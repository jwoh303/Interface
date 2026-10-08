<%--
**********************************************
* 메뉴 : 납품관리 > 납품실적등록 > 엑셀업로드 
* 화면 : 엑셀업로드
* 기능 : 택배송장번호 일괄 엑셀업로드
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2025-10-31
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_id = CommonUtil.nvl((String) request.getParameter("user_id"), _sessionInfo.getUserId());
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var maxAllowRow = 100;	// 등록 허용할 데이터 Row수
var excelRow = 0;

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var parcelComCodeGbn = KepSheetComboData("C019","SEL");
var comboInfo = {ComboCode: parcelComCodeGbn.ComboCode, ComboText:parcelComCodeGbn.ComboText};

//최초 화면 함수
function kep_onload_view(){
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
						{ Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
						,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}
						,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",				Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
						,{ Align:"Center",	SaveName:"BUYER_CODE",			Header:"고객사코드",			Type:"Text",		Width:80,	Edit:false,	EditLen:100, 	Hidden:true}
						,{ Align:"Center",	SaveName:"INV_NO",				Header:"거래명세서번호",			Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
// 						,{ Align:"Center",	SaveName:"PARCEL_COM_NAME",		Header:"택배사",				Type:"Text",		Width:128,	Edit:true,	EditLen:100, 	Hidden:false}
						,{ Align:"Center",	SaveName:"PARCEL_COM_CODE",		Header:"택배사",				Type:"Combo",		Width:165,	Edit:true,	EditLen:100, 	Hidden:false,ComboCode: parcelComCodeGbn.ComboCode, ComboText:parcelComCodeGbn.ComboText}
						,{ Align:"Center",	SaveName:"PARCEL_INV_NO",		Header:"택배송장번호",			Type:"Text",		Width:175,	Edit:true,BackColor:"${optColor}"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHighlightAfterSort(2);
// 	mySheet.SetColProperty("PARCEL_COM_CODE", parcelComCodeGbn);
	
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	
	mySheet.SetTheme("DB", "DeepBlue");
}	

//팝업함수호출
var gridIndex = "";

//기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getSellerMpIvExcelUploadPop_v2.do" , pagingMode );
			break;
			
		case "loadExcel": // 파일 업로드
			mySheet.RemoveAll();
			var params = "";
			
			params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|||1|2|3|4"};
			
			mySheet.LoadExcel(params);
			break;
		case "excelDownload": //양식다운로드
			location.href = "/resources/excel/work/MPIV/SellerMpIvExcelUploadPop.xls";
			break;
	}
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if(excelRow != mySheet.RowCount()){
// 		alert("누락된 데이터가 있습니다. 엑셀파일을 다시 한  확인해 주시기 바랍니다.");
		var text = "누락된 데이터가 있습니다. 엑셀파일을 다시 한  확인해 주시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	var maxRowCount = maxAllowRow + 1;
	
	if(mySheet.RowCount() == 0){
// 		alert("일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.");
		var text = "일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else{
		if(maxRowCount < mySheet.RowCount() + 1) {
// 			alert(maxAllowRow + "건 이하의 파일만 업로드하여 주세요.");
			var text = maxAllowRow + "건 이하의 파일만 업로드하여 주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			mySheet.RemoveAll();
			return;
		}else{
			excelRow = mySheet.RowCount(); //엑셀 업로드 라인 수 저장
			kepSaveAll(document.searchCondition ,  mySheet , "/mpiv/setMpIvExcelUp_v2.do" , "SELECTED" );
		}
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	} 
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnParcel"){
// 		alert("택배사 정보가 정상적으로 등록되었습니다.");
		var text = "택배사 정보가 정상적으로 등록되었습니다.";
		var but1funcTmp = "javascript:delMpIvExcelUp();return false;";
		openLayerPopText2(text,but1text,but1funcTmp,but1width);
	}	

	if(pMethod == "delete"){
		parent.doAction("search");
		parent.closePop();
	}
	return;
}
function delMpIvExcelUp(){
	closePopText2();
	kepAjaxFormCall("/mpiv/delMpIvExcelUp.do","searchCondition","delete");
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response){
// 	alert("택배사 정보 등록에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.");
	var text = "택배사 정보 등록에 실패하였습니다.</br>관리자에게 문의하여 주시길 바랍니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
}

