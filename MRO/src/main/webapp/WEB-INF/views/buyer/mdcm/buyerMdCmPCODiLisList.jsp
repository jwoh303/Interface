<%--
**********************************************
* 메뉴 : 검색엔진을 이용한 펀치아웃 조회
* 화면 : 상품목록
* 기능 : 카테고리에서 최하단취 카테고리를 선택한 후 보여지는 상품목록. 장바구니에 담을 수 있다.
* 프로그램 ID : PG_06_B_002_00
* 담당자 : 현명환
* 착수일 : 2015-04-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
	String total_cnt =CommonUtil.nvl((String)request.getAttribute("totalCnt"),"0"); // 조회된 결과
	
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_CATEGORY = (List<Map<String,String>>) request.getAttribute("data_CATEGORY"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_MAKER = (List<Map<String,String>>) request.getAttribute("data_MAKER"); // 조회된 결과
     
	 
	String categ_code = CommonUtil.nvl((String) request.getParameter("categ_code"),"");   
	String buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");   
	String byca_comorg_code = CommonUtil.nvl((String) request.getParameter("byca_comorg_code"),"");   
	String company = CommonUtil.nvl((String) request.getParameter("company"),"");   
	String category_no = CommonUtil.nvl((String) request.getParameter("category_no"),"");   
	String maker_name = CommonUtil.nvl((String) request.getParameter("maker_name"),"");   
	
	String searchTarget = CommonUtil.nvl((String) request.getParameter("searchTarget"),"");   
	String searchTerm = CommonUtil.nvl((String) request.getParameter("searchTerm"),"");   
	 
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");
	
	String groupCategoryText = CommonUtil.nvl((String) request.getParameter("groupCategoryText"),"");   
	String groupMakerName = CommonUtil.nvl((String) request.getParameter("groupMakerName"),"");   
	String searchSort = CommonUtil.nvl((String) request.getParameter("searchSort"),"");   
	
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");   
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");   
	String st_maker = CommonUtil.nvl((String) request.getParameter("st_maker"),"");   
	String st_categoty_name = CommonUtil.nvl((String) request.getParameter("st_categoty_name"),"");   
	String searchMode = CommonUtil.nvl((String) request.getParameter("searchMode"),"");   
	 
	  
	// 조회조건 E
	String SessionComCode = "";
	String SessionComOrg = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	String img_view_flag   = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
		SessionComOrg = CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());
	}  
	 if(image_status.equals("")){ 
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	
	 
	 int cols_cnt = 5; // 카테고리,제조사 정렬 갯수
	 
	 
	 
	 boolean list = true;
	 if (_gridList == null || _gridList.size() == 0){
		 list = false;
	 }
	 

	
%> 
<body onload="kep_onload_view()">
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
	<h3>상품목록</h3>
	
	<table class="cont_t_list05" style="width:100%">
	<tr>
		<td  colspan="<%=cols_cnt %>" >카테고리</td>
	</tr> 
<%
if (list == false){
%>
		<tr>
			<td colspan="<%=cols_cnt %>" align="center" height = "50"> 
			<span>조회된 데이타가 없습니다.</span>
			</td> 
		</tr>
<%
}else{ 
int col = 0;
for (int j=0; j<_data_CATEGORY.size(); j++) {
	Map<String,String> rowData = _data_CATEGORY.get(j); 			
	
	if ((j%cols_cnt)==0){
		col = 0;
		%><tr><%
	}			
	col ++;
%>  
	<td width="100"><a href="javascript:top_kepSearch('1','<%=CommonUtil.nvl(rowData.get("groupId"))%>')"><%=CommonUtil.nvl(rowData.get("groupId"))%>&nbsp;(<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</a> </td> 
<%
	if ((j%cols_cnt)==(cols_cnt-1)){
		%></tr><%
	} 
} 
for (int j=0; j<(cols_cnt-col); j++) {
	%>
	<td width="100"></td> 
	<%	 
	if ((j+1)==(cols_cnt-col)) %></tr><%
} 
}%>
	</table>
	<br>
	<table class="cont_t_list05" style="width:100%">
	<tr>
		<td  colspan="<%=cols_cnt %>" >제조사</td>
	</tr>
<%
if (list == false){
%>
	<tr>
		<td colspan="<%=cols_cnt %>" align="center" height = "50"> 
		<span>조회된 데이타가 없습니다.</span>
		</td> 
	</tr>
<%
}else{
int col2 = 0;
for (int j=0; j<_data_MAKER.size(); j++) {
	Map<String,String> rowData = _data_MAKER.get(j);				 
	
	if ((j%cols_cnt)==0){
		col2 = 0;
		%><tr><%
	}			
	col2 ++;	
%>  
			<td width="100"><a href="javascript:top_kepSearch('2','<%=CommonUtil.nvl(rowData.get("groupId"))%>')"><%=CommonUtil.nvl(rowData.get("groupId"))%>&nbsp;(<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</a> </td> 
<%
	if ((j%cols_cnt)==(cols_cnt-1)){
		%></tr><%
	} 
}  
for (int j=0; j<(cols_cnt-col2); j++) {
	%>
	<td width="100"></td> 
	<%
	if ((j+1)==(cols_cnt-col2)) %></tr><%
} 
}%>	
	</table>
		<br> 
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="categ_code" id="categ_code" value="<%=categ_code %>">
		<input type="hidden" name="category_no" id="category_no" value="<%=category_no %>">
		<input type="hidden" name="buyer" id="buyer" value="<%=buyer %>">
		<input type="hidden" name="byca_comorg_code" id="byca_comorg_code" value="<%=byca_comorg_code %>"> 
		<input type="hidden" name="company" id="company" value="<%=company %>">  
		<input type="hidden" name="com_code" id="com_code" value="<%=company %>">   
		<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=st_sort_change %>">  
 		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">  
		<input type="hidden" name="maker_name" id="maker_name" value="<%=maker_name %>">		
 		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_mail" id="st_mail"  value="${sessionInfo.email}">
		<input type="hidden" name="st_user_name" id="st_user_name"  value="${sessionInfo.userNameLoc}">
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		<div class="contList">  		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);"> 
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "15" <%if ("15".equals(onepagerow)) {%>selected<%} %>>15건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option> 
			</select>
			</span> &nbsp;
						
			<span class="contList_btn">
		      <%  if(image_status.equals("IMAGE_HIDDEN")){   %>
		      <a href="javascript:imageHideView();">이미지보이기</a>
		      <%  }else{   %>
		     <a href="javascript:imageHideView();">이미지감추기</a>
		      <%  }   %>
     		</span>
			<span class="contList_btn" title="품목코드" ><a href="javascript:searchSort('BUYER_ITEM_NO');">품목코드</a></span>
			<span class="contList_btn" title="품목명" ><a href="javascript:searchSort('DESCRIPTION');">품목명</a></span>
			<span class="contList_btn" title="규격" ><a href="javascript:searchSort('SPECIFICATION');">규격</a></span>
			<span class="contList_btn" title="제조사" ><a href="javascript:searchSort('MAKER_NAME');">제조사</a></span>
			<span class="contList_btn" title="단가" ><a href="javascript:searchSort('TARGET_PRICE');">단가</a> </span>	
			</div>		
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 --> 
	  	
		<table class="cont_t_list002" style="width:100%">
			<colgroup>
	            <col width="5%" />
	            <col width="10%" />
	            <col width="45%" />
	            <col width="15%" />
	            <col width="15%" />
	            <col width="*" /> 
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
<%
if (list == false){
}else{
%>  
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
<%} %>
				</th> 
                <th scope="col">이미지</th>
                <th scope="col">품목코드/두산 ItemNo/품목명/규격</th>
                <th scope="col">협력사/원산지/제조사</th>
                <th scope="col">계약여부/단위/재고</th>
                <th scope="col">단가/재고수량</th> 
			</tr>
		</thead>
		<tbody>
<%
if (list == false){
%>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%
}else{
	Map<String,String> rowData = null;
	for (int j=0; j<_gridList.size(); j++) {
		rowData = _gridList.get(j);
		String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		String item_flag = "";
		String productCloseFlag = CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"));
		  if(productCloseFlag.equals("N")){ 
	             item_flag = "단가계약품목";
	          }else if(productCloseFlag.equals("A")){ 
	          	item_flag = "일회성_미발주";
	          }else if(productCloseFlag.equals("C")){ 
	          	item_flag = "신규요청품목";
	          }else if(productCloseFlag.equals("Y")){ 
	          	item_flag = "단종";
	          }  
		
%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="font1_black1"  align="center">
						<input type="checkbox" name="lnCheck<%=j%>" class="input_noline" >	                   
					</td>
					<td title="이미지">
						<div class="PDimg">
<% if(image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0"><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outstock'>품절</span>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<span class='outitem'>단종</span>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outstock'>품절</span>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<span class='outitem'>단종</span>")%> 
 
<%     }
}else{
	if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0"><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outstock'>품절</span>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<span class='outitem'>단종</span>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<span class='outstock'>품절</span>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<span class='outitem'>단종</span>")%>
 
<%     }
    }
