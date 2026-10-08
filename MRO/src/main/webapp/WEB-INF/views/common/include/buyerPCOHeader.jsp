<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.SeedCbcAlgorithmUtil"%>
<%@ page import="java.util.*"%> 
<%
	SessionInfo _h_sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String h_usingCatalType = "";
	String h_bycaComorgCode = "";
	String h_comcode = "";
	String h_ciImg = "";
	String h_getAccessComorgLevel = ""; 
	if (_h_sessionInfo != null){
		h_usingCatalType =  CommonUtil.nvl((String)_h_sessionInfo.getUsingCatalType()); 	 // 사용카탈로그타입(1:전용 2:공통 3:둘다 , 재개발 A:전용 B:공통 C:둘다 , Z:전자입찰)
		h_bycaComorgCode =  CommonUtil.nvl((String)_h_sessionInfo.getBycaComorgCode()); 
		h_comcode =  CommonUtil.nvl((String)_h_sessionInfo.getComCode()); 
		h_ciImg =   CommonUtil.nvl((String)_h_sessionInfo.getCiImage());
		h_getAccessComorgLevel =   CommonUtil.nvl((String)_h_sessionInfo.getAccessComorgLevel());
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
	
%>   
	<div id="headerWrap">
    	<div id="header">
    		   	<form name="loginForm" method="post">
			<input type="hidden" name="h_byca_comorg_code" id="h_byca_comorg_code"  value="<%=h_bycaComorgCode%>" />
			<input type="hidden" name="h_category_name1" id="h_category_name1"  />
			<input type="hidden" name="h_category_name2" id="h_category_name2"  />
			<input type="hidden" name="h_category_name3" id="h_category_name3"  />
        	<div id="header_globalArea">
                  	<!--로그인후-->
					<c:choose>
						<c:when test="${sessionInfo != null }">
                <ul class="header_topGmenu">
                    <li class="first">${sessionInfo.comNameLoc} ${sessionInfo.userNameLoc} [<span class="black">${sessionInfo.userId}</span>] 님 &nbsp;l&nbsp;</li>
                    <li><a href="javascript:faqpopup();">FAQ &nbsp;l&nbsp; </a></li>
			        <% if (h_comcode.equals("KRKEPB0004") || h_comcode.equals("KRDONG0110") || h_comcode.equals("KRDONG0121") || h_comcode.equals("KRDONG0107") || h_comcode.equals("KRDONG0117") || h_comcode.equals("KRDONG0128")) { 	%>
				   <li><a href="javaScript:openSearchPopup('<%=h_sslurl%>/home/showBuyerHomeGoodsRegFormPop.do', '', '700,440,no');">품목등록증&nbsp;l&nbsp; </a></li>
				   <% } %>
				   <li class="last"><a href="<%=h_sslurl%>/main/getCustomerCenterList.do?upperId=b00000000000">고객센터&nbsp;l&nbsp; </a></li>
                    <li><span class="topbtn"><a href="javascript:showBuyerMyMenuPop();">나의메뉴 지정</a></span></li>
 <li>
                    
                    <% if(h_getAccessComorgLevel.equals("1")) { %> 
							<select name="h_comg_code"  id="h_comg_code" style="width:90%"  onChange="setChange();"> 
											<%
											Map<String, String> _h_map = new HashMap<String, String>();
											_h_map.put("COM_CODE",h_comcode); 
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.getComGCode","",_h_map,h_comg_code) %>
									</select>  
<%} else{ %>						
<input type="hidden" name="h_comg_code" id="h_comg_code">
<%} %>			
                    </li>
                </ul>
                </c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>
            </div>
            
            
            
            <div class="myMenuBox" style="display:none;" ><!--나의메뉴지정 시작 가려놨어요-->
    				<div class="myMenuHeader"><span class="myMenu">나의메뉴 지정</span> <span class="myMenuNum"> * 최대 6개까지 지정 &nbsp;&nbsp;&nbsp;<a href="#"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></span></div>
                    <div class="List01">
                    	<p class="myMenubIG">상품검색</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 카테고리상품검색</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 이력상품검색</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 나의상품검색</li>
                        </ul>
                    </div>
                    <div class="List02">
                    	<p class="myMenubIG">견적관리</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 신규상품규격의뢰</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 신규상품규격확인</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 신규상품견적의뢰(두산)</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 신규상품견적의뢰</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 단가합의 및 Nego요청</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 진행상태조회</li>
                        </ul>
                    </div>
                    <div class="List03">
                    	<p class="myMenubIG">주문관리</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 장바구니</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 주문 진행현황</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 장바구니 업로드</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 납기지연현황</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 반품진행현황</li>
                        </ul>
                    </div>
                    <div class="List04">
                    	<p class="myMenubIG">발주관리</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 구매요청접수</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 구매요청반려조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 발주보류조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 발주진행관리</li>
                        </ul>
                    </div>
                    <div class="List05">
                    	<p class="myMenubIG">입고</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 입고등록</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 입고조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 마감조회</li>
                        </ul>
                    </div>
                    <div class="List06">
                    	<p class="myMenubIG">도안관리</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 발주관리</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 작물보호</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 종자</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 농약포장재</li>
                        </ul>
                    </div>
                    <div class="List07">
                    	<p class="myMenubIG">결재</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 결재대상조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 결재진행함</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 상신함</li>
                        </ul>
                    </div>
                    <div class="List08">
                    	<p class="myMenubIG">재고관리</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 출고지시</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 수불리스트</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 수불현황</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 재고조정</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 재고상품등록관리</li>
                        </ul>
                    </div>
                    <div class="List09">
                    	<p class="myMenubIG">관리자</p>
                        <ul>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 사용자등록요청접수</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 사용자조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 회사법인정보관리</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 마스터코드관리</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 카탈로그 조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 품목군별 현황조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 통계</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 예산부서</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 부서별계정</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 예산편성</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 예산조회</li>
                            <li><input name="" type="checkbox" value="" class="myMenucheck"> 공지사항관리</li>
                        </ul>
                    </div>
                    <div class="myMenuline" ></div>
                    <div class="myMenubtn" ><span class="btn_04 "><a href="#">확인</a></span> <span class="btn_04 "><a href="#">취소</a></span> </div>
			</div><!--나의메뉴지정 끝-->
                  </form>
            
            
            
            <h1><a href="<%=h_sslurl%>/buyerPCOMain.do"><img src="<%=h_ciImg %>" onError="this.src='/resources/images/b_h1_logo.gif';" alt="kep로고" /></a></h1>
            <div id="header_topArea">
            	<!--검색영역-->
                <div id="header_searchArea"> 
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
					<input type="hidden"  name="searchTargetIDX_CATEGORY_NO"  id="searchTargetIDX_CATEGORY_NO"  value="<%=h_searchTargetIDX_CATEGORY_NO %>"   /> <!--   IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다. -->
						
					
					<div class="search_combo_area">
						<div class="search_combo_text"></div>
						<ul class="search_combo_list" >
							<li id="ALL" <%if ("ALL".equals(h_searchTarget)) {%>class="on"<%} %>>전체</li>
							<li id="DESCRIPTION" <%if ("DESCRIPTION".equals(h_searchTarget)) {%>class="on"<%} %>>품목명</li>
							<li id="SPECIFICATION" <%if ("SPECIFICATION".equals(h_searchTarget)) {%>class="on"<%} %>>규격</li>
							<li id="BUYER_ITEM_NO" <%if ("BUYER_ITEM_NO".equals(h_searchTarget)) {%>class="on"<%} %>>품목코드</li>
							<li id="MAKER_NAME" <%if ("MAKER_NAME".equals(h_searchTarget)) {%>class="on"<%} %>>제조사</li>
							<li id="CATEG_NAME" <%if ("CATEG_NAME".equals(h_searchTarget)) {%>class="on"<%} %>>카테고리</li>
							<li id="AGENT" <%if ("AGENT".equals(h_searchTarget)) {%>class="on"<%} %>>협력사</li>
						</ul>
					</div>
                    
                    <input name="searchTerm" type="text" class="inputStyle01 mt05" value="<%=h_searchTerm%>"    style="margin-left : 125px ; padding-top:4px; width: 200px; height:22px; color:#263753; font-size:12px; font-family:dotum;"  onkeyup="kep_h_getBuyerMdCmGoodsDiAitoLisList(this.value)" onFocus="kep_h_getBuyerMdCmGoodsDiAitoHidden()" onKeyDown="if(event.keyCode==13){  actionBuyerMdCmGoodsDiLisList(); };"  />
	              <a href="javascript:actionBuyerMdCmGoodsDiLisList();"><img src="/resources/images/b_btn_search.jpg" alt="검색하기" class="searchBtn" /></a>
	              </form>
                </div>
                <a href="<%=h_sslurl%><%=h_p060000036%>"><div class="topCart"><p class="topCartNum" id="top_cart_cnt">  		
		
                <%=CommonUtil.getCartCnt(request)%>
                </p></div></a>
                <div class="topMarket"><a href="<%=h_sslurl%>/promote_index.html"  target="_blank"><img src="/resources/images/b_img_eprocurement.gif" alt="eprocurement"/></a></div>
                
            </div>
            
            <!--메뉴부분-->
            <div id="header_gnbArea">
            	<p class="menuAll"><a href="javascript:leftShowTopHidden('show');">전체메뉴</a></p>
                <p class="cate"><a href="javascript:kep_categori_show();"><img src="/resources/images/b_icn_cate.gif" alt="카테고리" /></a></p> 
                
                <%
                if (h_shotcutSsso == null || h_shotcutSsso.size() == 0){
				}else{
					if("KRCOWA0001".equals(h_comcode) || "KRCOWA0002".equals(h_comcode) || "KRCOWA0003".equals(h_comcode) || "KRCOWA0007".equals(h_comcode) )
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
			                       <a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>','<%=h_SSO_PASSWORD%>');"><span class="cowayIcon0<%=(++j)%>">MRO</span></a> <!-- coway_on_01 -->
			               	<% }else if("KRCOWA0002".equals(h_SSO_COM_CODE)){  %>
			               		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>','<%=h_SSO_PASSWORD%>');"><span class="cowayIcon0<%=(++j)%>">CL</span></a>  <!-- coway_on_02 -->
			                <% }else if("KRCOWA0003".equals(h_SSO_COM_CODE)){  %>
			                		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>','<%=h_SSO_PASSWORD%>');"><span class="cowayIcon0<%=(j++)%>">CS</span></a>  <!-- coway_on_03 -->	
			                <% }else if("KRCOWA0007".equals(h_SSO_COM_CODE)){  %>
			                		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>','<%=h_SSO_PASSWORD%>');"><span class="cowayIcon0<%=(++j)%>">HC</span></a>  <!-- coway_on_04 -->	
			                <% }else if("KRCOWA0008".equals(h_SSO_COM_CODE)){  %>
			                		<a href="javascript:goMroCheckHeader('<%=h_SSO_COM_CODE%>','<%=h_SSO_USER_ID%>','<%=h_SSO_PASSWORD%>');"><span class="cowayIcon0<%=(++j)%>">W</span></a>  <!-- coway_on_05 -->	
			                <%} %>  
	                <%} 
	                }%> 
               <%} %>
               
                <ul class="header_gnb">
               <% if(myMenuList == null || myMenuList.size() == 0 ){ %>
                    <li><a href="<%=h_sslurl%>/mpso/getBuyerMpSoDlvryInfoSearchList.do?upperId=b00100000000">배송조회</a>  <img src="/resources/images/br_header_gnb.gif" alt="주문진행현황" /></li>
                    <li><a href="<%=h_sslurl%>/mpso/getBuyerMpSoOrderProgressList.do?upperId=b00100000000">주문진행현황</a>  <img src="/resources/images/br_header_gnb.gif" alt="마감정보" /></li>
                    <li><a href="<%=h_sslurl%>/wmgr/showBuyerWmGrClosing.do?upperId=b00100000000">마감정보</a>  <img src="/resources/images/br_header_gnb.gif" alt="결재대상조회" /></li>
                    <li><a href="<%=h_sslurl%>/mdap/showNewPassRecvList.do?upperId=b00100000000">결재대상조회</a></li>
                <%
                	} else {
                		for(int inx = 0 ; inx < myMenuList.size() ; inx++){
                			Map<String, String> menuItem = myMenuList.get(inx);
                %>
                	<li>
                <%		if(inx > 0){ %>
                		<img src="/resources/images/br_header_gnb.gif" alt="<%=CommonUtil.nvl((String) menuItem.get("NAME")) %>" />
                <%		} %>
                		<a href="<%=h_sslurl%><%=CommonUtil.nvl((String) menuItem.get("URL")) %>?upperId=<%=CommonUtil.nvl((String) menuItem.get("TOPMENUID")) %>"><%=CommonUtil.nvl((String) menuItem.get("NAME")) %></a>
                	</li>
                <%
                		}
                	}
                %>
                </ul>
                <p class="manual"></p>
            </div>
        </div>
    </div>

