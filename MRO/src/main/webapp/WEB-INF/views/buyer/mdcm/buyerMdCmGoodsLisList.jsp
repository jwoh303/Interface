<%--
**********************************************
* 메뉴 : 상품검색>카테고리상품검색>상품목록
* 화면 : 상품목록
* 기능 : 카테고리에서 최하단취 카테고리를 선택한 후 보여지는 상품목록. 장바구니에 담을 수 있다.
* 프로그램 ID : PG_06_B_002_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-13
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
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_CATEGORY = (List<Map<String,String>>) request.getAttribute("data_CATEGORY"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_MAKER = (List<Map<String,String>>) request.getAttribute("data_MAKER"); // 조회된 결과
    
	// 조회조건 S
	String buyerCategItemListLocation_categ_code = CommonUtil.nvl((String) request.getParameter("buyerCategItemListLocation_categ_code"),"");   
	String buyerCategItemListLocation_buyer = CommonUtil.nvl((String) request.getParameter("buyerCategItemListLocation_buyer"),"");   
	String buyerCategItemListLocation_byca_comorg_code = CommonUtil.nvl((String) request.getParameter("buyerCategItemListLocation_byca_comorg_code"),"");   
	String buyerCategItemListLocation_company = CommonUtil.nvl((String) request.getParameter("buyerCategItemListLocation_company"),"");     
	 
	String categ_code = CommonUtil.nvl((String) request.getParameter("categ_code"),"");   
	String buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");   
	String byca_comorg_code = CommonUtil.nvl((String) request.getParameter("byca_comorg_code"),"");   
	String company = CommonUtil.nvl((String) request.getParameter("company"),"");   
	String category_no = CommonUtil.nvl((String) request.getParameter("category_no"),"");   
	String maker_name = CommonUtil.nvl((String) request.getParameter("maker_name"),"");   
	
	
	if ("".equals(buyerCategItemListLocation_categ_code)){		
	}else{
		categ_code = buyerCategItemListLocation_categ_code; // 카테고리번호
	}
	if ("".equals(buyerCategItemListLocation_buyer)){		
	}else{
		buyer = buyerCategItemListLocation_buyer;
	}
	if ("".equals(buyerCategItemListLocation_byca_comorg_code)){		
	}else{
		byca_comorg_code = buyerCategItemListLocation_byca_comorg_code;
	}
	if ("".equals(buyerCategItemListLocation_company)){		
	}else{
		company = buyerCategItemListLocation_company;
	}
	if ("".equals(category_no)){		
		category_no = buyerCategItemListLocation_categ_code; // 카테고리번호
	} 	
	
	String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"SPECIFICATION");   
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");   
	
	// 조회조건 E
	String SessionComCode = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	String img_view_flag   = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
	}  
	 if(image_status.equals("")){ 
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	 
	 int cols_cnt = 5; // 카테고리,제조사 정렬 갯수
	
	 
	 String tmp = "";
	 if ("KRKOLO0033".equals(SessionComCode) || "KRDOOS0020".equals(SessionComCode) || "KRILJI0002".equals(SessionComCode)) {
		 tmp ="";
	 }else {
		 tmp = "실적";
	 }
	 
	 
	//SLOGIC-BEGIN(P06-0000036)
	 String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	 String p060000036 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000036","COL02_DATA", request); // 권한별URL
	 if (p060000036 == null){
	 	p060000036 = defaultUrl;
	 }else if ("".equals(p060000036)){
	 	p060000036 = defaultUrl;
	 }
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
	
	<table class="cont_t_list05" style="width:100%">
	<tr>
		<td  colspan="<%=cols_cnt %>" >카테고리</td>
	</tr> 
<%
if (_data_CATEGORY == null || _data_CATEGORY.size() == 0){
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
				<td width="100"><a href="javascript:top_kepSearch('1','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_TEXT"))%>')"><%=CommonUtil.nvl(rowData.get("CATEGORY_TEXT"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("CNT"))%></a> </td> 
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
if (_data_MAKER == null || _data_MAKER.size() == 0){
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
			<td width="100"><a href="javascript:top_kepSearch('2','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>','<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>')"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("CNT"))%></a> </td> 
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
		<input type="hidden" name="st_sort_gubun" id="st_sort_gubun" value="<%=st_sort_gubun %>">  
		<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=st_sort_change %>">  
 		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">  
		<input type="hidden" name="maker_name" id="maker_name" value="<%=maker_name %>">		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
 		
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
			
			<span class="btn_imghide">
			  <%  if(image_status.equals("IMAGE_HIDDEN")){   %>
			  <div title="이미지보이기" ><a href="javascript:imageHideView();">이미지보이기</a></div>
			  <%  }else{   %>
			 <div title="이미지감추기" ><a href="javascript:imageHideView();">이미지감추기</a></div>
			  <%  }   %>
      		</span>
			&nbsp;
			<span class="btn_gray_04" title="품목코드" ><a href="javascript:doAction('search','BUYER_ITEM_NO');">품목코드</a></span>
			&nbsp;
			<span class="btn_gray_03" title="품목명" ><a href="javascript:doAction('search','DESCRIPTION');">품목명</a></span>
			&nbsp;
			<span class="btn_gray_02" title="규격" ><a href="javascript:doAction('search','SPECIFICATION');">규격</a></span>
			&nbsp;
			<span class="btn_gray_03" title="제조사" ><a href="javascript:doAction('search','MAKER_NAME');">제조사</a></span>
			&nbsp;
			<span class="btn_gray_02" title="<%=tmp %>단가" ><a href="javascript:doAction('search','TARGET_PRICE');"><%=tmp %>단가</a> </span>
			
      	</span>       
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table class="cont_t_list02" style="width:100%">
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
if (_gridList == null || _gridList.size() == 0){
}else{
%>  						
							<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck')">
<%} %>							
				</th> 
                <th scope="col">이미지</th>
                <th scope="col">품목코드/품목명/규격</th>
                <th scope="col">원산지/제조사</th>
                <th scope="col">구매수량/단위/협력사</th>
                <th scope="col"><%=tmp %>단가</th> 
			</tr>
		</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
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
					<input type="checkbox" name="lnCheck<%=j%>">	                   
				</td>
				<td title="이미지">
