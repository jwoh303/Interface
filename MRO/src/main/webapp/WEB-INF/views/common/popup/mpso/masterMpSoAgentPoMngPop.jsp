<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
String comType = (String)_sessionInfo.getBusinessCond();
String userId = (String)_sessionInfo.getUserId();
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된결과  
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
Map<String,String> rowData = null;

if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1.get(0);
}
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

function kep_onload_view(){
<%
	if (_dataList1==null || _dataList1.size()==0){
%>
		setQuery();
<%
	}else{
%>
	var initsheet = {};
	initsheet.Cols = [
		{ Align:"Center",	SaveName:"sStatus",			Header:"상태",		Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true},
		{ Align:"Center",	SaveName:"SELECTED",		Header:"",			Type:"DummyCheck",	Width:38,	Edit:true,	EditLen:100,	Hidden:false},
		{ Align:"Center",	SaveName:"ADD_DATE",		Header:"이슈등록일",	Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false},
		{ Align:"Center",	SaveName:"TYPE",			Header:"이슈상태",		Type:"Text",		Width:120,	Edit:false,	EditLen:4,		Hidden:true},
		{ Align:"Center",	SaveName:"TYPE_TEXT",		Header:"이슈상태",		Type:"Text",		Width:120,	Edit:false,	EditLen:4,		Hidden:false},
		{ Align:"Center",	SaveName:"BUYER",			Header:"고객사코드",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true},
		{ Align:"Left",		SaveName:"BUYER_NAME",		Header:"고객사명",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false},
		{ Align:"Center",	SaveName:"PO_NO",			Header:"발주번호",		Type:"Text",		Width:80,	Edit:false,	EditLen:2,		Hidden:false},
		{ Align:"Center",	SaveName:"PO_SEQ",			Header:"발주항번",		Type:"Text",		Width:50,	Edit:false,	EditLen:2,		Hidden:true},
		{ Align:"Center",	SaveName:"DS_SEQ",			Header:"수주항번",		Type:"Text",		Width:50,	Edit:false,	EditLen:2,		Hidden:true},
		{ Align:"Center",	SaveName:"SEQ",				Header:"발송정보 항번",	Type:"Text",		Width:50,	Edit:false,	EditLen:2,		Hidden:true},
		{ Align:"Center",	SaveName:"BUYER_ITEM_NO",	Header:"품목코드",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false},
		{ Align:"Left",		SaveName:"DESCRIPTION",		Header:"품명",		Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false},
		{ Align:"Left",		SaveName:"SPECIFICATION",	Header:"규격",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true},
		{ Align:"Center",	SaveName:"MAKER_CODE",		Header:"제조사코드",	Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true},
		{ Align:"Left",		SaveName:"MAKER_NAME",		Header:"제조사",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true},
		{ Align:"Right",	SaveName:"CD_QTY",			Header:"수량",		Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false},
		{ Align:"Right",	SaveName:"UNIT_PRICE",		Header:"매출가",		Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false},
		{ Align:"Right",	SaveName:"AGENT_PRICE",		Header:"매입가",		Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false},
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "TYPE_TEXT");
	
	doAction("search");
<%
	}
%>
}

function setQuery(){
	$('#searchForm').attr("action", "/common/getAgentPoMngPop.do").submit();
}

function kepEnter() {
	if (event.keyCode == 13) { 
		setQuery();
	}
}

var st;
var mt;
//기능함수
function doAction(str, flag) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	switch (str) {
		case "search":
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mpso/getMasterMpSoAgentPoMngPop.do", pagingMode);
			break;
	}
}

function setReturn(value1,value2){ 
	opener.setPopupReturn(value1,value2);
	this.close();
}

