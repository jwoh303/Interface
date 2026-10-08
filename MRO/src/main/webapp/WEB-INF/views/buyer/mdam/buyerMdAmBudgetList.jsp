<%--
**********************************************
* 메뉴 : 관리자>예산관리>예산조회
* 화면 : 예산조회
* 기능 : 부서별 계정별 예산, 사용실적, 잔액현황을 조회할 수 있다.
* 프로그램 ID : PG_06_B_053_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String st_account_type = CommonUtil.nvl((String) request.getParameter("st_account_type"),"ALL");  //  (조회조건)
	String toDate			  = CommonUtil.formatDateNoDateGubun(new Date(),1);
	
	String SessionUserName = "";  
	String SessionComCode = "";
	String SessionUserId = "";
	String SessionUserDept = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionUserName =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
		SessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId());  
		SessionUserDept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
	}
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"ALL");  
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"ALL");  
	String st_term_type = CommonUtil.nvl((String) request.getParameter("st_term_type"),"M"); 
	String st_term = CommonUtil.nvl((String) request.getParameter("st_term"),"ALL");
	String st_term_text = CommonUtil.nvl((String) request.getParameter("st_term_text"),"ALL");
	String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
	
	//엑셀다운로드 기능 통제
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P17-0000001");
	
	String p070000027 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P07-0000027","COL01_DATA");
	
%> 

<body onload="kep_onload_view()">
<%if(!"Y".equals(moveToMaster) ){%>
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<%} %>

<%if(!"Y".equals(moveToMaster) ){%>
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<%} %>

<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<%if(!"Y".equals(moveToMaster) ){%>
	<div id="ContArea">
<%}else{%>
    <div id="ContArea2">
<%} %>    

<%if(!"Y".equals(moveToMaster) ){%>
    <h3><%=CommonLang.get("HTITLE431") %><!-- 예산조회 --></h3>
    <div id="searchBtnA">
<%}else{%>
     <div id="searchBtnA" style="position:relative;  text-align:right; width:950px; height:32px; border: solid 0px; margin-top:5px; ">
     <h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px "><%=CommonLang.get("HTITLE431") %><!-- 예산조회 --></h3>
<%} %>

	<!--버튼영역-->
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" id="moveToMaster"  name="moveToMaster" value="<%=moveToMaster%>">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<colgroup>
					<col width="8%" />
					<col width="35%" />
					<col width="8%" />
					<col width="35%" />
				</colgroup>
				
				<tbody>
				<%if(!"Y".equals(moveToMaster) ){%>
					<tr>
				      <th><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>
				      <td ><input type="text" id="st_dept_name" name="st_dept_name" style="width:75%" value="" readonly>
				      <input type="hidden" id="st_dept_code" name="st_dept_code"  readonly value=""><a href="javascript:doPop('dept');">
				      <img src="/resources/images/btn_search03.gif" alt="검색" ></a>
				      <a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
				      </td>
						<th></th>
						<td></td>
					</tr>
				<%}else{%>
					<tr>
						<th><font color="red">*</font><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
						<td>
							<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:47%" value="" readonly onclick="javascript:doPop('icomcmpyPop');">
							<input type="hidden" name="st_buyer" id="st_buyer" style="width:80%" value="">
							<a href="javascript:doPop('icomcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
						</td>
				      <th><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>
				      <td ><input type="text" id="st_dept_name" name="st_dept_name" style="width:40%" value="" readonly>
				      <input type="hidden" id="st_dept_code" name="st_dept_code"  readonly value=""><a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a></td>
					</tr>
				<%}%>
				    <tr>
				      <th ><%=CommonLang.get("HTITLE423") %><!-- 기간 --></th>
				       <td>
					      <select class="sel_125" id = "st_term_type" name = "st_term_type"  onchange="javascript:kepClearField('st_term', 'st_term_text');">
				            <option value = "ALL"><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
				            <option value = "Y"><%=CommonLang.get("HTITLE424") %><!-- 년 --></option>
				            <option value = "H"><%=CommonLang.get("HTITLE425") %><!-- 반기 --></option>
				            <option value = "Q"><%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
				            <option value = "M" selected><%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
				        </select>
				        <input type="text"  id="st_term_text" name="st_term_text"  style="width:25%" value="" readonly>
				        <input type="hidden" id="st_term" name="st_term"  value="" readonly><a href="javascript:doPop('commonCoCoTermChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a></td>
				        <input type="hidden" id="st_from_date"  name="st_from_date" value="<%=(st_from_date.equals("ALL") ? "" : st_from_date)%>">
						<input type="hidden" id="st_to_date"  name="st_to_date"   value="<%=(st_to_date.equals("ALL") ? "" : st_to_date)%>">

					<th><%=CommonLang.get("HTITLE432") %><!-- 계정분류 --></th>
					<td><select id="st_account_type" name="st_account_type"  style="width:150px" onclick="javascript:chkdept();"></select>
	         		</td> 
				    </tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
			</select>
      	</span>      
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
				<col width="6%" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="7%" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="9%" />
	            <col width="8%" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="8%" />
	        </colgroup>
	        <thead>
			<tr>
			  <th scope="col"><%=CommonLang.get("HTITLE568") %><!-- 예산부서코드 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE420") %><!-- 예산부서명 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE432") %><!-- 계정분류 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE433") %><!-- 기간구분 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE423") %><!-- 기간 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE694") %><!-- 예산 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE434") %><!-- 실적금액 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE435") %><!-- 임시실적금액 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE436") %><!-- 잔액 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE437") %><!-- 예산수립일 --></th>
			  <th scope="col"><%=CommonLang.get("HTITLE438") %><!-- 최종실적발생일 --></th>
	        </tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
                        <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr bgcolor="<%=tclass%>">
					<td width="6%" class="left" height="25" title="예산부서코드">&nbsp;<%=rowData.get("DEPT")%></td>
					<td width="10%" class="left" height="25" title="예산부서">&nbsp;<%=rowData.get("DEPT_NAME")%></td>
					<td width="8%"  class="left"   title="계정분류">&nbsp;<%=rowData.get("ACCOUNT_TYPE_TEXT")%></td>
					<td width="7%"  title="기간구분">&nbsp;<%=rowData.get("TERM_TYPE_TEXT")%></td>
					<td width="10%" class="left"   title="기간">&nbsp;<%=rowData.get("TERM_TEXT")%></td>
					<td width="8%"  class="right"  title="예산"><%=CommonUtil.formatNumber(rowData.get("PLAN_AMT"),true,0,3)%>&nbsp;</td>
					<td width="8%"  class="right"  title="실적금액"><%=CommonUtil.formatNumber(rowData.get("RESULT_AMT"),true,0,3)%>&nbsp;</td>
					<td width="9%"  class="right"  title="임시실적금액"><%=CommonUtil.formatNumber(rowData.get("TEMP_AMT"),true,0,3)%>&nbsp;</td>
					<td width="8%"  class="right"  title="잔액"><%=CommonUtil.formatNumber(rowData.get("TEMP_AMT_TEXT"),true,0,3)%>&nbsp;</td>
					<td width="10%" class="left"   title="비고">&nbsp;<%=rowData.get("REMARK")%></td>
					<td width="8%"  title="예산수립일">&nbsp;<%=CommonUtil.formatStrinigDate(rowData.get("PLAN_DATE"))%></td>
					<td width="8%" title="최종실적발생일">&nbsp;<%=CommonUtil.formatStrinigDate(rowData.get("LAST_RESULT_DATE"))%></td>
				</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span>
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('histExcelDown');"><%=CommonLang.get("HTITLE917") %><!-- 상세 다운로드 --></a>
				</span>
				<%
				//엑셀다운로드 기능 통제
				if(p170000001 == false){
				%>
					<span class="btn_04">
						<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a>
					</span>
				<%
				}
				%>
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>

