	<%--
	**********************************************
	* 메뉴 : 마이페이지 > 자주 구매하는 상품
	* 화면 : 자주 구매하는 상품
	* 기능 : 
	* 프로그램 ID : BU0803005
	* 담당자 : 최찬규
	* 착수일 : 2026-03-10
	**********************************************
	--%>
	<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
	<%@ page import="java.util.List"%>
	<%@ page import="java.util.Map"%>
	<%@ page import="java.util.Arrays"%>
	<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
	<%@ page import="com.koreab2b.mro.util.CommonLang"%>
	<!DOCTYPE html>
	<html>
	<head>
	<%@ include file="../../common/include/head_v2.jspf"  %>
	</head>
	<%
		// 공통
		@SuppressWarnings (value="unchecked")
	
		String menuId = CommonUtil.nvl((String) request.getParameter("menuId"),""); // 메뉴아이디
		
		if(myMenuListHeader != null){ //null이 아닌 경우에만 체크
			for(int i = 0; i<myMenuListHeader.size(); i++){
				if(myMenuListHeader.get(i).get("MENU_ID").equals(menuId)){
					myMenuFlag = true;
					break;
				}
			}
		}
		SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
		String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
		String grid_cnt = "0";
		if(_gridList.size()>0 && _gridList != null){
			grid_cnt = String.valueOf(_gridList.size());
		}
		String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
		String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(sessionInfo.getRowCnt(),"30"));  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
		String pageString = "30,50,100,200,500,1000";
		if(!Arrays.asList(pageString.split(",")).contains(onepagerow)){
			onepagerow = "30";
		}
		// 조회조건 S
		String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
		String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");    
		String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");    
		String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");    	
		String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"");   
		String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");
		String st_desc_spec = CommonUtil.nvl((String) request.getParameter("st_desc_spec"),"");
		String st_list_type = CommonUtil.nvl((String) request.getParameter("st_list_type"),"list");
		String searchSort = CommonUtil.nvl((String) request.getParameter("searchSort"),"");
		String st_keyword = CommonUtil.nvl((String) request.getParameter("st_keyword"),"");
		String keyword_sel = CommonUtil.nvl((String) request.getParameter("keyword_sel"),"");
		String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
		String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");
		// 조회조건 E
		
		String SessionComCode = "";
		String SessionUserId ="";
		String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
		String img_view_flag   = "";
		String user_group = "";
		if (sessionInfo != null){ 
			SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
			SessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId()); 
			img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag());
			user_group = CommonUtil.nvl((String)sessionInfo.getUserGroup());
		}  
		 if(image_status.equals("")){ 
	        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
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
	/*
			프로그램ID: PG_02_B_000834_008
			수정자: 현명환
			수정일: 2015.03.06
			펀치아웃 해당 내용 표시.
		*/
		boolean p060000052 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000052");	 
	
		//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
		boolean p060000072 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000072");
		
		String dup_add_posb_yn = "N";
		
		if(p060000072 == true){
			dup_add_posb_yn = "Y";
	    }
		
		//MOQ를 이용하여 주문 통제
	    boolean p060000077 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000077"); 
	    //주문배수를 이용하여 주문 통제
	    boolean p060000089 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000089");
		//SLOGIC-END
		
		// SLOGIC-BEGIN(P06-0000094) - 기등록 품목 신규견적 의뢰 기능 활성화.
		boolean p060000094 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000094");
	  	//견적의뢰 기능 비활성화
	    boolean p060000102 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000102");
	  	//USER_GRUP=Z 체크하여 견적 비활성화
	  	if(user_group.equals("Z")){
	  		p060000102 = true;
	  	}
	  	
		//SLOGIC-END
		
		List<Map<String,String>> myItemList =  CommonUtil.getCode3List(_sessionInfo.getComCode(), "SEL", "ITEM",_sessionInfo.getUserId(), "ICOMCOD3_v2", "", "");
		
	%> 
	
	<body onLoad="kep_onload_view()">
	<div id="wrapper"> 
	<!-- 메뉴 S --> 
	<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerHeader_v2"/>
	<c:param name="part" value="buyerHeader_v2"/>
	</c:import>
	<div id="container2">
	<!-- 메뉴 E -->
	<!--내용 시작-->
		<!--서브타이틀-->  
	  <div class="SubPageTit">
	    <%=CommonLang.get("HTITLE1015")%><!-- 자주 구매하는 상품 --> <%if(myMenuFlag) {%>
	          <button class="But_Star_on"></button>
	     	<%}else{ %>
	     	  <button class="But_Star_off"></button>
	     	<%} %> 
	    <div class="SubPageGuide">
	      <ul>
	        <li><img src="/resources/imgs/Icon_Home.png" /></li>
	        <li><%=CommonLang.get("HTITLE987")%><!-- 마이페이지 --></li>
	        <li><%=CommonLang.get("HTITLE1015")%><!-- 자주 구매하는 상품 --></li>
	      </ul>
	    </div>   
	  </div>
		<div class="containerBox"   >
		  <form name = "searchForm" id="searchForm" method = "post">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<!-- 화면 내 정의 -->
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 
			<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">  
			
			<input type="hidden" name="confirm1" id="confirm1" value="">
			<input type="hidden" name="confirm2" id="confirm2" value="">
			<input type="hidden" name="confirm3" id="confirm3" value="">
			<input type="hidden" name="confirm4" id="confirm4" value="">
			<input type="hidden" name="st_list_type" id="st_list_type" value="<%=st_list_type %>">
			<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=st_sort_change %>">
			<input type="hidden" name="st_sort_gubun" id="st_sort_gubun" value="<%=st_sort_gubun %>">
			<input type="hidden" name="searchSort" id="searchSort"  value="<%=searchSort%>" />
	    <div class="FavoriteSearch1280 mt35">
	    <table class="SearchTable02" style="border-top: none;" >
	      <colgroup>
	        <col width="80px" />
	        <col width="690px" />
	        <col width="70px" />
	        <col width="440px" />
	      </colgroup>           	
	      <tr>
	        <th>주문일</th>
	        <td >
	          <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
	            <div class="Buyer-date-input"  data-datepicker><input id="st_from_date" name="st_from_date" type="text" placeholder="" readonly value="<%=st_from_date %>" /><span>1 </span></div>
	            <span class="Buyer-dash">~</span>
	            <div class="Buyer-date-input" data-datepicker><input type="text" id="st_to_date" name="st_to_date" placeholder="" readonly value="<%=st_to_date %>"/><span>1</span></div>
	          </div>
	          <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','1'); return false;">1개월</button> 
	          <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','2'); return false;">2개월</button>
	          <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','3'); return false;">3개월</button>
	          <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date','st_to_date','12'); return false;">1년</button>
	        </td>
	        <th>검색어</th>
	        <td>
	          <select name="keyword_sel" class="Select40" style=" float:left;width:120px; margin-right:5px">
	            <option value="ALL" <%if ("ALL".equals(keyword_sel)) {%>selected<%} %>>전체</option>
	            <option value="BUYER_ITEM_NO" <%if ("BUYER_ITEM_NO".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
	            <option value="DESCRIPTION" <%if ("DESCRIPTION".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
	            <option value="SPECIFICATION" <%if ("SPECIFICATION".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE14") %><!-- 규격 --></option>
	            <option value="MAKER_NAME" <%if ("MAKER_NAME".equals(keyword_sel)) {%>selected<%} %>><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></option>
	          </select>  
	          <input class="input40" style="width:293px" name=st_keyword id="st_keyword" type="text" maxlength="100" value="<%=st_keyword%>" onKeyDown="kepEnter_v2()"/>
	        </td>                 
	      </tr>
	    </table>
	    </div>
	    <div class="SearchResultBtnBox"><div class="SearchResultBtnBox1280"><div class="Center"> <button class="ButOutline_Medium" onclick="javascript:doAction('reload',''); return false;" ><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></button> <button class="ButDarkGray_Medium" onclick="javascript:doAction('search',''); return false;"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></button></div>         </div> </div>         
		<div class="container"  >
	      <!--리스트정렬-->
	      <div class="SearchResultTitSum mt50 pb20">
	        <%=CommonLang.get("HTITLE921") %><!-- 총 --> <%=total_cnt %><%=CommonLang.get("HTITLE595") %><!-- 건 -->
	        <div class="buttonRight">
	         	<button class="ButM_Outline" onclick="javascript:doAction('checkMyItem',''); return false;"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
		        <button class="ButMPrimary" onclick="javascript:doAction('checkCartItem',''); return false;"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
	        </div>
	      </div> 
	      <div class="Array">
	      <div class="buttonLeft">
	        <ul id="sortList">
	        	<a href="javascript:searchSort('BUY_TERM');"><li id="BUY_TERM"><%=CommonLang.get("HTITLE1124") %><!-- 구매 빈도순 --></li></a>
	            <a href="javascript:searchSort('DESCRIPTION');"><li id="DESCRIPTION"><%=CommonLang.get("HTITLE1019") %><!-- 품목명순 --></li></a>
	            <a href="javascript:searchSort('SPECIFICATION');"><li id="SPECIFICATION"><%=CommonLang.get("HTITLE1020") %><!-- 규격순 --></li></a>
	            <a href="javascript:searchSort('MAKER_NAME');"><li id="MAKER_NAME"><%=CommonLang.get("HTITLE1021") %><!-- 제조사순 --></li></a>
	            <a href="javascript:searchSort('TARGET_PRICE');"><li id="TARGET_PRICE"><%=CommonLang.get("HTITLE1022") %><!-- 품목가격순 --></li></a>
	<!--           <li class="Checked">구매 빈도수순 <img src="imgs/Icon_Arra.png" /> </li> -->
	<!--           <li>상품명순</li> -->
	<!--           <li>규격순</li> -->
	<!--           <li>제조사순</li> -->
	<!--           <li>상품가격순</li> -->
	        </ul>
	      </div>
	<%--       	<div class="buttonLeft"><label class="CheckLargeLabel"><input type="checkbox" id="CheckedAll" name="CheckedAll" onchange="javascript:checkedAll();"><span class="CheckLargeCustom"></span> <%=CommonLang.get("HTITLE1119")%><!--전체 선택--></label> </div> --%>
	        <div class="buttonRight">
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
			<!-- 공통 -->
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	      <!--상품리스트-->
	      <!-- 목록형 -->
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
	        <%if(_gridList.size()<=0 || _gridList == null) {%>
	      	<%}else{
	      		for(int j = 0; j < _gridList.size(); j++){
	      			Map<String,String> rowData = _gridList.get(j);
	      	%>
	      		<tr>
				  <td><label class="CheckLargeLabel" for="lnCheck<%=j%>"><input type="checkbox" id="lnCheck<%=j%>" name="lnCheck<%=j%>"><span class="CheckLargeCustom"></span></label></td>
				  <td>
				  	<a class="PDimg" href="javascript:getBuyerCatalogDisplayPop_v2('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');" >
				  		<%if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){%>
				  			<div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
				  		<%} %>
				  		<%if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){%>
				  			<div class="OpacityBox"><%=CommonLang.get("HTITLE394") %><!-- 단종 --></div>
				  		<%} %>
				  		<%if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){%>
						    <p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p>
						<%} %>
						<p class="BuyNumber"><%=CommonUtil.bnvl(rowData.get("PR_SEQ"))%><%=CommonLang.get("HTITLE1027") %><!-- 회 구매 --></p>
				  	<%if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){%>
				  		<img src="/resources/imgs/noimage.gif">
				  	<%}else{ %>
				  		<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"  name="image1">
				  	<%} %>
				  	</a>
				  	</td>
		          	   <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
	                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
	                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
	                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
	                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>">
	                   <input type="hidden" name="st_cart_seq" value="<%=CommonUtil.nvl(rowData.get("CART_SEQ"))%>">
		          		<input type="hidden" name="st_my_group" value="<%=CommonUtil.nvl(rowData.get("MY_GROUP"))%>">
		          		<input type="hidden" name="st_product_close_flag" value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
		          		
		          <td ><a href="javascript:getBuyerCatalogDisplayPop_v2('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');" >
		            <div class="PDTit"><span><%=rowData.get("BUYER_ITEM_NO")%></span> <%=rowData.get("DESCRIPTION")%></div>
		            <table class="PDAttribute">
		              <colgroup><col width="50px" /><col width="*" /></colgroup>              
		              <tr><th><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th><td><p class="Attribute"><%=rowData.get("SPECIFICATION")%></p></td></tr>
		              <tr><th><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th><td><%=rowData.get("MAKER_NAME")%></td></tr>
		              <tr><th><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th><td><%=rowData.get("UNIT_MEASURE")%></td></tr>
		            </table></a>
		          </td>
		          		<input type="hidden" name="st_min_order_qty"  value="<%=rowData.get("MIN_ORDER_QTY")%>">
						<input type="hidden" name="st_pur_unit_qty"  value="<%=rowData.get("PUR_UNIT_QTY")%>">
		          <%if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){ %>
		          		<input type="hidden" name="st_order_qty" id="st_order_qty" size="4" value="1">
						<td colspan="3"  >
		            		<div class="ListReq" >
		              			<img src="/resources/imgs/Icon_Warning01.png" />
		              			<p class="txt"><%=CommonLang.msg("MSG692")%><!-- 미등록품목은 견적의뢰를 통해 품목 등록 후, 구매가 가능합니다. --></p>
		            		</div>
		          		</td>
		          		
		          		<td>
		          		<%if ( p060000094 == true ) {%>
		               		<%if(p060000102==false) {%>
		          				<button onclick="javascript:doAction('reqItem','<%=j%>'); return false;" class="Btn_Estimate"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>    
		          			<%} %>
		          		<%}else{ %>
			        		<%if(p060000102==false) {%>
			        			<button onclick="javascript:doAction('reqGplItem','<%=j%>'); return false;" class="Btn_Estimate"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>     
			        		<%} %>
		        		<%} %>
				        </td>
	          	 <%}else{ %>
		          <td><p class="PDPrice"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><%=CommonLang.get("HTITLE660") %><!-- 원 --></p></td>
		          <td>
		            <div class="PDOrderNum">
					  <div class="NumInput">
						<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
						<input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>'); return false;}">
						<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
					  </div><br/>
		             <p class="NumTxt"> <%=CommonLang.get("HTITLE1028") %><!-- 최소주문 --> <span><%=rowData.get("MIN_ORDER_QTY")%></span></p> 
				     <p class="NumTxt"> <%=CommonLang.get("HTITLE1029") %><!-- 주문배수 --> <span><%=rowData.get("PUR_UNIT_QTY")%></span></p>  
					</div>
		          </td>
		          <td>
		            <div class="TotalPric"><span name="st_sum_price" id="st_sum_price_text<%=j%>"><%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("UNIT_PRICE"))),true,0,3) %></span><%=CommonLang.get("HTITLE660") %><!-- 원 --></div>  
		             <input type="hidden"  name="st_sum_price" id="st_sum_price"  value="<%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("UNIT_PRICE"))),true,0,3) %>"  readonly>           
		          </td>
		          <td >
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
	         			<%} %>
	        			
	        			<%if(rowData.get("MY_ITEM_YN").equals("Y")) {%>
		        			<button onclick="javascript:doAction('myItem','<%=j%>'); return false;" class="Favorit_on"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
		        		<%}else{ %>
		        			<button onclick="javascript:doAction('myItem','<%=j%>'); return false;" class="Favorit"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
		        		<%} %>
	        		<%} %>
		          </td>
		          <%} %>
		          
		        </tr>
		        <%} %>
	      	<%} %>
	      </table>
	      </form>
	      <!-- 이미지형 -->
	      <form name = "contentForm2" id="contentForm2" method = "post">
	      <table  class="PDListImg" id="PDImageType" style="display: none;">
	        <colgroup>
	            <col width="256px" />
	            <col width="256px" />
	            <col width="256px" />
	            <col width="256px" />
	            <col width="256px" /> 
	        </colgroup>
	        <%if(_gridList.size()<=0 || _gridList == null) {%>
	      	<%}else{
	      		for(int j = 0; j < _gridList.size(); j++){
	      			Map<String,String> rowData = _gridList.get(j);
	      			if(j%5==0){
	      	%>
	      			<tr>
	      			<%}%>
	      	
	      				<input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
	                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
	                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
	                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
	                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>">
	                   <input type="hidden" name="st_cart_seq" value="<%=CommonUtil.nvl(rowData.get("CART_SEQ"))%>">
		          		<input type="hidden" name="st_my_group" value="<%=CommonUtil.nvl(rowData.get("MY_GROUP"))%>">
		          		<input type="hidden" name="st_product_close_flag" value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
		          	<td>
		          		<a href="javascript:getBuyerCatalogDisplayPop_v2('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
			  			<div class="img">
			  			<div class="BrList"><p class="BuyNumber"><%=CommonUtil.bnvl(rowData.get("PR_SEQ"))%><%=CommonLang.get("HTITLE1027") %><!-- 회 구매 --></p>
						    <%if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){%>
							      <p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p>
							<%} %>
						</div>
			  				<%if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){%> 
						          <div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
						    <%}%>
						    <%if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){%> 
						          <div class="EstimateBox"><%=CommonLang.msg("MSG693") %><!-- 미등록품목은 견적의뢰를 통해 --></br><%=CommonLang.msg("MSG694") %><!--  품목 등록 후, 구매가 가능합니다. --></div>
						    <%}%>
			  			<%if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){%>
						    <label class="CheckLargeLabel"><input type="checkbox" id="lnCheck<%=j%>" name="lnCheck<%=j%>"><span class="CheckLargeCustom"></span></label><img src="/resources/imgs/noimage.gif"></div>
			  			<%}else{ %>
			  				<label class="CheckLargeLabel"><input type="checkbox" id="lnCheck<%=j%>" name="lnCheck<%=j%>"><span class="CheckLargeCustom"></span></label><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"  name="image1"></div>
			  			<%} %>
			  			<div class="PDCode"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></div>
	            		<div class="PDTit"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></div>
	            		</a>
	            	<input type="hidden" name="st_min_order_qty"  value="<%=rowData.get("MIN_ORDER_QTY")%>">
						<input type="hidden" name="st_pur_unit_qty"  value="<%=rowData.get("PUR_UNIT_QTY")%>">
	            	<%if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")) {%>
	            	<input type="hidden" name="st_order_qty" id="st_order_qty" size="4" value="1">
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
	            		<div class="PDPrice"><span id="st_image_sum_price_text<%=j%>"><%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("UNIT_PRICE"))),true,0,3) %></span>원</div>
				   	<input type="hidden"  name="st_sum_price" id="st_sum_price"  value="<%=CommonUtil.formatNumber(String.valueOf( Double.valueOf(CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1")) * Double.valueOf(rowData.get("UNIT_PRICE"))),true,0,3) %>"  readonly>
				   	<div class="Txt"><p><%=CommonLang.get("HTITLE1028") %><!-- 최소주문 --> <span><%=rowData.get("MIN_ORDER_QTY")%></span></p><p><%=CommonLang.get("HTITLE1029") %><!-- 주문배수 --> <span><%=rowData.get("PUR_UNIT_QTY")%></span></p></div>
				   		<%if ( p060000094 == true ) {%>
					   		<div class="NumInputSmall">
			              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
			              		<input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>'); return false;}">
			              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
		            		</div>
			             	<button onclick="javascript:doAction('cartItem','<%=j%>'); return false;" class="But_Cart"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
		           			<%if(p060000102==false) {%>
		      					<button class="Btn_EstimateSmall" onclick="javascript:doAction('reqItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>
		      				<%} %>
		      				
		      			<%}else{ %>
			      			<div class="NumInput">
			              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
			              		<input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>'); return false;}">
			              		<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
		            		</div>
		            		<button onclick="javascript:doAction('cartItem','<%=j%>'); return false;" class="But_Cart"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
		      			<%} %>
	            	<%} %>
	            </td>
	        <%if(j%5==4 || j==(_gridList.size()-1)){%>
			</tr>
		  	<%}%>
	      <%} %>
	      </table>
	      <%} %>
	      </form>       
	      <%if (_gridList != null && _gridList.size() > 0){	%>
				 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
		  <%}%>
	      <!--버튼정렬 Bottom-->
	      <div class="ButtonBottom">
	         <div class="buttonRight">
	         	<button class="ButM_Outline" onclick="javascript:doAction('checkMyItem',''); return false;"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
		        <button class="ButMPrimary" onclick="javascript:doAction('checkCartItem',''); return false;"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
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
	      <div class="h80"></div> 
	    </div><!--/container_Main -->
	    
	    <form name="processForm" id="processForm" method="post">	
		<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
		<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
		<input type="hidden" name="st_query2" id="st_query2"  value=""/>
		<input type="hidden" name="st_user_id_session" id="st_user_id_session"  value="${sessionInfo.userId}"> 
		<input type="hidden" name="st_com_code" id="st_com_code"  value="${sessionInfo.comCode}">  
		<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" />
		<input type="hidden" name="st_pf_my_group" id="st_pf_my_group" value="" />
	</form>
	<form name="locationForm" id="locationForm" method="post">	
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 		
		<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="">
		<input type="hidden" name="st_description" id="st_description" value="">
		<input type="hidden" name="st_specification" id="st_specification" value="">
		<input type="hidden" name="st_maker_name" id="st_maker_name" value="">
		<input type="hidden" name="st_desc_spec" id="st_desc_spec" value="">
		<input type="hidden" name="st_query" id="st_query"  value=""/>				
	</form>
	  </div>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
	</div>
	</body>
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
	<div id="confirmArea"  style="position:absolute; left:  250px; top: 250px; width: 500px; height: 100px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 1px solid blue; padding:20px;">
	 <h4  id="confirmMsg"></h4>  
		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:kep_confrim_search();"><%=CommonLang.get("HTITLE591")%></a>		<!-- 계속검색 -->
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();"><%=CommonLang.get("HTITLE592")%></a>	<!-- 이동 -->
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_cancel();"><%=CommonLang.get("HTITLE229")%></a> 	<!-- 취소 -->		
				</span>					
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
	// 최초 화면 함수 
	function kep_onload_view(){
		if ($("#st_from_date").val() == "") {
			$("#st_from_date").val(kepToMonthAdd("3","M"));
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		//sort순
		var st_search_sort = "<%=searchSort%>";
		if(st_search_sort != ""){ //기본 값 아니면
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
			if(upDown =="DOWN")
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
			imageButton.classList.remove("ButListImg_on");
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
	
	var st;
	//기능함수
	function doAction(str , gubun) {	
		
		switch (str) {
			case "search":	 //조회
			
				// 정렬순서 조정
	// 			if (gubun != ""){			
	// 				$("#st_sort_gubun").val(gubun); 
	// 			    if($("#st_sort_change").val() == '0'){
	// 			    	$("#st_sort_change").val("1");
	// 			    }else {
	// 			    	$("#st_sort_change").val("0");
	// 			    }
	// 			} else {
	// 				$("#st_sort_gubun").val(""); 
	// 				$("#st_sort_change").val("");
	// 			}
			
				kepSearch(1);
				break;
				
			case "reload":	//초기화
				$("#keyword_sel").val("");
				$("#st_keyword").val("");
				kepMonth_v2('st_from_date','st_to_date','3');
				
		// 		kepSearch(-1);
	// 			jspTableClean("table_list");
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
	//	 		document.getElementById("st_my_groups").style.display = "none";
	//	 		$("#st_my_group_nm").val("");
				saveProcess("C",gubun);
				break;  	
			case "checkCartItem": // 장바구니 담기
	//	 		document.getElementById("st_my_groups").style.display = "none";
	//	 		$("#st_my_group_nm").val("");
				saveCheckProcess("C");
				break;  
			case "reqItem": // 신규견적입력
				saveRqdtProcess(gubun);
				break; 	
			case "reqGplItem": // GPL, 미계약, 단종 건 견적입력
	// 			document.getElementById("st_my_groups").style.display = "none";
	//	 		$("#st_my_group_nm").val("");
				saveRqdtGplProcess(gubun);
				break;
		}
	}
	function getBuyerCatalogDisplayPop_v2(BUYER,BUYER_ITEM_NO,CONTRACT_NO,CONTRACT_SEQ){
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+BUYER+"&BUYER_ITEM_NO="+escape(BUYER_ITEM_NO)+"&CONTRACT_NO="+CONTRACT_NO+"&CONTRACT_SEQ="+CONTRACT_SEQ+"&popupCheck=N";
		openLayerPop(src,"650px","600px");
	}
	// 조회
	function kepSearch(curPage){
		
		document.forms.searchForm.curPage.value = curPage; 
		$('#searchForm').attr("action", "/mdcm/getBuyerMdCmHistoryGoodsSearchList.do").submit();   
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
	    var p060000077 = "<%=p060000077%>"; //MOQ
		var p060000089 = "<%=p060000089%>"; //주문배수
	
	    var type = $("#st_list_type").val();
	    if(type == "list"){
	    	if(eval(tot_cnt) < 2){
	         	var order_qty     = document.forms["contentForm"].st_order_qty.value;
	       		var st_item_no   = document.forms["contentForm"].st_item_no.value;
				var st_order_qty = document.forms["contentForm"].st_order_qty.value;
				var st_agent     = document.forms["contentForm"].st_agent_code.value;
				var contract_no  = document.forms["contentForm"].st_contract_no.value;
				var contract_seq = document.forms["contentForm"].st_contract_seq.value;
				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code.value;
				var st_min_order_qty = document.forms["contentForm"].st_min_order_qty.value;
				var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty.value;
	             if(flag == "C"){
	            	//MOQ 주문 통제 특수로직 적용한 고객사 한정
	          		if(p060000077 == "true"){
	          			if(Number(order_qty) < Number(st_min_order_qty)){
	          				//수량을 최소주문보다 크게 입력 바랍니다.
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
	          	       		//주문배수만큼 수량 입력 바랍니다. 
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
	            
				query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
	     	}else{
	            var order_qty     = document.forms["contentForm"].st_order_qty[y_num].value;
				var st_item_no   = document.forms["contentForm"].st_item_no[y_num].value;
				var st_order_qty = document.forms["contentForm"].st_order_qty[y_num].value;
				var st_agent     = document.forms["contentForm"].st_agent_code[y_num].value;
				var contract_no  = document.forms["contentForm"].st_contract_no[y_num].value;
				var contract_seq = document.forms["contentForm"].st_contract_seq[y_num].value;
				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code[y_num].value;
				var st_min_order_qty = document.forms["contentForm"].st_min_order_qty[y_num].value;
				var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty[y_num].value;
	            if(flag == "C"){
	            	//MOQ 주문 통제 특수로직 적용한 고객사 한정
	          		if(p060000077 == "true"){
	          			if(Number(order_qty) < Number(st_min_order_qty)){
	          				//수량을 최소주문보다 크게 입력 바랍니다.
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
	          	       		//주문배수만큼 수량 입력 바랍니다. 
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
			  	query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
			  	query += "&&";
	     	}
	    }else{
	    	if(eval(tot_cnt) < 2){
	         	var order_qty     = document.forms["contentForm2"].st_order_qty.value;
	       		var st_item_no   = document.forms["contentForm2"].st_item_no.value;
				var st_order_qty = document.forms["contentForm2"].st_order_qty.value;
				var st_agent     = document.forms["contentForm2"].st_agent_code.value;
				var contract_no  = document.forms["contentForm2"].st_contract_no.value;
				var contract_seq = document.forms["contentForm2"].st_contract_seq.value;
				var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code.value;
				var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty.value;
				var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty.value;
	             if(flag == "C"){
	             	//MOQ 주문 통제 특수로직 적용한 고객사 한정
	           		if(p060000077 == "true"){
	           			if(Number(order_qty) < Number(st_min_order_qty)){
	           				//수량을 최소주문보다 크게 입력 바랍니다.
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
	           	       		//주문배수만큼 수량 입력 바랍니다. 
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
	             
				query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
	     	}else{
	            var order_qty     = document.forms["contentForm2"].st_order_qty[y_num].value;
				var st_item_no   = document.forms["contentForm2"].st_item_no[y_num].value;
				var st_order_qty = document.forms["contentForm2"].st_order_qty[y_num].value;
				var st_agent     = document.forms["contentForm2"].st_agent_code[y_num].value;
				var contract_no  = document.forms["contentForm2"].st_contract_no[y_num].value;
				var contract_seq = document.forms["contentForm2"].st_contract_seq[y_num].value;
				var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code[y_num].value;
				var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty[y_num].value;
				var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty[y_num].value;
	            if(flag == "C"){
	            	//MOQ 주문 통제 특수로직 적용한 고객사 한정
	          		if(p060000077 == "true"){
	          			if(Number(order_qty) < Number(st_min_order_qty)){
	          				//수량을 최소주문보다 크게 입력 바랍니다.
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
	          	       		//주문배수만큼 수량 입력 바랍니다. 
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
	 function saveCheckProcess(flag){    
		    var tot_cnt  = $("#display_item_cnt").val();
		    var chk_cnt = 0;
		    var cnt     = 0;
		    var query   = "";
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
		    		        var st_item_no   = document.forms["contentForm"].st_item_no.value;
		    				var st_order_qty = document.forms["contentForm"].st_order_qty.value;
		    				var st_agent     = document.forms["contentForm"].st_agent_code.value;
		    				var contract_no  = document.forms["contentForm"].st_contract_no.value;
		    				var contract_seq = document.forms["contentForm"].st_contract_seq.value;
		    				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code.value;
		    				var st_min_order_qty = document.forms["contentForm"].st_min_order_qty.value;
		    				var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty.value;
		                    if(flag == "C"){
		                    	//MOQ 주문 통제 특수로직 적용한 고객사 한정
		                  		if(p060000077 == "true"){
		                  			if(Number(order_qty) < Number(st_min_order_qty)){
		                  				//수량을 최소주문보다 크게 입력 바랍니다.
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
		                  	       		//주문배수만큼 수량 입력 바랍니다. 
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
		    					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
		                }
		            }else{
		                for(var i = 0; i <tot_cnt; i++){
		                    var box = eval('document.forms["contentForm"].lnCheck' + i);
		                    var order_qty     = document.forms["contentForm"].st_order_qty[i].value;
		                    var st_item_no   = document.forms["contentForm"].st_item_no[i].value;
		                    var st_order_qty = document.forms["contentForm"].st_order_qty[i].value;
		    				var st_agent     = document.forms["contentForm"].st_agent_code[i].value;
		    				var contract_no  = document.forms["contentForm"].st_contract_no[i].value;
		    				var contract_seq = document.forms["contentForm"].st_contract_seq[i].value;
		    				var byit_comorg_code = document.forms["contentForm"].st_byit_comorg_code[i].value;
		    				var st_min_order_qty = document.forms["contentForm"].st_min_order_qty[i].value;
		    				var st_pur_unit_qty = document.forms["contentForm"].st_pur_unit_qty[i].value;
		                    if(box.checked == true){
		                        if(flag == "C"){
		                        	//MOQ 주문 통제 특수로직 적용한 고객사 한정
		                      		if(p060000077 == "true"){
		                      			if(Number(order_qty) < Number(st_min_order_qty)){
		                      				//수량을 최소주문보다 크게 입력 바랍니다.
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
		                      	       		//주문배수만큼 수량 입력 바랍니다. 
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
		                        
		                        
		    					  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		    					  query += "&&";
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
		    		        var st_item_no   = document.forms["contentForm2"].st_item_no.value;
		    				var st_order_qty = document.forms["contentForm2"].st_order_qty.value;
		    				var st_agent     = document.forms["contentForm2"].st_agent_code.value;
		    				var contract_no  = document.forms["contentForm2"].st_contract_no.value;
		    				var contract_seq = document.forms["contentForm2"].st_contract_seq.value;
		    				var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code.value;
		    				var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty.value;
		    				var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty.value;
		                    if(flag == "C"){
		                    	//MOQ 주문 통제 특수로직 적용한 고객사 한정
		                  		if(p060000077 == "true"){
		                  			if(Number(order_qty) < Number(st_min_order_qty)){
		                  				//수량을 최소주문보다 크게 입력 바랍니다.
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
		                  	       		//주문배수만큼 수량 입력 바랍니다. 
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
		                    
		                    
		    					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
		                }
		            }else{
		                for(var i = 0; i <tot_cnt; i++){
		                    var box = eval('document.forms["contentForm2"].lnCheck' + i);
		                    var order_qty     = document.forms["contentForm2"].st_order_qty[i].value;
		    				var st_item_no   = document.forms["contentForm2"].st_item_no[i].value;
		    				var st_order_qty = document.forms["contentForm2"].st_order_qty[i].value;
		    				var st_agent     = document.forms["contentForm2"].st_agent_code[i].value;
		    				var contract_no  = document.forms["contentForm2"].st_contract_no[i].value;
		    				var contract_seq = document.forms["contentForm2"].st_contract_seq[i].value;
		    				var byit_comorg_code = document.forms["contentForm2"].st_byit_comorg_code[i].value;
		    				var st_min_order_qty = document.forms["contentForm2"].st_min_order_qty[i].value;
		    				var st_pur_unit_qty = document.forms["contentForm2"].st_pur_unit_qty[i].value;
		                    if(box.checked == true){
		                        
		                        if(flag == "C"){
		                        	//MOQ 주문 통제 특수로직 적용한 고객사 한정
		                      		if(p060000077 == "true"){
		                      			if(Number(order_qty) < Number(st_min_order_qty)){
		                      				//수량을 최소주문보다 크게 입력 바랍니다.
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
		                      	       		//주문배수만큼 수량 입력 바랍니다. 
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
		     
		    document.forms.locationForm.st_query.value = query; 
		    $('#locationForm').attr("action", "/mprq/showBuyerMpRqRequestQuotation_v2.do?menuId=br00101000000&tabIndex=1&itemFlag=Y").submit();
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
	
		    		if((contract_no != null || contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
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
		            if((contract_no != null || contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
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
	
		    		if((contract_no != null || contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
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
		            if((contract_no != null || contract_no != "") && contract_no != "PC" && product_close_flag == "N" ){
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
			
	//	     $('body,html').animate({
	//	 		scrollTop: 0
	//	 	}, 100);
			runRqdtGplProcess();
		<%-- 	$("#confirmMyGroupMsg").text("<%=CommonLang.msg("MSG498") %>");	//견적 임시 저장하시고 신규견적 임시저장 조회 화면으로 이동하시겠습니까? --%>
	//	 	$("#confirmMyGroupArea").show();
	//	 	$("#confirmMyGroupAreaOverlay").show();
		}
	
		function runRqdtGplProcess() {  	
			$("#confirm4").val("save");
			var gubun = $("#confirm1").val();
			var query = $("#confirm2").val();
			
			document.forms.locationForm.st_query.value = query;
			kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationGpl.do","locationForm",gubun); 
		}
	/*
	 * 이력상품검색 화면에서 삭제
	 */
	function delProcess(){    
	
	    var tot_cnt  = $("#display_item_cnt").val(); // 총 건수
	    var chk_cnt = 0;  // 체크되어있는 건수
	    var query   = "";
	    
	    if(tot_cnt == 0 || kepIsValueNull(tot_cnt)){
			//  목록에 표시된 상품이 없습니다.
	    	alert("<%=CommonLang.msg("MSG16")%>");  
	        return;
	    }
	
	
		if(eval(tot_cnt) < 2){
			var box = eval("document.forms.contentForm.lnCheck0" ); 
			if(box.checked == true){
				chk_cnt++;
				var st_item_no   = document.forms.contentForm.st_item_no.value;
	
				query += st_item_no + "&&";
			}
		}else{
			for(var i = 0; i <tot_cnt; i++){
				var box = eval("document.forms.contentForm.lnCheck" + i);
				if(box.checked == true){
					chk_cnt++;
					var st_item_no   = document.forms.contentForm.st_item_no[i].value;
	                
					query += st_item_no + "&&";
	            }
	        }
	    }
	    
	    if(chk_cnt == "0"){
	    	// 하나 이상의 상품이 선택되어야 합니다.
	    	alert("<%=CommonLang.msg("MSG17")%>");
	        return;
	    } 
	    
	    
		if(!confirm("선택하신 상품을 이력상품검색에서 삭제하시겠습니까?")){
			return;
		}
		
		document.forms.processForm.st_query2.value = query;
		kepAjaxFormCall("/mdcm/removebuyerMdCmHistoryGoodsItem.do","processForm","delProcess");
	    
		console.log(query);
	}
	function kep_showConfirm(){
		
		
		var runFlag = $("#confirm1").val();
		var query = $("#confirm2").val();
		var flag = $("#confirm3").val();
		
	    var msg = "";
	    if (runFlag == "CsaveProcess"){
	    	runProcess();
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
	
	/** 
	 
	 desc ICOMCART
	 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
	 
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
		       }else if(pMethod == "save"){
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
	    }else{     
	    	$('#locationForm2').attr("action", "/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit();   
	    }
	}
	function thisPopClose2(){
		closePopText1();
		kepSearch($("#curPage").val());
	}
	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxError(pMethod , response) {	
		
		if (pMethod == "CsaveProcess"){ 
			//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
			 alert("<%=CommonLang.msg("MSG26")%>"); 
		}else if (pMethod == "RsaveProcess"){ 
			//나의상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
			 alert("<%=CommonLang.msg("MSG27")%>"); 
		}  
		 
		
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
	         		 document.forms["contentForm"].st_sum_price.value = kepCommaNum(unit_price);
	//          		 document.forms["contentForm"].st_sum_price_text.innerHTML = kepCommaNum(unit_price);
	         		 $("#st_sum_price_text"+y_num).html(kepCommaNum(unit_price));
	         	 }else{
	                  st_sum_price = kepGetRound((order_qty * unit_price),3);
	                  document.forms["contentForm"].st_sum_price.value = kepCommaNum(st_sum_price);
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
	         		 document.forms["contentForm"].st_sum_price[y_num].value = kepCommaNum(unit_price);
	//          		document.forms["contentForm"].st_sum_price_text[y_num].innerHTML = kepCommaNum(unit_price);
	         		$("#st_sum_price_text"+y_num).html(kepCommaNum(unit_price)); 
	         	 }else{
	                  st_sum_price = kepGetRound((order_qty * unit_price),3);
	                  document.forms["contentForm"].st_sum_price[y_num].value = kepCommaNum(st_sum_price);
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
	         		 document.forms["contentForm2"].st_sum_price.value = kepCommaNum(unit_price);
	//          		document.forms["contentForm2"].st_sum_price_text.innerHTML = kepCommaNum(unit_price);
	         		 $("#st_image_sum_price_text"+y_num).html(kepCommaNum(unit_price));
	         	 }else{
	                  st_sum_price = kepGetRound((order_qty * unit_price),3);
	                  document.forms["contentForm2"].st_sum_price.value = kepCommaNum(st_sum_price);
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
	         		 document.forms["contentForm2"].st_sum_price[y_num].value = kepCommaNum(unit_price);
	//          		document.forms["contentForm2"].st_sum_price_text[y_num].innerHTML = kepCommaNum(unit_price);
	         		$("#st_image_sum_price_text"+y_num).html(kepCommaNum(unit_price)); 
	         		
	         	 }else{
	                  st_sum_price = kepGetRound((order_qty * unit_price),3);
	                  document.forms["contentForm2"].st_sum_price[y_num].value = kepCommaNum(st_sum_price);
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
		        document.forms["contentForm"].st_sum_price.value = kepCommaNum(st_sum_price);
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
		        document.forms["contentForm"].st_sum_price[y_num].value = kepCommaNum(st_sum_price);
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
		        document.forms["contentForm2"].st_sum_price.value = kepCommaNum(st_sum_price);
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
		        document.forms["contentForm2"].st_sum_price[y_num].value = kepCommaNum(st_sum_price);
	// 	        document.forms["contentForm2"].st_sum_price_text[y_num].innerHTML = kepCommaNum(st_sum_price);
		        $("#st_image_sum_price_text"+y_num).html(kepCommaNum(st_sum_price));
			}
		}
		
		
	}
	function checkedAll(){
		var isChecked =$("#CheckedAll").is(":checked");
		for (var i = 0; i < <%=grid_cnt%>; i++) {
			$("input[name=lnCheck"+i+"]").prop('checked', isChecked);
		}
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
		document.forms.searchForm.searchSort.value = gubun + "_"+st_sort_change; 
	// 	document.forms.searchDiForm.st_sort_change.value = st_sort_change;
		//alert(document.forms.searchDiForm.searchSort.value);
		kepSearch(1);
	}
	
	</script>
	</html>
