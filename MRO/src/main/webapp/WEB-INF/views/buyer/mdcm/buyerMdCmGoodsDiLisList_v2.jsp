<%--
**********************************************
* 메뉴 : 검색엔진을 이용한 조회
* 화면 : 상품목록
* 기능 : 카테고리에서 최하단의 카테고리를 선택한 후 보여지는 상품목록. 장바구니에 담을 수 있다.
* 프로그램 ID : BU0201002
* 담당자 : 최찬규
* 착수일 : 2026-01-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"  %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt =CommonUtil.nvl((String)request.getAttribute("totalCnt"),"0"); // 조회된 결과
	String searchKeyWord =CommonUtil.nvl((String)request.getAttribute("searchKeyWord"),""); // 조회된 결과
	String searchResultKeyword =CommonUtil.nvl((String)request.getAttribute("searchResultKeyword"),""); // 결과내 재검색 키워드
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"30"));  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String pageString = "30,50,100,200,500,1000";
	if(!Arrays.asList(pageString.split(",")).contains(onepagerow)){
		onepagerow = "30";
	}
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_CATEGORY = (List<Map<String,String>>) request.getAttribute("data_CATEGORY"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _data_MAKER = (List<Map<String,String>>) request.getAttribute("data_MAKER"); // 조회된 결과
	
	String searchTargetIDX_CATEGORY_NO = CommonUtil.nvl((String)request.getAttribute("searchTargetIDX_CATEGORY_NO"),""); //조회된결과
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
	String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"");
	String st_list_type = CommonUtil.nvl((String) request.getParameter("st_list_type"),"list");
	
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
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"IMAGE_VIEW");   
	String img_view_flag   = "";
	String agent_open_flag = "";
	String session_lang = "";
	String st_no_contract_hidden_flag = CommonUtil.nvl((String) request.getParameter("st_no_contract_hidden_flag"),"N");
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag());
		agent_open_flag =  CommonUtil.nvl((String)sessionInfo.getAgentOpenFlag());
		session_lang = CommonUtil.nvl((String)sessionInfo.getLang());
	}  
	 if(image_status.equals("")){ 
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	 
	 //관심상품 분류 리스트
	List<Map<String,String>> myItemList =  CommonUtil.getCode3List(_sessionInfo.getComCode(), "SEL", "ITEM",_sessionInfo.getUserId(), "ICOMCOD3_v2", "", "");
	 
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
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
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
<%-- <%@ include file="/WEB-INF/views/common/include/buyerHeader_v2.jsp" %>    --%>
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>
<div id="container2">
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
<%
//검색결과가 없을 경우.
if (list == false){
%>
<div class="containerBox"   >
	<div class="container"  >
      <div class="NodataMessage mt100">
        <img src="/resources/imgs/Icon_Warning01.png" />
        <div class="MessageTit mt10"><%=CommonLang.msg("MSG649")%><!--일치하는 품목이 없습니다.--></div>
        <div class="MessageMiddle mt10"><%=CommonLang.msg("MSG650")%><!--원하시는 품목이 없는 경우 신규견적 의뢰해보세요.--></div>
        <div class="MessageLine mt40"></div>
        <div class="MessageSmall mt25">
          ·&nbsp; <%=CommonLang.msg("MSG651")%><!--단어 사이의 띄어쓰기를 해보시거나 일반적인 검색어로 다시 검색해 보세요.--><br />
          ·&nbsp; <%=CommonLang.msg("MSG652")%><!--카테고리를 선택하시거나 제조사 등을 입력하시면 보다 정확한 검색이 가능합니다.--><br />
          ·&nbsp; <%=CommonLang.msg("MSG653")%><!--한글을 영어로 혹은 영어를 한글로 입력했는지 확인해보세요.-->
        </div>
        <button class="ButOutline_large mt40 mb100" onclick="location.href='/mprq/showBuyerMpRqRequestQuotation_v2.do?menuId=br00101000000&tabIndex=1'; return false; " ><%=CommonLang.get("HTITLE1098")%><!--신규견적 의뢰--></button>
      </div>
    </div><!--/container -->
    
</div>
<%
}else{
%>
<div class="containerBox">
	<form name = "searchForm" id="searchForm" method = "post">
	<input type="text" name="st_result_keyword2"  id="st_result_keyword2" style="display:none" />
	<div class="SearchResultBoxTit"><span><%=searchKeyWord%></span><%=CommonLang.get("HTITLE1036") %><!-- 에 대한 검색결과 -->
      <div class="ResultSearchForm">
        <input type="text" placeholder="<%=CommonLang.get("HTITLE1037") %>" id="st_result_keyword" name="st_result_keyword" value="<%=searchResultKeyword%>" onKeyDown="if(event.keyCode==13){event.stopPropagation(); searchEnter(event)};" style="vertical-align: top;"><!-- 결과 내 재검색 -->
        <button type="button" onclick="javascript:resultKepSearch('1'); return false;"><img src="/resources/imgs/Icon_ResultSearch.png" /></button>
      </div>
    </div>
        <!-- 검색 카테고리-->
        <div class="SearchResult1280">
      	<!-- 카테고리 -->
      		<div class="SearchResultSection01">
		        <div class="title"><%=CommonLang.get("HTITLE510") %> <!-- 카테고리 --></div>
		        <div class="SearchList">
		        		<% 
						for (int j=0; j<_data_CATEGORY.size(); j++) {
							Map<String,String> rowData = _data_CATEGORY.get(j);
						%>
						<label class="CheckLargeLabel"><input type="checkbox" name="categCheck" id="<%=CommonUtil.nvl(rowData.get("groupId")).replaceAll("[()]","")%>" value="<%=CommonUtil.nvl(rowData.get("groupId"))%>"><span class="CheckLargeCustom"></span><span style="width:150px; display: inline-block; white-space: nowrap; overflow: hidden; text-overflow:ellipsis;" title="<%=CommonUtil.nvl(rowData.get("groupId"))%> (<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)"><%=CommonUtil.nvl(rowData.get("groupId"))%> (<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</span></label> 
							<%if(j%5==4){%>
							<br/>
					    	<%} %>
					    <%} %>			
		        </div>
		    </div>   
		 </div>
    
        <div class="searchWrap" id="searchWrap" >
      		<div class="SearchResult1280">
		        <!-- 제조사 -->
		        <div class="SearchResultSection02">
		          <div class="title"><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></div>
		        <div class="SearchListScroll"  >
		          <div class="SearchList">
		          <% for (int j=0; j<_data_MAKER.size(); j++) {
							Map<String,String> rowData = _data_MAKER.get(j);
				  %>										
							<label class="CheckLargeLabel"><input type="checkbox" name="makerCheck" id="<%=CommonUtil.nvl(rowData.get("groupId")).replaceAll("[()]","")%>" value="<%=CommonUtil.nvl(rowData.get("groupId"))%>"><span class="CheckLargeCustom"></span><span style="width:150px; display: inline-block; white-space: nowrap; overflow: hidden; text-overflow:ellipsis;" title="<%=CommonUtil.nvl(rowData.get("groupId"))%> (<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)"><%=CommonUtil.nvl(rowData.get("groupId"))%> (<%=CommonUtil.nvl(rowData.get("groupIntValue"))%>)</span></label>
						<%if(j%5==4){%>
							<br/>
					    	<%} %>
						
						<%}%>
		          </div>
		          </div>
		        </div>      
			</div> 
		</div>
		<div class="SearchResultBtnBox">
      <div class="SearchResultBtnBox1280">
        <div class="Center"> <button class="ButM_Outline" onclick="javascript:top_kepReload('<%=_data_CATEGORY.size() %>','<%=_data_MAKER.size()%>'); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> <button class="ButMDarkGray" onclick="javascript:top_kepSearch('<%=_data_CATEGORY.size() %>','<%=_data_MAKER.size()%>'); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button></div>         
        <div class="Right"><button class="RoundButton_LeftIcon40_00" id="detailBtn" onclick="return false;"><img id="iconArrow" src="/resources/imgs/arrow_top_Btn40_02.png" /> <span id="btnText"><%=CommonLang.get("HTITLE276") %><!-- 상세조회 --></span></button> </div> 
      </div> 
    </div>         
	<script>
      const detailBtn = document.getElementById('detailBtn');
      const searchWrap = document.getElementById('searchWrap');
      const btnText = document.getElementById('btnText');
      const iconArrow = document.getElementById('iconArrow');
    
      let isCollapsed = false; // 처음 접힌 상태
    
      detailBtn.addEventListener('click', function(){
        isCollapsed = !isCollapsed;
        searchWrap.classList.toggle('collapsed', isCollapsed);
    
        if (isCollapsed) {
          btnText.textContent = '<%=CommonLang.get("HTITLE276")%>';
          iconArrow.classList.add('rotate');
        } else {
          btnText.textContent = '<%=CommonLang.get("HTITLE276")%>';
          iconArrow.classList.remove('rotate');
        }
      });
    </script>
	<!--조회영역 리스트정렬-->
    <div class="container"  >
    	<div class="SearchResultTitSum mt50 pb20">
        		<%=CommonLang.get("HTITLE921") %><!-- 총 --> <%=total_cnt %><%=CommonLang.get("HTITLE595") %><!-- 건 -->
        	<div class="buttonRight">
	         <button class="ButM_Outline" onclick="javascript:doAction('checkMyItem',''); return false;"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
	         <button class="ButMPrimary" onclick="javascript:doAction('checkCartItem',''); return false;"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
        	</div>
      	</div>
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
		<input type="hidden" name="st_sort_gubun" id="st_sort_gubun" value="<%=st_sort_gubun %>"> 
 		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">  
		<input type="hidden" name="maker_name" id="maker_name" value="<%=maker_name %>">		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">
		
		<input type="hidden" name="st_list_type" id="st_list_type" value="<%=st_list_type %>">
            <!--상품정렬-->
            <div class="Array">
		      <div class="buttonLeft">
		          <ul id="sortList">
		        	<a href="javascript:searchSort('BUYER_ITEM_NO');"><li id="BUYER_ITEM_NO"><%=CommonLang.get("HTITLE1018") %><!-- 품목코드순 --></li></a>
		            <a href="javascript:searchSort('DESCRIPTION');"><li id="DESCRIPTION"><%=CommonLang.get("HTITLE1019") %><!-- 품목명순 --></li></a>
		            <a href="javascript:searchSort('SPECIFICATION');"><li id="SPECIFICATION"><%=CommonLang.get("HTITLE1020") %><!-- 규격순 --></li></a>
		            <a href="javascript:searchSort('MAKER_NAME');"><li id="MAKER_NAME"><%=CommonLang.get("HTITLE1021") %><!-- 제조사순 --></li></a>
		            <a href="javascript:searchSort('TARGET_PRICE');"><li id="TARGET_PRICE"><%=CommonLang.get("HTITLE1022") %><!-- 품목가격순 --></li></a>
		          </ul>
		       </div>
		       <div class="buttonRight">
		       	<%
					if(p060000066==true) {
				%>
				   	<select class="SelectEach" name="st_no_contract_hidden_flag" id="st_no_contract_hidden_flag" onchange="javascript:kepSearch(1);" style="width: 130px;">
				   		<option value = "N" <%if ("N".equals(st_no_contract_hidden_flag)) {%>selected<%} %>><%=CommonLang.get("HTITLE1023")%><!-- 미계약 포함 --></option>
				   		<option value = "Y" <%if ("Y".equals(st_no_contract_hidden_flag)) {%>selected<%} %>><%=CommonLang.get("HTITLE1024")%><!-- 미계약 제외 --></option>
				   	</select>
				<%
					} else { %>
						<input type="hidden" name="st_no_contract_hidden_flag" id="st_no_contract_hidden_flag" value="">
				<% 	} %>
<!-- 		          <p class="ImgHidden"><label class="CheckLargeLabel"><input type="checkbox" name="image_status_check" id="image_status_check" onclick="javascript:imageHideView();"><span class="CheckLargeCustom"></span></label> 이미지 숨김</p> -->
		          <select class="SelectEach" name="onepagerow" onchange="javascript:kepSearch(1);">
		            <option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
		            <option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
		            <option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
		            <option value = "200" <%if ("200".equals(onepagerow)) {%>selected<%} %>>200<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
		            <option value = "500" <%if ("500".equals(onepagerow)) {%>selected<%} %>>500<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
		            <option value = "1000" <%if ("1000".equals(onepagerow)) {%>selected<%} %>>1000<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
		          </select>
		          <button id="listButton" class="ButListArray_on" onclick="javascript:listTypeChange('list'); return false;"><%=CommonLang.get("HTITLE1025") %><!-- 목록형 --></button>
		          <button id="imageButton" class="ButListImg_off" onclick="javascript:listTypeChange('image'); return false;"><%=CommonLang.get("HTITLE1026") %><!-- 이미지형 --></button> 
		       </div>
			 </div>
		</form>
	<form name = "contentForm" id="contentForm" method = "post">
	<!--목록형-->
      <table  class="PDList" id="PDListType">
        <colgroup>
          <col width="45px" />
          <col width="135px" />
          <col width="515px" />
          <col width="165px" />
          <col width="150px" />
          <col width="180px" />
          <col width="100px" />
        </colgroup>
        <%
	for (int j=0; j<_gridList.size(); j++) {
		Map<String,String> rowData = _gridList.get(j);
%>
		<input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
        <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>">
        <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
        <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
        <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
        <input type="hidden" name="st_stnd_flag"  value="<%=CommonUtil.nvl(rowData.get("STND_FLAG"))%>">
        <input type="hidden" name="st_product_close_flag"  value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
        <input type="hidden" name="st_over_short_flag"  value="<%=CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG"))%>">
                   
      	<tr>
		  <td><label class="CheckLargeLabel" for="lnCheck<%=j%>"><input type="checkbox" id="lnCheck<%=j%>" name="lnCheck<%=j%>"><span class="CheckLargeCustom"></span></label></td>
		  <td class="PDimgNo" name="PDimgNo" style="display: none; width:112px; height:112px;" ></td>
		  <td name="PDimg">
		  <a class="PDimg" href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>');" >
		  	<%     
						if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
					%>
					          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""){ %>
					          		<div class="OpacityBox"><%=CommonLang.get("HTITLE816") %><!-- 미계약품목 --></div>
					          <%}else{
					        	    if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){
					          %> 
					          			<div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
					          <%	}
					          %>
					          <%
					        	    if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){
					          %> 
					          			<div class="OpacityBox"><%=CommonLang.get("HTITLE394") %><!-- 단종 --></div>
					          <%	}
					          }
					          %>
					          
					          <%
					          	//녹색구매제품
					          	if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){
					          %>
					          	<p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p>
					          <%} %>
					          <img src="/resources/imgs/noimage.gif">
						     <%}else{ %> 
					             
					          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""){ %>
					          			<div class="OpacityBox"><%=CommonLang.get("HTITLE816") %><!-- 미계약품목 --></div>
					          <%}else{
					        	    if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){
					          %> 
					          			<div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
					          <%	}
					          %>
					          <%
					        	    if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){
					          %> 
					          			<div class="OpacityBox"><%=CommonLang.get("HTITLE394") %><!-- 단종 --></div>
					          <%	}
					         	 }%>
					         	 
					         	  <%
						          	//녹색구매제품
						          	if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){
						          %>
						          	<p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p>
						          <%} %>
						          
					         	 <img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"  name="image1">
					         <%}%>
					         </a>
		  </td>
          <td >
          <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) =="" || CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC")){ %>   
		  	<div class="PDTit"><span><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></span> <%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%></div>
            <table class="PDAttribute">
              <colgroup><col width="50px" /><col width="*" /></colgroup>              
              <tr><th><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th><td><p class="Attribute"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></p></td></tr>
              <tr><th><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th><td><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td></tr>
              <tr><th><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th><td><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td></tr>
            </table>
		  <%}else{ %>
          	<a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>');" >
          	<%
				//사용자 언어타입이 영어일 영문 품명, 규격 표기
				if(session_lang.equals("EN")) {
			%>
				<div class="PDTit"><span><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></span> <%=CommonUtil.nvl(rowData.get("DESCRIPTION_ENG"))%></div>
            <table class="PDAttribute">
              <colgroup><col width="50px" /><col width="*" /></colgroup>              
              <tr><th><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th><td><p class="Attribute"><%=CommonUtil.nvl(rowData.get("SPECIFICATION_ENG"))%></p></td></tr>
            </table>
			<%}else{ %>
			<div class="PDTit"><span><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></span> <%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%></div>
            <table class="PDAttribute">
              <colgroup><col width="50px" /><col width="*" /></colgroup>              
              <tr><th><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th><td><p class="Attribute"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></p></td></tr>
			<%} %> 
              <tr><th><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th><td><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td></tr>
              <tr><th><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th><td><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td></tr>
            </table>
          <%} %>
          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) =="" || CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC")){ %>   
		  
		  <%}else{ %>
          	</a>
          <%} %>
          </td>
	          	<input type="hidden" name="st_min_order_qty" id="st_min_order_qty" value="<%=rowData.get("MIN_ORDER_QTY")%>">
				<input type="hidden" name="st_pur_unit_qty" id="st_pur_unit_qty" value="<%=rowData.get("PUR_UNIT_QTY")%>">
          <%
            //단종일 경우 단가 표기 안함.
			if(g_product_close_flag.equals("Y")&&CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){%>
	          	<input type="hidden" name="st_order_qty" id="st_order_qty" size="4" value="1">
	          	<td colspan="3"  >
            		<div class="ListReq" >
              			<img src="/resources/imgs/Icon_Warning01.png" />
              			<p class="txt"><%=CommonLang.msg("MSG692")%><!-- 미등록품목은 견적의뢰를 통해 품목 등록 후, 구매가 가능합니다. --></p>
            		</div>
          		</td>
          <%}else{ %>
				<!--단종상품도 견적의뢰만 가능 -> 사업팀 협의 시 추후 변경될 수 있음 -->
          		<%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""||CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC") || CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){ %>
	          		<input type="hidden" name="st_order_qty" id="st_order_qty" size="4" value="1">
					<td colspan="3"  >
	            		<div class="ListReq" >
	              			<img src="/resources/imgs/Icon_Warning01.png" />
	              			<p class="txt"><%=CommonLang.msg("MSG692")%><!-- 미등록품목은 견적의뢰를 통해 품목 등록 후, 구매가 가능합니다. --></p>
	            		</div>
	          		</td>
          		<%}else{ %>
          		<td>
          			<p class="PDPrice"><a href="javascript:getBuyerPriceHistoryPop('<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>');"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE_2"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></a></p>
          		</td>
		          <td>
		            <div class="PDOrderNum">
					  <div class="NumInput">
						<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
						<input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>'); return false;}">
						<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
					  </div><br/>
					  <p class="NumTxt"> <%=CommonLang.get("HTITLE1028") %><!-- 최소주문 --> <span><%=rowData.get("MIN_ORDER_QTY")%></span></p> 
					  <p class="NumTxt"> <%=CommonLang.get("HTITLE1029") %><!-- 주문배수 --> <span><%=rowData.get("PUR_UNIT_QTY")%></span></p>
					  <input type="hidden"  name="st_sum_price" id="st_sum_price"  value="<%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("TARGET_PRICE_2"))),true,0,3) %>"  readonly> 
					</div>             
		          </td>
		          <td><div class="TotalPric"><span name="st_sum_price" id="st_sum_price_text<%=j%>"><%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("TARGET_PRICE_2"))),true,0,3) %></span><%=CommonLang.get("HTITLE660") %><!-- 원 --></div></td>
          		<%} %>
          <%} %>
          			<td>
          				<%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""||CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC") || CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){ %>
          					<%if ( p060000094 == true ) {%>
			               		<%if(p060000102==false) {%>
			          				<button onclick="javascript:doAction('reqItem','<%=j%>'); return false;" class="Btn_Estimate"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>    
			          			<%} %>
			          		<%}else{ %>
				        		<%if(p060000102==false) {%>
				        			<button onclick="javascript:doAction('reqGplItem','<%=j%>'); return false;" class="Btn_Estimate"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>     
				        		<%} %>
			        		<%} %>
          				<%}else{ %>
		              		<button onclick="javascript:doAction('cartItem','<%=j%>'); return false;" class="Cart"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
          					<%if ( p060000094 == true ) {%>
          						<%if(p060000102==false) {%>
			          				<button onclick="javascript:doAction('reqItem','<%=j%>'); return false;" class="ListReq_s"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>    
			          			<%} %>
          					<%}else{ %>
          						<%if(p060000102==false) {%>
			          				<button onclick="javascript:doAction('reqGplItem','<%=j%>'); return false;" class="ListReq_s"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>    
			          			<%} %>
			          		<%} %>
          					<%if(rowData.get("MY_ITEM_YN").equals("Y")) {%>
			        			<button onclick="javascript:doAction('myItem','<%=j%>'); return false;" class="Favorit_on"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
			        		<%}else{ %>
			        			<button onclick="javascript:doAction('myItem','<%=j%>'); return false;" class="Favorit"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
			        		<%} %>
          				<%} %>
	          		</td>
        </tr>
     	<%} %>
      </table>
      </form>
      
      <form name = "contentForm2" id="contentForm2" method = "post">
      <!-- 이미지형 -->
      <table  class="PDListImg" id="PDImageType" style="display: none;">
        <colgroup>
            <col width="256px" />
            <col width="256px" />
            <col width="256px" />
            <col width="256px" />
            <col width="256px" /> 
        </colgroup>
        <%
	for (int j=0; j<_gridList.size(); j++) {
		Map<String,String> rowData = _gridList.get(j);
		if(j%5==0){
		%>
		<tr>
	  <%}%>
		<input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
        <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>">
        <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
        <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
        <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
        <input type="hidden" name="st_stnd_flag"  value="<%=CommonUtil.nvl(rowData.get("STND_FLAG"))%>">
        <input type="hidden" name="st_product_close_flag"  value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
        <input type="hidden" name="st_over_short_flag"  value="<%=CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG"))%>">
		  <td>
		  <a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEGORY_NO"))%>', '<%=CommonUtil.nvl(rowData.get("AGENT"))%>','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>');" >
		  <div class="img">
            <%     
						if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
					%>
					          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""){ %>
					          		<div class="EstimateBox"><%=CommonLang.msg("MSG693") %><!-- 미등록품목은 견적의뢰를 통해 --></br><%=CommonLang.msg("MSG694") %><!--  품목 등록 후, 구매가 가능합니다. --></div>
					          <%}else{
					        	    if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){
					          %> 
					          			<div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
					          <%	}
					          %>
					          <%
					        	    if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){
					          %> 
					          			<div class="EstimateBox"><%=CommonLang.msg("MSG693") %><!-- 미등록품목은 견적의뢰를 통해 --></br><%=CommonLang.msg("MSG694") %><!--  품목 등록 후, 구매가 가능합니다. --></div>
					          <%	}
					          }
					          %>
					          
					          <%
						          	//녹색구매제품
						          	if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){
						          %>
						          	<div class="BrList"><p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p></div>
						          <%} %>
					          <label class="CheckLargeLabel"><input type="checkbox" id="lnCheck<%=j%>" name="lnCheck<%=j%>"><span class="CheckLargeCustom"></span></label><img src="/resources/imgs/noimage.gif"></div>
					<%}else{ %> 
					             
					          <%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""){ %>
					          			<div class="EstimateBox"><%=CommonLang.msg("MSG693") %><!-- 미등록품목은 견적의뢰를 통해 --></br><%=CommonLang.msg("MSG694") %><!--  품목 등록 후, 구매가 가능합니다. --></div>
					          <%}else{
					        	    if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){
					          %> 
					          			<div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
					          <%	}
					          %>
					          <%
					        	    if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){
					          %> 
					          			<div class="EstimateBox"><%=CommonLang.msg("MSG693") %><!-- 미등록품목은 견적의뢰를 통해 --></br><%=CommonLang.msg("MSG694") %><!--  품목 등록 후, 구매가 가능합니다. --></div>
					          <%	}
					         	 }%>
					         	 
					         	 <%
						          	//녹색구매제품
						          	if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){
						          %>
						          	<div class="BrList"><p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p></div>
						          <%} %>
						          
					         	 <label class="CheckLargeLabel"><input type="checkbox" id="lnCheck<%=j%>" name="lnCheck<%=j%>"><span class="CheckLargeCustom"></span></label><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"  name="image1"></div>
					         <%}%>
            <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
            <div class="PDCode"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
            		<%if(rowData.get("MY_ITEM_YN").equals("Y")) {%>
		              <button onclick="javascript:doAction('myItem','<%=j%>'); return false;" class="Favorit_on"><%=CommonLang.get("HTITLE1031") %><!-- 즐겨찾기 --></button>
       				<%}else{ %>
				      <button onclick="javascript:doAction('myItem','<%=j%>'); return false;" class="Favorit"><%=CommonLang.get("HTITLE1031") %><!-- 즐겨찾기 --></button>       				
       				<%} %>
            </div>
            <div class="PDTit"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></div>
            </a>
            	<input type="hidden" name="st_min_order_qty" id="st_min_order_qty" value="<%=rowData.get("MIN_ORDER_QTY")%>">
				<input type="hidden" name="st_pur_unit_qty" id="st_pur_unit_qty" value="<%=rowData.get("PUR_UNIT_QTY")%>">
            <%if(g_product_close_flag.equals("Y")&&CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){%> 
            	<input type="hidden" name="st_order_qty" id="st_order_qty" size="4" value="1">
            	<input type="hidden"  name="st_sum_price" id="st_sum_price"  value=""  readonly>
            	<div class="PDPrice"><span></span></div>
            	<div class="Txt"><p><span></span></p><p><span></span></p></div>
            	<%if ( p060000094 == true ) {%>
           			<%if(p060000102==false) {%>
      					<div class="Estimate"><button class="Btn_Estimate" onclick="javascript:doAction('reqItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button></div>
      				<%} %>
      			<%}else{ %>
      				<%if(p060000102==false) {%>
      					<div class="Estimate"><button class="Btn_Estimate" onclick="javascript:doAction('reqGplItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button></div>     
      				<%} %>
      			<%} %>
		    <%}else{ %>
		    	<!-- 단종도 견적의뢰만 활성화 -> 사업팀 협의 후 변경 될 수 있음 -->
		    	<%if(CommonUtil.nvl(rowData.get("CONTRACT_NO")) == null || CommonUtil.nvl(rowData.get("CONTRACT_NO")) ==""||CommonUtil.nvl(rowData.get("CONTRACT_NO")).equals("PC") || CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){ %>
		    		<input type="hidden" name="st_order_qty" id="st_order_qty" size="4" value="1">
		    		<input type="hidden"  name="st_sum_price" id="st_sum_price"  value=""  readonly>
		    		<div class="PDPrice"><span></span></div>
	            	<div class="Txt"><p><span></span></p><p><span></span></p></div>
	            	<%if ( p060000094 == true ) {%>
	           			<%if(p060000102==false) {%>
	      					<div class="Estimate"><button class="Btn_Estimate" onclick="javascript:doAction('reqItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button></div>
	      				<%} %>
	      			<%}else{ %>
	      				<%if(p060000102==false) {%>
	      					<div class="Estimate"><button class="Btn_Estimate" onclick="javascript:doAction('reqGplItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button></div>     
	      				<%} %>
	      			<%} %>
			   <%}else{ %>
			   <div class="PDPrice"><span id="st_image_sum_price_text<%=j%>"><%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("TARGET_PRICE_2"))),true,0,3) %></span>원</div>
			   	<input type="hidden"  name="st_sum_price" id="st_sum_price"  value="<%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("TARGET_PRICE_2"))),true,0,3) %>"  readonly>
			   	<div class="Txt"><p><%=CommonLang.get("HTITLE1028") %><!-- 최소주문 --> <span><%=rowData.get("MIN_ORDER_QTY")%></span></p><p><%=CommonLang.get("HTITLE1029") %><!-- 주문배수 --> <span><%=rowData.get("PUR_UNIT_QTY")%></span></p></div>
			   	<%if ( p060000094 == true ) {%>
			   		<div class="NumInputSmall">
	              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
	              		<input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>'); return false;}">
	              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
            		</div>
	             	<button onclick="javascript:doAction('cartItem','<%=j%>'); return false;" class="But_Cart"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
	           			<%if(p060000102==false) {%>
	      					<button class="Btn_EstimateSmall" onclick="javascript:doAction('reqItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>
	      				<%} %>
	      				
	      		<%}else{ %>
	      			<div class="NumInputSmall">
	              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
	              		<input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>');return false;}">
	              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE_2")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
            		</div>
            		<button onclick="javascript:doAction('cartItem','<%=j%>'); return false;" class="But_Cart"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
            		<%if(p060000102==false) {%>
      					<button class="Btn_EstimateSmall" onclick="javascript:doAction('reqGplItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>
      				<%} %>
	      		<%} %>
			   	
			   <%} %>
		    <%} %>
            
          </td>
         <%if(j%5==4 || j==(_gridList.size()-1)){%>
		</tr>
	  	<%}%>
      <%} %>
      </table>