//택배사정보등록
function setParcel(){
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	if(checkRows.length == 0){
// 		alert("선택된 항목이 없습니다.");
		var text = "선택된 항목이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var query = "";
	
	for(var idx = 0; idx<arrRow.length; idx++){
		var buyer_name = mySheet.GetCellValue(arrRow[idx],"BUYER_NAME");
		var buyer = mySheet.GetCellValue(arrRow[idx],"BUYER_CODE");
		var parcel_com_code = mySheet.GetCellValue(arrRow[idx],"PARCEL_COM_CODE");
		var parcel_inv_no = mySheet.GetCellValue(arrRow[idx],"PARCEL_INV_NO");
		var inv_no = mySheet.GetCellValue(arrRow[idx],"INV_NO");
		// 고객사명 체크
		if(isEmpty(buyer_name)){
// 			alert((idx+1)+"번째 행의 고객사코드를 확인하여 주십시오.");
			var text = (idx+1)+"번째 행의 고객사코드를 확인해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		// 택배사명 체크
		if(isEmpty(parcel_com_code)){
// 			alert((idx+1)+"번째 행의 택배사를 확인하여 주십시오.");
			var text = (idx+1)+"번째 행의 택배사를 확인해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		// 택배송장번호 체크
		if(!alphaNumChk(parcel_inv_no) || isEmpty(parcel_inv_no)){
// 			alert((idx+1)+"번째 행의 택배송장번호는 영문, 숫자만 입력가능합니다.");
			var text = (idx+1)+"번째 행의 택배송장번호는 영문, 숫자만 입력가능합니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		query +=  buyer					+ "@@";
		query +=  inv_no					+ "@@";
		query +=  parcel_com_code	+ "@@";
		query +=  parcel_inv_no;
		query +=  "^||^" ;
	}
	document.forms["searchCondition"].st_query.value  = query;
	
// 	if(!confirm("택배사정보를 등록 하시겠습니까?")) return;
	var text = "택배사정보를 등록 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpIvDeliveryRecordParcelRegList(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "110px";
	var but2widthC = "110px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
	
// 	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordParcelRegList.do","searchCondition","btnParcel");
}

function saveSellerMpIvDeliveryRecordParcelRegList(){
	closePopText1();
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryRecordParcelRegList.do","searchCondition","btnParcel");
}
// 택배송장번호 영문과 숫자만 사용
function alphaNumChk(text) {
	
	var input = text; 	
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    
    for (var inx = 0; inx < input.length; inx++) {
        if (chars.indexOf(input.charAt(inx)) == -1){
            return false;
        }
     }
     return true;
}

</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">엑셀업로드<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <form name = "searchCondition" id="searchCondition" method = "post">
  <div class="FileUploadBox mt15">
		   		<input type="hidden" name="s_SAVENAME">
		   		<input type="hidden" id="st_com_code" name="st_com_code" value="${sessionInfo.comCode}">
	    		<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
	    		<input type="hidden" name="st_query" id="st_query" value ="">
<!--     <input type="text" id="fileName" placeholder="선택된 파일이 없습니다." readonly /> -->
    <button class="But_ExcelDown40" onclick="javascript:doAction('excelDownload'); return false;">양식다운로드</button>
    <div style="right: 20px; position: absolute;"><button id="selectFileBtn" class="ButDarkGray_Medium" onclick="javascript:doAction('loadExcel'); return false;">파일 선택</button></div>
<!--     <input type="file" id="files"/> -->
  </div>
   <div class="h50" style="height: 30px;"></div> 
  <div class="IBSheetPopup" style="width:700px; height:350px;">
  <script type="text/javascript">
         createIBSheet("mySheet", "", "100%");
  </script>
  </div>
  </form>
  <div class="PopupListBtnBox_Center mt15" style="width:700px;">
<!--     <button class="ButQuaternary_large" >취소</button> -->
    <button class="ButPrimary_large" onclick="javascript:setParcel(); return false;">적용</button>
  </div>

</div><!-- warp 끝-->

</body>
</html>
