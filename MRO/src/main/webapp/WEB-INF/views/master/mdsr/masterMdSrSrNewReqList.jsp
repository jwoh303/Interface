<%--
**********************************************
* 메뉴 : S/R 요청부서>S/R 신규요청
* 화면 : S/R 신규요청
* 기능 : 
* 프로그램 ID : PG_90_C_700_02
* 담당자 :  홍석규( 설계 : 공통 )
* 착수일 : 2014-08-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String user_id = _sessionInfo.getUserId();
String user_dept = _sessionInfo.getDepartment();
String com_code = _sessionInfo.getComCode();

String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
String year             = check_date.substring(0,4);
String month            = check_date.substring(4,6);
String day              = check_date.substring(6,8);

String check_time       = check_date.substring(8,12);
String hour             = check_time.substring(0,2);
String minutes          = check_time.substring(2,4);
String st_req_type = CommonUtil.nvl((String) request.getParameter("st_req_type"),"");
String st_subject = CommonUtil.nvl((String) request.getParameter("st_subject"),"");
String st_sys_type = CommonUtil.nvl((String) request.getParameter("st_sys_type"),"");

%>

<script src="/resources/js/common.js"></script>
<script type="text/javascript">
// <!--
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var st_req_type = "<%=st_req_type%>";
	var st_subject =  "<%=st_subject%>";
	var st_sys_type =  "<%=st_sys_type%>";
	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_sys_type','getSrsysTypeList','SR01','4','',st_sys_type);
	kepAjaxCommonQueryIdSearchTwoCombo('st_req_type','getSrsysTypeList','SR02','4','',st_req_type);
	if(st_req_type == "IP" && st_sys_type == "SA"){
		kepAjaxCommonQueryIdSearchTwoCombo('st_req_sr_type','getSrsysTypeList','SR07','4','','');
	}else 	if(st_req_type == "IP" && (st_sys_type == "KW" || st_sys_type == "IT")){
		kepAjaxCommonQueryIdSearchTwoCombo('st_req_sr_type','getSrsysTypeList','SR08','4','','');
	}else{
		kepAjaxCommonQueryIdSearchTwoCombo('st_req_sr_type','getSrsysTypeList','SR05','4','','');
	}

	// 조회조건 초기화
	kepSetCalenderTime("st_ph_date","st_atos_end_time");
	kepSetCalender("st_ph_date");
	if(st_req_type  =="DL"){
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		//콤보데이터 셋팅
		kepAjaxCommonQueryIdSearchTwoCombo('st_req_data_type','getSrsysTypeList','SR06','4','','');
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	}
	
}

function doReload(){
	kepReload("contentForm");
	
	$("#st_req_remark").val("");
	$("#st_image_key").val("");
	$("#st_image_key_text").val("");
	$("#st_ph_date").val("");
	$("#SR_NO").val("");
	$("#RECV_FLAG").val("");
}

