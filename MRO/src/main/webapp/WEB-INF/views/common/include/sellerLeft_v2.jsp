<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.menu.domain.Menu"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _leftList = (List<Map<String,String>>) request.getAttribute("left_data"); // 조회된결과
Map<String,String> leftData = (_leftList != null && _leftList.size() > 0) ? _leftList.get(0) : new HashMap<String, String>();

SessionInfo _sessionInfoLeft = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String SessionComCodeLeft		= _sessionInfoLeft.getComCode();
List<Map<String, String>> myMenuList = _sessionInfoLeft.getMyMenuList();

%>
<script type="text/javascript">
//팝업함수호출
function doPopLeft(str, value1, value2) {
	popupSel = str;

	switch (str) {
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			var st_com_code = '<%=SessionComCodeLeft%>';
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerInfoPop.do", "?st_com_code="+st_com_code+'&popup_flag=1', "440,500,no");
			break;
		case "commonNoNeMyMenuPop":
			openSearchPopup("/none/showCommonNoNeMyMenuPop_v2.do", "", "800,600,no");
			break;
	} 
}
</script>
<div class="wrap">
<section class="Sidebar"  >
      <!-- 상단 고정 메뉴 -->
      <div class="TopMenu">
		<div class="MyToDo">나의 할 일<br/> <span>집계기준:최근 3개월</span><p onclick="refreshLeft();"><img src="/resources/imgs/Refresh.png" /></p></div>
		<div class="MenuGroup">
          <div class="MainMenu"><img src="/resources/imgs/Sidebar_Icon03.png" />견적현황</div>
          <ul class="SubMenu">
            <li><a href="/mprq/showSellerMpRqQuotList.do?menuId=sr00301000000">일반견적<%if(Integer.parseInt(CommonUtil.nvl(String.valueOf(leftData.get("ACCEPT_SOURCING_WRITE_CNT")),"0"))>0) {%><p id="acceptSourcingWriteCnt"><%=CommonUtil.formatNumber(leftData.get("ACCEPT_SOURCING_WRITE_CNT"),true,0,3)%></p><%} %></a></li>
            <li><a href="/mpcl/showSellerMpClCatalogRecharterList.do?menuId=sr00302000000">재계약견적<%if(Integer.parseInt(CommonUtil.nvl(String.valueOf(leftData.get("ACCEPT_SOURCING_RE_WRITE_CNT")),"0"))>0) {%><p id="acceptSourcingReWriteCnt"><%=CommonUtil.formatNumber(leftData.get("ACCEPT_SOURCING_RE_WRITE_CNT"),true,0,3)%></p><%} %></a></li>
            <li><a href="/mprq/showSellerMpRqBulkQuotList.do?menuId=sr00303000000">프로젝트견적<%if(Integer.parseInt(CommonUtil.nvl(String.valueOf(leftData.get("PROJECT_SOURCING_WRITE_CNT")),"0"))>0) {%><p id="projectSourcingWriteCnt"><%=CommonUtil.formatNumber(leftData.get("PROJECT_SOURCING_WRITE_CNT"),true,0,3)%></p><%} %></a></li>
