<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.util.SeedCbcAlgorithmUtil"%>
<%@ page import="java.util.*"%> 
<%
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
	String h_onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");    
	
	String h_st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");   
	String h_st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");   
	String h_st_maker = CommonUtil.nvl((String) request.getParameter("st_maker"),"");   
	String h_st_categoty_name = CommonUtil.nvl((String) request.getParameter("st_categoty_name"),"");   
	// IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다.  2014.11.26
	String h_searchTargetIDX_CATEGORY_NO = CommonUtil.nvl((String) request.getParameter("searchTargetIDX_CATEGORY_NO"),"");   
	String h_searchMode = CommonUtil.nvl((String) request.getParameter("searchMode"),"");   
	String h_comg_code = CommonUtil.nvl((String) request.getParameter("h_comg_code"),"");   
	String h_comg_code_val = CommonUtil.nvl((String) request.getParameter("h_comg_code_val"),"");   
	//결과네 재검색 관련
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
	String h_defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
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
	
	// 고객사별 미사용 메뉴 확인
	String menuUrl = "";
	Map<String, String> menuUrlInfo = CommonUtil.getIcomCode2ReturnMap(h_comcode,"NOTUSED","MENU"); 
    if (menuUrlInfo != null){
    	menuUrl= CommonUtil.nvl(menuUrlInfo.get("TEXT1"),"");
    }
%>
<div class="ViewPD_Left">
 <div class="ViewPD_LeftTit"> 최근본상품</div>
    <div class="ViewPD_List"  id="openProduct">
    </div>
    <img src="/resources/images/top.jpg" style="margin-top: 9px; cursor: pointer;" onclick="window.scrollTo(0,0)">
	<img src="/resources/images/down.jpg" style=" cursor: pointer;" onclick="window.scrollTo({ top: document.body.scrollHeight})">
	