//기능함수
function doAction(str) {
	switch (str) {
		case "reload":	// 초기화
			doReload();
			
			break;
		case "save": // 저장
			if (checkSubmit(str)) {
				$("#RECV_FLAG").val("GA");
				kepAjaxFormCall("/mdsr/saveMasterMdSrSrNewReqList.do","contentForm","save");
			}
			break;
			
		case "approval": // 품의상신
			if (checkSubmit(str)) {
				$("#RECV_FLAG").val("GP");
				kepAjaxFormCall("/mdsr/getSrNoMasterMdSrSrNewReqList.do","contentForm","getSrNo");
			}
			break;	
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg.msg;
	
	if (pMethod == "save") { //요청
		if (sMsg == "OK") {
			alert("정상적으로 S/R 신규요청 작성되었습니다.");
			doAction("reload");
			return;
		} else {
			alert("S/R 요청 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
			return;
		}
	}else if (pMethod == "getSrNo") { //품의상신DOCU_NO 채번
		if (sMsg == "OK") {
			var type = "";
		    if($("#st_req_type").val() == "DL"){
		    	 type = "DL";//품의구분
		    }else{
		    	 type = "SR";//품의구분	
		    }
			var com_code	= $("#st_com_code").val();
			var sr_no = response.msg.usrmsg;
			$("#SR_NO").val(sr_no);
			//결재
			var req_remark = $("#st_req_remark").val();
 			var req_remark2 = req_remark.replace(/\n/gi,"<br>"); 
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+com_code+'&PARAM2='+$("#st_user_id").val()+'&st_title='+$("#st_subject").val()+'&st_cont='+req_remark2, "1000,500,no");
			return;
		} else {
			alert("S/R 요청 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
			return;
		}
	}else if (pMethod == "approvalReturn") { //품의상신시 S/R요청 저장
		if (sMsg == "OK") {
			alert("정상적으로 S/R 신규요청 작성되었습니다.");
			kepSearch();
			return;
		} else {
			alert("S/R 요청 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("S/R 요청 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
} 

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case 	"fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=SR", "500,430,no");
			break;
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "fileUpload") {
		$("#st_image_key").val(code);
		$("#st_image_key_text").val(text);
	}else if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	}
}

function checkSubmit(str) {
    
	if(isEmpty($("#st_subject").val()))
    {
       alert("제목을 입력하여 주십시요.");
       $("#st_subject").focus();
       return false;
    }
	
    if(isEmpty($("#st_req_remark").val()))
    {
       alert("요청내역을 입력하여 주십시요.");
       $("#st_req_remark").focus();
       return false;
    }
    
    if(isEmpty($("#st_ph_date").val()))
    {
    	alert("처리 희망일을 선택하여 주십시요.");
       return false;
    }
	
    var msg;
    if(str == "approval"){
    	msg = "S/R 신규요청 품의상신하시겠습니까? ";
    }else{
    	msg = "S/R 신규요청 작성하시겠습니까? ";
    }
    
    if($("#st_req_type").val() == "DL"){
	    if(isEmpty($("#st_buyer_code").val())){
	    	alert("고객사를 입력하여 주십시요.");
	       return false;
	    }
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.");
			return false;
		}
		if($("#st_sys_type").val() != "KA"){
			alert("실적 데이터 다운로드는 KOREAB2B만 가능 합니다.");
			return;
		}
	}
    return confirm(msg);
}


//textarea 백그라운드 
function clrImg(obj){
	$("#st_req_remark").val("");
	obj.onkeydown=obj.onmousedown=null;
}

function kepApprovalReturn(flag,docu_no){
	//결재상신시에 저장
	kepAjaxFormCall("/mdsr/saveMasterMdSrSrNewReqList.do","contentForm","approvalReturn");
}
//조회
function kepSearch(){
		$('#contentForm').attr("action", "/mdsr/showMasterMdSrSrNewReq.do").submit();
}
//-->
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>S/R 신규요청</h3>
   		</div>        	
        <!--조회영역-->
       	<form id="contentForm" name="contentForm" method = "post">
       		<!-- HIDDEN -->
			<input type="hidden" id="st_user_id" name="st_user_id"			value="<%=user_id%>">
			<input type="hidden" id="st_user_dept" name="st_user_dept"		value="<%=user_dept%>">
			<input type="hidden" id="st_com_code" name="st_com_code"		value="<%=com_code%>">
			<input type="hidden" id="SR_NO" name="SR_NO">
			<input type="hidden" id="RECV_FLAG" name="RECV_FLAG">
			
			<!-- HIDDEN -->
			<div>
            	<table class="cont_t_list06" style="width:100%;">
					<caption>S/R 신규요청</caption>
					<colgroup>
						<col width="120px" />
						<col width="32%" />
						<col width="120px" />
						<col width="32%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">요청자</th>
							<td class="left" >
								&nbsp;&nbsp;<%=_sessionInfo.getDepartmentName()%> <%=_sessionInfo.getUserNameLoc()%>
							</td>
							<th scope="row">요청일</th>
							<td class="left" >
								&nbsp;&nbsp;<%=year%>년 <%=month%>월 <%=day%>일 <%=hour%>시 <%=minutes%>분
							</td>
						</tr>
						<tr>
							<th scope="row">시스템구분</th>
							<td colspan="3">
								<select id="st_sys_type" name="st_sys_type"  onchange="javascript:kepSearch();"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">요청영역</th>
							<td class="left" >
								<select id="st_req_type" name="st_req_type" onchange="javascript:kepSearch();"></select>
							</td>
							<th scope="row">요청내역분류</th>
							<td class="left" >
								<select id="st_req_sr_type" name="st_req_sr_type"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td  colspan="3">
								<input type="text" id="st_subject"  name="st_subject"  class="input_type_text" style="width:90%;ime-mode:active" maxlength="100">
							</td>
						</tr>

