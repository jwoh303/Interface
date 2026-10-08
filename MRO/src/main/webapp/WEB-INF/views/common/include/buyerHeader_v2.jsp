<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.util.SeedCbcAlgorithmUtil"%>
<%@ page import="java.util.*"%> 
<%
	//메뉴
	String navi = (String)request.getAttribute("navi");
	String naviArr[] = navi.split("@");
	String categ = (String)request.getAttribute("cateList");
	String categArr[] = new String[2];
	if(!categ.equals("")){
		categArr = categ.split("@");
	}else{ //카테고리 없는 경우
		categArr[0] = "";
		categArr[1] = "";
	}
	
	SessionInfo _h_sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String h_usingCatalType = "";
	String h_bycaComorgCode = "";
	String h_comcode = "";
	String h_ciImg = "";
	String h_getAccessComorgLevel = ""; 
	String h_good_search_flag = "";
	String h_get_session_user_id = "";
	String h_userIDAuthCode = "";
	String h_get_session_user_lang = "";//로그인 사용자 언어 정보
	String h_chg_info_pwd_yn = "";
	if (_h_sessionInfo != null){
		h_usingCatalType =  CommonUtil.nvl((String)_h_sessionInfo.getUsingCatalType()); 	 // 사용카탈로그타입(1:전용 2:공통 3:둘다 , 재개발 A:전용 B:공통 C:둘다 , Z:전자입찰)
		h_bycaComorgCode =  CommonUtil.nvl((String)_h_sessionInfo.getBycaComorgCode()); 
		h_comcode =  CommonUtil.nvl((String)_h_sessionInfo.getComCode()); 
		h_ciImg =   CommonUtil.nvl((String)_h_sessionInfo.getCiImage());
		h_getAccessComorgLevel =   CommonUtil.nvl((String)_h_sessionInfo.getAccessComorgLevel());
		h_get_session_user_id =   CommonUtil.nvl((String)_h_sessionInfo.getUserId());
		h_userIDAuthCode = CommonUtil.getMD5Encrypt(h_get_session_user_id+"0949");
		h_get_session_user_lang = CommonUtil.nvl((String)_h_sessionInfo.getLang());
		h_chg_info_pwd_yn = CommonUtil.nvl((String)_h_sessionInfo.getChgInfoPwdYn(), ""); // 개인정보 클릭 시 비밀번호 인증 여부
	} 
	
	String h_searchTarget = CommonUtil.nvl((String) request.getParameter("searchTarget"),"ALL");   
	String h_searchTerm = CommonUtil.nvl((String) request.getParameter("searchTerm"),"");   
	
	String h_groupCategoryText = CommonUtil.nvl((String) request.getParameter("groupCategoryText"),"");   
	String h_groupMakerName = CommonUtil.nvl((String) request.getParameter("groupMakerName"),"");   
	String h_searchSort = CommonUtil.nvl((String) request.getParameter("searchSort"),"");    
	String h_st_image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");    
	String h_st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");
	String h_curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1");
	String h_onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"30");    
	
	String h_st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");   
	String h_st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");   
	String h_st_maker = CommonUtil.nvl((String) request.getParameter("st_maker"),"");   
	String h_st_categoty_name = CommonUtil.nvl((String) request.getParameter("st_categoty_name"),""); 
	String h_st_sub_flag = CommonUtil.nvl((String) request.getParameter("st_sub_flag"),"N"); 
	// IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다.  2014.11.26
	String h_searchTargetIDX_CATEGORY_NO = CommonUtil.nvl((String) request.getParameter("searchTargetIDX_CATEGORY_NO"),"");   
	String h_searchMode = CommonUtil.nvl((String) request.getParameter("searchMode"),"");   
	String h_comg_code = CommonUtil.nvl((String) request.getParameter("h_comg_code"),"");   
	String h_comg_code_val = CommonUtil.nvl((String) request.getParameter("h_comg_code_val"),"");   
	//결과내 재검색 관련
	String h_searchWhereStr =CommonUtil.nvl((String)request.getAttribute("searchWhereStr"),""); // 조회된 결과
	String h_searchKeyWord =CommonUtil.nvl((String)request.getAttribute("searchKeyWord"),""); // 검색어
	String h_searchResultKeyword =CommonUtil.nvl((String)request.getAttribute("searchResultKeyword"),""); // 결과내 재검색 키워드
	
	if ("".equals(h_comg_code) && "".equals(h_comg_code_val) ){
		h_comg_code = (String)request.getSession().getAttribute("h_comg_code");
	}else{ 
		 
		h_comg_code = h_comg_code_val;
		request.getSession().setAttribute("h_comg_code",h_comg_code);
		String [] h_comg_code_array = h_comg_code_val.split("@");
		if (h_comg_code_array != null){
			if (h_comg_code_array.length == 4){ 				
				//이수화학(주), 온산공장, 울산공장은 Select박스로 세션이동을 함(이수화학 그룹)
				_h_sessionInfo.setComCode(h_comg_code_array[0]);
				_h_sessionInfo.setComNameLoc(h_comg_code_array[1]);
				_h_sessionInfo.setBycaComorgLevel(h_comg_code_array[2]);
				_h_sessionInfo.setBycaComorgCode(h_comg_code_array[3]);
			 
			}
		}

	}
	
	 //SLOGIC-BEGIN(P06-0000036)
	String h_defaultUrl = "/mpso/getBuyerMpSoCartList.do";
	String h_p060000036 = CommonUtil.getSpecialCheckReturn(h_comcode,"P06-0000036","COL01_DATA", request); // 권한별URL
// 	String h_p060000036 = CommonUtil.getSpecialCheckReturn(h_comcode,"P06-0000036","COL01_DATA"); // 권한별URL
	if (h_p060000036 == null){
		h_p060000036 = h_defaultUrl;
	}else if ("".equals(h_p060000036)){
		h_p060000036 = h_defaultUrl;
	}
	//SLOGIC-END
	
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> h_shotcutSsso = (List<Map<String,String>>) request.getAttribute("shotcutSsso"); // 조회된 결과
	String h_SSO_COM_CODE = "";
	String h_SSO_USER_ID = "";
	String h_SSO_PASSWORD = "";
	Map<String,String> h_shotcutSssoData = null;
	if (h_shotcutSsso == null || h_shotcutSsso.size() == 0){
	}else{ 
	}
	
	// 나의 메뉴 목록 정보 LIST
	List<Map<String, String>> myMenuList = _h_sessionInfo.getMyMenuList();
	
	
	String h_sslurl = CommonUtil.getSslURL(request, "http");
	String h_sslurl2 = CommonUtil.getSslURL(request, "https");
	String h_devReal = CommonUtil.getDevRealLocalFlag(request);
	String flag = CommonUtil.getDevRealLocalFlag(request);
	String httpurl ="";
	String httpsurl ="";
	if(flag.equals("2")){
/* 		httpurl =  "http"+ "://" + request.getServerName() ;
		httpsurl = "https"+ "://" + request.getServerName() ; */
		httpurl =  "" ;
		httpsurl = "" ;	
	}else{
		httpurl =  "" ;
		httpsurl = "" ;		
	}
	//미계약 옵션 정보 조회.
	String strStndContractFlag = CommonUtil.getKepBuyerFlagColumnReturn(h_comcode, "STND_CONTRACT_FLAG");
	/*
	프로그램ID: PG_02_B_000834_008
	수정자: 현명환
	수정일: 2015.03.06
	펀치아웃 해당 내용 표시.
	*/
	boolean h_060000052 = CommonUtil.getSpecialCheckReturn(h_comcode,"P06-0000052");
	
	boolean h_060000084 = CommonUtil.getSpecialCheckReturn(h_comcode,"P06-0000084");
	boolean h_060000092 = CommonUtil.getSpecialCheckReturn(h_comcode,"P06-0000092");//검색엔진 자동완성 기능제거 고객사 특수로직.
	String h_060000084_type = "";
	if (h_060000084 == true) {
		h_060000084_type = CommonUtil.getSpecialCheckReturn(h_comcode,"P06-0000084","COL01_DATA");
	}
	
	// 통합ID 사용 고객사 사용자리스트
	String pass_ok = "N";
	// 통합ID 기능 사용여부 테크
	boolean getCod3= CommonUtil.getCode3CheckReturn("UNID", h_get_session_user_id, h_comcode);
	
	if(getCod3 == true){
		pass_ok = "Y";
	}
	
	boolean p170000003 = CommonUtil.getSpecialCheckReturn(h_comcode,"P17-0000003");// 고객사 크레텍책임 바로가기 링크(버튼) 활성화
	String p170000003_type = "";
	if (p170000003 == true) {
		p170000003_type = CommonUtil.getSpecialCheckReturn(h_comcode,"P17-0000003","COL01_DATA", request);
	}
	
	boolean bet00001 = CommonUtil.getSpecialCheckReturn(h_comcode,"BET00001");//헤더 외부링크 버튼
	String bet00001_type = "";
	if(bet00001 == true){
		bet00001_type = CommonUtil.getSpecialCheckReturn(h_comcode,"BET00001","COL01_DATA", request);
	}
	
	// 고객사별 미사용 메뉴 확인
	String menuUrl = "";
	Map<String, String> menuUrlInfo = CommonUtil.getIcomCode2ReturnMap(h_comcode,"NOTUSED","MENU"); 
    if (menuUrlInfo != null){
    	menuUrl= CommonUtil.nvl(menuUrlInfo.get("TEXT1"),"");
    }
