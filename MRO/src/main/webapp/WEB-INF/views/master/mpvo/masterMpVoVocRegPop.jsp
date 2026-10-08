<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 등록 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	String st_type = CommonUtil.nvl((String) request.getParameter("st_type"), "PO");
	
	Map<String,String> _data = null;
	String st_buyer_code = "";
	String st_buyer_name = "";
	String st_buyer_item_no = "";
	String st_pr_user_name = "";
	String st_pr_user_id = "";
	String st_pr_user_tel = "";
	String st_po_no = "";
	String st_quotation_no_arr = "";//견적 VOC등록시 견적 정보
	String st_sg_mng_id = ""; //견적 처리자 ID
	
	if(st_type.equals("ITM")){
		st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"), _sessionInfo.getComCode());
		st_buyer_name =  CommonUtil.nvl((String) request.getParameter("st_buyer_name")); 
		st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"));
	}else if(st_type.equals("RE")){
		st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_voc_buyer"));
		st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_voc_buyer_name"));
		st_quotation_no_arr = CommonUtil.nvl((String) request.getParameter("st_quotation_no_arr"));
		st_sg_mng_id = CommonUtil.nvl((String) request.getParameter("st_sg_mng_id"),"");
	}else if(st_type.equals("PO")){
		st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"), _sessionInfo.getComCode());
		// 팝업과 함께 가져오는 데이터
		_data = (Map)request.getAttribute("data_po");
		st_buyer_name = _data.get("BUYER_NAME"); 
		st_buyer_item_no = _data.get("BUYER_ITEM_NO");
		st_pr_user_name = _data.get("PR_ADD_USER_NAME");;
		st_pr_user_id = _data.get("PR_ADD_USER_ID");
		st_pr_user_tel = _data.get("PR_ADD_USER_TEL");
		st_po_no = (String) request.getParameter("st_po_no");
	}
	
	String st_req_user_id = CommonUtil.nvl(_sessionInfo.getUserId());
	String st_req_user_name = CommonUtil.nvl(_sessionInfo.getUserNameLoc());
	String st_req_user_tel = CommonUtil.nvl(_sessionInfo.getTel());
	
	
	String user_id = _sessionInfo.getUserId();
	String user_dept = _sessionInfo.getDepartment();
	
	String st_ds_user_id = _sessionInfo.getUserId();
	
	String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
	String year             = check_date.substring(0,4);
	String month            = check_date.substring(4,6);
	String day              = check_date.substring(6,8);

	String check_time       = check_date.substring(8,12);
	String hour             = check_time.substring(0,2);
	String minutes          = check_time.substring(2,4);

	//VOC 시스템 구분 (KA:KOREAB2B, SA:건설MRO, WD:WELDING, KM:KEPMRO, KW:KWAY)
	String user_sys_type = "";
	if(user_dept.equals("006")){
		user_sys_type = "SA";
	}else if(user_dept.equals("019")){
		user_sys_type = "KW";
	}else if(user_dept.equals("020")){
		user_sys_type = "KM";
	}else{
		user_sys_type = "KA";
	}
		
%>


