<%--
**********************************************
* 메뉴 : 관리자>예산관리>예산편성
* 화면 : 예산편성
* 기능 : 예산관리 부서별 예산을 편성/관리할 수 있는 화면이다.
* 프로그램 ID : PG_06_B_052_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/include/head.jspf"%>

<%
	String row_cnt = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		row_cnt = CommonUtil.nvl((String)sessionInfo.getRowCnt()); //20070704 추가 페이지 기본 개수
	}  
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt);  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
%>	
</head>
<body onload="kep_onload_view()">
	<div id="wrapper">
		<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp"%>
		
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			<c:set var="total_cnt" value='0' />
			<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1) %>' />
			<c:forEach items="${data }" var="_gridList" begin="0" end="1">
				<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
			</c:forEach>
			<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
			<c:set var="fromDate" value='' />
			<c:set var="toDate" value='' />
			<c:set var="st_from_date" value='${st_fromDate }' />
			<c:set var="st_to_date" value='${st_to_date }' />
			<c:if test='${st_from_date == null || st_from_date == "" }'>
				<c:set var="fromDate" value='<%=CommonUtil.addDate(new Date(), "M", -1, 1) %>' />
				<c:set var="toDate" value='<%=CommonUtil.getCurrentDay_Time("yyyyMMdd") %>' />
			</c:if>
			<c:if test='${!(st_from_date == null || st_from_date == "") }'>
				<c:set var="toDate" value='${st_to_date }' />
			</c:if>
			<c:set var="rowNumber" value='0' />
			<div id="container2">
			<div id="ContArea">
				<h3>요청서 조회</h3>
				<div id="searchBtnA">
					<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
					<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
				</div>
				<form name="searchForm" id="searchForm" method="post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" id="curPage" name="curPage" value="${curPage }" />
					<input type="hidden" id="st_com_code" name="st_com_code" value="${sessionInfo.comCode}">
					<input type="hidden" id="st_dept" name="st_dept" value="${sessionInfo.department}">
					<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
					<input type="hidden" id="moveToMaster" name="moveToMaster" value="${moveToMaster }">
					<input type="hidden" id="st_from_date" name="st_from_date" value="">
					<input type="hidden" id="st_to_date" name="st_to_date" value="">
					<input type="hidden" id="BUYER" name="BUYER" value="">
					<input type="hidden" id="DEPARTMENT" name="DEPARTMENT" value="">
					<input type="hidden" id="I_RESTATUS" name="I_RESTATUS" value="Y" />
					<input type="hidden" id="I_KEY" name="I_KEY" value="D" />
					<input type="hidden" id="st_screen_id" name="st_screen_id" value="3" />
					<div id="cont_searchA">
						<table class="cont_t_list01">
							<caption>조회</caption>
							<colgroup>
								<col width="20%" />
								<col width="30%" />
								<col width="20%" />
								<col width="30%" />
							</colgroup>
							<tbody>
								<tr>
									<th>요청일</th>
									<td>
										<input type="text" size="11" id="from_date" name="from_date" value="" readonly="readonly" />
										 ~ 
										<input type="text" size="11" id="to_date" name="to_date" value="" readonly="readonly" />
									</td>
									<th>요청코드</th>
									<td>
										<input type="text" name="I_RE_MBLNR" id="I_RE_MBLNR" style="width:75%" value="" />
									</td>
								</tr>
								<tr>
									<th>조직명</th>
									<td>
										<input type="text" name="I_ORGEH" id="I_ORGEH" style="width:75%" value="" />
									</td>
									<th>조직장</th>
									<td>
										<a href="javascript:getReqUserSelect();">
										<input type="text" name="I_ENAME" id="I_ENAME" style="width:75%" value="" readOnly/>
											<img src="/resources/images/but_query.gif" width="19" height="19">
										</a>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top: 3px;" />
						<label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow">
							<option value="100" <%=("50".equals(onepagerow) ? "selected" : "")%>>100건</option>
							<option value="200" <%=("200".equals(onepagerow) ? "selected" : "")%>>200건</option>
							<option value="300" <%=("300".equals(onepagerow) ? "selected" : "")%>>300건</option>
							<option value="500" <%=("500".equals(onepagerow) ? "selected" : "")%>>500건</option>
							<option value="1000" <%=("1000".equals(onepagerow) ? "selected" : "")%>>1000건</option>
						</select> 
					</span>
					<br/>
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_selected_row" id="st_selected_row" value="" />
					<input type="hidden" id="st_screen_id" name="st_screen_id" value="4" />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="3%" />
							<col width="10%" />
							<col width="10%" />
							<col width="20%" />
							<col width="7%" />
							<col width="*" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" name="checkAll" id="checkAll" value="" onclick="javascript:checkAll1();" /></th>
								<th scope="col">요청코드</th>
								<th scope="col">구분</th>
								<th scope="col">요청일</th>
								<th scope="col">조직장</th>
								<th scope="col">조직명</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${data == null || fn:length(data) == 0}">
									<tr>
										<td colspan="15" align="center" height="50">
											<span>조회된 데이타가 없습니다.</span>
										</td>
									</tr>
								</c:when>
								<c:when test="${fn:length(data) > 0}">
									<c:set var="tclass" value='#FFFFFF' />
									<c:forEach items="${data}" var="_gridList" varStatus="status">
										<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
										<c:set var="rowNumber" value='${status.index }' />
										<c:if test='${rowNumber % 2 != 0 }' >
											<c:set var="tclass" value="#FAFAFA"/>
										</c:if>
										<c:if test='${rowNumber % 2 == 0 }' >
											<c:set var="tclass" value="#FFFFFF"/>
										</c:if>
										<tr align="center" bgcolor="${tclass }" height="25" >
											<td title="체크박스" width="7%">
												<input type="checkbox" name="checkbox${rowNumber }" id="check" value="${_gridList.MBLNR }" />
												<input type="hidden" name="db_dept" value="${_gridList.DEPT }" />
												<input type="hidden" name="db_account_type" value="${_gridList.ACCOUNT_TYPE }" />
												<input type="hidden" name="db_term" value="${_gridList.TERM }" />
												<input type="hidden" name="db_term_type" value="${_gridList.TERM_TYPE }" />
												<input type="hidden" name="db_from_date" value="${_gridList.FROM_DATE }" />
												<input type="hidden" name="db_to_date" value="${_gridList.TO_DATE }" />
												<input type="hidden" name="db_flag" value="${_gridList.FLAG }" />
												
												<input type="hidden" name="ERSDA" value="${_gridList.ERSDA }" />
												<input type="hidden" name="CITY1" value="${_gridList.CITY1 }" />
												<input type="hidden" name="MBLNR" value="${_gridList.MBLNR }" />
												<input type="hidden" name="STREET" value="${_gridList.STREET }" />
												<input type="hidden" name="TEL_NUMBER" value="${_gridList.TEL_NUMBER }" />
												<input type="hidden" name="STEXT" value="${_gridList.STEXT }" />
												<input type="hidden" name="ENAME" value="${_gridList.ENAME }" />
												<input type="hidden" name="MATNR" value="${_gridList.MATNR }" />
												<input type="hidden" name="MOB_NUMBER" value="${_gridList.MOB_NUMBER }" />
												<input type="hidden" name="ORGEH" value="${_gridList.ORGEH }" />
												<input type="hidden" name="POST_CODE1" value="${_gridList.POST_CODE1 }" />
												<input type="hidden" name="BUYER" value="${_gridList.BUYER }" />
												<input type="hidden" name="PR_NO" value="${_gridList.PR_NO }" />
												<input type="hidden" name="i_buyer${rowNumber }" value="${_gridList.BUYER }" />
												<input type="hidden" name="i_pr_no${rowNumber }" value="${_gridList.PR_NO }" />
												<input type="hidden" name="i_pr_seq${rowNumber }" value="${_gridList.PR_SEQ }" />
											</td>
											<td title="요청번호" width="24%">
												<c:choose>
													<c:when test="${_gridList.PR_NO != ''}">
														<c:out value="${_gridList.MBLNR }"/>(<c:out value="${_gridList.MATNR }"/>)
													</c:when>
													<c:otherwise>
															<c:out value="${_gridList.MBLNR }"/>
													</c:otherwise>
												</c:choose>
											</td>
											<td title="구분" class="center">
												<c:out value="지급"/>
											</td>
											<td title="요청일" class="center">
												${_gridList.ERSDA }
											</td>
											<td title="조직장" class="center">
												${_gridList.ENAME }
											</td>
											<td title="조직명" class="left">
												${_gridList.STEXT }
											</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
					<c:if test="${data != null && fn:length(data) > 0}">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" />
					</c:if>
					<p id="paging" class="paging">
						<%=CommonUtil.getPageView("kepSearch", Integer.parseInt(pageContext.getAttribute("total_cnt").toString()), (pageContext.getAttribute("curPage") == null) ? "0" : (String) pageContext.getAttribute("curPage"), onepagerow)%>
						<span class="cl">[ 총 <c:out value="${total_cnt }" /> 건 ]</span>
					</p>
					<div class="btnArea">
						<div class="fr">
							<span class="btn_04">
								<a href="javascript:doAction('giPrintPop');">명세서출력</a>
							</span>
							<span class="btn_04">
								<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
							</span>
							<span class="btn_04">
								<a href="javascript:doAction('excelDownSAP');">SAP다운로드</a>
							</span>
						</div>
					</div>
				</form>
				<form name="processForm" id="processForm" method="post">
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="total_cnt" id="total_cnt" value="${total_cnt }" />
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="onepagerow" id="onepagerow" value="${onepagerow }" />
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode }" />
					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId }" />
					<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="" />
					<input type="hidden" id="st_mblnr" name="st_mblnr" value="">
					<input type="hidden" id="st_key" name="st_key" value="">
					<input type="hidden" id="st_from_date" name="st_from_date" value="">
					<input type="hidden" id="st_to_date" name="st_to_date" value="">
					<input type="hidden" id="BUYER" name="BUYER" value="">
					<input type="hidden" id="DEPARTMENT" name="DEPARTMENT" value="">
					<input type="hidden" id="v_buyer" name="v_buyer" value="">
					<input type="hidden" id="v_pr_no" name="v_pr_no" value="">
					<input type="hidden" id="v_pr_seq" name="v_pr_seq" value="">
				</form>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "from_date", "${from_date}");
	initSearchCondition("searchForm", "to_date", "${to_date}");
	initSearchCondition("searchForm", "I_ORGEH", "${I_ORGEH}");
	initSearchCondition("searchForm", "I_RE_MBLNR", "${I_RE_MBLNR}");
	initSearchCondition("searchForm", "I_KEY", "${I_KEY}");
	initSearchCondition("searchForm", "I_ENAME", "${I_ENAME}");
	initSearchCondition("searchForm", "BUYER", "${BUYER}");
	initSearchCondition("searchForm", "DEPARTMENT", "${DEPARTMENT}");
	initSearchCondition("processForm", "BUYER", "${BUYER}");
	initSearchCondition("processForm", "DEPARTMENT", "${DEPARTMENT}");
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
	kepSetCalender("from_date");
	kepSetCalender("to_date");
	if('${from_date}' == '')
		$("#from_date").val( kepToMonthAdd("1","M"));
	if('${to_date}' == '')
	$("#to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#I_ORGEH").val('${I_ORGEH }');
	$("#I_RE_MBLNR").val('${I_RE_MBLNR }');
	
}

