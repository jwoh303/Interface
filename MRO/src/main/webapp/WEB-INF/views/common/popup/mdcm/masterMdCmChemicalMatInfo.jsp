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
	String sg119Yn = "";
	String businessCond = "";
	String cmcHarmfulYn = "N";
	String reqNo = "";
	//st_type: sInput:협력사 입력, sSearh:협력사 조회, mInput:KeP입력
	String st_type = CommonUtil.nvl((String) request.getParameter("st_type"), "");
	String st_req_status = CommonUtil.nvl((String) request.getParameter("st_req_status"), "");
	String st_cmc_yn = "N";
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		sg119Yn =CommonUtil.nvl(_rowData.get("SG118_YN"),"N");
		cmcHarmfulYn = CommonUtil.nvl(_rowData.get("CMC_HARMFUL_YN"));
		st_cmc_yn = CommonUtil.nvl(_rowData.get("CMC_USR_YN"),"N");
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
							,{ Align:"Left",	SaveName:"CML_HARMFUL_YN",		Header:"화관법|유독물질",		Type:"DummyCheck", HeaderCheck:0,	Width:79,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${optColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CML_PRE_TROUBLE_YN",		Header:"화관법|사고대비물질",		Type:"DummyCheck", HeaderCheck:0,	Width:79,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${optColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CML_BAN_OBJECT_YN",		Header:"화관법|금지물질",		Type:"DummyCheck", HeaderCheck:0,	Width:79,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,BackColor:"${optColor}",Hidden:false}
							,{ Align:"Left",	SaveName:"CML_LIMIT_OBJECT_YN",		Header:"화관법|제한물질",		Type:"DummyCheck", HeaderCheck:0,	Width:79,	Edit:true,	EditLen:6, ColMerge:1,Sort:1,	BackColor:"${optColor}",Hidden:false}

	];
	//InitHeaders의 두번째 인자
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	initsheet.HeaderMode = {ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	IBS_InitSheet(mySheet, initsheet,pagingMode, '');	
	mySheet.SetColProperty("OPEN_FLAG", comboOpenFlag);
	mySheet.SetColProperty("COMPONENT_TYPE_CODE", comboCompent);
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmChemicalMatInfoList.do" , pagingMode );
	var cmcHarmfulYn = "<%=cmcHarmfulYn%>";
	harmfulSet(cmcHarmfulYn);

}

