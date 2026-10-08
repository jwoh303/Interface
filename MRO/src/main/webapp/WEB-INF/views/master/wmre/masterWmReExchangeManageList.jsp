<%--
**********************************************
* 메뉴 : 반품>고객사 반품 관리 
* 화면 : 고객사 반품 관리 
* 기능 : 
* 프로그램 ID : PG_08_M_019_06
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-17
**********************************************
--%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_common.js"></script> 
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

String curDate   = CommonUtil.formatDateNoDateGubun(new Date(),1);
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),""); 
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  
// String st_from_date  = "";
// String st_to_date    = "";
// st_from_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
// if( st_from_date.equals("")){    	
// 	st_from_date    = CommonUtil.addDate(new Date(),"M",-1,1);
// 	st_from_date = CommonUtil.formatStrinigDate(st_from_date);
// }else{
// 	st_from_date    = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");    	
// }


// st_to_date        = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");
// if( st_to_date.equals("")){    	
// 	st_to_date    = CommonUtil.formatDateNoDateGubun(new Date(),1);
// 	st_to_date = CommonUtil.formatStrinigDate(st_to_date);
// }else{
// 	st_to_date    = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");    	
// } 

String st_BUYER_PERSON_NAME = CommonUtil.nvl((String) request.getParameter("st_BUYER_PERSON_NAME"),"");    	
String st_WMRE_NO = CommonUtil.nvl((String) request.getParameter("st_WMRE_NO"),"");    	
String st_PO_NO = CommonUtil.nvl((String) request.getParameter("st_PO_NO"),"");    
String st_WMRE_TYPE = CommonUtil.nvl((String) request.getParameter("st_WMRE_TYPE"),"");    
String st_flag = CommonUtil.nvl((String) request.getParameter("st_flag"),"");    
String st_date_type= CommonUtil.nvl((String) request.getParameter("st_date_type"),"");    
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
	<h3><%=CommonLang.get("HTITLE219") %><!-- 반품진행현황 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
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
			
		<div id="cont_searchA"  style="width:680">	
        	<!-- 수정전 --><!-- table class="cont_t_list01" style="width:100%;"-->
            <table class="cont_t_list01" ><!-- 마이페이지 닫힐때 width="887"-->
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<colgroup>
					<col width="12%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="*" />
				</colgroup>
				
				<tbody>
				<tr>
							<th><select name="st_date_type" class="TitSelect">
								    <option value="b_req_date"  <%if ("b_req_date".equals(st_date_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></option>
									<option value="rd_date" <%if ("rd_date".equals(st_date_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE647") %><!-- 접수일자 --></option>
									<option value="po_create_date"  <%if ("po_create_date".equals(st_date_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE208") %><!-- 발주일 --></option>

								</select></th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="<%=st_from_date%>">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="<%=st_to_date%>">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
								<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>				
							</td>
					<td><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></td>
					<td>
						<input type="text" class="input_type_text" name="st_BUYER_PERSON_NAME" id="st_BUYER_PERSON_NAME" style="width:65%;ime-mode:active" value="<%=st_BUYER_PERSON_NAME %>"  onKeyDown="kepEnter()">
					</td>
				</tr>
				<tr>
					<td><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></td>
					<td>
						<input type="text" class="input_type_text" name="st_WMRE_NO" id="st_WMRE_NO" style="width:80%;ime-mode:active" value="<%=st_WMRE_NO%>"   onKeyUp="kepToUpper('st_WMRE_NO')"   onKeyDown="kepEnter()">
					</td>
					<td><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></td>
					<td>
						<input type="text" class="input_type_text" name="st_PO_NO" id="st_PO_NO" style="width:80%;ime-mode:active" value="<%=st_PO_NO%>"  onKeyUp="kepToUpper('st_PO_NO')" onKeyDown="kepEnter()">
					</td>
				</tr>
				
				<tr>	
							<th><%=CommonLang.get("HTITLE222") %><!-- 요청유형 --></th>
							<td>
								 <select id="st_WMRE_TYPE" name="st_WMRE_TYPE" style="width:80%;height:20px"  >
								<%= CommonUtil.getCodeComboQueryIdList("common.getTypeWM01","SEL",st_WMRE_TYPE ) %>
								</select>
							</td>
							<th><%=CommonLang.get("HTITLE606") %><!-- 진행상태 --></th>
							<td>								 
							  <select  name="st_flag" id= "st_flag" style="width:80%;height:20px">
							 	 <option value="" selected><%=CommonLang.get("HTITLE178") %><!-- 선택 --></option>
								<option value="1"  <%if ("1".equals(st_flag)) {%>selected<%} %>><%=CommonLang.get("HTITLE226") %><!-- 고객사요청 --></option>
								<option value="2" <%if ("2".equals(st_flag)) {%>selected<%} %>><%=CommonLang.get("HTITLE227") %><!-- KEP접수 --></option>
								<option value="3" <%if ("3".equals(st_flag)) {%>selected<%} %>><%=CommonLang.get("HTITLE228") %><!-- 종결 --></option>
								<option value="4" <%if ("4".equals(st_flag)) {%>selected<%} %>><%=CommonLang.get("HTITLE229") %><!-- 취소 --></option>
								</select>
							</td>

					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onChange="javascript:kepSearch(1);">   
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
			</select>
      	</span>        

       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%;table-layout:fixed;">
			<colgroup>
	            <col width="7%" />
	            <col width="6%" />
	            <col width="6%" />
	            <col width="35%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="5%" />
	            <col width="5%" />
	            <col width="6%" />
	            <col width="6%" />
	            <col width="6%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col"><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --><br><%=CommonLang.get("HTITLE648") %><!-- 발주순번 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE649") %><!-- 발주일자 --><br><%=CommonLang.get("HTITLE650") %><!-- 요청일자 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE52") %><!-- 단위 --><br><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --><br><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE651") %><!-- 요청수량 --><br><%=CommonLang.get("HTITLE217") %><!-- 발주수량 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE652") %><!-- 요청구분 --><br><%=CommonLang.get("HTITLE653") %><!-- 요청사유 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE654") %><!-- 접수자 --><br><%=CommonLang.get("HTITLE606") %><!-- 진행상태 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE647") %><!-- 접수일자 --><br><%=CommonLang.get("HTITLE655") %><!-- 완료일자 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE148") %><!-- 취소사유 --></th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="11" align="center" height = "50"> 
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
					<td title="요청번호" align="center"><%=CommonUtil.nvl(rowData.get("WMRE_NO"))%></td>                    
                    <td title="발주번호/발주순번" ><%=CommonUtil.nvl(rowData.get("PO_NO"))%><br/><%=CommonUtil.nvl(rowData.get("PO_SEQ"))%></td>
                    <td title="발주일자/요청일자"><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%><br/><%=CommonUtil.formatStrinigDate(rowData.get("B_REQ_DATE"))%></td>
                    <td class="left" title="품목명/규격"  style="word-break:break-all"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%><br/><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
                    <td class="left" title="단위/협력사" ><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE")) %><br/><%=CommonUtil.nvl(rowData.get("SELLER_NAME"))%></td>
                    <td class="left" title="요청부서/요청자" ><%=rowData.get("BUYER_DEPT_NAME")%><br/><%=CommonUtil.nvl(rowData.get("BUYER_PERSON_NAME"))%></td>
                    <td  class="right" title="요청수량/발주수량"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("WMRE_QTY")),true,0,3)%><br/><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,3)%></td>
                    <td title="요청구분/요청사유"   ><%=CommonUtil.nvl(rowData.get("WMRE_TYPE_NAME"))%><br/>
                     <%if("".equals(CommonUtil.nvl(rowData.get("B_REQ_REMARK")))) {%>
                <img src="/resources/images/icon2.gif"  border="0"> 
<% }else { %>
                <a  href="javascript:doPop( 'reason' ,'<%=rowData.get("B_REQ_REMARK")%>');"><img src="/resources/images/icon.gif" border="0"></a> 
<% } %>
                    </td>
                    <td class="left" title="접수자/진행상태" ><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME"))%><br/><%=CommonUtil.nvl(rowData.get("NAME_FLAG"))%></td>
                    <td title="접수일자"><%=CommonUtil.formatStrinigDate(rowData.get("M_REC_DATE"))%><br/><%=CommonUtil.formatStrinigDate(rowData.get("END_DATE"))%></td>
                    <td  title="취소사유" class="hyperLink"  align="center">
 <%if("".equals(CommonUtil.nvl(rowData.get("CANCEL_REMARK")))) {%>
                <img src="/resources/images/icon2.gif"   border="0"> 
<% }else { %>
                <a  href="javascript:doPop( 'cancel' ,'<%=rowData.get("CANCEL_REMARK")%>');"><img src="/resources/images/icon.gif"  border="0"></a> 
<% } %>
				</td>      
				</tr>	
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
        	
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
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
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

		document.forms.searchForm.curPage.value = 1; 
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
// 		kepSearch(-1);
		jspTableClean("table_list");
		break;

	
	}
}

  
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
		//조회기간을 3개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG95")%>");
		return;
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/wmre/getMasterWmReExchangeManageList.do").submit();   
}



//팝업함수호출
function doPop(str,reason) {
	
	switch (str) {
	case "reason":
		openSearchPopup('/wmco/showMasterWmReturnReasonPop.do', '?st_title=요청사유&st_reason='+reason ,'500,220,no');
		break;
	case "cancel":
		openSearchPopup('/wmco/showMasterWmReturnReasonPop.do', '?st_title=사유&st_reason='+reason ,'500,220,no');
		break;
	}
}

</script>

</html>