<%
}
%>


<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
	<!-- 버튼영역 -->
	<div class="ButtonBottom">
		<div class="buttonRight">
	<%if("Y".equals(misumi_open_flag)){%>
		<button class="ButM_Outline" onclick="javascript:doAction('misumiItem',''); return false;"><%=CommonLang.get("HTITLE822") %><!-- 미스미품목검색 --></button>			
	<%}%>
	<%if(list != false) {%>
		<button class="ButM_Outline" onclick="javascript:doAction('checkMyItem',''); return false;"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
        <button class="ButMPrimary" onclick="javascript:doAction('checkCartItem',''); return false;"><%=CommonLang.get("HTITLE11") %><!-- 장바구니 --></button>		
    <%} %>
        </div>
    </div>
    
	<!-- 페이징 -->
	<div class="Paging mt20">
<!--        <button class="ButPagLeft02"></button> -->
<!--        <button class="ButPagLeft01"></button> -->
	<%=CommonUtil.getPageSearchView("kepSearch",total_cnt, curPage ,onepagerow) %>
<!--        <p>1</p> -->
<!--        <p>2</p> -->
<!--        <p>3</p> -->
<!--        <p>4</p> -->
<!--        <p>5</p> -->
<!--        <button class="ButPagRight01"></button> -->
<!--        <button class="ButPagRight02"></button> -->
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
	<input type="hidden" name="st_sort_gubun" id="st_sort_gubun"  value="<%=st_sort_gubun%>" />
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
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
</div>
</body>
<div class="DIVLayerPopup-overlay" id="confirmCartAreaOverlay" style="display: none;" ></div>
 <div class="DIVLayerPopup" id="confirmCartArea" style="display: none;">
     <div class="wrapPopupAlert"  >
     <div class="AlertTxtSmall" id="confirmCartMsg">
     </div>
       <div class="h20"></div> 
       <div class="PopupListBtnBox_Center">
         <button class="ButPrimary_large" onclick="javascript:kep_confrim_search(); return false;"><%=CommonLang.get("HTITLE591") %><!-- 계속검색 --></button>
         <button class="ButPrimary_large" onclick="javascript:kep_confirm_location(); return false;"><%=CommonLang.get("HTITLE965") %><!-- 장바구니 이동 --></button>
       </div>  
     </div><!-- wrapPopup 끝-->  
 </div><!-- DIVpopup 끝-->
 <div class="DIVpopup-overlay popupOverlay" id="confirmMyGroupAreaOverlay" style="display: none;"></div>