%>
<div class="wrap">
  <!--headerwrap 시작-->
  <div class="headerwrap" id="headerwrap">
 	<section class="header">
 	<form name="loginForm" method="post">
            <input type="hidden" name="h_byca_comorg_code" id="h_byca_comorg_code"  value="<%=h_bycaComorgCode%>" />
            <input type="hidden" name="h_category_name1" id="h_category_name1"  />
            <input type="hidden" name="h_category_name2" id="h_category_name2"  />
            <input type="hidden" name="h_category_name3" id="h_category_name3"  />
        </form>
      <div class="Util">
        <ul>
        	<%
            // 통합ID 사용자 여부
            if(pass_ok.equals("Y")){
            %>
            <li><select name="union_id" id="union_id" class="Util_Select" onChange="userIdChange(this.value);" >
                <%=CommonUtil.getUnionUserIdList(h_comcode, "NO", "UNID",h_get_session_user_id, "ICOMCOD3", h_get_session_user_id, "") %>
            </select> 
            </li>
           <%}%>
            <li><a href="javascript:actionLogout();"><%=CommonLang.get("HTITLE989") %><!-- 로그아웃 --></a></li>
            
        </ul>
	  </div>
	  <h1><a href="/buyerMain.do"><img src="<%=h_ciImg %>" onError="this.src='/resources/imgs/logo.png';" alt="kep로고"/></a></h1>
      <div class="AllSearch-select" id="AllStatusSelect">
        <div class="AllSearch-box"><span class="AllSelected-value"><%=CommonLang.get("HTITLE29")%><!-- 전체 --></span></div>
        <ul class="AllSearch-options">
          <li data-value="ALL"><%=CommonLang.get("HTITLE29")%><!-- 전체 --></li>
          <li data-value="DESCRIPTION"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></li>
          <li data-value="SPECIFICATION"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></li>
          <li data-value="BUYER_ITEM_NO"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></li>
          <li data-value="MAKER_NAME"><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></li>
          <li data-value="CATEG_NAME"><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></li>
          <li data-value="AGENT"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></li>
        </ul>
	  </div> 
      <script>
        const customSelect_h = document.getElementById("AllStatusSelect");
        const selectBox_h = customSelect_h.querySelector(".AllSearch-box");
        const options_h = customSelect_h.querySelector(".AllSearch-options");
        const selectedValue_h = customSelect_h.querySelector(".AllSelected-value");
        
        
        // 열기/닫기
        selectBox_h.addEventListener("click", function() {
        	options_h.style.display = options_h.style.display === "block" ? "none" : "block";
        	selectBox_h.classList.toggle("active");
        });
        
        
        // 옵션 선택
        customSelect_h.querySelectorAll("li").forEach(function(option) {
          option.addEventListener("click", function() {
        	  selectedValue_h.textContent = option.textContent;
        	  options_h.style.display = "none";
        	  selectBox_h.classList.remove("active");
            $("#searchTargetSel").val(option.dataset.value)
//             console.log("선택된 값:", option.dataset.value);
          });
        });
        
        
        // 바깥 클릭 시 닫기
        document.addEventListener("click", function(e) {
          if (!customSelect_h.contains(e.target)) {
            options_h.style.display = "none";
            selectBox_h.classList.remove("active");
          }
        });
      </script>
      <div class="SearchWrapper" id="searchBox">
        <form name="searchDiForm"  id="searchDiForm" method="post" class="SearchForm">
                <input type="hidden" name="onepagerow" value="" /> 
                <input type="hidden" name="curPage" value="" /> 
                <input type="hidden" name="st_image_status" value="" /> 
                <input type="hidden" name="st_sort_change" value="" /> 
                <input type="hidden" name="st_sort_gubun" value="" />
                <input type="hidden" name="upperId" id="upperId"  value="b00100000000" /> 
                <input type="hidden" name="groupCategoryText" id="groupCategoryText"  value="<%=h_groupCategoryText%>" />
                <input type="hidden" name="groupMakerName" id="groupMakerName" value="<%=h_groupMakerName%>" />
                <input type="hidden" name="searchSort" id="searchSort"  value="<%=h_searchSort%>" /> 
                <input type="hidden"  name="st_description"  id="st_description" value="<%=h_st_description %>"  /> 
                <input type="hidden"  name="st_specification"  id="st_specification"  value="<%=h_st_specification %>"  /> 
                <input type="hidden"  name="st_maker"  id="st_maker"   value="<%=h_st_maker %>"  /> 
                <input type="hidden"  name="st_categoty_name"  id="st_categoty_name"  value="<%=h_st_categoty_name %>"   /> 
                <input type="hidden"  name="searchMode"  id="searchMode"  value="<%=h_searchMode %>"   /> 
                <input type="hidden"  name="searchTarget"  id="searchTarget"  value="<%=h_searchTarget %>"   />
                <input type="hidden"  name="st_research_flag"  id="st_research_flag"  value=""   />
                <input type="hidden"  name="st_contract_flag"  id="st_contract_flag"  value=""   />
                <input type="hidden"  name="resultKeyword"  id="resultKeyword"  value=""   />
				<input type="hidden" name="st_searchWhereStr" id="st_searchWhereStr"  value="<%=h_searchWhereStr%>" />
				<input type="hidden" name="searchKeyWord" id="searchKeyWord"  value="<%=h_searchKeyWord%>" />
                <input type="hidden"  name="searchTargetIDX_CATEGORY_NO"  id="searchTargetIDX_CATEGORY_NO"  value="<%=h_searchTargetIDX_CATEGORY_NO %>"   /> <!--   IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다. -->
                <input type="hidden" name="st_tmp_categ_text" value="" />
                <input type="hidden" name="st_no_contract_hidden_flag" value="" />
                <input type="hidden" name="st_sub_flag" id="st_sub_flag" value="<%=h_st_sub_flag %>" />
                <input type="hidden" name="st_list_type" id="st_list_type" value="" />
          <select name="searchTargetSel" id="searchTargetSel" style="display: none;">
            <option value="ALL" <%if ("ALL".equals(h_searchTarget)) {%>selected<%} %>><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
            <option value="DESCRIPTION" <%if ("DESCRIPTION".equals(h_searchTarget)) {%>selected<%} %>><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></option>
            <option value="SPECIFICATION" <%if ("SPECIFICATION".equals(h_searchTarget)) {%>selected<%} %>><%=CommonLang.get("HTITLE14")%><!-- 규격 --></option>
            <option value="BUYER_ITEM_NO" <%if ("BUYER_ITEM_NO".equals(h_searchTarget)) {%>selected<%} %>><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
            <option value="MAKER_NAME" <%if ("MAKER_NAME".equals(h_searchTarget)) {%>selected<%} %>><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></option>
            <option value="CATEG_NAME" <%if ("CATEG_NAME".equals(h_searchTarget)) {%>selected<%} %>><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></option>
            <option value="AGENT" <%if ("AGENT".equals(h_searchTarget)) {%>selected<%} %>><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></option>
          </select>
          <% //자동완성 로직 기능 제거
          if(h_060000092 ==true){ 
          %>
          <input type="text" placeholder="<%=CommonLang.msg("MSG433")%>" id="searchTerm" name="searchTerm" onKeyDown="if(event.keyCode==13){ event.stopPropagation(); actionBuyerMdCmGoodsDiLisList(event); };" value="<%=h_searchTerm%>" onFocus="kep_h_getBuyerMdCmGoodsDiAitoHidden()" autocomplete="off">
          <%}else{ %>
          <input type="text" placeholder="<%=CommonLang.msg("MSG433")%>" id="searchTerm" name="searchTerm" onKeyDown="if(event.keyCode==13){ event.stopPropagation(); actionBuyerMdCmGoodsDiLisList(event); };" value="<%=h_searchTerm%>" onkeyup="kep_h_getBuyerMdCmGoodsDiAitoLisList_v2(this.value)" autocomplete="off" onFocus="kep_h_getBuyerMdCmGoodsDiAitoHidden()">
          <%} %>
          <button type="button" onclick="javascript:actionBuyerMdCmGoodsDiLisList(); return false;"><img src="/resources/imgs/Search_icon.png" /></button>
        </form>
        <div class="DropdownArea" id="autoDiSearchView" style="display: none;">
		  	<ul class="TxtSearch" id="autoDiSearchList" >
	        </ul>
		</div>
        <div class="DropdownArea" id="dropdownArea" style="display: none;">
          <div class="RecentSearchesTit"><%=CommonLang.get("HTITLE986") %><!-- 최근 검색어 --></div>
          <ul id="searchList">
          </ul>
        </div>
      </div>
      <script>
		const searchInput = document.getElementById('searchTerm');
		const searchBox = document.getElementById('searchBox');
		
		// 포커스 시 확장
		searchInput.addEventListener('focus', function(){
		if(document.searchDiForm.searchTerm.value == ""){ //검색어 없을 때만 최근검색어 표시
			searchBox.classList.add('expanded');
			$("#autoDiSearchView").attr("style","display:none");
			$("#dropdownArea").attr("style","display:block");
			  openCookieKeyword();
		}
		});
		
		// 외부 클릭 시 닫기
		document.addEventListener('click', function(e){
		  if (!e.target.closest('#searchBox')) {
			searchBox.classList.remove('expanded');
			$("#dropdownArea").attr("style","display:none");
			$("#autoDiSearchView").attr("style","display:none");
		  }
		});
		
		// 최근 검색어 제거
		function removeItem(index) {
			var searchMyKeywordList = getKePCookie("searchMyKeywordList");
			if(searchMyKeywordList != null){
				arr = searchMyKeywordList.split("&&");	
			}
			var keywordTemp = "";
			for(var i = 0 ; i<arr.length; i++){
				if(index != i){ //삭제한 index 날려주기
					keywordTemp += arr[i] + "&&";
				}
			}
			setKePCookie("searchMyKeywordList", keywordTemp ,1);
			//다시 그려주기
			openCookieKeyword();
		}
		
		const searchTermInput = document.getElementById('searchTerm');

		//검색어쪽에 복붙할 때 앞에 공백 제거
		searchTermInput.addEventListener('paste', function(e) {
		  e.preventDefault();
		  const pasteData = (e.clipboardData || window.clipboardData).getData('text');
		  const trimmedData = pasteData.replace(/^[\t\s]+/, ''); // 앞쪽 탭/공백만 제거

		  const start = this.selectionStart;
		  const end = this.selectionEnd;
		  const value = this.value;

		  this.value = value.slice(0, start) + trimmedData + value.slice(end);

		  const cursorPos = start + trimmedData.length;
		  this.setSelectionRange(cursorPos, cursorPos);
		});
      </script>	  
      <div class="user_side">
        <ul>
        <%if(p170000003_type.equals("TYPE01")) { 	%>
        	<a href="http://ctx.cretec.kr/nctx/index.do" target="_blank"><li class="Cretec"><%=CommonLang.get("HTITLE1227")%><!--온라인주문--></li></a>
           <a href="<%=h_p060000036%>"><li class="UserCart"><p id="top_cart_cnt"><%=CommonUtil.getCartCnt_v2(request)%></p> <%=CommonLang.get("HTITLE161")%></li></a><!-- 장바구니 -->
           <a href="/main/showBuyerMyPage_v2.do"><li class="UserMyPage"><%=CommonLang.get("HTITLE987")%></li></a><!-- 마이페이지 -->
		<%} else if(p170000003_type.equals("TYPE02")) { 	%>
			<a a href="https://ctx.cretec.kr/CtxApp/ebook/index.do"  target="_blank"><li class="Cretec"><%=CommonLang.get("HTITLE553")%><!-- 카탈로그 --></li></a>
           <a href="<%=h_p060000036%>"><li class="UserCart"><p id="top_cart_cnt"><%=CommonUtil.getCartCnt_v2(request)%></p> <%=CommonLang.get("HTITLE161")%></li></a><!-- 장바구니 -->
           <a href="/main/showBuyerMyPage_v2.do"><li class="UserMyPage"><%=CommonLang.get("HTITLE987")%></li></a><!-- 마이페이지 -->
		<%} else if (bet00001_type.equals("TYPE01") ) { 	%>
			<a href="javascript:go_to_mall2();"><li class="UserPhone"><%=CommonLang.get("HTITLE1228")%><!--모바일전용몰--></li></a>
           <a href="<%=h_p060000036%>"><li class="UserCart"><p id="top_cart_cnt"><%=CommonUtil.getCartCnt_v2(request)%></p> <%=CommonLang.get("HTITLE161")%></li></a><!-- 장바구니 -->
           <a href="/main/showBuyerMyPage_v2.do"><li class="UserMyPage"><%=CommonLang.get("HTITLE987")%></li></a><!-- 마이페이지 -->
		<%}else{%>
<%--  		   <a href="#"><li class="UserLink"><%=CommonLang.get("HTITLE988")%><!-- 외부링크--></li></a> --%>
           <a href="<%=h_p060000036%>"><li class="UserCart"><p id="top_cart_cnt"><%=CommonUtil.getCartCnt_v2(request)%></p> <%=CommonLang.get("HTITLE161")%></li></a><!-- 장바구니 -->
           <a href="/main/showBuyerMyPage_v2.do"><li class="UserMyPage"><%=CommonLang.get("HTITLE987")%></li></a><!-- 마이페이지 -->
		<%} %>
           
        </ul>
      </div>
    </section>
	<!--TOP bar-->
    <nav class="nav">
      <div class="navigationBar">
        <div class="navigation" >
          <!-- 마이메뉴 -->
          <div class="MYmenu">
            <button class="menu-button"><%=CommonLang.get("HTITLE991") %><!-- MY MENU --></button>
            <div class="MYmenu-list">
              <p class="MYmenuTag"></p>
              <div class="MYmenuList">
                <ul id="MYmenuListEdit">
                <% if(myMenuList == null || myMenuList.size() == 0 ){ %>
                <%}else{ 
                	for(int inx = 0 ; inx < myMenuList.size() ; inx++){
            			Map<String, String> menuItem = myMenuList.get(inx);
                %>
                  <li><a href="javascript:kep_view_link('<%=CommonUtil.nvl((String) menuItem.get("URL")) %>?menuId=<%=CommonUtil.nvl((String) menuItem.get("MENU_ID")) %>&tabIndex=1');"><%=CommonUtil.nvl((String) menuItem.get("NAME")) %> </a></li>
                  	<%} %>
                <%} %>
                  <p class="MYmenuEdit" ><a href="javascript:showBuyerMyMenuPop();"><img src="/resources/imgs/setting.png" /> <%=CommonLang.get("HTITLE992") %><!-- 메뉴편집 --> </a></p>
                </ul>
              </div>
            </div>
          </div> 
		  <div class="Menubar">
            <ul id="MainMenu">
            </ul>
		  </div>
          <div class="Menusub-layer" id="MenusubLayer">
            <div class="Menusub-inner" id="MenusubInner">
                <!-- JavaScript로 소메뉴 삽입 -->
			</div>
		  </div> 
		  <script>
				const MainMenu = document.getElementById("MainMenu");
              const MenusubLayer = document.getElementById("MenusubLayer");
              const MenusubInner = document.getElementById("MenusubInner");
				const MainMenuTitles = [
					<%=naviArr[0]%>
				];
				
				const MainMenuLinks = [
					<%=naviArr[1]%>
				];
				
				const MainMenuId = [
                    <%=naviArr[2]%>
           		];
 
              const MenusubData = [
                    <%=naviArr[3]%>
              ];
              const MenuLinks = [
					<%=naviArr[4]%>
                ];
             
              const MenuId = [
					<%=naviArr[5]%>
       			];
           // 대메뉴 생성
      		
