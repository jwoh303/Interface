<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사별집계
* 기능 : 협력사별 발주 집계
* 프로그램 ID : PG_06_B_018_01
* 담당자 : 현명환
* 착수일 : 2015-04-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList =  (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   

SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");


String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"),""); // 조회조건
String fromDate = CommonUtil.nvl((String) request.getParameter("fromDate"),""); // 조회조건
String toDate = CommonUtil.nvl((String) request.getParameter("toDate"),""); // 조회조건
String st_search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),""); // 조회조건
String st_legacy_po_no = CommonUtil.nvl((String) request.getParameter("st_legacy_po_no"),""); // 조회조건
String st_dept_no = CommonUtil.nvl((String) request.getParameter("st_dept_no"),""); // 조회조건
String st_dept_nm = CommonUtil.nvl((String) request.getParameter("st_dept_nm"),""); // 조회조건
String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),""); // 조회조건
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),""); // 조회조건
String st_sort_flag = CommonUtil.nvl((String) request.getParameter("st_sort_flag"),""); // 조회조건


String SessionComCode = "";
String byca_comorg_code = ""; 
String buyer = ""; 
String user_dept              = ""; 
String userId = "";
String byca_comorg_level = "";
String dept_name = "";

String searchALL = "전체";

if (sessionInfo != null){ 
	SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
	byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());  
	buyer  = SessionComCode;
	user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
	dept_name =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
	userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	byca_comorg_level = CommonUtil.nvl((String)sessionInfo.getBycaComorgLevel()); 
}  

%>

<script type="text/javascript">
function dept_print()
{  	 
	window.print();

}
//정렬
function setSortingList(sort_column) {
	document.forms.searchForm.st_sort_column.value = sort_column;
	
	var sort_flag = document.forms.searchForm.st_sort_flag.value;
	if(sort_flag=="ASC") {
		document.forms.searchForm.st_sort_flag.value = "DESC";
	}else {
		document.forms.searchForm.st_sort_flag.value = "ASC";
	} 
	kepSearch(1);
}

// 조회
function kepSearch(curPage){	
	document.forms.searchForm.target = "_self"; 
	$('#searchForm').attr("action", "/mppo/getBuyerMpPoOrderAgentPop.do").submit();   
}

 //-->
</script> 
<body>
<form name="searchForm" id="searchForm" method=post >
<input type=hidden name="st_date_type" id="st_date_type"  value="<%=st_date_type%>">
<input type=hidden name="fromDate" id="fromDate"  value="<%=fromDate%>">
<input type=hidden name="toDate" id="toDate"  value="<%=toDate%>">
<input type=hidden name="st_search_no" id="st_search_no"  value="<%=st_search_no%>">
<input type=hidden name="st_legacy_po_no" id="st_legacy_po_no"  value="<%=st_legacy_po_no%>">
<input type=hidden name="st_dept_no" id="st_dept_no"  value="<%=st_dept_no%>">
<input type=hidden name="st_dept_nm" id="st_dept_nm"  value="<%=st_dept_nm%>">
<input type=hidden name="st_status" id="st_status"  value="<%=st_status%>">
<input type=hidden name="st_buyer_code" id="st_buyer_code"  value="<%=st_buyer_code%>">
<input type=hidden name="st_sort_column" id="st_sort_column"  value="">
<input type=hidden name="st_sort_flag" id="st_sort_flag"  value="<%=st_sort_flag%>">

<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div id="popWrapper" style="height:600px;">
   	<div id="popHeader">
       	<h1 class="title">협력사별집계</h1>
           <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
       </div>
       <!--팝업내용입니다-->
       <div id="popContainer"> 
          	<!--grid-->
          	  <table  class="cont_t_list06"  style="width:100%">
                   <caption>구매요청(발주)  리스트</caption>
                   <colgroup>
                       <col width="15%" />
                       <col width="35%" />                   
                       <col width="15%" />              
                       <col width="35%" />                 
                   </colgroup>
                       <tr>
<% if(st_date_type.equals("PO")){ %>
                        <th scope="row" class="center">주문일자</th>
<%}else{ %>
						<th scope="row" class="center">입고일자</th>
<%} %> 
						<td colspan="3" ><%=fromDate%> ~ <%=toDate%></td>
					</tr>
                    <tr>
                      <th scope="row"  class="center">요청부서</th><td><%if(st_dept_nm.equals("")){%><%=searchALL%><%}else{%><%=st_dept_nm%><%}%></td>
                      <th scope="row"  class="center">제품코드</th><td><%if(st_search_no.equals("")){%><%=searchALL%><%}else{%><%=st_search_no%><%}%></td>
                    </tr>
                    <tr>
                      <th scope="row"  class="center">주문번호</th><td><%if(st_legacy_po_no.equals("")){%><%=searchALL%><%}else{%><%=st_legacy_po_no%><%}%></td>
                      <th scope="row"  class="center">진행상태</th><td><%if(st_status.equals("")){%><%=searchALL%><%}else{%><%=st_status%><%}%></td>
                    </tr>
		     </table>				
<br> 
            <div class="scrollArea" style="height:280px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>구매요청(발주)  리스트</caption>
                    <colgroup>
                        <col width="15%" />                   
                        <col width="*" />                   
                        <col width="13%" />                   
                        <col width="15%" />                   
                        <col width="15%" />                   
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">협력사코드</th> 
                            <th scope="col"><a href="javascript:setSortingList('3');">협력사명</a></th>
							<th scope="col">주문건 수</th>   
							<th scope="col"><a href="javascript:setSortingList('4');">발주금액</a></th>   
							<th scope="col"><a href="javascript:setSortingList('5');">입고금액</a></th>   
                        </tr>              
                    </thead>
                    <tbody>
<%
double tot_po_amt = 0;
double tot_gr_amt = 0;
double tot_po_cnt = 0;
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="10" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
	tot_po_amt += Double.parseDouble(rowData.get("PO_AMT"));
	tot_gr_amt += Double.parseDouble(rowData.get("GR_AMT"));
	tot_po_cnt += Double.parseDouble(rowData.get("PO_CNT"));
%>     
		<tr>
		  <td height="25" align="center" title="협력사코드"><%=rowData.get("AGENT")%></td>
          <td title="협력사명" class="left"><%=rowData.get("AGENT_NAME")%></td>
          <td class="right" title="주문건수"><%=CommonUtil.formatNumber(rowData.get("PO_CNT"),true,0,3)%></td>
          <td class="right" title="발주금액"><%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%></td>
          <td class="right" title="입고금액"><%=CommonUtil.formatNumber(rowData.get("GR_AMT"),true,0,3)%></td>
		<tr>

<%}
%>
		<tr>
			<td height="25" align="center"  colspan="2" title="부서코드">합계</td>
			<td class="right" title="주문건수"><%=CommonUtil.formatNumber(tot_po_cnt,true,0,3)%></td>
			<td class="right" title="발주금액"><%=CommonUtil.formatNumber(tot_po_amt,true,0,3)%></td>
			<td class="right" title="입고금액"><%=CommonUtil.formatNumber(tot_gr_amt,true,0,3)%></td>
		</tr>
<%

}%>   
	                 
			
                    </tbody>
                </table> 
                        </div>      
                <table style="width:100%">			
			      <tr>			
			        <td align="right">	
			  			<span class="btn_02 mr02"  title="출력"><a href="javascript:dept_print();">출력</a></span>  
			  		</td>
			      </tr>			
			    </table>           
  
    </div>        

</div>
</form> 
</body>
</html>