<%if(!"Y".equals(moveToMaster) ){%>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
<%} %>

</body>

<script type="text/javascript">
var popupSel = "";
var default_term = "<%=p070000027%>";

// 최초 화면 함수 
function kep_onload_view(){
	//콤보데이터 셋팅	
	 
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer", "${st_buyer}");	//고객사코드
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	var buyerCode = $("#st_buyer").val();
	var search=(buyerCode == null || buyerCode == '' )? $("#st_com_code").val() : buyerCode;
	kepAjaxCommonQueryIdSearchCombo('st_account_type','common.mpso.getAccountTypeSelect',search,'ALL');
	initSearchCondition("searchForm", "st_dept_code", "${st_dept_code}");	//부서코드
	initSearchCondition("searchForm", "st_dept_name", "${st_dept_name}");	//부서명
	initSearchCondition("searchForm", "st_account_type", "${st_account_type}");	//계정유형
//	initSearchCondition("searchForm", "st_term_type", "${st_term_type}");	//기간유형
	initSearchCondition("searchForm", "st_term", "${st_term}");	//
	initSearchCondition("searchForm", "st_term_text", "${st_term_text}");	//
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
// 	initSearchCondition("searchForm", "curPage", "${curPage}");	//현재 페이지		

// 	kepAjaxCommonCombo("st_account_type", "C019", "SEL");
	reloadPeriod();
}

