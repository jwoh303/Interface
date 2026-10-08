<%--
**********************************************
* 메뉴 : 고객사 > HOME > 예산조회 팝업
* 화면 : 예산조회 
* 기능 : 예산조회 팝업
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2019-01-23
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"%>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>

<%
// 공통
String SessionComCode = "";
String SessionUserId = "";
String SessionUserDept = "";
String SessionUserDeptName = "";
String SessionUserType = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	SessionComCode = CommonUtil.nvl((String)sessionInfo.getComCode());
	SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId());  
	SessionUserDept = CommonUtil.nvl((String)sessionInfo.getDepartment());
	SessionUserDeptName = CommonUtil.nvl((String)sessionInfo.getDepartmentName());
	SessionUserType = CommonUtil.nvl((String)sessionInfo.getUserType());
}
boolean p060000116 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000116");
boolean p060000140 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000140"); // 예산 조회시 icomcod3의 전용 조건 참고여부
String stAccountFlg = "N";
if(p060000140 == true){
	stAccountFlg = "Y";
}
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {

	var initsheet = {};
	initsheet.Cols = [
			 {Align:"Center",	SaveName:"DEPT",				Header:"부서코드",		Type:"Text",	Width:70,	Edit:false,	EditLen:100,	Hidden:false}
			,{Align:"Left",		SaveName:"DEPT_NAME",			Header:"부서명",		Type:"Text",	Width:180,	Edit:false,	EditLen:200,	Hidden:false}
			,{Align:"Left",		SaveName:"BDGT_DEPT_NAME",		Header:"예산부서",		Type:"Text",	Width:180,	Edit:false,	EditLen:20,		Hidden:false}
			,{Align:"Left",		SaveName:"ACCOUNT_TYPE_TEXT",	Header:"예산계정",		Type:"Text",	Width:195,	Edit:false,	EditLen:30,		Hidden:false}
			,{Align:"Center",	SaveName:"TERM_TYPE_TEXT",		Header:"기간구분",		Type:"Text",	Width:70,	Edit:false,	EditLen:100,	Hidden:false}
			,{Align:"Left",		SaveName:"TERM_TEXT",			Header:"기간",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{Align:"Right",	SaveName:"PLAN_AMT",			Header:"예산금액",		Type:"Float",	Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{Align:"Right",	SaveName:"RESULT_AMT",			Header:"실적금액",		Type:"Float",	Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{Align:"Right",	SaveName:"TEMP_AMT",			Header:"임시실적금액",	Type:"Float",	Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{Align:"Right",	SaveName:"BAL_AMT",				Header:"잔여금액",		Type:"Float",	Width:90,	Edit:false,	EditLen:100,	Hidden:false}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//doAction("search");
}

function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "dept": // 요청부서
			var buyerCode = "";
			var sessionCode = $("#st_com_code").val();
			var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
			openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+comCode, "500,500,no");
			break;
			
		case "commonCoCoTermChoicePop": // 기간선택
			var termType = $("#st_term_type").val();
			if(termType == 'ALL'){
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
function setPopupReturn(value1,value2,value3,value4,value5) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "dept") {
		$("#st_dept_code").val(value1);
		$("#st_dept_name").val(value2);
	}else if(popupSel == "commonCoCoTermChoicePop"){
		$("#st_term").val(value1);
		$("#st_term_text").val(value5);
	}
	grbRow="";	//초기화
}

var st;
var mt;

//기능함수
function doAction(str, flag) {
	st = new Date();
	
	switch (str) {
		case "search":
			current_page = -1;
			var p060000116 = "<%=p060000116%>";
			if(p060000116 == "true"){
				if($("#st_account_name").val() ==  "" || $("#st_account_name").val() ==  null){
					alert("<%=CommonLang.msg("MSG554") %>");//"계정명 입력 바랍니다."
					return;
				}
			}
			kepSearch(document.searchForm, mySheet, "/home/getBuyerHomeDeptBudgetPopList.do", pagingMode);
			break;
			
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/home/excelBuyerHomeDeptBudgetPopList.do";
			document.forms.searchForm.submit();
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
}

function mySheet_OnChange(Row, Col, Value) {
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
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchForm ,  mySheet , "/home/getBuyerHomeDeptBudgetPopList.do?page="+current_page , pagingMode );
}

</script> 
<body onload="kep_onload_view();">
<form name="searchForm" id="searchForm" method=post>
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" id=st_user_type  name="st_user_type" value="<%=SessionUserType%>">
<input type="hidden" id=st_user_dept  name="st_user_dept" value="<%=SessionUserDept%>">
<input type="hidden" id=st_account_flg name="st_account_flg" value="<%=stAccountFlg%>">
<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME"/>
<input type="hidden" id="pageflag" name="pageflag" value="1"/>

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:400px;">
    	<div id="popHeader">
			<h1 class="title">예산조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        
        <div id="popContainer">
        	<div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
			</div>
            
        	<div id="cont_searchA">	
				<table class="cont_t_list01" style="width:100%">
					<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
				
					<tbody>
						<tr>
							<th><%=CommonLang.get("HTITLE329") %><!-- 부서 --></th>
							<td>
								<%if(SessionUserType.equals("A")){%>
									<input type="text" id="st_dept_name" name="st_dept_name" style="width:60%" value="" readonly>
									<input type="hidden" id="st_dept_code" name="st_dept_code" readonly value="">
									<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a>
									<a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
								<%}else{%>
									<input type="text" id="st_dept_name" name="st_dept_name" style="width:60%" value="" readonly>
									<input type="hidden" id="st_dept_code" name="st_dept_code" readonly value="">
									<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a>
									<a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
								<%}%>
							</td>
				      		
				      		<th><%=CommonLang.get("HTITLE423") %><!-- 기간 --></th>
							<td>
								<select class="sel_125" id = "st_term_type" name = "st_term_type" style="width:25%" onchange="javascript:kepClearField('st_term', 'st_term_text');">
									<option value = "ALL" selected><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
									<option value = "Y"><%=CommonLang.get("HTITLE424") %><!-- 년 --></option>
									<option value = "H"><%=CommonLang.get("HTITLE425") %><!-- 반기 --></option>
									<option value = "Q"><%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
									<option value = "M"><%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
								</select>
				        		<input type="text"  id="st_term_text" name="st_term_text"  style="width:40%" value="" readonly>
								<input type="hidden" id="st_term" name="st_term"  value="" readonly>
								<a href="javascript:doPop('commonCoCoTermChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a>
								<a href="javascript:kepEraser('st_term','st_term_text');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
							</td>
						</tr>
						<tr>
							<th><%=CommonLang.get("HTITLE267") %><!-- 계정명 --></th>
							<td>
								<input type="text" id="st_account_name" name="st_account_name" style="width:60%" value="" onKeyDown="kepEnter()">
							</td>
				      		<th></th>
							<td>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width:70px;">
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			
			<br/>
			
            <div class="contArea" style="height:400px;" >
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "360px");
					</script>
				</div>
				<p class="paging" id="pageindex"></p>
			</div>
			
			<!--버튼영역-->	
			<div class="btnArea">
				<span class="fl">
					<span class="btn_06">
						<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a>
					</span>	
				</span>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