%>			
						
						</div>	
					</td>                      
                    <td class="left" title="품목코드/두산 ItemNo/품목명/규격">&nbsp;<a class="hyperLink"  href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','ITEM');"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></a>&nbsp;
					 <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >&nbsp;<%=CommonUtil.nvl(rowData.get("ITEM_NO"))%>
					 <br>
					&nbsp;<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%><br>
					&nbsp;<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%> 
					<% if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N")) { %> <% } else { %> <br><font color="green">(재 판매일 :<%=CommonUtil.nvl(rowData.get("HS_NO"))%>)</font><% } %>
					 
                    </td>          
                   <td title="협력사/원산지/제조사">
<!-- 검색엔진 SQL문에서 한글 미지원으로 수정 , (복수협력사입니다 ==> MULTI_AGENT) , (코리아e플랫폼(주) ==> KOREAEPLATFORM)  수정함 -->
<% if(CommonUtil.nvl(rowData.get("AGENT")).equals("MULTI_AGENT")) { %>
                &nbsp;복수협력사입니다 
<% }else { %>
                 &nbsp;<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>');"><%=(CommonUtil.nvl(rowData.get("AGENT")).equals("KOREAEPLATFORM")) ? "코리아e플랫폼(주)" : CommonUtil.nvl(rowData.get("AGENT"))%></a>
<% } %><br>
				   <%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%> <br>
				   <%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>

				   </td>            
                   <td title="계약여부/단위/재고">
				   <input type="hidden"  name="st_order_qty" id="st_order_qty" size="4" value="1" id="line"  > 
			   <% if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N")){ %><font color="blue"><%=item_flag%></font>                    
		       <% }else if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("A")){ %><font color="red"><%=item_flag%></font>            
		       <% }else if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("C")){ %><font color="green"><%=item_flag%></font>                     
		       <% }  %>
				 	<br>
				 	<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%> <br>
                   <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>">
                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
                   <input type="hidden" name="st_item_type_co" value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
                   <input type="hidden" name="st_description2" value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>">
                   <input type="hidden" name="st_specification2" value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
                   <input type="hidden" name="st_unit_price" value="<%=CommonUtil.nvl(rowData.get("TARGET_PRICE"))%>">
					<%=CommonUtil.nvl(rowData.get("ITEM_NO")).equals("")?"비재고":"재고가능"%>
				   </td>            
                   <td title=" 단가/재고수량" class="right">
				   <%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>
				   <br> 
      			<% if(CommonUtil.nvl(rowData.get("WMS_STOCK_QTY")).equals(0)){ %>
							<span class="Price"><%=CommonUtil.formatNumber(rowData.get("WMS_STOCK_QTY"),true,0,3)%></span>   /
				<% } %>
      			<% if(CommonUtil.nvl(rowData.get("TOOL_STOCK_FLAG")).equals(0)){ %>
							<span class="Price"><%=CommonUtil.formatNumber(rowData.get("TOOL_STOCK_FLAG"),true,0,3)%></span>
				<% } %>
				   </td>            
				</tr>
