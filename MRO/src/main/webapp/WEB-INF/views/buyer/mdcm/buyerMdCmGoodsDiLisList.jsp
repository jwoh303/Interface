<%--
**********************************************
* 메뉴 : 검색엔진을 이용한 조회
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
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
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
	String searchKeyWord =CommonUtil.nvl((String)request.getAttribute("searchKeyWord"),""); // 조회된 결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_CATEGORY = (List<Map<String,String>>) request.getAttribute("data_CATEGORY"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_MAKER = (List<Map<String,String>>) request.getAttribute("data_MAKER"); // 조회된 결과
     
	String tmp_categ_text = CommonUtil.nvl((String) request.getParameter("st_tmp_categ_text"),""); // 장바구니 카테고리 구조 저장
	
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
	String st_contract_flag = CommonUtil.nvl((String) request.getParameter("st_contract_flag"),""); 
	// 조회조건 E
	String SessionComCode = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	String img_view_flag   = "";
	String agent_open_flag = "";
	String st_no_contract_hidden_flag = CommonUtil.nvl((String) request.getParameter("st_no_contract_hidden_flag"),"N");
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag());
		agent_open_flag =  CommonUtil.nvl((String)sessionInfo.getAgentOpenFlag());
	}  
	 if(image_status.equals("")){ 
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	
	 
	 int cols_cnt = 5; // 카테고리,제조사 정렬 갯수
	 
	 // 카테고리, 제조사 숨겨있는 ROW수
	 int add_row = 0;
	 int add_row2 = 0;
	 
	 String tmp = "";
	 if ("KRKOLO0033".equals(SessionComCode) || "KRDOOS0020".equals(SessionComCode) || "KRILJI0002".equals(SessionComCode)) {
		 tmp ="";
	 }else {
		 tmp = CommonLang.get("HTITLE823") ;	//"실적"
	 }
	 
	 
	 
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
	//SLOGIC-END
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	//SLOGIC-END
	
	// SLOGIC-BEGIN(P06-0000082) - 미스미 품목 검색 기능 오픈 여부.
	boolean p060000082 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000082");
	String misumi_open_flag = "N";
	if ( p060000082 == true ) {
		misumi_open_flag = "Y";
	}
	Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	String st_timestamp = Long.toString(timestamp.getTime());
	// SLOGIC-END
	
	//SLOGIC-BEGIN(P06-0000078) - 상품검색 화면 단가 이력 미공개 고객사
	boolean p060000078 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000078");
	String price_History_Pop_flag = "Y";
	if ( p060000078 == true ) {
		price_History_Pop_flag = "N";
	}
	// SLOGIC-BEGIN(P06-0000093) - 단종 단가표기 안되며, 장바구니 나의 상품등록이 불가능.
	boolean p060000093 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000093");
	// SLOGIC-BEGIN(P06-0000094) - 기등록 품목 신규견적 의뢰 기능 활성화.
	boolean p060000094 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000094");
	String g_product_close_flag = "N";
	if ( p060000093 == true ) {
		g_product_close_flag = "Y";
	}	
    //MOQ를 이용하여 주문 통제
    boolean p060000077 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000077"); 
    //주문배수를 이용하여 주문 통제
    boolean p060000089 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000089");
  	//견적의뢰 기능 비활성화
    boolean p060000102 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000102");
  	//USER_GRUP=Z 체크하여 견적 비활성화
  	String user_group = CommonUtil.nvl((String)_sessionInfo.getUserGroup(),""); //사용자견적권한
  	if(user_group.equals("Z")){
  		p060000102 = true;
  	}
  	// 그룹카탈로그 내 당사 미계약품목 보이는 고객사
    boolean p060000066 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000066");
%> 
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<div id="container2">
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
<%
//검색결과가 없을 경우.
if (list == false){
%>
        <div class="PDSearch_NO">
			<p><span class="Color_red"><%=searchKeyWord%></span>에 대한 검색결과가 없습니다.</p>
            <p>정확한 검색어인지 확인하시고 다시 검색해 주세요.</p>
            <p>- 단어 사이의 띄어쓰기를 해보시거나 일반적인 검색어로 다시 검색해 보세요.</br>
            - 카테고리를 선택하시거나 제조사 등을 입력하시면 보다 정확한 검색이 가능합니다.</br>
            - 한글을 영어로 혹은 영어를 한글로 입력했는지 확인해보세요.</p>
           <a href="/mprq/showBuyerMpRqRequestQuotationStnd.do?upperId=b00100000000"> <div class="Btn_Estimate">신규견적 의뢰 안내</div></a>
        </div>
    </div>
<%
}else{
%>
	<form name = "searchForm" id="searchForm" method = "post">
	<input type="text" name="st_result_keyword2"  id="st_result_keyword2" style="display:none" />
	<div class="SearchTitBox"> 
     <div class="H2Tit">' <span class="Color_red"><%=searchKeyWord%></span> <%=CommonLang.get("HTITLE813") 
     %><!-- ' 검색결과 (총 --> <%=total_cnt %><%=CommonLang.get("HTITLE814") %><!-- 건) --></div>
     	<div  class="ReSearch">
          	<select disabled>
                  <option selected><%=CommonLang.get("HTITLE918") %><!--포함단어 --></option>
                  <%--<option><%=CommonLang.get("HTITLE919") %><!-- 제외단어 --></option> --%>
              </select>
              <input type="text" name="st_result_keyword"  id="st_result_keyword"  value="<%=h_searchResultKeyword%>"   class="input01"  onKeyDown="if(event.keyCode==13){searchEnter()};"/>
              <a href="javascript:resultKepSearch('1')"><p>검색</p></a>
          </div>
     </div>
        <!-- 검색 카테고리-->
        <div class="CASearchDetail">
            <div class="CATit"><%=CommonLang.get("HTITLE510") %><!-- 카테고리 --><p id="CA_Btn" class="CA_Expand" > 닫기/펼치기</p> </div>
        	    <div class="CAList">
    	    	    <ul class="CA_Box">
						<% 
						for (int j=0; j<_data_CATEGORY.size(); j++) {
							Map<String,String> rowData = _data_CATEGORY.get(j); 			
								if(j < 10){%>
										<li><a href="javascript:top_kepSearch('1','<%=CommonUtil.nvl(rowData.get("groupId"))%>')"><%=CommonUtil.nvl(rowData.get("groupId"))%> <span>(<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</span></a></li> 
								<%}%>  
						<%}%>
                </ul>
                <ul id="CA_hidden" class="CA_hiddenBox" style="display: none" >
                    <li class="allView"><%=CommonLang.get("HTITLE29") %><!--전체 --> (<%=total_cnt %>)</li>  
						<% for (int j=0; j<_data_CATEGORY.size(); j++) {
							Map<String,String> rowData = _data_CATEGORY.get(j); 			
						%>
										<li><a href="javascript:top_kepSearch('1','<%=CommonUtil.nvl(rowData.get("groupId"))%>')"><%=CommonUtil.nvl(rowData.get("groupId"))%> <span>(<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</span></a></li> 
						<%}%>
                </ul>
            </div>
        </div>
        <!-- 검색 브랜드-->
        <div class="BRSearchDetail">
            <div class="BRTit"><%=CommonLang.get("HTITLE15") %><!-- 제조사 --> <p id="BR_Btn" class="BR_Expand" > 닫기/펼치기</p> </div>
            <div class="BRList">
                <ul class="BR_Box">
						<% for (int j=0; j<_data_MAKER.size(); j++) {
							Map<String,String> rowData = _data_MAKER.get(j); 			
								if(j < 10){%>
										<li><a href="javascript:top_kepSearch('2','<%=CommonUtil.nvl(rowData.get("groupId"))%>')"><%=CommonUtil.nvl(rowData.get("groupId"))%> <span>(<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</span></a></li>
								<%}%>  
						<%}%>
                </ul>
                <ul id="BR_hidden" class="BR_hiddenBox" style="display: none" >
                    <li class="allView"><%=CommonLang.get("HTITLE29") %><!--전체 --> (<%=total_cnt %>)</li>
						<% for (int j=0; j<_data_MAKER.size(); j++) {
							Map<String,String> rowData = _data_MAKER.get(j);%> 			
										<li><a href="javascript:top_kepSearch('2','<%=CommonUtil.nvl(rowData.get("groupId"))%>')"><%=CommonUtil.nvl(rowData.get("groupId"))%> <span>(<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</span></a></li>
						<%}%>
                </ul>
            </div>
        </div>
	<!--조회영역 리스트정렬-->
    <div class="SearchSortBox">
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
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		<div class="SearchPDTit"><%=CommonLang.get("HTITLE921") %><!--  개의 상품이 있습니다.--> <span class="Color_red"><%=total_cnt %></span><%=CommonLang.get("HTITLE920") %><!--  개의 상품이 있습니다.--> </div>
            <!--상품정렬-->
            <div class="PDSort">
            	<%
					if(p060000066==true) {
				%>
				   	<select style="width:110px;" id="st_no_contract_hidden_flag" name="st_no_contract_hidden_flag" onchange="javascript:kepSearch(1);">
				   		<option value = "N" <%if ("N".equals(st_no_contract_hidden_flag)) {%>selected<%} %>>미계약 포함<!-- 미계약 포함 --></option>
				   		<option value = "Y" <%if ("Y".equals(st_no_contract_hidden_flag)) {%>selected<%} %>>미계약 제외<!-- 미계약 제외 --></option>
				   	</select>
				<%
					} else { %>
						<input type="hidden" name="st_no_contract_hidden_flag" id="st_no_contract_hidden_flag" value="">
				<% 	} %>
				
            	<a href="javascript:searchSort('BUYER_ITEM_NO');"><p><%=CommonLang.get("HTITLE12") %></p><!-- 품목코드 --></a></span>
            	<a href="javascript:searchSort('DESCRIPTION');"><p><%=CommonLang.get("HTITLE13") %></p><!-- 품목명 --></a></span>
            	<a href="javascript:searchSort('SPECIFICATION');"><p><%=CommonLang.get("HTITLE14") %></p><!-- 규격 --></a></span>
            	<a href="javascript:searchSort('MAKER_NAME');"><p><%=CommonLang.get("HTITLE15") %></p><!-- 제조사  --></a></span>
            	<a href="javascript:searchSort('TARGET_PRICE');"><p><%=tmp %><%=CommonLang.get("HTITLE174") %></p><!-- 단가 --></a></span>
				<select name="onepagerow" onchange="javascript:kepSearch(1);"> 
					<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value = "15" <%if ("15".equals(onepagerow)) {%>selected<%} %>>15<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
					<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
					<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
				</select>
            </div>
     </div>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
	<div class="Line"></div>
<%
	Map<String,String> rowData = null;
	for (int j=0; j<_gridList.size(); j++) {
		rowData = _gridList.get(j);
%>
        <div class="PD_Long">
            <ul>
                <li class="PD_checkbox" >
                	<input type="checkbox" name="lnCheck<%=j%>"  id="lnCheck<%=j%>"  /> <label for="lnCheck<%=j%>"> <span></span> </label>
                </li>
                <li class="PDLongImg">
<!-- 검색엔진 SQL문에서 한글 미지원으로 수정 , (복수협력사입니다 ==> MULTI_AGENT) , (코리아e플랫폼(주) ==> KOREAEPLATFORM)  수정함 -->
                   <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>">
                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
                   <input type="hidden" name="st_stnd_flag"  value="<%=CommonUtil.nvl(rowData.get("STND_FLAG"))%>">
                   <input type="hidden" name="st_product_close_flag"  value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
                   <input type="hidden" name="st_over_short_flag"  value="<%=CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG"))%>">
					<%     
						if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
					%>
					          <img src="/resources/images/noimage.gif"  border="0"><br>
					          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""){ %>
					          		<div class='Uncontracted'><p><%=CommonLang.get("HTITLE816") %><!-- 미계약품목 --></p><p>BG</p> </div>
					          <%}else{
					        	    if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){
					          %> 
					          			<div class='Outitem_New'>품절</div>
					          <%	}
					          %>
					          <%
					        	    if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){
					          %> 
					          			<div class='Outitem_New'>단종</div>
					          <%	}
					          }
						     }else{ %> 
					             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" border="0"></a><br>
					          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""){ %>
					          		<a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
					          			<div class='Uncontracted'><p> <%=CommonLang.get("HTITLE816") %><!-- 미계약품목 --> </p><p>BG</p> </div>
					          		</a>
					          <%}else{
					        	    if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){
					          %> 
					          			<div class='Outitem_New'><p> 품절 </p><p>BG</p> </div>
					          <%	}
					          %>
					          <%
					        	    if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){
					          %> 
					          			<div class='Outitem_New'><p> 단종 </p><p>BG</p> </div>
					          <%	}
					         	 }
					          }
					%>	
                </li>
                <li >
          			<%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) =="" || CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC")){ %>
          				<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
                    	<p class="PDLongCode"> <%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></p> &nbsp;  <p class="PDLongName"><%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%></p><br/>
						 <p class="PDLongTxt"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></p></a><br/>
                    <%}else{%>
              			<%
						//사용자 언어타입이 영어일 영문 품명, 규격 표기
						if(h_get_session_user_lang.equals("EN")) {
						%> 
							<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
	                    	<a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>');">
                    		<p class="PDLongCode"> <%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></p> &nbsp;  <p class="PDLongName"><%=CommonUtil.nvl(rowData.get("DESCRIPTION_ENG"))%></p><br/>
						 	<p class="PDLongTxt"><%=CommonUtil.nvl(rowData.get("SPECIFICATION_ENG"))%>
							
							 / MOQ:  <%=rowData.get("MIN_ORDER_QTY")%>
							
							
							 / 주문배수:  <%=rowData.get("PUR_UNIT_QTY")%>
							
						 	</p></a><br/>
              			<%
						}else{
						%>
							<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
	                    	<a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>');">
                    	   	 <p class="PDLongCode"> <%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></p> &nbsp;  <p class="PDLongName"><%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%></p><br/>
						 	 <p class="PDLongTxt"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
							
							 / MOQ:  <%=rowData.get("MIN_ORDER_QTY")%>
							
							 / 주문배수:  <%=rowData.get("PUR_UNIT_QTY")%>
							
							<%
								if(CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")) !="") {
							%>
							 / <%=CommonLang.get("HTITLE956") %><!-- 녹색구매제품 -->:  <%=rowData.get("BUY_GREEN_ITEM_NM")%>
							<%
								}
							%>
						 	 </p></a><br/>						
              			<%
						}
						%> 
                    <%}%>
					 <p class="PDLongEtc"><%=CommonLang.get("HTITLE120") %><!-- 원산지 --> : <%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%> │ <%=CommonLang.get("HTITLE15") %><!-- 제조사 --> : <%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%> │ <%=CommonLang.get("HTITLE144") %><!-- 협력사 --> : 
							 <!-- 검색엔진 SQL문에서 한글 미지원으로 수정 , (복수협력사입니다 ==> MULTI_AGENT) , (코리아e플랫폼(주) ==> KOREAEPLATFORM)  수정함 -->
		          			<%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""){ %>
		          			 		<%=CommonLang.get("HTITLE818") %><!-- 미계약품 -->
							<%}else if(CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC")){ %>
		          			 		<%=CommonLang.get("HTITLE886") %><!-- 추천상품 -->							 
		          			<%}else{ %>
								<% if(CommonUtil.nvl(rowData.get("AGENT")).equals("MULTI_AGENT")) { %>
								              <%=CommonLang.get("HTITLE819") %><!-- 복수협력사입니다 --> 
								<% }else { 
										if(agent_open_flag.equals("N")){
													%>
												  <a class="hyperLink"  href="javascript:getAgentDisplayPop('KRKORE0001');"><%=CommonLang.get("HTITLE820") %><!-- 코리아이플랫폼㈜ --></a>
									<%}else{ %>
												 <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>');"><%=(CommonUtil.nvl(rowData.get("AGENT")).equals("KOREAEPLATFORM")) ? "코리아e플랫폼(주)" : CommonUtil.nvl(rowData.get("AGENT"))%></a>
								<% 	}
									} %>
		          			<%} %> │ <%=CommonLang.get("HTITLE52") %><!-- 단위 --> :  <%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></p>
                </li>
                <li class="PDLongPrice" >
                    <p class="PDpriceOne"><%=tmp %><%=CommonLang.get("HTITLE174") %><!-- 단가 --> 
                    	<span>
                    	<%
                    	//단종일 경우 단가 표기 안함.
						if(g_product_close_flag.equals("Y")&&CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){                    	
                    	%>
                    		 	<a href="javascript:getBuyerPriceHistoryPop('<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>');">-</a>
							</span>
		                    </p>   
		                    <p class="PD_order" >
		                    	<button type="button"  id="" onclick="" >빼기</button><input type="text"  name="st_order_qty" id="st_order_qty" size="4" value="1"  onChange="" onBlur="this.value=this.value;" onKeyDown=""><button type="button" id="" onclick="" >더하기</button> 
		                    </p> 
		                    <p class="PDpriceAll"><%=CommonLang.get("HTITLE922") %><!-- 합계 -->  
								   <input type="text"  name="st_sum_price" id="st_sum_price"    value="<%=CommonLang.get("HTITLE887") %>"   readonly><!-- 견적의뢰 Click -->  
		                    </p>
                    	<%
						}else{
                    	%>
		                   <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""||CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC")){ %>
							   <a href="javascript:getBuyerPriceHistoryPop('<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>');">-</a>
						   <%}else{ %>
								<a href="javascript:getBuyerPriceHistoryPop('<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>');"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE_2"),true,0,3)%></a>
						   <%}%>
							   </span>
		                    </p>   
		                    <p class="PD_order" >
		                    	<button type="button"  id="" onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>');" >빼기</button><input type="text"  name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>');"><button type="button" id="" onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>');" >더하기</button> 
		                    </p> 
		                    <p class="PDpriceAll"><%=CommonLang.get("HTITLE922") %><!-- 합계 -->
								   <!-- 계약정보 없을 경우 견적의뢰 Click로 표기. -->                   
				                   <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""||CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC")){ %>
					                   <%
											if(p060000102==false) {
										%>
										   	<a href="javascript:doAction('reqItem','<%=j%>');"><input type="text"  name="st_sum_price" id="st_sum_price"    value="<%=CommonLang.get("HTITLE887") %>"   readonly></a><!-- 견적의뢰 Click -->
					                   <%
											}
										%>
								   <%}else{ %>
								   		<input type="text"  name="st_sum_price" id="st_sum_price"  value="<%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("TARGET_PRICE_2"))),true,0,3) %>"  readonly>
								   <%}%>  
		                    </p>
                    	<%
						}
                    	%>  
                </li>
                <li class="PDLongBtn">
                	<a href="javascript:doAction('cartItem','<%=j%>');"><p class="BuyCart"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></p></a>
                    <a href="javascript:doAction('myItem','<%=j%>');"><p class="BuyFavorite"><%=CommonLang.get("HTITLE10") %><!-- 상품등록 --></p></a>
	<%			
				if ( p060000094 == true ) {
	%>
               <%
					if(p060000102==false) {
				%>
						<a href="javascript:doAction('reqItem','<%=j%>');"><p class="BuyEstimate"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></p></a>
                <%
					}
				%>
	<%			
				}else {
	%>
               <%
					if(p060000102==false) {
				%>
					<a href="javascript:doAction('reqGplItem','<%=j%>');"><p class="BuyEstimate"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></p></a>
                <%
					}
				%>
	<% } %>	
                </li>
            </ul>
        </div>
