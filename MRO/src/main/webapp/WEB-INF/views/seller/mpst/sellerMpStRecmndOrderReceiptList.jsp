<%--
**********************************************
* 메뉴 : 재고관리>VMI 납품관리>권고발주접수
* 화면 : 권고발주접수
* 기능 : 
* 프로그램 ID : PG_07_A_016_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-28
**********************************************
--%>
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
	String st_search_flag = CommonUtil.nvl((String) request.getParameter("st_search_flag"),"");  // 조회일(From)
	// 조회조건 E
%> 

<body onload="kep_onload_view()">
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
	<h3>권고발주접수</h3>
	<!--버튼영역-->
     <div id="searchBtnA">&nbsp;</div>
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_search_flag" id="st_search_flag" value="1">
			
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
	            <col width="20%" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="*" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">물류센터명</th>
                <th scope="col">권고발주번호</th>
                <th scope="col">금액</th>
                <th scope="col">품목수</th>
                <th scope="col">입고요청일</th>
                <th scope="col">발주일</th>
                <th scope="col">비고</th>
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
                    <td title="물류센터명" class="td02 left"><%=String.valueOf(CommonUtil.nvl(rowData.get("WMS_NAME")))%></td>
                    <td title="권고발주번호" class="td02">
                    	<a class="hyperLink" href="javascript:doPop('commonMpIvDetailInvoiceCreationPop','<%=String.valueOf(rowData.get("VPO_NO"))%>', '<%=String.valueOf(rowData.get("ITEM_AMT"))%>', '<%=String.valueOf(rowData.get("RD_DATE"))%>', '<%=String.valueOf(rowData.get("VPO_DATE"))%>', '<%=String.valueOf(rowData.get("BUYER"))%>', '<%=String.valueOf(rowData.get("DELY_TO_LOCATION"))%>');">
                    		<%=String.valueOf(CommonUtil.nvl(rowData.get("VPO_NO")))%>
                    	</a>
                    </td>
                    <td title="금액" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_AMT")),true,0,3)%></td>
                    <td title="품목수" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_CNT")),true,0,3)%></td>
                    <td title="입고요청일" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
                    <td title="발주일" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("VPO_DATE"))%></td>
                    <td title="비고" class="td02 left"><%=String.valueOf(CommonUtil.nvl(rowData.get("VPO_REMARK")))%></td>
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

// 최초 화면 함수 
function kep_onload_view(){
<% if(!"1".equals(st_search_flag)){ %>
	kepSearch(1);
<% } %>
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpst/getSellerMpStRecmndOrderReceiptList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str, value1, value2, value3, value4, value5, value6) {
	switch (str) {
		case "commonMpIvDetailInvoiceCreationPop": // 요청부서
			var st_agent = $("#st_com_code").val();
			var st_vpo_no = value1;
			var st_item_amt = value2;
			var st_rd_date = value3;
			var st_vpo_date = value4;
			var st_buyer = value5;
			var st_dely_to_location_text = value6;
			var param = "?st_agent="+st_agent+"&st_vpo_no="+st_vpo_no+"&st_item_amt="+st_item_amt+"&st_rd_date="+st_rd_date+"&st_vpo_date="+st_vpo_date+"&st_buyer="+st_buyer+"&st_dely_to_location_text="+st_dely_to_location_text; 

			popupSel = "commonMpIvDetailInvoiceCreationPop";
			openSearchPopup("/mpiv/showCommonMpIvDetailInvoiceCreationPop.do", param, "800,500,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if (popupSel = "commonMpIvDetailInvoiceCreationPop") {
		kepSearch("1");
	}
}

</script>
</html>