<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen" href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script>
var popupSel = "";
function popupOnload(){
	
	kepSetCalenderTime("st_ph_date", "st_atos_end_time");

	kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "", "<%=user_id%>");

	kepAjaxCommonCombo("st_claim_master", "VC03", "SEL");
	
	$("#st_claim_master").change(function(){
		//voc 유형 대분류
		kepAjaxCommonQueryIdSearchTwoCombo("st_claim_type", "commonTwoSearchList", "VC01", $(this).val(), "SEL", "" );
	})
	
	$("#st_claim_type").change(function(){
		var data = { st_type : $(this).val(), st_buyer_code : $("#st_buyer_code").val(), st_buyer_item_no : $("#st_buyer_item_no").val() };
		//voc 유형 소분류
		kepAjaxCallNoBar("/common/getVOCUser.do", data, "select");
	})
	//VOC 등록 타입
	var st_type = "<%=st_type%>";
	//견적 VOC 등록
	if(st_type == "RE"){
		var st_sg_mng_id = "<%=st_sg_mng_id%>"; //처리자 id
		var st_quotation_no_arr = "<%=st_quotation_no_arr%>";
		$("#st_req_remark").val(st_quotation_no_arr); //요청내용 저장
		if(st_sg_mng_id != ""){
			$("#st_ds_user_id").val(st_sg_mng_id).prop("selected", true);			
		}
		//VOC 대분류 셋팅
		$("#st_claim_master").val("ZR").prop("selected", true);
		//VOC 소분류 셋팅
		kepAjaxCommonQueryIdSearchTwoCombo("st_claim_type", "commonTwoSearchList", "VC01", "ZR", "SEL", "RA");
	}
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case  "save":
			if (checkSubmit()) {
 				kepAjaxFormCall("/mpvo/saveMasterMpVoVocReceiptList.do","contentForm","save");
			}
			break;
	}

}
function checkSubmit() {
    if(isEmpty($("#st_buyer_code").val())){
        alert("고객사를 선택해 주십시오. ");        
        return false;
    }
    if(isEmpty($("#st_req_user_name").val())){
        alert("고객사의 요청자를 선택해 주십시오.");        
        return false;
    }
    
    var req_user_name = $("#st_req_user_name").val();
    var req_user_id   = $("#st_req_user_id").val();

    if(req_user_name != "" && req_user_id == ""){
    	$("#st_req_user_id").val("999999");
    }
    
    var claim_master = $("#st_claim_master").val();
    if(claim_master==""){
        alert("VOC Type의 상위분류를 선택해 주십시오.");  
        $("#st_claim_master").focus();
        return false;
    }
    
    var claim_type = $("#st_claim_type").val();
    if(claim_type==""){
        alert("VOC Type의 하위분류를 선택해 주십시오.");
        $("#st_claim_type").focus();
        return false;
    }
    
    if(isEmpty($("#st_ph_date").val())){
       alert("처리 희망일을 선택하여 주십시오.");
       return false;
    }

    if(isEmpty($("#st_ds_user_id").val())){
        alert("처리담당자를 선택해 주십시오.");
        $("#st_ds_user_id").focus();
       return false;
    }

    if(isEmpty($("#st_req_remark").val())){
        alert("요청내역을 입력하여 주십시오.");
        $("#st_req_remark").focus();
       return false;
    }

    return confirm("기재하신 사항으로 접수하시겠습니까? ");
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod, response) {	
	if(pMethod == "save"){
		alert("VOC 등록 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
	}
	else if (pMethod == "select"){
		alert("오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");	
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod, response){
	var sMsg = response.msg;
	if (pMethod == "save") {
		if (sMsg == "OK") {
			alert("정상적으로 VOC가 등록 되었습니다.");
			parent.opener.doAction("search");
			this.close();
			return;
		} else {
			alert("VOC 등록 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
			parent.opener.doAction("search");
			this.close();
			return;
		}
	}
	else if (pMethod == "select"){
		if(response.USER_ID == "" ||response.USER_ID == " " || response.USER_ID == null ||response.USER_ID == "0"){ // 담당자가 없을 시 다시 자신의 id로
			st_ds_user_id = $("#st_cd_user_id").val();
		}else{
			st_ds_user_id = response.USER_ID;
		}
		// 담당자로 selectbox 선택된 값 변경
		$("#st_ds_user_id").val(st_ds_user_id).prop("selected", true);
	}
}
//주문요청자 변경
function changeVocReqUserInfo(){
	var st_req_user_id = "<%=st_req_user_id%>";
	var st_req_user_name = "<%=st_req_user_name%>";
	var st_req_user_tel = "<%=st_req_user_tel%>";
	var st_pr_user_id = "<%=st_pr_user_id%>";
	var st_pr_user_name = "<%=st_pr_user_name%>";
	var st_pr_user_tel = "<%=st_pr_user_tel%>";	
	if(document.getElementById("st_checkbox").checked == true){
		$("#st_req_user_id").val(st_pr_user_id);
		$("#st_req_user_name").val(st_pr_user_name);
		$("#st_req_user_tel").val(st_pr_user_tel);
		
		document.getElementById("po_change_alert").style.display = "block";
	}else{
		$("#st_req_user_id").val(st_req_user_id);
		$("#st_req_user_name").val(st_req_user_name);
		$("#st_req_user_tel").val(st_req_user_tel);
		
		document.getElementById("po_change_alert").style.display = "none";
	}
}
</script> 
</head>
<body onload="popupOnload(); ">
<form name = "contentForm"  id = "contentForm" method = "post" onsubmit="return false">
	<input type="hidden" id="st_cd_user_id" name="st_cd_user_id" value="<%=user_id%>">
	<input type="hidden" id="st_sys_type" name="st_sys_type" value="<%=user_sys_type%>">
	<input type="hidden" id="st_mro_area_text" name="st_mro_area_text" value="">
	<input type="hidden" id="st_st_mro_area_code" name="st_mro_area_code" value="">
	<input type="hidden" name="st_cd_dept" value="<%=user_dept%>">
	<div id="popWrapper" style="height:380px;">
    	<div id="popHeader">
        	<h1 class="title">VOC 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
				<h4><b>VOC 등록 </b></h4>
            	<table class="cont_t_list07" style="width:100%">
						<caption>VOC등록</caption>
						<colgroup>
							<col width="18%" />
							<col width="32%" />
							<col width="18%" />
							<col width="32%" />
						</colgroup>
						<tbody>
						<tr>
							<th scope="row">고객사</th>
							<td class="left" >
								<input type="text" style="width:90%; border:0px;" id = "st_buyer_name" value="<%=st_buyer_name%>" readonly />
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=st_buyer_code%>" />
							</td>
							<th scope="row">요청자</th>
							<td class="left" >
								<input type="text" class="input_type_text" name="st_req_user_name" id="st_req_user_name" style="width:100px; border:0px;" value ="<%=st_req_user_name%>" readonly />
								<input type="hidden" name="st_req_user_id" id="st_req_user_id" value ="<%=st_req_user_id%>" />
								<% if(st_type.equals("PO")){ %>
								&emsp;<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" onclick="changeVocReqUserInfo()">&nbsp;주문요청자 변경
								<%} %>
							</td>
						</tr>
						<tr>
							<th scope="row">VOC 유형</th>
							<td>
								<select id="st_claim_master" name="st_claim_master">
									<option value="" >선택</option>
								</select>
								<select id="st_claim_type" name="st_claim_type">
									<option value="" >선택</option>
								</select>
							</td>
							<th scope="row">요청자 전화번호</th>
							<td class="left">
								<input type="text" class="input_type_text" name="st_req_user_tel" id="st_req_user_tel" value ="<%=st_req_user_tel%>" style="width:100px; border:0px;" readonly/>
							</td>
						</tr>
	                  	<tr>
							<th scope="row">발주번호</th>
							<td>
								<input type="text" id="st_po_no" name="st_po_no" class="input_type_text" title="발주코드" value="<%=st_po_no%>" maxlength="20" style="width:80%; border:0px;" readonly/>
							</td>
							<th scope="row">품목코드</th>
							<td>
								<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" class="input_type_text" value="<%=st_buyer_item_no%>" title="품목코드" maxlength="20" style="width:80%; border:0px;" readonly />
							</td>
						</tr>
						<tr>
							<th scope="row">처리희망일</th>
							<td>
								<input type="text" class="input_type_text" name="st_ph_date" id="st_ph_date" readOnly style="width:100px; text-align:center;" value="">
								<select id="st_atos_end_time" name="st_atos_end_time">
									<option value="090000">09:00</option>
									<option value="100000">10:00</option>
									<option value="110000">11:00</option>
									<option value="120000">12:00</option>
									<option value="130000">13:00</option>
									<option value="140000">14:00</option>
									<option value="150000">15:00</option>
									<option value="160000">16:00</option>
									<option value="170000">17:00</option>
								</select>
							</td>
							<th scope="row">처리담당자</th>
							<td>
								<select id="st_ds_user_id" name="st_ds_user_id"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">접수일자</th>
							<td colspan="3"><%=year%>년 <%=month%>월 <%=day%>일 <%=hour%>시 <%=minutes%>분</td>
						</tr>
						<tr>
							<th scope="row">요청내역</th>
							<td colspan="3" style="height:100px;"><textarea rows="6" cols="70" id="st_req_remark" name="st_req_remark" style="text-align:left; width:98%; ime-mode:active;"></textarea></td>
						</tr>
					</tbody>
				</table>	
		
            <!--grid-->
			<span class="fl">
			<% if(st_type.equals("PO")){ %>
				※ VOC 요청자는 기본 로그인한 사용자 설정이며, 구매요청자 변경시 요청자 변경 후 저장 바랍니다.
				<div id="po_change_alert" style="display:none">
					<font color="red"><b>※ 모든 처리 내역은 고객사로 전달되므로 작성 시 유의 바랍니다.</b></font>
				</div>
			<%} %>  
			</span>
			<span class="fr">
			<% if(  !("Y".equals(CommonUtil.nvl((String) request.getParameter("st_req_flag"),"")  )  )) {%>
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
			<%} %>	
			</span>
			<br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>