//            try {
        	   MainMenuTitles.forEach(function(title, idx){
             		
//            		  if(idx > 5){ //메뉴는 5개까지만 출력
//            		  	throw new Error("stop");
//            		  }
           		  const li=document.createElement("li");
           		  li.dataset.index=idx;
           		  li.textContent=title;
           		
//            		  const a=document.createElement("a");
//            		  a.href=MainMenuLinks[idx]+"?menuId="+MainMenuId[idx];
//            		  a.textContent=title;
//            		  li.appendChild(a);
           		
           		  MainMenu.appendChild(li);
           		});
// 		} catch (e) {
// 			// TODO: handle exception
// 		}
      		
      		
      	// 소메뉴 생성
            MenusubData.forEach(function(data, idx){
              const group = document.createElement("div");
              group.className = "Menusub-group";
              group.dataset.index = idx;
            
			const title = document.createElement("div");
			title.className = "title";
			
			const titleLink = document.createElement("div");
// 			titleLink.href = MainMenuLinks[idx]+"?menuId="+MainMenuId[idx]; // ✅ 메뉴 링크 직접 지정
			titleLink.textContent = MainMenuTitles[idx];
// 			titleLink.className = "navigationBar";
			
			title.appendChild(titleLink);
			group.appendChild(title);
            
//               if (idx === 5) {
//                 const Menusub2 = document.createElement("div");
//                 Menusub2.className = "Menusub2";
//                 data.forEach(function(section, sectionIdx) {
//                   const hasChildren = Array.isArray(section.children) && section.children.length > 0;
                  
//                   const mid = document.createElement("div");
//                   mid.className = "middle-title";
//                   mid.textContent = section.middle;
//                   if (section.children.length === 0) {
//                 	  mid.dataset.href = MenuLinks[idx][sectionIdx]?.middle + "?menuId="+MenuId[idx][sectionIdx]?.middle;
//                 	  mid.classList.add("navigationBar");

//                 	  mid.addEventListener("click", () => {
//                 	    location.href = mid.dataset.href;
//                 	  });
//                   }
                  
//                   Menusub2.appendChild(mid);
            
//                   const ul = document.createElement("ul");
//                   section.children.forEach(function(item, itemIdx){
//                     const li = document.createElement("li");
//                     const a = document.createElement("a");
//                     a.href = MenuLinks[idx][sectionIdx]?.children?.[itemIdx] + "?menuId="+MenuId[idx][sectionIdx]?.children?.[itemIdx];
//                     a.textContent = item;
//                     a.className = "navigationBar";
//                     li.appendChild(a);
//                     ul.appendChild(li);
//                   });
//                   Menusub2.appendChild(ul);
//                 });
//                 group.appendChild(Menusub2);
//               } else {
                const ul = document.createElement("ul");
                data.forEach(function(item, itemIdx) {
                  const li = document.createElement("li");
                  const a = document.createElement("a");
                  var linkUrl = MenuLinks[idx][itemIdx];
                  var separator = linkUrl.indexOf('?') >= 0 ? '&' : '?';
                  a.href = linkUrl + separator + "menuId="+MenuId[idx][itemIdx];
                  a.textContent = item;
                  a.className = "navigationBar";
                  li.appendChild(a);
                  ul.appendChild(li);
                });
                group.appendChild(ul);
//               }
            
              MenusubInner.appendChild(group);
            });
        
          
          // 클릭으로 레이어를 열 때, 레이어가 정지된 커서 아래에 나타나며
          // 발생하는 합성 mouseenter(잘못된 왼쪽 메뉴 강조)를 무시하기 위한 플래그.
          // 사용자가 실제로 마우스를 움직이면 해제되어 정상 hover 전환이 복구됨.
          var ignoreHoverUntilMove = false;

          document.querySelectorAll("#MainMenu li").forEach(function(li){
            li.addEventListener("mouseup", function(){
              const index = li.dataset.index;
              MenusubLayer.classList.add("show");
              activateMenu(index);                 // 클릭된 메뉴에 강조 강제 적용
              ignoreHoverUntilMove = true;         // 클릭 직후 합성 mouseenter 무시 시작
              document.addEventListener("mousemove", function onMove(){
                ignoreHoverUntilMove = false;      // 실제 이동 시 hover 정상화
                document.removeEventListener("mousemove", onMove);
              });
            });
          });

          document.querySelectorAll(".Menusub-group").forEach(function(group){
            group.addEventListener("mouseenter", function(){
              if (ignoreHoverUntilMove) return;    // 클릭 직후 커서 위치 기반 강조 무시
              const index = group.dataset.index;
              activateMenu(index);
            });
          });
        
          document.body.addEventListener("mouseleave", function() {
            MenusubLayer.classList.remove("show");
            document.querySelectorAll("#MainMenu li").forEach(function(el){ el.classList.remove("active")});
            document.querySelectorAll(".Menusub-group").forEach(function(el){el.classList.remove("highlight")});
            document.querySelectorAll(".Menusub-group .title").forEach(function(el){el.classList.remove("active")});
          });
        
          MenusubLayer.addEventListener("mouseleave", function() {
            MenusubLayer.classList.remove("show");
            document.querySelectorAll("#MainMenu li").forEach(function(el){el.classList.remove("active")});
            document.querySelectorAll(".Menusub-group").forEach(function(el){el.classList.remove("highlight")});
            document.querySelectorAll(".Menusub-group .title").forEach(function(el){el.classList.remove("active")});
          });
          
          function activateMenu(index) {
              document.querySelectorAll("#MainMenu li").forEach(function(el){el.classList.remove("active")});
              document.querySelectorAll(".Menusub-group").forEach(function(el) { el.classList.remove("highlight")});
              document.querySelectorAll(".Menusub-group .title").forEach(function(el){el.classList.remove("active")});
          
//               document.querySelector('.MainMenu li[data-index=\"'+index+'\"]').classList.add("active");
              const group = document.querySelector('.Menusub-group[data-index=\"'+index+'\"]');
              group.classList.add("highlight");
              group.querySelector(".title").classList.add("active");
            }
            </script>                                
 		  <!-- 카테고리 -->
		  <div class="category-container">
            <div style=" position:absolute; height:30px; height:11px; background: url(/resources/imgs/CategoryBox_top.png) no-repeat top center;"></div>
            <div class="category-button"><%=CommonLang.get("HTITLE510") %><!-- 카테고리 --></div>
            <div class="category-panel" id="categoryPanel" >
              <!-- 대분류 -->
              <div class="category-level" id="mainCategories" >
                <div class="category-class01"><%=CommonLang.get("HTITLE2") %><!-- 대분류 --></div>
