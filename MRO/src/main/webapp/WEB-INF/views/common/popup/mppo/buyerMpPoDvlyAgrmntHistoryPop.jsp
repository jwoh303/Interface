<%--
**********************************************
* 메뉴 : 
* 화면 : 납품합의 이력관리
* 기능 : 납품합의 이력을 관리하기 위한 화면
* 프로그램 ID : PG_06_B_019_01
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode());
String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
String st_po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
	<% if ("Y".equals(open)) { %>
  $('#buyerMpPoDvlyAgrmntHistoryPop').attr("action", "/mppo/getBuyerMpPoDvlyAgrmntHistoryPop.do").submit();    
  <%}%>
}
 
 //-->
</script> 
<body onload="kepSearch()">
<form name="buyerMpPoDvlyAgrmntHistoryPop" id="buyerMpPoDvlyAgrmntHistoryPop" method=post >
<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
<input type=hidden name="st_po_no" id="st_po_no"  value="<%=st_po_no%>">
<input type=hidden name="st_po_seq" id="st_po_seq"  value="<%=st_po_seq%>">
<% if ("".equals(open)) { %>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:444px;">
    	<div id="popHeader">
        	<h1 class="title">납품합의 이력관리</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">  
           	<!--grid-->
            <div class="scrollArea" style="height:365px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>납품합의 이력관리 리스트</caption>
                    <colgroup>
                        <col width="5%" /> 
                        <col width="13%" /> 
                        <col width="13%" /> 
                        <col width="*" /> 
                        <col width="13%" /> 
                        <col width="13%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">순번</th> 
                            <th scope="col">KeP담당자</th> 
                            <th scope="col">공급사담당자</th>
                            <th scope="col">납품조정일</th>
                            <th scope="col">납품합의일</th>
                            <th scope="col">사유</th>
                            <th scope="col">내용</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="7"  height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
				          <td   title="부서코드" height="25" ><%=(j+1)%></td>
				          <td   title="KeP담당자" ><%=rowData.get("KEP_USER_NAME")%></td>
				          <td   title="협력사담당자" ><%=rowData.get("SUPPLIER_USER_NAME")%></td>
				          <td   title="납품조정일" ><%=rowData.get("CREATE_DATE1")%>&nbsp;<%=rowData.get("CREATE_DATE2")%></td>
				          <td   title="납품조정일" ><%=rowData.get("APPROVAL_RD_DATE")%></td>
				          <td   title="사유" ><%=rowData.get("REASON_CODE_REMARK")%></td>
				          <td align="left"    title="내용" ><%=rowData.get("REASON_REMARK")%></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
<%} %>
</form> 
</body>
</html>