var st;
//기능함수
function doAction(str) {
	var btnEvent = str;
	switch (str) {
	case "search":	 //조회

		document.forms.searchForm.curPage.value = "1";
	
		checkDate();
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		initSearchCondition("searchForm", "from_date", "");
		initSearchCondition("searchForm", "to_date", "");
		initSearchCondition("searchForm", "I_ORGEH", "");
		initSearchCondition("searchForm", "I_RE_MBLNR", "");
		initSearchCondition("searchForm", "I_KEY", "");
		initSearchCondition("searchForm", "I_ENAME", "");
		initSearchCondition("processForm", "BUYER", "");
		initSearchCondition("processForm", "DEPARTMENT", "");
		
		initSearchCondition("searchForm", "onepagerow", "100");	//페이징단위
		kepSetCalender("from_date");
		kepSetCalender("to_date");
		$("#from_date").val( kepToMonthAdd("1","M"));
		$("#to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		$("#I_ORGEH").val('${I_ORGEH }');
		$("#I_RE_MBLNR").val('${I_RE_MBLNR }');
		break;

	case "excelDown": // 엑셀다운로드
		giExcelDownload();
		break; 

	case "excelDownSAP": // 엑셀다운로드
		giSAPExcelDownload();
		break; 

	case "giPrintPop": // 엑셀다운로드
		giPrintPop();
		break; 

	case "SaveInfo": // 저장	
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("선택한 예산 목록을 저장 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mdam/saveBuyerMdAmBudgetCompilationList.do","processForm",btnEvent); 	
		}
		break;
	}
}