<%
		} 
	}
%>
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
			<div class="fr">
				<span class="btn_04"  title="견적의뢰" >
					<a href="javascript:doAction('saveReq','');">견적의뢰</a> 
				</span>	
				<span class="btn_04"  title="나의상품등록" >
					<a href="javascript:doAction('myItem','');">나의상품등록</a> 
				</span>	
				<span class="btn_04" title="장바구니담기" >
					<a href="javascript:doAction('cartItem','');">장바구니담기</a>
				</span>					
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id_session" id="st_user_id_session" value="${sessionInfo.userId}">
</form>

<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	<input type="hidden" name="stdcateg_id" id="stdcateg_id" value="" />
	<input type="hidden" name="stdcatlg_id" id="stdcatlg_id" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="com_code" id="com_code" value="" />
	<input type="hidden" name="buyer_tem_no" id="buyer_tem_no" value="" />
	<input type="hidden" name="category_no" id="category_no" value="" />
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=SessionComOrg%>"/>
	<input type="hidden" name="st_categ_id" id="st_categ_id" value="" />	
	<input type="hidden" name="key_flag" id="key_flag" value="" />
	<input type="hidden" name="cata" id="cata" value="" />
	<input type="hidden" name="product_flag" id="product_flag" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/> 
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/> 
	<input type="hidden" name="byca_comorg_code" id="byca_comorg_code" value="<%=byca_comorg_code %>">   
	<input type="hidden" name="image_status" id="image_status" value="<%=image_status %>">  	
	<input type="hidden" name="maker_name" id="maker_name" value="<%=maker_name %>">	
	<input type="hidden" name="searchTarget" id="searchTarget" value="<%=searchTarget %>">
	<input type="hidden" name="searchTerm" id="searchTerm" value="<%=searchTerm %>">	    
	<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status%>" />
	<input type="hidden" name="groupCategoryText" id="groupCategoryText"  value="<%=groupCategoryText%>" />
	<input type="hidden" name="groupMakerName" id="groupMakerName" value="<%=groupMakerName%>" />
	<input type="hidden" name="searchSort" id="searchSort"  value="<%=searchSort%>" />
	<input type="hidden" name="st_sort_change" id="st_sort_change"  value="<%=st_sort_change%>" />	
	<input type="hidden" name="st_detail_gubun" id="st_detail_gubun"  value="Y" />
	
	<input type="hidden"  name="st_description"  id="st_description" value="<%=st_description %>"  /> 