<div class="DIVpopup" id="confirmMyGroupArea" style="display: none;">
  <div class="wrapPopupAlert">
    <div class="AlertTxtSmall">
    <span id="confirmMyGroupMsg" style="white-space: pre-line;"></span></br>
	  <div class="Search-select mt20" id="st_my_groups" style="width:310px; margin:0 auto">
	  <input type="hidden" id="st_my_groups_code"   value="">
        <div class="Search-box" ><span class="Selected-value"><%=CommonLang.get("HTITLE1065") %><!-- 기본 --></span></div>
        <ul class="Search-options"  style="width:310px">
          		<li data-value="MCDEFAULT"><%=CommonLang.get("HTITLE1065") %><!-- 기본 --></li>
          <%if(myItemList.size()<=0 || myItemList == null) {%>
	        <%}else{
 	        	for(int i = 0 ; i<myItemList.size(); i++){
 	        		if(myItemList.get(i).get("CODE2").equals("MCDEFAULT"))
 	        			continue;
 	        	%>
	        	<li data-value="<%=myItemList.get(i).get("CODE2")%>"><%=myItemList.get(i).get("TEXT1") %></li>
	        	<%} %>
	        <%} %> 
        </ul>
	  </div> 
      <script>
        const customSelect = document.getElementById("st_my_groups");
        const selectBox = customSelect.querySelector(".Search-box");
        const options = customSelect.querySelector(".Search-options");
        const selectedValue = customSelect.querySelector(".Selected-value");
        
        
        // 열기/닫기
        selectBox.addEventListener("click", function(){
          options.style.display = options.style.display === "block" ? "none" : "block";
          selectBox.classList.toggle("active");
        });
        
        
        // 옵션 선택
        customSelect.querySelectorAll("li").forEach(function(option){
          option.addEventListener("click", function() {
            selectedValue.textContent = option.textContent;
            options.style.display = "none";
            selectBox.classList.remove("active");
        
            $("#st_my_groups_code").val(option.dataset.value);
          });
        });
     	// 바깥 클릭 시 닫기
        document.addEventListener("click", function(e){
          if (!customSelect.contains(e.target)) {
            options.style.display = "none";
            selectBox.classList.remove("active");
          }
        });
      </script>         
    </div>
    <div class="h20"></div>
    <div class="PopupListBtnBox_Center">
      <button class="ButQuaternary_large" style=" width:100px" onclick="javascript:kep_confirm_cancel(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:kep_confirm_location(); return false;"><%=CommonLang.get("HTITLE592") %><!-- 이동 --></button>
         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:kep_confrim_search();return false;"><%=CommonLang.get("HTITLE591") %><!-- 계속검색 --></button>
    </div>
  </div>
</div>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

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
	
	var st_maker = "<%=st_maker%>";
	var st_categoty_name = "<%=st_categoty_name%>";
	var st_maker_arr = st_maker.split(",");
	var st_categoty_arr = st_categoty_name.split(",");
	
	for(var i= 0 ; i<st_maker_arr.length; i++){
		var makerId = st_maker_arr[i].replace(/[()]/g,"");
		$("[id='" + makerId + "']").prop("checked",true);
	}
	for(var i= 0 ; i<st_categoty_arr.length; i++){
		var categId = st_categoty_arr[i].replace(/[()]/g,"");
		$("[id='" + categId + "']").prop("checked",true);
	}
	//sort순
	var st_search_sort = "<%=searchSort%>";
	if(st_search_sort != "WEIGHT" && st_search_sort != ""){ //기본 값 아니면
		var last_index = st_search_sort.lastIndexOf("_");
		var gubun = st_search_sort.substring(0,last_index);
		var upDown = st_search_sort.substring(last_index+1);
		var liList = document.querySelectorAll("#sortList li");
		var clickLi = document.getElementById(gubun);
		liList.forEach(function(li){
			li.classList.remove("Checked");
			document.querySelectorAll("#sortList li img").forEach(function(img){img.remove();})
		})
		clickLi.classList.add("Checked");
		var img = document.createElement("img");
		var src = "";
		if(upDown =="UP")
			src = "/resources/imgs/Icon_Arra_down.png";
		else
			src = "/resources/imgs/Icon_Arra.png"
		img.src = src;
		$("#"+gubun).append(img);
	}
	//목록형, 이미지형
	var st_list_type = "<%=st_list_type%>";
	var listButton = document.getElementById("listButton");
	var imageButton = document.getElementById("imageButton");
	
	if(st_list_type == "list"){
		$("#st_list_type").val("list");
		$("#PDListType").show();
		$("#PDImageType").hide();
		listButton.classList.remove('ButListArray_off');
		listButton.classList.add('ButListArray_on');
		imageButton.classList.remove('ButListImg_on');
		imageButton.classList.add('ButListImg_off');
	}else{
		$("#st_list_type").val("image");
		$("#PDListType").hide();
		$("#PDImageType").show();
		listButton.classList.remove('ButListArray_on');
		listButton.classList.add('ButListArray_off');
		imageButton.classList.remove('ButListImg_off');
		imageButton.classList.add('ButListImg_on');
	}
	//이미지 숨김
<%-- 	var st_image_status = "<%=image_status%>"; --%>
// 	if(st_image_status == "IMAGE_VIEW"){
// 		$("#image_status_check").prop("checked",false);
// 		$(".PDimg").show();
// 		$(".PDimgNo").hide();
// 	}else{
// 		$("#image_status_check").prop("checked",true);
// 		$(".PDimg").hide();
// 		$(".PDimgNo").show();
// 	}
}
 
