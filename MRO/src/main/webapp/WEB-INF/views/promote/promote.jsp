<%--
**********************************************
* 메뉴 : 판촉물전용마켓 MAIN
* 화면 : 판촉물전용마켓 MAIN
* 기능 : 
* 프로그램 ID : 
* 담당자 : 홍석규 ( 설계 : 공통 )
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge;" />
<title>코리아 e 플랫폼</title>
<script type="text/javascript">
 
</script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("mainItem"); // 상품목록

%>
<body>
<div id="wrapper">
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:import charEncoding="utf-8" url="/promote/promoteHeader.do" />
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->

	<div id="container">
    	<div class="specialGift">
            <ul class="specialGift1">
            	<li><a href="javascript:setKeyCategory('2','TOTAL');"><img src="/resources/images/banner_h.jpg" alt="홍보베너" /></a></li>
				<li><a href="javascript:setKeyCategory('3','TOTAL');"><img src="/resources/images/banner_k.jpg" alt="홍보베너" /></a></li>
            </ul>
       		<script> $(".specialGift").slide({ titCell:".num ul" , mainCell:".specialGift1" , effect:"fold", autoPlay:true, delayTime:1000 , autoPage:true }); </script>
 		</div>
        
        <div class="h30"></div>
<%
int li_cnt			= 5;
int start_item_idx	=0;
int end_item_idx	=0;

	if (_dataList != null){
		for (int main_idx=0; main_idx<_dataList.size(); main_idx++) {
			Map<String,String> rowData = _dataList.get(main_idx);
		
			if((main_idx%li_cnt)==0) {
				end_item_idx=start_item_idx+li_cnt;
			
%>
        	<!-- h2><%=rowData.get("PID_CATEG_NAME")%><a href="javascript:setKeyCategory('<%=rowData.get("PID")%>','TOTAL');"><span class="PDadd">더보기 ></span></a></h2 -->
	        <div class="GiftPD">
	            <ul>
<%
					for(; start_item_idx<end_item_idx; start_item_idx++) {
	
						Map<String,String> rowData2 = _dataList.get(start_item_idx);
	
						if((start_item_idx%3)==2){
%>
				<li class="PDAreaLast">
<%
						}else{
%>
				<li>
<%
						}
			if(!rowData2.get("DESCRIPTION").equals(" ")){
%>
				<a href="javascript:setKeyDetail('<%=rowData2.get("PID")%>','<%=rowData2.get("ITEM_NO")%>');">
                    <img src="<%=rowData2.get("IMG_NAME")%>" alt="상품" class="PDimg" />
                    <p class="PDCode"><%=rowData2.get("ITEM_NO")%></p>
                    <p class="PDTit"><%=rowData2.get("DESCRIPTION")%></p>
                    <p class="PDPrice"><%=CommonUtil.formatNumber(rowData2.get("USER_PRICE"),true,0,3)%></p>
				</a>
                </li>
<%
			}
					}
%>	            
        		</ul>
        </div>
        
<%
					//마지막 Line은 PDLine div태그가 추가되지 않음.
					if(start_item_idx != _dataList.size() ){
%>
        <div class="PDLine"></div>
<%
					}
			}  //end if((main_idx%td_cnt)==0) {
		}  //end for (int main_idx=0; main_idx<_dataList.size(); main_idx++) {
	} //end if (_dataList != null){
%>
    </div>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	<%@ include file="/WEB-INF/views/promote/include/promoteFooter.jsp" %>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
</div>
</body>
</html>