<% if(image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%> 
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }
    }
%>				
					</td>                      
                    <td class="left" title="품목코드/품목명/규격">&nbsp;<a class="hyperLink"  href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>','CATA');"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>&nbsp;
					<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("ORG_BUYER_ITEM_NO"))%>" >
					<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%></a><br>
             		&nbsp;<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%> 
					<% if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N")) { %> <% } else { %> <br><font color="green">(재 판매일 :<%=CommonUtil.nvl(rowData.get("HS_NO"))%>)</font><% } %>
                 
                    </td>          
                   <td title="원산지/제조사">
				   <%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%> <br>
				   <%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%> <%=("KRMYUN0046".equals(SessionComCode) ? "/"+CommonUtil.nvl(rowData.get("DELIVERY_LT")) +"일"  : "")%>

				   </td>            
                   <td title="구매수량/단위/협력사">
				   
				   <input type="text"  name="st_order_qty" id="st_order_qty" size="4" value="1" id="line" class="input_type_text" > 
				 <%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%> <br>
<!-- 검색엔진 SQL문에서 한글 미지원으로 수정 , (복수협력사입니다 ==> MULTI_AGENT) , (코리아e플랫폼(주) ==> KOREAEPLATFORM)  수정함 -->
<% if(CommonUtil.nvl(rowData.get("AGENT")).equals("MULTI_AGENT")) { %>
                &nbsp;복수협력사입니다 
<% }else { %>
                 &nbsp;<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=CommonUtil.nvl(rowData.get("AGENT3"))%>');"><%=(CommonUtil.nvl(rowData.get("AGENT")).equals("KOREAEPLATFORM")) ? "코리아e플랫폼(주)" : CommonUtil.nvl(rowData.get("AGENT"))%></a>
<% } %>
<!-- 검색엔진 SQL문에서 한글 미지원으로 수정 , (복수협력사입니다 ==> MULTI_AGENT) , (코리아e플랫폼(주) ==> KOREAEPLATFORM)  수정함 -->
                   <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT2"))%>">
                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
      

				   </td>            
                   <td title="<%=tmp %>단가" class="right">
				   <a class="hyperLink"   href="javascript:getBuyerPriceHistoryPop('<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>');"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></a> 

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
				<span class="btn_04"  title="나의상품등록" >
					<a href="javascript:doAction('myItem','');">나의상품등록</a> 
				</span>	
				<span class="btn_04" title="장바구니담기" >
					<a href="javascript:doAction('cartItem','');">장바구니담기</a>
				</span>					
            </div>
        </div>
        
        
<% if  ("KRKOLO0031".equals(SessionComCode)){%>        
※ 찾는 상품이 없을시 인사총무팀(02-2120-7898)으로 연락바랍니다.
<%} %>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/> 
</form>

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
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/> 
	<input type="hidden" name="byca_comorg_code" id="byca_comorg_code" value="<%=byca_comorg_code %>"> 
	<input type="hidden" name="sort_gubun" id="sort_gubun" value="<%=st_sort_gubun %>">  	
	<input type="hidden" name="sort_change" id="sort_change" value="<%=st_sort_change %>">  
	<input type="hidden" name="image_status" id="image_status" value="<%=image_status %>">  	
	<input type="hidden" name="maker_name" id="maker_name" value="<%=maker_name %>">
</form>

<form name="locationForm2" id="locationForm2" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	
	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="">
	<input type="hidden" name="st_description" id="st_description" value="">
	<input type="hidden" name="st_specification" id="st_specification" value="">
	<input type="hidden" name="st_maker_name" id="st_maker_name" value="">		