<%--                 <%if() %> --%>
                <%=categArr[0] %>
              </div>
              <!-- 중분류 -->
              <div class="category-level" id="midCategories"></div>
              <div class="category-class02"><%=CommonLang.get("HTITLE3") %><!-- 중분류 --></div>
              <!-- 소분류 -->
              <div class="category-level" id="subCategories"></div>
              <div class="category-class03"><%=CommonLang.get("HTITLE4") %><!-- 소분류 --></div>
              <!-- 최종분류 (추가) -->
              <div class="category-level" id="finalCategories"></div>
              <div class="category-class04"><%=CommonLang.get("HTITLE5") %><!-- 최종분류 --></div>
			</div>
		  </div>
		  <script>
		  const data = {
				  <%=categArr[1] %>
				};
				
				const mainItems = document.querySelectorAll('#mainCategories .category-item');
				const midContainer = document.getElementById('midCategories');
				const subContainer = document.getElementById('subCategories');
				const finalContainer = document.getElementById('finalCategories');
				
				function clearActive(container) {
				  container.querySelectorAll('.category-item').forEach(function(i) { i.classList.remove('active')});
				}
				
				function updateMenu(midKey) {
				  mainItems.forEach(function(i){
						i.classList.toggle('active', i.dataset.mid === midKey)
				  });
				
				  midContainer.innerHTML = '';
				  subContainer.innerHTML = '';
				  finalContainer.innerHTML = '';
				
				  const mids = data[midKey];
				
				  Object.keys(mids).forEach(function(midName) {
					const midDiv = document.createElement('div');
					midDiv.className = 'category-item';
					const midNameArr = midName.split("#");
					if(midNameArr[0] == "ITM"){
						midDiv.innerHTML = "<a href='javascript:kep_sel_h_getItmeList_v2(\""+midNameArr[1]+"\",\""+midNameArr[2]+"\");'>"+midNameArr[3]+'</a><span class="arrow"></span>';
					}else{
						midDiv.innerHTML = midNameArr[3]+'<span class="arrow"></span>';
					}
// 					midDiv.innerHTML = midName+'<span class="arrow"></span>';
				
					midDiv.addEventListener('mouseover', function() {
					  clearActive(midContainer);
					  midDiv.classList.add('active');
					  updateSub(mids[midName]);
					});
				
					midContainer.appendChild(midDiv);
				  });
				
				  // 첫 중분류 자동 선택
// 				  const firstMid = midContainer.querySelector('.category-item');
// 				  if (firstMid) {
// 					firstMid.classList.add('active');
// 					updateSub(mids[firstMid.textContent.trim()]);
// 				  }
				}
				
				function updateSub(subData) {
				  subContainer.innerHTML = '';
				  finalContainer.innerHTML = '';
				
				  Object.keys(subData).forEach(function(subName) {
					const subDiv = document.createElement('div');
					subDiv.className = 'category-item';
					const subNameArr = subName.split("#");
					if(subNameArr[0] == "ITM"){
						subDiv.innerHTML = "<a href='javascript:kep_sel_h_getItmeList_v2(\""+subNameArr[1]+"\",\""+subNameArr[2]+"\");'>"+subNameArr[3]+'</a><span class="arrow"></span>';
					}else{
						subDiv.innerHTML = subNameArr[3]+'<span class="arrow"></span>';
					}
// 					subDiv.innerHTML = subName+'<span class="arrow"></span>';
				
					subDiv.addEventListener('mouseover', function() {
					  clearActive(subContainer);
					  subDiv.classList.add('active');
					  updateFinal(subData[subName]);
					});
				
					subContainer.appendChild(subDiv);
				  });
				
// 				  const firstSub = subContainer.querySelector('.category-item');
// 				  if (firstSub) {
// 					firstSub.classList.add('active');
// 					updateFinal(subData[firstSub.textContent.trim()]);
// 				  }
				}
				
				function updateFinal(finalList) {
				  finalContainer.innerHTML = '';
				  finalList.forEach(function(item){
					const finalDiv = document.createElement('div');
					finalDiv.className = 'category-item';
					const itemArr = item.split("#");
					if(itemArr[0] == "ITM"){
						finalDiv.innerHTML = "<a href='javascript:kep_sel_h_getItmeList_v2(\""+itemArr[1]+"\",\""+itemArr[2]+"\");'>"+itemArr[3]+'</a><span class="arrow"></span>';
					}else{
						finalDiv.innerHTML = itemArr[3]+'<span class="arrow"></span>';
					}
// 					finalDiv.textContent = item;
					finalContainer.appendChild(finalDiv);
				  });
				}
				
				// 대분류 hover
				mainItems.forEach(function(item) {
				  item.addEventListener('mouseover', function() {
					updateMenu(item.dataset.mid);
				  });
				});
				
				// 초기 로딩
				window.addEventListener('DOMContentLoaded', function() {
				  if (mainItems[0]) updateMenu(mainItems[0].dataset.mid);
				});
		  </script>   
		</div>
	  </div>    
	</nav>
  </div><!--headerwrap 끝-->
    <form name="buyerCategItemListLocation" id="buyerCategItemListLocation" method="post">
        <input type="hidden" name="buyerCategItemListLocation_categ_code" id="buyerCategItemListLocation_categ_code" />
        <input type="hidden" name="buyerCategItemListLocation_buyer" id="buyerCategItemListLocation_buyer"  value="<%=h_comcode %>"/>
        <input type="hidden" name="buyerCategItemListLocation_byca_comorg_code" id="buyerCategItemListLocation_byca_comorg_code" />
        <input type="hidden" name="buyerCategItemListLocation_company" id="buyerCategItemListLocation_company"  value="<%=h_comcode %>"/>
        <input type="hidden" name="upperId" id="upperId"  value="b00100000000"/> <!--  b00100000000 카테고리 검색 고정 -->
        <input type="hidden" name="onepagerow" id="onepagerow"  value="30"/>
        <!--상품상세 페이지 이동 param -->
        <input type="hidden" name="stdcateg_id" id="stdcateg_id"  value=""/>
        <input type="hidden" name="stdcatlg_id" id="stdcatlg_id"  value=""/>
        <input type="hidden" name="buyer" id="buyer"  value=""/>
        <input type="hidden" name="com_code" id="com_code"  value=""/>
        <input type="hidden" name="buyer_tem_no" id="buyer_tem_no"  value=""/>
        <input type="hidden" name="category_no" id="category_no"  value=""/>
        <input type="hidden" name="key_flag" id="key_flag"  value=""/>
        <input type="hidden" name="cata" id="cata"  value=""/>
    </form>
    <form name="ssoHeaderLogin" id="ssoHeaderLogin" method="post">
        <input type="hidden" name="userId" id="userId" value="" /> 
    </form>
    <form name="comgCodeForm" id="comgCodeForm" method="post">
    	<input type="hidden" name="h_comg_code_val" id="h_comg_code_val" value="" />  
    </form>
    <form name="punchoutexit" id="punchoutexit" method="post" accept-charset="UTF-8" onsubmit="emulAcceptCharset(this)">	
        <input type="hidden" name="cxml-urlencoded" id="cxml-urlencoded" value=""> 
    </form>

  <!--윙베너--> 
  <div class="wing-banner" id="wingBanner">
  <div class="RenewalGuide" id="renewalBtn"><p class="RenewalGuideTit"><span><%=CommonLang.msg("MSG993")%> <!-- 새로워진 --></span> <br/> <%=CommonLang.msg("MSG994")%> <!-- 사이트 안내 --> </p></div>
    <a href="<%=h_p060000036%>"><div class="cartbox"><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --> <p id="top_cart_cnt"><%=CommonUtil.getCartCnt(request)%></p></div></a>
    <div class="pdbox">
	  <div class="pd-header"><%=CommonLang.get("HTITLE990") %><!-- 최근 본 상품 --><p id="itemContainerCnt"></p></div>
	  <div class="viewed-items" id="itemContainer">
	  </div>
	  <div class="scroll-buttons">
        <button onclick="javascript:scrollItems(-1); return false;"><img src="/resources/imgs/arrow_left.png" alt="" /></button>
        <button onclick="javascript:scrollItems(1); return false;"><img src="/resources/imgs/arrow_right.png" alt="" /></button>
	  </div>        
	</div>
	<div class="TOPDOWN">
      <div class="buttonTOP"  onClick="window.scrollTo(0,0)"><%=CommonLang.get("HTITLE993") %><!-- TOP --></div>
      <div class="buttonDOWN" onClick="window.scrollTo({ top: document.body.scrollHeight})"><%=CommonLang.get("HTITLE994") %><!-- DOWN --></div>
	</div>
  </div>
  <script>
	const wing = document.getElementById('wingBanner');
	const nav = document.getElementById('navBar');
	
	window.addEventListener('scroll', function() {
	  if (!nav || !wing) return;
	  var navTop = nav.getBoundingClientRect().top;

	  if (navTop <= 0) {
		wing.classList.add('fixed');
	  } else {
		wing.classList.remove('fixed');
	  }
	});
	
	function scrollItems(direction) {
	  const container = document.getElementById('itemContainer');
	  const scrollAmount = 230;
	  container.scrollBy({
		top: scrollAmount * direction,
		behavior: 'smooth'
	  });
	}
  </script>
