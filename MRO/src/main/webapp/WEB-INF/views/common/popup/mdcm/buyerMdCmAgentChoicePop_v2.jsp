<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사선택팝업
* 기능 : 협력사선택팝업
* 프로그램 ID : BU0201011
* 담당자 : 최찬규
* 착수일 : 2026-01-15
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
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String SessionComCode = "";
	String agent_open_flag = "";
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
		agent_open_flag =  CommonUtil.nvl((String)sessionInfo.getAgentOpenFlag());
		
	}
%>

<script type="text/javascript">
var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view() {
}
function setAgent(){

	var index = "";
	
	$("input[name='agentCheck']:checked").each(function(e){
		index = $(this).attr("id");
	});
	if(index == ""){
		var text = "협력사를 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	query = $("#st_buyer_item_no"+index).val()+"@@"+$("#st_order_qty"+index).val()+"@@"+$("#st_agent"+index).val()+"@@"+$("#st_contract_no"+index).val()+"@@"+$("#st_contract_seq"+index).val()+"@@"+$("#st_byit_comorg_code"+index).val()+"&&";
	parent.setPopupReturn(query);
	parent.closePop();
}
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup"  >
  <div class="PopupTit">협력사 선택<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubTxt">협력사를 선택해주세요.</div>
  <div class="Popup_GrayBox mt05">
    <table class="NoLine_TDBottom1px" width="100%">
      <tr>
        <th width="30%">품목코드</td>
        <td width="70%"><%=_gridList.get(0).get("BUYER_ITEM_NO") %></td>
      </tr>
      <tr>
        <th>품목명</td>
        <td><%=_gridList.get(0).get("DESCRIPTION") %></td>
      </tr>
    </table>    
  </div>
  <div class="SellerSelect mt25">
      <button id="SSleftBtn"></button>
      <div class="SSelectArea" id="SSellerArea">
      <%if(_gridList.size() != 0 && _gridList != null) {%>
          	<%for(int i = 0; i<_gridList.size(); i++){ 
          		Map<String,String> rowData = _gridList.get(i);
          	%>
        <div class="SSelectBox">
          <label class="CheckLargeLabel" ><input type="checkbox" name="agentCheck" id="<%=i%>" <%if(i==0) {%>checked<%} %>><span class="CheckLargeCustom"></span>
          <input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no<%=i %>" value="<%=rowData.get("BUYER_ITEM_NO") %>" />
          <input type="hidden" name="st_agent" id="st_agent<%=i %>" value="<%=rowData.get("AGENT") %>" />
          <input type="hidden" name="st_contract_no" id="st_contract_no<%=i %>" value="<%=rowData.get("CONTRACT_NO") %>" />
          <input type="hidden" name="st_contract_seq" id="st_contract_seq<%=i %>" value="<%=rowData.get("CONTRACT_SEQ") %>" />
          <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code<%=i %>" value="<%=rowData.get("BUYER") %>" />
          <input type="hidden" name="st_order_qty" id="st_order_qty<%=i %>" value="<%=rowData.get("MIN_ORDER_QTY") %>" />
           	<%if(agent_open_flag.equals("N")){ %>
           		<%=CommonLang.get("HTITLE820")%>
           	<%}else{ %>
           		<%=rowData.get("COM_NAME_LOC")%>
           	<%} %>
          </label>
          <table class="BoxSellerTable mt20">
            <colgroup>
              <col width="90px" />
              <col width="100px" />
            </colgroup>  
            <tr>
              <th>배송일수</th>
              <td><%=rowData.get("DELIVERY_LT")%><%=CommonLang.get("HTITLE834")%><!-- 일 --></td>
            </tr>
            <%if(!rowData.get("STOCK_CNT").equals("")) {%>
            <tr>
              <th>재고</th>
              <td><%=CommonUtil.formatNumber(rowData.get("STOCK_CNT"),true,0,3)%>개</td>
            </tr>
            <%} %>
            <tr>
              <th>최소주문</th>
              <td><%=CommonUtil.formatNumber(rowData.get("MIN_ORDER_QTY"),true,0,3)%>개</td>
            </tr>
            <tr>
              <th>주문배수</th>
              <td><%=CommonUtil.formatNumber(rowData.get("PUR_UNIT_QTY"),true,0,3)%>개</td>
            </tr>
            <tr>
              <th>가격</th>
              <td><span><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></span>원</td>
            </tr>
          </table>
        </div>
        	<%} %>
       <%} %>
      </div>
      <button id="SSrightBtn"></button>
  </div>
  <script>
    const boxes = document.querySelectorAll('.SSelectBox');
    
    boxes.forEach(function(SSelectBox) {
      const checkbox = SSelectBox.querySelector('input[type="checkbox"]');
    
      // ✅ 박스 전체 클릭 시 체크 + 선택
      SSelectBox.addEventListener('click', function(e) {
        // label 내부의 checkbox 클릭일 경우 중복 방지
        if (e.target.tagName.toLowerCase() === 'input') return;
    
        // 모든 박스 초기화
        boxes.forEach(function(b) {
          b.querySelector('input[type="checkbox"]').checked = false;
          b.classList.remove('SSelected');
        });
    
        // 현재 박스 선택
        checkbox.checked = true;
        SSelectBox.classList.add('SSelected');
      });
    
      // ✅ 체크박스 클릭 시도 동일하게 작동 (라디오처럼 1개만)
      checkbox.addEventListener('change', function() {
        boxes.forEach(function(b) {
          b.querySelector('input[type="checkbox"]').checked = false;
          b.classList.remove('SSelected');
        });
        checkbox.checked = true;
        SSelectBox.classList.add('SSelected');
      });
    });
    
    // 좌우 이동
    const scrollArea = document.getElementById('SSellerArea');
    document.getElementById('SSleftBtn').addEventListener('click', function(){
      scrollArea.scrollBy({ left: -240, behavior: 'smooth' });
    });
    document.getElementById('SSrightBtn').addEventListener('click', function(){
      scrollArea.scrollBy({ left: 240, behavior: 'smooth' });
    });
  </script>    
  <div class="PopupListBtnBox_Center mt30"><button class="ButPrimary_large" onclick="javascript:setAgent(); return false;">확인</button></div>  
</div><!-- wrapPopup 끝--> 
</body>
</html>
