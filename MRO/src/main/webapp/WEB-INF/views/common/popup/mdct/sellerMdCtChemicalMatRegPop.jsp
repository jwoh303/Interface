<%--
**********************************************
* 메뉴 : 
* 화면 :물질정보 등록
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;
	String businessCond = "";
	String cmcHarmfulYn = "N";
	String reqNo = "";
	String st_edit_yn = "Y";
	String st_cmc_yn = "N";//화학물질 담당자 여부
	
	// 견적정보가 있는 경우 활용
	String st_buyer = "";
	String st_quotation_no = "";
	String st_quotation_seq = "";
	String st_revision = "";
	
	// 보관조건, 보관온도 입력 필수 대상 고객사
	String p070000033 = "";
	
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		cmcHarmfulYn = CommonUtil.nvl(_rowData.get("CMC_HARMFUL_YN"));
		st_cmc_yn = CommonUtil.nvl(_rowData.get("CMC_USR_YN"),"N");
		
		// 견적정보가 있는 경우 활용
		st_buyer = CommonUtil.nvl(_rowData.get("BUYER"),"");
		st_quotation_no = CommonUtil.nvl(_rowData.get("QUOTATION_NO"),"");
		st_quotation_seq = CommonUtil.nvl(_rowData.get("QUOTATION_SEQ"),"");
		st_revision = CommonUtil.nvl(_rowData.get("REVISION"),"");
		
		// 보관조건, 보관온도 입력 필수 대상 고객사
		Map<String, String> p070000033_map = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P07-0000033");
		if (p070000033_map != null){
	    	p070000033= CommonUtil.nvl(p070000033_map.get("COL01_DATA"),""); // 유형별 값
	    }
	}
	//st_type: sInput:협력사 입력, sSearh:협력사 조회, mInput:KeP입력
	String st_type = CommonUtil.nvl((String) request.getParameter("st_type"), "");
	String st_req_status = CommonUtil.nvl((String) request.getParameter("st_req_status"), "");
	if(st_type.equals("mInput")){//운영사 입력
		if(st_cmc_yn.equals("Y")){//물질정보 담당자
			if(st_req_status.equals("C")||st_req_status.equals("T")||st_req_status.equals("N")){
				st_edit_yn = "N";	
			}			
		}else{//사업팀일경우
			if(st_req_status.equals("C")||st_req_status.equals("T")||st_req_status.equals("N")||st_req_status.equals("M")){
				st_edit_yn = "N";	
			}			
		}
	}else if(st_type.equals("sInput")||st_type.equals("sSearch")){////협력사 수정불가 case
		if(st_req_status.equals("Q")||st_req_status.equals("R")){
			st_edit_yn = "Y";	
		}else{
			st_edit_yn = "N";	
		}
	}
	if (_sessionInfo != null){ 	
		businessCond =  CommonUtil.nvl((String)_sessionInfo.getBusinessCond());  		
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var cm07 = KepSheetComboData("CM07","SPACE");
var comboOpenFlag = {ComboCode: cm07.ComboCode, ComboText:cm07.ComboText}; //공개여부 combo list
var cm08 = KepSheetComboData("CM08","SPACE");
var comboCompent = {ComboCode: cm08.ComboCode, ComboText:cm08.ComboText}; //성분유형 combo list
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
						 {Align:"Center",	SaveName:"sStatus",			Header:"상태|상태",			Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Sort:0,BackColor:"${optColor}",Hidden:true}
						 	,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"|",BackColor:"${notnullColor}",	SaveName:"SELECTED"}
							,{ Align:"Left",	SaveName:"OPEN_FLAG",		Header:"공개여부|공개여부",		Type:"Combo",				Width:50,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${notnullColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CAS_NO",		Header:"성분(CAS-NO)|성분(CAS-NO)",		Type:"Text",				Width:90,	Edit:true,		Sort:1,BackColor:"${notnullColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"COMPONENT_TYPE_CODE",		Header:"성분유형|성분유형",		Type:"Combo",				Width:60,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${notnullColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"MIN_MAKE_RATE",		Header:"함량(%)|최소값",	Type : "Float",	 Format:"${priceFormat}",	Width:60,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${notnullColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"MAX_MAKE_RATE",		Header:"함량(%)|최대값",	Type : "Float",	 Format:"${priceFormat}",	Width:60,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${notnullColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"AVG_MAKE_RATE",		Header:"함량(%)|평균값",	Type : "Float",	 Format:"${priceFormat}",	Width:60,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${notnullColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CML_HARMFUL_YN",		Header:"화관법|유독물질",		Type:"DummyCheck", HeaderCheck:0,	Width:80,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${optColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CML_PRE_TROUBLE_YN",		Header:"화관법|사고대비물질",		Type:"DummyCheck", HeaderCheck:0,	Width:80,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${optColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CML_BAN_OBJECT_YN",		Header:"화관법|금지물질",		Type:"DummyCheck", HeaderCheck:0,	Width:80,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${optColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CML_LIMIT_OBJECT_YN",		Header:"화관법|제한물질",		Type:"DummyCheck", HeaderCheck:0,	Width:80,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,	BackColor:"${optColor}",Hidden:false}

	];
	//InitHeaders의 두번째 인자
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	initsheet.HeaderMode = {ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	IBS_InitSheet(mySheet, initsheet,pagingMode, '');	
	mySheet.SetColProperty("OPEN_FLAG", comboOpenFlag);
	mySheet.SetColProperty("COMPONENT_TYPE_CODE", comboCompent);
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getSellerMdCtChemicalMatRegPop.do" , pagingMode );
	var cmcHarmfulYn = "<%=cmcHarmfulYn%>";
	harmfulSet(cmcHarmfulYn);

}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	
	// 그리드를 사용하지 않을거라 액션 위해 강제로 1줄 추가 및 선택
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	if(selectedGrid.length == 0) {
		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, 'SELECTED', "1");			
	}
	switch (str) {
		case "send": //협력사 물질정보 제출
			if ( !checkSend())return;
			//MSDS 체크
			if (isEmpty($("#st_msds_no").val()) && isEmpty($("#st_msds_file_key").val())) {
				alert("MSDS정보 입력 바랍니다.");
				$("#st_msds_no").focus();
				return;
			}
			if($("#infoOptiAgree").is(":checked") != true){
				alert("협력업체 제출 확인사항을 확인 바랍니다.");
				$("#infoOptiAgree").focus();
				return;				
			}
			
<%if(CommonUtil.nvl(_rowData.get("SG118_YN")).equals("Y")){%>
	<%if(!"".equals(p070000033) && "".equals(st_quotation_no)){%>
			if(isEmpty($("#st_temp_cond").val())){
				alert("보관조건을 입력하여 주세요.");
				$("#st_temp_cond").focus();
				return;
			}
			
			if(isEmpty($("#st_temp_range").val())){
				alert("보관온도를 입력하여 주세요.");
				$("#st_temp_range").focus();
				return;
			}
	<%}%>
<%}%>

			if(confirm("물질정보 제출 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdct/saveSellerMdCtChemicalMatSendList.do" , "SELECTED");
			}
			break;
			
		case "return": //협력사 물질정보 오분류
<%if(CommonUtil.nvl(_rowData.get("SG118_YN")).equals("Y")){%>
	<%if(!"".equals(p070000033) && "".equals(st_quotation_no)){%>
			if(isEmpty($("#st_temp_cond").val())){
				alert("보관조건을 입력하여 주세요.");
				$("#st_temp_cond").focus();
				return;
			}
			
			if(isEmpty($("#st_temp_range").val())){
				alert("보관온도를 입력하여 주세요.");
				$("#st_temp_range").focus();
				return;
			}
	<%}%>
<%}%>		
			if($('input:radio[name="rdo_agent_note"]').is(":checked") != true){
				alert("협력사 Comment 내에서 선택 바랍니다.");
				return;
			}else{
				if ($("#rdo_agent_note3").is(":checked") == true && isEmpty($("#st_agent_note").val())) {
					alert("협력사 Comment 입력 바랍니다.");
					$("#st_agent_note").focus();
					return;		
				}
			}
		
			if($("#rdo_agent_note1").is(":checked") == true){
				$("#rdo_agent_note_value").val("안전확인대상 생활화학제품");
			}else if($("#rdo_agent_note2").is(":checked") == true){
				$("#rdo_agent_note_value").val("제품 내 화학물질 미분류");
			}else if($("#rdo_agent_note3").is(":checked") == true){
				$("#rdo_agent_note_value").val($("#st_agent_note").val());
			}
			
			alert("MSDS 제출 대상 제품임에도 불구하고 MSDS가 공유되지 않을 경우,\n산업안전보건법 제175조 9항에 의거하여 5,000만원 이하의 과태료가 부가될 수 있습니다.");

			if(confirm("물질정보 오분류 처리 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdct/returnSellerMdCtChemicalMatSendList.do" , "SELECTED");
			}
			break;
			
		case "mReturn": //사업팀 물질정보 오분류
			if(confirm("물질정보 오분류 처리 하시겠습니까?\nMSDS_NO(MS99999999)와 화학물질담당자Comment만 저장됩니다.")) {
				$("#st_status").val("T");
				kepSave(document.searchCondition, mySheet, "/mdcm/updateStatusMasterrMdCtChemicalMat.do" , "SELECTED");
			}
			break;
			
		case "mCancle": //사업팀 취소
			$("#st_status").val("N");
			if(confirm("취소 처리 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdcm/updateStatusMasterrMdCtChemicalMat.do" , "SELECTED");
			}
			break;
			
		case "mRend": //사업팀 협력사반려
			if (isEmpty($("#st_kep_note").val())&&isEmpty($("#st_kep_cmc_note").val())) {
				alert("담당자 Comment 입력 바랍니다. ");
				return;		
			}
			$("#st_status").val("R");
			if(confirm("협력사 반려 처리시 담당자 Comment만 저장 되고 기타정보는 저장되지 않습니다.\n 협력사 반려 처리 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdcm/returnMasterrMdCtChemicalMat.do" , "SELECTED");
			}
			break;
			
		case "mSend": //검토요청
			if ( !checkSend())return;
			$("#st_status").val("M");
			if(confirm("검토요청 처리 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdcm/reqMasterrMdCtChemicalMat.do" , "SELECTED");
			}
			break;
			
		case "mConfirm": //최종승인
			if ( !checkSend())return;
			//MSDS 체크
			if (isEmpty($("#st_msds_no").val()) && isEmpty($("#st_msds_file_key").val())) {
				alert("MSDS정보 입력 바랍니다.");
				$("#st_msds_no").focus();
				return;
			}
			if (isEmpty($("#st_msds_no").val())) {
				alert("MSDS정보 매핑 바랍니다.");
				$("#st_msds_no").focus();
				return;
			}
			
<%if(CommonUtil.nvl(_rowData.get("SG118_YN")).equals("Y")){%>
	<%if(!"".equals(p070000033) && "".equals(st_quotation_no)){%>
			if(isEmpty($("#st_temp_cond").val())){
				alert("보관조건을 입력하여 주세요.");
				$("#st_temp_cond").focus();
				return;
			}
			
			if(isEmpty($("#st_temp_range").val())){
				alert("보관온도를 입력하여 주세요.");
				$("#st_temp_range").focus();
				return;
			}
	<%}%>
<%}%>
		
			$("#st_status").val("C");
			if(confirm("최종승인 처리 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdcm/confirmMasterrMdCtChemicalMat.do" , "SELECTED");
			}
			break;
			
		case "after": // 발주 후 제출(협력사)
			if($('input:radio[name="rdo_agent_note"]').is(":checked") != true){
				alert("협력사 Comment 내에서 선택 바랍니다.");
				return;
			}else{
				if ($("#rdo_agent_note3").is(":checked") == true && isEmpty($("#st_agent_note").val())) {
					alert("협력사 Comment 입력 바랍니다.");
					$("#st_agent_note").focus();
					return;		
				}
			}
		
			if($("#rdo_agent_note1").is(":checked") == true){
				$("#rdo_agent_note_value").val("안전확인대상 생활화학제품");
			}else if($("#rdo_agent_note2").is(":checked") == true){
				$("#rdo_agent_note_value").val("제품 내 화학물질 미분류");
			}else if($("#rdo_agent_note3").is(":checked") == true){
				$("#rdo_agent_note_value").val($("#st_agent_note").val());
			}
		
			if(confirm("발주 후 제출 처리하시겠습니까?\nKEP에서 최종 확인이 남았습니다.")) {
				kepSave(document.searchCondition, mySheet, "/mdct/afterSellerMdCtChemicalMatSendList.do" , "SELECTED");
			}
			break;
			
		case "mAfter": // 발주 후 제출
			$("#st_status").val("B");
			if(confirm("발주 후 제출 처리 하시겠습니까?\nMSDS_NO(MS88888888)와 화학물질담당자Comment만 저장됩니다.")) {
				kepSave(document.searchCondition, mySheet, "/mdcm/afterMasterrMdCtChemicalMat.do" , "SELECTED");
			}
			break;
	}
}
//제출시 데이터 체크
function checkSend() {
	if (isEmpty($("#st_harmful_yn").val())) {
		alert("유해화학 물질 여부 입력 바랍니다. ");
		$("#st_harmful_yn").focus();
		return false;		
	}
	//유해화학물질 항목 필수값 체크.
	if($("#st_harmful_yn").val() == "Y"){
		if (isEmpty($("#st_use_cd").val())) {
			alert("품목용도 정보를 입력 바랍니다. ");
			$("#st_use_cd").focus();
			return false;		
		}
		if (isEmpty($("#st_info_level").val())) {
			alert("순준량 정보를 입력 바랍니다. ");
			$("#st_info_level").focus();
			return false;		
		}
		if(!kepIsNumChk('st_info_level',2)) {
			alert("순준량 정보를 숫자형식으로 입력하여 주십시요.");
			$("#st_info_level").focus();
			return false;
		}
	}
	
	return true;
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	if(code>0){
		opener.doAction('search');
		self.close();
	}
}

function doPop(str) {
	var st_edit_yn = "<%=st_edit_yn%>";
	var viewType = "VI";
	if(st_edit_yn=="N"){
		viewType = "R";
	}
	switch (str){
	case "msds": //MSDS
		popupSel = "msds";
		openSearchPopup("/coco/showCommonCoCoMsdsPop.do", "?p_return=CHEMICAL", "950,600,no");
		break;
	case "msdsImageKey": //MSDS 첨부
		var type="CMC";
		var image_key =  $('#st_msds_file_key').val();
		popupSel = "msdsImageKey";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3){
	if(popupSel == "msds") {	//MSDS 매핑
		$('#st_msds_no').val(value1);
		$('#st_harmful_yn').val(value2);
		$('#st_use_cd').val(value3);
		
		harmfulSet(value2);
	}else if(popupSel == "msdsImageKey"){ //MSDS 첨부
		$('#st_msds_file_key').val(value1);
	} 
	grbRow="";	//초기화
}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	var st_edit_yn = "<%=st_edit_yn%>";
	if(st_edit_yn =="N"){
		var totRow = mySheet.RowCount();
		if( totRow<= 0) return;
		for(var i=1; i<=totRow;i++){
			mySheet.SetCellEditable(i+1, "SELECTED", 0);
			mySheet.SetCellEditable(i+1, "OPEN_FLAG", 0);
			mySheet.SetCellEditable(i+1, "CAS_NO", 0);
			mySheet.SetCellEditable(i+1, "COMPONENT_TYPE_CODE", 0);
			mySheet.SetCellEditable(i+1, "MIN_MAKE_RATE", 0);
			mySheet.SetCellEditable(i+1, "MAX_MAKE_RATE", 0);
			mySheet.SetCellEditable(i+1, "AVG_MAKE_RATE", 0);
			mySheet.SetCellEditable(i+1, "CML_HARMFUL_YN", 0);
			mySheet.SetCellEditable(i+1, "CML_PRE_TROUBLE_YN", 0);
			mySheet.SetCellEditable(i+1, "CML_BAN_OBJECT_YN", 0);
			mySheet.SetCellEditable(i+1, "CML_LIMIT_OBJECT_YN", 0);
		}		
	}
	if(!checkedSession(stCode)){return;}	
   	
}
//그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {

}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	grbRow = Row;
	return;
}

function mySheet_OnChange(Row, Col, Value, OldValue) {
	if ( Row  < 1) return;
}
//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
}
//유해화학여부에 따른 데이터값 셋팅
function harmfulSet(val){
	//유해화학물질 일경우
	if(val =="Y"){
		//물질정보
		document.getElementById('popContainer1').style.display = "block";
	}else{
		//물질정보
		document.getElementById('popContainer1').style.display = "none";
	}
}

</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_req_no"  name="st_req_no" value="${param.st_req_no}">
	<input type="hidden" id="st_status"  name="st_status" value="">		
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">
	<div id="popWrapper" style="height:600px;">
    	<div id="popHeader">
        	<h1 class="title">물질정보 입력</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--데이타그리드-->
            <h4><b>고객사 품목정보 </b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				   <col width="15%"/>
                   <col width="35%" />
                   <col width="15%" />
                   <col width="35%" />
				</colgroup>
				<tbody>
				  <tr>		
				  	<th>품명</th>  		
					<td>
						<%=CommonUtil.nvl(_rowData.get("DESCRIPTION_LOC")) %>
					</td>
					<th>규격</th>			
					<td>
						<%=CommonUtil.nvl(_rowData.get("SPECIFICATION")) %>
					</td>
				 </tr>
				  <tr>		
				  	<th>제조사</th>  		
					<td>
						<%=CommonUtil.nvl(_rowData.get("MAKER_NAME")) %>
					</td>
					<th>원산지</th>			
					<td>
						<%=CommonUtil.nvl(_rowData.get("ORIGIN_NM")) %>
					</td>
				 </tr>
				</tbody>
			</table>
			 <!--데이타그리드-->
            <h4><b>표준 품목정보 </b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				   <col width="15%"/>
                   <col width="35%" />
                   <col width="15%" />
                   <col width="35%" />
				</colgroup>
				<tbody>
				  <tr>		
				  	<th>품명</th>  		
					<td>
						<%=CommonUtil.nvl(_rowData.get("CMS_DESCRIPTION_LOC")) %>
					</td>
					<th>규격</th>			
					<td>
						<%=CommonUtil.nvl(_rowData.get("CMS_SPECIFICATION")) %>
					</td>
				 </tr>
				  <tr>		
				  	<th>제조사</th>  		
					<td>
						<%=CommonUtil.nvl(_rowData.get("CMS_MAKER_NAME")) %>
					</td>
					<th>표준카테고리</th>			
					<td>
						<%=CommonUtil.nvl(_rowData.get("CMS_CATEG_NM")) %>
					</td>
				 </tr>
				</tbody>
			</table>
			
<%if(CommonUtil.nvl(_rowData.get("SG118_YN")).equals("Y")){%>
	<% if("".equals(st_quotation_no)){ %>
			<h4><b>보관조건</b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				   <col width="15%"/>
                   <col width="35%" />
                   <col width="15%" />
                   <col width="35%" />
				<tbody>
				  <tr>		
				  	<th>보관조건
				  		<img src="/resources/images/but_query.png" style="vertical-align: middle;" title="실온     : 2-30 ℃ or Room temperature (RT)&#10;정온     : 15-25 ℃&#10;냉장     : 2-10 ℃&#10;냉동     : -20 ℃&#10;극냉동 : -30 ℃ 이하">
				  	</th>  					
					<td>
                        <select name="st_temp_cond" id="st_temp_cond" style="height:20px; width: 100px;" <%=st_edit_yn.equals("N") ? "disabled":""%>>
							<option value="">선택</option>
							<option value="A" <% if (CommonUtil.nvl(_rowData.get("TEMP_COND")).equals("A")) { %> selected <%} %>>상온(실온(RT))</option>
							<option value="B" <% if (CommonUtil.nvl(_rowData.get("TEMP_COND")).equals("B")) { %> selected <%} %>>상온(정온)</option>
							<option value="C" <% if (CommonUtil.nvl(_rowData.get("TEMP_COND")).equals("C")) { %> selected <%} %>>냉장</option>
							<option value="D" <% if (CommonUtil.nvl(_rowData.get("TEMP_COND")).equals("D")) { %> selected <%} %>>냉동</option>
							<option value="E" <% if (CommonUtil.nvl(_rowData.get("TEMP_COND")).equals("E")) { %> selected <%} %>>극냉동</option>
	                	</select>
					</td>
					<th>보관온도</th>			
					<td>
						<input type="text" class="input_type_text" name="st_temp_range"  id="st_temp_range" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("TEMP_RANGE"))%>" <%=st_edit_yn.equals("N") ? "disabled":""%>>
					</td>
				 </tr>
				</tbody>
			</table>
	<%}else{%>
			<input type="hidden" name="st_temp_cond" id="st_temp_cond" value="<%=CommonUtil.nvl(_rowData.get("TEMP_COND"))%>"/>
			<input type="hidden" name="st_temp_range" id="st_temp_range" value="<%=CommonUtil.nvl(_rowData.get("TEMP_RANGE"))%>"/>
	<%}%>
<%}else{%>
			<input type="hidden" name="st_temp_cond" id="st_temp_cond" value="<%=CommonUtil.nvl(_rowData.get("TEMP_COND"))%>"/>
			<input type="hidden" name="st_temp_range" id="st_temp_range" value="<%=CommonUtil.nvl(_rowData.get("TEMP_RANGE"))%>"/>
<%}%>
        	<h4><b>MSDS</b> ※ MSDS정보가 조회 되지 않을경우 파일첨부로 이용 바랍니다.</h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				   <col width="15%"/>
                   <col width="35%" />
                   <col width="15%" />
                   <col width="35%" />
				<tbody>
				  <tr>		
				  	<th>MSDS</th>  					
					<td>
						<input type="hidden" id="st_byit_comorg_code"  name="st_byit_comorg_code"  value="<%=CommonUtil.nvl(_rowData.get("BYIT_COMORG_CODE")) %>"/>
						<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no"  value="<%=CommonUtil.nvl(_rowData.get("BUYER_ITEM_NO")) %>"/>
						<input type="hidden" id="st_cmc_result_yn"  name="st_cmc_result_yn"  value="<%=CommonUtil.nvl(_rowData.get("CMC_RESULT_YN")) %>"/>
                        <input type="text" class="input_type_text" name="st_msds_no"  id="st_msds_no" style="width:100px;" value="<%=CommonUtil.nvl(_rowData.get("MSDS_NO")) %>" READONLY>
                        <!-- 협력사는 MSDS매핑 불가능. -->
                        <%if(st_edit_yn.equals("Y") && st_type.equals("mInput")){ %>
                        	<a href="javascript:doPop('msds');"><img src="/resources/images/btn_search03.gif"></a>
                        <%} %>
						<input type="hidden" name="st_msds_file_key" id="st_msds_file_key" style="width:100px;" value="<%=CommonUtil.nvl(_rowData.get("MSDS_NO_FILEKEY")) %>">
						<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('msdsImageKey')">파일첨부</a></span>
					</td>
					<th>유해화학물질 여부</th>			
					<td>
						<select name="st_harmful_yn" id="st_harmful_yn"   onchange="javascript:harmfulSet(this.value);" style="height:20px; width: 60px;" <%=st_edit_yn.equals("N") ? "disabled":""%>>
							<option value="">선택</option>
							<option value="Y" <% if (CommonUtil.nvl(_rowData.get("CMC_HARMFUL_YN")).equals("Y")) { %> selected <%} %>>Y</option>
							<option value="N" <% if (CommonUtil.nvl(_rowData.get("CMC_HARMFUL_YN")).equals("N")) { %> selected <%} %>>N</option>
	                	</select>
					</td>
				 </tr>
				</tbody>
			</table>	
			<div id="popContainer1"  style="display:none;">
        	<h4><b>물질정보</b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				   <col width="15%"/>
                   <col width="35%" />
                   <col width="15%" />
                   <col width="35%" />
                </colgroup>
				<tbody>
				  <tr>		
					<th>품목용도</th>			
					<td >
						<select name="st_use_cd"  id="st_use_cd" style="width:80%" <%=st_edit_yn.equals("N") ? "disabled":""%>>
						  	<%= CommonUtil.getCode3ComboList("", "SEL", "CM02","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("CMC_USE_CODE")), "") %>           
				         </select>
					</td>
					<th>순준량</th>			
					<td >
						<input type="text" name="st_info_level" id="st_info_level" class="input_type_text" title="" style="width:40%;"  <%=st_edit_yn.equals("N") ? "disabled":""%> value="<%=CommonUtil.nvl(_rowData.get("CMC_INFO_LEVEL")) %>"/>
						<input type="hidden" name="st_info_unit" id="st_info_unit" value="KG"/>
						<font style="vertical-align: middle;">Kg</font>
					</td>
				 </tr>
				</tbody>
			</table>	
			</div>

	       	<!--grid-->
			<div id="gridArea" style="height:150px;display:none;" class="mb10">
				<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "150px");
					</script>
				</div>
			</div>
			
			<!--담당자Commnet-->
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				   <col width="18%"/>
                   <col width="*" />
				<tbody>
				  <tr>
					<th>MSDS 제출<br>예외사유</th>
					<td >
				<%
				// 예외사유 표시 로직
				String kepNote = CommonUtil.nvl(_rowData.get("KEP_NOTE"));
				String reqStatus = CommonUtil.nvl(_rowData.get("REQ_STATUS"));
				String displayExceptionReason = "";

				if (!kepNote.isEmpty()) {
					// 미대상품목: KEP_NOTE에 저장된 예외사유 표시
					displayExceptionReason = kepNote;
				}
				// 2025-01-20 주석처리: KEP담당자가 [발주후제출] 선택 시 상태값만 변경되어야 하는데,
				// 이 로직으로 인해 "발주 후 제출" 텍스트가 input 필드에 자동 삽입되어
				// 다른 작업(반려/검토요청) 수행 시 KEP_NOTE에 저장되는 문제 발생
				// else if ("A".equals(reqStatus) || "B".equals(reqStatus)) {
				// 	// 발주후제출: REQ_STATUS가 A 또는 B이면 "발주 후 제출" 표시
				// 	displayExceptionReason = "발주 후 제출";
				// }

				//사업팀 입력
				if(st_type.equals("mInput")&& st_cmc_yn.equals("N")){
				%>
						<input type="text" name="st_kep_note" id="st_kep_note" class="input_type_text" title="" style="width:90%;" value="<%=displayExceptionReason%>"/>
				<%
				}else{
				%>
						<input type="hidden" id="st_kep_note" name="st_kep_note" value="<%=kepNote%>"/>
						<%=displayExceptionReason%>
				<%
				}
				%>
					</td>
				 </tr>
				  <tr>		
					<th>화학물질담당자<br>Comment</th>			
					<td >
				<%
				//사업팀 입력
				if(st_type.equals("mInput")&& st_cmc_yn.equals("Y")){
				%>
					<input type="text" name="st_kep_cmc_note" id="st_kep_cmc_note" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("KEP_CMC_NOTE")) %>"/>
				<%
				}else{
				%>
						<input type="hidden" id="st_kep_cmc_note"  name="st_kep_cmc_note"  value="<%=CommonUtil.nvl(_rowData.get("KEP_CMC_NOTE")) %>"/>
						<%=CommonUtil.nvl(_rowData.get("KEP_CMC_NOTE")) %>
				<%
				}
				%>
					</td>
				 </tr>
				 <tr>
					<th>협력사<br>Comment</th>			
					<td >
				<%
				//협력사 입력
				if(st_type.equals("sInput")){
				%>
					<input type="hidden" name="rdo_agent_note_value" id="rdo_agent_note_value" class="input_type_text" value=""/>
					<input type="radio" style="vertical-align: middle;" name="rdo_agent_note" id="rdo_agent_note1" value="A" />&nbsp;안전확인대상 생활화학제품&nbsp; &nbsp;
					<input type="radio" style="vertical-align: middle;" name="rdo_agent_note" id="rdo_agent_note2" value="B" />&nbsp;제품 내 화학물질 미분류&nbsp; &nbsp;
					<input type="radio" style="vertical-align: middle;" name="rdo_agent_note" id="rdo_agent_note3" value="C" />&nbsp;기타&nbsp;
					<input type="text" name="st_agent_note" id="st_agent_note" class="input_type_text" title="" style="width:25%;" value="<%=CommonUtil.nvl(_rowData.get("AGENT_NOTE")) %>"/>
					
				<%
				}else{
				%>
					<input type="hidden" id="st_agent_note"  name="st_agent_note"  value="<%=CommonUtil.nvl(_rowData.get("AGENT_NOTE")) %>"/>
					<%=CommonUtil.nvl(_rowData.get("AGENT_NOTE")) %>
				<%
				}
				%>
					</td>
				 </tr>
				</tbody>
			</table>
				<%
				if(st_type.equals("sInput")){//협력사 입력
				%>	
					<div style=" width:100%; text-align:center; background-color:#eaeaea; border-top:2px solid #686868; height:30px; line-height:30px; font-weight:bold; color:#181818">협력업체 제출확인사항</div>
            		<textarea rows="8" style="width:98%; padding:1%; margin-bottom:10px;font-family:Dotum" readonly>
* 유해화학물질 확인
‘화학물질의 등록 및 평가 등에 관한 법률’ 및 ‘화학물질관리법’ 제2조에 따른 유해화학물질 함유여부 확인 당사가 KeP에 공급하는 제품에는 본 화학물질 등록서류에 작성한 성분 물질을 제외한 미공개 물질에 대하여 ‘화학물질의 등록 및 평가 등에 관한 법률과 ‘화학물질관리법’에서 정의하는 신규화학물질, 등록대상 기존화학물질, 유독물질, 허가물질, 제한물질 또는 금지물질, 사고대비물질, 그 밖에 유해성 또는 위해성이 있거나 그러할 우려가 있는 화학물질을 함유하고 있지 않음을 확인합니다.

‘EU REACH’ 제5조에 따른 등록대상물질 함유여부 확인 당사가 KeP에 공급하는 제품에는 본 화학물질 등록서류에 작성한 성분 물질을 제외한 미공개 물질에 대하여 EU REACH 제5조에 의거하여 등록이 필요한 물질을 함유하고 있지 않음을 확인합니다.
 
*  REACH SVHC 물질확인
‘EU REACH SVHC’ 물질 함유여부 확인
당사가 KeP에 공급하는 제품에는 본 화학물질 등록서류에 작성한 성분 물질을 제외한 미공개 물질에 대하여 유럽화학물질청(ECHA)에서 규제하는 SVHC 물질을 함유하고 있지 않음을 확인합니다.

※SVHC 물질은 EU REACH Regulation 제59조 제10항에서 언급하는 고위험성 우려물질 후보목록(Candidate List of Substances of Very High Concern)에 포함되는 물질로써,공급업체가 KeP에 공급하는 시점까지 ECHA 홈페이지에 공개한 목록에 포함되는 물질을 말합니다.
 
* 공급업체 제출확인
당사가 전자구매포탈에 입력한 모든 기재 내용은 사실에 근거하여 작성되었으며, 당사는 잘못된 정보로 인하여 차후 KeP에서 발생할 수 있는 손해와 법적인 문제에 대해서 책임질 것을 보증합니다.
또한 산업안전보건법 제41조(물질안전보건자료의 작성, 비치 등) 에 의거하여 화학물질의 정보에 변경사항이 발생된 경우 신속히 KeP에 알릴 것을 보증합니다.

MSDS 제출 대상 제품임에도 불구하고 MSDS가 공유되지 않는다면 산업안전보건법 제175조 9항에 의거하여 5,000만원 이하의 과태료가 발생할 수 있음을 안내 드립니다.
MSDS 제출 대상이 아닌 제품인 경우, 협력사 comment에 작성과 오분류 처리를 부탁 드리겠습니다.            
            		</textarea>
		            <font style="color:blue;"><b>※ 위 "협력업체 제출확인사항" 확인 후 제출 하시겠습니까?</b></font>&nbsp;
		           	<input style="vertical-align: middle;" type="radio" name="infoOptional" id="infoOptiAgree" value="Y"/>&nbsp;예&nbsp; &nbsp;
		           	<input style="vertical-align: middle;" type="radio" name="infoOptional" id="infoOptiDisagree" value="N"/>&nbsp;아니오
		             <div  class="btnArea" >
		  	          	<span class="fr">
		  	          	<% if(!"".equals(st_quotation_no)){ %>
							<span class="btn_05 mr04"><a href="javascript:doAction('after')">발주 후 제출</a></span>
						<% } %>
							<span class="btn_05 mr04"><a href="javascript:doAction('return')">물질정보 오분류</a></span>
							<span class="btn_05 mr04"><a href="javascript:doAction('send');">물질정보제출</a></span>
						</span>
			  		</div>
			<%
				}else if(st_type.equals("mInput") && st_cmc_yn.equals("N")){//사업팀권한
			%>
					 <font style="color:blue;">※ 협력사에서 오분류를 선택하는 경우, 상세사유를 필수 입력해주시길 부탁드리며, 화학물질이 아닌 경우, 사업팀 담당자분들께서는 표준카테고리를 변경하신 후 검토요청을 진행해주시기 바랍니다.</font>&nbsp;
		             <div  class="btnArea" >
		  	          	<span class="fr">
							<% 
							if(!st_req_status.equals("M")&&!st_req_status.equals("C")&&!st_req_status.equals("T")&&!st_req_status.equals("N")&&!st_req_status.equals("B")){//검토요청건에 대해서는 취소,오분류 처리 불가능
							%>
								<span class="btn_02 mr04"><a href="javascript:doAction('mCancle')">취소</a></span>
							<%
							}
							if(!st_req_status.equals("R")&&!st_req_status.equals("M")&&!st_req_status.equals("Q")&&!st_req_status.equals("C")&&!st_req_status.equals("T")&&!st_req_status.equals("N")&&!st_req_status.equals("B")){//협력사 반려제출된상태면 상태 아래버튼 안나옴.
							%>
								<span class="btn_05 mr04"><a href="javascript:doAction('mRend');">협력사반려</a></span>
							<%
							}
							%>
							<% 
							if(!st_req_status.equals("R")&&!st_req_status.equals("M")&&!st_req_status.equals("C")&&!st_req_status.equals("T")&&!st_req_status.equals("N")&&!st_req_status.equals("B")){//협력사 반려제출된상태면 상태 아래버튼 안나옴.
							%>
								<span class="btn_04 mr04"><a href="javascript:doAction('mSend');">검토요청</a></span>
							<%
							}
							%>
						</span>
			  		</div>
			<%
				}else if(st_type.equals("mInput") && st_cmc_yn.equals("Y")){//화학물질 담당자.
			%>
		             <div  class="btnArea" >
		  	          	<span class="fr">
							<% 
							if(!st_req_status.equals("C")&&!st_req_status.equals("T")&&!st_req_status.equals("N")&&!st_req_status.equals("B")){//최종승인시 버튼 비활성화
							%>
								<span class="btn_02 mr04"><a href="javascript:doAction('mCancle')">취소</a></span>
								<span class="btn_05 mr04"><a href="javascript:doAction('mReturn')">오분류(종결)</a></span>
							<% if(!"".equals(st_quotation_no)){ %>
								<span class="btn_05 mr04"><a href="javascript:doAction('mAfter')">발주 후 제출</a></span>
							<% } %>
							<%
							}
							if(!st_req_status.equals("R")&&!st_req_status.equals("C")&&!st_req_status.equals("Q")&&!st_req_status.equals("T")&&!st_req_status.equals("N")&&!st_req_status.equals("B")){//협력사 반려제출된상태면 상태 아래버튼 안나옴.
							%>
								<span class="btn_05 mr04"><a href="javascript:doAction('mRend');">협력사반려</a></span>
							<%
							}
							if(!st_req_status.equals("R")&&!st_req_status.equals("C")&&!st_req_status.equals("T")&&!st_req_status.equals("N")&&!st_req_status.equals("B")){//협력사 반려제출된상태면 상태 아래버튼 안나옴.
							%>
								<span class="btn_04 mr04"><a href="javascript:doAction('mConfirm');">최종승인</a></span>
							<%
							}
							%>
						</span>
			  		</div>			
			<%
				}
			%>		
        </div>
    	</div>
	</div>				
	</form>
</body>
</html>