// 화면이동
function getBuyerCatalogDisplay(stdcateg_id,stdcatlg_id,buyer,org_buyer_item_no,category_no,key_flag,cata,image_dir,image_file, product_close_flag,description){
	//최근본상품저장
	if(product_close_flag == "Y"){
    	//해당 품목은 단종되었습니다.
<%--         alert(" <%=CommonLang.msg("MSG117") %>     "); --%>
        var text = "<%=CommonLang.msg("MSG117") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var searchMyItemList = getKePCookie("searchMyItemList"); 
	searchMyItemList = stdcateg_id+"@@"+stdcatlg_id+"@@"+buyer+"@@"+org_buyer_item_no+"@@"+category_no+"@@"+key_flag+"@@"+cata+"@@"+image_dir+"@@"+image_file+"@@"+description+"&&"+searchMyItemList;
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

	$('#locationForm').attr("action", "/mdcm/getBuyerMdCmGoodsLisDetail.do").submit();   
}

 

// 단가 이력
function getBuyerPriceHistoryPop(byca_comorg_code,contract_no, contract_seq, buyer_item_no)
{       
	var strBuyer = "<%=buyer%>";
	var price_History_Pop_flag = "<%=price_History_Pop_flag%>";
	
	if(contract_no == ""||contract_no == null){ //계약정보 없을 경우 사업장 팝업 표시
	 	if(price_History_Pop_flag == "N"){ // 팝업 미공개 고객사
	 		//단가정보가 없습니다.
<%-- 	 		alert("<%=CommonLang.msg("MSG343") %>"); --%>
	 		var text = "<%=CommonLang.msg("MSG343") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
	 		return;
		}else{
			openSearchPopup("/common/mpiv/catePriceBuyerHistory.do","?open=Y&st_byca_comorg_code="+byca_comorg_code+"&st_buyer_item_no="+buyer_item_no,"740,350,no");			
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
 
	case "myItem": // 관심상품 담기 
		document.getElementById("st_my_groups").style.display = "inline-block";
<%-- 		$("#st_my_group_nm").val("<%=CommonLang.get("HTITLE912") %>:");	//관심상품 분류지정 --%>
		saveProcess("R",gubun);
		break;  
	case "checkMyItem": // 관심상품 담기 
		document.getElementById("st_my_groups").style.display = "inline-block";
<%-- 		$("#st_my_group_nm").val("<%=CommonLang.get("HTITLE912") %>:");	//관심상품 분류지정 --%>
		saveCheckProcess("R");
		break; 
	case "cartItem": // 장바구니 담기
// 		document.getElementById("st_my_groups").style.display = "none";
// 		$("#st_my_group_nm").val("");
		saveProcess("C",gubun);
		break;  	
	case "checkCartItem": // 장바구니 담기
// 		document.getElementById("st_my_groups").style.display = "none";
// 		$("#st_my_group_nm").val("");
		saveCheckProcess("C");
		break;  
	case "reqItem": // 신규견적입력
		saveRqdtProcess(gubun);
		break; 	
	case "reqGplItem": // GPL, 미계약, 단종 건 견적입력
// 		document.getElementById("st_my_groups").style.display = "none";
// 		$("#st_my_group_nm").val("");
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
		$('#locationForm2').attr("action", "/mdcm/showBuyerMdCmCategoryGoodsSearch.do").submit();
		break;
	}
}


function top_kepSearch(cateSize,makerSize){
	var cateText = "";
	var makerText = "";
	
	$("input[name='categCheck']:checked").each(function(e){
		cateText += $(this).val()+",";
	});
	$("input[name='makerCheck']:checked").each(function(e){
		makerText += $(this).val()+",";
	});
	
	cateText = cateText.substr(0,cateText.length-1);
	makerText = makerText.substr(0,makerText.length-1);
	document.forms.searchDiForm.st_categoty_name.value = cateText;
	document.forms.searchDiForm.st_maker.value = makerText; 
	document.forms.searchDiForm.searchTargetIDX_CATEGORY_NO.value = '<%=searchTargetIDX_CATEGORY_NO%>';
	document.forms.searchDiForm.searchTerm.value = '<%=searchKeyWord%>';
	document.forms.searchDiForm.resultKeyword.value = document.forms.searchForm.st_result_keyword.value;
<%-- 	document.forms.searchDiForm.resultKeyword.value = '<%=searchResultKeyword%>'; --%>
	document.forms.searchDiForm.st_sub_flag.value = "Y";
	
	kepSearch(1);
}
function top_kepReload(cateSize,makerSize){ 
	$("input[name='categCheck']").each(function(e){
		$(this).prop("checked",false);
	});
	$("input[name='makerCheck']").each(function(e){
		$(this).prop("checked",false);
	});
	
	document.forms.searchForm.st_result_keyword.value = "";
	
}
function searchSort(gubun){
	var st_sort_gubun = document.forms.searchForm.st_sort_gubun.value;
	var st_sort_change = document.forms.searchForm.st_sort_change.value;
	
	//alert("st_sort_change  "+st_sort_change);
	if(st_sort_gubun != gubun){
		st_sort_change = "UP";
	}else{
		if (st_sort_change == "" || st_sort_change == "DOWN"){
			st_sort_change = "UP";
		}else{
			st_sort_change = "DOWN";
		}
	}
	
	
	document.forms.searchForm.st_sort_change.value = st_sort_change;
	document.forms.searchForm.st_sort_gubun.value = gubun;
	document.forms.searchDiForm.st_sort_gubun.value = gubun;
	document.forms.searchDiForm.st_sort_change.value = st_sort_change;
	document.forms.searchDiForm.searchSort.value = gubun + "_"+st_sort_change; 
	//alert(document.forms.searchDiForm.searchSort.value);
	kepSearch(1);
}

/*
 * 여러건 처리할 경우 관심상품등록 R
 * 여러건 처리할 경우 장바구니담기 C
 */
function saveCheckProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var openAgentPop = false;
    var buyerArr = "";
    var buyerItemNoArr = "";
    var orderQtyArr = "";
    var p060000077 = "<%=p060000077%>"; //MOQ
	var p060000089 = "<%=p060000089%>"; //주문배수
    
    //
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//목록에 표시된 상품이 없습니다.
<%--         alert(" <%=CommonLang.msg("MSG16") %>     "); --%>
        var text = "<%=CommonLang.msg("MSG16") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    
    var type = $("#st_list_type").val();
    if(type == "list"){
    	if(eval(tot_cnt) < 2){
            var box = eval('document.forms["contentForm"].lnCheck0');
            if(box.checked == true) chk_cnt++;
        }else{
            for(var j = 0; j < tot_cnt; j++){
                 var box = eval('document.forms["contentForm"].lnCheck' + j);
                 if(box.checked == true){
                      chk_cnt++;
                 }
            }
        }
        if(chk_cnt == "0"){
        	if(flag == "R"){
        		//관심상품으로 등록할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG663")%>";
        	}else if(flag == "C"){
        		//장바구니에 등록할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG664") %>";
        	}
    		openLayerPopText2(text,but1text,but1func,but1width);
            return;
        }else{
            if(eval(tot_cnt) < 2){
                var box = eval('document.forms["contentForm"].lnCheck0' ); 
                if(box.checked == true){
                	var order_qty     = document.forms["contentForm"].st_order_qty.value;
                    var st_agent_flag = document.forms["contentForm"].st_agent_flag.value;
    		        var st_item_no   = document.forms["contentForm"].st_item_no.value;
    				var st_order_qty = document.forms["contentForm"].st_order_qty.value;
    				var st_agent     = document.forms["contentForm"].st_agent_code.value;
    				var contract_no  = document.forms["contentForm"].st_contract_no.value;
    				var contract_seq = document.forms["contentForm"].st_contract_seq.value;
    				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code.value;
    				var st_min_order_qty = document.forms["contentForm"].st_min_order_qty.value;
    				var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty.value;
    				//표준카탈로그 매핑 여부
    				var st_stnd_flag = document.forms["contentForm"].st_stnd_flag.value;
    				//단종여부 
    				var st_product_close_flag = document.forms["contentForm"].st_product_close_flag.value;
                    var key_flag      = st_agent_flag.substr(0,2); 
                    if(st_agent_flag == "MULTI_AGENT"){
                        var st_key_flag = "Y";
                    }else{
                        var st_key_flag = "N";
                    }
                    if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                    	//계약정보 없는 품목은 등록이 불가능 합니다.
    <%--                 	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
                    	var text = "<%=CommonLang.msg("MSG344") %>";
                		openLayerPopText2(text,but1text,but1func,but1width);
                    	return;
                    }
                    //단종이고 단종일때 단가 비노출이면 처리 불가능.
                    if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                    	//해당 품목은 단종되었습니다.
    <%--                 	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
                    	var text = "<%=CommonLang.msg("MSG117") %>";
                		openLayerPopText2(text,but1text,but1func,but1width);
                    	return;
                    }
                    if(flag == "C"){
                    	//MOQ 주문 통제 특수로직 적용한 고객사 한정
                  		if(p060000077 == "true"){
                  			if(Number(order_qty) < Number(st_min_order_qty)){
                  				//최소주문수량에 맞게 수량을 설정해주세요.
                  				var text = "<%=CommonLang.msg("MSG611")%>";
                  		  		openLayerPopText2(text,but1text,but1func,but1width);
                  				document.forms["contentForm"].st_order_qty.focus();
                  				return;				
                  			}            	
                  		}
                  		//주문배수 주문 통제 특수로직 적용한 고객사 한정
                  		if(p060000089 == "true"){
                  			var checkNum = order_qty%st_pur_unit_qty;
                  			if(checkNum != 0 ){
                  	       		//주문배수에 맞게 수량을 설정해주세요.
                  	   			var text = "<%=CommonLang.msg("MSG609")%>";
                  		  		openLayerPopText2(text,but1text,but1func,but1width);
                  	       		document.forms["contentForm"].st_order_qty.focus();
                  	       		return;				
                  			}            	
                  		}
                  		if(!kepChkDecimal(order_qty,3)){
                        	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
        <%--                     alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                            var text = "<%=CommonLang.msg("MSG18") %>";
                    		openLayerPopText2(text,but1text,but1func,but1width);
                            document.forms["contentForm"].st_order_qty.focus();
                            return;
                        }
                     }
                    
                    if(st_key_flag == "Y"){
                    	openAgentPop = true;
                    	buyerArr = byit_comorg_code;
                    	buyerItemNoArr += st_item_no + ",";
                    }else{
    					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
    				}
                }
            }else{
                for(var i = 0; i <tot_cnt; i++){
                    var box = eval('document.forms["contentForm"].lnCheck' + i);
                    var order_qty     = document.forms["contentForm"].st_order_qty[i].value;
                    var st_agent_flag = document.forms["contentForm"].st_agent_flag[i].value;
    				var st_item_no   = document.forms["contentForm"].st_item_no[i].value;
    				var st_order_qty = document.forms["contentForm"].st_order_qty[i].value;
    				var st_agent     = document.forms["contentForm"].st_agent_code[i].value;
    				var contract_no  = document.forms["contentForm"].st_contract_no[i].value;
    				var contract_seq = document.forms["contentForm"].st_contract_seq[i].value;
    				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code[i].value;
    				var st_min_order_qty = document.forms["contentForm"].st_min_order_qty[i].value;
    				var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty[i].value;
    				//표준카탈로그 매핑 여부
    				var st_stnd_flag = document.forms["contentForm"].st_stnd_flag[i].value;
    				//단종여부 
    				var st_product_close_flag = document.forms["contentForm"].st_product_close_flag[i].value;
                    if(box.checked == true){
                        if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                        	//계약정보 없는 품목은 등록이 불가능 합니다.
    <%--                     	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
                        	var text = "<%=CommonLang.msg("MSG344") %>";
                    		openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                        //단종이고 단종일때 단가 비노출이면 처리 불가능.
                        if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                        	//해당 품목은 단종되었습니다.
    <%--                     	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
                        	var text = "<%=CommonLang.msg("MSG117") %>";
                    		openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                        var key_flag      = st_agent_flag.substr(0,2); 
                        if(st_agent_flag == "MULTI_AGENT"){
                            var st_key_flag = "Y";
                        }else{
                            var st_key_flag = "N";
                        }
                        
                        if(flag == "C"){
                        	//MOQ 주문 통제 특수로직 적용한 고객사 한정
                      		if(p060000077 == "true"){
                      			if(Number(order_qty) < Number(st_min_order_qty)){
                      				//최소주문수량에 맞게 수량을 설정해주세요.
                      				var text = "<%=CommonLang.msg("MSG611")%>";
                      		  		openLayerPopText2(text,but1text,but1func,but1width);
                      				document.forms["contentForm"].st_order_qty[i].focus();
                      				return;				
                      			}            	
                      		}
                      		//주문배수 주문 통제 특수로직 적용한 고객사 한정
                      		if(p060000089 == "true"){
                      			var checkNum = order_qty%st_pur_unit_qty;
                      			if(checkNum != 0 ){
                      	       		//주문배수에 맞게 수량을 설정해주세요.
                      	   			var text = "<%=CommonLang.msg("MSG609")%>";
                      		  		openLayerPopText2(text,but1text,but1func,but1width);
                      	       		document.forms["contentForm"].st_order_qty[i].focus();
                      	       		return;				
                      			}            	
                      		}
                      		if(!kepChkDecimal(order_qty,3)){
                            	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
        <%--                         alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
                                var text = (i+1)+"<%=CommonLang.msg("MSG20") %>";
                        		openLayerPopText2(text,but1text,but1func,but1width);
                                document.forms["contentForm"].st_order_qty[i].focus();
                                return;
                            }
                         }
                        
                        
                        if(st_key_flag == "Y"){
                        	openAgentPop = true;
                        	buyerArr = byit_comorg_code;
                        	buyerItemNoArr += st_item_no + ",";
                        }else {
    					  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
    					  query += "&&";
    					}
                    }
                }
            }
        }
    }else{
    	if(eval(tot_cnt) < 2){
            var box = eval('document.forms["contentForm2"].lnCheck0');
            if(box.checked == true) chk_cnt++;
        }else{
            for(var j = 0; j < tot_cnt; j++){
                 var box = eval('document.forms["contentForm2"].lnCheck' + j);
                 if(box.checked == true){
                      chk_cnt++;
                 }
            }
        }
        if(chk_cnt == "0"){
        	if(flag == "R"){
        		//관심상품으로 등록할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG663")%>";
        	}else if(flag == "C"){
        		//장바구니에 등록할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG664") %>";
        	}
    		openLayerPopText2(text,but1text,but1func,but1width);
            return;
        }else{
            if(eval(tot_cnt) < 2){
                var box = eval('document.forms["contentForm2"].lnCheck0' ); 
                if(box.checked == true){
                	var order_qty     = document.forms["contentForm2"].st_order_qty.value;
                    var st_agent_flag = document.forms["contentForm2"].st_agent_flag.value;
    		        var st_item_no   = document.forms["contentForm2"].st_item_no.value;
    				var st_order_qty = document.forms["contentForm2"].st_order_qty.value;
    				var st_agent     = document.forms["contentForm2"].st_agent_code.value;
    				var contract_no  = document.forms["contentForm2"].st_contract_no.value;
    				var contract_seq = document.forms["contentForm2"].st_contract_seq.value;
    				var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code.value;
    				var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty.value;
    				var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty.value;
    				//표준카탈로그 매핑 여부
    				var st_stnd_flag = document.forms["contentForm2"].st_stnd_flag.value;
    				//단종여부 
    				var st_product_close_flag = document.forms["contentForm2"].st_product_close_flag.value;
                    var key_flag      = st_agent_flag.substr(0,2); 
                    if(st_agent_flag == "MULTI_AGENT"){
                        var st_key_flag = "Y";
                    }else{
                        var st_key_flag = "N";
                    }
                    if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                    	//계약정보 없는 품목은 등록이 불가능 합니다.
    <%--                 	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
                    	var text = "<%=CommonLang.msg("MSG344") %>";
                		openLayerPopText2(text,but1text,but1func,but1width);
                    	return;
                    }
                    //단종이고 단종일때 단가 비노출이면 처리 불가능.
                    if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                    	//해당 품목은 단종되었습니다.
    <%--                 	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
                    	var text = "<%=CommonLang.msg("MSG117") %>";
                		openLayerPopText2(text,but1text,but1func,but1width);
                    	return;
                    }
                    if(flag == "C"){
                    	//MOQ 주문 통제 특수로직 적용한 고객사 한정
                  		if(p060000077 == "true"){
                  			if(Number(order_qty) < Number(st_min_order_qty)){
                  				//최소주문수량에 맞게 수량을 설정해주세요.
                  				var text = "<%=CommonLang.msg("MSG611")%>";
                  		  		openLayerPopText2(text,but1text,but1func,but1width);
                  				document.forms["contentForm"].st_order_qty.focus();
                  				return;				
                  			}            	
                  		}
                  		//주문배수 주문 통제 특수로직 적용한 고객사 한정
                  		if(p060000089 == "true"){
                  			var checkNum = order_qty%st_pur_unit_qty;
                  			if(checkNum != 0 ){
                  	       		//주문배수에 맞게 수량을 설정해주세요.
                  	   			var text = "<%=CommonLang.msg("MSG609")%>";
                  		  		openLayerPopText2(text,but1text,but1func,but1width);
                  	       		document.forms["contentForm"].st_order_qty.focus();
                  	       		return;				
                  			}            	
                  		}
                  		if(!kepChkDecimal(order_qty,3)){
                        	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
        <%--                     alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                            var text = "<%=CommonLang.msg("MSG18") %>";
                    		openLayerPopText2(text,but1text,but1func,but1width);
                            document.forms["contentForm2"].st_order_qty.focus();
                            return;
                        }
                     }
                    
                    
                    if(st_key_flag == "Y"){
                    	openAgentPop = true;
                    	buyerArr = byit_comorg_code;
                    	buyerItemNoArr += st_item_no + ",";
                    }else{
    					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
    				}
                }
            }else{
                for(var i = 0; i <tot_cnt; i++){
                    var box = eval('document.forms["contentForm2"].lnCheck' + i);
                    var order_qty     = document.forms["contentForm2"].st_order_qty[i].value;
                    var st_agent_flag = document.forms["contentForm2"].st_agent_flag[i].value;
    				var st_item_no   = document.forms["contentForm2"].st_item_no[i].value;
    				var st_order_qty = document.forms["contentForm2"].st_order_qty[i].value;
    				var st_agent     = document.forms["contentForm2"].st_agent_code[i].value;
    				var contract_no  = document.forms["contentForm2"].st_contract_no[i].value;
    				var contract_seq = document.forms["contentForm2"].st_contract_seq[i].value;
    				var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code[i].value;
    				var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty[i].value;
    				var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty[i].value;
    				//표준카탈로그 매핑 여부
    				var st_stnd_flag = document.forms["contentForm2"].st_stnd_flag[i].value;
    				//단종여부 
    				var st_product_close_flag = document.forms["contentForm2"].st_product_close_flag[i].value;
                    if(box.checked == true){
                        if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                        	//계약정보 없는 품목은 등록이 불가능 합니다.
    <%--                     	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
                        	var text = "<%=CommonLang.msg("MSG344") %>";
                    		openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                        //단종이고 단종일때 단가 비노출이면 처리 불가능.
                        if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                        	//해당 품목은 단종되었습니다.
    <%--                     	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
                        	var text = "<%=CommonLang.msg("MSG117") %>";
                    		openLayerPopText2(text,but1text,but1func,but1width);
                        	return;
                        }
                        var key_flag      = st_agent_flag.substr(0,2); 
                        if(st_agent_flag == "MULTI_AGENT"){
                            var st_key_flag = "Y";
                        }else{
                            var st_key_flag = "N";
                        }
                        
                        if(flag == "C"){
                        	//MOQ 주문 통제 특수로직 적용한 고객사 한정
                      		if(p060000077 == "true"){
                      			if(Number(order_qty) < Number(st_min_order_qty)){
                      				//최소주문수량에 맞게 수량을 설정해주세요.
                      				var text = "<%=CommonLang.msg("MSG611")%>";
                      		  		openLayerPopText2(text,but1text,but1func,but1width);
                      				document.forms["contentForm"].st_order_qty[i].focus();
                      				return;				
                      			}            	
                      		}
                      		//주문배수 주문 통제 특수로직 적용한 고객사 한정
                      		if(p060000089 == "true"){
                      			var checkNum = order_qty%st_pur_unit_qty;
                      			if(checkNum != 0 ){
                      	       		//주문배수에 맞게 수량을 설정해주세요.
                      	   			var text = "<%=CommonLang.msg("MSG609")%>";
                      		  		openLayerPopText2(text,but1text,but1func,but1width);
                      	       		document.forms["contentForm"].st_order_qty[i].focus();
                      	       		return;				
                      			}            	
                      		}
                      		if(!kepChkDecimal(order_qty,3)){
                            	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
        <%--                         alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
                                var text = (i+1)+"<%=CommonLang.msg("MSG20") %>";
                        		openLayerPopText2(text,but1text,but1func,but1width);
                                document.forms["contentForm2"].st_order_qty[i].focus();
                                return;
                            }
                         }
                        
                        if(st_key_flag == "Y"){
                        	openAgentPop = true;
                        	buyerArr = byit_comorg_code;
                        	buyerItemNoArr += st_item_no + ",";
                        }else {
    					  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
    					  query += "&&";
    					}
                    }
                }
            }
        }
    }
    	 
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	//복수 협력사 상품 1개라도 있으면 협력사선택팝업
	if(openAgentPop){
		popupSel = flag+"saveProcessMulti";
		buyerItemNoArr = buyerItemNoArr.substring(0,buyerItemNoArr.length-1);
		var src = '/mdcm/buyerMdCmAgentChoiceMultiPop_v2.do?buyer='+buyerArr+'&buyer_tem_no='+buyerItemNoArr+'&stdcatlg_id='+"";
		openLayerPop(src,"940px","500px");
		return;
	}else{
		kep_showConfirm();	   
	}   
 
}
 