<input type="hidden"  name="st_specification"  id="st_specification"  value="<%=st_specification %>"  /> 
<input type="hidden"  name="st_maker"  id="st_maker"   value="<%=st_maker %>"  /> 
<input type="hidden"  name="st_categoty_name"  id="st_categoty_name"  value="<%=st_categoty_name %>"   /> 
<input type="hidden"  name="searchMode"  id="searchMode"  value="<%=searchMode %>"   />
<input type="hidden"  name="st_return"  id="st_return"  value="SEARCH"   />  
</form>

<form name="locationForm2" id="locationForm2" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	 
	<input type="hidden" name="searchTarget" id="searchTarget" value="<%=searchTarget %>">
	<input type="hidden" name="searchTerm" id="searchTerm" value="<%=searchTerm %>">	
	
		<input type="hidden"  name="st_description"  id="st_description" value="<%=st_description %>"  /> 
<input type="hidden"  name="st_specification"  id="st_specification"  value="<%=st_specification %>"  /> 
<input type="hidden"  name="st_maker"  id="st_maker"   value="<%=st_maker %>"  /> 
<input type="hidden"  name="st_categoty_name"  id="st_categoty_name"  value="<%=st_categoty_name %>"   /> 
<input type="hidden"  name="searchMode"  id="searchMode"  value="<%=searchMode %>"   /> 
</form>
</div>
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<div id="confirmArea"  style="position:absolute; left:  250px; top: 250px; width: 500px; height: 100px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 1px solid blue; padding:20px;">
 <h4  id="confirmMsg"></h4>  
 		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:kep_confrim_search();">계속검색</a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();">이동</a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_cancel();">취소</a>
				</span>					
            </div>
        </div>        
</div>

<script type="text/javascript">
var popupSel = ""; 

// 최초 화면 함수 
function kep_onload_view(){  
}
 
