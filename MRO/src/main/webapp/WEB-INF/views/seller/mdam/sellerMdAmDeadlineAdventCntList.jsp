<%--
**********************************************
* 메뉴 : HOME>TODO>납기도래건수(납기도래품목현황)
* 화면 : 납기도래품목현황
* 기능 : 
* 프로그램 ID : PG_07_A_021_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-09-04
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
 

<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  //  (조회조건)
	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)
	String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
%> 

<script type="text/javascript"> 
var popupSel = "";

function doAction(str) {
	switch (str) {
		case "search":	 //조회
			if(isEmpty($("#st_buyer_code").val())){
				alert("고객사를 선택해주세요.");
				return;
			}
			kepSearch("1");
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_name").val("");
			$("#st_buyer_code").val("");
// 			kepSearch("-1");
			jspTableClean("table_list");
			break;
	
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mdam/excelSellerMdAmDeadlineAdventCntList.do";
			document.forms.searchForm.submit();
			break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getSellerMdAmDeadlineAdventCntList.do").submit();   
}	

// 팝업 함수호출
function doPop(str,value1, value2, value3, value4) {
	switch (str) {
		case "deliveryDelay": // 납품지연 고객사 선택
			var st_com_code = $("#st_com_code").val();
			popupSel = "deliveryDelay";			
			openSearchPopup("/mdam/showSellerMdAmDeliveryDelayListPop.do", "?st_com_code="+st_com_code, "500,400,no");
			break;
		case "catalogDetail": // 품목코드 상세정보
			var buyer = value1;
			var buyerItemNo = value2;
			var contractNo = value3;
			var contractSeq = value4;
			openSearchPopup("/common/catalogDetailPop.do", "?BUYER="+buyer+"&BUYER_ITEM_NO="+buyerItemNo+"&CONTRACT_NO="+contractNo+"&CONTRACT_SEQ="+contractSeq, "800,290,no");
			break;
		case "agent": // 회원사 정보 조회
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
		case "commonMpIvOrderInfoPop": // 발주정보 조회
			popupSel = "commonMpIvOrderInfoPop";
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer=" + value1 + "&st_po_no=" + value2, "930,600,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "deliveryDelay": // 납품지연 고객사 선택
			$("#st_buyer_code").val(code);
			$("#st_buyer_name").val(text);
			break;
	}
}

</script>
</head>

<body onload="">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2" style="margin-right: 20px;">
<%-- <c:import charEncoding="utf-8" url="/menu/menu.do"> --%>
<%-- <c:param name="page" value="sellerLeft"/> --%>
<%-- <c:param name="part" value="${param.upperId}"/> --%>
<%-- </c:import> --%>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>납기도래 품목현황</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
		
		<input type="hidden" name="search_flag" id="search_flag" value="Y" />
		
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
						<td colspan="2">조회 기준 : 5일 이내에 납품대상인 품목</td>
						<td><font color="red"><b>*</b></font>고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active;" value="<%=st_buyer_name%>" onclick="javascript:doPop('deliveryDelay');" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=st_buyer_code%>">
							<a href="javascript:doPop('deliveryDelay');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
					   <td>발주번호</td>
						<td>
						   <input type="text" class="input_type_text" name="st_po_no" id="st_po_no" value="<%=st_po_no %>" style="width:80%;" onKeyDown="kepEnter();">
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
	            <col width="25%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="*" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">고객사<br>발주번호</th>
                <th scope="col">품목코드<br>발주일</th>
                <th scope="col">품목명<br>규격</th>
                <th scope="col">발주단가<br>단위</th>
                <th scope="col">발주수량<br>납품예정수량</th>
                <th scope="col">납기요청일<br>납품예정일</th>
                <th scope="col">발주자<br>요청자</th>
                <th scope="col">관리번호<br>요청부서</th>
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
                   	<td title="고객사" class="left"><a class="hyperLink" href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER"))%>');"><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></a></td>
                    <td title="품목코드"><a class="hyperLink" href="javascript:doPop('catalogDetail','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></a></td>
                    <td title="품목명" class="left"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></td>
                    <td title="발주단가" class="right"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></td>
                    <td title="발주수량" class="right"><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
                    <td title="납기요청일"><%=CommonUtil.formatDate(rowData.get("RD_DATE"))%></td>
                    <td title="발주자"><%=CommonUtil.nvl(rowData.get("PURCHASER_NAME"))%></td>
                    <td title="관리번호"><%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%></td>
				</tr>
				<tr align="center" bgcolor="<%=tclass%>">                     	
                   	<td title="발주번호"><a class="hyperLink" href="javascript:doPop('commonMpIvOrderInfoPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("PO_NO"))%>');"><%=CommonUtil.nvl(rowData.get("PO_NO"))%></a></td>
                    <td title="발주일"><%=CommonUtil.formatDate(rowData.get("PO_CREATE_DATE"))%></td>
                    <td title="규격" class="left"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
                    <td title="단위"><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td>
                    <td title="납품예정수량" class="right"><%=CommonUtil.formatNumber(rowData.get("CD_QTY"),true,0,3)%></td>
                    <td title="납품예정일"><%=CommonUtil.formatDate(rowData.get("DS_DATE"))%></td>
                    <td title="요청자"><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME"))%></td>
                    <td title="요청부서"><%=CommonUtil.nvl(rowData.get("REQ_DEPT"))%></td>
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
</html>
