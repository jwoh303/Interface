<%--
**********************************************
* 메뉴 : 주문관리>장바구니 업로드
* 화면 : 장바구니 업로드
* 기능 : 엑셀파일과 그리드를 이용하여 장바구니 업로드
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2018-02-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
    SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String com_code = sessionInfo.getComCode();
	String budget_flag = sessionInfo.getBudgetFlag();     // 고객사 예산 사용여부
	
	String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
	
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var maxAllowRow = 1000;	// 추천을 허용할 데이터 Row수

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
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
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
	
	// 최초 화면 완성 시 조회
	doAction('search');
}

// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	// 선택된 항목 유무 체크
	if (str =="deleteRows" && selectedGrid.length == 0) {
		//선택된 항목이 없습니다.
		alert("<%=CommonLang.msg("MSG78") %>");
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
			
		case "setCartAddReg": // 장바구니 담기
			setCartAddReg();
			break;
			
		case "deleteCartTmp": // 삭제
			kepSave(document.searchCondition ,  mySheet , "/mpso/delBuyerMpSoExcelUpload.do" , "SELECTED" );
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
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
		alert(msg);
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
		alert("<%=CommonLang.msg("MSG467") %>");
	}else{
		if(maxRowCount < mySheet.RowCount() + 1) {
			//건 이하의 파일만 업로드하여 주세요.
			alert(maxAllowRow + "<%=CommonLang.msg("MSG468") %>");
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
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	} 
}

function setCartAddReg(){
	var dup_add_posb_yn = "<%=dup_add_posb_yn%>";
	var budget_check_err_flag = "N";
	
	for(var i=1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i, "SELECTED") == 1){
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
					alert(remark + " <%=CommonLang.msg("MSG472") %> \nLine No." + eval(i));
					return;
				}
			}else{
				if(remark != ''){
					//건은 장바구니 등록할 수 없습니다.
					alert(remark + " <%=CommonLang.msg("MSG472") %> \nLine No." + eval(i));
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
				alert("<%=CommonLang.msg("MSG588")%> \nLine No." + eval(i)); //주문할 수 없는 카테고리의 상품입니다.
				return;
			}
		}
	}
	
	if(budget_check_err_flag == "Y"){
		// 사용 불가한 예산정보는 장바구니 내에서 다시 선택하셔야 합니다.
		alert("<%=CommonLang.msg("MSG596")%>");
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mpso/setExcelIcomcartAdd.do" , "SELECTED");
}

</script>
</head>
<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 
	<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
		<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="buyerLeft"/>
			<c:param name="part" value="${param.upperId}"/>
		</c:import>

		<!--내용 시작-->
		<div id="container2">
		<div id="ContArea" style="width: 97%;">
		
			<h3><%=CommonLang.get("HTITLE179") %><!-- 장바구니 업로드 --></h3>
    		<div id="searchBtnA">
				<!--버튼영역-->
	   		</div>   
	   	
	   		<form name = "searchCondition" method = "post">
		   		<input type="hidden" name="s_SAVENAME">
		   		<input type="hidden" id="buyer" name="buyer" value="${sessionInfo.comCode}">
	    		<input type="hidden" id="userid" name="userid" value="${sessionInfo.userId}">
	    		<input type="hidden" id="cart_type" name="cart_type" value="<%=budget_flag%>">
	    		
	    		<!--grid-->
   				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "490px");
	  				</script>
  				</div>
	
	  			<br>
  			
  				<!--버튼영역-->
				<div class="btnArea">
					<span class="fl">
	 					<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');"><%=CommonLang.get("HTITLE34") %><!-- 엑셀업로드 --></a></span>
	 					<span class="btn_03 mr04">
	 						<%if(budget_flag.equals("Y")){%>
								<a href="/resources/excel/cart_template_budget.xls"><%=CommonLang.get("HTITLE183") %><!-- 등록양식 --></a>
							<%}else{%>
								<a href="/resources/excel/cart_template.xls"><%=CommonLang.get("HTITLE183") %><!-- 등록양식 --></a>
							<%}%>
						</span>
	 					&nbsp;※ <b><font color="red"><%=CommonLang.get("HTITLE848") %><!-- 엑셀업로드 시 등록양식을 다운받은 후 기입하여 주시기 바랍니다. --></font></b>
	 				</span>
			
	 	          	<span class="fr">
	 	          		<span class="btn_03 mr04"><a href="javascript:doAction('setCartAddReg');"><%=CommonLang.get("HTITLE11") %><!-- 장바구니담기 --></a></span>
	 					<span class="btn_02 mr04"><a href="javascript:doAction('deleteCartTmp');"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></a></span>
	 				</span> 
	 			 </div>
			</form>

<!--내용 종료-->
		</div>
	</div>

<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>

</body>
</html>