<!-- 리뉴얼안내 Popup -->
  <div class="RWPopup" id="RWPopup">
    <div class="RWBox">
      <div class="RW-visual"><h2 ><%=CommonLang.msg("MSG970")%> <!-- 코리아e플랫폼 사이트가 새롭게 개선되었습니다. --></h2> <button class="RWClose" id="RWClose"> ✕ </button></div>
      <div class="RW-content">
        <div class="RW-contentBox">
          <div class="titbold"> <img src="/resources/imgs/Check_blue_big.png"> <%=CommonLang.msg("MSG971")%> <!-- 먼저, 새로고침 해주세요. --></div>  
          <div class="txt"><span class="Red">Ctrl + Shift + R</span> <%=CommonLang.msg("MSG972")%> <!-- 을 동시에 누르면 이전 화면 기록을 지우고 최신 화면을 깔끔하게 다시 불러올 수 있어요. --></div>
        </div>
        <div class="RW-contentBox">
          <div class="titbold"> <img src="/resources/imgs/Check_blue_big.png"> <%=CommonLang.msg("MSG973")%> <!-- 화면(표)이 깨져 보이거나 어긋나 보인다면? --></div>  
          <div class="txt"> <%=CommonLang.msg("MSG974")%> <!-- PC 화면 설정에 따라 표가 겹쳐 보이거나 일부 항목이 가려질 수 있습니다. 아래와 같이 설정해 주세요. --><br/>
            - <%=CommonLang.msg("MSG975")%> <!-- Windows 설정 > 시스템 > 디스플레이 설정 > 텍스트, 앱 및 기타 항목의 크기 변경: 100% --><br/>
            - <%=CommonLang.msg("MSG976")%> <!-- 브라우저 화면 배율(Ctrl + 0 또는 Ctrl + -/+): 100% -->
          </div>
        </div>
        <div class="RW-contentBox">
          <div class="titbold"> <img src="/resources/imgs/Check_blue_big.png"> <%=CommonLang.msg("MSG977")%> <!-- 무엇이 좋아졌나요? --></div>  
          <div class="txt"> 
            <div class="txtBox"><span class="bold">⭐ <%=CommonLang.msg("MSG978")%> <!-- 메뉴가 보기 쉽게 정리되었습니다. --></span><br/><%=CommonLang.msg("MSG979")%> <!-- 메뉴 구조를 재정비하여 원하는 기능을 더 쉽고 빠르게 찾을 수 있습니다. --></div>
            <div class="txtBox"><span class="bold">⭐ <%=CommonLang.msg("MSG980")%> <!-- 한 화면에서 원하는 정보를 한눈에 볼 수 있습니다. --></span><br/><%=CommonLang.msg("MSG981")%> <!-- 관련 정보를 한 화면에 모아 확인·처리까지 가능하도록 개선하였습니다. --></div>
            <div class="txtBox">
              <div class="bold">⭐ <%=CommonLang.msg("MSG982")%> <!-- 표(리스트) 컬럼 기능이 새로워 졌습니다. --></div>
              <div class="boldsmall"><%=CommonLang.msg("MSG983")%> <!-- 1. 컬럼 이동 --></div>
              <%=CommonLang.msg("MSG984")%> <!-- 칸(컬럼)을 마우스로 끌어서 원하는 위치로 이동한 뒤 컬럼 정보 저장하면 이후 조회 시에도 동일한 순서로 볼 수 있습니다. --><br/>
              <img class="imggif" src="/resources/imgs/01.gif"><br/>

              <div class="boldsmall"> <%=CommonLang.msg("MSG985")%> <!-- 2. 컬럼 숨기기 --></div>
              <%=CommonLang.msg("MSG986")%> <!-- 우 클릭후 [컬럼설정] 버튼에서 필요 없는 칸을 숨기고, 보고 싶은 정보만 표시할 수 있습니다. --><br/>
              <img class="imggif" src="/resources/imgs/02.gif"><br/>

              <div class="boldsmall"> <%=CommonLang.msg("MSG987")%> <!-- 3. 컬럼 필터 --></div>
              <%=CommonLang.msg("MSG988")%> <!-- 필터행 사용 설정 시 조회된 데이터에서 원하는 값만 골라 볼 수 있습니다. --><br/>
              <img class="imggif" src="/resources/imgs/03.gif">
            </div>
          </div>
        </div>
        <div class="RW-contentBox">
          <div class="titbold"> <img src="/resources/imgs/Check_blue_big.png"> <%=CommonLang.msg("MSG989")%> <!-- 더 자세히 보고싶다면? --></div>  
          <div class="txt"><span class="Red"  onclick="window.open('/resources/html/main/notice/고객사매뉴얼_통합_v3.1.pdf', '_blank');" style="cursor: pointer;" > <%=CommonLang.msg("MSG990")%> <!-- [사용자 매뉴얼] --></span> <%=CommonLang.msg("MSG991")%> <!-- 에서 전체 기능을 한눈에 확인할 수 있어요. --></div>
        </div>
      </div> 
      <div class="RW-footer"><button type="button" class="ButPrimary_large" id="popupCloseX"><%=CommonLang.msg("MSG992")%> <!-- 확인하고 닫기 --></button></div> 
    </div>
  </div>
  <script>
    const popup = document.getElementById("RWPopup");
    const openBtn = document.getElementById("renewalBtn");
    const closeBtnRWPop = document.getElementById("RWClose");
    const closeX = document.getElementById('popupCloseX');
    

    function openPopup(){
        document.body.style.overflow="hidden";
        popup.classList.remove("hide");
        requestAnimationFrame(function(){
            popup.classList.add("show");
        });
    }
    function closePopup(){
        popup.classList.add("hide");
        popup.classList.remove("show");
        setTimeout(function(){
            document.body.style.overflow="";
        },450);
    }
    openBtn.addEventListener("click",openPopup);
    closeBtnRWPop.addEventListener("click",closePopup);
    closeX.addEventListener('click', closePopup);

    /* 배경 클릭 */
    popup.addEventListener("click",function(e){
        if(e.target===popup){
            closePopup();
        }
    });
    /* ESC */
    document.addEventListener("keydown",function(e){
        if(e.key==="Escape"){
            closePopup();
        }
    });

      
  </script>
