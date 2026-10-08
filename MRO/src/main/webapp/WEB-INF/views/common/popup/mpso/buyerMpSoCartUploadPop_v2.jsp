<%--
**********************************************
* 메뉴 : 예산편성 > 일괄편성 팝업
* 화면 : 예산편성 > 일괄편성 팝업
* 기능 : 예산편성 > 일괄편성 팝업
* 프로그램 ID : BU1005012
* 담당자 : 최찬규
* 착수일 : 2026-03-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
    SessionInfo sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String com_code = sessionInfoPop.getComCode();
	String budget_flag = sessionInfoPop.getBudgetFlag();     // 고객사 예산 사용여부
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
  	boolean p060000072 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000072");

	String dup_add_posb_yn = "N";

	if(p060000072 == true){
		dup_add_posb_yn = "Y";
	}
	//SLOGIC-END
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<script>
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var maxAllowRow = 1000;	// 업로드 허용할 데이터 Row수

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cols = [
	                  {Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"<%=CommonLang.get("HTITLE255") %>",	SaveName:"sStatus"}, /* 상태 */
	                  {Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",									SaveName:"SELECTED"},
	                  {Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE12") %>",	SaveName:"BUYER_ITEM_NO"},	/* 품목코드 */
	                  {Align:"Left",	Width:150,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE13") %>",	SaveName:"DESCRIPTION_LOC"},	/* 품목명 */
	                  {Align:"Left",	Width:180,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE14") %>",	SaveName:"SPECIFICATION"},	/* 규격 */
	                  {Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE567") %>",	SaveName:"AGENT_NAME"},	/* 협력사명 */
	                  {Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE45") %>",	SaveName:"CART_QTY"},	/* 수량 */
	                  {Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE18") %>",	SaveName:"REF_PR_NO"},	/* 관리번호 */
	                  {Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE568") %>",	SaveName:"BUDGET_DEPT"},	/* 예산부서코드 */
	                  {Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE420") %>",	SaveName:"BUDGET_DEPT_NAME"},	/* 예산부서명 */
	                  {Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE386") %>",	SaveName:"ACCOUNT_TYPE"},	/* 계정코드 */
	                  {Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE267") %>",	SaveName:"ACCOUNT_TYPE_NAME"},	/* 계정명 */
	                  {Align:"Left",	Width:200,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE122") %>",	SaveName:"REMARK"},	/* 비고 */
	                  {Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE140") %>",	SaveName:"SEQ"},	/* 순번 */
	                  {Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"<%=CommonLang.get("HTITLE975") %>",	SaveName:"URCT2_YN"}	/* URCT2 여부 */
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetHighlightAfterSort(2);
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	
// 	doAction('search');
}
	
var st;
var mt;

// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	// 선택된 항목 유무 체크
	if (str =="deleteRows" && selectedGrid.length == 0) {
		//선택된 항목이 없습니다.
		var text = "<%=CommonLang.msg("MSG78")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getBuyerMpSoCartExcelUploadList.do" , pagingMode );
			break;
			
		case "loadExcel": // 파일 업로드
			mySheet.RemoveAll();
			var params = "";
			
			if("<%=budget_flag%>" == "Y"){ // cart_template_budget
				params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||||2|3|4||5|||||"};
			}else{ // cart_template
				params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||||2|3|||||||"};
			}
			
			mySheet.LoadExcel(params);
			break;
			
		case "excelDown":
			<%if(budget_flag.equals("Y")){%>
				location.href="/resources/excel/cart_template_budget.xls";
			<%}else{%>
				location.href="/resources/excel/cart_template.xls";
			<%}%>
			
			
			break;
		case "setCartAddReg": // 장바구니 담기
			setCartAddReg();
			break;
			
		case "deleteCartTmp": // 삭제
			kepSave(document.searchCondition ,  mySheet , "/mpso/delBuyerMpSoExcelUpload.do" , "SELECTED" );
			break;
	}
}
function kepAjaxSuccess(pMethod , response){
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
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
	var maxRowCount = maxAllowRow + 1;
	
	if(mySheet.RowCount() == 0){
		//일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.
		var text = "<%=CommonLang.msg("MSG467")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else{
		if(maxRowCount < mySheet.RowCount() + 1) {
			//건 이하의 파일만 업로드하여 주세요.
			var text = maxAllowRow + "<%=CommonLang.msg("MSG468")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			mySheet.RemoveAll();
			return;
		}else{
			kepSaveAll(document.searchCondition ,  mySheet , "/mpso/saveBuyerMpSoExcelUpload.do" , "SELECTED" );
		}
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		var text = msg;
		if(code>=0){
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
			return;
		} 
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	} 
}
function thisPopClose(){
	closePopText2();
	
	doAction('search');
}