<%
	}
}
%>


<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 버튼영역 -->
		 <div class="PD_btn">
<%
if (list == false){
%>
				<a href="/mprq/showBuyerMpRqRequestQuotationStnd.do?upperId=b00100000000"><p class="BuyEstimate"><%=CommonLang.get("HTITLE32") %><!-- 견적의뢰 --></p></a> 
<%} %>
<%if(!tmp_categ_text.equals("")){%>			
				<a href="javascript:doAction('goBack','');"><p class="BuyBTN"><%=CommonLang.get("HTITLE821") %><!-- 이전화면 --></p></a>				 
<%}%>
<%if("Y".equals(misumi_open_flag)){%>		
				<a href="javascript:doAction('misumiItem','');"><p class="BuyBTN"><%=CommonLang.get("HTITLE822") %><!-- 미스미품목검색 --></p></a>
<%}%>		
            	<a href="javascript:doAction('checkCartItem','');"><p class="BuyCart"><%=CommonLang.get("HTITLE11") %><!-- 장바구니담기 --></p></a>
            	<a href="javascript:doAction('checkMyItem','');"><p class="BuyFavorite"><%=CommonLang.get("HTITLE10") %><!-- 나의상품등록 --></p></a>
        </div>
		<!-- 페이징 -->
        <div class="PD_Paging">
			<%=CommonUtil.getPageSearchView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span> <%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --> </span>
        </div> 
        