</form>

</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<div id="confirmArea"  style="position:absolute; left:  250px; top: 250px; width: 500px; height: 100px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 1px solid blue; padding:20px;">
 <h4 id="confirmMsg"></h4>  
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
function getBuyerCatalogDisplay(stdcateg_id,stdcatlg_id,buyer,org_buyer_item_no,category_no,key_flag,cata){
	
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

	$('#locationForm').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsLisDetail.do").submit();   
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
		
		// 정렬순서 조정
		if (gubun != ""){			
			$("#st_sort_gubun").val(gubun); 
		    if($("#st_sort_change").val() == '0'){
		    	$("#st_sort_change").val("1");
		    }else {
		    	$("#st_sort_change").val("0");
		    }
		} else {
			$("#st_sort_gubun").val("SPECIFICATION"); 
			$("#st_sort_change").val("");
		}
		
		kepSearch(1);
		break; 
 
	case "myItem": // 나의상품 담기 
		saveProcess("R");
		break;  
	
	case "cartItem": // 장바구니 담기
		saveProcess("C");
		break;  
	
	}
}

 
// 1 카테고리
// 2 제조사
function top_kepSearch(flag,category_no,maker_name){ 
	
	document.forms.searchForm.category_no.value = category_no; 
	if (flag==2)
	{
		document.forms.searchForm.maker_name.value = maker_name; 
	}	else{
		document.forms.searchForm.maker_name.value = ""; 
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
            	var order_qty     = document.forms.contentForm.st_order_qty.value;
                var st_agent_flag = document.forms.contentForm.st_agent_flag.value;
		        var st_item_no   = document.forms.contentForm.st_item_no.value;
				var st_order_qty = document.forms.contentForm.st_order_qty.value;
				var st_agent     = document.forms.contentForm.st_agent_code.value;
				var contract_no  = document.forms.contentForm.st_contract_no.value;
				var contract_seq = document.forms.contentForm.st_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;

                var key_flag      = st_agent_flag.substr(0,2); 
                if(st_agent_flag == "MULTI_AGENT"){
                    var st_key_flag = "Y";
                }else{
                    var st_key_flag = "N";
                }
                if(!kepChkDecimal(order_qty,3)){
                    alert( " 첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
                    document.forms.contentForm.st_order_qty.focus();
                    return;
                }
                else if(st_key_flag == "Y"){
                    alert( " 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     ");
                    box.checked = false;
                    return;
                }else{
					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
				}
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                var order_qty     = document.forms.contentForm.st_order_qty[i].value;
                var st_agent_flag = document.forms.contentForm.st_agent_flag[i].value;
				var st_item_no   = document.forms.contentForm.st_item_no[i].value;
				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;
				var st_agent     = document.forms.contentForm.st_agent_code[i].value;
				var contract_no  = document.forms.contentForm.st_contract_no[i].value;
				var contract_seq = document.forms.contentForm.st_contract_seq[i].value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;

                if(box.checked == true){
                    
                    var key_flag      = st_agent_flag.substr(0,2); 
                    if(st_agent_flag == "MULTI_AGENT"){
                        var st_key_flag = "Y";
                    }else{
                        var st_key_flag = "N";
                    }
                    if(!kepChkDecimal(order_qty,3)){
                        alert( i+" 번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.    ");
                        document.forms.contentForm.st_order_qty[i].focus();
                        return;
                    }
                    else if(st_key_flag == "Y"){
                        alert( " 상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.     ");
                        box.checked = false;
                        return;
                    }else {
					  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
					  query += "&&";
					}
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
	
    var image_status   = $("#st_image_status").val();
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    $("#st_image_status").val(image_status);
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}

// 조회
function kepSearch(curPage){
		
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsLisList.do").submit();   
}
   
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){ 
}



/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 
 */
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
		 
	if (gubun == "CsaveProcess"){ // 장바구니 		
	}else if (gubun == "RsaveProcess"){ // 나의상품 		
	}  		 
	
	document.forms.processForm.st_use_flag.value = flag; 
	document.forms.processForm.st_query2.value = query;
	
	kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm",gubun); 
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
        	   
        	   
        	   $('#locationForm2').attr("action", "<%=h_sslurl%><%=p060000036%>").submit();    
        	
        	
           }
        	
       }else {
          alert("나의상품으로 등록 되었습니다.   ");
          
          if (confirm4 == "search"){ 
        	  // 계속검색클릭 
           	 // 처리후 재조회
           	 kepSearch($("#curPage").val());          	   
          }else{     
          
          $('#locationForm2').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit();   
          }
       } 
        
      }else{
    	  
         if(pMethod == "CsaveProcess")
          {
            alert("품목코드 (" + sMsg + ") 은 이미 장바구니에 저장된 항목입니다.  ");
          }else {
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
