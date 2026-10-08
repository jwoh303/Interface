<%--
**********************************************
* 메뉴 : 판촉물전용마켓 > 카테고리 상품리스트
* 화면 : 판촉물전용마켓 카테고리 상품리스트
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
/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	var field = document.headerForm.st_key_src;
	//defaultvalue인 검색어를 입력하십시요. 문구는 null처리.
	if (field.value.indexOf("검색어를") > -1 ) { field.value = ""; } 
	
	$("#curPage").val(curPage);
	$("#st_key_src").val("");	
	resetDetail();
	
	doSubmit("/promote/promote_PDCategory.do"); 
}
</script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("searchItem"); // 상품목록
@SuppressWarnings (value="unchecked")
List<Map<String,String>> categPath = (List<Map<String,String>>) request.getAttribute("categPath"); // 카테고리PATH

String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow =  CommonUtil.nvl((String) request.getParameter("onepagerow"),"20");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

String this_categ_list = "";
String other_categ_list = "";

String std_categ_id = CommonUtil.nvl((String) request.getParameter("st_std_categ_id"),"");
String std_pid = CommonUtil.nvl((String) request.getParameter("st_pid"),"");

if (categPath != null && categPath.size() > 0){
	for(int ca_i=0; ca_i<categPath.size(); ca_i++) {
		Map<String,String> rowCateg = categPath.get(ca_i);
		
		if(ca_i==0) {
			this_categ_list= rowCateg.get("CATEG_NAME")+" > ";
			continue;
		}
		
		if(std_categ_id.equals(rowCateg.get("STD_CATEG_ID"))) {
			this_categ_list+=rowCateg.get("CATEG_NAME");
		}
		
		other_categ_list+= "<a href=\"javascript:setKeyCategory('"+std_pid+"', '"+rowCateg.get("STD_CATEG_ID")+"')\" >"+rowCateg.get("CATEG_NAME")+"</a>";
		
		if((ca_i+1)!=categPath.size()){
			other_categ_list+= " | ";
		}
		
	}
}

%>
<body>
<div id="wrapper">
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:import charEncoding="utf-8" url="/promote/promoteHeader.do" />
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<div id="container">
		<div class="Category">
            <h4><%=this_categ_list %></h4>
            <%=other_categ_list %> 
        </div>
	        
        <div class="h30"></div>
        <h2>상품리스트</h2>
<%
int li_cnt			= 3;
int start_item_idx	=0;
int end_item_idx	=0;

	if (_dataList != null && _dataList.size() > 0){
		for (int main_idx=0; main_idx<_dataList.size(); main_idx++) {
		
			if((main_idx%li_cnt)==0) {
				end_item_idx=start_item_idx+li_cnt;
				
				if(end_item_idx >_dataList.size()){
					end_item_idx = _dataList.size();
				}
			
%>
	        <div class="GiftPD">
	            <ul>
<%
					for(; start_item_idx<end_item_idx; start_item_idx++) {
	
						Map<String,String> rowData = _dataList.get(start_item_idx);
	
						if((start_item_idx%3)==2){
%>
				<li class="PDAreaLast">
<%
						}else{
%>
				<li>
<%
						}
%>
				<a href="javascript:setKeyDetail('<%=rowData.get("PID")%>','<%=rowData.get("ITEM_NO")%>');">
                    <img src="<%=rowData.get("IMG_NAME")%>" alt="상품" class="PDimg" />
                    <p class="PDCode"><%=rowData.get("ITEM_NO")%></p>
                    <p class="PDTit"><%=rowData.get("DESCRIPTION")%></p>
                    <p class="PDPrice"><%=CommonUtil.formatNumber(rowData.get("USER_PRICE"),true,0,3)%></p>
				</a>
                </li>
<%
					}
%>	            
        		</ul>
        </div>
        
        <div class="PDLine"></div>
<%
			}  //end if((main_idx%td_cnt)==0) {
		}  //end for (int main_idx=0; main_idx<_dataList.size(); main_idx++) {
%>
		<!--페이징-->
		<p class="Paging">
			<%=CommonUtil.getPromotePageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span>
		</p> 
<%
	}else{ //end if (_dataList != null){
%>
	<div class="GiftPDNo"><img src="/resources/images/promote/no_product.gif" alt="등록된 상품이 없습니다." /><p>등록된 상품이 없습니다</p></div><!--등록된 상품이 없을때-->
<%
	}
%>

    </div>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
	<%@ include file="/WEB-INF/views/promote/include/promoteFooter.jsp" %>
	<!------------------------------------------------------------------------------------------------footer-------------------------------------------------------------------------------------------------------------->
</div>
</body>
</html>