<% if  ("KRKOLO0031".equals(SessionComCode)){%>        
<%=CommonLang.msg("MSG345") %><!-- ※ 찾는 상품이 없을시 인사총무팀(02-2120-7898)으로 연락바랍니다. -->
<%} %>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_pf_my_group" id="st_pf_my_group"  value=""/>
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" /> 
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
	<input type="hidden"  name="st_query"  id="st_query"  value=""   />
	<input type="hidden"  name="st_buyer"  id="st_buyer"  value="${sessionInfo.comCode}">
	<input type="hidden"  name="tmp_categ_text"  id="tmp_categ_text"  value="<%=tmp_categ_text %>"   />
	 
</form>

<form name="misForm" id="misForm" method="post">
	<input type="hidden" name="it_buyer" value="${sessionInfo.comCode}">
	<input type="hidden" name="it_doc_no"	value="<%=st_timestamp%>">
	<input type="hidden" name="p_flag" value="IT">
	<input type="hidden" name="it_searchTerm" id="it_searchTerm" value="<%=searchTerm %>">
</form>
</div>
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<div id="confirmCartArea"   style="display:none;">
   <div  style="position:absolute; left:50%; margin-left:-300px; top:400px; width: 600px; height:100px; text-align:center; background-color: #fff;  z-index:999;  border: 0px; padding:50px 0;">
   	<div style="font-size:16px;" ><h4  id="confirmCartMsg"></h4></div> 		
 		<!-- 버튼영역 -->
		<div style="text-align:center; margin-top:40px"> 
				<span class="btn_04">
					<a href="javascript:kep_confrim_search();"><%=CommonLang.get("HTITLE591") %><!-- 계속검색 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();"><%=CommonLang.get("HTITLE965") %><!-- 장바구니 이동 --></a>
				</span>					
			</div>					
         </div>
    	<div style="position:absolute; top:0; width:100%; height:100%; display:table-cell; background-color:#03F; z-index:99; background-color:#000; opacity: 0.4;   "></div>
