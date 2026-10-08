<%--
**********************************************
* 메뉴 : VOC 등록>
* 화면 : VOC 등록
* 기능 : VOC 등록 화면
* 프로그램 ID : PG_90_C_800_02
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-11
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String user_dept = CommonUtil.nvl((String) request.getParameter("st_user_dept"),_sessionInfo.getDepartment());

String check_date       = DateTimeUtil.getFormatString("yyyyMMddHHmm");
String year             = check_date.substring(0,4);
String month            = check_date.substring(4,6);
String day              = check_date.substring(6,8);

String check_time       = check_date.substring(8,12);
String hour             = check_time.substring(0,2);
String minutes          = check_time.substring(2,4);

String st_ds_user_id = _sessionInfo.getUserId();

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

<script src="/resources/js/common.js"></script>
<script type="text/javascript">
// <!--
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	// 조회조건 초기화
	kepSetCalenderTime("st_ph_date","st_atos_end_time");
	
	// 처리 담당자
	kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "", "<%=user_id%>");
	
	// 콤보 생성 ( VOC Master )
	kepAjaxCommonCombo("st_claim_master","VC03","SEL");
	
	// VOC Type 선택 시 이벤트 발생
	$("#st_claim_master").change(function(){
		if(checkType()){
			// 콤보 생성 ( VOC Type )
			kepAjaxCommonQueryIdSearchTwoCombo("st_claim_type","commonTwoSearchList", "VC01", $(this).val(), "SEL", "");
		}else{
			$("#st_claim_master").val("");
			$("#st_claim_type").val("");
		}
	});
	
	// VOC 소분류 선택시 담당자 변경
	$("#st_claim_type").change(function(){
		var data = { st_type : $(this).val(), st_buyer_code : $("#st_buyer_code").val(), st_buyer_item_no : $("#st_buyer_item_no").val() };
		//voc 유형 소분류
		kepAjaxCallNoBar("/common/getVOCUser.do", data, "select");
	})
}

