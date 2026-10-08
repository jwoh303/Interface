<%--
**********************************************
* 메뉴 : 납품관리>선입고 납품 관리
* 화면 : 선입고 납품 관리
* 기능 : 선입고 주문목록 조회 할 수 있다.
* 프로그램 ID : PG_07_A_009_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-12
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
    
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  // 고객사코드
	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  고객사명
	String st_bs_no = CommonUtil.nvl((String) request.getParameter("st_bs_no"),"");  // 요청번호
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
	<h3>선입고 납품 관리</h3>
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
					<td>조회일</td>
					<td colspan="5">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>
						&nbsp;~&nbsp;
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a>
							&nbsp;&nbsp;
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
					</td>
				</tr>
				<tr>
					<td>고객사</td>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="<%=st_buyer_name%>" onclick="javascript:doPop('icomcmpyPop');" READONLY />
						<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=st_buyer_code%>" />
						<a href="javascript:doPop('icomcmpyPop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
					<td>요청번호</td>
					<td>
						<input type="text" class="input_type_text" name="st_bs_no" id="st_bs_no" style="width:80%;" value="<%=st_bs_no%>" onkeyup="kepToUpper('st_bs_no')" onKeyDown="kepEnter()">
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "5" <%if ("5".equals(onepagerow)) {%>selected<%} %>>5건</option>
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
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
	            <col width="*" />
	            <col width="15%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="15%" />
	            <col width="10%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">고객사</th>
                <th scope="col">요청번호</th>
                <th scope="col">요청일</th>
                <th scope="col">거래명세서번호</th>
                <th scope="col">총 금액</th>
                <th scope="col">품목 수</th>
                <th scope="col">요청자</th>
                <th scope="col">상태</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="9" align="center" height = "50"> 
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
					<!-- HIDDEN 공통 -->
                    <td title="고객사"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_NAME")))%></td>
                    <td title="요청번호"><%=String.valueOf(CommonUtil.nvl(rowData.get("BS_NO")))%></td>
                    <td title="요청일"><%=CommonUtil.formatStrinigDate(rowData.get("BEFORE_GR_DATE"))%></td>
                    <td title="거래명세서번호">
                    	<a class="hyperLink" href="javascript:doPop('sellerMpIvPrewarhsngOrderDetailPop','<%=String.valueOf(rowData.get("BUYER"))%>', '<%=String.valueOf(rowData.get("INV_NO"))%>','${sessionInfo.comCode}');">
                    		<b><%=String.valueOf(CommonUtil.nvl(rowData.get("INV_NO")))%></b>
                    	</a>
                    </td>
                    <td title="총 금액" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("INV_AMT")),true,0,3)%></td>
                    <td title="품목 수" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("PRODUCT_CNT")),true,0,3)%></td>
                    <td title="요청자"><%=String.valueOf(CommonUtil.nvl(rowData.get("PURCHASER_NAME")))%></td>
                    <td title="상태"><%=String.valueOf(CommonUtil.nvl(rowData.get("DELIVERY_STATUS")))%></td>
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
				<span class="btn_06">
					<a href="javascript:doPop('savePrewarhsngReg');">선입고 요청 등록</a>
				</span>
				<span class="btn_04">
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
	case "search":	 //조회
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		$("#st_buyer_code").val("");		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
// 		kepSearch("-1");
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpiv/excelSellerMpIvPrewarhsngDeliveryManageList.do";
		document.forms.searchForm.submit();
		break;

	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvPrewarhsngDeliveryManageList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	switch (str) {
	case "icomcmpyPop": // 거래 고객사 선택
		popupSel = "icomcmpyPop";
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
		break;
		
	case "sellerMpIvPrewarhsngOrderDetailPop": // 선입고 상세 정보 팝업
		openSearchPopup("/mpiv/getSellerMpIvPrewarhsngOrderDetailPop.do", "?st_buyer_code="+value1+"&st_inv_no="+value2+"&st_com_code="+value3, "800,500,no");
		break;
		
	case "savePrewarhsngReg": // 선입고 요청 등록
		openSearchPopup("/mpiv/showSellerMpIvPrewarhsngOrderRegPop.do", "?st_buyer_code="+value1+"&st_inv_no="+value2+"&st_com_code="+value3, "800,410,no");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if (popupSel = "icomcmpyPop") {
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	}
}

</script>
</html>