<form name="buyerCategItemListLocation" id="buyerCategItemListLocation" method="post">
<input type="hidden" name="buyerCategItemListLocation_categ_code" id="buyerCategItemListLocation_categ_code" />
<input type="hidden" name="buyerCategItemListLocation_buyer" id="buyerCategItemListLocation_buyer"  value="<%=h_comcode %>"/>
<input type="hidden" name="buyerCategItemListLocation_byca_comorg_code" id="buyerCategItemListLocation_byca_comorg_code" />
<input type="hidden" name="buyerCategItemListLocation_company" id="buyerCategItemListLocation_company"  value="<%=h_comcode %>"/>
<input type="hidden" name="upperId" id="upperId"  value="b00100000000"/> <!--  b00100000000 카테고리 검색 고정 -->
<input type="hidden" name="onepagerow" id="onepagerow"  value="10"/>
</form>
 <form name="ssoHeaderLogin" id="ssoHeaderLogin" method="post">
			<input type="hidden" name="userId" id="userId" value="" /> 
			<input type="hidden" name="password" id="password" value="" /> 
</form>
 <form name="comgCodeForm" id="comgCodeForm" method="post">
			<input type="hidden" name="h_comg_code_val" id="h_comg_code_val" value="" />  
</form>
<div id="quickCategoriArea"  style="position:absolute; left:  25px; top: 142px; width: 1000px; height: 380px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 2px solid #1D2A40; padding:25px; Border-radius:20px;">
<div class="btnArea"> 
<div class="fl"> 
<h4  id="h_topmenunnavi"></h4> 
</div>
<div class="fr"> 
		<font size="6px"><a href="javascript:kep_categori_show();">Χ</a></font>
         </div>
     </div>
 <table class="cont_t_list10_div" style="width:100%">
 			<colgroup>
	            <col width="8%" />
	            <col width="*" /> 
	        </colgroup>
 	<tr>
 		<td>대분류</td><td><div id="h_cateMenu1"></div></td>
 	</tr>
 	<tr>
 		<td>중분류</td><td><div id="h_cateMenu2"></div></td>
 	</tr>
 	<tr>
 		<td>소분류</td><td><div id="h_cateMenu3"></div></td>
 	</tr>
 	<tr>
 		<td>표준품명</td><td><div id="h_cateMenu4"></div></td>
 	</tr> 	 	 	
 </table>  