<script type="text/javascript">

//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

<!-- 

$(document).ready(function(){
	
	$(".category-container").mouseup(function(){
		$(".category-panel").css({"opacity":"1","visibility":"visible","transform":"translateY(0)","pointer-events":"auto"});
	})
	$(".category-container").mouseleave(function(){
		$(".category-panel").css({"opacity":"0","visibility":"hidden","transform":"translateY(10px)","pointer-events":"none"});
	})
	
	//선택한 값으로 셋팅
	var customSelect2_h = document.getElementById("AllStatusSelect");
    var selectedValue2_h = customSelect2_h.querySelector(".AllSelected-value");
    $("#searchTargetSel").val("ALL"); //검색 후 무조건 전체 로 선택되게 수정
    selectedValue2_h.textContent = $("#searchTargetSel option:checked").text();
	
	openCookieItem();	
});
//오늘본 상품
function openCookieItem() {	
	var arr = "";
	var searchMyItemList = getKePCookie("searchMyItemList");
	if(searchMyItemList != null){
		arr = searchMyItemList.split("&&");	
	}
	var tableBody	=	""; 
	var strArrLength =  arr.length-1;
	if(strArrLength > 9){ //최대 9개까지만 노출
		strArrLength = 9;
	}
	$("#itemContainerCnt").text(strArrLength);
	
	$('#itemContainer *').remove();
	if(strArrLength == 0){
		tableBody += "<div class='item'><a href='#'>"+"<%=CommonLang.msg("MSG603")%>"+"</a></div>"; //최근 본 상품이 없습니다.
	}else{
		for(var i = 0; i < strArrLength; i++){
// 			if(strArrLength > i){
				var strArry = arr[i].split("@@");
// 				if(strArry[1] ==null){
// 					tableBody += "<div class='item'><a href='#'>최근 본 상품이 없습니다.</a></div>";
// 				}else{
					tableBody += "<div class='item'><a href=\"javascript:getHearderCatalogDetail('"+strArry[0]+"','"+ strArry[1]+"','"+ strArry[2]+"','"+ strArry[3]+"','"+ strArry[4] +"','"+ strArry[5] +"','"+strArry[6] +"');\"><span>"+strArry[3]+"</span><br/>"+strArry[9]+"<br/></a></div>";
// 				}
// 			}else{		
// 				tableBody += "<div class='item'><a href='#'>최근 본 상품이 없습니다.</a></div>";
// 			}			
		}
	}
	
// 	tableBody +="<div class='ViewPD_Btn'><a href=\"javascript:getPreGoodsItem();\"><img src='/resources/images/ViewPD_left.gif'/></a> <a href=\"javascript:getNextGoodsItem();\"><img src='/resources/images/ViewPD_right.gif' /></a></div>";
	$("#itemContainer").append(tableBody);
}
//화면이동
function getHearderCatalogDetail(stdcateg_id,stdcatlg_id,buyer,org_buyer_item_no,category_no,key_flag,cata){
    var key_flag     = key_flag.substr(0,2);
    var st_key_flag ="";
    if(key_flag == "MULTI_AGENT"){
        st_key_flag = "Y";
    }else{
        st_key_flag = "N";
    }    
	document.buyerCategItemListLocation.stdcateg_id.value = stdcateg_id; // 표준카테고리ID
	document.buyerCategItemListLocation.stdcatlg_id.value = stdcatlg_id; // 표준카탈로그ID
	document.buyerCategItemListLocation.buyer.value = buyer;
	document.buyerCategItemListLocation.com_code.value = buyer;
	document.buyerCategItemListLocation.buyer_tem_no.value = org_buyer_item_no;
	document.buyerCategItemListLocation.category_no.value = category_no; // 카테고리번호
	document.buyerCategItemListLocation.key_flag.value = st_key_flag;
	document.buyerCategItemListLocation.cata.value = cata;
	$('#buyerCategItemListLocation').attr("action", "/mdcm/getBuyerMdCmGoodsLisDetail.do").submit();   
}

