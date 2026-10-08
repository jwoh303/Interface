<%--
**********************************************
* 메뉴 :관리자>카탈로그등록현황
* 화면 : 카탈로그등록현황
* 기능 : 카탈로그등록현황
* 프로그램 ID : PG_06_B_014_00
* 담당자 : 현명환
* 착수일 : 2015-04-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
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
	String budget_flag           = sessionInfo.getBudgetFlag();
	
    String fromDate  = "";
    String toDate    = "";

    fromDate        = CommonUtil.nvl((String) request.getParameter("fromDate"),"");
    if( fromDate.equals("")){
        toDate      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
        fromDate    = CommonUtil.addDate(new Date(),"M",-1,1);
    }else{
        toDate    = CommonUtil.nvl((String) request.getParameter("toDate"),"");
    }    
    fromDate = fromDate.replace("/", "");
    toDate = toDate.replace("/", "");   
    String from_year   = fromDate.substring(0,4);
    String from_month  = fromDate.substring(4,6);
    String from_day    = fromDate.substring(6,8);
    String v_fromDate   = from_year+"/"+from_month+"/"+from_day;
    String to_year   = toDate.substring(0,4);
    String to_month  = toDate.substring(4,6);
    String to_day    = toDate.substring(6,8);
    String v_toDate   = to_year+"/"+to_month+"/"+to_day;
    String SessionComCode        = sessionInfo.getComCode();
    String SessionUserId         = sessionInfo.getUserId();
    String row_cnt = sessionInfo.getRowCnt();
    
    String st_agent         = CommonUtil.nvl((String) request.getParameter("st_agent"),""); 
    String st_agent_name = CommonUtil.nvl((String) request.getParameter("st_agent_name"),"");
    String st_description        = CommonUtil.nvl((String) request.getParameter("st_description"),"");
    String st_specifcation        = CommonUtil.nvl((String) request.getParameter("st_specifcation"),"");
    String st_item_gubun = CommonUtil.nvl((String) request.getParameter("st_item_gubun"),"");    
    String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");
    String search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),"");
    

    // 진행상태
    String status        = CommonUtil.nvl((String) request.getParameter("st_status"),"ALL");
    // HTML 리스트 조회시 공통사용
    String pg_row             = CommonUtil.nvl((String) request.getParameter("st_pg_row"),""); 
 
    String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
 
    // HTML 리스트 조회시 공통사용
    //1개월
    String fromDate1  = "";
    String toDate1    = "";
    toDate1      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
    fromDate1    =    CommonUtil.addDate(new Date(),"M",-1,1);
    String from_year1   = fromDate1.substring(0,4);
    String from_month1  = fromDate1.substring(4,6);
    String from_day1    = fromDate1.substring(6,8);
    String v_fromDate1   = from_year1+"/"+from_month1+"/"+from_day1;
    String to_year1   = toDate1.substring(0,4);
    String to_month1  = toDate1.substring(4,6);
    String to_day1    = toDate1.substring(6,8);
    String v_toDate1   = to_year1+"/"+to_month1+"/"+to_day1; 
    
    String buyer = sessionInfo.getComCode();
    String userid = sessionInfo.getUserId();
    String SessionComOrg = CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());
	  if ("".equals(curPage)){ 
		  v_fromDate = v_fromDate1;
		  v_toDate = v_toDate1;

	 } 
    
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수  
 
