<%--
**********************************************
* 메뉴 : 주문관리>납기지연현황
* 화면 : 납기지연현황
* 기능 : 발주 후 납기요청일이 지났는데도 아직 납품되지 않은 발주목록을 조회한다.
* 프로그램 ID : PG_06_B_015_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-08-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

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
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
    String buyer = sessionInfo.getComCode();
    String userid = sessionInfo.getUserId();
    String row_cnt = sessionInfo.getRowCnt();
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수  
	
	String st_dept_type		= CommonUtil.nvl((String) request.getParameter("st_dept_type"),""); 
	String st_req_dept_name	= CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),""); 
	String st_req_dept_code	= CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),""); 
	
	SimpleDateFormat _sdf = new SimpleDateFormat("yyyy");
	String st_po_create_year = CommonUtil.nvl((String) request.getParameter("st_po_create_year"),"");
	
	String SessionComCode	= "";
	String year	= _sdf.format(new Date());
	
	if ( "".equals(st_po_create_year) ) {
		st_po_create_year = Integer.toString(Integer.parseInt(year) - 1);
	}
	
	if (sessionInfo != null){ 
		SessionComCode	= sessionInfo.getComCode();  
	}
	
	//엑셀다운로드 기능 통제
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P17-0000001");
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE213") %><!-- 납기지연현황 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
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
			<table class="cont_t_list01"  >
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<colgroup>
                    <col width="10%" />
                    <col width="21%" />
                    <col width="10%" />
                    <col width="21%" />
                    <col width="10%" />
                    <col width="21%" />      
				</colgroup>
				
				<tbody>
				<tr>
					<th><%=CommonLang.get("HTITLE214") %><!-- 발주년도 --></th>
					<td>
						<select class="TitSelect" id="st_po_create_year" name="st_po_create_year"> 
<%
	int now_year	= Integer.parseInt(year);
	for( int i = now_year ; i >= 2000 ; i-- ) {
%>
							<option value="<%=i%>" <%if( Integer.parseInt(st_po_create_year) == i ) out.println("SELECTED"); %>><%=i%></option>
<%	}	%>
						</select>
					</td>  
                       
				    <th>
                        <label for="b_code" class="hidden">부서선택</label>                        
			  			<select name = "st_dept_type" id="st_dept_type"  class="TitSelect">
				      		<option value="PR" <%if ("PR".equals(st_dept_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></option>
				      		<option value="PO" <%if ("PO".equals(st_dept_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></option> 
                          </select> 
                       </th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="<%=st_req_dept_name%>" READONLY>
						<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="<%=st_req_dept_code%>">
						<a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
				</tr>
				</tbody>
			</table>
			<b><%=CommonLang.get("HTITLE215") %><!-- 조회기준 :  --></b><%=CommonLang.get("HTITLE646") %><!-- 발주 후  납기요청일이 지났는데도 아직 납품되지 않은 품목 -->
<!-- 
 1. 발주년도 조회 조건 추가
 2. 부서유형 / 부서정보 입력

 -->
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);">   
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
			</select>
      	</span>      
       <div class="fr">
       		<%=CommonLang.get("HTITLE594") %><!-- (기준 : 원) --> 
       </div>
       
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="8%" />
	            <col width="9%" />
	            <col width="8%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="10%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col"><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --><br><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE205") %><!-- 배송희망일 --><br><%=CommonLang.get("HTITLE185") %><!-- 주문일 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --><br><%=CommonLang.get("HTITLE208") %><!-- 발주일 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE217") %><!-- 발주수량 --><br><%=CommonLang.get("HTITLE218") %><!-- 지연일수 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --><br><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --><br><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></th>
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
				<tr align="center" bgcolor="<%=tclass%>">


						<td title="요청번호/관리번호">
				          <%=rowData.get("PR_NO")%><br> <%=rowData.get("REF_PR_NO")%>
				         </td>
				         <td title="배송희망일/주문일">
				            <%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br><%=CommonUtil.formatStrinigDate(rowData.get("CHANGE_DATE"))%>
				         </td>
				         <td title="품목코드/발주일">
				            <a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a><br><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
				         </td>
				         <td class="left" title="품목명/규격">
				            <%=rowData.get("DESCRIPTION")%><br><%=rowData.get("SPECIFICATION")%>
				         </td>
				         <td class="right" title="발주수량/지연일수">
				         <%=rowData.get("ITEM_QTY")%><br><%=CommonUtil.formatNumber(rowData.get("DELAY_DAY"),true,0,3)%>  
				         </td>
				         <td class="right" title="단가/금액"> 
				                 <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br>
				                <%=CommonUtil.formatNumber(rowData.get("PO_SUM"),true,0,3)%>
				         </td>
				         <td title="협력사/발주자">
				            <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_TEXT")%></a><br><%=rowData.get("PURCHASER_NAME")%>          
				         </td>
				         <td title="요청부서/발주부서">
				            <%=rowData.get("REQ_DEPT_NAME")%><br><%=rowData.get("PURCHASER_DEPT_NAME")%>
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
<%	}	%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
		</p>  
				 		<%
        if (_gridList == null || _gridList.size() == 0){        
        }else{
        %>
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<%
				//엑셀다운로드 기능 통제
				if(p170000001 == false){
				%>
        			<span class="btn_04 mr04">
						<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a>
					</span>
				<%
				}
				%>
            </div>
        </div>
             <%} %>
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
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
 
}

function getDepartmentCode(){ 
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code=<%=SessionComCode%>", "500,500,no"); 
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		document.forms.searchForm.curPage.value = 1; 
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		break;

	case "excelDown": // 엑셀다운로드 
	
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoDelayDlvyStateList.do";
		document.forms.searchForm.submit();
		
		break;

	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoDelayDlvyStateList.do").submit();   
}
  
function getPrDisplay(BUYER,PR_NO,STATUS_TEXT,RECV_FLAG,REF_NO){  
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO +'&RECV_FLAG='+RECV_FLAG, "800,600,no"); 
} 

function setPopupReturn(code, text) { 
		document.forms.searchForm.st_req_dept_code.value = code;
		document.forms.searchForm.st_req_dept_name.value = text; 
}



</script>
</html>