function openCookieKeyword() {
	var arr = "";
	var searchMyKeywordList = getKePCookie("searchMyKeywordList");
	if(searchMyKeywordList != null){
		arr = searchMyKeywordList.split("&&");	
	}	
	var tableBody	=	""; 
	$('#searchList *').remove();
	if(arr.length == 0){
		tableBody += '<div class="NoSearchesTit">'+"<%=CommonLang.msg("MSG654")%>"+'</div>'; //최근 검색어가 없어요.
	}else{
		if(arr[0] == ""){
			tableBody += '<div class="NoSearchesTit">'+"<%=CommonLang.msg("MSG654")%>"+'</div>';//최근 검색어가 없어요. 
		}else{
			if(arr.length > 5) //최대 5개까지만 출력
				arr.length = 5;
			for(var i = 0; i < arr.length; i++){
				if(arr[i] == ""){
					break;
				}
				if(i == 3){
					tableBody += '<br/>';
				}
				tableBody += '<li><a href="javascript:actionBuyerMdCmGoodsDiLisListKeywordClick(\''+arr[i]+'\');"><span>'+arr[i]+'</span></a><button onClick="removeItem('+i+')">X</button></li>';
			}
		}
		
	}
		
// 	tableBody +="<div class='ViewPD_Btn'><a href=\"javascript:getPreGoodsItem();\"><img src='/resources/images/ViewPD_left.gif'/></a> <a href=\"javascript:getNextGoodsItem();\"><img src='/resources/images/ViewPD_right.gif' /></a></div>";
	$("#searchList").append(tableBody);
}
function actionLogin() {
	if (document.loginForm.userId.value == "") {
<%-- 		alert("<%=CommonLang.msg("MSG430")%>");	//아이디를 입력하세요 --%>
		var text = "<%=CommonLang.msg("MSG430")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} else if (document.loginForm.password.value == "") {
<%-- 		alert("<%=CommonLang.msg("MSG431")%>");	//비밀번호를 입력하세요 --%>
		var text = "<%=CommonLang.msg("MSG431")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} else {
		document.loginForm.action = "/login/login.do";
		document.loginForm.submit();
	}
}
//IP로그아웃
function setLogoutSessionInfo(){
	//화면으로 돌아가시겠습니까?
<%--     if(!confirm(" IProcurement <%=CommonLang.msg("MSG432")%>     ")) return; --%>
	
    var text = "IProcurement <%=CommonLang.msg("MSG432")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:setLogoutSessionInfoProcess; return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function setLogoutSessionInfoProcess(){
	closePopText1();
	top.opener = self;
	top. window.close();

	document.loginForm.submit();
	
}
function actionLogout() {
	document.loginForm.action = "/login/logout.do";
	document.loginForm.submit();
}
function actionBuyerMdCmPCODiLisList() { 	
	
	if ( document.searchDiForm.searchTerm.value == ""){
<%-- 		alert("<%=CommonLang.msg("MSG433")%>");	//검색어를 입력하세요. --%>
		var text = "<%=CommonLang.msg("MSG433")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		document.searchDiForm.searchTerm.focus();
		return;
	}	
	document.searchDiForm.onepagerow.value = "30";
	document.searchDiForm.curPage.value = "1";
	document.searchDiForm.st_image_status.value = "";
	document.searchDiForm.groupCategoryText.value = "";
	document.searchDiForm.groupMakerName.value = "";
	document.searchDiForm.searchSort.value = "WEIGHT";
	document.searchDiForm.st_sort_change.value = "";	 
	document.searchDiForm.st_description.value = "";	 
	document.searchDiForm.st_specification.value = "";	 
	document.searchDiForm.st_maker.value = "";	 
	document.searchDiForm.st_categoty_name.value = "";	 
	document.searchDiForm.searchMode.value = "";	 
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.action = "/mdcm/getBuyerMdCmPCODiLisList.do";
	document.searchDiForm.submit();
}

function actionBuyerMdCmGoodsDiLisList(event,recommendYn) {
	if(event)
		event.preventDefault();
	
	if ( document.searchDiForm.searchTerm.value == ""){
<%-- 		alert("<%=CommonLang.msg("MSG433")%>");	//검색어를 입력하세요. --%>
		var text = "<%=CommonLang.msg("MSG433")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		document.searchDiForm.searchTerm.focus();
		return;
	}
	<%if(strStndContractFlag.equals("Y")){ %>
	if(recommendYn == "Y"){
		document.searchDiForm.st_contract_flag.value = "Y";	
	}else{
		document.searchDiForm.st_contract_flag.value = "N";
	}
	<%}%>
	//키워드 저장(최근 검색어 만들기 위함)
	var searchMyKeywordList = getKePCookie("searchMyKeywordList");
	if(searchMyKeywordList != null){
		arr = searchMyKeywordList.split("&&");	
	}
	var keywordTemp = "";
	for(var i = 0 ; i<arr.length; i++){
		if(arr[i] != document.searchDiForm.searchTerm.value){ //최근검색어에 해당 검색어 있으면 빼고 저장
			keywordTemp += arr[i] + "&&";
		}
	}
	keywordTemp = document.searchDiForm.searchTerm.value+"&&"+keywordTemp;
	setKePCookie("searchMyKeywordList", keywordTemp ,1);
	
// 	var searchMyKeywordList = getKePCookie("searchMyKeywordList"); 
// 	searchMyKeywordList = document.searchDiForm.searchTerm.value+"&&"+searchMyKeywordList;
// 	setKePCookie("searchMyKeywordList", searchMyKeywordList ,1);
	
	document.searchDiForm.st_research_flag.value = "N";
	document.searchDiForm.onepagerow.value = "";
	document.searchDiForm.curPage.value = "1";
	document.searchDiForm.st_image_status.value = "";
	document.searchDiForm.groupCategoryText.value = "";
	document.searchDiForm.groupMakerName.value = "";
	document.searchDiForm.searchSort.value = "WEIGHT";
	document.searchDiForm.st_sort_change.value = "";	 
	document.searchDiForm.st_description.value = "";	 
	document.searchDiForm.st_specification.value = "";	 
	document.searchDiForm.st_maker.value = "";	 
	document.searchDiForm.st_categoty_name.value = "";	 
	document.searchDiForm.searchMode.value = "";	 
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";
	document.searchDiForm.searchTarget.value = $("#searchTargetSel").val();
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiForm.submit();
}
function actionBuyerMdCmGoodsDiLisListKeywordClick(keyword) { //최근검색어에서 검색어 클릭 시 검색
	document.searchDiForm.searchTerm.value = keyword;
	document.searchDiForm.st_research_flag.value = "N";
	document.searchDiForm.onepagerow.value = "30";
	document.searchDiForm.curPage.value = "1";
	document.searchDiForm.st_image_status.value = "";
	document.searchDiForm.groupCategoryText.value = "";
	document.searchDiForm.groupMakerName.value = "";
	document.searchDiForm.searchSort.value = "WEIGHT";
	document.searchDiForm.st_sort_change.value = "";	 
	document.searchDiForm.st_description.value = "";	 
	document.searchDiForm.st_specification.value = "";	 
	document.searchDiForm.st_maker.value = "";	 
	document.searchDiForm.st_categoty_name.value = "";	 
	document.searchDiForm.searchMode.value = "";	 
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiForm.submit();
}
function actionBuyerMdCmGoodsDiLisList2() { 	  
	<%
	//SLOGIC-BEGIN(P06-0000052)
	//펀치아웃
	if(h_060000052 == true) {
	%>
	document.searchDiForm.st_research_flag.value = "N";
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiForm.action = "/mdcm/getBuyerMdCmPCODiLisList.do";
	document.searchDiForm.submit();
	<%}else{%>
	document.searchDiForm.st_research_flag.value = "N";
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiForm.submit();
	<%}%>
} 

