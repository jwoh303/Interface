<%--
**********************************************
* 메뉴 : 카테고리를 이용한 조회
* 화면 : 상품목록
* 기능 : 카테고리에서 최하단취 카테고리를 선택한 후 보여지는 상품목록. 장바구니에 담을 수 있다.
* 프로그램 ID : PG_06_B_002_00
* 담당자 : 현명환
* 착수일 : 2015-03-23
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
	List<Map<String,String>> _pathList = (List<Map<String,String>>) request.getAttribute("_data_path"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	
	// 조회조건 E
	String SessionComCode = "";
	String byca_comorg_code = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");
	String categ_id = CommonUtil.nvl((String) request.getParameter("st_categ_id"),"");
	String st_sort_column = CommonUtil.nvl((String) request.getParameter("st_sort_column"),"");   
	String st_sort_flag1 = CommonUtil.nvl((String) request.getParameter("st_sort_flag1"),"");
	String img_view_flag   = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		byca_comorg_code =  CommonUtil.nvl((String)_sessionInfo.getBycaComorgCode());
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
	}  
	 if(image_status.equals("")){ 
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	
	 
	 int cols_cnt = 5; // 카테고리,제조사 정렬 갯수
	 
 
	 
	 boolean list = true;
	 if (_gridList == null || _gridList.size() == 0){
		 list = false;
	 }
	 
	 
	 
	 //SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	String p060000036 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000036","COL02_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
	/*
	* 고객사에 따라 카탈로그 검색기준이 다름
	* A: 두산엔진 KRHSDE0003
	*/
	String p060000055 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000055","COL02_DATA"); // 검색조건변경
	//SLOGIC-END
	
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
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_categ_id" id="st_categ_id" value="<%=categ_id %>">
		<input type="hidden" name="st_byca_comorg_code" id="st_byca_comorg_code" value="<%=byca_comorg_code %>"> 
 		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">
 		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_mail" id="st_mail"  value="${sessionInfo.email}">
		<input type="hidden" name="st_user_name" id="st_user_name"  value="${sessionInfo.userNameLoc}">
		<input type="hidden" name="st_sort_column" id="st_sort_column" value="<%=st_sort_column %>">  
		<input type="hidden" name="st_sort_flag1" id="st_sort_flag1" value="<%=st_sort_flag1 %>">
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		<div id="cont_searchA">
	    <table class="cont_t_list01" >
			<caption>조회</caption>
                <colgroup>
                    <col width="100%" />
                 </colgroup>
				<tbody>
				<tr><th><h4>
<%
	if(_pathList.size() > 0){
		Map<String,String> pathData = null;
		for (int j=0; j<_pathList.size(); j++) {
			pathData = _pathList.get(j);
		if(j == _pathList.size()-1){
%> 
	<%=CommonUtil.nvl(pathData.get("CATEG_NAME"))%>
<%  }else{ %>
	<a   href="javascript:getNextCategory('<%=CommonUtil.nvl(pathData.get("CATEG_SYS_CODE"))%>','<%=CommonUtil.nvl(pathData.get("CATEG_NAME"))%>'
	,'<%=CommonUtil.nvl(pathData.get("STD_CATEG_ID"))%>','<%=CommonUtil.nvl(pathData.get("PID"))%>','<%=CommonUtil.nvl(pathData.get("DEPTH"))%>','<%=CommonUtil.nvl(pathData.get("CATEG_TYPE"))%>'
	,'<%=CommonUtil.nvl(pathData.get("COM_CODE"))%>');"><%=CommonUtil.nvl(pathData.get("CATEG_NAME"))%>&nbsp;&nbsp;>&nbsp;&nbsp;</a>
<%    
    	}
	}
}
%>
				</h4></th></tr>
				</tbody>
			</table>
		</div>
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
			<span class="contList_btn" title="품목명" ><a href="javascript:searchSort('DESCRIPTION_LOC');">품목명</a></span>
			<span class="contList_btn" title="규격" ><a href="javascript:searchSort('SPECIFICATION');">규격</a></span>
			<span class="contList_btn" title="제조사" ><a href="javascript:searchSort('MAKER_NAME');">제조사</a></span>
			<span class="contList_btn" title="단가" ><a href="javascript:searchSort('TARGET_PRICE');">단가</a> </span>	
			</div>		
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 --> 
		<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >	  	
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
<%
if(p060000055.equals("A")){
%>
                <th scope="col">이미지</th>
                <th scope="col">ItemNo/품목명/규격</th>
                <th scope="col">협력사/원산지/제조사</th>
                <th scope="col">계약여부</th>
                <th scope="col">단가/단위</th>
<%}else{ %>
                <th scope="col">이미지</th>
                <th scope="col">품목코드/두산 ItemNo/품목명/규격</th>
                <th scope="col">협력사/원산지/제조사</th>
                <th scope="col">계약여부/단위/재고</th>
                <th scope="col">재고수량/단가</th>
<%} %>
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
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a><br>
<%     }
}else{
	if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0"><br>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a><br>
 
<%     }
    }
