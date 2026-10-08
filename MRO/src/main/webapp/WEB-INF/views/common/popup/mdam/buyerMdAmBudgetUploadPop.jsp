<%--
**********************************************
* 메뉴 : 관리자>예산관리>예산편성>일괄편성
* 화면 : 
* 기능 : 
* 프로그램 ID :
* 담당자 : HSJ ( 설계 : 공통 )
* 착수일 : 2018-07-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String toDate = CommonUtil.formatDateNoDateGubun(new Date(),1);
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
var maxAllowRow = 1000;	// 업로드 허용할 데이터 Row수

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
	         		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}
	         		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:true,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
	         		,{ Align:"Center",	Width:120,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"예산부서",		SaveName:"BUDGET_DEPT"}
	         		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"예산부서명",		SaveName:"BUDGET_DEPT_NAME"}
	         		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"계정코드",		SaveName:"ACCOUNT"}
	         		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"계정명",		SaveName:"ACCOUNT_NAME"}
	         		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"예산편성금액",	SaveName:"BUDGET_AMT"}
	         		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		Header:"사용금액",		SaveName:"USED_AMT"}
	         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"예산/계정 매핑",	SaveName:"MAPPING_YN"}
	         		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",		Header:"기등록여부",		SaveName:"EXIST_YN"}
	         		,{ Align:"Right",	Width:100,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Float",		Header:"기존예산편성금액",	SaveName:"BEFORE_BUDGET_AMT"}
	         		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",		Header:"예산부서등록",	SaveName:"BUDGET_DEPT_YN"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
}
	
var st;
var mt;

// 기능함수
function doAction(str) {
	
	st = new Date();
	var rowCount = mySheet.RowCount();
	
	switch (str) {
		case "search": // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdam/getBuyerMdAmBudgetUploadPop.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if(rowCount == 0){
				alert("저장할 대상이 없습니다.");
				return;
			}
		
			for ( var i =1; i < mySheet.RowCount()+1;i++) {
				
				// 예산부서 확인
				if(mySheet.GetCellValue(i, "BUDGET_DEPT_NAME") == "" || mySheet.GetCellValue(i, "BUDGET_DEPT_NAME") == null || mySheet.GetCellValue(i, "BUDGET_DEPT_YN") == "N"){
					alert(i+"번째 예산부서를 확인하여 주시기 바랍니다.");
					return;
				}
				
				// 계정코드 확인
				if(mySheet.GetCellValue(i, "ACCOUNT_NAME") == "" || mySheet.GetCellValue(i, "ACCOUNT_NAME") == null){
					alert(i+"번째 계정코드를 확인하여 주시기 바랍니다.");
					return;
				}
				
				// 부서별계정 매핑 확인
				if(mySheet.GetCellValue(i, "MAPPING_YN") == "N"){
					alert(i+"번째 부서별계정 매핑을 확인하여 주시기 바랍니다.");
					return;
				}
				
				// 사용금액 초과 확인 
				if(mySheet.GetCellValue(i, "BUDGET_AMT") < mySheet.GetCellValue(i, "USED_AMT")){
					alert(i+"번째 예산편성금액은 사용금액을 초과할 수 없습니다.");
					return;
				}
			}
			if ( !confirm('선택한 항목을 저장 하시겠습니까?') )
				return;
			
			kepSaveAll(document.searchCondition ,  mySheet , "/mdam/saveBuyerMdAmBudgetUpload.do" , "SELECTED" );
			break;
			
		case "loadExcel": // 파일 업로드
			var term = $("#st_term").val();

			if(term == ''){
				alert("<%=CommonLang.msg("MSG3") %>\n선택기간이 없을 경우 KEP 담당자에게 문의바랍니다.");	//기간 구분을 먼저 선택하십시오.
				return;
			}
			
			mySheet.RemoveAll();
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1||2||3|||"};
			mySheet.LoadExcel(params);
			break;
	}
}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	var maxRowCount = maxAllowRow + 1;
	
	if(mySheet.RowCount() == 0){
		alert("일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.");
	}else{
		if(maxRowCount < mySheet.RowCount() + 1) {
			alert(maxAllowRow + "건 이하의 파일만 업로드하여 주세요.");
			mySheet.RemoveAll();
			return;
		}else{
			kepSaveAll(document.searchCondition ,  mySheet , "/mdam/saveBuyerMdAmExcelUpload.do" , "SELECTED" );
		}
	}
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
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