%>  
<body onLoad="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>카탈로그등록정보</h3>
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
		<input type="hidden" name="st_buyer_org_code" id="st_buyer_org_code" value="<%=SessionComOrg%>">
		<input type="hidden" name="st_fromDate" value="<%=fromDate%>">
		<input type="hidden" name="st_toDate"   value="<%=toDate%>">
			
		<div id="cont_searchA" >
            <table class="cont_t_list01">
				<caption>조회</caption>
                <colgroup>
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
                    <col width="8%" />
                    <col width="21%" />
                </colgroup>
				
				<tbody>
				<tr>
				    <th>고객사</th>
					<td><select name="st_buyer_code"  id="st_buyer_code"  style="width:90%"> 
				             <option <%=(st_buyer_code.equals("KRDOOD0001")? "selected" : "")%> value="KRDOOD0001">두산중공업(주) 창원</option>
				             <option <%=(st_buyer_code.equals("KRDOOS0004")? "selected" : "")%> value="KRDOOS0004">두산중공업(주) 서울</option>
				          </select>		
					</td>
                    <th>품목코드</th>
					<td><input type="text"  class="input_type_text"   name="st_search_no" style="width:87%" value = "<%=(search_no.equals("ALL") ? "" : search_no)%>" onKeyDown="kepEnter()" /></td>
                    <th>품목구분</th>
					<td> <select name="st_item_gubun" id="st_item_gubun"  style="width:90%"> 
				            <option <%=(st_item_gubun.equals("ALL")? "selected" : "")%> value="">전체</option>
				            <option <%=(st_item_gubun.equals("N")? "selected" : "")%> value="N">단가계약품목</option>
				            <option <%=(st_item_gubun.equals("C")? "selected" : "")%> value="C">신규요청품목</option>
				            <option <%=(st_item_gubun.equals("A")? "selected" : "")%> value="A">일회성미발주</option>
						    </select>  
					</td>
				</tr>
                <tr>
					<th>협력사</th>
                    <td><input type="text"  class="input_type_text"  name="st_agent_name" style="width:65%" value = "<%=(st_agent_name.equals("ALL") ? "" : st_agent_name)%>" onKeyDown="kepEnter()" />
	                    		<input type="hidden" id="st_agent" name="st_agent" value="<%=(st_agent.equals("ALL") ? "" : st_agent)%>" />
	                    		<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a><a href="javascript:agentEraser();"><img src="/resources/images/btn_eraser2.gif"></a>
	                 </td>
					<th>품목명</th>
					<td><input type="text"  class="input_type_text"  name="st_description" style="width:87%" value="<%=(st_specifcation.equals("ALL") ? "" : st_specifcation)%>" onKeyDown="kepEnter()" /></td>
                    <th>규격</th>
					<td><input type="text"  class="input_type_text"   name="st_specifcation" style="width:87%" value = "<%=(st_specifcation.equals("ALL") ? "" : st_specifcation)%>" onKeyDown="kepEnter()" /></td>
		   		</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onChange="javascript:kepSearch(1);">   
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option>
				<option value = "300" <%if ("300".equals(onepagerow)) {%>selected<%} %>>300건</option>
			</select>
      	</span>      
       <span class="fr">(기준 : 원) </span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<table id="table_list" class="cont_t_list002" style="width:100%">
			<colgroup>
			 	  <col width="15%" />
                  <col width="20%" />
                  <col width="*" />
                  <col width="16%" />
                  <col width="10%" />                  
                  <col width="10%" />
	        </colgroup>
	        <thead>
        <tr>
          <th scope="col" >품목코드</th>
          <th scope="col">품목명</th>
          <th scope="col" >규격</th>
          <th scope="col" >협력사</th>
          <th scope="col" >단가</th>
          <th scope="col" >자재유형</th>
        </tr>
		</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
	<tr>
		<td colspan="15" align="center" height = "50"> 
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
       		  <td class="left" title="품목코드">	            
	             <a class="PDnameLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BELOW_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
	          </td>
	          <td class="left" title="품목명">
	            <%=rowData.get("DESCRIPTION")%>
	          </td>
	          <td class="left" title="규격">
				<%=rowData.get("SPECIFICATION")%>
	          </td>
	          <td title="협력사">
	            <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT_NAME")%></a>
	          </td>
	          <td  class="right"  title="단가">
	            <span class="Price"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>
	          </td>
	          <td title="자재유형">
	            <%=CommonUtil.formatNumber(rowData.get("ITEM_NO_NAME"),true,0,3)%>
	          </td>
      </tr>      
 <%}
} %>
           		</tbody>
            </table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
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
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
 
	kepSetCalender("fromDate");
	kepSetCalender("toDate"); 
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
		document.forms.searchForm.st_buyer_code.value = "KRDOOD0001";
		document.forms.searchForm.st_search_no.value = "";
		document.forms.searchForm.st_item_gubun.value = "";
		document.forms.searchForm.st_agent_name.value = "";
		document.forms.searchForm.st_agent.value = "";
		document.forms.searchForm.st_description.value = "";
		document.forms.searchForm.st_specifcation.value = "";
		
		
		jspTableClean("table_list");
		break;

	}
}
function agentEraser(){
	document.forms.searchForm.st_agent.value = "";
	document.forms.searchForm.st_agent_name.value = "";
}
// 조회
function kepSearch(curPage){
	
	document.forms.searchForm.curPage.value = curPage;

	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmAdminCatalogtList.do").submit();   
}

//팝업함수호출
function doPop(str, val, val2) {
	switch (str) {
		case "agent_single": // 협력사 M
			openSearchPopup("/common/icomcmpyPop.do", '?BUSINESS_COND=S&MULTI=N', "500,466,no");
			popupSel = "agent_single";
			break;	
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, val) {
	//팝업 조회후 해당 항목에 값을 셋팅
	switch (popupSel) {
		case "agent_single": // 협력사 M
				document.forms.searchForm.st_agent.value =code;
				document.forms.searchForm.st_agent_name.value =text;
			break;	
	}
}



</script>
</html>