</div>
<div id="confirmMyGroupArea"   style="display:none;">
   <div  style="position:absolute; left:50%; margin-left:-300px; top:400px; width: 600px; height:100px; text-align:center; background-color: #fff;  z-index:999;  border: 0px; padding:50px 0;">
   	<div style="font-size:16px;" ><h4  id="confirmMyGroupMsg"></h4></div>
 		<input type="text" name="st_my_group_nm"    id="st_my_group_nm" style="width:20%;border:0px; font-size:11px; background-color:transparent;"  value=" 나의상품 분류지정:" readonly></a>
	 	<select id="st_my_groups" name="st_my_groups" title="분류" style="width:60%;">
			<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "SEL", "ITEM",_sessionInfo.getUserId(), "ICOMCOD3", "", "") %>
		</select>
 		<!-- 버튼영역 -->
		<div style="text-align:center; margin-top:40px"> 
				<span class="btn_04">
					<a href="javascript:kep_confrim_search();"><%=CommonLang.get("HTITLE591") %><!-- 계속검색 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();"><%=CommonLang.get("HTITLE592") %><!-- 이동 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_cancel();"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></a>
				</span>
			</div>					
         </div>
    	<div style="position:absolute; top:0; width:100%; height:100%; display:table-cell; background-color:#03F; z-index:99; background-color:#000; opacity: 0.4;   "></div>
</div>        
<script type="text/javascript">
var popupSel = ""; 

// 더보기 버튼 활성 flag
var showMore_categ_flag = "N";
var showMore_maker_flag = "N";
//상품검색시 카테고리 더보기, 닫기
$(document).ready(function(){
    $('#CA_Btn').click(function(){
        if($("#CA_hidden").is(":visible")){
            $("#CA_Btn").toggleClass("CA_Expand CA_Close");
            $("#CA_hidden").slideUp();
        }else{
            $("#CA_Btn").toggleClass("CA_Close CA_Expand");
        $("#CA_hidden").slideDown();
        }
    });
});
// 상품검색시 브랜드 더보기, 닫기
$(document).ready(function(){
    $('#BR_Btn').click(function(){
        if($("#BR_hidden").is(":visible")){
            $("#BR_Btn").toggleClass("BR_Expand BR_Close");
            $("#BR_hidden").slideUp();
        }else{
            $("#BR_Btn").toggleClass("BR_Close BR_Expand");
        $("#BR_hidden").slideDown();
        }
    });
});
// 최초 화면 함수 
function kep_onload_view(){  
	var st_contract_flag ="<%=st_contract_flag%>";
	if(st_contract_flag == "Y"){
		//document.searchDiForm.st_no_contract_flag.checked = true;
	}else{
		//document.searchDiForm.st_no_contract_flag.checked = false;
	}
}
 
// 화면이동
function getBuyerCatalogDisplay(stdcateg_id,stdcatlg_id,buyer,org_buyer_item_no,category_no,key_flag,cata,image_dir,image_file, product_close_flag){
	//최근본상품저장
	if(product_close_flag == "Y"){
    	//해당 품목은 단종되었습니다.
        alert(" <%=CommonLang.msg("MSG117") %>     ");
		return;
	}
	var searchMyItemList = getKePCookie("searchMyItemList"); 
	searchMyItemList = stdcateg_id+"@@"+stdcatlg_id+"@@"+buyer+"@@"+org_buyer_item_no+"@@"+category_no+"@@"+key_flag+"@@"+cata+"@@"+image_dir+"@@"+image_file+"&&"+searchMyItemList;
	setKePCookie("searchMyItemList", searchMyItemList ,1);
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
	var strBuyer = "<%=buyer%>";
	var price_History_Pop_flag = "<%=price_History_Pop_flag%>";
	
	if(contract_no == ""||contract_no == null){ //계약정보 없을 경우 사업장 팝업 표시
	 	if(price_History_Pop_flag == "N"){ // 팝업 미공개 고객사
	 		//단가정보가 없습니다.
	 		alert("<%=CommonLang.msg("MSG343") %>");
	 		return;
		}else{
			openSearchPopup("/common/mpiv/catePriceBuyerHistory.do","?open=Y&st_byca_comorg_code="+byca_comorg_code+"&st_buyer_item_no="+buyer_item_no,"600,200,no");			
		}
	}else{
		openSearchPopup("/common/mpiv/catePriceHistory.do","?open=Y&st_byca_comorg_code="+byca_comorg_code+"&st_contract_no="+contract_no+"&st_contract_seq="+contract_seq+"&st_buyer_item_no="+buyer_item_no,"420,320,no");
	}
    
}

