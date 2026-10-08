<%--
**********************************************
* 메뉴 : 
* 화면 : 납품이슈현황 > 요청사항 상세조회 팝업
* 기능 : 요청사항 상세에 대한 팝업
* 프로그램 ID : SU0503006
* 담당자 : 최찬규
* 착수일 : 2025-11-03
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
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String st_type = CommonUtil.nvl((String) request.getParameter("value1"),"");  //  (조회조건)
String st_buyer = CommonUtil.nvl((String) request.getParameter("value2"),"");  //  (조회조건)
String st_po_no = CommonUtil.nvl((String) request.getParameter("value3"),"");  //  (조회조건)
String st_po_seq = CommonUtil.nvl((String) request.getParameter("value4"),"");  //  (조회조건)
String st_ds_seq = CommonUtil.nvl((String) request.getParameter("value5"),"");  //  (조회조건)
String st_seq = CommonUtil.nvl((String) request.getParameter("value6"),"");  //  (조회조건)
String st_agent = CommonUtil.nvl((String) request.getParameter("value7"),"");  //  (조회조건)
Map<String,String> rowData = null;

if (_dataList==null || _dataList.size()==0) {
}else {
	rowData = _dataList.get(0);
}
%>
<script type="text/javascript">
function kep_onload_view() {
	<%
		if (_dataList==null || _dataList.size()==0){
	%>
			setQuery();
	<%	
		}
	%>
}

function setQuery() {
  $('#sellerMpIvDeliChangeReqDetailPop').attr("action", "/mpiv/getSellerMpIvDeliChangeReqDetailPop_v2.do").submit();   
}

function kepEnter() {
	if (event.keyCode == 13) {
		setQuery();
	}
}
</script> 
<body onload="kep_onload_view()">
	 <form name="sellerMpIvDeliChangeReqDetailPop" id="sellerMpIvDeliChangeReqDetailPop" method="post">
	 <input type="hidden" name="st_type" id="st_type" value="<%=st_type%>"/>
	 <input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>"/>
	 <input type="hidden" name="st_po_no" id="st_po_no" value="<%=st_po_no%>"/>
	 <input type="hidden" name="st_po_seq" id="st_po_seq" value="<%=st_po_seq%>"/>
	 <input type="hidden" name="st_ds_seq" id="st_ds_seq" value="<%=st_ds_seq%>"/>
	 <input type="hidden" name="st_seq" id="st_seq" value="<%=st_seq%>"/>
	 <input type="hidden" name="st_agent" id="st_agent" value="<%=st_agent%>"/>
<%
if (_dataList==null || _dataList.size()==0) {
%>
<%
} else {
%>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup">
  <div class="PopupTit">요청사항 상세조회 <span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubState">요청내역 </div>
  <table class="PopupTableTxt" width="600px">
    <colgroup>
      <col width="120px" />
      <col width="480px" />  
  	</colgroup>
    <tr>
      <th>요청사항</th>
      <td><%=CommonUtil.nvl(rowData.get("TYPE_TEXT"))%></td>
    </tr>
    <tr>      
      <th>상세사유</th>
      <td>
      	<div style="height:70px; overflow:auto; overflow-x:hidden; ">
      <%if(CommonUtil.nvl(rowData.get("TYPE")).equals("D")){%><!-- 거래유형 변경 -->
    	  기존(<%=CommonUtil.nvl(rowData.get("RE_PROCESS_TYPE_TEXT"))%>) → 변경(<%=CommonUtil.nvl(rowData.get("CH_PROCESS_TYPE_TEXT"))%>_<%=CommonUtil.nvl(rowData.get("PARCEL_YN_TEXT"))%>)</br><%=CommonUtil.nvl(rowData.get("AGENT_REMARK"))%>
      <% }else if(CommonUtil.nvl(rowData.get("TYPE")).equals("E")){%><!-- 수주거부 -->
        	<%=CommonUtil.nvl(rowData.get("AGENT_REMARK"))%>
      <% }else if(CommonUtil.nvl(rowData.get("TYPE")).equals("G")){%> <!-- 납품예정일 변경 -->
      		기존(<%=CommonUtil.nvl(rowData.get("RE_DS_DATE"))%>) → 변경(<%=CommonUtil.nvl(rowData.get("CH_DS_DATE"))%>)</br><%=CommonUtil.nvl(rowData.get("AGENT_REMARK"))%>
      <% }else if(CommonUtil.nvl(rowData.get("TYPE")).equals("I")){%><!-- 수주접수 초기화 -->
      		<%=CommonUtil.nvl(rowData.get("AGENT_REMARK"))%>
      <% } %>
        </div>
      </td>
    </tr>
  </table>
  <%if(!CommonUtil.nvl(rowData.get("TYPE")).equals("D")){%>  
  <div class="PopupTitSub">대표 품목 정보</div>
  <table class="PopupTableTxt" width="600px">
    <colgroup>
      <col width="120px" />
      <col width="180px" />
      <col width="120px" />
      <col width="180px" />
  	</colgroup>
    <tr>
      <th>품목코드</th>
      <td><%=CommonUtil.nvl(rowData.get("PO_BUYER_ITEM_NO"))%></td>
      <th>거래유형</th>
      <td><%=CommonUtil.nvl(rowData.get("PO_PROCESS_TYPE"))%></td>
    </tr>
    <tr>
      <th>품목명</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("PO_DESCRIPTION"))%></td>
    </tr>
    <tr>
      <th>규격</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("PO_SPECIFICATION"))%></td>
    </tr>       
  </table>
  <%} %>  
</div><!-- warp 끝-->         
<%}%>                     
</form> 
</body>
</html>