/*
 * 단건 관심상품등록 R
 * 단건  장바구니담기 C
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var openAgentPop = false;
    var buyerArr = "";
    var buyerItemNoArr = "";
    var orderQtyArr = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
    	//목록에 표시된 상품이 없습니다.
<%--         alert(" <%=CommonLang.msg("MSG16") %>     "); --%>
        var text = "<%=CommonLang.msg("MSG16") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval('document.forms["contentForm"].lnCheck0');
        if(box.checked == true) chk_cnt++;
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval('document.forms["contentForm"].lnCheck' + j);
             if(box.checked == true){
                  chk_cnt++;
             }
        }
    }
    if(chk_cnt == "0"){
    	//하나 이상의 상품이 선택되어야 합니다.
<%--         alert(" <%=CommonLang.msg("MSG17") %>   "); --%>
        var text = "<%=CommonLang.msg("MSG17") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }else{
        if(eval(tot_cnt) < 2){
            var box = eval('document.forms["contentForm"].lnCheck0' ); 
            if(box.checked == true){
            	var order_qty     = document.forms["contentForm"].st_order_qty.value;
                var st_agent_flag = document.forms["contentForm"].st_agent_flag.value;
		        var st_item_no   = document.forms["contentForm"].st_item_no.value;
				var st_order_qty = document.forms["contentForm"].st_order_qty.value;
				var st_agent     = document.forms["contentForm"].st_agent_code.value;
				var contract_no  = document.forms["contentForm"].st_contract_no.value;
				var contract_seq = document.forms["contentForm"].st_contract_seq.value;
				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code.value;
				//표준카탈로그 매핑 여부
				var st_stnd_flag = document.forms["contentForm"].st_stnd_flag.value;
				//단종여부 
				var st_product_close_flag = document.forms["contentForm"].st_product_close_flag.value;
                var key_flag      = st_agent_flag.substr(0,2); 
                if(st_agent_flag == "MULTI_AGENT"){
                    var st_key_flag = "Y";
                }else{
                    var st_key_flag = "N";
                }
                if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                	//계약정보 없는 품목은 등록이 불가능 합니다.
<%--                 	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
                	var text = "<%=CommonLang.msg("MSG344") %>";
            		openLayerPopText2(text,but1text,but1func,but1width);
                	return;
                }
                //단종이고 단종일때 단가 비노출이면 처리 불가능.
                if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                	//해당 품목은 단종되었습니다.
<%--                 	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
                	var text = "<%=CommonLang.msg("MSG117") %>";
            		openLayerPopText2(text,but1text,but1func,but1width);
                	return;
                }
                if(!kepChkDecimal(order_qty,3)){
                	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
<%--                     alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                    var text = "<%=CommonLang.msg("MSG18") %>";
            		openLayerPopText2(text,but1text,but1func,but1width);
                    document.forms["contentForm"].st_order_qty.focus();
                    return;
                }
                else if(st_key_flag == "Y"){
                	openAgentPop = true;
                	buyerArr = byit_comorg_code;
                	buyerItemNoArr += st_item_no + ",";
                	orderQtyArr += order_qty + ",";
                }else{
					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
				}
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval('document.forms["contentForm"].lnCheck' + i);
                var order_qty     = document.forms["contentForm"].st_order_qty[i].value;
                var st_agent_flag = document.forms["contentForm"].st_agent_flag[i].value;
				var st_item_no   = document.forms["contentForm"].st_item_no[i].value;
				var st_order_qty = document.forms["contentForm"].st_order_qty[i].value;
				var st_agent     = document.forms["contentForm"].st_agent_code[i].value;
				var contract_no  = document.forms["contentForm"].st_contract_no[i].value;
				var contract_seq = document.forms["contentForm"].st_contract_seq[i].value;
				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code[i].value;
				//표준카탈로그 매핑 여부
				var st_stnd_flag = document.forms["contentForm"].st_stnd_flag[i].value;
				//단종여부 
				var st_product_close_flag = document.forms["contentForm"].st_product_close_flag[i].value;
                if(box.checked == true){
                    if(contract_no == null || contract_no ==""|| contract_no =="PC"){
                    	//계약정보 없는 품목은 등록이 불가능 합니다.
<%--                     	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
                    	var text = "<%=CommonLang.msg("MSG344") %>";
                		openLayerPopText2(text,but1text,but1func,but1width);
                    	return;
                    }
                    //단종이고 단종일때 단가 비노출이면 처리 불가능.
                    if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
                    	//해당 품목은 단종되었습니다.
<%--                     	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
                    	var text = "<%=CommonLang.msg("MSG117") %>";
                		openLayerPopText2(text,but1text,but1func,but1width);
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
<%--                         alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
                        var text = (i+1)+"<%=CommonLang.msg("MSG20") %>";
                		openLayerPopText2(text,but1text,but1func,but1width);
                        document.forms["contentForm"].st_order_qty[i].focus();
                        return;
                    }
                    else if(st_key_flag == "Y"){
                    	openAgentPop = true;
                    	buyerArr = byit_comorg_code;
                    	buyerItemNoArr += st_item_no + ",";
                    	orderQtyArr += order_qty + ",";
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
	//복수 협력사 상품 1개라도 있으면 협력사선택팝업
	if(openAgentPop){
		popupSel = flag+"saveProcessMulti";
		buyerItemNoArr = buyerItemNoArr.substring(0,buyerItemNoArr.length-1);
		var src = '/mdcm/buyerMdCmAgentChoiceMultiPop_v2.do?buyer='+buyerArr+'&buyer_tem_no='+buyerItemNoArr+'&stdcatlg_id='+"";
		openLayerPop(src,"940px","500px");
		return;
	}else{
		kep_showConfirm();	   
	}
 
}
 
//e신규견적입력.
function saveRqdtProcess(y_num){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var type = $("#st_list_type").val();

    if(type == "list"){
    	if(eval(tot_cnt) < 2){
         	var order_qty     = document.forms["contentForm"].st_order_qty.value;
            var st_item_no   = document.forms["contentForm"].st_item_no.value;

            if(!kepChkDecimal(order_qty,3)){
           		//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
    <%--             alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                var text = "<%=CommonLang.msg("MSG18") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                document.forms["contentForm"].st_order_qty.focus();
                 return;
             }
             query = st_item_no;
         }else{
            var order_qty     = document.forms["contentForm"].st_order_qty[y_num].value;
    		var st_item_no   = document.forms["contentForm"].st_item_no[y_num].value;
            if(!kepChkDecimal(order_qty,3)){
            	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
    <%--            alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
               var text = (i+1)+"<%=CommonLang.msg("MSG20") %>";
       		   openLayerPopText2(text,but1text,but1func,but1width);
               document.forms["contentForm"].st_order_qty[y_num].focus();
               return;
             }
             query += st_item_no + "@@";
         }
    }else{
    	if(eval(tot_cnt) < 2){
         	var order_qty     = document.forms["contentForm2"].st_order_qty.value;
            var st_item_no   = document.forms["contentForm2"].st_item_no.value;

            if(!kepChkDecimal(order_qty,3)){
           		//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
    <%--             alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                var text = "<%=CommonLang.msg("MSG18") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                document.forms["contentForm2"].st_order_qty.focus();
                 return;
             }
             query = st_item_no;
         }else{
            var order_qty     = document.forms["contentForm2"].st_order_qty[y_num].value;
    		var st_item_no   = document.forms["contentForm2"].st_item_no[y_num].value;
            if(!kepChkDecimal(order_qty,3)){
            	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
    <%--            alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
               var text = (i+1)+"<%=CommonLang.msg("MSG20") %>";
       		   openLayerPopText2(text,but1text,but1func,but1width);
               document.forms["contentForm2"].st_order_qty[y_num].focus();
               return;
             }
             query += st_item_no + "@@";
         }
    }
     
    document.forms.locationForm2.st_query.value = query; 
    $('#locationForm2').attr("action", "/mprq/showBuyerMpRqRequestQuotation_v2.do?menuId=br00101000000&tabIndex=1&itemFlag=Y").submit();
}
// 미계약 품목 신규견적
function saveRqdtGplProcess(y_num){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var flag	= "Q";
    var type	= "";

    var listType = $("#st_list_type").val();
    if(listType == "list"){
    	if(eval(tot_cnt) < 2){
            var box = eval('document.forms["contentForm"].lnCheck0' ); 
            var order_qty    = document.forms["contentForm"].st_order_qty.value;
            var st_item_no   = document.forms["contentForm"].st_item_no.value;
    		var st_order_qty = document.forms["contentForm"].st_order_qty.value;
    		var st_agent     = document.forms["contentForm"].st_agent_code.value;
    		var contract_no  = document.forms["contentForm"].st_contract_no.value;
    		var contract_seq = document.forms["contentForm"].st_contract_seq.value;
    		var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code.value;
    		var product_close_flag = document.forms["contentForm"].st_product_close_flag.value;

    		if((contract_no != null && contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
               	//기등록건은 견적의뢰가 불가능 합니다.
    <%--         	alert( " <%=CommonLang.msg("MSG500") %> "); --%>
            	var text = "<%=CommonLang.msg("MSG500") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                return;
            }
            if(!kepChkDecimal(order_qty,3)){
              	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
    <%--             alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                var text = "<%=CommonLang.msg("MSG18") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                document.forms["contentForm"].st_order_qty.focus();
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
         	var order_qty    = document.forms["contentForm"].st_order_qty[y_num].value;
            var st_item_no   = document.forms["contentForm"].st_item_no[y_num].value;
    		var st_order_qty = document.forms["contentForm"].st_order_qty[y_num].value;
    		var st_agent     = document.forms["contentForm"].st_agent_code[y_num].value;
    		var contract_no  = document.forms["contentForm"].st_contract_no[y_num].value;
    		var contract_seq = document.forms["contentForm"].st_contract_seq[y_num].value;
    		var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code[y_num].value;
    		var product_close_flag = document.forms["contentForm"].st_product_close_flag[y_num].value;
            if((contract_no != null && contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
            	//기등록건은 견적의뢰가 불가능 합니다.
    <%--             alert( " <%=CommonLang.msg("MSG500") %> "); --%>
                var text = "<%=CommonLang.msg("MSG500") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                return;
            }
            if(!kepChkDecimal(order_qty,3)){
            	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
    <%--             alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
                var text = (i+1)+"<%=CommonLang.msg("MSG20") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                document.forms["contentForm"].st_order_qty[i].focus();
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
    }else{
    	if(eval(tot_cnt) < 2){
            var box = eval('document.forms["contentForm2"].lnCheck0' ); 
            var order_qty    = document.forms["contentForm2"].st_order_qty.value;
            var st_item_no   = document.forms["contentForm2"].st_item_no.value;
    		var st_order_qty = document.forms["contentForm2"].st_order_qty.value;
    		var st_agent     = document.forms["contentForm2"].st_agent_code.value;
    		var contract_no  = document.forms["contentForm2"].st_contract_no.value;
    		var contract_seq = document.forms["contentForm2"].st_contract_seq.value;
    		var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code.value;
    		var product_close_flag = document.forms["contentForm2"].st_product_close_flag.value;

    		if((contract_no != null && contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
               	//기등록건은 견적의뢰가 불가능 합니다.
    <%--         	alert( " <%=CommonLang.msg("MSG500") %> "); --%>
            	var text = "<%=CommonLang.msg("MSG500") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                return;
            }
            if(!kepChkDecimal(order_qty,3)){
              	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
    <%--             alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                var text = "<%=CommonLang.msg("MSG18") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                document.forms["contentForm2"].st_order_qty.focus();
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
         	var order_qty    = document.forms["contentForm2"].st_order_qty[y_num].value;
            var st_item_no   = document.forms["contentForm2"].st_item_no[y_num].value;
    		var st_order_qty = document.forms["contentForm2"].st_order_qty[y_num].value;
    		var st_agent     = document.forms["contentForm2"].st_agent_code[y_num].value;
    		var contract_no  = document.forms["contentForm2"].st_contract_no[y_num].value;
    		var contract_seq = document.forms["contentForm2"].st_contract_seq[y_num].value;
    		var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code[y_num].value;
    		var product_close_flag = document.forms["contentForm2"].st_product_close_flag[y_num].value;
            if((contract_no != null && contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
            	//기등록건은 견적의뢰가 불가능 합니다.
    <%--             alert( " <%=CommonLang.msg("MSG500") %> "); --%>
                var text = "<%=CommonLang.msg("MSG500") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                return;
            }
            if(!kepChkDecimal(order_qty,3)){
            	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
    <%--             alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
                var text = (i+1)+"<%=CommonLang.msg("MSG20") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
                document.forms["contentForm2"].st_order_qty[i].focus();
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
    }

     
    $("#confirm1").val("save");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
    kep_showRqdtGplConfirm();
}

function kep_showRqdtGplConfirm(){
	
//     $('body,html').animate({
// 		scrollTop: 0
// 	}, 100);
	runRqdtGplProcess();
<%-- 	$("#confirmMyGroupMsg").text("<%=CommonLang.msg("MSG498") %>");	//견적 임시 저장하시고 신규견적 임시저장 조회 화면으로 이동하시겠습니까? --%>
// 	$("#confirmMyGroupArea").show();
// 	$("#confirmMyGroupAreaOverlay").show();
}

function runRqdtGplProcess() {  	
	$("#confirm4").val("save");
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	
	document.forms.locationForm2.st_query.value = query;
	kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationGpl.do","locationForm2",gubun); 
}

/*
 * 관심상품등록 R
 * 장바구니담기 C
 */