// 조회
function kepSearch(curPage){
	checkDate();
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 183 ){
		alert('요청일은 최대 6개월 까지 가능합니다.');
		return;
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmGiCowayReqList.do").submit();   
}
  
// 팝업 함수호출
var gridIndex = 0;
var grbRow = "";
function doPop(idx, str,value1, value2, value3, value4, value5) {
	popupSel = str;
	gridIndex =idx;
	
	switch (str) {
	case "icomcmpyPop":
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
		break;
	case "dept": // 요청부서
		var buyerCode = $("#st_buyer").val();
		var sessionCode = $("#st_com_code").val();
		var comCode = (buyerCode == null || buyerCode == '')? sessionCode : buyerCode  ;
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+comCode, "500,500,no");
		break;
	case "commonCoCoTermChoicePop": // 기간선택
		var termType = $("#st_term_type").val();
		if(termType == 'ALL'){
			alert("기간 구분을 먼저 선택하십시오.");
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
	case "remarkReturn2Pop": // 비고
		var remark = $("input[name=st_remark]").eq(idx).val();
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");
		break;
	case "getBuyerMdAmGiCowayReqDetailPop": // 비고
		var remark = $("input[name=st_remark]").eq(idx).val();
// 		openSearchPopup("/mdam/getBuyerMdAmGiCowayDetailPop.do", "?st_selected_row="+value1, "700,600,no");
		$('#st_selected_row').val(value1);
		openSearchPopupPost("/mdam/getBuyerMdAmGiCowayReqDetailPop.do", 'contentForm', 'getBuyerMdAmGiCowayReqDetailPop', "width=700,height=800,resizable=no,scrollbars=no, top=0, left=0");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11, value12){ // id,이름,부서코드,부서명,전화번호,email,fax,휴대폰,우편번호,주소,buyer
//  	alert(gridIndex+"::"+value1+"::"+value2+"::"+value3+"::"+value4+"::"+value5);
	
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
	}else if(popupSel == "remarkReturn2Pop"){
		 $("input[name=st_remark]").eq(gridIndex).val(value1);
		 if(value1 ==""){
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
	}else if(popupSel == "hqUserInfo"){
		document.forms.processForm.BUYER.value = value12;
		document.forms.processForm.DEPARTMENT.value = value3;
		document.forms.searchForm.BUYER.value = value12;
		document.forms.searchForm.DEPARTMENT.value = value3;
		document.forms.searchForm.I_ORGEH.value = value4;
		document.forms.searchForm.I_ENAME.value = value2;
		kepSearch($("#curPage").val());
	}

}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var plan_amt			= "";		  	
	var flag				= "";
	var result_amt		  = "";
	
	var buyer = $("#st_buyer").val();
	if(buyer != null && buyer == ''){
		alert("고객사를 선택해 주십시오.");
	}else{
		$("#st_buyer_code").val(buyer);	
	}
	
	
	var tot_cnt = document.forms.contentForm.display_item_cnt.value;
	
	var chkGridValue = {};
	
	if(btnEvent == "BudgetSaveInfo"){
		if(eval(tot_cnt) < 2){
			plan_amt		= document.forms.contentForm.st_plan_amt.value;
			result_amt		= document.forms.contentForm.st_result_amt.value;
			
			// 예산금액 체크
			if( kepIsEmpty("st_plan_amt") || !kepIsNumber("st_plan_amt")){
				alert("예산금액을 확인 후 다시 입력해 주십시요");
				return;
			}
			// 예산금액 체크
			if( (plan_amt == 0) ){
				alert("예산금액이 입력되지 않았습니다. 확인 후 다시 입력해 주십시요");
				return;
			}
			if(eval(plan_amt) < eval(result_amt)){
				alert("예산금액은 실적금액보다 큰 경우만 수정 가능합니다.");
				return;
			}
		}else{
			for(var k = 0; k < tot_cnt; k++){
				var box = eval("document.forms.contentForm.checkbox" + k);
				if(box.checked == true){
					plan_amt		= document.forms.contentForm.st_plan_amt[k].value;
					result_amt		= document.forms.contentForm.st_result_amt[k].value;

					// 예산금액 체크
					if( kepIsEmpty("st_plan_amt") || !kepIsNumber("st_plan_amt")){
						alert( k+1 + " 번째 목록의 예산금액을 확인 후 다시 입력해 주십시요");
						return;
					}
					// 예산금액 체크
					if( (plan_amt == 0) ){
						alert( k+1 + " 번째 목록의 예산금액이 입력되지 않았습니다. 확인 후 다시 입력해 주십시요");
						return;
					}
					// 예산금액 > 실적금액 체크
					if(eval(plan_amt) < eval(result_amt)){
						alert("예산금액은 실적금액보다 큰 경우만 수정 가능합니다.");
						return;
					}						
				}
			}
		}
	}else if(btnEvent=="BudgetDeleteInfo"){
		if(eval(tot_cnt) < 2){
			flag		= document.forms.contentForm.db_flag.value;
			result_amt		= document.forms.contentForm.st_result_amt.value;
			
			if(flag =="INSERT" ){
				alert("아직 예산편성이 되지않은 계정입니다.");
				return;
			}
			// 예산사용 여부 체크 , 실적금액(result_amt + temp_amt) = 0 일 경우만 삭제 가능
			if(eval(result_amt) > 0){
				alert("예산이 편성되어 사용되어진 목록입니다. 운영자에게 문의 바랍니다.");
				return;
			}			

		}else{
			for(var k = 0; k < tot_cnt; k++){
				var box = eval("document.forms.contentForm.checkbox" + k);
				if(box.checked == true){
					flag		= document.forms.contentForm.db_flag[k].value;
					result_amt		= document.forms.contentForm.st_result_amt[k].value;

					if(flag =="INSERT" ){
						alert( k+1 + " 번째 목록은 아직 예산편성이 되지않은 계정입니다.");
						return;
					}					
					// 예산사용 여부 체크 , 실적금액(result_amt + temp_amt) = 0 일 경우만 삭제 가능
					if(eval(result_amt) > 0){
						alert("예산이 편성되어 사용되어진 목록입니다. 운영자에게 문의 바랍니다.");
						return;
					}		
				}
			}
		}
	}
	
	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}