</div>
<div id="wrapper">
	<div class="HeaderWrap">
		<form name="loginForm" method="post">
            <input type="hidden" name="h_byca_comorg_code" id="h_byca_comorg_code"  value="<%=h_bycaComorgCode%>" />
            <input type="hidden" name="h_category_name1" id="h_category_name1"  />
            <input type="hidden" name="h_category_name2" id="h_category_name2"  />
            <input type="hidden" name="h_category_name3" id="h_category_name3"  />
        </form>
        <div class="HeaderGlobal">
            <!--로그인후-->
            <c:choose>
                <c:when test="${sessionInfo != null }">
                    <ul class="GlobalMenu">
                    	<li><%=CommonLang.get("HTITLE930")%>:<!-- 최종접속 --> <span class="black">${sessionInfo.lastLoginDate}</span></li>
                        <li>${sessionInfo.comNameLoc} ${sessionInfo.userNameLoc} [<span class="black">${sessionInfo.userId}</span>] <%=CommonLang.get("HTITLE736")%><!-- 님 --></li>
                        <%
						//SLOGIC-BEGIN(P06-0000052)
						if(h_060000052 == false) {
						%>
							<%
							if("Y".equals(h_chg_info_pwd_yn)){
							%>
								<li><a href="/main/sub_pw_insert.do"><%=CommonLang.get("HTITLE445")%><!-- 개인정보 --></a></li>
							<%
							}else{
							%>
								<li><a href="/mdam/showBuyerMdAmUserInfo.do?upperId=b00000000000&leftMenu=N"><%=CommonLang.get("HTITLE445")%><!-- 개인정보 --></a></li>
							<%
							}
							%>
                        	<li><a href="/mdam/showBuyerMdAmCmpyInfo.do?upperId=b00000000000&leftMenu=N"><%=CommonLang.get("HTITLE737")%><!-- 회사정보 --></a></li>
                        <%} %>
                        <%
                        //언어타입이 영어일 경우 FAQ 미표기
                        if(!h_get_session_user_lang.equals("EN")) {
                        %>                    
                        <li><a href="javascript:faqpopup();">FAQ</a></li>
                        <%} %>
                         <li><a href="/main/getCustomerCenterList.do?upperId=b00000000000"><%=CommonLang.get("HTITLE739")%><!-- 고객센터 --></a></li>
                        <%
                        // 통합ID 사용자 여부
                        if(pass_ok.equals("Y")){
                        %>
                        <li>
                            <select name="union_id"  id="union_id" style="width:100%"  onChange="userIdChange(this.value);">
                                <%=CommonUtil.getUnionUserIdList(h_comcode, "NO", "UNID",h_get_session_user_id, "ICOMCOD3", h_get_session_user_id, "") %>
                            </select>
                        </li>
                        <%}%>				   
                    </ul>
                </c:when>
                <c:otherwise></c:otherwise>
            </c:choose>
        </div>
		<div class="HeaderSearch">
			<div class="HeaderLogo"><a href="<%=httpurl%>/buyerMain.do"><img src="<%=h_ciImg %>" onError="this.src='/resources/images/KepLogo.gif';" alt="kep로고" /></a></div>  
			<div class="SearchArea">
                <!--검색영역-->
                <form name="searchDiForm"  id="searchDiForm"method="post">
                <input type="hidden" name="onepagerow" value="" /> 
                <input type="hidden" name="curPage" value="" /> 
                <input type="hidden" name="st_image_status" value="" /> 
                <input type="hidden" name="st_sort_change" value="" /> 
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

                <div class="search_combo_area">
                    <div class="search_combo_text">통합검색</div>
                        <ul class="search_combo_list" >
                            <li id="ALL" <%if ("ALL".equals(h_searchTarget)) {%>class="on"<%} %>><%=CommonLang.get("HTITLE29")%><!-- 전체 --></li>
                            <li id="DESCRIPTION" <%if ("DESCRIPTION".equals(h_searchTarget)) {%>class="on"<%} %>><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></li>
                            <li id="SPECIFICATION" <%if ("SPECIFICATION".equals(h_searchTarget)) {%>class="on"<%} %>><%=CommonLang.get("HTITLE14")%><!-- 규격 --></li>
                            <li id="BUYER_ITEM_NO" <%if ("BUYER_ITEM_NO".equals(h_searchTarget)) {%>class="on"<%} %>><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></li>
                            <li id="MAKER_NAME" <%if ("MAKER_NAME".equals(h_searchTarget)) {%>class="on"<%} %>><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></li>
                            <li id="CATEG_NAME" <%if ("CATEG_NAME".equals(h_searchTarget)) {%>class="on"<%} %>><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></li>
                            <li id="AGENT" <%if ("AGENT".equals(h_searchTarget)) {%>class="on"<%} %>><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></li>
                        </ul>
                </div>
                <% //자동완성 로직 기능 제거
                if(h_060000092 ==true){ 
                %>
	                <input name="searchTerm" type="text" class="HeaderSearchInput mt05" placeholder="검색어를 입력하세요!"  value="<%=h_searchTerm%>" 
	                onFocus="kep_h_getBuyerMdCmGoodsDiAitoHidden()" onKeyDown="if(event.keyCode==13){ actionBuyerMdCmGoodsDiLisList(); };" />
                <%
                }else{
                %>
	                <input name="searchTerm" type="text" class="HeaderSearchInput mt05" placeholder="검색어를 입력하세요!"  value="<%=h_searchTerm%>" onkeyup="kep_h_getBuyerMdCmGoodsDiAitoLisList(this.value)" 
	                onFocus="kep_h_getBuyerMdCmGoodsDiAitoHidden()" onKeyDown="if(event.keyCode==13){ actionBuyerMdCmGoodsDiLisList(); };" />
                <%
                }
                %>
                    <a href="javascript:actionBuyerMdCmGoodsDiLisList();"><img src="/resources/images/HeaderSearch_icon.png" alt="검색하기" class="HeaderSearchBtn" /></a>
				</form>
			</div>			
				<%
					if(p170000003_type.equals("TYPE01")) { 	%>
		            <div class="HeaderMYList_Market">
		                <a href="<%=httpurl%><%=h_p060000036%>"><div class="MYCart_Market"><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --> <p id="top_cart_cnt"><%=CommonUtil.getCartCnt(request)%></p></div></a>
		                <a href="javascript:showBuyerMyMenuPop();"><div class="MYMenu_Market"><%=CommonLang.get("HTITLE724")%><!-- 나의메뉴 --></div></a>
                    	<a href="http://ctx.cretec.kr/nctx/index.do"  target="_blank"><div class="MYLink_Market_Cretec" >온라인주문</div></a>                    	
                    	<a href="javascript:actionLogout();"><div class="MYLogout_Market">LOGOUT</div></a>
                    </div>
            	<%
                    } else if(p170000003_type.equals("TYPE02")) { 	%>
		            <div class="HeaderMYList_Market">
		                <a href="<%=httpurl%><%=h_p060000036%>"><div class="MYCart_Market"><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --> <p id="top_cart_cnt"><%=CommonUtil.getCartCnt(request)%></p></div></a>
		                <a href="javascript:showBuyerMyMenuPop();"><div class="MYMenu_Market"><%=CommonLang.get("HTITLE724")%><!-- 나의메뉴 --></div></a>
	                	<a href="https://ctx.cretec.kr/CtxApp/ebook/index.do"  target="_blank"><div class="MYLink_Market_Cretec" >카탈로그</div></a>	                	
	                	<a href="javascript:actionLogout();"><div class="MYLogout_Market">LOGOUT</div></a>
                	</div>
        		<%
                	} else if (h_comcode.equals("KRSYSR0001") ) { 	%>
		            <div class="HeaderMYList_Market">
		                <a href="<%=httpurl%><%=h_p060000036%>"><div class="MYCart_Market"><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --> <p id="top_cart_cnt"><%=CommonUtil.getCartCnt(request)%></p></div></a>
		                <a href="javascript:showBuyerMyMenuPop();"><div class="MYMenu_Market"><%=CommonLang.get("HTITLE724")%><!-- 나의메뉴 --></div></a>
                    	<a href="javascript:go_to_mall2();" ><div class="MYLink_Market_Etland" >모바일전용몰</div></a>
                    	<a href="javascript:actionLogout();"><div class="MYLogout_Market">LOGOUT</div></a>
                    </div>
            	<%}else{%>
		            <div class="HeaderMYList">
		                <a href="<%=httpurl%><%=h_p060000036%>"><div class="MYCart"><%=CommonLang.get("HTITLE161")%><!-- 장바구니 --> <p id="top_cart_cnt"><%=CommonUtil.getCartCnt(request)%></p></div></a>
		                <a href="javascript:showBuyerMyMenuPop();"><div class="MYMenu"><%=CommonLang.get("HTITLE724")%><!-- 나의메뉴 --></div></a>
		                <a href="javascript:actionLogout();"><div class="MYLogout">LOGOUT</div></a>
		            </div>
            	<%}%>
            
		</div><!-- class="HeaderSearch" 끝-->  
        
        <!--메뉴부분-->
		<div class="HeaderGnb">
			<div class="GnbMenu">
				<a href="javascript:leftShowTopHidden('show');"><p class="MyMenu"><img src="/resources/images/nav_menu.png" /> <%=CommonLang.get("HTITLE755")%><!-- 나의전체메뉴 --></p></a>
                <a href="javascript:kep_categori_show();"><p class="CateAll"><img src="/resources/images/nav_cate.png" /> CATEGORY</p></a>
                <%
                if (h_shotcutSsso == null || h_shotcutSsso.size() == 0){
				}else{
					if("KRCOWA0001".equals(h_comcode) || "KRCOWA0002".equals(h_comcode) || "KRCOWA0003".equals(h_comcode) || "KRCOWA0007".equals(h_comcode) || "KRCOWA0008".equals(h_comcode) )
					{
						int j = 0;
						for (int i=0; i<h_shotcutSsso.size(); i++){
									h_shotcutSssoData = h_shotcutSsso.get(i); 
									h_SSO_COM_CODE = CommonUtil.nvl(h_shotcutSssoData.get("COM_CODE"),""); 
									h_SSO_USER_ID = CommonUtil.nvl(h_shotcutSssoData.get("USER_ID"),""); 
									h_SSO_PASSWORD = CommonUtil.nvl(h_shotcutSssoData.get("PASSWORD"),"");
									
									String st_o_user_id =  h_SSO_USER_ID;
									byte[] plainText = st_o_user_id.getBytes();
									byte[]  bszDigest = SeedCbcAlgorithmUtil.SEED_CBC_Encrypt(plainText,0,plainText.length);		   
									h_SSO_USER_ID = SeedCbcAlgorithmUtil.getString(bszDigest);
					%>
			              	<% if("KRCOWA0001".equals(h_SSO_COM_CODE)){  %>
			                       <a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>');"><p>MRO</p></a> <!-- coway_on_01 -->
			               	<% }else if("KRCOWA0002".equals(h_SSO_COM_CODE)){  %>
			               		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>');"><p>CL</p></a>  <!-- coway_on_02 -->
			                <% }else if("KRCOWA0003".equals(h_SSO_COM_CODE)){  %>
			                		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>');"><p>CS</p></a>  <!-- coway_on_03 -->	
			                <% }else if("KRCOWA0007".equals(h_SSO_COM_CODE)){  %>
			                		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>');"><p>HC</p></a>  <!-- coway_on_04 -->	
			                <% }else if("KRCOWA0008".equals(h_SSO_COM_CODE)){  %>
			                		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>');"><p>DS</p></a>  <!-- coway_on_05 -->	
			                <%} %> 
	                <%} 
	                }%> 
               <%} %>
                <ul class="MyFavorite">
               <% if(myMenuList == null || myMenuList.size() == 0 ){ %>
                <li><a href="<%=httpurl%>/mpso/getBuyerMpSoDlvryInfoSearchList.do?upperId=b00100000000"><%=CommonLang.get("HTITLE230")%><!-- 배송조회 --></a> </li>
                <li><a href="<%=httpurl%>/mpso/getBuyerMpSoOrderProgressList.do?upperId=b00100000000"><%=CommonLang.get("HTITLE524")%><!-- 주문진행현황 --></a> </li>
                <li><a href="<%=httpurl%>/wmgr/showBuyerWmGrClosing.do?upperId=b00100000000"><%=CommonLang.get("HTITLE757")%><!-- 마감정보 --></a>  </li>
                <li><a href="<%=httpurl%>/mdap/showNewPassRecvList.do?upperId=b00100000000"><%=CommonLang.get("HTITLE295")%><!-- 결재대상조회 --></a></li>
                <%
                	} else {
                		for(int inx = 0 ; inx < myMenuList.size() ; inx++){
                			Map<String, String> menuItem = myMenuList.get(inx);
                %>
                	<li>
                		<a href="javascript:kep_view_link('<%=httpurl%><%=CommonUtil.nvl((String) menuItem.get("URL")) %>?upperId=<%=CommonUtil.nvl((String) menuItem.get("TOPMENUID")) %>');"><%=CommonUtil.nvl((String) menuItem.get("NAME")) %></a>                		
                	</li>
                <%
                		}
                	}
                %>
                </ul>
                <p class="manual"></p>
			</div><!--GnbMenu 끝--> 
		</div><!--HeaderGnb 끝--> 
	</div><!--HeaderWrap 끝-->
	<div id="autoDiSearchView"  style="display:none; position:absolute; top:130px;left:50%; margin-left:-300px; width:528px; height:400px; background-color:#fff; z-index:99999999999; border:1px solid #e8340c; padding:25px;">
	 <table class="cont_t_list002" style="width:100%">
	 			<colgroup>
		            <col width="50%" />
		            <col width="50%" />
		        </colgroup>
	 	<tr>
	 		<th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
	 		<th><%=CommonLang.get("HTITLE759")%><!-- 제조사(브랜드) --></th>
	 	</tr> 	
	 	 	<tr>
	 		<td valign="top"><div id="dicart1"></div>
	 		<td valign="top"><div id="dicart2"></div></td>
	 	</tr> 	  	
	 	<tr>
	 		<th><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
	 		<th><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
	 	</tr> 	 	
	 	 	 	<tr>
	 		<td valign="top"><div id="dicart3"></div>
	 		<td valign="top"><div id="dicart4"></div></td>
	 	</tr> 	  	 	
	 </table>  
	</div>
    <form name="buyerCategItemListLocation" id="buyerCategItemListLocation" method="post">
        <input type="hidden" name="buyerCategItemListLocation_categ_code" id="buyerCategItemListLocation_categ_code" />
        <input type="hidden" name="buyerCategItemListLocation_buyer" id="buyerCategItemListLocation_buyer"  value="<%=h_comcode %>"/>
        <input type="hidden" name="buyerCategItemListLocation_byca_comorg_code" id="buyerCategItemListLocation_byca_comorg_code" />
        <input type="hidden" name="buyerCategItemListLocation_company" id="buyerCategItemListLocation_company"  value="<%=h_comcode %>"/>
        <input type="hidden" name="upperId" id="upperId"  value="b00100000000"/> <!--  b00100000000 카테고리 검색 고정 -->
        <input type="hidden" name="onepagerow" id="onepagerow"  value="10"/>
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
    <div id="quickCategoriArea"  style=" display:none; position:absolute; top:216px;left:50%; margin-left:-400px; width:950px; height:380px; background-color:#fff; z-index:99999999999; border:1px solid #4b4948; padding:25px;">
        <div class="btnArea"> 
            <div class="fl"> <h4  id="h_topmenunnavi"></h4> </div>
            <div class="fr"> <font size="6px"><a href="javascript:kep_categori_show();">Χ</a></font></div>
         </div>
        <table class="cont_t_list10_div" style="width:100%">
            <colgroup>
                <col width="10%" />
                <col width="*" /> 
            </colgroup>
        <tr><td><%=CommonLang.get("HTITLE2")%><!--   대분류 --></td><td><div id="h_cateMenu1"></div></td></tr>
        <tr><td><%=CommonLang.get("HTITLE3")%><!--   중분류 --></td><td><div id="h_cateMenu2"></div></td></tr>
        <tr><td><%=CommonLang.get("HTITLE4")%><!--   소분류 --></td><td><div id="h_cateMenu3"></div></td></tr>
        <tr><td><%=CommonLang.get("HTITLE5")%><!-- 최종분류 --></td><td><div id="h_cateMenu4"></div></td></tr> 
        </table>  
    </div>