function saveProcess(flag, y_num){
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var p060000077 = "<%=p060000077%>"; //MOQ
	var p060000089 = "<%=p060000089%>"; //주문배수

    var type = $("#st_list_type").val();
    if(type == "list"){
    	if(eval(tot_cnt) < 2){
         	var order_qty     = document.forms["contentForm"].st_order_qty.value;
            var st_agent_flag = document.forms["contentForm"].st_agent_flag.value;
       		var st_item_no   = document.forms["contentForm"].st_item_no.value;
			var st_order_qty = document.forms["contentForm"].st_order_qty.value;
			var st_agent     = document.forms["contentForm"].st_agent_code.value;
			var contract_no  = document.forms["contentForm"].st_contract_no.value;
			var contract_seq = document.forms["contentForm"].st_contract_seq.value;
			var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code.value;
			var st_min_order_qty = document.forms["contentForm"].st_min_order_qty.value;
			var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty.value;
			
			//표준카탈로그 매핑 여부
			var st_stnd_flag = document.forms["contentForm"].st_stnd_flag.value;
			//단종여부 
			var st_product_close_flag = document.forms["contentForm"].st_product_close_flag.value;
             var key_flag      = st_agent_flag.substr(0,2); 
             if(st_agent_flag == "MULTI_AGENT"){
                 var st_key_flag = "Y";
             }else{
                 var st_key_flag = "N";
             }
             if(contract_no == null || contract_no ==""|| contract_no =="PC"){
             	//계약정보 없는 품목은 등록이 불가능 합니다.
<%--              	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
             	var text = "<%=CommonLang.msg("MSG344") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
             	return;
             }
             //단종이고 단종일때 단가 비노출이면 처리 불가능.
             if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
             	//해당 품목은 단종되었습니다.
<%--              	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
             	var text = "<%=CommonLang.msg("MSG117") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
             	return;
             }
             if(flag == "C"){
            	//MOQ 주문 통제 특수로직 적용한 고객사 한정
          		if(p060000077 == "true"){
          			if(Number(order_qty) < Number(st_min_order_qty)){
          				//최소주문수량에 맞게 수량을 설정해주세요.
          				var text = "<%=CommonLang.msg("MSG611")%>";
          		  		openLayerPopText2(text,but1text,but1func,but1width);
          				document.forms["contentForm"].st_order_qty.focus();
          				return;				
          			}            	
          		}
          		//주문배수 주문 통제 특수로직 적용한 고객사 한정
          		if(p060000089 == "true"){
          			var checkNum = order_qty%st_pur_unit_qty;
          			if(checkNum != 0 ){
          	       		//주문배수에 맞게 수량을 설정해주세요.
          	   			var text = "<%=CommonLang.msg("MSG609")%>";
          		  		openLayerPopText2(text,but1text,but1func,but1width);
          	       		document.forms["contentForm"].st_order_qty.focus();
          	       		return;				
          			}            	
          		}
                  if(!kepChkDecimal(order_qty,3)){
                  	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
     <%--                  alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                      var text = "<%=CommonLang.msg("MSG18") %>";
              		 openLayerPopText2(text,but1text,but1func,but1width);
                      document.forms["contentForm"].st_order_qty.focus();
                      return;
                  }
             }
            
             if(st_key_flag == "Y"){
            	//협력사 선택 팝업
            	 popupSel = flag+"saveProcess";
         		 var src = '/mdcm/getBuyerMdCmAgentChoicePop_v2.do?buyer='+byit_comorg_code+'&buyer_tem_no='+st_item_no+'&stdcatlg_id='+"";
         		 openLayerPop(src,"570px","620px");
         		 return;
             }else{
				query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
			}
     	}else{
            var order_qty     = document.forms["contentForm"].st_order_qty[y_num].value;
            var st_agent_flag = document.forms["contentForm"].st_agent_flag[y_num].value;
			var st_item_no   = document.forms["contentForm"].st_item_no[y_num].value;
			var st_order_qty = document.forms["contentForm"].st_order_qty[y_num].value;
			var st_agent     = document.forms["contentForm"].st_agent_code[y_num].value;
			var contract_no  = document.forms["contentForm"].st_contract_no[y_num].value;
			var contract_seq = document.forms["contentForm"].st_contract_seq[y_num].value;
			var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code[y_num].value;
			var st_min_order_qty = document.forms["contentForm"].st_min_order_qty[y_num].value;
			var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty[y_num].value;
			//표준카탈로그 매핑 여부
			var st_stnd_flag = document.forms["contentForm"].st_stnd_flag[y_num].value;
			//단종여부 
			var st_product_close_flag = document.forms["contentForm"].st_product_close_flag[y_num].value;
            if(contract_no == null || contract_no ==""|| contract_no =="PC"){
               	//계약정보 없는 품목은 등록이 불가능 합니다.
<%--                	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
               	var text = "<%=CommonLang.msg("MSG344") %>";
        		 openLayerPopText2(text,but1text,but1func,but1width);
	        	return;
            }
            //단종이고 단종일때 단가 비노출이면 처리 불가능.
            if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
            	//해당 품목은 단종되었습니다.
<%--             	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
            	var text = "<%=CommonLang.msg("MSG117") %>";
        		 openLayerPopText2(text,but1text,but1func,but1width);
            	return;
            }
            if(flag == "C"){
            	//MOQ 주문 통제 특수로직 적용한 고객사 한정
          		if(p060000077 == "true"){
          			if(Number(order_qty) < Number(st_min_order_qty)){
          				//최소주문수량에 맞게 수량을 설정해주세요.
          				var text = "<%=CommonLang.msg("MSG611")%>";
          		  		openLayerPopText2(text,but1text,but1func,but1width);
          				document.forms["contentForm"].st_order_qty[y_num].focus();
          				return;				
          			}            	
          		}
          		//주문배수 주문 통제 특수로직 적용한 고객사 한정
          		if(p060000089 == "true"){
          			var checkNum = order_qty%st_pur_unit_qty;
          			if(checkNum != 0 ){
          	       		//주문배수에 맞게 수량을 설정해주세요.
          	   			var text = "<%=CommonLang.msg("MSG609")%>";
          		  		openLayerPopText2(text,but1text,but1func,but1width);
          	       		document.forms["contentForm"].st_order_qty[y_num].focus();
          	       		return;				
          			}            	
          		}
          		if(!kepChkDecimal(order_qty,3)){
                 	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
    <%--                  alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
                     var text = y_num+"<%=CommonLang.msg("MSG20") %>";
             		 openLayerPopText2(text,but1text,but1func,but1width);
                     document.forms["contentForm"].st_order_qty[y_num].focus();
                     return;
                 }
             }
            var key_flag      = st_agent_flag.substr(0,2); 
            if(st_agent_flag == "MULTI_AGENT"){
            	var st_key_flag = "Y";
             }else{
                 var st_key_flag = "N";
             }
             
            if(st_key_flag == "Y"){
            	 //협력사 선택 팝업
            	 popupSel = flag+"saveProcess";
         		 var src = '/mdcm/getBuyerMdCmAgentChoicePop_v2.do?buyer='+byit_comorg_code+'&buyer_tem_no='+st_item_no+'&stdcatlg_id='+"";
         		 openLayerPop(src,"570px","620px");
         		 return;
             }else {
		  		query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		  		query += "&&";
			}
     	}
    }else{
    	if(eval(tot_cnt) < 2){
         	var order_qty     = document.forms["contentForm2"].st_order_qty.value;
            var st_agent_flag = document.forms["contentForm2"].st_agent_flag.value;
       		var st_item_no   = document.forms["contentForm2"].st_item_no.value;
			var st_order_qty = document.forms["contentForm2"].st_order_qty.value;
			var st_agent     = document.forms["contentForm2"].st_agent_code.value;
			var contract_no  = document.forms["contentForm2"].st_contract_no.value;
			var contract_seq = document.forms["contentForm2"].st_contract_seq.value;
			var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code.value;
			var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty.value;
			var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty.value;
			//표준카탈로그 매핑 여부
			var st_stnd_flag = document.forms["contentForm2"].st_stnd_flag.value;
			//단종여부 
			var st_product_close_flag = document.forms["contentForm2"].st_product_close_flag.value;
             var key_flag      = st_agent_flag.substr(0,2); 
             if(st_agent_flag == "MULTI_AGENT"){
                 var st_key_flag = "Y";
             }else{
                 var st_key_flag = "N";
             }
             if(contract_no == null || contract_no ==""|| contract_no =="PC"){
             	//계약정보 없는 품목은 등록이 불가능 합니다.
<%--              	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
             	var text = "<%=CommonLang.msg("MSG344") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
             	return;
             }
             //단종이고 단종일때 단가 비노출이면 처리 불가능.
             if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
             	//해당 품목은 단종되었습니다.
<%--              	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
             	var text = "<%=CommonLang.msg("MSG117") %>";
        		openLayerPopText2(text,but1text,but1func,but1width);
             	return;
             }
             if(flag == "C"){
             	//MOQ 주문 통제 특수로직 적용한 고객사 한정
           		if(p060000077 == "true"){
           			if(Number(order_qty) < Number(st_min_order_qty)){
           				//최소주문수량에 맞게 수량을 설정해주세요.
           				var text = "<%=CommonLang.msg("MSG611")%>";
           		  		openLayerPopText2(text,but1text,but1func,but1width);
           				document.forms["contentForm"].st_order_qty.focus();
           				return;				
           			}            	
           		}
           		//주문배수 주문 통제 특수로직 적용한 고객사 한정
           		if(p060000089 == "true"){
           			var checkNum = order_qty%st_pur_unit_qty;
           			if(checkNum != 0 ){
           	       		//주문배수에 맞게 수량을 설정해주세요.
           	   			var text = "<%=CommonLang.msg("MSG609")%>";
           		  		openLayerPopText2(text,but1text,but1func,but1width);
           	       		document.forms["contentForm"].st_order_qty.focus();
           	       		return;				
           			}            	
           		}
                  if(!kepChkDecimal(order_qty,3)){
             	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
<%--                  alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                 var text = "<%=CommonLang.msg("MSG18") %>";
         		 openLayerPopText2(text,but1text,but1func,but1width);
                 document.forms["contentForm2"].st_order_qty.focus();
                 return;
             }
              }
             
              if(st_key_flag == "Y"){
            	//협력사 선택 팝업
            	 popupSel = flag+"saveProcess";
         		 var src = '/mdcm/getBuyerMdCmAgentChoicePop_v2.do?buyer='+byit_comorg_code+'&buyer_tem_no='+st_item_no+'&stdcatlg_id='+"";
         		 openLayerPop(src,"570px","620px");
         		 return;
             }else{
				query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
			}
     	}else{
            var order_qty     = document.forms["contentForm2"].st_order_qty[y_num].value;
            var st_agent_flag = document.forms["contentForm2"].st_agent_flag[y_num].value;
			var st_item_no   = document.forms["contentForm2"].st_item_no[y_num].value;
			var st_order_qty = document.forms["contentForm2"].st_order_qty[y_num].value;
			var st_agent     = document.forms["contentForm2"].st_agent_code[y_num].value;
			var contract_no  = document.forms["contentForm2"].st_contract_no[y_num].value;
			var contract_seq = document.forms["contentForm2"].st_contract_seq[y_num].value;
			var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code[y_num].value;
			var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty[y_num].value;
			var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty[y_num].value;
			//표준카탈로그 매핑 여부
			var st_stnd_flag = document.forms["contentForm2"].st_stnd_flag[y_num].value;
			//단종여부 
			var st_product_close_flag = document.forms["contentForm"].st_product_close_flag[y_num].value;
            if(contract_no == null || contract_no ==""|| contract_no =="PC"){
               	//계약정보 없는 품목은 등록이 불가능 합니다.
<%--                	alert( " <%=CommonLang.msg("MSG344") %> "); --%>
               	var text = "<%=CommonLang.msg("MSG344") %>";
        		 openLayerPopText2(text,but1text,but1func,but1width);
	        	return;
            }
            //단종이고 단종일때 단가 비노출이면 처리 불가능.
            if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
            	//해당 품목은 단종되었습니다.
<%--             	alert( "<%=CommonLang.msg("MSG117") %>"); --%>
            	var text = "<%=CommonLang.msg("MSG117") %>";
        		 openLayerPopText2(text,but1text,but1func,but1width);
            	return;
            }
            if(flag == "C"){
            	//MOQ 주문 통제 특수로직 적용한 고객사 한정
          		if(p060000077 == "true"){
          			if(Number(order_qty) < Number(st_min_order_qty)){
          				//최소주문수량에 맞게 수량을 설정해주세요.
          				var text = "<%=CommonLang.msg("MSG611")%>";
          		  		openLayerPopText2(text,but1text,but1func,but1width);
          				document.forms["contentForm"].st_order_qty[y_num].focus();
          				return;				
          			}            	
          		}
          		//주문배수 주문 통제 특수로직 적용한 고객사 한정
          		if(p060000089 == "true"){
          			var checkNum = order_qty%st_pur_unit_qty;
          			if(checkNum != 0 ){
          	       		//주문배수에 맞게 수량을 설정해주세요.
          	   			var text = "<%=CommonLang.msg("MSG609")%>";
          		  		openLayerPopText2(text,but1text,but1func,but1width);
          	       		document.forms["contentForm"].st_order_qty[y_num].focus();
          	       		return;				
          			}            	
          		}
          		if(!kepChkDecimal(order_qty,3)){
                 	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
    <%--                  alert( i+" <%=CommonLang.msg("MSG20") %>    "); --%>
                     var text = y_num+"<%=CommonLang.msg("MSG20") %>";
             		 openLayerPopText2(text,but1text,but1func,but1width);
                     document.forms["contentForm2"].st_order_qty[y_num].focus();
                     return;
                 }
             }
            var key_flag      = st_agent_flag.substr(0,2); 
            if(st_agent_flag == "MULTI_AGENT"){
            	var st_key_flag = "Y";
             }else{
                 var st_key_flag = "N";
             }
             
            if(st_key_flag == "Y"){
            	 //협력사 선택 팝업
            	 popupSel = flag+"saveProcess";
         		 var src = '/mdcm/getBuyerMdCmAgentChoicePop_v2.do?buyer='+byit_comorg_code+'&buyer_tem_no='+st_item_no+'&stdcatlg_id='+"";
         		 openLayerPop(src,"570px","620px");
         		 return;
             }else {
		  		query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		  		query += "&&";
			}
     	}
    }
    
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	kep_showConfirm();	   
 
}
 
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7){
	if(popupSel == "CsaveProcess"){
		$("#confirm1").val("CsaveProcess");
		$("#confirm2").val(value1);
		$("#confirm3").val("C");
		$("#confirm4").val("");
		kep_showConfirm();
	}else if(popupSel == "RsaveProcess"){
		$("#confirm1").val("RsaveProcess");
		$("#confirm2").val(value1);
		$("#confirm3").val("R");
		$("#confirm4").val("");
		kep_showConfirm();
	}else if(popupSel == "CsaveProcessMulti"){
		var query = $("#confirm2").val();
		query = query + value1;
		$("#confirm1").val("CsaveProcess");
		$("#confirm2").val(query);
		$("#confirm3").val("C");
		$("#confirm4").val("");
		kep_showConfirm();
	}else if(popupSel == "RsaveProcessMulti"){
		var query = $("#confirm2").val();
		query = query + value1;
		$("#confirm1").val("RsaveProcess");
		$("#confirm2").val(query);
		$("#confirm3").val("R");
		$("#confirm4").val("");
		kep_showConfirm();
	}
}