var st;
var g_product_close_flag = "<%=g_product_close_flag%>"; //특수로직 단종일때 단가 비노출 장바구니, 상품등록 등록 안됨.
//기능함수
function doAction(str , gubun) {
	 
	
	switch (str) {
	case "search":	 //조회	  
		kepSearch(1);
		break; 
 
	case "myItem": // 나의상품 담기 
		document.getElementById("st_my_groups").style.display = "inline-block";
		$("#st_my_group_nm").val("<%=CommonLang.get("HTITLE912") %>:");	//나의상품 분류지정
		saveProcess("R",gubun);
		break;  
	case "checkMyItem": // 나의상품 담기 
		document.getElementById("st_my_groups").style.display = "inline-block";
		$("#st_my_group_nm").val("<%=CommonLang.get("HTITLE912") %>:");	//나의상품 분류지정
		saveCheckProcess("R");
		break;  
	case "cartItem": // 장바구니 담기
		document.getElementById("st_my_groups").style.display = "none";
		$("#st_my_group_nm").val("");
		saveProcess("C",gubun);
		break;  	
	case "checkCartItem": // 장바구니 담기
		document.getElementById("st_my_groups").style.display = "none";
		$("#st_my_group_nm").val("");
		saveCheckProcess("C");
		break;  
	case "reqItem": // 신규견적입력
		saveRqdtProcess(gubun);
		break; 	
	case "reqGplItem": // GPL, 미계약, 단종 건 견적입력
		document.getElementById("st_my_groups").style.display = "none";
		$("#st_my_group_nm").val("");
		saveRqdtGplProcess(gubun);
		break;
	case "misumiItem": // 미스미품목검색
		var misForm	= document.misForm;
		misForm.action	= "/misOpenPop.jsp";
		misForm.target	= "MisumiPop";
		misumiPop = window.open("about:blank","MisumiPop","width=1300,height=600,scrollbars=yes, resize=yes");
		misForm.submit();
		break;
		
	case "goBack": // 이전화면(카테고리상품검색)
		$('#locationForm2').attr("action", "<%=h_sslurl%>/mdcm/showBuyerMdCmCategoryGoodsSearch.do").submit();
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

/*
 * 여러건 처리할 경우 나의상품등록 R
 * 여러건 처리할 경우 장바구니담기 C
 */
function saveCheckProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    //
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//목록에 표시된 상품이 없습니다.
        alert(" <%=CommonLang.msg("MSG16") %>     ");
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
    	//하나 이상의 상품이 선택되어야 합니다.
        alert(" <%=CommonLang.msg("MSG17") %>   ");
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
				//표준카탈로그 매핑 여부
				var st_stnd_flag = document.forms.contentForm.st_stnd_flag.value;
				//단종여부 
				var st_product_close_flag = document.forms.contentForm.st_product_close_flag.value;
                var key_flag      = st_agent_flag.substr(0,2); 
                if(st_agent_flag == "MULTI_AGENT"){
                    var st_key_flag = "Y";
                }else{
                    var st_key_flag = "N";
                }
                if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                	//계약정보 없는 품목은 등록이 불가능 합니다.
                	alert( " <%=CommonLang.msg("MSG344") %> ");
                	return;
                }
                //단종이고 단종일때 단가 비노출이면 처리 불가능.
                if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                	//해당 품목은 단종되었습니다.
                	alert( "<%=CommonLang.msg("MSG117") %>");
                	return;
                }
                if(!kepChkDecimal(order_qty,3)){
                	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
                    alert( " <%=CommonLang.msg("MSG18") %>    ");
                    document.forms.contentForm.st_order_qty.focus();
                    return;
                }
                else if(st_key_flag == "Y"){
                	//상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.
                    alert( " <%=CommonLang.msg("MSG19") %>     ");
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
				//표준카탈로그 매핑 여부
				var st_stnd_flag = document.forms.contentForm.st_stnd_flag[i].value;
				//단종여부 
				var st_product_close_flag = document.forms.contentForm.st_product_close_flag[i].value;
                if(box.checked == true){
                    if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                    	//계약정보 없는 품목은 등록이 불가능 합니다.
                    	alert( " <%=CommonLang.msg("MSG344") %> ");
                    	return;
                    }
                    //단종이고 단종일때 단가 비노출이면 처리 불가능.
                    if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                    	//해당 품목은 단종되었습니다.
                    	alert( "<%=CommonLang.msg("MSG117") %>");
                    	return;
                    }
                    var key_flag      = st_agent_flag.substr(0,2); 
                    if(st_agent_flag == "MULTI_AGENT"){
                        var st_key_flag = "Y";
                    }else{
                        var st_key_flag = "N";
                    }
                    if(!kepChkDecimal(order_qty,3)){
                    	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
                        alert( i+" <%=CommonLang.msg("MSG20") %>    ");
                        document.forms.contentForm.st_order_qty[i].focus();
                        return;
                    }
                    else if(st_key_flag == "Y"){
                    	//상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.
                        alert( " <%=CommonLang.msg("MSG19") %>     ");
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
 
/*
 * 단건 나의상품등록 R
 * 단건  장바구니담기 C
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//목록에 표시된 상품이 없습니다.
        alert(" <%=CommonLang.msg("MSG16") %>     ");
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
    	//하나 이상의 상품이 선택되어야 합니다.
        alert(" <%=CommonLang.msg("MSG17") %>   ");
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
				//표준카탈로그 매핑 여부
				var st_stnd_flag = document.forms.contentForm.st_stnd_flag.value;
				//단종여부 
				var st_product_close_flag = document.forms.contentForm.st_product_close_flag.value;
                var key_flag      = st_agent_flag.substr(0,2); 
                if(st_agent_flag == "MULTI_AGENT"){
                    var st_key_flag = "Y";
                }else{
                    var st_key_flag = "N";
                }
                if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                	//계약정보 없는 품목은 등록이 불가능 합니다.
                	alert( " <%=CommonLang.msg("MSG344") %> ");
                	return;
                }
                //단종이고 단종일때 단가 비노출이면 처리 불가능.
                if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                	//해당 품목은 단종되었습니다.
                	alert( "<%=CommonLang.msg("MSG117") %>");
                	return;
                }
                if(!kepChkDecimal(order_qty,3)){
                	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
                    alert( " <%=CommonLang.msg("MSG18") %>    ");
                    document.forms.contentForm.st_order_qty.focus();
                    return;
                }
                else if(st_key_flag == "Y"){
                	//상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.
                    alert( " <%=CommonLang.msg("MSG19") %>     ");
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
				//표준카탈로그 매핑 여부
				var st_stnd_flag = document.forms.contentForm.st_stnd_flag[i].value;
				//단종여부 
				var st_product_close_flag = document.forms.contentForm.st_product_close_flag[i].value;
                if(box.checked == true){
                    if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                    	//계약정보 없는 품목은 등록이 불가능 합니다.
                    	alert( " <%=CommonLang.msg("MSG344") %> ");
                    	return;
                    }
                    //단종이고 단종일때 단가 비노출이면 처리 불가능.
                    if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                    	//해당 품목은 단종되었습니다.
                    	alert( "<%=CommonLang.msg("MSG117") %>");
                    	return;
                    }
                    var key_flag      = st_agent_flag.substr(0,2); 
                    if(st_agent_flag == "MULTI_AGENT"){
                        var st_key_flag = "Y";
                    }else{
                        var st_key_flag = "N";
                    }
                    if(!kepChkDecimal(order_qty,3)){
                    	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
                        alert( i+" <%=CommonLang.msg("MSG20") %>    ");
                        document.forms.contentForm.st_order_qty[i].focus();
                        return;
                    }
                    else if(st_key_flag == "Y"){
                    	//상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.
                        alert( " <%=CommonLang.msg("MSG19") %>     ");
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
 
//e신규견적입력.
function saveRqdtProcess(y_num){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";

     if(eval(tot_cnt) < 2){
     	var order_qty     = document.forms.contentForm.st_order_qty.value;
        var st_item_no   = document.forms.contentForm.st_item_no.value;

        if(!kepChkDecimal(order_qty,3)){
       		//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
            alert( " <%=CommonLang.msg("MSG18") %>    ");
            document.forms.contentForm.st_order_qty.focus();
             return;
         }
         query = st_item_no;
     }else{
        var order_qty     = document.forms.contentForm.st_order_qty[y_num].value;
		var st_item_no   = document.forms.contentForm.st_item_no[y_num].value;
        if(!kepChkDecimal(order_qty,3)){
        	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
           alert( i+" <%=CommonLang.msg("MSG20") %>    ");
           document.forms.contentForm.st_order_qty[y_num].focus();
           return;
         }
         query += st_item_no + "@@";
     }
    document.forms.locationForm2.st_query.value = query; 
    $('#locationForm2').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmMyRqdtSearchList.do").submit();
}
// 미계약 품목 신규견적
function saveRqdtGplProcess(y_num){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var flag	= "Q";
    var type	= "";


     if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" ); 
        var order_qty    = document.forms.contentForm.st_order_qty.value;
        var st_item_no   = document.forms.contentForm.st_item_no.value;
		var st_order_qty = document.forms.contentForm.st_order_qty.value;
		var st_agent     = document.forms.contentForm.st_agent_code.value;
		var contract_no  = document.forms.contentForm.st_contract_no.value;
		var contract_seq = document.forms.contentForm.st_contract_seq.value;
		var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
		var product_close_flag = document.forms.contentForm.st_product_close_flag.value;

		if((contract_no != null && contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
           	//기등록건은 견적의뢰가 불가능 합니다.
        	alert( " <%=CommonLang.msg("MSG500") %> ");
            return;
        }
        if(!kepChkDecimal(order_qty,3)){
          	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
            alert( " <%=CommonLang.msg("MSG18") %>    ");
            document.forms.contentForm.st_order_qty.focus();
            return;
         }
       if(contract_no == null || contract_no ==""){	// 미계약상품
			type = "N";
	   }else if(contract_no =="PC"){					// 추천상품
			type = "R";
	   }else if(product_close_flag == "Y"){			// 기등록상품(단종)
			type = "G";
	   }else{
			type = "";
	   }
             query = st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + type + "&&";
     }else{
     	var order_qty    = document.forms.contentForm.st_order_qty[y_num].value;
        var st_item_no   = document.forms.contentForm.st_item_no[y_num].value;
		var st_order_qty = document.forms.contentForm.st_order_qty[y_num].value;
		var st_agent     = document.forms.contentForm.st_agent_code[y_num].value;
		var contract_no  = document.forms.contentForm.st_contract_no[y_num].value;
		var contract_seq = document.forms.contentForm.st_contract_seq[y_num].value;
		var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[y_num].value;
		var product_close_flag = document.forms.contentForm.st_product_close_flag[y_num].value;
        if((contract_no != null && contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
        	//기등록건은 견적의뢰가 불가능 합니다.
            alert( " <%=CommonLang.msg("MSG500") %> ");
            return;
        }
        if(!kepChkDecimal(order_qty,3)){
        	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
            alert( i+" <%=CommonLang.msg("MSG20") %>    ");
            document.forms.contentForm.st_order_qty[i].focus();
            return;
        }
        if(contract_no == null || contract_no ==""){	// 미계약상품
			type = "N";
		}else if(contract_no =="PC"){					// 추천상품
			type = "R";
		}else if(product_close_flag == "Y"){			// 기등록상품(단종)
			type = "G";
		}else{
			type = "";
		}
        query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + type;
        query += "&&";
     }
    $("#confirm1").val("save");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
    kep_showRqdtGplConfirm();
}

function kep_showRqdtGplConfirm(){
	
    $('body,html').animate({
		scrollTop: 0
	}, 100);

	$("#confirmMyGroupMsg").text("<%=CommonLang.msg("MSG498") %>");	//견적 임시 저장하시고 신규견적 임시저장 조회 화면으로 이동하시겠습니까?
	$("#confirmMyGroupArea").show();
}

function runRqdtGplProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	
	document.forms.locationForm2.st_query.value = query;
	kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationGpl.do","locationForm2",gubun); 
}

/*
 * 나의상품등록 R
 * 장바구니담기 C
 */
function saveProcess(flag, y_num){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";

     if(eval(tot_cnt) < 2){
         	var order_qty     = document.forms.contentForm.st_order_qty.value;
            var st_agent_flag = document.forms.contentForm.st_agent_flag.value;
       		var st_item_no   = document.forms.contentForm.st_item_no.value;
			var st_order_qty = document.forms.contentForm.st_order_qty.value;
			var st_agent     = document.forms.contentForm.st_agent_code.value;
			var contract_no  = document.forms.contentForm.st_contract_no.value;
			var contract_seq = document.forms.contentForm.st_contract_seq.value;
			var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
			//표준카탈로그 매핑 여부
			var st_stnd_flag = document.forms.contentForm.st_stnd_flag.value;
			//단종여부 
			var st_product_close_flag = document.forms.contentForm.st_product_close_flag.value;
             var key_flag      = st_agent_flag.substr(0,2); 
             if(st_agent_flag == "MULTI_AGENT"){
                 var st_key_flag = "Y";
             }else{
                 var st_key_flag = "N";
             }
             if(contract_no == null || contract_no ==""|| contract_no =="PC"){
             	//계약정보 없는 품목은 등록이 불가능 합니다.
             	alert( " <%=CommonLang.msg("MSG344") %> ");
             	return;
             }
             //단종이고 단종일때 단가 비노출이면 처리 불가능.
             if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
             	//해당 품목은 단종되었습니다.
             	alert( "<%=CommonLang.msg("MSG117") %>");
             	return;
             }
             if(!kepChkDecimal(order_qty,3)){
             	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
                 alert( " <%=CommonLang.msg("MSG18") %>    ");
                 document.forms.contentForm.st_order_qty.focus();
                 return;
             } else if(st_key_flag == "Y"){
             	//상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.
                 alert( " <%=CommonLang.msg("MSG19") %>     ");
                 box.checked = false;
                 return;
             }else{
				query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
			}
     }else{
            var order_qty     = document.forms.contentForm.st_order_qty[y_num].value;
            var st_agent_flag = document.forms.contentForm.st_agent_flag[y_num].value;
			var st_item_no   = document.forms.contentForm.st_item_no[y_num].value;
			var st_order_qty = document.forms.contentForm.st_order_qty[y_num].value;
			var st_agent     = document.forms.contentForm.st_agent_code[y_num].value;
			var contract_no  = document.forms.contentForm.st_contract_no[y_num].value;
			var contract_seq = document.forms.contentForm.st_contract_seq[y_num].value;
			var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[y_num].value;
			//표준카탈로그 매핑 여부
			var st_stnd_flag = document.forms.contentForm.st_stnd_flag[y_num].value;
			//단종여부 
			var st_product_close_flag = document.forms.contentForm.st_product_close_flag[y_num].value;
            if(contract_no == null || contract_no ==""|| contract_no =="PC"){
               	//계약정보 없는 품목은 등록이 불가능 합니다.
               	alert( " <%=CommonLang.msg("MSG344") %> ");
	        	return;
            }
            //단종이고 단종일때 단가 비노출이면 처리 불가능.
            if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
            	//해당 품목은 단종되었습니다.
            	alert( "<%=CommonLang.msg("MSG117") %>");
            	return;
            }
            var key_flag      = st_agent_flag.substr(0,2); 
            if(st_agent_flag == "MULTI_AGENT"){
            	var st_key_flag = "Y";
             }else{
                 var st_key_flag = "N";
             }
             if(!kepChkDecimal(order_qty,3)){
             	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
                 alert( i+" <%=CommonLang.msg("MSG20") %>    ");
                 document.forms.contentForm.st_order_qty[i].focus();
                 return;
             } else if(st_key_flag == "Y"){
             	//상품구분이 필요한 항목입니다.   \n\n 품목코드를 클릭해서 제품 상세보기에서 선택해 주시기 바랍니다.
                 alert( " <%=CommonLang.msg("MSG19") %>     ");
                 box.checked = false;
                 return;
             }else {
		  		query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		  		query += "&&";
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
    	msg = "<%=CommonLang.msg("MSG557")%>";	//장바구니
    	$("#confirmCartMsg").text(msg);
    	$("#confirmCartArea").show();
    }else{
    	msg = "<%=CommonLang.get("HTITLE593")%>";	//나의상품
    	$("#confirmMyGroupMsg").text(msg+" <%=CommonLang.msg("MSG348") %>\n"+msg+"<%=CommonLang.msg("MSG349") %>");	//으로 저장하시고	보기 화면으로 이동하시겠습니까?
    	$("#confirmMyGroupArea").show();
    }

    $('body,html').animate({
		scrollTop: 0
	}, 100);
	
	
	
	 //runProcess(runFlag,query,flag);
}