<%if(st_req_type.equals("DL")){ %>
						<tr>
							<th scope="row"><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:170px;" value = "" READONLY>
	                       		<input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
	                       		<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
	                       		<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th scope="row">데이터요청 타입</th>
							<td class="left" >
								<select id="st_req_data_type" name="st_req_data_type"></select>
							</td>
						</tr>
						<tr>
							<th scope="row">조회기간</th>
							<td class="left"   colspan="3">
									<input type="text" class="input_type_text" id="st_from_date" name="st_from_date" readOnly style="width:80px; text-align:center;" value=""> - 
									<input type="text" class="input_type_text" id="st_to_date" name="st_to_date" readOnly style="width:80px; text-align:center;" value="">
							</td>
						</tr>
<%} %>					
						<tr>
							<th scope="row">요청내역</th>
							<td colspan="3" >
<%if(!st_req_type.equals("DL")){ %>
								<input type="hidden" id="st_buyer_code" name="st_buyer_code" value="">
								<input type="hidden" id="st_from_date" name="st_from_date" value="">
								<input type="hidden" id="st_to_date" name="st_to_date" value="">
								<input type="hidden" id="st_req_data_type" name="st_req_data_type" value="">
								
<%}%>
								<textarea name="st_req_remark" rows=17 style="padding:3px;width:90%;ime-mode:active" id="st_req_remark" onkeydown="clrImg(this)" onmousedown="clrImg(this)" >
* 카탈로그,발주,실적자료 요청 카탈로그 매입,매출단가변경시 반드시 각 팀장의 결재가 필요합니다.
* 그외 요청건의 결재자 선택은 요청영역의 상황에 따라 요청자가 판단하셔야 합니다.
* S/R처리순서는 요청순서에 따라 진행됩니다. 업무에 참고 하시기 바랍니다.
* 수주런칭/재계약의 카탈로그 벌크 등록 S/R요청 시 원품의서 승인파일 첨부 및 정보시스템실장 참조 必
								</textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">첨부파일</th>
							<td colspan="3" >
								<input type="hidden" id="st_image_key" name="st_image_key" value="" />
								<input type="hidden" id="st_image_key_Text" 	name="st_image_key_Text" class="input_type_text" title="" style="width: 250px;" value="" />
								<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileUpload')">첨부등록</a></span>
							</td>
						</tr>
						<tr>
							<th scope="row">처리희망일</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_ph_date" id="st_ph_date" readOnly style="width:100px; text-align:center;" value="" >
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
						</tr>
					</tbody>
				</table>	
            </div>
		</form>
<!--버튼영역-->
		<div class="btnArea">
			<span class="fl" >
				* 카탈로그,발주,실적자료 견적회신일변경 요청시 반드시 각 팀장님의 결재가 필요합니다.<br>
				* 그외 요청건의 결재자 선택은 요청영역의 상황에 따라 요청자가 판단하셔야 합니다. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</span>
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('approval');">품의상신</a></span>
<%if(!st_req_type.equals("DL")){ %>
				<span class="btn_02"><a href="javascript:doAction('save');">요청</a></span>
<%} %>
			</span>
		</div>
		<div class="btnArea">
			<span class="fl">
				
			</span>
		</div>
		
<!--내용 종료-->	                 
</body>
</html>