function actionBuyerMdCmGoodsDiLisList3(searchTarget,searchTerm) { 	 
	//키워드 저장(최근 검색어 만들기 위함)
	var searchMyKeywordList = getKePCookie("searchMyKeywordList");
	if(searchMyKeywordList != null){
		arr = searchMyKeywordList.split("&&");	
	}
	var keywordTemp = "";
	for(var i = 0 ; i<arr.length; i++){
		if(arr[i] != searchTerm){ //최근검색어에 해당 검색어 있으면 빼고 저장
			keywordTemp += arr[i] + "&&";
		}
	}
	keywordTemp = searchTerm+"&&"+keywordTemp;
	setKePCookie("searchMyKeywordList", keywordTemp ,1);
	
	
// 	var searchMyKeywordList = getKePCookie("searchMyKeywordList"); 
// 	searchMyKeywordList = searchTerm+"&&"+searchMyKeywordList;
// 	setKePCookie("searchMyKeywordList", searchMyKeywordList ,1);
	
	<%
	//SLOGIC-BEGIN(P06-0000052)
	//펀치아웃
	if(h_060000052 == true) {
	%>
		document.searchDiForm.upperId.value = "b00100000000";
		document.searchDiForm.searchTarget.value = searchTarget;	 
		document.searchDiForm.searchTerm.value = searchTerm;	 
		document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
		document.searchDiForm.action = "/mdcm/getBuyerMdCmPCODiLisList.do";
		document.searchDiForm.submit();
	<%}else{%>
		document.searchDiForm.upperId.value = "b00100000000";
		document.searchDiForm.searchTarget.value = searchTarget;	 
		document.searchDiForm.searchTerm.value = searchTerm;	 
		document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
		document.searchDiForm.action = "/mdcm/getBuyerMdCmGoodsDiLisList.do";
		document.searchDiForm.submit();
	<%}%>
}

function leftShowTopHidden(flag) { 
	if (flag == "onload_show" || flag == "show") { 
		  if ($("#lnbArea").css("display") == "none"){
			$("#lnbArea").show();
		  }else{
			  $("#lnbArea").hide();
		  }
	} else { 
		$("#lnbArea").hide();
	}  
}

function goMroCheckHeader(com_code, user_id)
{ 
    document.ssoHeaderLogin.userId.value = user_id;
    $('#ssoHeaderLogin').attr("action", "/login/office_login.do").submit();
}

function showBuyerMyMenuPop(){
	openSearchPopup("/none/showCommonNoNeMyMenuPop_v2.do", "", "800,600,no");
// 	openSearchPopup("/none/showCommonNoNeBuyerMyMenuPop.do", "?1=1", "878,579,no");
}
		
function kep_view_link(link){
	var link_split = link.split("?");
	var fullUrl = "<%=menuUrl%>";
	var targetUrl = link_split[0]; //
	if(fullUrl.indexOf(targetUrl) >= 0){
		// 해당 메뉴로 접근할 수 없습니다(고객사 미사용)
<%-- 		alert("<%=CommonLang.msg("MSG583")%>"); --%>
		var text = "<%=CommonLang.msg("MSG583")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if (link.indexOf("#")>=0 || link.indexOf("null")>=0){
		return;
	}
	window.location.href = "<%=httpurl%>"+link;
}

//이수화학(주), 온산공장, 울산공장은 Select박스로 세션이동을 함(이수화학 그룹)
function setChange()
{ 
    document.comgCodeForm.h_comg_code_val.value = kepSelectOptionVal("h_comg_code"); 
    $('#comgCodeForm').attr("action", "/buyerMain.do").submit();      
}

// 통합사용자ID 변경 로그인
function userIdChange(userId){
	document.ssoHeaderLogin.userId.value = userId;
    $('#ssoHeaderLogin').attr("action", "/login/office_login.do").submit();
}

function OpenWindowWithPost(url, name, params)
{
	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("action", url);
	form.setAttribute("target", name);
	for (var i in params)
	{
		var input = document.createElement('input');
		input.type = 'hidden';
		input.name = params[i].key;
		input.value = params[i].value;
		form.appendChild(input);
	}
	document.body.appendChild(form);
	form.submit();
	document.body.removeChild(form);
}

function go_to_mall(){
	var strUserID = "<%=h_get_session_user_id%>";
	var params = []; 
	//서브도메인 셋팅후 url 서브도메인으로 변경해 주시면 됩니다.
	var url = "http://kep-giftshop.com/login_x.asp";    

	params.push({ key: "userid", value: strUserID });

	OpenWindowWithPost(url, "B2B_MALL", params);
}
function go_to_mall2(){
	var strUserAuth = "<%=h_userIDAuthCode%>";
	var strUserID = "<%=h_get_session_user_id%>";
	//POST 방식 테스트 확인.
	var params = []; 
	//서브도메인 셋팅후 url 서브도메인으로 변경해 주시면 됩니다.
	var url = "https://land.u2okorea.com";    
	params.push({ key: "mid", value: strUserID });
	params.push({ key: "auth_code", value: strUserAuth });
	OpenWindowWithPost(url, "KEP_SHOP", params);
	return;
}
function getPunchoutURLandExit(){

  	$.ajax({
	  type: "POST",
      //dataType:"json",
      url: "/mpso/getPunchoutURL.do",
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      //data: {"buyer":_buyer, "userid":_userid},
      //async : false,
      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT 
      success:function( response ) {
    	  var _form = document.forms.punchoutexit;

    	  _form.action = response.msg.pURL;
    	  _form.target = "_top";
    	  _form.submit();
      },
      error:function( response ) {
<%-- 		  alert("Exit URL<%=CommonLang.msg("MSG528")%>");	//을 찾지 못했습니다. --%>
		  var text = "Exit URL<%=CommonLang.msg("MSG528")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
	   }
 	 });	
}
function emulAcceptCharset(form) {
    if (form.canHaveHTML) { // detect IE
        document.charset = form.acceptCharset;
    }
    return true;
}

function setMenu(dataList){
	 //가져온 메뉴 리스트 가지고 나의메뉴 수정
	 $("#MYmenuListEdit").empty();
	 dataList.forEach(function(item){
		 var url = item.URL+"?menuId="+item.MENU_ID+"&tabIndex=1"; //메뉴아이디 파라미터로 같이 넘김
		 var aTag = $('<a>').attr('href',"javascript:kep_view_link('"+url+"');").text(item.NAME);
		 var liTag = $('<li>').append(aTag);
		 $("#MYmenuListEdit").append(liTag);
	 })
	 var editHtml = '<p class="MYmenuEdit" ><a href="javascript:showBuyerMyMenuPop();"><img src="/resources/imgs/setting.png" /> 메뉴편집 </a></p>';
	 $("#MYmenuListEdit").append(editHtml);
}


//-->
</script>
