<%--
**********************************************
* 메뉴 : 납품관리>수주접수
* 화면 : 수주접수
* 기능 : 수주내역을 조회하고 접수처리 하기 위한 화면
* 프로그램 ID : PG_07_A_001_00
* 담당자 : 개발3 ( 설계 : 김지현 )
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
 

<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
%> 

<script type="text/javascript"> 
var popupSel = "";

//최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//고객사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//고객사코드
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	initSearchCondition("searchForm", "st_req_user_info", "${st_req_user_info}");	//요청정보
	initSearchCondition("searchForm", "st_order_by", "${st_order_by}");	//정렬기준
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
	
	var searchYn = "${initSearchYn}";
	
	// 초기 화면호출시 자동조회
	if(searchYn != "N"){
		doAction("search");	
	}
	
}

function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch("1");
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code").val("");
// 			kepSearch("-1");
			jspTableClean("table_list");
			break;
	
		case "excelDown": // 엑셀다운로드
			//$('#searchForm').attr("action", "/mpiv/getExcelSellerMpIvObtnodrReceiptList.do").submit();
			document.forms.searchForm.action = "/mpiv/excelSellerMpIvObtnodrReceiptList.do";
			document.forms.searchForm.submit();
			break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvObtnodrReceiptList.do").submit();   
}	

// 팝업 함수호출
function doPop(str,value1, value2, value3) {
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "720,505,no");
			break;
			
		case "sellerMpIvObtnodrReceiptDetailPop": // 수주접수
			if(value3 == "Y"){
				alert("고객사 이슈로 수주 접수 불가, 담당자에게 문의 바랍니다.\n 최병관 책임(02-3016-8931), 배인영 사원(02-3016-8933)");
	    		return;
			}
		
			openSearchPopup("/mpiv/getSellerMpIvObtnodrReceiptDetailPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "1400,610,no");
			break;
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}

//납기관리개선 협력사 매뉴얼 안내
function popup_20231212() {
	window.open("/resources/html/main/notice/popup_20231212.htm","popup_20231212","width=690, height=540, scrollbars = no");
}

</script>
</head>

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
	<h3>수주접수</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
		<span class="btn_search"><a href="javascript:popup_20231212();">매뉴얼</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
		
		<input type="hidden" name="initSearchYn" id="initSearchYn" value="N" />
		
		<!-- <input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> -->
		
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
					<td>고객사</td>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" READONLY>
						<input type="hidden" name="st_buyer_code" id="st_buyer_code" >
						<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
				   <td>발주번호</td>
					<td>
					   <input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" onKeyDown="kepEnter();">
					</td>					
					<td>요청정보</td>
					<td>
						<input type="text" class="input_type_text" name="st_req_user_info" id="st_req_user_info" style="width:80%;" onKeyDown="kepEnter();">
					</td>
					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow">
					<option value = "10" >10건</option>
					<option value = "20" >20건</option>
					<option value = "30" >30건</option>
					<option value = "40" >40건</option>
					<option value = "50" >50건</option> 
				</select>
				<select name="st_order_by" id="st_order_by">
					<option value = "2">발주일▲</option>
					<option value = "9">발주일▼</option>
					<option value = "1">고객사</option>
					<option value = "3">주문번호</option>
					<option value = "4">발주번호</option>
					<option value = "5">발주총금액</option>
					<option value = "6">품목수</option>
					<option value = "7">표준납기일</option>
					<option value = "8">선입고여부</option>
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
	            <col width="14%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="6%" />
	            <col width="6%" />
	            <col width="8%" />
	            <col width="6%" />
	            <col width="*" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">고객사</th>
                <th scope="col">발주일</th>
                <th scope="col">주문번호</th>
                <th scope="col">발주번호</th>
                <th scope="col">발주총금액</th>
                <th scope="col">품목수</th>
                <th scope="col">표준납기일</th>
                <th scope="col">KeP담당자</th>
                <th scope="col">선입고여부</th>
                <th scope="col">비고</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="10" align="center" height = "50"> 
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
                   	<td title="고객사" class="left">
                   		<a class="hyperLink" href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER2"))%>');">
                   			<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
                   		</a>
                   	</td>
                    <td title="발주일"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("PO_CREATE_DATE")))%></td>
                    <td title="주문번호"><%=CommonUtil.nvl(rowData.get("REF_NO"))%></td>
                    <td title="발주번호">
                    	<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('sellerMpIvObtnodrReceiptDetailPop','<%=String.valueOf(rowData.get("BUYER"))%>','<%=String.valueOf(rowData.get("PO_NO"))%>','<%=CommonUtil.nvl(rowData.get("PORS_CHECK"))%>');">
	                    	<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
	                    </a>
                    </td>
                    <td title="발주총금액" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("PO_AMT")),true,0,3)%></td>
                    <td title="품목수"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("PO_SEQ")),true,0,0)%></td>
                    <td title="표준납기일"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("ST_DATE")))%></td>
                    <td title="KeP담당자"><%=CommonUtil.nvl(rowData.get("KEP_USER_NAME"))%><br>(<%=CommonUtil.nvl(rowData.get("KEP_PHONE_NUMBER"))%>)</td>
                    <td title="선입고여부"><%=CommonUtil.nvl(rowData.get("BFRE_STCK_YN"))%></td>
                    <td title="비고" class="left"><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></td>
				</tr>
            <%
                        } 
        			}
            %>

           		</tbody>
            </table>
         <span>※ 수주접수를 하시려면 <font color="red">발주번호</font>을 클릭하시기 바랍니다.  </span>   
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
