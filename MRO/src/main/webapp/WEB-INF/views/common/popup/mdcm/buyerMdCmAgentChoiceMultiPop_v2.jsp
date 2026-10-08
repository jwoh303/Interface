<%--
**********************************************
* 메뉴 : 
* 화면 : 품목별협력사선택팝업
* 기능 : 품목별협력사선택팝업
* 프로그램 ID : BU0201012
* 담당자 : 최찬규
* 착수일 : 2026-01-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
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
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String buyer_item_no = (String) request.getAttribute("st_buyer_item_no");
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String SessionComCode = "";
	String agent_open_flag = "";
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
		agent_open_flag =  CommonUtil.nvl((String)sessionInfo.getAgentOpenFlag());
		
	}
%>

<script type="text/javascript">
var buyerItemNoLength = 0;

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view() {
	
}
function setAgent(){

	var query = "";
	
	var buyer_item_no = "<%=buyer_item_no%>";
	var buyerItemArr = buyer_item_no.split(",");
	
	for(var i = 0 ; i<buyerItemArr.length; i++){
		var index = $('input[name="'+buyerItemArr[i]+'"]:checked').val();
		query = query + $("#st_buyer_item_no"+index).val()+"@@"+$("#st_order_qty"+index).val()+"@@"+$("#st_agent"+index).val()+"@@"+$("#st_contract_no"+index).val()+"@@"+$("#st_contract_seq"+index).val()+"@@"+$("#st_byit_comorg_code"+index).val()+"&&"
	}
	parent.setPopupReturn(query);
	parent.closePop();
}
</script> 
<body onload="kep_onload_view()">
<form id="searchCondition" name="searchCondition" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup"  >
  <div class="PopupTit">품목별 협력사 선택<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubTxt">협력사를 선택해야 하는 품목의 협력사를 선택해 주세요.</div>
  <table class="PopupTableTHrow">
    <colgroup>
      <col width="130px" />
      <col width="250px" />
      <col width="250px" />
      <col width="150px" />
      <col width="100px" />
      <col width="100px" />
      <col width="100px" />
      <col width="100px" />
    </colgroup>  
  	<tr>
      <th>품목코드</th>
      <th>품목명</th>
      <th>협력사</th>
      <th>가격</th>
      <th>배송일수</th>
      <th>재고</th>
      <th>최소주문</th>
      <th>주문배수</th>
    </tr>
    <%
    String buyer_item_no_tmp = "";
    for(int i = 0; i<_gridList.size(); i++){ 
    	Map<String,String> rowData = _gridList.get(i);
    %>
    	<%if(buyer_item_no_tmp.equals(rowData.get("BUYER_ITEM_NO"))){%>
	    	<tr>
		      <td style="border-left:1px solid #dedede;"><label class="RadioMediumLabel" style="margin-left:0"><input type="radio" name="<%=rowData.get("BUYER_ITEM_NO")%>" value="<%=i%>"><span class="RadioMediumTxt"></span> 
		      	<%if(agent_open_flag.equals("N")){ %>
           			<%=CommonLang.get("HTITLE820")%>
           		<%}else{ %>
           			<%=rowData.get("COM_NAME_LOC")%>
           		<%} %>
           	</label></td>
		      <td align="right"><span class="F6495F"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>원</td>
		      <td align="right"><%=rowData.get("DELIVERY_LT")%>일</td>
		      <td align="right"><%=CommonUtil.formatNumber(rowData.get("STOCK_CNT"),true,0,3)%>개</td>
		      <td align="right"><%=CommonUtil.formatNumber(rowData.get("MIN_ORDER_QTY"),true,0,3)%>개</td>
		      <td align="right"><%=CommonUtil.formatNumber(rowData.get("PUR_UNIT_QTY"),true,0,3)%>개</td>
	    	</tr>
    	<%}else{ 
    		buyer_item_no_tmp = rowData.get("BUYER_ITEM_NO");
    	%>
	    	<tr>
		      <td rowspan="<%=rowData.get("LINE_CNT")%>"><%=rowData.get("BUYER_ITEM_NO")%></td>
		      <td rowspan="<%=rowData.get("LINE_CNT")%>"><%=rowData.get("DESCRIPTION")%></td>
		      <td><label class="RadioMediumLabel" style="margin-left:0" ><input type="radio" name="<%=rowData.get("BUYER_ITEM_NO")%>" value="<%=i%>" checked><span class="RadioMediumTxt"></span> 
				<%if(agent_open_flag.equals("N")){ %>
           			<%=CommonLang.get("HTITLE820")%>
           		<%}else{ %>
           			<%=rowData.get("COM_NAME_LOC")%>
           		<%} %>
           		</label></td>
		      <td align="right"><span class="F6495F"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>원</td>
		      <td align="right"><%=rowData.get("DELIVERY_LT")%>일</td>
		      <td align="right"><%=CommonUtil.formatNumber(rowData.get("STOCK_CNT"),true,0,3)%>개</td>
		      <td align="right"><%=CommonUtil.formatNumber(rowData.get("MIN_ORDER_QTY"),true,0,3)%>개</td>
		      <td align="right"><%=CommonUtil.formatNumber(rowData.get("PUR_UNIT_QTY"),true,0,3)%>개</td>
	    	</tr>
    	<%} %>
    	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no<%=i %>" value="<%=rowData.get("BUYER_ITEM_NO") %>" />
          <input type="hidden" name="st_agent" id="st_agent<%=i %>" value="<%=rowData.get("AGENT") %>" />
          <input type="hidden" name="st_contract_no" id="st_contract_no<%=i %>" value="<%=rowData.get("CONTRACT_NO") %>" />
          <input type="hidden" name="st_contract_seq" id="st_contract_seq<%=i %>" value="<%=rowData.get("CONTRACT_SEQ") %>" />
          <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code<%=i %>" value="<%=rowData.get("BUYER") %>" />
          <input type="hidden" name="st_order_qty" id="st_order_qty<%=i %>" value="<%=rowData.get("MIN_ORDER_QTY") %>" />
    <%}%>
  </table>
  <script>
    document.querySelectorAll('.PopupTableTHrow tr').forEach(function(tr){
      const tds = tr.querySelectorAll('td');
      tds.forEach(function(td, i) {
        td.addEventListener('mouseenter', function() {
          // 라디오버튼이 있는 td부터 끝까지 배경색 적용
          if (td.querySelector('input[type="radio"]')) {
            for (var j = i; j < tds.length; j++) {
              tds[j].style.backgroundColor = '#F7FAE6';
            }
          }
        });
        td.addEventListener('mouseleave', function() {
          tds.forEach(function(td2){ td2.style.backgroundColor = ''});
        });
      });
    });
  </script> 
  
  <div class="PopupListBtnBox_Center mt30"><button class="ButPrimary_large" onclick="javascript:setAgent(); return false;">확인</button></div>  
</div><!-- wrapPopup 끝-->
</form> 
</body>
</html>