//기능함수
function doAction(str) {
	switch (str) {
		case "reload":	// 초기화
			kepReload("contentForm");
			break;
		case "save": // 저장
			if (checkSubmit()) {
				kepAjaxFormCall("/mpvo/saveMasterMpVoVocReceiptList.do","contentForm","save");
			}
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	var st_ds_user_id = "";
	
	if (pMethod == "save") {
		if (sMsg == "OK") {
			alert("정상적으로 VOC가 등록 되었습니다.");
			doAction("reload");
			return;
		} else {
			alert("VOC 등록 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
			return;
		}
	}	else if (pMethod == "select"){
		if(response.USER_ID != '0'){
			st_ds_user_id = response.USER_ID;
		}else{ // 담당자가 없을 시 다시 자신의 id로
			st_ds_user_id = $("#st_user_id").val();
		}
		// 담당자로 selectbox 선택된 값 변경
		$("#st_ds_user_id").val(st_ds_user_id).prop("selected", true);
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	if(pMethod == "save"){
		alert("VOC 등록 처리하던중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
	}	
	else if (pMethod == "select"){
		alert("오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");	
	}
	
} 

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop": // 고객사, 협력사 팝업
			popupSel = "masterCmCoBuyerAgntcmpyPop";
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=B&st_sys_type=KA&st_sys_change_flag=N", "500,500,no");
			break;
			
		case "masterMpVoVocUserSearchPop": // 요청자 선택
			if(isEmpty($("#st_buyer_code").val())){
				alert("고객사를 먼저 선택해 주시기 바랍니다.");
				return;
			}
			popupSel = "masterMpVoVocUserSearchPop";
			var st_sys_type = $("#st_sys_type").val();
			var st_buyer_code = $("#st_buyer_code").val();			
			openSearchPopup("/mpvo/getMasterMpVoVocUserSearchPop.do", "?com_type=B&buyer=" + st_buyer_code + "&st_sys_type=" + st_sys_type, "500,500,no");
			break;
			
		case "masterMpVoVocDeptSearchPop": // 건설사현장 선택 팝업
			popupSel = "masterMpVoVocDeptSearchPop";
			openSearchPopup("/mpvo/getMasterMpVoVocDeptSearchPop.do", "?com_code=", "500,500,no");
			break;
			
		case "fileUpload": //파일업로드
			if(isEmpty($("#st_buyer_code").val())){
				alert("고객사를 먼저 선택해 주시기 바랍니다.");
				return;
			}
		
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=VOC", "500,430,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmCoBuyerAgntcmpyPop") {	// 고객사, 협력사 팝업
		// value1			, value2		, value3			, value4		, value5				, value6
		// db_com_code	, com_code	, com_name	, com_info	, com_sys_type	, com_type
		// 회원사   선택 전 정보
		var pre_com_code = "";
		var pre_sys_type = $("#st_sys_type").val();
		pre_com_code	= $("#st_buyer_code").val();
		
		$("#st_buyer_code").val(value2);
		$("#st_buyer_name").val(value3);
		$("#st_com_type_db").val(value4);
		$("#st_sys_type").val(value5);
		
		// 회원사가 변경된 경우 요청자 아이디, 건설현장정보 초기화
		if(pre_com_code != value2 || pre_sys_type != value5){
			$("#st_req_user_id").val("");
			$("#st_req_user_name").val("");
			$("#st_req_user_name2").val("");
			$("#st_req_user_tel").val("");
			$("#st_mro_area_code").val("");
			$("#st_mro_area_text").val("");
		}
	}else 	if (popupSel == "masterMpVoVocUserSearchPop") {	// 요청자 선택
		// value1		, value2	, value3			, value4			, value5		, value6			, value7
		// db_user_id	, user_id	, user_name	, user_phone	, user_dept	, user_sys_type	, com_code
		$("#st_req_user_id").val(value2);
		$("#st_req_user_name").val(value3);
		$("#st_req_user_name2").val(value3);
		$("#st_req_user_tel").val(value4);
	}else 	if (popupSel == "masterMpVoVocDeptSearchPop") {	// 건설사현장 선택 팝업
		// value1		, value2		, value3	, value4
		// buyer_code	, buyer_text	, dept		, dept_name
		var pre_buyer_code	= $("#st_buyer_code").val();
		var pre_sys_type	= $("#st_sys_type").val();
		
		$("#st_mro_area_text").val(value4);
		$("#st_mro_area_code").val(value3);
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_sys_type").val("SA");
		$("#st_com_type_db").val("PB");

		if(pre_buyer_code != buyer_code || pre_sys_type !="SA"){
			$("#st_req_user_id").val("");
			$("#st_req_user_name").val("");
			$("#st_req_user_name2").val("");
			$("#st_req_user_tel").val("");
		}
	}else if (popupSel == "fileUpload") {
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";

		if(value1 != ''){
			document.forms.contentForm.st_image_key.value = value1;
			document.forms.contentForm.Image2.src = diskOn;
	    }else{
			document.forms.contentForm.st_image_key.value = "";
			document.forms.contentForm.Image2.src = diskOff;
	    }
	}
}

function kepEraser(eraserObj){
	if(eraserObj != null && eraserObj.length > 0){
		for(var inx = 0 ; inx < eraserObj.length ; inx++){
			$("#"+eraserObj[inx]).val("");
		}
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
    var req_user_bak  = $("#st_req_user_name2").val();
    var req_user_id   = $("#st_req_user_id").val();
    
    if(req_user_bak != req_user_name){
    	$("#st_req_user_id").val("999999");
    }
    
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
       alert("처리 희망일을 선택하여 주십시요.");
       return false;
    }

    if(isEmpty($("#st_ds_user_id").val())){
        alert("처리담당자를 선택해 주십시요.");
        $("#st_ds_user_id").focus();
       return false;
    }

	var com_type_db = $("#st_com_type_db").val();
    if(com_type_db == "PB" && isEmpty($("#st_mro_area_code").val())){
        alert("건설사현장을 선택해 주십시요.");
        $("#st_mro_area_text").focus();
       return false;
    }

    if(isEmpty($("#st_req_remark").val())){
        alert("요청내역을 입력하여 주십시요.");
        $("#st_req_remark").focus();
       return false;
    }

    return confirm("기재하신 사항으로 접수하시겠습니까? ");
}

function checkType() {
    
    if(isEmpty($("#st_buyer_code").val())){
        alert("고객사를 선택해 주십시오. ");        
        return false;
    }
    
//     if(isEmpty($("#st_po_no").val())){
//         alert("발주코드를 입력하여 주십시오.");
//         $("#st_po_no").focus();
//        return false;
//     }

//     if(isEmpty($("#st_buyer_item_no").val())){
//         alert("품목코드를 입력하여 주십시오.");
//         $("#st_buyer_item_no").focus();
//        return false;
//     }    
    
	return true;
}

function kepReload(){
	$("#st_req_user_name2").val("");
	$("#st_com_type_db").val("");
	$("#st_buyer_name").val("");
	$("#st_buyer_code").val("");
	$("#st_req_user_name").val("");
	$("#st_req_user_id").val("");
	$("#st_claim_master").val("");
	$("#st_claim_type").val("");
	$("#st_req_user_tel").val("");
	$("#st_po_no").val("");
	$("#st_buyer_item_no").val("");
	$("#st_ph_date").val("");
	$("#st_atos_end_time").val("");
	$("#st_mro_area_text").val("");
	$("#st_mro_area_code").val("");
	$("#st_req_remark").val("");
}

//-->
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>VOC 등록</h3>
   		</div>        	
        <!--조회영역-->
       	<form id="contentForm" name="contentForm" method = "post">
       		<!-- HIDDEN -->
			<input type="hidden" id="st_user_id" name="st_user_id"			value="<%=user_id%>">
			<input type="hidden" id="st_user_dept" name="st_user_dept"		value="<%=user_dept%>">
			<input type="hidden" id="st_sys_type" name="st_sys_type"			value="<%=user_sys_type%>">
			<input type="hidden" id="st_com_type_db" name="st_com_type_db"		value="">
			<!-- HIDDEN -->
       		
			<div>
            	<table class="cont_t_list06" style="width:100%;">
					<caption>VOC 등록</caption>
					<colgroup>
						<col width="120px" />
						<col width="32%" />
						<col width="120px" />
						<col width="32%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">고객사</th>
							<td class="left" >
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%;" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop');"/>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" />
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser(['st_buyer_code','st_buyer_name']);"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th scope="row">요청자</th>
							<td class="left" >
								<input type="text" class="input_type_text" name="st_req_user_name" id="st_req_user_name" style="width:71%" readonly onclick="javascript:doPop('masterMpVoVocUserSearchPop');" />
								<input type="hidden" name="st_req_user_id" id="st_req_user_id" />
								<a href="javascript:doPop('masterMpVoVocUserSearchPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser(['st_req_user_name','st_req_user_id']);"><img src="/resources/images/btn_eraser2.gif"></a>&nbsp;&nbsp;
							</td>
						</tr>
						<tr>
							<th scope="row">VOC 유형 / 첨부파일</th>
							<td>
								<select id="st_claim_master" name="st_claim_master">
									<option value="" >선택</option>
								</select>
								<select id="st_claim_type" name="st_claim_type">
									<option value="" >선택</option>
								</select>
								
								&nbsp; / &nbsp;
								
								<input type="hidden" id="st_image_key" name="st_image_key" value="" />
								<a href="javascript:doPop('fileUpload');"><img src="/resources/images/disk_off.gif" id="Image2" name="Image2" border="0" style="vertical-align: text-bottom;"></a>
							</td>
							<th scope="row">요청자 전화번호</th>
							<td class="left" >
								<input type="text" class="input_type_text" name="st_req_user_tel" id="st_req_user_tel" style="width:100px" />
							</td>
						</tr>
	                  	<tr>
							<th scope="row">발주번호</th>
							<td>
								<input type="text" id="st_po_no" name="st_po_no" class="input_type_text" title="발주코드" maxlength="20" style="width:80%; ime-mode:disabled;" onkeyup="kepToUpper('st_po_no')" />
							</td>
							<th scope="row">품목코드</th>
							<td>
								<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" class="input_type_text" title="품목코드" maxlength="20" style="width:80%; ime-mode:disabled;" onkeyup="kepToUpper('st_buyer_item_no')" />
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
							<td><%=year %>년 <%=month %>월 <%=day %>일 <%=hour %>시 <%=minutes %>분</td>
							<th scope="row">건설사현장</th>
							<td>
								<input type="text" class="input_type_text" name="st_mro_area_text" id="st_mro_area_text" style="width:71%;" readonly onclick="javascript:doPop('masterMpVoVocDeptSearchPop');"/>
								<input type="hidden" name="st_mro_area_code" id="st_mro_area_code" />
								<input type="hidden" name="st_cd_user_id" value="<%=user_id%>">
								<input type="hidden" name="st_cd_dept" value="<%=user_dept%>">
								<input type="hidden" name="st_ds_dept" value="<%=user_dept%>">
								<a href="javascript:doPop('masterMpVoVocDeptSearchPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser(['st_mro_area_text','st_mro_area_code']);"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th scope="row">요청내역</th>
							<td colspan="3" style="height:110px;"><textarea rows="7" cols="70" id="st_req_remark" name="st_req_remark" style="text-align:left; width:99%; ime-mode:active;"></textarea></td>
						</tr>
					</tbody>
				</table>	
            </div>
		</form>
<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span>※ VOC 상세유형 선택 전 품목코드 입력해야 처리 담당자가 자동지정 됩니다.</span>
			</span>
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
			</span>
		</div>
<!--내용 종료-->	                 
</body>
</html>