// 화면이동
function getBuyerCatalogDisplay(stdcateg_id,stdcatlg_id,buyer,org_buyer_item_no,category_no,key_flag,product_flag,cata ){
	
    var key_flag     = key_flag.substr(0,2);
    if(key_flag == "MULTI_AGENT"){
        var st_key_flag = "Y";
    }else{
        var st_key_flag = "N";
    }    
    
	document.locationForm.stdcateg_id.value = stdcateg_id; // 표준카테고리ID
	document.locationForm.stdcatlg_id.value = stdcatlg_id; // 표준카탈로그ID
	document.locationForm.buyer.value = buyer;
	document.locationForm.com_code.value = buyer;
	document.locationForm.buyer_tem_no.value = org_buyer_item_no;
	document.locationForm.category_no.value = category_no; // 카테고리번호
	document.locationForm.key_flag.value = st_key_flag;
	document.locationForm.cata.value = cata;
	document.locationForm.product_flag.value = product_flag;
	document.locationForm.st_categ_id.value = category_no; // 카테고리번호
	
	
	$('#locationForm').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmPCOLisDetail.do").submit();   
}

 

// 단가 이력
function getBuyerPriceHistoryPop(byca_comorg_code,contract_no, contract_seq, buyer_item_no)
{       
    openSearchPopup("/common/mpiv/catePriceHistory.do","?open=Y&st_byca_comorg_code="+byca_comorg_code+"&st_contract_no="+contract_no+"&st_contract_seq="+contract_seq+"&st_buyer_item_no="+buyer_item_no,"420,320,no");
}

var st;
//기능함수
function doAction(str , gubun) {
	 
	
	switch (str) {
	case "search":	 //조회	  
		kepSearch(1);
		break; 
 
	case "myItem": // 나의상품 담기 
		saveProcess("R");
		break;  
	
	case "cartItem": // 장바구니 담기
		saveProcess("C");
		break;  	
	case "saveReq": //견적의뢰
		saveReq();
		break;
	}
}

 
// 1 카테고리
// 2 제조사
function top_kepSearch(flag,id){ 
	 
	if (flag==2)
	{
		document.forms.searchDiForm.groupCategoryText.value = ""; 
		document.forms.searchDiForm.groupMakerName.value = id; 
	}	else{
		document.forms.searchDiForm.groupCategoryText.value = id; 
		document.forms.searchDiForm.groupMakerName.value = ""; 
	} 
	
	kepSearch(1);
}

function searchSort(gubun){
	
	var st_sort_change = document.forms.searchForm.st_sort_change.value;
	
	//alert("st_sort_change  "+st_sort_change);
	
	if (st_sort_change == "" || st_sort_change == "DOWN"){
		st_sort_change = "UP";
	}else{
		st_sort_change = "DOWN";
	}
	
	document.forms.searchForm.st_sort_change.value = st_sort_change;
	document.forms.searchDiForm.st_sort_change.value = st_sort_change;
	document.forms.searchDiForm.searchSort.value = gubun + "_"+st_sort_change; 
	//alert(document.forms.searchDiForm.searchSort.value);
	kepSearch(1);
}

