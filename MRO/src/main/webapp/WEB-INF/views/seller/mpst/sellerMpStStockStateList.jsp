<%--
**********************************************
* 메뉴 : 재고관리>VMI 납품관리>재고현황조회
* 화면 : 재고현황조회
* 기능 : 
* 프로그램 ID : PG_08_A_603_00
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
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
	int grid_cnt = (_gridList != null )? _gridList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

	// 조회조건 S
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  // 품목명
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  // 규격
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  // 품목코드
	String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  // 물류센터
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
	<h3>재고현황조회</h3>

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
		<input type="hidden" name="st_comorg_code" id="st_comorg_code" value="${sessionInfo.bycaComorgCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_dept" id="st_user_dept" value="${sessionInfo.department}">

		<div id="cont_searchA">
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="17%" />
					<col width="8%" />
					<col width="17%" />
					<col width="8%" />
                    <col width="17%" />
					<col width="8%" />
                    <col width="17%" />
				</colgroup>

				<tbody>
					<tr>
						<th>품목명</th>
						<td>
							<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:80%;" value="<%=st_description%>" onKeyDown="kepEnter()">
						</td>
						<th>규격</th>
						<td>
							<input type="text" class="input_type_text" name="st_specification" id="st_specification" style="width:80%;" value="<%=st_specification%>" onKeyDown="kepEnter()">
						</td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" value="<%=st_buyer_item_no%>" onKeyDown="kepEnter()">
						</td>
						<th>물류센터</th>
      					<td>
      						<select id="st_buyer" name="st_buyer">
      							<%=CommonUtil.getCodeComboQueryIdList("common.agentWareHouse", "NO", st_buyer)%>
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
		<input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=grid_cnt %>" >

		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="20%" />
	            <col width="*" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="15%" />
	        </colgroup>
	        <thead>
				<tr>
	                <th scope="col">물류센터명</th>
	                <th scope="col">품목명</th>
	                <th scope="col">단위</th>
	                <th scope="col">가용재고량</th>
	                <th scope="col">최대재고량</th>
				</tr>
				<tr>
	                <th scope="col">품목코드</th>
	                <th scope="col">규격</th>
	                <th scope="col">총재고량</th>
	                <th scope="col">출하대기 재고량</th>
	                <th scope="col">최소재고량</th>
				</tr>
			</thead>
			<tbody>
<%
	if ( _gridList == null || _gridList.size() == 0) {
%>
				<tr>
		            <td colspan="6" align="center" height = "50">
		            	<span>조회된 데이타가 없습니다.</span>
		            </td>
		        </tr>
<%
	} else {
		for ( int j=0; j<_gridList.size(); j++ ) {
			Map<String,String> rowData = _gridList.get(j);
			String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
%>
				<tr align="center" bgcolor="<%=tclass%>">
		            <td class="left" title="물류센터명">
		                <%=rowData.get("WAREHOUSE_NAME")%>
					</td>
		            <td class="left pl10" title="품목명">
		                <%=rowData.get("DESCRIPTION")%>
		            </td>
		            <td title="단위">
		                <%=rowData.get("UNIT_MEASURE")%>
		            </td>
		            <td class="right pr10" title="가용재고량">
						<%=CommonUtil.formatNumber(rowData.get("AVAIL_QTY"),true,0,3)%>
					</td>
<!-- 					</td> -->
		            <td class="right pr10" title="최대재고량">
						<%=CommonUtil.formatNumber(rowData.get("MAX_STOCK_QTY"),true,0,3)%>
					</td>
				</tr>
				<tr align="center" bgcolor="<%=tclass%>">
		            <td title="품목코드">
						<%=rowData.get("BUYER_ITEM_NO")%>
		            </td>
		            <td class="left pl10" title="규격">
		                <%=rowData.get("SPECIFICATION")%>
		            </td>
		            <td class="right pr10" title="총재고량">
						<%=CommonUtil.formatNumber(rowData.get("TOT_QTY"),true,0,3)%>
					</td>
		            <td class="right pr10" title="출하재고량">
						<%=CommonUtil.formatNumber(rowData.get("ALLOC_QTY"),true,0,3)%>
					</td>
		            <td class="right pr10" title="최소재고량">
						<%=CommonUtil.formatNumber(rowData.get("MIN_ORDER_QTY"),true,0,3)%>
					</td>
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
        	<div class="fl">
        		<span class="btn_04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>
			</div>
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
	// TO-DO
}

var st;

// 기능함수
function doAction(str) {
	switch (str) {
		case "search": // 조회
			kepSearch($("#curPage").val());
			break;

		case "reload": // 초기화
			kepReload("searchForm");
			jspTableClean("table_list");
			break;
			
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpst/excelSellerMpStStockStateList.do";
			document.forms.searchForm.submit();
//	 		$('#searchForm').attr("action", "/mpst/excelSellerMpStStockStateList.do").submit();
			break;
	}
}

// 조회
function kepSearch(curPage) {
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mpst/getSellerMpStStockStateList.do").submit();
}
</script>
</html>