var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	if ($("#st_harmful_yn").val()=="N") {
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		if(selectedGrid.length ==0) {
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, 'SELECTED', "1");			
		}
	}
	switch (str) {
		case "cancle": //취소처리
			if($("#st_cmc_result").val() =="Y"){
				alert("유해 화학물질 실적 등록건이므로 삭제 불가능 합니다.");
				return;
			}
			if(confirm("삭제 처리 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdcm/cancleMasterMdCmChemicalMatInfo.do" , "SELECTED");
			}
			break;
		case "save": //저장
			if($("#st_cmc_result").val() =="Y"){
				alert("유해 화학물질 실적 등록건이므로 변경 불가능 합니다.");
				return;
			}
			if ( !checkSend())return;
			if(confirm("저장 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mdcm/saveMasterMdCmChemicalMatInfo.do" , "SELECTED");
			}
			break;
		case "addRow": // 행추가
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, 'SELECTED', "1");
			break;
		case "deleteRows": // 행삭제
			var selectedRows = mySheet.FindCheckedRow("SELECTED");
			mySheet.RowDelete(selectedRows, 1);	
			break;
	}

}
//제출시 데이터 체크
function checkSend() {
	//시약정보 요약서 체크
	var sg119Yn= "<%=sg119Yn%>";
	if(sg119Yn =="Y"&&$("#st_harmful_yn").val() == "Y"){
		if(isEmpty($("#st_cmc_image_key").val()) && isEmpty($("#st_cmc_class_cd").val())) {
			alert("시약정보 요약서 첨부 또는 미첨부 사유 입력 바랍니다.");
			return false;
		}
		if($("#st_cmc_class_cd").val() == "A04"){
			if (isEmpty($("#st_cmc_remark").val())) {
				alert("미첨부 사유가 기타면 비고 입력이 필요 합니다. ");
				$("#st_cmc_remark").focus();
				return false;
			}
		}
	}
	
	if (isEmpty($("#st_harmful_yn").val())) {
		alert("유해화학 물질 여부 입력 바랍니다. ");
		$("#st_harmful_yn").focus();
		return false;		
	}
	//유해화학물질 항목 필수값 체크.
	if($("#st_harmful_yn").val() == "Y"){
		if (isEmpty($("#st_harmful_desc").val())) {
			alert("물질품명 입력 바랍니다. ");
			$("#st_harmful_desc").focus();
			return false;		
		}
		if (isEmpty($("#st_use_cd").val())) {
			alert("품목용도 정보를 입력 바랍니다. ");
			$("#st_use_cd").focus();
			return false;		
		}
		if($("#st_use_cd").val() == "A55"){
			if (isEmpty($("#st_use_note").val())) {
				alert("품목용도가 기타면 품목용도 비고 입력이 필요 합니다. ");
				$("#st_use_note").focus();
				return false;
			}
		}
		if (isEmpty($("#st_info_cd").val())) {
			alert("물질상태 정보를 입력 바랍니다. ");
			$("#st_info_cd").focus();
			return false;		
		}
		if (isEmpty($("#st_info_level").val())) {
			alert("순준량 정보를 입력 바랍니다. ");
			$("#st_info_level").focus();
			return false;		
		}
		if (isEmpty($("#st_info_unit").val())) {
			alert("순준량 단위를 입력 바랍니다. ");
			$("#st_info_unit").focus();
			return false;		
		}
		var st_min_rate = "";
		var st_max_rate = "";
		var st_avg_rate = "";
		var st_open_flag = "";
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");
		if(selectedGrid.length == 0){
            alert("제출할 조성정보를 선택해주세요.");
            return false;			
		}
		
		for (var j=0; j<arrRow.length; j++){
		     if ( mySheet.GetCellValue(arrRow[j], "SELECTED") == 1 ) {
		         if ( mySheet.GetCellValue(arrRow[j], "OPEN_FLAG") == "" ) {
		             alert("조성정보의 공개여부를 선택해주세요.");
		             return false;
		         }
		         //비공개일 경우
		         if ( mySheet.GetCellValue(arrRow[j], "OPEN_FLAG") == "CL" ) {
		        	 st_open_flag = "N";
		         }
		         if ( mySheet.GetCellValue(arrRow[j], "CAS_NO") == "" ) {
		             alert("CAS-NO를 입력 바랍니다.");
		             return false;
		         }
		         if ( mySheet.GetCellValue(arrRow[j], "CML_HARMFUL_YN") == "0" && mySheet.GetCellValue(arrRow[j], "CML_PRE_TROUBLE_YN") == "0" 
	        		 &&mySheet.GetCellValue(arrRow[j], "CML_BAN_OBJECT_YN") == "0" &&mySheet.GetCellValue(arrRow[j], "CML_LIMIT_OBJECT_YN") == "0") {
	             alert("화관법 물질정보 체크 바랍니다.");
	             return false;
	         }
		         if ( mySheet.GetCellValue(arrRow[j], "COMPONENT_TYPE_CODE") == "" ) {
		             alert("성분유형을 선택해주세요.");
		             return false;
		         }
		         st_min_rate =  eval(mySheet.GetCellValue(arrRow[j], "MIN_MAKE_RATE") + st_min_rate);
		         st_max_rate =  eval(mySheet.GetCellValue(arrRow[j], "MAX_MAKE_RATE")+ st_max_rate);
		         st_avg_rate =  eval(mySheet.GetCellValue(arrRow[j], "AVG_MAKE_RATE")+ st_avg_rate);
		     }
		 }
     	var dupIdx = mySheet.ColValueDup("CAS_NO");
    	if(dupIdx > -1){
    		alert("동일한 CAS NO가 있습니다.");
    		return false;
    	}
		if(st_min_rate > 100){
	        alert("최소 함량값은 반드시 100% 초과하면 안됩니다.");
	        return false;		
		}
		if(st_max_rate > 100){
	        alert("최대 함량값은 반드시 100% 초과하면 안됩니다.");
	        return false;		
		}
		if(st_avg_rate > 100){
	        alert("평균 함량값은 반드시 100% 초과하면 안됩니다.");
	        return false;		
		}
		//공개여부가 비공개 일경우 LOC 첨부
		if(st_open_flag =="N"){
			if(isEmpty($("#st_loc_image_key").val())) {
				alert("비공개(영업비밀)로 선택하신 경우 LOC(Letter of Confirmation)를 첨부하여 주십시오.");
				return false;
			}
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
		this.close();
	}
}


function doPop(str) {
	switch (str){
	case "locImageKey": //LOC 첨부
		var type="CMC";
		var viewType="";
		var st_cmc_yn = "<%=st_cmc_yn%>";
		if(st_cmc_yn =="Y"){
			viewType="VI";
		}else{
			viewType="R";
		}
		var image_key =  $('#st_loc_image_key').val();
		popupSel = "locImageKey";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	case "cmcImageKey": //시약정보 요약
		var type="CMC";
		var st_cmc_yn = "<%=st_cmc_yn%>";
		if(st_cmc_yn =="Y"){
			viewType="VI";
		}else{
			viewType="R";
		}
		var image_key =  $('#st_cmc_image_key').val();
		popupSel = "cmcImageKey";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3){
	 if(popupSel == "locImageKey"){ //LOC 첨부
		$('#st_loc_image_key').val(value1);
	}else if(popupSel == "cmcImageKey"){ //시약정보 요약서
		$('#st_cmc_image_key').val(value1);
		$('#st_cmc_class_cd').val("");
		
	} 
	grbRow="";	//초기화
}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	//기타시약일 경우 체크
	var sg119Yn= "<%=sg119Yn%>";
	if(sg119Yn =="Y"&&$("#st_harmful_yn").val() == "Y"){
		//시약정보
		document.getElementById('popContainer3').style.display = "block";
	}else{
		//시약정보
		document.getElementById('popContainer3').style.display = "none";		
	}
	var st_cmc_yn = "<%=st_cmc_yn%>";
	//화학물질 담당자가 아닐경우 수정 불가.
	if(st_cmc_yn =="N"){
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
		//조성정보그리드
		document.getElementById('gridArea').style.display = "block";
		document.getElementById('btnArea').style.display = "block";
		var sg119Yn= "<%=sg119Yn%>";
		if(sg119Yn =="Y"){
			//시약정보
			document.getElementById('popContainer3').style.display = "block";
		}
	}else{
		//물질정보
		document.getElementById('popContainer1').style.display = "none";
		//조성정보그리드
		document.getElementById('gridArea').style.display = "none";
		document.getElementById('btnArea').style.display = "none";
		//시약정보
		document.getElementById('popContainer3').style.display = "none";
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
	<input type="hidden" id="st_buyer"  name="st_buyer" value="${param.st_buyer}">
	<input type="hidden" id="st_buyer_item_no"  name="st_buyer_item_no" value="${param.st_buyer_item_no}">
	<input type="hidden" id="st_danger_class_cd"  name="st_danger_class_cd" value="">
	<input type="hidden" id="st_info_keep"  name="st_info_keep" value="">
	<div id="popWrapper" style="height:600px;">
    	<div id="popHeader">
        	<h1 class="title">물질정보 조회</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--데이타그리드-->
            <h4><b>품목정보 </b></h4>
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
						<input type="hidden" id="st_cmc_result"  name="st_cmc_result" value="<%=CommonUtil.nvl(_rowData.get("CMC_RESULT_YN")) %>">
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
        	<h4><b>MSDS</b> ※ MSDS정보가 조회 되지 않을경우 첨부 등록으로 이용 바랍니다.</h4>
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
						<%=CommonUtil.nvl(_rowData.get("MSDS_NO")) %>
					</td>
					<th>유해화학물질 여부</th>			
					<td>
						<select name="st_harmful_yn" id="st_harmful_yn"   onchange="javascript:harmfulSet(this.value);" style="height:20px; width: 60px;" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>
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
				<tbody>
				  <tr>		
					<th>물질품명</th>			
					<td >
						<input type="text" name="st_harmful_desc" id="st_harmful_desc" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("HARMFUL_CMC_DESCRIPTION")) %>"  <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>/>
						<br>※ 제조사 기준으로 표기된 품명으로 입력 바립니다.
					</td>
					<th>폼목용도</th>			
					<td >
						<select name="st_use_cd"  id="st_use_cd" style="width:80%" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>
						  	<%= CommonUtil.getCode3ComboList("", "SEL", "CM02","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("CMC_USE_CODE")), "") %>           
				         </select>
					</td>
				 </tr>
				  <tr>		
					<th>품목용도비고</th>			
					<td>
						<input type="text" name="st_use_note" id="st_use_note" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("CMC_USE_NOTE")) %>" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>
					</td>
					<th>물질상태</th>			
					<td >
						<select name="st_info_cd"  id="st_info_cd" style="width:80%" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>>
						  	<%= CommonUtil.getCode3ComboList("", "SEL", "CM06","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("CMC_INFO_CODE")), "") %>           
				         </select>
					</td>
				 </tr>
				  <tr>		
					<th>순준량</th>			
					<td >
						<input type="text" name="st_info_level" id="st_info_level" class="input_type_text" title="" style="width:40%;" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"  value="<%=CommonUtil.nvl(_rowData.get("CMC_INFO_LEVEL")) %>" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>
						<select name="st_info_unit"  id="st_info_unit" style="width:40%" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>
						  	<%= CommonUtil.getCode3ComboList("", "SEL", "CM09","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("CMC_INFO_UNIT")), "") %>           
				         </select>
					</td>
					<th>LOC첨부</th>			
					<td >
						<input type="hidden" id="st_loc_image_key" name="st_loc_image_key" value="<%=CommonUtil.nvl(_rowData.get("LOC_IMAGE_KEY")) %>" />
						<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('locImageKey')">첨부등록</a></span>
					</td>
				 </tr>
				</tbody>
			</table>	
			</div>
			<div id="popContainer3"  style="display:none;">
        	<h4><b>시약정보 요약서</b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				   <col width="15%"/>
                   <col width="35%" />
                   <col width="15%" />
                   <col width="35%" />
				<tbody>
				  <tr>		
					<th>파일첨부</th>			
					<td >
						<input type="hidden" id="st_cmc_image_key" name="st_cmc_image_key" value="<%=CommonUtil.nvl(_rowData.get("CMC_INFO_IMAGE_KEY")) %>" />
						<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('cmcImageKey')">첨부등록</a></span>
					</td>
					<th>미첨부사유</th>			
					<td >
						<select name="st_cmc_class_cd"  id="st_cmc_class_cd" style="width:80%" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>
						  	<%= CommonUtil.getCode3ComboList("", "SEL", "CM05","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("CMC_INFO_NOT_IMAGE_CODE")), "") %>           
				         </select>
					</td>
				</tr>
				<tr>
					<th>비고</th>			
					<td colspan="3">
						<input type="text" name="st_cmc_remark" id="st_cmc_remark" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("CMC_INFO_REMARK")) %>" <%=CommonUtil.nvl(_rowData.get("CMC_USR_YN")).equals("N") ? "disabled":""%>>
					</td>
				 </tr>
				</tbody>
			</table>
			</div>
			<!--버튼영역-->
				<%
				if(st_cmc_yn.equals("Y")){
				%>			
	             <div id="btnArea"  class="btnArea"  style="display:none;">
	             	<span class="fl">
						<h4><b>조성정보</b></h4>
					</span>
	             	<span class="fr">
						<span class="btn_02 mr04"><a href="javascript:doAction('addRow')">행추가</a></span>
						<span class="btn_02 mr04"><a href="javascript:doAction('deleteRows')">행삭제</a></span>
					</span>					
		  		</div>
				<%
				}
				%>
	       	<!--grid-->
			<div id="gridArea" style="height:150px;display:none;" class="mb10">
				<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "150px");
					</script>
				</div>
			</div>
				<%
				 if(st_cmc_yn.equals("Y")){
				%>
		             <div  class="btnArea" >
		  	          	<span class="fr">
		  	          		<span class="btn_02 mr04"><a href="javascript:doAction('cancle')">삭제</a></span>
		  	          		<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
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