//팝업 함수호출
var gridIndex = 0;

function doPop(idx, str,value1, value2, value3, value4, value5) {
	popupSel = str;
	gridIndex =idx;
	
	switch (str) {
		case "commonCoCoTermChoicePop": // 기간선택
			var termType = $("#st_term_type").val();

			if(termType == ''){
				alert("<%=CommonLang.msg("MSG3") %>");	//기간 구분을 먼저 선택하십시오.
				return;
			}else if(termType == 'Y'){
				termType = "year";
			}else if(termType == 'H'){
				termType = "half";
			}else if(termType == 'Q'){
				termType = "quarter";
			}else{
				termType = "month";
			}
	        
			openSearchPopup("/coco/showCommonCoCoTermChoicePop.do", "?st_row=text&st_gubun_code="+termType, "500,300,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5){
	if(popupSel == "commonCoCoTermChoicePop"){
		var toDate   = "<%=toDate%>";
 		var selDate = value3;
		if(eval(toDate.substring(0, 6)) > eval(selDate.substring(0,6))){
			alert("<%=CommonLang.msg("MSG4") %>");	//금월 이전의 예산편성 및 수정은 불가합니다.\n\n운영자에게 문의 바랍니다.
			return;
		}
		
		$("#st_term").val(value1);
		$("#st_term_text").val(value5);
		$("#st_from_date").val(value2);
		$("#st_to_date").val(value3);

		doAction('search');
	}
}

function changeTermInit(){
	$("#st_term").val("");
	$("#st_term_text").val("");
	$("#st_from_date").val("");
	$("#st_to_date").val("");
	
	mySheet.RemoveAll();
}
</script>
</head>

<body onload="kep_onload_view()">

<!--내용 시작-->
<div id="popWrapper" style="height:494px; min-height: 100px;">    
    	<div id="popHeader">
        	<h1 class="title">예산일괄편성</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
    
	    <!--조회영역-->
		<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
					
				<table  class="cont_t_list01" style="width:100%;">
					<caption>예산일괄편성</caption>
					<colgroup>
						<col width="10%" />
						<col width="*" />
					</colgroup>
								
					<tbody>
						<tr>
							<th><font color="red"><b>*</b></font>기간</th>
							<td>
						        <select name="st_term_type" id="st_term_type" style="width:15%;height:20px;" onchange="javascript:changeTermInit();">
						        	<%=CommonUtil.getCodeBComboList(_sessionInfo.getComCode(), "SEL", "PERD", "ICOMCOD2", "", "")%>
						        </select>
						        <input type="text"  id="st_term_text" name="st_term_text"  style="width:20%" value="" readonly>
				        		<input type="hidden" id="st_term" name="st_term"  value="" readonly>
				        		<a href="javascript:doPop('','commonCoCoTermChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a>
				        		<input type="hidden" id="st_from_date"  name="st_from_date" value="">
								<input type="hidden" id="st_to_date"  name="st_to_date"   value="">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
<!-- 	            
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
 -->			
		</form>
						
		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "400px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
	  			
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
				<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">엑셀업로드</a></span>
				<span class="btn_03 mr04"><a href="/resources/excel/kep_budget_upload.xls">등록양식</a></span>
			</span>
	  				
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
			</span>
		</div>
<!--내용 종료-->
	</div>	                 
	</div>
</div>
</body>
</html>