function reloadPeriod(){
	var fromDate = "";
	var toDate = "";
	var year = "<%=DateTimeUtil.getYear()%>";
	var month = "<%=DateTimeUtil.getMonth()%>";
	var month0 = "";
	var quarter = "";
	var half = "";
	var half_text = "";
	
	if($("#st_term_text").val() == ""){
		if(default_term == "M"){
			// 한자리 월 앞에 0 붙이기
			if(month.length == 1){
				month0 = 0 + month;
			}else{
				month0 = month;
			}
			fromDate = year+month0+"01";
			toDate = year+month0+"31";
			
			$("#st_term_type").val("M");
			$("#st_term").val(year+month0);
			$("#st_term_text").val(year + "년도 " + month + "월");
			$("#st_from_date").val(fromDate);
			$("#st_to_date").val(toDate);
		}else if(default_term == "Q"){
			// 월 이용하여 분기 구하기
			if(month==1||month==2||month==3){
				quarter = 1;
				fromDate = year+"0101";
				toDate = year+"0331";
			}else if(month==4||month==5||month==6){
				quarter = 2;
				fromDate = year+"0401";
				toDate = year+"0630";
			}else if(month==7||month==8||month==9){
				quarter = 3;
				fromDate = year+"0701";
				toDate = year+"0930";
			}else if(month==10||month==11||month==12){
				quarter = 4;
				fromDate = year+"1001";
				toDate = year+"1231";
			}
			
			$("#st_term_type").val("Q");
			$("#st_term").val(year+"Q"+quarter);
			$("#st_term_text").val(year + "년도 " + quarter + "/4분기");
			$("#st_from_date").val(fromDate);
			$("#st_to_date").val(toDate);
		}else if(default_term == "H"){
			// 월 이용하여 반기 구하기
			if(month==1||month==2||month==3||month==4||month==5||month==6){
				half = 1;
				half_text = "전";
				fromDate = year+"0101";
				toDate = year+"0630";
			}else if(month==7||month==8||month==9||month==10||month==11||month==12){
				half = 2;
				half_text = "후";
				fromDate = year+"0701";
				toDate = year+"1231";
			}
			
			$("#st_term_type").val("H");
			$("#st_term").val(year+"H"+half);
			$("#st_term_text").val(year + "년도 " + half_text + "반기");
			$("#st_from_date").val(fromDate);
			$("#st_to_date").val(toDate);
		}else if(default_term == "Y"){
			fromDate = year+"0101";
			toDate = year+"1231";
			
			$("#st_term_type").val("Y");
			$("#st_term").val(year);
			$("#st_term_text").val(year + "년도");
			$("#st_from_date").val(fromDate);
			$("#st_to_date").val(toDate);
		}else{
			$("#st_term_type").val("<%=st_term_type%>");
		}
	}
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
	 	var buyerCode = $("#st_buyer").val();
		if(buyerCode != null && buyerCode == ''){
			//고객사를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG1") %>");return;
		}
	
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		$("#st_buyer").val("");
		$("#st_buyer_name").val("");
		$("#st_dept_code").val("");
		$("#st_dept_name").val("");
		$("#st_term_type").val("M");
		$("#st_term").val("");
		$("#st_term_text").val("");
		$("#st_account_type").val("ALL");
		
// 		kepSearch(-1);
		jspTableClean("table_list");
		reloadPeriod();
		break;

	case "excelDown": // 엑셀다운로드
		var buyerCode = $("#st_buyer").val();
		if(buyerCode != null && buyerCode == ''){
			//고객사를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG1") %>");
			return;
		}
		
		document.forms.searchForm.action = "/mdam/excelBuyerMdAmBudgetList.do";
		document.forms.searchForm.submit();
		break;
	
	case "histExcelDown": // 상세 다운로드
		var termType = $("#st_term_type").val();
		var termText = $("#st_term_text").val();
		var buyerCode = $("#st_buyer").val();
		
		if(buyerCode != null && buyerCode == ''){
			//고객사를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG1") %>");
			return;
		}
		
		if(termType == 'ALL' || termText == ''){
			alert("<%=CommonLang.msg("MSG3") %>");	//기간 구분을 먼저 선택하십시오.
			return;
		}
		
		document.forms.searchForm.action = "/mdam/excelBuyerMdAmBudgetHistList.do";
		document.forms.searchForm.submit();
		break;
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmBudgetList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	popupSel = str;
	switch (str) {
	case "icomcmpyPop":
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
		break;
	case "dept": // 요청부서
		var buyerCode = $("#st_buyer").val();
		if(buyerCode != null && buyerCode ==''){
			//고객사를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG1") %>");return;
		}
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

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5){
// 	alert(value1+"::"+value2+"::"+value3+"::"+value4+"::"+value5);
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
		
		//계정분류 콤보 재 설정
		var search=$("#st_buyer").val();
		kepAjaxCommonQueryIdSearchCombo('st_account_type','common.mpso.getAccountTypeSelect',search,'ALL');

	}else if (popupSel == "dept") {
		$("#st_dept_code").val(value1);
		$("#st_dept_name").val(value2);
		
	}else if(popupSel == "commonCoCoTermChoicePop"){
		$("#st_term").val(value1);
		$("#st_term_text").val(value5);
		$("#st_from_date").val(value2);
		$("#st_to_date").val(value3);
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;

	var chkGridValue = {
			keys : ["st_status"] ,
			value0 : ["합의완료", "장바구니"],
			msg0 : ["합의완료된 품목들만 장바구니에 담을수 있습니다."]
	};

	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("<%=CommonLang.msg("MSG13") %>");	//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
		returnValue = false;
	}

	return returnValue;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("<%=CommonLang.msg("MSG14") %>");		//처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요
} 

function chkdept(){
	var buyerName = $("#st_buyer_name").val();
	if(buyerName != null && buyerName ==''){
			// 고객사를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG1") %>");return;
	}	
}
</script>
</html>
