<%--
**********************************************
* 메뉴 : 장바구니 > 주문완료
* 화면 : 장바구니 > 주문완료
* 기능 : 
* 프로그램 ID : BU0401006
* 담당자 : 최찬규
* 착수일 : 2026-05-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head> 
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>

<%
//공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	List<Map<String,String>> _gridList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된 결과
	String passYn = (String) request.getParameter("passYn");
	String key_1 = (String) request.getParameter("key_1");
	String st_gr_flag = (String) request.getParameter("st_gr_flag");
	String type = (String) request.getParameter("type");
	String buyer = (String) request.getParameter("buyer");
	
	String remark = "";
	String pre_gr_date = "";
	String total_cnt = "0"; // 총 조회수 (필수)
	if (_gridList != null){
		total_cnt = String.valueOf(_gridList.size());
		remark = _gridList.get(0).get("REMARK");
		pre_gr_date = _gridList.get(0).get("PRE_GR_DATE");
	}	
	
	 double tot_price  = 0;
	 ArrayList<String> dely_name_list = new ArrayList<String>();
     ArrayList<String> dely_text_list = new ArrayList<String>();
     ArrayList<Integer> cnt_list = new ArrayList<Integer>();
	 
  	// 품목별 도착지 지정(TYPE 상관없이 공통)
 	boolean p060000100 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000100");
  
     if( p060000100 == true){
   	    String dely_temp = "";
   	    int cnt_temp = 0;
   		if (_gridList != null){
   			if (_gridList.size()>0){
   				for(int i = 0; i<_gridList.size(); i++){
   					Map<String,String> rowItemData = _gridList.get(i);
   					if(!rowItemData.get("DELY_TO_LOCATION").equals(dely_temp)){
   						if(i != 0){
   							cnt_list.add(cnt_temp);
   							cnt_temp = 1 ;
   						}else{
   							cnt_temp++;
   						}
   						dely_name_list.add(rowItemData.get("DELY_TO_LOCATION_NAME"));
   						dely_text_list.add(rowItemData.get("DELY_TO_LOCATION_TEXT"));
   						dely_temp = rowItemData.get("DELY_TO_LOCATION");
   					}else{
   						cnt_temp++;
   					}
   					if(i == _gridList.size() -1){
   						cnt_list.add(cnt_temp);
   					}
   				}
   			}
   		} 
     }
     
  // 특이사항 명칭 변경
 	Map<String, String> p060000122_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000122");
 	String p060000122_col1 = CommonLang.get("HTITLE1225"); // 특이사항 명칭 변경 값 / default - 배송특이사항
     if (p060000122_map != null){
     	p060000122_col1 = CommonUtil.nvl(p060000122_map.get("COL01_DATA"),""); 
     }
     
