<%--
**********************************************
* 메뉴 :관리자>신규품목현황
* 화면 : 신규품목현황
* 기능 : 신규품목현황
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
	<h3>신규품목현황</h3>
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
		<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=buyer%>">
		<input type="hidden" name="st_fromDate" value="<%=fromDate%>">
		<input type="hidden" name="st_toDate"   value="<%=toDate%>">
			
		<div id="cont_searchA" >
            <table class="cont_t_list01">
				<caption>조회</caption>
                <colgroup>
                    <col width="10%" />
                    <col width="*" />
                </colgroup>
				<tbody>
				<tr>
					<th>
				        수정일
					</th>
					<td>
						<input type="text" class="input_type_text" name="fromDate" id="fromDate" readOnly style="width:15%;text-align:center;" value="<%=v_fromDate%>"> - 
                        <input type="text" class="input_type_text" name="toDate" id="toDate" readOnly style="width:15%;text-align:center;"  value="<%=v_toDate%>"> 
                        <span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','2')">2개월</a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','3')">3개월</a></span>	
						<span class="btn_month"><a href="javascript:setCurMonth('fromDate','toDate')">당월</a></span>									
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onChange="javascript:kepSearch(1);">   
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option> 
			</select>
      	</span>      
       <span class="fr">(기준 : 원) </span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
			 	  <col width="18%" />
                  <col width="*" />
                  <col width="10%" />
                  <col width="15%" />
                  <col width="13%" />
	        </colgroup>
	        <thead>
        <tr>
          <th scope="col"  >카테고리명<br>품목코드</th>
          <th scope="col">품목명<br>규격</th>
          <th scope="col" >단가<br>단위</th>
          <th scope="col" >제조사<br>협력사</th>
          <th scope="col" >수정일<br>요청자</th>
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
       <td title="카테고리명/품목코드">	            
	             <%=rowData.get("CATEGORY_TEXT")%><br>
	               <%=rowData.get("BUYER_ITEM_NO")%>
	          </td>
	          <td class="left" title="품목명/규격">
	            <%=rowData.get("DESCRIPTION")%><br>
				<%=rowData.get("SPECIFICATION")%>
	          </td>
	          <td  title="단가/단위">
	            <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br>
				<%=rowData.get("UNIT_MEASURE")%>
	          </td>
	          <td title="제조사/협력사">
	            <%=rowData.get("MAKER_NAME")%><br>
				<a class="hyperLink" href="javascript:doPop('agent','<%=String.valueOf(rowData.get("AGENT"))%>');"><%=rowData.get("AGENT_NAME")%></a>
	          </td>
	          <td   title="수정일/요청자">
	            <%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%><br>
				<%=rowData.get("ADD_USER_NAME")%>
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
	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fl">
			<span class="btn_04 mr04">
				<a href="javascript:doAction('excelPoDown', '');">신규품발주현황</a>
			</span>
		</div>
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
	 
		// 조회일 초기 셋팅
		kepSetCalender("fromDate");
		kepSetCalender("toDate");		
		$("#fromDate").val( kepToMonthAdd("1","M"));
		$("#toDate").val( kepGetNowTimeStr('YYYYMMDD','/'));   		
		jspTableClean("table_list");
		break;
	case "excelDown": // 엑셀다운로드
		if (kepGetDateDiff('fromDate','toDate','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.");
			return;
		}
		document.forms.searchForm.action = "/mprq/getBuyerMpRqQuotaSourcExcelDown.do";
		document.forms.searchForm.submit();
		
		break;
	case "excelPoDown": // 신규발주다운로드
		if (kepGetDateDiff('fromDate','toDate','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.");
			return;
		}
		document.forms.searchForm.action = "/mprq/getBuyerMpRqQuotaNewPoExcelDown.do";
		document.forms.searchForm.submit();
		
		break;
	}
}

// 조회
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return;  
	if (kepGetDateDiff('fromDate','toDate','D') > 93 ){
		alert("조회기간을 3개월 단위로 조회가 가능합니다.");
		return;
	}
	document.forms.searchForm.curPage.value = curPage;

	$('#searchForm').attr("action", "/mprq/getBuyerMpRqQuotaSourcAdmin.do").submit();   
}

//팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	
	switch (str) {
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+val, "800,550,no");
		break;
	}
}



</script>
</html>
