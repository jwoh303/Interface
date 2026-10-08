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
	String toDate			  = CommonUtil.formatDateNoDateGubun(new Date(),1);
	
	// 조회조건 S
	String st_dept_loc = CommonUtil.nvl((String) request.getParameter("st_dept_loc"),"ALL");  
	String st_dept_code = CommonUtil.nvl((String) request.getParameter("st_dept_code"),"ALL");  
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"ALL");  
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"ALL");  
	String st_term_type = CommonUtil.nvl((String) request.getParameter("st_term_type"),"M"); 
	String st_term = CommonUtil.nvl((String) request.getParameter("st_term"),"ALL");
	String st_term_text = CommonUtil.nvl((String) request.getParameter("st_term_text"),"ALL");  
	// 조회조건 E
	String moveToMaster = CommonUtil.nvl((String) request.getParameter("moveToMaster"),""); // 조회조건
	
	String buyer = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		buyer = CommonUtil.nvl((String)sessionInfo.getComCode());
	}
	
	String p070000027 = CommonUtil.getSpecialCheckReturn(buyer,"P07-0000027","COL01_DATA");
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
	<h3><%=CommonLang.get("HTITLE422") %><!-- 예산편성 --></h3>
     <div id="searchBtnA">
<%}else{%>
     <div id="searchBtnA" style="position:relative;  text-align:right; width:950px; height:32px; border: solid 0px; margin-top:5px; ">
     <h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px "><%=CommonLang.get("HTITLE422") %><!-- 예산편성 --></h3>
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
		<input type="hidden" name="st_dept" id="st_dept" value="${sessionInfo.department}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" id="moveToMaster"  name="moveToMaster" value="<%=moveToMaster%>">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
				</colgroup>
				
				<tbody>
			<%if("Y".equals(moveToMaster) ){%>
				<tr>
					<th><font color="red">*</font><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
					<td>
						<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:45%" value="" readonly onclick="javascript:doPop('icomcmpyPop');">
						<input type="hidden" name="st_buyer" id="st_buyer" style="width:80%" value="">
						<a href="javascript:doPop('','icomcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
						<a href="javascript:kepEraser('st_buyer','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
					</td>
					<th></th>
					<td></td>
				</tr>
			<%}%>    				 	
				<tr>
				  <th><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>
			      <td ><input type="text" id="st_dept_name" name="st_dept_name" style="width:45%" value="" readonly>
			      <input type="hidden" id="st_dept_code" name="st_dept_code"  readonly value=""><a href="javascript:doPop('','dept');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a>
			      <a href="javascript:kepEraser('st_dept_code','st_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
			      </td>
			      <th ><font color="red">*</font><%=CommonLang.get("HTITLE423") %><!-- 기간 --></th>
			       <td>
			      		<select class="sel_125" id = "st_term_type" name = "st_term_type" onchange="javascript:kepClearField('st_term', 'st_term_text');">
				            <option value = "Y"><%=CommonLang.get("HTITLE424") %><!-- 년 --></option>
				            <option value = "H"><%=CommonLang.get("HTITLE425") %><!-- 반기 --></option>
				            <option value = "Q"><%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
				            <option value = "M"  selected ><%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
			        	</select>
				        <input type="text"  id="st_term_text" name="st_term_text"  style="width:35%" value="" readonly>
				        <input type="hidden" id="st_term" name="st_term"  value="" readonly><a href="javascript:doPop('','commonCoCoTermChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" ></a>
						<input type="hidden" id="st_from_date"  name="st_from_date" value="<%=(st_from_date.equals("ALL") ? "" : st_from_date)%>">
						<input type="hidden" id="st_to_date"  name="st_to_date"   value="<%=(st_to_date.equals("ALL") ? "" : st_to_date)%>">
			        </td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10"  selected>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "20" >20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "30" >30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "50" >50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
			</select>
      	</span>      
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="7%" />
	            <col width="24%" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="14%" /> 
	            <col width="10%" />
	            <col width="15%" />
	        </colgroup> 
	        <thead> 
			<tr>
                <th  scope="col">
                <input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox');">
                </th>
                <th scope="col"><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE428") %><!-- 계정 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE429") %><!-- 편성기간 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE430") %><!-- 예산금액 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE393") %><!-- 등록일 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15"  height = "50"> 
                        <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr  bgcolor="<%=tclass%>">
					<!-- HIDDEN 공통 -->
				<tr height="25" >
					<td width="7%" title="체크박스" >
						<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
						<input type="hidden" name="db_dept"				value="<%=rowData.get("DEPT")%>">
						<input type="hidden" name="db_account_type"		value="<%=rowData.get("ACCOUNT_TYPE")%>">
						<input type="hidden" name="db_term"				value="<%=rowData.get("TERM")%>">
						<input type="hidden" name="db_term_type"		value="<%=rowData.get("TERM_TYPE")%>">
						<input type="hidden" name="db_from_date"		value="<%=rowData.get("FROM_DATE")%>">
						<input type="hidden" name="db_to_date"			value="<%=rowData.get("TO_DATE")%>">
						<input type="hidden" name="db_flag"				value="<%=rowData.get("FLAG")%>">
					</td>
					<td class="left" width="24%" title="예산부서"><%=rowData.get("DEPT_NAME")%></td>
					<td class="left" width="15%" title="계정"><%=rowData.get("ACCOUNT_TEXT")%></td>
					<td class="left" width="15%" title="편성기간"><%=rowData.get("TERM_TEXT")%></td>
					<td class="right" width="14%" title="예산금액" >
						<input type="text"   name="st_plan_amt_text"    style="size: 15; text-align: right; "maxlength="15"  id="line" value="<%=CommonUtil.formatNumber(rowData.get("PLAN_AMT"),true,0,3)%>"  onchange="update_price(<%=j%>)">
						<input type="hidden" id="st_plan_amt" name="st_plan_amt"  value="<%=rowData.get("PLAN_AMT")%>">
						<input type="hidden" id="st_before_plan_amt" name="st_before_plan_amt"  value="<%=rowData.get("PLAN_AMT")%>">
						<input type="hidden" name="st_result_amt_text"  size="15" maxlength="15"  id="line" value="<%=CommonUtil.formatNumber(rowData.get("RESULT_AMT"),true,0,3)%>" >
						<input type="hidden" name="st_result_amt" value="<%=rowData.get("RESULT_AMT")%>">
					</td>
					<td width="10%" title="등록일" >
						<%=CommonUtil.formatStrinigDate(rowData.get("PLAN_DATE"))%>
					</td>
					<td width="15%" title="비고" >
								<input type="hidden" id="st_remark"	 name="st_remark"	value="<%=rowData.get("REMARK")%>">
									<%if(rowData.get("REMARK").equals("")) {%>
<!-- 										<img src="/resources/images/but_icon02.gif" border="0" name="st_remark_img"> -->
										<a class="hyperLink"  href="javascript:doPop(<%=j %>,'remarkReturn2Pop','<%=rowData.get("REMARK")%>');"><img src="/resources/images/but_icon02.gif" border="0" id="st_remark_img" name="st_remark_img"></a>
									<%}else {%>
										<a class="hyperLink"  href="javascript:doPop(<%=j %>,'remarkReturn2Pop','<%=rowData.get("REMARK")%>');"><img src="/resources/images/but_icon01.gif" border="0" id="st_remark_img" name="st_remark_img"></a>
										
									<%}%>
					</td>
				</tr>
            <%
                        }
        			}
            %>
           		</tbody>
            </table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}else{%>
	<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="0" >
<%	}%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span>
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
<%if(!"KRKORE0001".equals(buyer)){%>
			<div class="fl">
				<span class="btn_04">
					<a href="javascript:doAction('BudgetUpload');"><%=CommonLang.get("HTITLE703") %><!-- 일괄편성 --></a>
				</span>	
            </div>
<%}%>
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('BudgetSaveInfo');"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:doAction('BudgetDeleteInfo');"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></a>
				</span>		
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
		
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
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var default_term = "<%=p070000027%>";

// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer", "${st_buyer}");	//고객사코드
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	initSearchCondition("searchForm", "st_dept_code", "${st_dept_code}");	//부서코드
	initSearchCondition("searchForm", "st_dept_name", "${st_dept_name}");	//예산부서
// 	initSearchCondition("searchForm", "st_term_type", "${st_term_type}");	//기간유형
	$("#st_term_type").val( ("${st_term_type}" == '')?"M":"${st_term_type}");
	initSearchCondition("searchForm", "st_term", "${st_term}");	//
	initSearchCondition("searchForm", "st_term_text", "${st_term_text}");	//
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
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
			$("#st_term_type").val("M");
		}
	}
}

var st;
//기능함수
function doAction(str) {
	var btnEvent = str;
	switch (str) {
	case "search":	 //조회
	 	var buyerCode = $("#st_buyer").val();
		if(buyerCode != null && buyerCode == ''){
			//고객사를 선택해 주십시오.
			alert("<%=CommonLang.msg("MSG1") %>");
			return;
		}
	
		var term = document.forms.searchForm.st_term.value;
		if(term == ""){
			//예산 편성기간을 선택해 주십시요
			alert("<%=CommonLang.msg("MSG2") %>");
			return; 
		}
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		$("#st_buyer").val("");
		$("#st_buyer_name").val("");
		$("#st_dept_code").val("");
		$("#st_dept_name").val("");
		$("#st_term_type").val("M");
		$("#st_term").val("");
		$("#st_term_text").val("");
		
// 		kepSearch(-1);
		jspTableClean("table_list");
		reloadPeriod();
		break;

	case "excelDown": // 엑셀다운로드
		$('#searchForm').attr("action", "/mdam/excelBuyerMdAmBudgetCompilationList.do").submit();
		break;

	case "BudgetSaveInfo": // 저장	
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("<%=CommonLang.msg("MSG306") %>")){ //선택한 예산 목록을 저장 하시겠습니까?
				return;
			} 
			kepAjaxFormCall("/mdam/saveBuyerMdAmBudgetCompilationList.do","processForm",btnEvent); 	
		}
		break;
	
	case "BudgetDeleteInfo": // 삭제
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			
			if(!confirm("<%=CommonLang.msg("MSG307")%>")){ //선택한 예산 목록을 삭제 하시겠습니까?
				return;
			} 
			kepAjaxFormCall("/mdam/delBuyerMdAmBudgetCompilationList.do","processForm",btnEvent); 	
		}
		break;
	
	case "BudgetUpload":
		openSearchPopup("/mdam/showBuyerMdAmBudgetUploadPop.do","","1000,600,no");
		break;
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmBudgetCompilationList.do").submit();   
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
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&dept_type=B&com_code="+comCode, "500,500,no");
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
	case "remarkReturn2Pop": // 비고
		var remark = $("input[name=st_remark]").eq(idx).val();
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5){
//  	alert(gridIndex+"::"+value1+"::"+value2+"::"+value3+"::"+value4+"::"+value5);
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
	}else if (popupSel == "dept") {
		$("#st_dept_code").val(value1);
		$("#st_dept_name").val(value2);
	}else if(popupSel == "commonCoCoTermChoicePop"){
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
		
	}else if(popupSel == "remarkReturn2Pop"){
		 $("input[name=st_remark]").eq(gridIndex).val(value1);
		 if(value1 ==""){
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
	}

}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var plan_amt			= "";		  	
	var flag				= "";
	var result_amt          = "";
	
	var buyer = $("#st_buyer").val();
	if(buyer != null && buyer == ''){
		alert("<%=CommonLang.msg("MSG1") %>");	//고객사를 선택해 주십시오.
		return;
	}else{
		$("#st_buyer_code").val(buyer);	
	}
	
	
	var tot_cnt = document.forms.contentForm.display_item_cnt.value;
	var chk_cnt = 0;
	var chkGridValue = {};
	
	if(tot_cnt != "0"){
		chk_cnt = getCheckedRowCount(tot_cnt);	
	}
	
	if(chk_cnt == "0"){
    	// 하나 이상의 대상이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG259")%>");
        return;
    }
	
	if(btnEvent == "BudgetSaveInfo"){
	    if(eval(tot_cnt) < 2){
			plan_amt		= document.forms.contentForm.st_plan_amt.value;
			result_amt		= document.forms.contentForm.st_result_amt.value;
			
			// 예산금액 체크
			if( kepIsEmpty("st_plan_amt") || !kepIsNumber("st_plan_amt")){
				alert("<%=CommonLang.msg("MSG5") %>");	//예산금액을 확인 후 다시 입력해 주십시요
				return;
			}
			// 예산금액 체크
			if( (plan_amt == 0) ){
				alert("<%=CommonLang.msg("MSG6") %>");	//예산금액이 입력되지 않았습니다. 확인 후 다시 입력해 주십시요
				return;
			}
			if(eval(plan_amt) < eval(result_amt)){
				alert("<%=CommonLang.msg("MSG7") %>");	//예산금액은 실적금액보다 큰 경우만 수정 가능합니다.
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
						alert( k+1 + "<%=CommonLang.msg("MSG8") %>");	// 번째 목록의 예산금액을 확인 후 다시 입력해 주십시요
						return;
					}
					// 예산금액 체크
					if( (plan_amt == 0) ){
						alert( k+1 + "<%=CommonLang.msg("MSG9") %>");	// 번째 목록의 예산금액이 입력되지 않았습니다. 확인 후 다시 입력해 주십시요
						return;
					}
					// 예산금액 > 실적금액 체크
					if(eval(plan_amt) < eval(result_amt)){
						alert("<%=CommonLang.msg("MSG7") %>");	//예산금액은 실적금액보다 큰 경우만 수정 가능합니다.
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
				alert("<%=CommonLang.msg("MSG10") %>");	//아직 예산편성이 되지않은 계정입니다.
				return;
			}
			// 예산사용 여부 체크 , 실적금액(result_amt + temp_amt) = 0 일 경우만 삭제 가능
			if(eval(result_amt) > 0){
				alert("<%=CommonLang.msg("MSG11") %>");	//예산이 편성되어 사용되어진 목록입니다. 운영자에게 문의 바랍니다.
				return;
			}			

	    }else{
	        for(var k = 0; k < tot_cnt; k++){
	            var box = eval("document.forms.contentForm.checkbox" + k);
	            if(box.checked == true){
	            	flag		= document.forms.contentForm.db_flag[k].value;
					result_amt		= document.forms.contentForm.st_result_amt[k].value;

					if(flag =="INSERT" ){
						alert( k+1 + "<%=CommonLang.msg("MSG12") %>");	//번째 목록은 아직 예산편성이 되지않은 계정입니다.
						return;
					}					
					// 예산사용 여부 체크 , 실적금액(result_amt + temp_amt) = 0 일 경우만 삭제 가능
					if(eval(result_amt) > 0){
						alert("<%=CommonLang.msg("MSG11") %>");	//예산이 편성되어 사용되어진 목록입니다. 운영자에게 문의 바랍니다.
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
		alert("<%=CommonLang.msg("MSG13") %>");	//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
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
            alert("<%=CommonLang.msg("MSG539") %>");	//예산금액을 정수형으로 입력해주십시요.
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
            alert("<%=CommonLang.msg("MSG539") %>");	//예산금액을 정수형으로 입력해주십시요.
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

/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.contentForm.checkbox0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.checkbox" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}
</script>
</html>
