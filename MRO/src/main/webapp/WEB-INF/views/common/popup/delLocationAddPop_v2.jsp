<%--
**********************************************
* 메뉴 : 배송주소(도착지) 추가 팝업
* 화면 : 배송주소(도착지) 추가 팝업
* 기능 : 배송주소(도착지) 추가 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-03-12
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건) 
String del_code = CommonUtil.nvl((String) request.getParameter("del_code"),"");  //  (조회조건) 
String del_name = CommonUtil.nvl((String) request.getParameter("del_name"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String st_delyto_field = CommonUtil.nvl((String) request.getParameter("st_delyto_field"),"");  //결과내재검색
String st_check = CommonUtil.nvl((String) request.getParameter("st_check"),"");  //결과내재검색

%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [ 
	         		 { Align:"Center", Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"<%=CommonLang.get("HTITLE255")%>",				SaveName:"sStatus"}/*상태*/
	         		,{ Align:"Center",	Width:40,		Edit:false,	EditLen:30,	Hidden:true,	Type:"Text",				Header:"<%=CommonLang.get("HTITLE140")%>",				SaveName:"RN"}/*순번*/
	         		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
	         		,{ Align:"Left",	Width:80,		Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"<%=CommonLang.get("HTITLE371")%>",				SaveName:"CODE",			KeyField:true}/*코드*/
	         		,{ Align:"Left",	Width:200,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"<%=CommonLang.get("HTITLE372")%>",			SaveName:"TEXT1",			KeyField:true}/*도착지명*/
	         		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"<%=CommonLang.get("HTITLE343")%>",			SaveName:"ZIP_CODE",		KeyField:true,FontColor:"#3a72c7", Cursor:"Pointer"}/*우편번호*/
	         		,{ Align:"Left",	Width:400,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"<%=CommonLang.get("HTITLE373")%>",		SaveName:"ADDRESS01",	KeyField:true}/*도착지주소*/
	         		,{ Align:"Left",	Width:400,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"<%=CommonLang.get("HTITLE374")%>",	SaveName:"ADDRESS02"}/*도착지상세주소*/
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"ORG_CODE",		SaveName:"ORG_CODE"}
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT2",				SaveName:"TEXT2"}
	         		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"ZIP_KEY",			SaveName:"TEXT3"}
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT4",				SaveName:"TEXT4"}
	         	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

// 기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdAmMasterCodeManageList.do" , pagingMode);
			break;
		case "add": // 추가
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "SELECTED", "1");	
			break;
			
		case "save": // 저장
			var selectedGrid = "";
			selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				var text = "<%=CommonLang.msg("MSG78")%>"; //선택된 항목이 없습니다.
				openLayerPopText2(text,but1text,but1func,but1width);

				return;
			}
			
			for(var i = 0 ; i<arrRow.length; i++){
				if(mySheet.GetCellValue(arrRow[i],"") == "CODE" || mySheet.GetCellValue(arrRow[i],"") == "TEXT1" || mySheet.GetCellValue(arrRow[i],"ZIP_CODE") == "" || mySheet.GetCellValue(arrRow[i],"ADDRESS01") == ""){
					var text = "<%=CommonLang.msg("MSG716")%>"; //코드, 도착지명, 우편번호, 도착지주소를 입력해주세요
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}
			var text = "<%=CommonLang.msg("MSG292")%>";//선택한 항목을 저장 하시겠습니까?
        	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
        	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
        	var but1funcC = "javascript:saveMasterMdAmMasterCodeManageList(); return false;";
        	var but2funcC = "javascript:closePopText1(); return false;";
        	var but1widthC = "120px";
        	var but2widthC = "120px";
        	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
        	
        	break;
	}
}

function saveMasterMdAmMasterCodeManageList(){
	closePopText1();
	beforeProcessSave();
	kepSave(document.searchCondition ,  mySheet , "/mdam/saveMasterMdAmMasterCodeManageList.do" , "SELECTED" );
}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		var zip_code_04 = mySheet.GetCellValue(i, "TEXT4");
		var zip_code_02 = mySheet.GetCellValue(i, "TEXT2");
		var zip_arr = new Array();
		var chkSpace6 = zip_code_02.substring(5,6);
		zip_arr = zip_code_04.split("@");
		
		if ( zip_code_04 != '' ) {
			mySheet.SetCellValue(i, "ZIP_CODE", zip_arr[0]);
			mySheet.SetCellValue(i, "ADDRESS01", zip_arr[1]);
			mySheet.SetCellValue(i, "ADDRESS02", zip_arr[2]);
		}
		else {
			if(chkSpace6 ==" "){
				mySheet.SetCellValue(i, "ZIP_CODE", zip_code_02.substring(0,5));
				mySheet.SetCellValue(i, "ADDRESS01", zip_code_02.substring(6));				
			}else{
				mySheet.SetCellValue(i, "ZIP_CODE", zip_code_02.substring(0,7));
				mySheet.SetCellValue(i, "ADDRESS01", zip_code_02.substring(8));				
			}
			
		}
	}

}