function setCartAddReg(){
	var dup_add_posb_yn = "<%=dup_add_posb_yn%>";
	var budget_check_err_flag = "N";
	
	var cnt = 0;
	for(var i=1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i, "SELECTED") == 1){
			cnt++;
			var budget_chk = mySheet.GetCellValue(i, "BUDGET_DEPT_NAME");
			var account_chk = mySheet.GetCellValue(i, "ACCOUNT_TYPE_NAME");
			var ref_pr_chk = mySheet.GetCellValue(i, "REF_PR_NAME");
			var remark = mySheet.GetCellValue(i, "REMARK");
			var urct2_yn = mySheet.GetCellValue(i, "URCT2_YN");

			// 중복가능여부, 비고 확인
			if(dup_add_posb_yn == "Y"){
				if(remark == 'Excel데이타 중복품목 존재' || remark == '장바구니에 대상품목 기존재' || remark == ''){
				}else{
					//건은 장바구니 등록할 수 없습니다.
					var text = remark + " <%=CommonLang.msg("MSG472") %>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}else{
				if(remark != ''){
					//건은 장바구니 등록할 수 없습니다.
					var text = remark + " <%=CommonLang.msg("MSG472") %>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				if("<%=budget_flag%>" == "Y"){ // 예산 사용 고객사 경우 예산정보 체크
					if(budget_chk == "코드없음" || budget_chk == "예산정보 매핑오류" || account_chk == "코드없음" || account_chk == "예산정보 매핑오류"){
						budget_check_err_flag = "Y";
					}	
				}
			}
			
			//URCT2 여부 확인
			if(urct2_yn == "N"){
				//주문할 수 없는 카테고리의 상품입니다.
				var text = "<%=CommonLang.msg("MSG588")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}
	}
	
	if(cnt == 0){
		//등록할 항목을 선택해주세요
		var text = "<%=CommonLang.msg("MSG954")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(budget_check_err_flag == "Y"){
		// 사용 불가한 예산정보는 장바구니 내에서 다시 선택하셔야 합니다.
		var text = "<%=CommonLang.msg("MSG596")%>";
		openLayerPopText2(text,but1text,"javascript:addContinue();return false;",but1width);
		return;
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mpso/setExcelIcomcartAdd.do" , "SELECTED");
}
function addContinue(){
	closePopText2();
	
	kepSave(document.searchCondition ,  mySheet , "/mpso/setExcelIcomcartAdd.do" , "SELECTED");
	
}
</script>
</head>

<body onload="kep_onload_view()">

<!--내용 시작-->
<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE179") %><!-- 장바구니 업로드 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
<%--     <div class="BudgetExcelBoxTxt mb10"><%=CommonLang.msg("MSG732")%><!--1. 일괄편성을 위하여 작성하실 기간을 선택하여 양식을 다운로드 해주세요--><br /><%=CommonLang.msg("MSG733")%><!--2. 작성한 양식을 업로드해주세요. 편성기간과 양식 내 기재된 기간이 일치하지 않을 경우, 금액이 0원으로 표시됩니다.--></div> --%>
    <div class="BudgetExcel">
  <form name = "searchCondition" method = "post">
    	<input type="hidden" name="s_SAVENAME">
   		<input type="hidden" id="buyer" name="buyer" value="${sessionInfo.comCode}">
   		<input type="hidden" id="userid" name="userid" value="${sessionInfo.userId}">
   		<input type="hidden" id="cart_type" name="cart_type" value="<%=budget_flag%>">     
      <div class="ArraySub mt30 mb10" style="width: 1325px;">
      <div class="buttonLeft">
	      <button class="But_ExcelDown40" onclick="javascript:doAction('excelDown'); return false;"><%=CommonLang.get("HTITLE35")%><!-- 양식다운로드 --></button> <button class="ButDarkGray_Medium ml05" onclick="doAction('loadExcel');return false;"><%=CommonLang.get("HTITLE1155")%><!--파일업로드--></button>
      </div>
      <div class="buttonRight">
      		<button class="ButQuaternary_large" onclick="javascript:doAction('deleteCartTmp'); return false;"><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></button> <button class="ButPrimary_large ml05" onclick="doAction('setCartAddReg');return false;"><%=CommonLang.get("HTITLE11") %><!-- 장바구니담기 --></button>
      </div>
      </div>
    </div>
  <div class="ScrollBox mt20 " style="height:400px">
      <script type="text/javascript">
		createIBSheet("mySheet", "100%", "100%");
	  </script>
  </div>
  </form>  
<!--   <div class="PopupListBtnBox_Center mt50" ><button class="ButPrimary_large"  onclick="javascript:doAction('save');return false;">저장</button></div>   -->
</div><!-- warp 끝-->
</body>
</html>