// 계속검색
function kep_confrim_search(){
	var runFlag = $("#confirm1").val();
	$("#confirm4").val("search");
	$("#confirmCartArea").hide();
	$("#confirmMyGroupArea").hide();
	if(runFlag == "CsaveProcess" || runFlag == "RsaveProcess"){
		runProcess();
	}else{
		runRqdtGplProcess();
	}
}

// 이동
function kep_confirm_location(){ 
	var runFlag = $("#confirm1").val();
	$("#confirm4").val("location");
	$("#confirmCartArea").hide();
	$("#confirmMyGroupArea").hide();
	if(runFlag == "CsaveProcess" || runFlag == "RsaveProcess"){
		runProcess();
	}else{
		runRqdtGplProcess();
	}
}

// 취소
function kep_confirm_cancel(){ 
	$("#confirm4").val("");	
	$("#confirmMyGroupArea").hide(); 
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
	document.forms.searchDiForm.st_tmp_categ_text.value = "<%=tmp_categ_text%>";
	document.forms.searchDiForm.st_image_status.value = document.forms.searchForm.st_image_status.value; 	
	document.forms.searchDiForm.onepagerow.value = document.forms.searchForm.onepagerow.value; 	 
	document.forms.searchDiForm.curPage.value = curPage; 
	
	if ( document.forms.searchForm.st_result_keyword.value == ""){
		document.searchDiForm.st_research_flag.value = "N";
	}else{
		document.forms.searchDiForm.resultKeyword.value = document.forms.searchForm.st_result_keyword.value;
		document.searchDiForm.st_research_flag.value = "Y";
	}
	
	if ( document.forms.searchForm.st_no_contract_hidden_flag.value == "Y" ){
		document.searchDiForm.st_no_contract_hidden_flag.value = "Y";
	}else if( document.forms.searchForm.st_no_contract_hidden_flag.value == "N" ){
		document.searchDiForm.st_no_contract_hidden_flag.value = "N";
	}
	
	$('#searchDiForm').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsDiLisList.do").submit();   
}
//결과내재검색.
function resultKepSearch(curPage){
	if ( document.forms.searchForm.st_result_keyword.value == ""){
		alert("<%=CommonLang.msg("MSG433")%>");	//검색어를 입력하세요.
		document.searchForm.st_result_keyword.focus();
		return;
	}	
	document.forms.searchDiForm.onepagerow.value = document.forms.searchForm.onepagerow.value; 	 
	document.forms.searchDiForm.resultKeyword.value = document.forms.searchForm.st_result_keyword.value;
	document.forms.searchDiForm.curPage.value = curPage; 
	document.searchDiForm.st_research_flag.value = "Y";
	$('#searchDiForm').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsDiLisList.do").submit();
	
}
function searchEnter(){
	resultKepSearch("1");
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
	var st_my_groups =$("#st_my_groups").val();
	//나의상품저장시 분류 저장
	if (gubun == "RsaveProcess"){ // 나의상품
		document.forms.processForm.st_pf_my_group.value = st_my_groups;	
	}else{
		document.forms.processForm.st_pf_my_group.value = "";
	}  		 
	
	document.forms.processForm.st_use_flag.value = flag; 
	document.forms.processForm.st_query2.value = query;
	document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
	
	
	
	
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
        	//장바구니에 저장되었습니다.
          // alert("<%=CommonLang.msg("MSG22") %>   ");
           
           if (confirm4 == "search"){ 
         	  // 계속검색클릭 
            	 // 처리후 재조회
            	 kepSearch($("#curPage").val());
           }else{     
        	   
        	    
           $('#locationForm2').attr("action", "<%=h_sslurl%><%=p060000036%>").submit();    
        	
        	
           }
        	
       }else if(pMethod == "save")
       {
       	//저장 되었습니다.
          alert(" <%=CommonLang.msg("MSG31") %>  ");
          
          if (confirm4 == "search"){ 
        	  // 계속검색클릭 
           	 // 처리후 재조회
           	 kepSearch($("#curPage").val());           	   
          }else{     
       	   
       	    
          $('#locationForm2').attr("action", "<%=h_sslurl%>/mprq/getBuyerMpRqRequestQuotationTempList.do").submit();    
       	
       	
          }
       	}else {
    	   //나의상품으로 등록 되었습니다.
          alert("<%=CommonLang.msg("MSG23") %>   ");
          
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
        	 //품목코드 () 은 이미 장바구니에 저장된 항목입니다.
            alert("<%=CommonLang.msg("MSG352") %>" + sMsg + "<%=CommonLang.msg("MSG353") %>  ");
          }else if (pMethod == "save"){ 
      		//견적 임시 저장 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
     		 alert("<%=CommonLang.msg("MSG499") %>  "); 
     	  } else {
        	  //품목코드 () 은 이미 나의 상품으로 저장된 항목입니다.
            alert("<%=CommonLang.msg("MSG352") %>" + sMsg + "<%=CommonLang.msg("MSG25") %>  ");
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
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 alert("<%=CommonLang.msg("MSG26") %>  "); 
	}else if (pMethod == "RsaveProcess"){ 
		//나의상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 alert("<%=CommonLang.msg("MSG27") %>  "); 
	}else if (pMethod == "save"){ 
		//견적 임시 저장 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
		 alert("<%=CommonLang.msg("MSG499") %>  "); 
	}  
	 
	
} 
 