//팝업함수호출
function doPop(str) {

	var st_agent_code = $("#st_com_code").val();
	var st_agent_name = $("#st_agent_name").val();
	switch (str) {
		case "agentCommunity": // 협력사 커뮤니티
			if(st_agent_code == "") {
				alert("존재하지 않는 협력사입니다.");
				break;
			}
	
			openSearchPopup('/mdcp/getMasterMdCpAgentCommunityInfoList.do','?com_code='+st_agent_code, '800,680,no');
			break;
		case "agentDmSend":
			
			popupSel = "agentDmSendPop";
			const separator = "@";
			const formSeparator = "@@";
			const paramSeparator = "^||^";
			const commaSeparator = ",";
			let firstParamFlg = true;
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");

			// 선택된 항목 유무 체크
			if (str !="search" && selectedGrid.length == 0) {
				alert("선택된 값이 없습니다.\n이슈를 선택해주세요.");
				return;
			}
			// var dataArr = selectedGrid.split(separator);// 삭제대상
			var st_popup_url = "/mdcm/showMasterMdcmAgentDmSendPop.do";
			var st_popup_option = "900,850,no";
			var st_popup_param = "";
			var st_com_code_param	= "st_com_code" + formSeparator;
			var st_com_code_name_param	= "st_com_code_name" + formSeparator;
			var st_po_no_param	= "st_po_no" + formSeparator;
			var st_po_seq_param	= "st_po_seq" + formSeparator;
			var st_ds_seq_param	= "st_ds_seq" + formSeparator;
			var st_sent_seq_param	= "st_sent_seq" + formSeparator;
			var st_dm_issue_param = "st_dm_issue" + formSeparator;

			for(var i=1; i<mySheet.GetTotalRows()+1; i++){
				// 첫 실행에서 구분자 없이 붙이기
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					if(firstParamFlg) {
						firstParamFlg			= false; // 구분자 없이 붙이기 위한 flg 
						// bk_20240329 고객사가 아닌 협력사
						// st_com_code_param		+= mySheet.GetCellValue(i,"BUYER");
						// st_com_code_name_param	+= mySheet.GetCellValue(i,"BUYER_NAME");
						st_com_code_param		+= st_agent_code;
						st_com_code_name_param	+= st_agent_name;
						st_po_no_param			+= mySheet.GetCellValue(i,"PO_NO");
						st_po_seq_param			+= mySheet.GetCellValue(i,"PO_SEQ");
						st_ds_seq_param			+= mySheet.GetCellValue(i,"DS_SEQ");
						st_sent_seq_param		+= mySheet.GetCellValue(i,"SEQ"); // SENT_SEQ
						st_dm_issue_param		+= mySheet.GetCellValue(i,"PO_NO") + commaSeparator + mySheet.GetCellValue(i,"PO_SEQ") + commaSeparator
												+ mySheet.GetCellValue(i,"DS_SEQ") + commaSeparator + mySheet.GetCellValue(i,"SEQ");
					}else{
						st_po_no_param		+= separator + mySheet.GetCellValue(i,"PO_NO");
						st_po_seq_param		+= separator + mySheet.GetCellValue(i,"PO_SEQ");
						st_ds_seq_param		+= separator + mySheet.GetCellValue(i,"DS_SEQ");
						st_sent_seq_param	+= separator + mySheet.GetCellValue(i,"SEQ"); // SENT_SEQ
						st_dm_issue_param	+= separator + mySheet.GetCellValue(i,"PO_NO") + commaSeparator + mySheet.GetCellValue(i,"PO_SEQ") + commaSeparator
											+ mySheet.GetCellValue(i,"DS_SEQ") + commaSeparator + mySheet.GetCellValue(i,"SEQ");
					}
				}
			}
			st_popup_param = st_com_code_param + paramSeparator + st_com_code_name_param + paramSeparator + st_po_no_param + paramSeparator
							+ st_po_seq_param + paramSeparator + st_ds_seq_param + paramSeparator + st_sent_seq_param + paramSeparator + st_dm_issue_param;
			openSearchPopupAppendPost("agentDmSendPopForm",st_popup_url,st_popup_param,st_popup_option);
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	var st_popup_url = "";
	var st_popup_param = "";
	var st_popup_option = "";
	
	grbRow = Row;
	
	if (column == "TYPE_TEXT" ){
		st_popup_url = "/mpso/masterMpSoIssueManageRemarkPop.do";
		st_popup_param = "st_buyer@@"+mySheet.GetCellValue(Row,"BUYER")+"^||^st_po_no@@"+mySheet.GetCellValue(Row,"PO_NO")+"^||^st_po_seq@@"+mySheet.GetCellValue(Row,"PO_SEQ");
		st_popup_option = "1000,800,no";
		
		openSearchPopupAppendPost("IssueRemarkPopForm",st_popup_url,st_popup_param,st_popup_option);
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}

	if (current_page==-1) {
		makePageIndex2(mySheet, 1, document.searchForm.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchForm.onepagerow.value);	
	}
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchForm ,  mySheet , "/mpso/getMasterMpSoAgentPoMngPop.do?page="+current_page , pagingMode );
}
</script> 
<body onload="kep_onload_view()">
	<form name=searchForm id=searchForm method=post >
		<input type="hidden" name="codeGubun" id="codeGubun" value="masterMpSoAgentPoMngPop"> 
		<input type="hidden" name="st_com_code"  id="st_com_code" value="<%=st_com_code%>" onkeydown="kepEnter()" />
		
		<input type="hidden" id="st_user_id" name="st_user_id" value="<%=userId%>">
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" id="onepagerow" name="onepagerow" value="10">
		<input type="hidden" id="pageflag" name="pageflag" value="1">
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div id="popWrapper" >
			<div id="popHeader">
				<h1 class="title">협력사 정보</h1>
            	<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	        </div>
        
        	<!--팝업내용입니다-->
        	<div id="popContainer" >
				<h2>협력사 정보</h2>

				<table  class="cont_t_list06 mb15" summary="회원사" style="width:100%;">
					<caption>회원사</caption>
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="*" />
					</colgroup>
					<tbody>
	    				<tr>
							<th scope="row">회원사 코드</th>
							<td colspan="3"><font color="blue"><b><%=st_com_code%></b></font></td>
						</tr>
						<tr>
							<input type="hidden" name="st_agent_name"  id="st_agent_name" value="<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%>"/>
				    		<th scope="row">회원사명(한글)</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></td>
				    		<th scope="row">회원사명(영문)</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("COM_NAME_ENG"))%></td>
						</tr>
						<tr>
							<th scope="row">사업자등록번호</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("IRS_NO"))%></td>
							<th scope="row">대표자명</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("CEO_NAME_LOC"))%></td>
						</tr>
						<tr>
							<th scope="row">대표전화번호</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("TEL_NO"))%></td>
							<th scope="row">대표팩스번호</th>
							<td scope="row"><%=CommonUtil.nvl(rowData.get("FAX_NO"))%></td>
						</tr>
					</tbody>
				</table>

				<h2>협력사 사용자 정보</h2>
				
				<!--grid-->
				<div class="scrollArea"  style="height:120px">         
					<table  class="cont_t_list02"  style="width:100%">
						<caption>개인정보 리스트</caption>
						<colgroup>
	                        <col width="15%" />  
	                        <col width="25%" />
	                        <col width="25%" />
	                        <col width="*" />
	                    </colgroup>
	                    
	                    <thead>
	                    	<tr>
	                    		<th scope="col">직급</th>
	                    		<th scope="col">사용자명</th>
	                    		<th scope="col">전화번호</th>
	                    		<th scope="col">이메일</th>
							</tr>
						</thead>
					
						<tbody>
	<%
	for (int j=0; j<_dataList2.size(); j++) {
		Map<String,String> _tmp2 = _dataList2.get(j);
	%>
							<tr>
								<td class="center"><%=CommonUtil.nvl(_tmp2.get("POSITION_NAME"))%></td>
								<td class="center"><%=CommonUtil.nvl(_tmp2.get("USER_NAME_LOC"))%></td>
								<td class="center"><%=CommonUtil.nvl(_tmp2.get("PHONE_NUMBER"))%></td>
								<td class="left"><%=CommonUtil.nvl3(_tmp2.get("EMAIL"),"")%></td>
							</tr>
	<% } %>
						</tbody>
					</table>
				</div>
				<div>
					<h2 style="display: inline-block; height: 28px; margin-top: 5px; margin-bottom: 5px;">이슈 상태</h2>
					<span class="btn_06" style="float:right"><a href="javascript:doPop('agentDmSend');">협력사 DM 발송</a></span>
				</div>
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "350px");
					</script>
				</div>
				<div id="pageindex" style="display:none;"></div>
			</div>
		</div>
<%}%>
	</form>
</body>
</html>