function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
    if(column=='CODE'){
    	var dupIdx = mySheet.ColValueDup("CODE");
    	if(dupIdx > -1){
        	var text = "<%=CommonLang.msg("MSG294")%>";//입력하신 코드는 이미 존재합니다.
    		openLayerPopText2(text,but1text,but1func,but1width);
        	mySheet.SetCellValue(dupIdx,"CODE",'');
        	return;
    	}
    }
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}
//저장 선행 처리
function beforeProcessSave() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			var tempText2 = mySheet.GetCellValue(i, "ZIP_CODE") + ' ' + mySheet.GetCellValue(i, "ADDRESS01") + ' ' + mySheet.GetCellValue(i, "ADDRESS02");
			var tempText4 = mySheet.GetCellValue(i, "ZIP_CODE") + '@' + mySheet.GetCellValue(i, "ADDRESS01") + '@' + mySheet.GetCellValue(i, "ADDRESS02");
			mySheet.SetCellValue(i, "TEXT2", tempText2);
			mySheet.SetCellValue(i, "TEXT4", tempText4);
		}
	}
}

// 행삭제 선행 처리
function beforeProcessDelete() {
	for ( var i = mySheet.RowCount(); i >= 1; i-- ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "sStatus") == 'I' ) {
			mySheet.RowDelete(i, 0);
		}
	}
	
	if ( mySheet.FindCheckedRow("SELECTED").length == 0 ) {
		return false;
	}
	
	return true;
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'ZIP_CODE') { // 우편번호
		doPop("newzipcode"	);
	}

	return;
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481");
			break;
		case "buyer_single": // 고객사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
	}
}
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	// 팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") { // 단일 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}

	grbRow="";	// 초기화
}
 
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	mySheet.SetCellValue(grbRow, "ZIP_CODE", zipNo.replace(/[^0-9]/gi, ''));
	mySheet.SetCellValue(grbRow, "TEXT3", bdMgtSn);
	mySheet.SetCellValue(grbRow, "ADDRESS01", roadAddrPart1 + " " + roadAddrPart2);
	mySheet.SetCellValue(grbRow, "ADDRESS02", addrDetail);
}
</script>

<body onload="kep_onload_view();">
	 <form name="searchCondition" id="searchCondition" method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
	 <input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	 <input type="hidden" id="st_type" name="st_type"  value="C012">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1087") %><!-- 배송주소 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table  class="PopupSearchTable mt10" width="100%">
	<colgroup>
      <col width="50px" />
      <col width="340px" />
      <col width="120px" />
      <col width="390px" />
	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th>
      <td><div class="SearchPopupInput" style="width:260px;">
        <input type="text" name="st_code" id="st_code" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>     </td>
      <th><%=CommonLang.get("HTITLE488") %><!-- 도착지(명,주소) --></th>
      <td><div class="SearchPopupInput" style="width:390px;">
        <input type="text" name="st_name" id="st_name" value="" onKeyDown="kepEnter_v2()" style=" width:85%; ">
      </div>    </td>
    </tr>
  </table>
  <div class="h15"></div>
  	<div style="height:350px; width: 1150px;">
        	<script type="text/javascript">
				createIBSheet("mySheet", "100%", "100%");
			</script>
		</div>
		<!-- 이 부분 추후 디자인 받고 버튼 교체 -->
		 <div class="h10"></div>
		<div class="btnArea">
			<span class="fl">
			</span>
	  				
			<span class="fr">
				<button class="ButOutline_Medium" style="width:120px" onclick="javascript:doAction('add'); return false;"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></button> 
    			<button class="ButOutline_Medium" style="width:120px" onclick="javascript:doAction('save'); return false;"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></button> 
<%-- 				<span class="btn_02 mr04"><a href="javascript:doAction('add');"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></a></span> --%>
<%-- 				<span class="btn_02 mr04"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a></span> --%>
			</span>
		</div>
</div><!-- warp 끝-->
</form> 
</body>
</html>