</div>
<div id="autoDiSearchView"  style="position:absolute; left:  280px; top: 88px; width: 500px; height: 400px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 2px solid #1D2A40; padding:25px; Border-radius:20px;">
 <table class="cont_t_list002" style="width:100%">
 			<colgroup>
	            <col width="50%" />
	            <col width="50%" />
	        </colgroup>
 	<tr>
 		<th>품목명</th>
 		<th>제조사(브랜드)</th>
 	</tr> 	
 	 	<tr>
 		<td valign="top"><div id="dicart1"></div>
 		<td valign="top"><div id="dicart2"></div></td>
 	</tr> 	  	
 	<tr>
 		<th>규격</th>
 		<th>협력사</th>
 	</tr> 	 	
 	 	 	<tr>
 		<td valign="top"><div id="dicart3"></div>
 		<td valign="top"><div id="dicart4"></div></td>
 	</tr> 	  	 	
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
});

function actionLogin() {
	if (document.loginForm.userId.value == "") {
		alert("아이디를 입력하세요");
		return;
	} else if (document.loginForm.password.value == "") {
		alert("비밀번호를 입력하세요");
		return;
	} else {
		document.loginForm.action = "<%=h_sslurl2%>/login/login.do";
		document.loginForm.submit();
	}
}

function actionLogout() {
	document.loginForm.action = "<%=h_sslurl%>/login/logout.do";
	document.loginForm.submit();
}