//상품 큰이미지
function getBigImage(file_dir, file_name){	
	getBigImageReSizeView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
//품목 합계값
function getPriceUpdate(order_qty, y_num, unit_price){
    var tot_cnt  = $("#display_item_cnt").val();
    var st_sum_price = "";
    var st_order_qty = "";
    if(eval(tot_cnt) < 2){
      	 st_order_qty = document.forms.contentForm.st_order_qty.value;
      	 if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
      			//품목의 주문수량(숫자)을 입력하여 주십시요.
      		 alert("<%=CommonLang.msg("MSG120") %>  ");
      		 document.forms.contentForm.st_order_qty.value = "1";
      		 document.forms.contentForm.st_order_qty.focus();
      		 document.forms.contentForm.st_sum_price.value = kepCommaNum(unit_price);
      	 }else{
               st_sum_price = kepGetRound((order_qty * unit_price),3);
               document.forms.contentForm.st_sum_price.value = kepCommaNum(st_sum_price);
      	 }
    }else{
     	 st_order_qty = document.forms.contentForm.st_order_qty[y_num].value;
      	 if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
      			//품목의 주문수량(숫자)을 입력하여 주십시요.
      		 alert("<%=CommonLang.msg("MSG120") %>  ");
      		 document.forms.contentForm.st_order_qty[y_num].value = "1";
      		 document.forms.contentForm.st_order_qty[y_num].focus();
      		 document.forms.contentForm.st_sum_price[y_num].value = kepCommaNum(unit_price);
      	 }else{
               st_sum_price = kepGetRound((order_qty * unit_price),3);
               document.forms.contentForm.st_sum_price[y_num].value = kepCommaNum(st_sum_price);
      	 }
    }
}

