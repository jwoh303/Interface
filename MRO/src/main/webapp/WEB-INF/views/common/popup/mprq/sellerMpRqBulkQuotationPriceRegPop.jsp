<%--
**********************************************
* 메뉴 : 벌크 견적요청 접수 > 단가 업로드
* 화면 : 벌크소싱 품목 별 대체제안으로 단가 업로드
* 기능 : 1000px
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String burq_no = CommonUtil.nvl((String) request.getParameter("st_burq_no"),"");
	String project_name = CommonUtil.nvl((String) request.getParameter("st_project_name"),"");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var checkFlag = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		{Align:"Center",	Width:30,	Edit:false,	EditLen:0,		Hidden:false,	Type:"Seq",		Header:"NO",		SaveName:"SEQ"},
		{Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",		SaveName:"BURQ_RFQ_NO"},
		{Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단가",		SaveName:"CH_LIST_PRICE"},
		{Align:"Center",	Width:280,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"결과",	SaveName:"RESULT"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	if(!isEmpty("<%=burq_no%>")){
		$("#st_burq_no").val("<%=burq_no%>");
		$("#st_project_name").val("<%=project_name%>");
		var data = { st_burq_no : "<%=burq_no%>"};
// 		kepAjaxCallNoBar("/mprq/getProjectRemark.do",data,"burqremark"); 
	}
}	
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "burqremark"){
		var list = response.list;
		var remarkStr = '';
		for(var i = 0; i < list.length; i++){
			remarkStr += '▪ ' + list[i].NOTICE_REMARK + '<br>';	
		}
		document.getElementById("remark").innerHTML = remarkStr;
	}else if(pMethod =="save"){
// 		alert("단가 업로드가 완료되었습니다.");
		var text = "단가 업로드가 완료되었습니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

//기능함수
function doAction(str) {
	
	var project = $("#st_burq_no").val();
	if(isEmpty(project)){
// 		alert("프로젝트를 선택하시기 바랍니다.");
		var text = "프로젝트를 선택하시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	switch (str) {
		case "loadExcel": // 파일 업로드
			mySheet.RemoveAll();
			var params = { Mode : "NoHeader", StartRow: "3", ColumnMapping:"|1|2||"};
			mySheet.LoadExcel(params);
			checkFlag= "N";
			break;
		case "downForm" : // 양식 다운로드
			location.href = "/resources/excel/work/NEWSOURCING/sellerMpRqBulkQuotationPriceRegExcel.xlsx";
			break;
		case "downExcel": // 조회결과 다운로드
			var param = {FileName:"단가업로드.xls", HiddenColumn:1};
			mySheet.Down2Excel(param);
			break;
		case "checkExcel": // 업로드 결과 확인
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mprq/checkSellerMpRqBulkQuotationPriceRegPop.do", pagingMode);
			checkFlag= "Y";
			break;			
		case "save": // 등록
			if(mySheet.RowCount() == 0){
// 				alert("업로드 후 진행하시기 바랍니다.");
				var text = "업로드 후 진행하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(checkFlag != "Y"){
// 				alert("업로드 결과 확인 후 진행하시기 바랍니다.");
				var text = "업로드 결과 확인 후 진행하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			var maxRow = mySheet.RowCount() + 1; 
		    for(var i = 1; i < maxRow; i++){
		    	var result = mySheet.GetCellValue(i,"RESULT");
		    	if(result != "정상"){
// 		    		alert(i+":"+result+ "결과가 정상이 아닌 정보가 있습니다. 다시 엑셀 업로드 후 하시기 바랍니다.");
		    		var text = i+":"+result+ "결과가 정상이 아닌 정보가 있습니다. 다시 엑셀 업로드 후 하시기 바랍니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
		    		return;
		    	}
		    }
			    
// 			if(!confirm("입력하신 정보를 등록하시겠습니까?")){
// 				return;
// 			}
			var text = "입력하신 정보를 등록하시겠습니까?";
			var but1textC = "확인";
			var but2textC = "취소";
			var but1funcC = "javascript:saveSellerMpRqBulkQuotationPriceRegPop(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "80px";
			var but2widthC = "80px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
// 		    kepAjaxFormCall("/mprq/saveSellerMpRqBulkQuotationPriceRegPop.do","searchCondition","save");
			break;
	}
}
function saveSellerMpRqBulkQuotationPriceRegPop(){
	closePopText1();
	kepAjaxFormCall("/mprq/saveSellerMpRqBulkQuotationPriceRegPop.do","searchCondition","save");
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	var maxRow = mySheet.RowCount() + 1; 
    for(var i = 2; i <= maxRow; i++){
    	var result = mySheet.GetCellValue(i,"RESULT");
    	if(result != "정상"){
    		mySheet.SetRowBackColor(i,"#FFD966");
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
	
}
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	if(mySheet.RowCount() == 0){
		//일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.
// 		alert("일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.");
		var text = "일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else{
// 		document.getElementById("cnt").innerHTML = mySheet.RowCount();
		kepSaveAll(document.searchCondition,  mySheet, "/mprq/batchSellerMpRqBulkQuotationPriceRegPop.do");		
	}
}
function thisPopClose(){
	closePopText2();
	setReturn('1');
}
function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9)
{ 
  parent.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  parnet.closePop();
}
</script>
</head>
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">단가 업로드<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
<!--   <div class="Importance_Popup" style="width:540px; height:30px;line-height:30px; vertical-align: middle;" id="remark" name="remark" ></div> -->
<!--   <div class="h15"></div> -->
  <table class="PopTableThLTdL" style="width:100%">
    <colgroup>
      <col width="25%" />
      <col width="75%" /> 
    <tr>
      <th>프로젝트</th>
      <td><%=project_name %></td>
    </tr>
    <tr>
      <th>파일 업로드</th>
      <td><button class="But_ExcelDown40" onclick="javascript:doAction('downForm'); return false;" style="height:30px; line-height: 30px; background-position: 7px 3px; ">양식다운로드</button>&nbsp;&nbsp; <button id="selectFileBtn" class="ButM_Outline" onclick="javascript:doAction('loadExcel'); return false;"style="height:30px;line-height: 30px; ">파일 선택</button>&nbsp;&nbsp;<button id="selectFileBtn" class="ButDarkGray_Medium" onclick="javascript:doAction('checkExcel'); return false;" style="width: 130px; height:30px;line-height: 30px; ">업로드 결과 확인</button></td>
    </tr>
  </table>
  <div class="h50" style="height: 15px;"></div>
  <form name = "searchCondition" id="searchCondition" method = "post">
  <div style="width:470px;height: 45px;">
		   		<input type="hidden" name="s_SAVENAME">
				<input type="hidden" name="st_burq_no" id="st_burq_no" value="">
    <button class="But_ExcelDown40" onclick="javascript:doAction('downExcel'); return false;">조회결과 다운로드</button>
    <div style="right: 20px; position: absolute;">
<!--     <button id="selectFileBtn" class="ButDarkGray_Medium" onclick="javascript:doAction('checkExcel'); return false;" style="width: 130px;">업로드 결과 확인</button> -->
<!--     <button id="selectFileBtn" class="ButDarkGray_Medium" onclick="javascript:doAction('loadExcel'); return false;">파일 선택</button> -->
    </div>
<!--     <input type="file" id="files"/> -->
  </div>
<!--    <div class="h50" style="height: 10px;"></div>  -->
  <div class="IBSheetPopup" style="width:570px; height:350px;">
  <script type="text/javascript">
         createIBSheet("mySheet", "", "100%");
  </script>
  </div>
  </form>
  <div class="PopupListBtnBox_Center mt15" style="width:560px;">
<!--     <button class="ButQuaternary_large" >취소</button> -->
    <button class="ButPrimary_large" onclick="javascript:doAction('save'); return false;">등록</button>
  </div>

</div><!-- warp 끝-->

</body>

</html>