<script type="text/javascript">  
<!-- 

$(document).ready(function(){
	
	$(".search_combo_area .search_combo_text").html($(".search_combo_area #"+ $("#searchTarget").val() ).html());
	
	$(".search_combo_area .search_combo_text").click(function(){
		$(".search_combo_area ul li").removeClass("on");
		$(".search_combo_area ul #" + $("#searchTarget").val()).addClass("on");
		$(".search_combo_area ul").slideToggle("fast");
	});
	
	$(".search_combo_area ul li").mouseover(function() {
		$(".search_combo_area ul li").removeClass("on");
		$(this).addClass("on");
	});
	
	$(".search_combo_area").mouseleave(function() {
		$(".search_combo_area ul").slideUp("fast");
	});
	
	$(".search_combo_area ul li").click(function() {
		var searchTarget = $(this).attr("id");
		$("#searchTarget").val(searchTarget);
		$(".search_combo_area .search_combo_text").html($(".search_combo_area #"+ searchTarget ).html());
		$(".search_combo_area ul").slideUp("fast");
	});
	openCookieItem();	
});
var currentGoodsItem = 0;
//오늘본 상품
function openCookieItem() {	
	var arr = "";
	if(currentGoodsItem < 0){
		currentGoodsItem = 0;
		alert("이전 상품 정보가 없습니다.");		
		return;
	}
	var searchMyItemList = getKePCookie("searchMyItemList");
	if(searchMyItemList != null){
		arr = searchMyItemList.split("&&");	
	}	
	var tableBody	=	""; 
	var strArrLength =  arr.length;				
	$('#openProduct *').remove();
	for(var i = currentGoodsItem; i < 3+currentGoodsItem; i++){
		if(strArrLength > i){
			var strArry = arr[i].split("@@");
			if(strArry[1] ==null){
				tableBody += "<p>NO ITEM</p>";
			}else{
				var itemImagePath = "<%=CommonUtil.realImgS3UploadPath%>"+"/"+ strArry[7]+"/"+ strArry[8];
				tableBody += "<p><a href=\"javascript:getHearderCatalogDetail('"+strArry[0]+"','"+ strArry[1]+"','"+ strArry[2]+"','"+ strArry[3]+"','"+ strArry[4] +"','"+ strArry[5] +"','"+strArry[6] +"');\"><img src='"+itemImagePath+"'  onerror=\"javasrcipt:this.src='/resources/images/noimage.gif'\"></a></p>";
			}
		}else{		
			tableBody += "<p>NO ITEM</p>";
		}			
	}	
	tableBody +="<div class='ViewPD_Btn'><a href=\"javascript:getPreGoodsItem();\"><img src='/resources/images/ViewPD_left.gif'/></a> <a href=\"javascript:getNextGoodsItem();\"><img src='/resources/images/ViewPD_right.gif' /></a></div>";
	$("#openProduct").append(tableBody);
}
//최근 상품 다음 페이지 버튼 눌렀을 경우
function getNextGoodsItem(){
	currentGoodsItem++;	
	openCookieItem();
}
//최근 본 상품 이전 페이지 버튼 눌렀을 경우
function getPreGoodsItem(){
	currentGoodsItem--;	
	openCookieItem();
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
	$('#buyerCategItemListLocation').attr("action", "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsLisDetail.do").submit();   
}