//주문수량 기능 g_gbn P: 주문수량 1 플러스/ M: 주문수량 1마이너스, pur_unit_qty : 주문배수
function getOrderQty(order_qty, y_num, unit_price, g_gbn, pur_unit_qty){
	var tot_cnt  = $("#display_item_cnt").val();
	var st_order_qty = ""; //주문수량
	var st_tobe_order = "";//변경후 주문수량
	var st_sum_price = "";//합계 금액
	if(eval(tot_cnt) < 2){
		st_order_qty = document.forms.contentForm.st_order_qty.value;
		if(g_gbn == "P"){
			st_tobe_order = parseInt(st_order_qty) + parseInt(pur_unit_qty);
		}else if(g_gbn == "M"){
			st_tobe_order = parseInt(st_order_qty) - parseInt(pur_unit_qty);
			if(st_tobe_order < 1){
      			//품목의 주문수량(숫자)을 입력하여 주십시요.
	      		 alert("<%=CommonLang.msg("MSG120") %>  ");
	      		return;
			}
		}
		document.forms.contentForm.st_order_qty.value =st_tobe_order;
		st_sum_price = kepGetRound((st_tobe_order * unit_price),3);
        document.forms.contentForm.st_sum_price.value = kepCommaNum(st_sum_price);
	}else{
		st_order_qty = document.forms.contentForm.st_order_qty[y_num].value;
		if(g_gbn == "P"){
			st_tobe_order = parseInt(st_order_qty) + parseInt(pur_unit_qty);
		}else if(g_gbn == "M"){
			st_tobe_order = parseInt(st_order_qty) - parseInt(pur_unit_qty);
			if(st_tobe_order < 1){
      			//품목의 주문수량(숫자)을 입력하여 주십시요.
	      		 alert("<%=CommonLang.msg("MSG120") %>  ");
	      		 return;
			}
		}
		document.forms.contentForm.st_order_qty[y_num].value =st_tobe_order;
		st_sum_price = kepGetRound((st_tobe_order * unit_price),3);
        document.forms.contentForm.st_sum_price[y_num].value = kepCommaNum(st_sum_price);
	}
	
}
</script>
</html>