//예산금액 입력/변경
function update_price(row){
	var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
	if(eval(tot_cnt) < 2){	   
		var imsi_plan_amt = $("input[name=st_plan_amt_text]").eq(row).val();// 예산금액
		var imsi_st_plan_amt = $("input[name=st_plan_amt]").eq(row).val();// 예산금액
		// 예산금액 변경시
		if( isEmpty(imsi_plan_amt) || !kepIsNumberStr(imsi_plan_amt) || (imsi_plan_amt == 0) ){
			alert("예산금액을 확인 후 다시 입력해 주십시요");
			document.forms.contentForm.st_plan_amt_text.value		= kepCommaNum(imsi_st_plan_amt);
			return;
		}
		if(imsi_plan_amt!=""){
			document.forms.contentForm.st_plan_amt_text.value		= kepCommaNum(imsi_plan_amt);
			document.forms.contentForm.st_plan_amt.value		= imsi_plan_amt;
		}
	}else{
		var imsi_plan_amt = $("input[name=st_plan_amt_text]").eq(row).val();// 예산금액
		var imsi_st_plan_amt = $("input[name=st_plan_amt]").eq(row).val();// 예산금액
		
		// 예산금액 변경시
		if( isEmpty(imsi_plan_amt) || !kepIsNumberStr(imsi_plan_amt) || (imsi_plan_amt == 0) ){
			alert("예산금액을 확인 후 다시 입력해 주십시요");
			document.forms.contentForm.st_plan_amt_text[row].value		= kepCommaNum(imsi_st_plan_amt);
			return;
		}
		if(imsi_plan_amt!=""){
			document.forms.contentForm.st_plan_amt_text[row].value		= kepCommaNum(imsi_plan_amt);
			document.forms.contentForm.st_plan_amt[row].value		= imsi_plan_amt;
		}
	}// end else

}



// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.rfcMsg.MESSAGE;
	var code = response.rfcMsg.MSGTYPE;
	if(code == 'S')
		alert('촐고확정처리에 성공하였습니다.\n'+msg);
	else 
		if(msg == 'NO RESULT')
			alert('출고처리대상 데이터가 SAP에 존재하지 않습니다.');
		else
			alert('작업(SAP)에 실패 하였습니다.\n'+msg);
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if(pMethod != 'excelDown')
		alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
	else {
		alert('aaa')
	}
} 
function checkDate(){
	var v_f_date = document.searchForm.from_date.value;
	var v_t_date = document.searchForm.to_date.value;
	v_f_date = v_f_date.replace("-","");
	v_f_date = v_f_date.replace("-","");
	v_t_date = v_t_date.replace("-","");
	v_t_date = v_t_date.replace("-","");
	document.searchForm.st_from_date.value = v_f_date;
	document.searchForm.st_to_date.value = v_t_date;
}
function getPrDisplayPop(BUYER,PR_NO,RECV_FLAG,VALUE2){ 
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
}
function setInsertGi(){
	var v_check_value = "";
	var cnt = 0;
	var rCnt = eval($('#onepagerow').val());
	var totalCnt = $('#display_item_cnt').val();
	
	if(rCnt > totalCnt)
		rCnt = totalCnt;
	for(var i=0; i<rCnt; i++){
// 		alert(i)
		var i_checked = eval("document.contentForm.checkbox"+i+".checked");
		var i_check_value = eval("document.contentForm.checkbox"+i+".value");
		if(i_checked==true){
			if(v_check_value.indexOf(i_check_value)<0){
				v_check_value = i_check_value +"@@"+v_check_value;
			}
		}
	}
	if(rCnt > 0){
		document.processForm.st_key.value = 'D';//$('#I_KEY option:selected').val();
		document.processForm.st_mblnr.value = v_check_value;
		kepAjaxFormCall("/mdam/saveBuyerMdAmGiCowayList.do","processForm","SaveInfo");
	} else {
		alert('출고확정건을 선택하세요.');
		return;
	}
}
function giExcelDownload(){
	checkDate();
	var v_check_value = "";
	var v_buyer_value = "";
	var v_pr_no_value = "";
	var v_pr_seq_value = "";
	var cnt = 0;
	var rCnt = eval(document.searchForm.onepagerow.value);
	var totalCnt = $('#display_item_cnt').val();
	if(rCnt > totalCnt)
		rCnt = totalCnt;
	
	var checkCnt = 0;
	for(var i=0; i<rCnt; i++){
		var i_checked = eval("document.contentForm.checkbox"+i+".checked");
		var i_check_value = eval("document.contentForm.checkbox"+i+".value");
		var i_buyer_value = eval("document.contentForm.i_buyer"+i+".value");
		var i_pr_no_value = eval("document.contentForm.i_pr_no"+i+".value");
		var i_pr_seq_value = eval("document.contentForm.i_pr_seq"+i+".value");
		if(i_checked==true && i_buyer_value != ''){
			v_buyer_value = i_buyer_value +"@@"+v_buyer_value;
			v_pr_no_value = i_pr_no_value +"@@"+v_pr_no_value;
			v_pr_seq_value = i_pr_seq_value +"@@"+v_pr_seq_value;
			checkCnt++;
		}
	}
	
	
	if(checkCnt > 0){
		document.processForm.st_mblnr.value = v_check_value;
		document.processForm.v_buyer.value = v_buyer_value;
		document.processForm.v_pr_no.value = v_pr_no_value;
		document.processForm.v_pr_seq.value = v_pr_seq_value;
		document.processForm.st_from_date.value = document.searchForm.st_from_date.value;
		document.processForm.st_to_date.value = document.searchForm.st_to_date.value;
		document.forms.processForm.action = "/mdam/excelBuyerMdAmGiCowayReqList.do";
		document.forms.processForm.submit();
	} else {
		alert('데이터를 선택하세요.');
		return;
	}
}
function giSAPExcelDownload(){
	checkDate();
	var v_check_value = "";
	var v_buyer_value = "";
	var v_pr_no_value = "";
	var v_pr_seq_value = "";
	var cnt = 0;
	var rCnt = eval(document.searchForm.onepagerow.value);
	var totalCnt = $('#display_item_cnt').val();
	if(rCnt > totalCnt)
		rCnt = totalCnt;
	
	var checkCnt = 0;
	for(var i=0; i<rCnt; i++){
		var i_checked = eval("document.contentForm.checkbox"+i+".checked");
		var i_check_value = eval("document.contentForm.checkbox"+i+".value");
		var i_buyer_value = eval("document.contentForm.i_buyer"+i+".value");
		var i_pr_no_value = eval("document.contentForm.i_pr_no"+i+".value");
		var i_pr_seq_value = eval("document.contentForm.i_pr_seq"+i+".value");
		if(i_checked==true && i_buyer_value != ''){
			v_buyer_value = i_buyer_value +"@@"+v_buyer_value;
			v_pr_no_value = i_pr_no_value +"@@"+v_pr_no_value;
			v_pr_seq_value = i_pr_seq_value +"@@"+v_pr_seq_value;
			checkCnt++;
		}
	}
	
	
	if(checkCnt > 0){
		document.processForm.st_mblnr.value = v_check_value;
		document.processForm.v_buyer.value = v_buyer_value;
		document.processForm.v_pr_no.value = v_pr_no_value;
		document.processForm.v_pr_seq.value = v_pr_seq_value;
		document.processForm.st_from_date.value = document.searchForm.st_from_date.value;
		document.processForm.st_to_date.value = document.searchForm.st_to_date.value;
		document.forms.processForm.action = "/mdam/excelBuyerMdAmGiCowayReqListSAP.do";
		document.forms.processForm.submit();
	} else {
		alert('데이터를 선택하세요.');
		return;
	}
}
function giPrintPop(){
	if($('#I_ENAME').val() == ''){
		alert('명세서출력시 조직장명은 필수 입니다.');
		getReqUserSelect();
		return;
	}
	if(!$('input:checkbox[id="checkAll"]').is(":checked")){
		$('input:checkbox[id="checkAll"]').attr("checked", true);
		checkAll1();
	}
	checkDate();
	var v_check_value = "";
	var v_buyer_value = "";
	var v_pr_no_value = "";
	var v_pr_seq_value = "";
	var cnt = 0;
	var rCnt = eval(document.searchForm.onepagerow.value);
	var totalCnt = $('#display_item_cnt').val();
	if(rCnt > totalCnt)
		rCnt = totalCnt;
	var checkCnt = 0;
	
	alert(rCnt);
	for(var i=0; i<rCnt; i++){
		var i_checked = eval("document.contentForm.checkbox"+i+".checked");
		var i_check_value = eval("document.contentForm.checkbox"+i+".value");
		var i_buyer_value = eval("document.contentForm.i_buyer"+i+".value");
		var i_pr_no_value = eval("document.contentForm.i_pr_no"+i+".value");
		var i_pr_seq_value = eval("document.contentForm.i_pr_seq"+i+".value");
		if(i_checked==true && i_buyer_value != ''){
			v_buyer_value = i_buyer_value +"@@"+v_buyer_value;
			v_pr_no_value = i_pr_no_value +"@@"+v_pr_no_value;
			v_pr_seq_value = i_pr_seq_value +"@@"+v_pr_seq_value;
			checkCnt++;
		}
	}
	if(checkCnt > 0){
		document.processForm.st_mblnr.value = v_check_value;
		document.processForm.v_buyer.value = v_buyer_value;
		document.processForm.v_pr_no.value = v_pr_no_value;
		document.processForm.v_pr_seq.value = v_pr_seq_value;
		document.processForm.st_from_date.value = document.searchForm.st_from_date.value;
		document.processForm.st_to_date.value = document.searchForm.st_to_date.value;
		openSearchPopupPost("/mdam/getBuyerMdAmGiCowayReqDetailPop.do", 'processForm', 'getBuyerMdAmGiCowayReqDetailPop', "width=700,height=800,resizable=no,scrollbars=no, top=0, left=0");
	} else {
		alert('데이터를 선택하세요.');
		return;
	}
}
function checkAll1(){
// 	alert($('input:checkbox[id="checkAll"]').val())
// 	alert($('input:checkbox[id="checkAll"]').is(":checked"))
	var checkAllFlag = $('input:checkbox[id="checkAll"]').is(":checked");
	$('input:checkbox[id="check"]').each(function(){
		this.checked = checkAllFlag;
	});
}

//대상자셋팅
function setUserSelect(user_id, user_name, phone_number, email, dept, dept_name, address_loc, fax_number, legacy_user_id, mobile_phone){
		document.searchForm.I_ORGEH.value = dept_name;
// 		document.contentForm.st_user_name.value = user_name;
// 		document.contentForm.st_dept_code.value = dept;
}
//대상자선택
function getReqUserSelect(){
	popupSel = 'hqUserInfo';
	openSearchPopup('/mdam/showBuyerMdamHqUserInfoPop.do', '?open=Y&com_code=' , "500,500,no");
}
</script>
</html>
