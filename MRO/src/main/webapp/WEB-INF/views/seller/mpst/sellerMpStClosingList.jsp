<%--
**********************************************
* 메뉴 : 재고관리>VMI 납품관리>마감조회
* 화면 : 마감조회
* 기능 : 
* 프로그램 ID : PG_08_A_604_00
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
	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  // 구매회사코드
	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  // 구매회사명
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 출고일 시작
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 출고일 종료
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
	<h3>VMI마감조회</h3>
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
				<caption>VMI마감조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="42%" />
					<col width="8%" />
					<col width="42%" />
				</colgroup>
				
				<tbody>
					<tr>
						<td>출고일</td>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="<%=st_from_date%>">
							&nbsp;~&nbsp;
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
						</td>
						<th><font color="#FF6600">*</font>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="<%=st_buyer_name%>" readOnly>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=st_buyer_code%>">
							<a href="javascript:doPop('sellerMpStClosingBuyerPop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
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
	            <col width="11%" />
	            <col width="11%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="11%" />
	            <col width="11%" />
	            <col width="11%" />
	            <col width="11%" />
	        </colgroup>
	        <thead>
				<tr>
	                <th scope="col">발주번호</th>
	                <th scope="col">출고번호</th>
	                <th scope="col">품목명</th>
	                <th scope="col">규격</th>
	                <th scope="col">출고수량</th>
	                <th scope="col">단가</th>
	                <th scope="col">총금액</th>
	                <th scope="col">출고일자</th>
				</tr>
			</thead>
			<tbody>
<%
	if ( _gridList == null || _gridList.size() == 0) {
%>
				<tr>
		            <td colspan="8" align="center" height = "50">
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
		            <td title="발주번호">
		                <%=rowData.get("PO_NO")%>
					</td>
		            <td title="출고번호">
		                <%=rowData.get("GR_NO")%>
		            </td>
		            <td class="left pl20" title="품목명">
		                <%=rowData.get("DESCRIPTION")%>
		            </td>
		            <td class="left pl20" title="규격">
		                <%=rowData.get("SPECIFICATION")%>
		            </td>
		            <td class="right pr30" title="출고수량">
		                <%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
					</td>
		            <td class="right pr30" title="단가">
		                <%=CommonUtil.formatNumber(rowData.get("AGENT_PRICE"),true,0,3)%>
					</td>
		            <td class="right pr30" title="총금액">
		                <%=CommonUtil.formatNumber(rowData.get("AGENT_ITEM_AMT"),true,0,3)%>
					</td>
					<td title="출고일자">
		                <%=CommonUtil.formatDate(rowData.get("GR_DATE"))%>
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
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
<%if("".equals(st_from_date)){%>
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
<%}%>
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search": //조회
		// 조회조건 체크
		if ( !searchValidate() )
			return;
		kepSearch($("#curPage").val());
		break;
		
	case "reload": //초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
// 		$('#searchForm').attr("action", "/mpst/excelSellerMpStClosingList.do").submit();
		document.forms.searchForm.action = "/mpst/excelSellerMpStClosingList.do";
		document.forms.searchForm.submit();
		break;

	}
}

// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");
	
	if ( start_date > end_date ) {
		alert("출고 종료일은 시작일보다 작을 수 없습니다");
		return false;
	}
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}

	return true;
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpst/getSellerMpStClosingList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "sellerMpStClosingBuyerPop": // 거래고객사
			var params = "?st_from_date="+$("#st_from_date").val()+"&st_to_date="+$("#st_to_date").val()+"&st_com_code="+$("#st_com_code").val();
			openSearchPopup("/mpst/showSellerMpStClosingBuyerPop.do", params, "500,260,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if ( popupSel = "sellerMpStClosingBuyerPop" ) {
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	}
}
</script>
</html>