function kep_showConfirm(){
	
	
	var runFlag = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	
    var msg = "";
    if (runFlag == "CsaveProcess"){
    	runProcess(runFlag,query,flag);
<%--     	msg = "<%=CommonLang.msg("MSG557")%>";	//장바구니 --%>
//     	$("#confirmCartMsg").text(msg);
//     	$("#confirmCartArea").show();
//     	$("#confirmCartAreaOverlay").show();
    }else{
    	$("#confirmMyGroupMsg").text("<%=CommonLang.msg("MSG696")%>");	//관심상품으로 저장할 폴더를 선택해주세요.
    	$("#confirmMyGroupArea").show();
    	$("#confirmMyGroupAreaOverlay").show();
    }

//     $('body,html').animate({
// 		scrollTop: 0
// 	}, 100);
	
	
	
	 //runProcess(runFlag,query,flag);
}

// 계속검색
function kep_confrim_search(){
	var runFlag = $("#confirm1").val();
	$("#confirm4").val("search");
	$("#confirmCartArea").hide();
	$("#confirmCartAreaOverlay").hide();
	$("#confirmMyGroupArea").hide();
	$("#confirmMyGroupAreaOverlay").hide();
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
	$("#confirmCartAreaOverlay").hide();
	$("#confirmMyGroupArea").hide();
	$("#confirmMyGroupAreaOverlay").hide();
	if(runFlag == "CsaveProcess" || runFlag == "RsaveProcess"){
		runProcess();
	}else{
		runRqdtGplProcess();
	}
}

// 취소
function kep_confirm_cancel(){ 
	$("#st_my_groups_code").val("");
	const customSelect2 = document.getElementById("st_my_groups");
    const selectedValue2 = customSelect2.querySelector(".Selected-value");
    selectedValue2.textContent = "<%=CommonLang.get("HTITLE1065") %>"; //기본
	$("#confirm4").val("");	
	$("#confirmMyGroupArea").hide();
	$("#confirmMyGroupAreaOverlay").hide();
	
}

// 이미지 보이기 숨기기
function imageHideView(){ 
	if($("#image_status_check").is(":checked")){
		document.forms.searchForm.st_image_status.value = "IMAGE_HIDDEN";
		$(".PDimg").hide();
		$(".PDimgNo").show();
	}else{
		document.forms.searchForm.st_image_status.value = "IMAGE_VIEW";
		$(".PDimg").show();
		$(".PDimgNo").hide();
	}
	
// 	kepSearch($("#curPage").val());
}

// 조회
function kepSearch(curPage){
	document.forms.searchDiForm.st_tmp_categ_text.value = "<%=tmp_categ_text%>";
	document.forms.searchDiForm.st_image_status.value = document.forms.searchForm.st_image_status.value; 	
	document.forms.searchDiForm.onepagerow.value = document.forms.searchForm.onepagerow.value; 	 
	document.forms.searchDiForm.curPage.value = curPage;
	document.forms.searchDiForm.st_list_type.value = $("#st_list_type").val();
	
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
	
	$('#searchDiForm').attr("action", "/mdcm/getBuyerMdCmGoodsDiLisList.do").submit();   
}
//결과내재검색.
function resultKepSearch(curPage,event){
	if(event)
		event.preventDefault();
	if ( document.forms.searchForm.st_result_keyword.value == ""){
		//검색어를 입력하세요.
<%-- 		alert("<%=CommonLang.msg("MSG433")%>");	 --%>
		var text = "<%=CommonLang.msg("MSG433") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
		document.searchForm.st_result_keyword.focus();
		return;
	}	
	document.forms.searchDiForm.onepagerow.value = document.forms.searchForm.onepagerow.value; 	 
	document.forms.searchDiForm.resultKeyword.value = document.forms.searchForm.st_result_keyword.value;
	document.forms.searchDiForm.curPage.value = curPage; 
	document.forms.searchDiForm.st_list_type.value = $("#st_list_type").val(); 
	document.forms.searchDiForm.st_image_status.value = document.forms.searchForm.st_image_status.value;
	document.searchDiForm.st_research_flag.value = "Y";
	$('#searchDiForm').attr("action", "/mdcm/getBuyerMdCmGoodsDiLisList.do").submit();
	
}
function searchEnter(event){
	resultKepSearch("1",event);
}

