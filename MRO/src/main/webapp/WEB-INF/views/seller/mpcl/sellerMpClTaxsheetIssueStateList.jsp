<%--
**********************************************
* 메뉴 : 정산관리>마감관리>세금계산서 발행현황
* 화면 : 세금계산서 발행현황
* 기능 : 세금계산서 발행현황을 조회한다.
* 프로그램 ID : PG_07_A_019_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-14
**********************************************
--%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
	
	String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
	// 조회조건 S
	String st_cl_year = CommonUtil.nvl((String) request.getParameter("st_cl_year"), String.valueOf(DateTimeUtil.getYear()));
	String st_cl_month = CommonUtil.nvl((String) request.getParameter("st_cl_month"), CommonUtil.lpad(String.valueOf(DateTimeUtil.getMonth() - 1), 2, '0'));
	String st_site = CommonUtil.nvl((String) request.getParameter("st_site"),"");  // 조회필드콤보
	// 조회조건 E
%> 

<body>
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>세금계산서 발행현황</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
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
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup>
				
				<tbody>
				<tr>
					<td>마감월</td>
					<td colspan="3">
						<select name="st_cl_year" id="st_cl_year"  style="height:20px; width: 60px;" >
	                		<option value="<%=DateTimeUtil.getYear() - 4 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 4).equals(st_cl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 4 %></option>
	                		<option value="<%=DateTimeUtil.getYear() - 3 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 3).equals(st_cl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 3 %></option>
	                		<option value="<%=DateTimeUtil.getYear() - 2 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 2).equals(st_cl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 2 %></option>
	                		<option value="<%=DateTimeUtil.getYear() - 1 %>" <% if (String.valueOf(DateTimeUtil.getYear() - 1).equals(st_cl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() - 1 %></option>
	                		<option value="<%=DateTimeUtil.getYear() %>" <% if (String.valueOf(DateTimeUtil.getYear()).equals(st_cl_year)) { %> selected <%} %> ><%=DateTimeUtil.getYear() %></option>
	                		<option value="<%=DateTimeUtil.getYear() + 1 %>" <% if (String.valueOf(DateTimeUtil.getYear() + 1).equals(st_cl_year)) { %> selected <%} %>><%=DateTimeUtil.getYear() + 1 %></option>
	                		<option value="<%=DateTimeUtil.getYear() + 2 %>" <% if (String.valueOf(DateTimeUtil.getYear() + 2).equals(st_cl_year)) { %> selected <%} %>><%=DateTimeUtil.getYear() + 2 %></option>
	                		<option value="<%=DateTimeUtil.getYear() + 3 %>" <% if (String.valueOf(DateTimeUtil.getYear() + 3).equals(st_cl_year)) { %> selected <%} %>><%=DateTimeUtil.getYear() + 3 %></option>
	                	</select>&nbsp;년&nbsp;
	                	<select name="st_cl_month" id="st_cl_month"  style="height:20px; width: 40px;" >
	                		<option value="01" <% if (st_cl_month.equals("01")) { %> selected <%} %>>1</option>
	                		<option value="02" <% if (st_cl_month.equals("02")) { %> selected <%} %>>2</option>
	                		<option value="03" <% if (st_cl_month.equals("03")) { %> selected <%} %>>3</option>
	                		<option value="04" <% if (st_cl_month.equals("04")) { %> selected <%} %>>4</option>
	                		<option value="05" <% if (st_cl_month.equals("05")) { %> selected <%} %>>5</option>
	                		<option value="06" <% if (st_cl_month.equals("06")) { %> selected <%} %>>6</option>
	                		<option value="07" <% if (st_cl_month.equals("07")) { %> selected <%} %>>7</option>
	                		<option value="08" <% if (st_cl_month.equals("08")) { %> selected <%} %>>8</option>
	                		<option value="09" <% if (st_cl_month.equals("09")) { %> selected <%} %>>9</option>
	                		<option value="10" <% if (st_cl_month.equals("10")) { %> selected <%} %>>10</option>
	                		<option value="11" <% if (st_cl_month.equals("11")) { %> selected <%} %>>11</option>
	                		<option value="12" <% if (st_cl_month.equals("12")) { %> selected <%} %>>12</option>
	                	</select>&nbsp;월&nbsp;
					</td>
				    <td>사이트</td>
					<td>
			  			<select name = "st_site" id="st_site" style="height:20px;">
				      		<option value="KA" <%if ("KA".equals(st_site)) {%>selected<%} %>>KOREAB2B</option>
				      		<option value="KK" <%if ("KK".equals(st_site)) {%>selected<%} %>>경기MRO</option>
						</select>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
			</select>
      	</span>
       <span class="fr">총건수 <%=total_cnt %></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="15%" />
	            <col width="10%" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="15%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">당사사업장</th>
                <th scope="col">사이트<br>발행일</th>
                <th scope="col">거래처<br>사업자등록번호</th>
                <th scope="col">공급가액<br>세액</th>
                <th scope="col">합계</th>
                <th scope="col">세무구분<br>발행조건</th>
                <th scope="col">적요</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="7" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
                    <td title="당사사업장" rowspan="2" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("KEP_NAME")))%><br/><%=String.valueOf(CommonUtil.nvl(rowData.get("KEP_IRS_NO")))%></td>
                    <td title="사이트" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("KEP_SITE_NAME")))%></td>
                    <td title="거래처" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_NAME")))%></td>
                    <td title="공급가액" class="td02 right">
                    	<a class="hyperLink" href="javascript:doPop('commonMpIvBuyerClosingAmtPop','<%=String.valueOf(CommonUtil.nvl(rowData.get("SITE")))%>','<%=String.valueOf(rowData.get("TAX_BILL_NO"))%>');"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("TOT_SUPP_PRICE")),true,0,3)%></a>
                    </td>
                    <td title="합계" rowspan="2" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("TOT_AMT")),true,0,3)%></td>
                    <td title="세무구분" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("TAX_TYPE")))%></td>
                    <td title="적요" rowspan="2" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("SUMMARY")))%></td>
				</tr>
				<tr bgcolor="<%=tclass%>">
                    <td title="발행일 class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("ISSUE_DATE"))%></td>
                    <td title="사업자등록번호" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("IRS_NO")))%></td>
                    <td title="세액" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("TOT_TAX_PRICE")),true,0,3)%></td>
                    <td title="발행조건" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("BILL_TYPE")))%></td>
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
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_04 mr04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>
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
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		$("#st_cl_year").val( kepGetNowTimeStr('YYYY',''));   
		$("#st_cl_month").val( kepGetNowTimeStr('MM',''));   
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpcl/excelSellerMpClTaxsheetIssueStateList.do";
		document.forms.searchForm.submit();
		break;

	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpcl/getSellerMpClTaxsheetIssueStateList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	switch (str) {
		case "commonMpIvBuyerClosingAmtPop": // 고객사별 마감금액 팝업
			openSearchPopup("/mpiv/getCommonMpIvBuyerClosingAmtPop.do", "?st_site=" + value1 + "&st_tax_bill_no=" + value2, "500,500,no");
			break;
	}
}

</script>
</html>