function actionBuyerMdCmGoodsDiLisList() { 	
	
	if ( document.searchDiForm.searchTerm.value == ""){
		alert("검색어를 입력하세요.");
		document.searchDiForm.searchTerm.focus();
		return;
	}	
	document.searchDiForm.onepagerow.value = "10";
	document.searchDiForm.curPage.value = "1";
	document.searchDiForm.st_image_status.value = "";
	document.searchDiForm.groupCategoryText.value = "";
	document.searchDiForm.groupMakerName.value = "";
	document.searchDiForm.searchSort.value = "";
	document.searchDiForm.st_sort_change.value = "";	 
	document.searchDiForm.st_description.value = "";	 
	document.searchDiForm.st_specification.value = "";	 
	document.searchDiForm.st_maker.value = "";	 
	document.searchDiForm.st_categoty_name.value = "";	 
	document.searchDiForm.searchMode.value = "";	 
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.action = "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiForm.submit();
}
 
function actionBuyerMdCmGoodsDiLisList2() { 	  
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiForm.action = "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiForm.submit();
} 

function actionBuyerMdCmGoodsDiLisList3(searchTarget,searchTerm) { 	  
	document.searchDiForm.upperId.value = "b00100000000";
	document.searchDiForm.searchTarget.value = searchTarget;	 
	document.searchDiForm.searchTerm.value = searchTerm;	 
	document.searchDiForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiForm.action = "<%=h_sslurl%>/mdcm/getBuyerMdCmGoodsDiLisList.do";
	document.searchDiForm.submit();
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

function goMroCheckHeader(com_code, user_id, user_pw)
{ 
    document.ssoHeaderLogin.userId.value = user_id;
    document.ssoHeaderLogin.password.value = user_pw; 
    $('#ssoHeaderLogin').attr("action", "<%=h_sslurl2%>/login/office_login.do").submit();      
}

function showBuyerMyMenuPop(){
	openSearchPopup("/none/showCommonNoNeBuyerMyMenuPop.do", "?1=1", "878,579,no");
}
		
function kep_view_link(link){
	if (link.indexOf("#")>=0 || link.indexOf("null")>=0){
		return;
	}
	window.location.href = "<%=h_sslurl%>"+link;
}

//이수화학(주), 온산공장, 울산공장은 Select박스로 세션이동을 함(이수화학 그룹)
function setChange()
{ 
    document.comgCodeForm.h_comg_code_val.value = kepSelectOptionVal("h_comg_code"); 
    $('#comgCodeForm').attr("action", "<%=h_sslurl%>/buyerMain.do").submit();      
}


//-->
</script>