%>			
						
						</div>	
					</td>
<%
if(p060000055.equals("A")){
%>                      
                    <td class="left" title="ItemNo/품목명/규격">&nbsp;<a class="hyperLink"  href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','ITEM');"><%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%></a>&nbsp;
					 <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%>" >
					&nbsp;<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%><br>
					&nbsp;<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%> 
                    </td>
<%}else{ %>
                    <td class="left" title="품목코드/두산 ItemNo/품목명/규격">&nbsp;<a class="hyperLink"  href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','ITEM');"><%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%></a>&nbsp;
					 <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%>" >
					&nbsp;<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%><br>
					&nbsp;<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%><br>
					&nbsp;<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%> 
                    </td>
<%} %>          
                   <td title="협력사/원산지/제조사">
					<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>');"><%=CommonUtil.nvl(rowData.get("AGENT"))%></a>
                    <br>
				   <%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%><br><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>
			         <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
			         <input type="hidden" name="st_agent_code"  value="<%=CommonUtil.nvl(rowData.get("AGENT2"))%>">
			         <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
			         <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
			         <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>"> 			              
				   </td>
<%
if(p060000055.equals("A")){
%>            
                   <td title="계약여부">
					 <% if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N")){ %><font color="blue"><%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%></font>                    
		       <% }else if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("A")){ %><font color="red"><%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%></font>            
		       <% }else if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("C")){ %><font color="green"><%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%></font>
		       					&nbsp;<font color="red"><%=CommonUtil.nvl(rowData.get("ITEM_NO_TEXT2"))%></font>                     
		       <% }  %>
				   </td>
                   <td title="단가/단위" class="right">
							<span class="Price"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></span>
							<br><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
		                    <input type="hidden" name="st_unit_price"  value="<%=CommonUtil.nvl(rowData.get("TARGET_PRICE"))%>">
		                    <input type="hidden" name="st_list_price"  value="<%=CommonUtil.nvl(rowData.get("LIST_PRICE"))%>">
		                    <input type="hidden" name="st_description2" value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>">
		                    <input type="hidden" name="st_specification2"  value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
		                    <input type="hidden" name="st_item_type_nm"  value="<%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%>">
			                <input type="hidden" name="st_item_type_co"  value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
				   </td>        
<%
}else{
%>
                   <td title="계약여부/단위/재고">
					 <% if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N")){ %><font color="blue"><%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%></font>                    
		       <% }else if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("A")){ %><font color="red"><%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%></font>            
		       <% }else if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("C")){ %><font color="green"><%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%></font>                     
		       <% }  %>
      				<br>
						<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%><br><%=CommonUtil.nvl(rowData.get("GUBUN")).equals("STOCK")?"재고가능":"비재고"%>
				   </td>
                   <td title="재고수량/단가" class="right">
						<% if(CommonUtil.nvl(rowData.get("STOCK_QTY")).equals(0)){ %>
							<span class="Price"><%=CommonUtil.formatNumber(rowData.get("STOCK_QTY"),true,0,3)%><br></span>
						<% } %>
						<span class="Price"><%=CommonUtil.formatNumber(rowData.get("STOCK_FLAG"),true,0,3)%></span>
						<br><span class="Price"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></span>
		                    <input type="hidden" name="st_unit_price"  value="<%=CommonUtil.nvl(rowData.get("TARGET_PRICE"))%>">
		                    <input type="hidden" name="st_list_price"  value="<%=CommonUtil.nvl(rowData.get("LIST_PRICE"))%>">
		                    <input type="hidden" name="st_description2" value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>">
		                    <input type="hidden" name="st_specification2"  value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
		                    <input type="hidden" name="st_item_type_nm"  value="<%=CommonUtil.nvl(rowData.get("PRODUCT_FLAG"))%>">
			                <input type="hidden" name="st_item_type_co"  value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
				   </td>        
<%
}
%>            
    
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
</div>
<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
	<input type="hidden" name="stdcateg_id" id="stdcateg_id" value="" />
	<input type="hidden" name="stdcatlg_id" id="stdcatlg_id" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="com_code" id="com_code" value="" />
	<input type="hidden" name="buyer_tem_no" id="buyer_tem_no" value="" />
	<input type="hidden" name="category_no" id="category_no" value="" />
	<input type="hidden" name="key_flag" id="key_flag" value="" />
	<input type="hidden" name="cata" id="cata" value="" />
	<input type="hidden" name="gbnReturn" id="gbnReturn" value="" />
	<input type="hidden" name="st_categ_id" id="st_categ_id" value="">	
	<input type="hidden" name="st_pid"  id="st_pid"  value="">
	<input type="hidden" name="st_categ_level" id="st_categ_level" value="">
	<input type="hidden" name="st_return" id="st_return" value="SEARCH">
	<input type="hidden" name="st_categ_type" id="st_categ_type" value="">
	<input type="hidden" name="st_categ_sys_code" id="st_categ_sys_code" value="">
	<input type="hidden" name="st_byca_comorg_code" id="st_byca_comorg_code" value="">
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=byca_comorg_code%>"/>
	<input type="hidden" name="st_categ_id" id="st_categ_id" value="" />	
	<input type="hidden" name="product_flag" id="product_flag" value="" />
	<input type=hidden name="st_s_logic" id="st_s_logic"  value="<%=p060000055%>">