function actionLogin() {
	if (document.loginForm.userId.value == "") {
		alert("<%=CommonLang.msg("MSG430")%>");	//아이디를 입력하세요
		return;
	} else if (document.loginForm.password.value == "") {
		alert("<%=CommonLang.msg("MSG431")%>");	//비밀번호를 입력하세요
		return;
	} else {
		document.loginForm.action = "/login/login.do";
		document.loginForm.submit();
	}
}
//IP로그아웃
function setLogoutSessionInfo(){
	//화면으로 돌아가시겠습니까?
    if(!confirm(" IProcurement <%=CommonLang.msg("MSG432")%>     ")) return;
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
		alert("<%=CommonLang.msg("MSG433")%>");	//검색어를 입력하세요.
		document.searchDiForm.searchTerm.focus();
		return;
	}	
	document.searchDiForm.onepagerow.value = "10";
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

function actionBuyerMdCmGoodsDiLisList(recommendYn) {
	if ( document.searchDiForm.searchTerm.value == ""){
		alert("<%=CommonLang.msg("MSG433")%>");	//검색어를 입력하세요.
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
	document.searchDiForm.st_research_flag.value = "N";
	document.searchDiForm.onepagerow.value = "10";
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
	openSearchPopup("/none/showCommonNoNeBuyerMyMenuPop.do", "?1=1", "878,579,no");
}
		
function kep_view_link(link){
	var link_split = link.split("?");
	var fullUrl = "<%=menuUrl%>";
	var targetUrl = link_split[0]; //
	if(fullUrl.indexOf(targetUrl) >= 0){
		// 해당 메뉴로 접근할 수 없습니다(고객사 미사용)
		alert("<%=CommonLang.msg("MSG583")%>");
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
		  alert("Exit URL<%=CommonLang.msg("MSG528")%>");	//을 찾지 못했습니다.
	   }
 	 });	
}
function emulAcceptCharset(form) {
    if (form.canHaveHTML) { // detect IE
        document.charset = form.acceptCharset;
    }
    return true;
}
//-->
</script>