/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:관심상품)
 
 */
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	var st_my_groups =$("#st_my_groups_code").val();
	//관심상품저장시 분류 저장
	if (gubun == "RsaveProcess"){ // 관심상품
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
        	var text = "<%=CommonLang.msg("MSG695")%>";//장바구니에 추가되었습니다.
        	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
        	var but2textC = "<%=CommonLang.get("HTITLE1122")%>"; //장바구니 가기
        	var but1funcC = "javascript:thisPopClose2(); return false;";
        	var but2funcC = "javascript:goCart(); return false;";
        	var but1widthC = "120px";
        	var but2widthC = "120px";
        	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
        	
       }else if(pMethod == "save")
       {
    	   var text = "<%=CommonLang.msg("MSG697")%>";//신규견적등록에 임시저장되었습니다.
	       	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
	       	var but2textC = "<%=CommonLang.get("HTITLE1123")%>"; //신규견적목록 확인
	       	var but1funcC = "javascript:thisPopClose2(); return false;";
	       	var but2funcC = "javascript:goGpl(); return false;";
	       	var but1widthC = "110px";
	       	var but2widthC = "140px";
	       	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
          
       	}else {
    	   //관심상품으로 등록 되었습니다.
<%--           alert("<%=CommonLang.msg("MSG23") %>   "); --%>
          var text = "<%=CommonLang.msg("MSG669") %>";
    		openLayerPopText2(text,but1text,but1funcSearch,but1width);
       	} 
      }else{
         if(pMethod == "CsaveProcess")
          {
        	var text = sMsg; //이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다.
         	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
         	var but2textC = "<%=CommonLang.get("HTITLE1122")%>"; //장바구니 가기
         	var but1funcC = "javascript:thisPopClose2(); return false;";
         	var but2funcC = "javascript:goCart(); return false;";
         	var but1widthC = "120px";
         	var but2widthC = "120px";
         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
          }else if (pMethod == "save"){ 
      		//견적 임시 저장 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
<%--      		 alert("<%=CommonLang.msg("MSG499") %>  ");  --%>
     		var text = "<%=CommonLang.msg("MSG499") %>";
      		openLayerPopText2(text,but1text,but1func,but1width);
     	  } else {
        	thisPopClose();
          }
         
     	 // 처리후 재조회
//      	 kepSearch($("#curPage").val());
         
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "CsaveProcess"){ 
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG26") %>  ";
   		 openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "RsaveProcess"){ 
		//관심상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG671") %>  ";
   		 openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "save"){ 
		//견적 임시 저장 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG499") %>  ";
   		 openLayerPopText2(text,but1text,but1func,but1width);
	}  
	 
	
} 
function goCart(){
	closePopText1();
	location.href = "<%=p060000036%>";
}
function goGpl(){
	closePopText1();
	location.href = "/mprq/showBuyerMpRqRequestQuotation_v2.do?menuId=br00101000000&tabIndex=2";
}
function thisPopClose(){
	closePopText2();
	var confirm4 = $("#confirm4").val();
	if (confirm4 == "search"){ 
     	 kepSearch($("#curPage").val());          	   
    }else if(confirm4 == "save"){
    	$('#locationForm2').attr("action", "/mprq/showBuyerMpRqRequestQuotation_v2.do?menuId=br00101000000&tabIndex=2").submit();
    }else{     
    	$('#locationForm2').attr("action", "/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit();   
    }
}

function thisPopClose2(){
	closePopText1();
	kepSearch($("#curPage").val());  
}
function listTypeChange(type){
	var listButton = document.getElementById("listButton");
	var imageButton = document.getElementById("imageButton");
	
	if(type == "list"){
		$("#st_list_type").val("list");
		$("#PDListType").show();
		$("#PDImageType").hide();
		listButton.classList.remove('ButListArray_off');
		listButton.classList.add('ButListArray_on');
		imageButton.classList.remove('ButListImg_on');
		imageButton.classList.add('ButListImg_off');
	}else{
		$("#st_list_type").val("image");
		$("#PDListType").hide();
		$("#PDImageType").show();
		listButton.classList.remove('ButListArray_on');
		listButton.classList.add('ButListArray_off');
		imageButton.classList.remove('ButListImg_off');
		imageButton.classList.add('ButListImg_on');
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
    var type = $("#st_list_type").val();
    if(type == "list"){
    	if(eval(tot_cnt) < 2){
         	 st_order_qty = document.forms["contentForm"].st_order_qty.value;
         	 if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
         			//품목의 주문수량(숫자)을 입력하여 주십시요.
   <%--       		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
         		 var text = "<%=CommonLang.msg("MSG120") %>  ";
         		 openLayerPopText2(text,but1text,but1func,but1width);
         		 document.forms["contentForm"].st_order_qty.value = "1";
         		 document.forms["contentForm"].st_order_qty.focus();
//          		 document.forms["contentForm"].st_sum_price_text.innerHTML = kepCommaNum(unit_price);
         		 $("#st_sum_price_text"+y_num).html(kepCommaNum(unit_price));
         	 }else{
                  st_sum_price = kepGetRound((order_qty * unit_price),3);
//                  document.forms["contentForm"].st_sum_price_text.innerHTML = kepCommaNum(st_sum_price);
                  $("#st_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
         	 }
       }else{
        	 st_order_qty = document.forms["contentForm"].st_order_qty[y_num].value;
         	 if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
         			//품목의 주문수량(숫자)을 입력하여 주십시요.
   <%--       		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
         		var text = "<%=CommonLang.msg("MSG120") %>  ";
        		 openLayerPopText2(text,but1text,but1func,but1width);
         		 document.forms["contentForm"].st_order_qty[y_num].value = "1";
         		 document.forms["contentForm"].st_order_qty[y_num].focus();
//          		document.forms["contentForm"].st_sum_price_text[y_num].innerHTML = kepCommaNum(unit_price);
         		$("#st_sum_price_text"+y_num).html(kepCommaNum(unit_price)); 
         	 }else{
                  st_sum_price = kepGetRound((order_qty * unit_price),3);
//                   document.forms["contentForm"].st_sum_price_text[y_num].innerHTML = kepCommaNum(st_sum_price);
                  $("#st_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
         	 }
       }
    }else{
    	if(eval(tot_cnt) < 2){
         	 st_order_qty = document.forms["contentForm2"].st_order_qty.value;
         	 if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
         			//품목의 주문수량(숫자)을 입력하여 주십시요.
   <%--       		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
         		 var text = "<%=CommonLang.msg("MSG120") %>  ";
         		 openLayerPopText2(text,but1text,but1func,but1width);
         		 document.forms["contentForm2"].st_order_qty.value = "1";
         		 document.forms["contentForm2"].st_order_qty.focus();
//          		document.forms["contentForm2"].st_sum_price_text.innerHTML = kepCommaNum(unit_price);
         		 $("#st_image_sum_price_text"+y_num).html(kepCommaNum(unit_price));
         	 }else{
                  st_sum_price = kepGetRound((order_qty * unit_price),3);
//                   document.forms["contentForm2"].st_sum_price_text.innerHTML = kepCommaNum(st_sum_price);
                  $("#st_image_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
         	 }
       }else{
        	 st_order_qty = document.forms["contentForm2"].st_order_qty[y_num].value;
         	 if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
         			//품목의 주문수량(숫자)을 입력하여 주십시요.
   <%--       		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
         		var text = "<%=CommonLang.msg("MSG120") %>  ";
        		 openLayerPopText2(text,but1text,but1func,but1width);
         		 document.forms["contentForm2"].st_order_qty[y_num].value = "1";
         		 document.forms["contentForm2"].st_order_qty[y_num].focus();
//          		document.forms["contentForm2"].st_sum_price_text[y_num].innerHTML = kepCommaNum(unit_price);
         		$("#st_image_sum_price_text"+y_num).html(kepCommaNum(unit_price)); 
         		
         	 }else{
                  st_sum_price = kepGetRound((order_qty * unit_price),3);
//                   document.forms["contentForm2"].st_sum_price_text[y_num].innerHTML = kepCommaNum(st_sum_price);
                  $("#st_image_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
         	 }
       }
    }
    
}

//주문수량 기능 g_gbn P: 주문수량 1 플러스/ M: 주문수량 1마이너스, pur_unit_qty : 주문배수
function getOrderQty(order_qty, y_num, unit_price, g_gbn, pur_unit_qty){
	var tot_cnt  = $("#display_item_cnt").val();
	var st_order_qty = ""; //주문수량
	var st_tobe_order = "";//변경후 주문수량
	var st_sum_price = "";//합계 금액
	
	var type = $("#st_list_type").val();
	if(type=="list"){
		if(eval(tot_cnt) < 2){
			st_order_qty = document.forms["contentForm"].st_order_qty.value;
			if(g_gbn == "P"){
				st_tobe_order = parseInt(st_order_qty) + parseInt(pur_unit_qty);
			}else if(g_gbn == "M"){
				st_tobe_order = parseInt(st_order_qty) - parseInt(pur_unit_qty);
				if(st_tobe_order < 1){
	      			//품목의 주문수량(숫자)을 입력하여 주십시요.
	<%-- 	      		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
		      		var text = "<%=CommonLang.msg("MSG120") %>  ";
		     		 openLayerPopText2(text,but1text,but1func,but1width);
		      		return;
				}
			}
			document.forms["contentForm"].st_order_qty.value =st_tobe_order;
			st_sum_price = kepGetRound((st_tobe_order * unit_price),3);
// 	        document.forms["contentForm"].st_sum_price_text.innerHTML = kepCommaNum(st_sum_price);
	        $("#st_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
	        
		}else{
			st_order_qty = document.forms["contentForm"].st_order_qty[y_num].value;
			if(g_gbn == "P"){
				st_tobe_order = parseInt(st_order_qty) + parseInt(pur_unit_qty);
			}else if(g_gbn == "M"){
				st_tobe_order = parseInt(st_order_qty) - parseInt(pur_unit_qty);
				if(st_tobe_order < 1){
	      			//품목의 주문수량(숫자)을 입력하여 주십시요.
	<%-- 	      		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
		      		var text = "<%=CommonLang.msg("MSG120") %>  ";
		     		 openLayerPopText2(text,but1text,but1func,but1width);
		      		 return;
				}
			}
			document.forms["contentForm"].st_order_qty[y_num].value =st_tobe_order;
			st_sum_price = kepGetRound((st_tobe_order * unit_price),3);
// 	        document.forms["contentForm"].st_sum_price_text[y_num].innerHTML = kepCommaNum(st_sum_price);
	        $("#st_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
		}
	}else{
		if(eval(tot_cnt) < 2){
			st_order_qty = document.forms["contentForm2"].st_order_qty.value;
			if(g_gbn == "P"){
				st_tobe_order = parseInt(st_order_qty) + parseInt(pur_unit_qty);
			}else if(g_gbn == "M"){
				st_tobe_order = parseInt(st_order_qty) - parseInt(pur_unit_qty);
				if(st_tobe_order < 1){
	      			//품목의 주문수량(숫자)을 입력하여 주십시요.
	<%-- 	      		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
		      		var text = "<%=CommonLang.msg("MSG120") %>  ";
		     		 openLayerPopText2(text,but1text,but1func,but1width);
		      		return;
				}
			}
			document.forms["contentForm2"].st_order_qty.value =st_tobe_order;
			st_sum_price = kepGetRound((st_tobe_order * unit_price),3);
// 	        document.forms["contentForm2"].st_sum_price_text.innerHTML = kepCommaNum(st_sum_price);
	        $("#st_image_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
		}else{
			st_order_qty = document.forms["contentForm2"].st_order_qty[y_num].value;
			if(g_gbn == "P"){
				st_tobe_order = parseInt(st_order_qty) + parseInt(pur_unit_qty);
			}else if(g_gbn == "M"){
				st_tobe_order = parseInt(st_order_qty) - parseInt(pur_unit_qty);
				if(st_tobe_order < 1){
	      			//품목의 주문수량(숫자)을 입력하여 주십시요.
	<%-- 	      		 alert("<%=CommonLang.msg("MSG120") %>  "); --%>
		      		var text = "<%=CommonLang.msg("MSG120") %>  ";
		     		 openLayerPopText2(text,but1text,but1func,but1width);
		      		 return;
				}
			}
			document.forms["contentForm2"].st_order_qty[y_num].value =st_tobe_order;
			st_sum_price = kepGetRound((st_tobe_order * unit_price),3);
// 	        document.forms["contentForm2"].st_sum_price_text[y_num].innerHTML = kepCommaNum(st_sum_price);
	        $("#st_image_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
		}
	}
	
	
}
</script>
</html>