</form>

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
function getNextCategory(categ_sys_code, categ_name, std_categ_id, pid, depth, categ_type, byca_comorg_code){
	document.locationForm.st_categ_id.value = std_categ_id; // 표준카테고리ID
	document.locationForm.st_pid.value = pid; 
	document.locationForm.st_categ_level.value = depth;
	document.locationForm.st_categ_type.value = categ_type;
	document.locationForm.st_categ_sys_code.value = categ_sys_code;
	document.locationForm.st_byca_comorg_code.value = byca_comorg_code; 


	$('#locationForm').attr("action", "<%=h_sslurl%>/mdcm/showBuyerMdCmCategoryPCOSearch.do").submit();   
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
	document.locationForm.gbnReturn.value = "CATEG";
	document.locationForm.st_categ_id.value = category_no; // 카테고리번호
	
	$('#locationForm').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmPCOLisDetail.do").submit();   
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


function searchSort(gubun){
	// 정렬순서 조정
	if (gubun != ""){			

		document.forms.searchForm.st_sort_column.value =gubun; 
	    if(document.forms.searchForm.st_sort_flag1.value == "DESC"){
	    	document.forms.searchForm.st_sort_flag1.value = "ASC";
	    }else {
	    	document.forms.searchForm.st_sort_flag1.value = "DESC";
	    }
	} else {
		document.forms.searchForm.st_sort_column.value ="";  
		document.forms.searchForm.st_sort_flag1.value =""; 
	}
	kepSearch(1);
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
				var st_order_qty =  0;
				var st_agent     = document.forms.contentForm.st_agent_code.value;
				var contract_no  = document.forms.contentForm.st_contract_no.value;
				var contract_seq = document.forms.contentForm.st_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
            	var item_type =document.forms.contentForm.st_item_type_co.value;
				var st_description2 =document.forms.contentForm.st_description2.value;
				var st_specification2 =document.forms.contentForm.st_specification2.value;
				var st_unit_price =document.forms.contentForm.st_unit_price.value;
                var st_agent_flag = document.contentForm.st_agent_flag.value;
                var key_flag      = st_agent_flag.substr(0,2);
                
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
                if(key_flag == "복수"){
                    var st_key_flag = "Y";
                }else{
                    var st_key_flag = "N";
                }

                if(st_key_flag == "Y"){
                    alert( " 상품구분이 필요한 항목입니다.   \n\n 상품코드를 클릭해서 제품 상세보기에서 공급사를 선택해 주시기 바랍니다.     ");
                    box.checked = false;
                    return;
                }
                query = st_item_no + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + st_description2 + "@@"  + st_specification2 +  "@@"  + st_unit_price + "@@" + st_order_qty+"&&";

            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
				var st_item_no   = document.forms.contentForm.st_item_no[i].value;
				var st_order_qty = 0;
				var st_agent     = document.forms.contentForm.st_agent_code[i].value;
				var contract_no  = document.forms.contentForm.st_contract_no[i].value;
				var contract_seq = document.forms.contentForm.st_contract_seq[i].value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;
				var item_type =document.forms.contentForm.st_item_type_co[i].value;
				var st_description2 =document.forms.contentForm.st_description2[i].value;
				var st_specification2 =document.forms.contentForm.st_specification2[i].value;
				var st_unit_price =document.forms.contentForm.st_unit_price[i].value;
                var st_agent_flag = document.contentForm.st_agent_flag[i].value;
                var key_flag      = st_agent_flag.substr(0,2);
                
                if(box.checked == true){
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
	                if(key_flag == "복수"){
	                    var st_key_flag = "Y";
	                }else{
	                    var st_key_flag = "N";
	                }

	                if(st_key_flag == "Y"){
	                    alert( " 상품구분이 필요한 항목입니다.   \n\n 상품코드를 클릭해서 제품 상세보기에서 공급사를 선택해 주시기 바랍니다.     ");
	                    box.checked = false;
	                    return;
	                }
					 query += st_item_no + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + st_description2 + "@@"  + st_specification2 +  "@@"  + st_unit_price + "@@" + st_order_qty;
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
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmPCODLisList.do").submit();   
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
	}else if (pMethod == "QsaveProcess"){ 
		 alert("임시저장 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");   
	 
	}
} 
 

//상품 큰이미지
function getBigImage(file_dir, file_name){	
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
</script>
</html>