<!--             <li><a href="/menu3/sub2">프로젝트 견적</a></li>  -->
          </ul>
		</div>
		<div class="MenuGroup">
		  <div class="MainMenu"><img src="/resources/imgs/Sidebar_Icon01.png" />주문현황</div>
          <ul class="SubMenu">
            <li><a href="/mpiv/showSellerMpIvObtnodrReceipt.do?menuId=sr00402000000">수주접수<%if(Integer.parseInt(CommonUtil.nvl(String.valueOf(leftData.get("ORDER_RECEIVE_CNT")),"0"))>0) {%><p id="orderReceiveCnt"><%=CommonUtil.formatNumber(leftData.get("ORDER_RECEIVE_CNT"),true,0,3)%></p><%} %></a></li>
            <li><a href="/mpiv/showSellerMpIvTranStatementWrite.do?menuId=sr00403000000">거래명세서 생성<%if(Integer.parseInt(CommonUtil.nvl(String.valueOf(leftData.get("INVOICE_CRE_CNT")),"0"))>0) {%><p id="invoiceCreCnt"><%=CommonUtil.formatNumber(leftData.get("INVOICE_CRE_CNT"),true,0,3)%></p><%} %></a></li>
            <li><a href="/mpiv/showSellerMpIvDeliveryRecordReg.do?menuId=sr00404000000">납품실적등록<%if(Integer.parseInt(CommonUtil.nvl(String.valueOf(leftData.get("DELIVERY_RSLT_CRE_CNT")),"0"))>0) {%><p id="deliveryRsltCreCnt"><%=CommonUtil.formatNumber(leftData.get("DELIVERY_RSLT_CRE_CNT"),true,0,3)%></p><%} %></a></li>
          </ul>
		</div>
		<div class="MenuGroup">
          <div class="MainMenu"><img src="/resources/imgs/Sidebar_Icon02.png" />상품현황</div>
          <ul class="SubMenu">
            <li><a href="/mdct/showSellerMdCmChemicalMatMngList.do?menuId=sr00202000000">MSDS 대상<%if(Integer.parseInt(CommonUtil.nvl(String.valueOf(leftData.get("MATERIAL_REQUEST_CNT")),"0"))>0) {%><p id="materialRequestCnt"><%=CommonUtil.formatNumber(leftData.get("MATERIAL_REQUEST_CNT"),true,0,3)%></p><%} %></a></li> 
          </ul>
        </div>
		<div class="MenuMY">
          <div class="MainMY"><img src="/resources/imgs/star.png" />나의메뉴<span onclick="doPopLeft('commonNoNeMyMenuPop')">편집</span></div>
          <ul class="SidebarEdit" id ="SidebarEdit">
          		<% if(myMenuList == null || myMenuList.size() == 0 ){ %>
                <%} else {
                		for(int inx = 0 ; inx < myMenuList.size() ; inx++){
                			Map<String, String> menuItem = myMenuList.get(inx);
                %>
                	<li>
                		<a href="javascript:kep_view_link('<%=CommonUtil.nvl((String) menuItem.get("URL")) %>?menuId=<%=CommonUtil.nvl((String) menuItem.get("MENU_ID"))%>');"><%=CommonUtil.nvl((String) menuItem.get("NAME")) %></a>                		
                	</li>
                <%
                		}
                	}
                %>
                
            
          </ul>
		</div>
      </div>
 
      <!-- 하단 고정 메뉴 -->
      <div class="BottomMmenu">
        <div class="SidebarManager"><a href="#" onclick="doPopLeft('commonMpIvTranBuyerChoicePop');"><img src="/resources/imgs/Sidebar_manager.png" /> 담당자 찾기</a></div> 
      	<div class="SidebarRemote"><a href="http://113366.com/koreab2b" target="_blank"><img src="/resources/imgs/Sidebar_Remote.png" /> 원격지원</a></div>
      	<div class="SidebarCustomer"><a href="/mscs/sellerMCSCNotice.do?menuId=sr00701000000"><img src="/resources/imgs/Sidebar_customer.png" /> 고객센터</a></div>

	  </div>
	</section>
</div>
 <script>
 
 function refreshLeft(){
	 kepAjaxFormCallLeft("/main/leftMenuDataRefresh.do", "", "leftMenuDataRefresh");
 }
 function setMenu(dataList){
	 //가져온 메뉴 리스트 가지고 나의메뉴 수정
	 $("#SidebarEdit").empty();
	 dataList.forEach(function(item){
		 var url = item.URL+"?menuId="+item.MENU_ID; //메뉴아이디 파라미터로 같이 넘김
		 var aTag = $('<a>').attr('href',"javascript:kep_view_link('"+url+"');").text(item.NAME);
		 var liTag = $('<li>').append(aTag);
		 $("#SidebarEdit").append(liTag);
	 })
 }
 
 /**
  * ajax left 호출후 성공시 처리 함수
  */
 function kepAjaxSuccessLeft(pMethod , response){
	 if(pMethod == "leftMenuDataRefresh"){
		 if(response.msg && response.msg.length > 0 && response.msg[0].msg != null){
			 alert(response.msg[0].msg);
		 }else{
			 //새 데이터로 수정
			 $("#orderReceiveCnt").text(response.leftData[0].ORDER_RECEIVE_CNT);
			 $("#invoiceCreCnt").text(response.leftData[0].INVOICE_CRE_CNT);
			 $("#deliveryRsltCreCnt").text(response.leftData[0].DELIVERY_RSLT_CRE_CNT);
			 $("#materialRequestCnt").text(response.leftData[0].MATERIAL_REQUEST_CNT);
			 $("#acceptSourcingWriteCnt").text(response.leftData[0].ACCEPT_SOURCING_WRITE_CNT);
			 $("#projectSourcingWriteCnt").text(response.leftData[0].PROJECT_SOURCING_WRITE_CNT);
			 $("#acceptSourcingReWriteCnt").text(response.leftData[0].ACCEPT_SOURCING_RE_WRITE_CNT);
			 //프로젝트견적 추후 추가
// 			 $("#orderReceiveCnt").text(response.ORDER_RECEIVE_CNT);
			 
			 //메뉴쪽 refresh
			 var dataList = response.menuList;
			 if(dataList.length >0){
			 	setMenu(dataList);
			 }else{
								 
			 }
		 }
	 }
 }

 /**
  * ajax left 호출후 에러시 처리 함수
  */
 function  kepAjaxErrorLeft(pMethod , response) {
 }
</script>