%> 
<body>
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div class="CartPageTit">
    <%=CommonLang.get("HTITLE1005") %><!-- 주문완료 -->
    <div class="CartGuide">
      <div class="CartGuideTxt_on"><p>1</p><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></div> 
      <div class="CartGuideTxtBr"></div> 
      <div class="CartGuideTxt_on"><p>2</p><%=CommonLang.get("HTITLE1424") %><!-- 주문/결제 --></div> 
      <div class="CartGuideTxtBr"></div> 
      <div class="CartGuideTxt_on"><p>3</p><%=CommonLang.get("HTITLE1005") %><!-- 주문완료 --></div> 
    </div>
  </div>
 <form name = "contentForm" id="contentForm" method = "post">
		
  <div class="CARTcontainer">
	<div class="CARTleft">
	<div class="OrderComplete mt80">
        <img src="/resources/imgs/Icon_check_won.png" />
        <%if(type.equals("PX")) {%>
        <p class="mt30"><%=CommonLang.msg("MSG903")%><!--주문이 완료되었습니다.--></p>
        <%}else{ %>
        <p class="mt30"><%=CommonLang.msg("MSG904")%><!--주문요청이 완료되었습니다.--></p>
        <p class="mt15"><%=CommonLang.msg("MSG905")%><!--발주자가 발주처리 이후 주문이 완료됩니다.--></p>
        <%} %>
        <p class="h40"></p>
      </div> 
	<%if(!p060000100) {%> <!-- 품목별 배송지가 아닌 경우 , 데이터의 0번째 INDEX로 가져옴(다 똑같음) -->
      <!--배송정보 -->  
      <div class="CART_Addbox mt20">
        <div class="CART_AddboxTit"><%=CommonLang.get("HTITLE824") %><!-- 배송정보 --> </div>
        <p class="Shipper"><%=_gridList.get(0).get("DELY_TO_LOCATION_NAME") %></p>
        <p class="DeliveryAdd mt10"><%=_gridList.get(0).get("DELY_TO_LOCATION_TEXT") %></p>
        <p class="DeliveryAdd mt10"><%=_gridList.get(0).get("RECV_USER_NAME") %> <span class="DeliveryAddBr">｜</span> <%=_gridList.get(0).get("RECV_USER_TEL") %>  <span class="DeliveryAddBr">｜</span> <span class="DeliveryDate"><%=CommonLang.get("HTITLE831") %><!-- 수령희망일 --></span> <%=_gridList.get(0).get("RD_DATE") %></p>
      </div>
      <div class="CART_Sort mt20 mb10">
        <p><%=CommonLang.get("HTITLE1222") %><!-- 주문품목 --> <span>(<%=total_cnt %>)</span></p>
        <div class="Rrightlabel"><button class="But_ExcelDown40" onclick="javascript:excelDown(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button></div> 
      </div>
      	<table class="SimpleView" id="simpleView" width="960px">
          <tr>
            <th width="160px"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
            <th width="200px"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
            <th width="230px"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
            <th width="130px"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
            <th width="100px"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
            <th width="140px"><%=CommonLang.get("HTITLE922")%><!-- 합계 --></th>
          </tr>
      <%
	      for(int j = 0; j<_gridList.size(); j++) {
	    	  Map<String,String> rowData = _gridList.get(j);
				
				tot_price += Double.parseDouble(rowData.get("TOT_PRICE"));
      %>
      
          <tr>
            <td align="center"><%=rowData.get("BUYER_ITEM_NO") %></td>
            <td align="left"><%=rowData.get("DESCRIPTION_LOC") %></td>
            <td align="left"><%=rowData.get("SPECIFICATION") %></td>
            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%></td>
            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TOT_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
          </tr>
      <%} %>
	  </table>
      
	 <%}else{ %>
	 	<!--배송지묶음 -->  
      <div class="CART_SortBig mt20">
        <p><%=CommonLang.get("HTITLE824")%><!-- 배송정보 --> <span>(<%=dely_name_list.size() %>)</span></p>
         
        <div class="Rrightlabel" style="float: right;"><button class="But_ExcelDown40" onclick="javascript:excelDown(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button></div>
      </div>
      <%
	    int index2 = 0;
	    boolean startFlag2 = true; //첫 시작 flag
      	for(int i = 0; i<dely_name_list.size(); i++){ %>
      	<div class="CART_Addbox mt20">
			<div class="DelAdd mb20">
	          <div><%=CommonLang.get("HTITLE583")%><!-- 배송지 --><%=i+1 %></div> 
	          <div><%=dely_name_list.get(i) %></div>
	          <div><%=dely_text_list.get(i) %></div>
	        </div>
			<div class="DelGoods"><%=CommonLang.get("HTITLE1222") %><!-- 주문품목 --> <span>(<%=cnt_list.get(i) %>)</span> 
			</div>
      		<div class="SimpleViewScroll02" id="simpleView<%=i %>">
		      <table class="SimpleView"  width="1000px" >
		          <tr>
		            <th width="150px"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
		            <th width="200px"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
		            <th width="250px"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE922")%><!-- 합계 --></th>
		            <th width="100px"><%=CommonLang.get("HTITLE827")%><!-- 인수자명 --></th>
		          </tr>
		      <%
			      for(int j = index2; j<_gridList.size(); j++) {
			    	  Map<String,String> rowData = _gridList.get(j);
						if(!startFlag2){
							Map<String,String> rowData2 = _gridList.get(j-1);
							if(!rowData.get("DELY_TO_LOCATION").equals(rowData2.get("DELY_TO_LOCATION"))){
								startFlag2 = true;
								index2 = j;
								break;
							}
						}
						tot_price += Double.parseDouble(rowData.get("TOT_PRICE"));
		      %>
		      
		          <tr>
		            <td align="center"><%=rowData.get("BUYER_ITEM_NO") %></td>
		            <td align="left"><%=rowData.get("DESCRIPTION_LOC") %></td>
		            <td align="left"><%=rowData.get("SPECIFICATION") %></td>
		            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
		            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%></td>
		            <td align="right"><%=CommonUtil.formatNumber(rowData.get("TOT_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
		          	<td align="center"><%=rowData.get("RECV_USER_NAME") %></td>
		          </tr>
		      <%
		      	startFlag2 = false;
			      } %>
			  </table>
			 </div>
		 </div>
      <%} %>
	 <%} %>
	 <input type="hidden" name="tot_price" id="tot_price" value="<%=tot_price%>">
	 <div class="h50"></div>
	</div>
	
	<div class="CARTright">
      <div class="OptionBoxLine">
        <div class="OptionTit mt30 mb20 ml20 mr20" ><%=CommonLang.get("HTITLE835") %><!-- 주문정보 -->
        <%if(st_gr_flag.equals("S")) {%>
        	<span class="OptionTitBr ml05"><%=CommonLang.get("HTITLE842") %><!-- 선입고 --></span> 
        <%}else if(st_gr_flag.equals("F")) {%>
        	<span class="OptionTitBr ml05"><%=CommonLang.get("HTITLE840") %><!-- 긴급발주 --></span> 
        <%} %> 
        </div>
        <table class="OptionTable01 mb20">
         <tr>
           <th><%=CommonLang.get("HTITLE1179") %><!-- 주문요청번호 --></th>
           <td><span><%=_gridList.get(0).get("PR_NO") %></span></td>
         </tr>
         <tr>
           <th><%=CommonLang.get("HTITLE1222") %><!-- 주문품목 --></th>
           <td><span><%=CommonUtil.formatNumber(total_cnt,true,0,3)%></span><%=CommonLang.get("HTITLE96")%><!-- 개 --></td>
         </tr>
         <tr>
           <th><%=CommonLang.get("HTITLE1059") %><!-- 주문금액 --></th>
           <td><span><%=CommonUtil.formatNumber(tot_price,true,0,3)%></span><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
         </tr>
         <%if(type.equals("PX") && passYn.equals("N")) {%>
	         <%if(st_gr_flag.equals("S")) {%>
	         <tr>
	           <th><%=CommonLang.get("HTITLE1432") %><!-- 선입고 날짜 --></th>
	           <td><span><%=pre_gr_date %></span></td>
	         </tr>
	         <%} %>
	     <%} %>
        </table>
      </div>
      <%if(passYn.equals("Y")) {%>
      <div class="OptionBoxLine"> 
        <div class="OptionTit mt30 mb30 ml20 mr20"><%=CommonLang.get("HTITLE1067") %><!-- 결재경로 --><span class="OptionTitBr ml05"><%=CommonLang.get("HTITLE1046") %><!-- 결재대기 --></span><p class="OptionBoxLine_Num"><button class="ButOutline_RightIcon_Tiny" onclick="javascript:goToNext('PASS'); return false;" ><%=CommonLang.get("HTITLE1443") %><!-- 자세히 보기 --></button></p></div>
        <table class="OptionTable02 mb20">
        <%
        boolean first = true;
        for(int i = 0 ; i<_gridList2.size(); i++) {
        	Map<String,String> rowData = _gridList2.get(i);
        %>
       	<tr>
         	<th><%=rowData.get("USER_NAME") %></th>
         	<%if(rowData.get("PASS_TP").equals("0")) {%>
	          	<td><%=CommonLang.get("HTITLE1045") %><!-- 상신완료 --></td>
         	<%}else{ %>
         		<%if(first) {
         			first = false;
         		%>
         			<td><span class="blue"><%=CommonLang.get("HTITLE1046") %><!-- 결재대기 --></span></td>
         		<%}else{ %>
         			<td><span class="gray"><%=CommonLang.get("HTITLE1046") %><!-- 결재대기 --></span></td>
         		<%} %>
         	<%} %>
        </tr>
        <%} %>
        </table>      
      </div>
      <%} %>
      <div class="OptionBogo">
        <div class="OptionBogoTit mt25"><%=p060000122_col1 %></div>
        <div class="OptionBogoTxt mt15"><%=remark %></div>
      </div>
      <div class="CARTBox" id="CART-Box">
        <button class="ButPrimary_large mt15 mb08" onclick="goToNext('ORDER'); return false;" ><%=CommonLang.get("HTITLE1444")%><!--주문내역조회--></button><br/>
        <button class="ButOutline_large mb20" onclick="goToNext('HOME'); return false;"><%=CommonLang.get("HTITLE1445")%><!--홈 화면 이동--></button>
      </div><!-- CARTBox -->
    </div><!-- CARTright -->
</div>
</form>
<form name = "excelForm" id="excelForm" method = "post">
	<input type="hidden" name="buyer" value="<%=buyer%>">
	<input type="hidden" name="passYn" value="<%=passYn%>">
	<input type="hidden" name="type" value="<%=type%>">
	<input type="hidden" name="key_1" value="<%=key_1%>">
</form>
<!--내용 종료-->	
 <br>                

<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
</div>
</body>
<script>
$(document).ready(function(){
	window.scrollTo(0,0);
});

const CARTBox = document.getElementById('CART-Box');
const footer = document.querySelector('.footer');
const CARTcontainer = document.querySelector('.CARTcontainer');
const CARTright = document.querySelector('.CARTright');

function updateCARTBoxPosition() {
  const rightRect = CARTright.getBoundingClientRect();
  const footerRect = footer.getBoundingClientRect();
  const viewportHeight = window.innerHeight;

  // .CARTright의 문서 좌표 기준 왼쪽 위치 계산
  const rightLeft = rightRect.left + window.scrollX;

  // footer가 화면에 들어왔는지 확인
  const footerTop = footerRect.top + window.scrollY;
  const viewportBottom = window.scrollY + viewportHeight;

  if (viewportBottom >= footerTop) {
    // footer 진입 시 CARTcontainer 내부에 고정
    CARTBox.classList.remove('CartBottomBox-fixed');
    CARTBox.classList.add('CartBottomBox-absolute');
    CARTBox.style.CARTleft = ""; // fixed CARTleft 해제
  } else {
    // 일반 스크롤 시 화면 하단 고정
    CARTBox.classList.remove('CartBottomBox-absolute');
    CARTBox.classList.add('CartBottomBox-fixed');
    CARTBox.style.CARTleft = rightLeft+"px"; // 옵션박스의 왼쪽 라인 기준
  }
}

window.addEventListener('scroll', updateCARTBoxPosition);
window.addEventListener('resize', updateCARTBoxPosition);
updateCARTBoxPosition();
</script>
 
<script type="text/javascript">
function goToNext(flag){
	if(flag == "ORDER"){
		location.href = "/mpso/showBuyerMpSoOrderProgress.do?menuId=br00201000000";
	}else if(flag == "HOME"){
		location.href = "/buyerMain.do";
	}else{
		location.href = "/mdap/showBuyerNewPassList_v2.do?menuId=br00401000000";
		
	}
}

function excelDown(){
	document.forms.excelForm.action = "/mpso/excelBuyerMpSoOrderEndList_v2.do";
	document.forms.excelForm.submit();
	
	
}
</script>
</html>