function saveReq(){
	var buyer = document.forms.searchForm.st_com_code.value; 
	var user_id = document.forms.searchForm.st_user_id.value;
	var mail = document.forms.searchForm.st_mail.value;
	var user_name = document.forms.searchForm.st_user_name.value;
	var dept_code  = "";
	var dept_name = "";
	var phone_no = "";
	var query = "";
	var chk_cnt = 0;
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getRqUserInfo.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: {param1: buyer,param2: user_id},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
   	 	if (response.data.length > 0){
		    	  for (var i=0; i<response.data.length; i++){ 
		    		  if(i==response.data.length-1){
		    			  dept_code = $.trim(eval("response.data["+i+"].DEPT_CODE"));
		    			  dept_name = $.trim(eval("response.data["+i+"].DEPT_NAME"));
		    			  phone_no = $.trim(eval("response.data["+i+"].PHONE_NO"));
		    	  	  }
	 		      }	 
   		  }
		      },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		      }
   });  

	var tot_cnt  = $("#display_item_cnt").val(); 
	var item_type_cnt_N = 0;
	var item_type_cnt_A = 0;
	var item_type_cnt_B = 0;
	var item_type_cnt_C = 0;
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.contentForm.lnCheck" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
		if (tot_cnt < 2) {
			var box = eval("document.forms.contentForm.lnCheck0" ); 
	        if(box.checked == true){
	        	var item_type =document.forms.contentForm.st_item_type_co.value;
	            var buyer_item_no = document.contentForm.st_item_no.value;
                
	            if(item_type == "N"){
	                item_type_cnt_N++;	            	
	            }else if(item_type == "A"){
	                item_type_cnt_A++;	  
				}else if(item_type == "B"){
	            	item_type_cnt_B++;
	            }else if(item_type == "C"){
	            	item_type_cnt_C++;
	            }
				if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
					 alert( "  단가계약품목과  신규요청품목이 동시에 선택 되었습니다.   \n\n  신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.    ");
				     return;
				}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
		      		alert( "  일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다.   \n\n  신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.    ");
		      		return;
		 		}else if((item_type_cnt_A > 0) || (item_type_cnt_N > 0)){
		      		alert( "  단가계약품목이나 일회성_미발주 품목이 선택 되었습니다.   \n\n  신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.    ");
		      		return;
		 		}

				query = buyer_item_no + "@@" +  item_type+ "@@" +user_id+"@@"+user_name+ "@@"+dept_code  +"@@"+dept_name +"@@"+phone_no +"@@"+mail+"&&";
	        }
		}else{
	        for(var k = 0; k < tot_cnt; k++){
	        	var box = eval("document.forms.contentForm.lnCheck" + k);
	            if(box.checked == true){
	            	var item_type =document.forms.contentForm.st_item_type_co[k].value;
	            	var buyer_item_no = document.contentForm.st_item_no[k].value;
	                
	                if(item_type == "N"){
	                    item_type_cnt_N++;	            	
	                }else if(item_type == "A"){
	                    item_type_cnt_A++;	  
	    			}else if(item_type == "B"){
	                	item_type_cnt_B++;
	                }else if(item_type == "C"){
	                	item_type_cnt_C++;
	                }
		    		if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
		    			 alert( "  단가계약품목과  신규요청품목이 동시에 선택 되었습니다.   \n\n  신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.    ");
		    		     return;
		    		}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
		          		alert( "  일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다.   \n\n  신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.    ");
		          		return;
		     		}else if((item_type_cnt_A > 0) || (item_type_cnt_N > 0)){
		          		alert( "  단가계약품목이나 일회성_미발주 품목이 선택 되었습니다.   \n\n  신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.    ");
		          		return;
		     		}

		    		query += buyer_item_no + "@@" +  item_type+ "@@" +user_id+"@@"+user_name+ "@@"+dept_code  +"@@"+dept_name +"@@"+phone_no +"@@"+mail;
		   		 	query += "&&";
	            }
	        }
		}
    }

    var flag = "Q";
   	$("#confirm1").val(flag+"saveProcess");
   	$("#confirm2").val(query);
   	$("#confirm3").val(flag);
   	$("#confirm4").val("");
   	kep_showConfirm(); 
    
}
/*
 * 나의상품등록 R
 * 장바구니담기 C
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
	var item_type_cnt_N = 0;
	var item_type_cnt_A = 0;
	var item_type_cnt_B = 0;
	var item_type_cnt_C = 0;
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" 목록에 표시된 상품이 없습니다.     ");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.contentForm.lnCheck" + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
		        var st_item_no   = document.forms.contentForm.st_item_no.value;
				var st_order_qty =  document.forms.contentForm.st_order_qty.value;
				var st_agent     = document.forms.contentForm.st_agent_code.value;
				var contract_no  = document.forms.contentForm.st_contract_no.value;
				var contract_seq = document.forms.contentForm.st_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
            	var item_type =document.forms.contentForm.st_item_type_co.value;
				var st_description =document.forms.contentForm.st_description2.value;
				var st_specification =document.forms.contentForm.st_specification2.value;
				var st_unit_price =document.forms.contentForm.st_unit_price.value;
                var st_agent_flag = document.forms.contentForm.st_agent_flag.value;
				var st_key_flag = "";
				
                if(st_agent_flag == "MULTI_AGENT"){
                    st_key_flag = "Y";
                }else{
                    st_key_flag = "N";
                }
                if(!kepChkDecimal(st_order_qty,3)){
                    alert( " 첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
                    document.forms.contentForm.st_order_qty.focus();
                    return;
                } else if(st_key_flag == "Y"){
                    alert( " 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     ");
                    box.checked = false;
                    return;
                }
                if(item_type == "N"){
                    item_type_cnt_N++;	            	
                }else if(item_type == "A"){
                    item_type_cnt_A++;	  
    			}else if(item_type == "B"){
                	item_type_cnt_B++;
                }else if(item_type == "C"){
                	item_type_cnt_C++;
                }
				if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
					 alert( "  단가계약품목과 신규요청품목이 동시에 선택 되었습니다.   \n\n  나의상품등록은 단가계약품목이나  일회성_미발주 품목만 선택하시기 바랍니다.     ");
					 box.checked = false;
				     return;
				}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
					 alert( "  일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다.   \n\n  나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.     ");
					 box.checked = false;
				     return;
				}else if(item_type_cnt_C > 0){
					 alert( "  신규요청품목이 선택 되었습니다.   \n\n  나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.     ");
					 box.checked = false;
				     return;
				}
				 query = st_item_no + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + st_description + "@@"  + st_specification +  "@@"  + st_unit_price + "@@" + st_order_qty+"&&";
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                if(box.checked == true){
    		        var st_item_no   = document.forms.contentForm.st_item_no[i].value;
    				var st_order_qty =  document.forms.contentForm.st_order_qty[i].value;
    				var st_agent     = document.forms.contentForm.st_agent_code[i].value;
    				var contract_no  = document.forms.contentForm.st_contract_no[i].value;
    				var contract_seq = document.forms.contentForm.st_contract_seq[i].value;
    				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
                	var item_type =document.forms.contentForm.st_item_type_co[i].value;
    				var st_description =document.forms.contentForm.st_description2[i].value;
    				var st_specification =document.forms.contentForm.st_specification2[i].value;
    				var st_unit_price =document.forms.contentForm.st_unit_price[i].value;
                    var st_agent_flag = document.forms.contentForm.st_agent_flag[i].value;
    				var st_key_flag = "";
    				
                    if(st_agent_flag == "MULTI_AGENT"){
                        st_key_flag = "Y";
                    }else{
                        st_key_flag = "N";
                    }
                    if(!kepChkDecimal(st_order_qty,3)){
                        alert( " 첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
                        document.forms.contentForm.st_order_qty.focus();
                        return;
                    } else if(st_key_flag == "Y"){
                        alert( " 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     ");
                        box.checked = false;
                        return;
                    }
                    if(item_type == "N"){
                        item_type_cnt_N++;	            	
                    }else if(item_type == "A"){
                        item_type_cnt_A++;	  
        			}else if(item_type == "B"){
                    	item_type_cnt_B++;
                    }else if(item_type == "C"){
                    	item_type_cnt_C++;
                    }
    				if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
    					 alert( "  단가계약품목과 신규요청품목이 동시에 선택 되었습니다.   \n\n  나의상품등록은 단가계약품목이나  일회성_미발주 품목만 선택하시기 바랍니다.     ");
    					 box.checked = false;
    				     return;
    				}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
    					 alert( "  일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다.   \n\n  나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.     ");
    					 box.checked = false;
    				     return;
    				}else if(item_type_cnt_C > 0){
    					 alert( "  신규요청품목이 선택 되었습니다.   \n\n  나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.     ");
    					 box.checked = false;
    				     return;
    				}
    				 query += st_item_no + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + st_description + "@@"  + st_specification +  "@@"  + st_unit_price + "@@" + st_order_qty;
    				 query += "&&";
                }
            }
        }
    }	 
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	kep_showConfirm(); 
}
 


function kep_showConfirm(){
	
	
	var runFlag = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	
    var msg = "";
    if (runFlag == "CsaveProcess"){
    	msg = "장바구니";
    }else if(runFlag == "QsaveProcess"){
    	msg = "임시저장";
    }else{
    	msg = "나의상품";
    }


    $('body,html').animate({
		scrollTop: 0
	}, 100);

	$("#confirmMsg").text(msg+"으로 저장하시고\n"+msg+"보기 화면으로 이동하시겠습니까?");
	$("#confirmArea").show(); 
	 //runProcess(runFlag,query,flag);
}

// 계속검색
function kep_confrim_search(){ 
	$("#confirm4").val("search");
	$("#confirmArea").hide(); 
	runProcess();
}

// 이동
function kep_confirm_location(){ 
	$("#confirm4").val("location");
	$("#confirmArea").hide(); 
	runProcess();
}

// 취소
function kep_confirm_cancel(){ 
	$("#confirm4").val("");
	$("#confirmArea").hide(); 
}

// 이미지 보이기 숨기기
function imageHideView(){ 
	
    var image_status   = document.forms.searchForm.st_image_status.value;
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    document.forms.searchForm.st_image_status.value = image_status;
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}

// 조회
function kepSearch(curPage){
	
	document.forms.searchDiForm.st_image_status.value = document.forms.searchForm.st_image_status.value; 	
	document.forms.searchDiForm.onepagerow.value = document.forms.searchForm.onepagerow.value; 	 
	document.forms.searchDiForm.curPage.value = curPage; 
	
	$('#searchDiForm').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmPCODiLisList.do").submit();   
}
   

/** 

desc DOOCART
USE_FLAG	NOT NULL	CHAR(1)	용도구분(Q:견적의뢰,C:장바구니,D:,R:나의상품)

*/
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	
	if (gubun == "CsaveProcess" || gubun == "RsaveProcess"){ // 장바구니, 나의상품 
		document.forms.processForm.st_use_flag.value = flag; 
		document.forms.processForm.st_query2.value = query;
		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmPopularGoods.do","processForm",gubun); 
	}else{ // 견적의뢰 
		document.forms.processForm.st_use_flag.value = flag; 
		document.forms.processForm.st_query2.value = query;
		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmRqdtTemp.do","processForm",gubun); 
	}  		 
	
}
  
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	var confirm4 = $("#confirm4").val();
    if(sMsg == "CREATE_OK"){
    	
        if(pMethod == "CsaveProcess")
        {
           alert("장바구니에 저장되었습니다.   ");
           
           if (confirm4 == "search"){ 
         	  // 계속검색클릭 
            	 // 처리후 재조회
            	 kepSearch($("#curPage").val());           	   
           }else{ 
        	   $('#locationForm').attr("action", "/mdcm/getBuyerMdCmCartPunchOutList.do").submit();    
           }
        	
       }else if(pMethod == "RsaveProcess") {
          alert("나의상품으로 등록 되었습니다.   ");
          if (confirm4 == "search"){ 
        	  // 계속검색클릭 
           	 // 처리후 재조회
           	 kepSearch($("#curPage").val());          	   
          }else{     
        	  $('#locationForm').attr("action", "/mdcm/getBuyerMdCmMyPunchOutList.do").submit();
          }
       }else if(pMethod == "QsaveProcess") {
           alert("임시저장 되었습니다.   ");
           if (confirm4 == "search"){ 
         	  // 계속검색클릭 
            	 // 처리후 재조회
            	 kepSearch($("#curPage").val());          	   
           }else{     
         	  $('#locationForm').attr("action", "/mprq/getBuyerMpRqTempQuotationPCO.do").submit();
           }
       }        
      }else{
    	  
         if(pMethod == "CsaveProcess")
          {
            alert("품목코드 (" + sMsg + ") 은 이미 장바구니에 저장된 항목입니다.  ");
          }else if(pMethod == "RsaveProcess") {
            alert("품목코드 (" + sMsg + ") 은 이미 나의 상품으로 저장된 항목입니다.  ");
          }
         
     	 // 처리후 재조회
     	 kepSearch($("#curPage").val());
         
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "CsaveProcess"){ 
		 alert("장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "RsaveProcess"){ 
		 alert("나의상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}  
	 
	
} 
 
//상품 큰이미지
function getBigImage(file_dir, file_name){	
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

</script>
</html>
