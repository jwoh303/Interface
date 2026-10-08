<%--
**********************************************
* 메뉴 : 마이페이지 > 관심상품
* 화면 : 관심상품
* 기능 : 관심상품 등록한 상품 리스트를 보여준다.
* 프로그램 ID : BU0803001
* 담당자 : 최찬규
* 착수일 : 2026-02-25
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
	List<Map<String,String>> _totalList = (List<Map<String,String>>) request.getAttribute("total_data"); // 조회된 결과
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	List<Map<String,String>> _gridPagingList = (List<Map<String,String>>) request.getAttribute("paging_data"); // 조회된 결과
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
	String total_cnt = "0"; // 총 조회수 (필수)
	String grid_cnt = "0"; // 리스트 조회 수 
	String grid_paging_cnt = "0";
	if(_totalList != null && _totalList.size()>0){
		total_cnt = String.valueOf(_totalList.size());
	}
	if(_gridList != null && _gridList.size()>0){
		grid_cnt = String.valueOf(_gridList.size());
	}
	if(_gridPagingList != null && _gridPagingList.size()>0){
		grid_paging_cnt = String.valueOf(_gridPagingList.size());
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
	String st_my_groups = CommonUtil.nvl((String) request.getParameter("st_my_groups"),"");
	String st_list_type = CommonUtil.nvl((String) request.getParameter("st_list_type"),"list");
	// 조회조건 E	
	
	String SessionComCode = "";
	String SessionUserId = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");   
	String img_view_flag   = "";
	String user_group = "";
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
		SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId());
		user_group = CommonUtil.nvl((String)sessionInfo.getUserGroup()); //사용자견적권한
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
	
	//관심상품 분류 리스트
	List<Map<String,String>> myItemList =  CommonUtil.getCode3List(SessionComCode, "SEL", "ITEM",SessionUserId, "ICOMCOD3_v2", "", "");
	
	int noGroupCnt = 0; //미분류
	int myItemListSize = 0;
	if(myItemList.size()>0 && myItemList != null){
		myItemListSize = myItemList.size();
		for(int i = 0; i < _totalList.size(); i++){
			if(CommonUtil.bnvl(_totalList.get(i).get("MY_GROUP")).equals("") || CommonUtil.bnvl(_totalList.get(i).get("MY_GROUP")).equals("MCDEFAULT")){ //기본폴더 처리
				noGroupCnt ++;
			}else{
				for(int j = 0; j<myItemList.size(); j++){
					if(_totalList.get(i).get("MY_GROUP").equals(myItemList.get(j).get("CODE2"))){
						int cnt = Integer.valueOf(CommonUtil.nvl(myItemList.get(j).get("VALUE1"),"0"));
						cnt ++;
						myItemList.get(j).put("VALUE1", String.valueOf(cnt));
					}
				}
			}
		}
	}else{
		noGroupCnt = _totalList.size();
	}
%> 

<body onload="kep_onload_view()">
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
    <%=CommonLang.get("HTITLE1016")%><!-- 관심상품 --> <%if(myMenuFlag) {%>
          <button class="But_Star_on"></button>
     	<%}else{ %>
     	  <button class="But_Star_off"></button>
     	<%} %> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE987")%><!-- 마이페이지 --></li>
        <li><%=CommonLang.get("HTITLE1016")%><!-- 관심상품 --></li>
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
		<input type="hidden" name="st_my_groups" id="st_my_groups" value="<%=st_my_groups%>">
		<input type="hidden" name="st_list_type" id="st_list_type" value="<%=st_list_type %>">
    <div class="FavoriteFolder mt35">
      <div class="FPDFolderBox">
      <div <%if(st_my_groups.equals("")) {%> class="FPDFolder_on" <%}else{ %> class="FPDFolder" <%} %> onclick="javascript:clickFolder('')"><p class="HeartWon"><p class="HeartNUm"><%=total_cnt %></p></p><p class="HeartFont"><%=CommonLang.get("HTITLE29") %><!-- 전체 --></p></div>
      <div <%if(st_my_groups.equals("기본")) {%> class="FPDFolder_on" <%}else{ %> class="FPDFolder" <%} %> onclick="javascript:clickFolder('기본')"><p class="HeartWon"><p class="HeartNUm"><%=noGroupCnt %></p></p><p class="HeartFont"><%=CommonLang.get("HTITLE1065") %><!-- 기본 --></p></div>
      <%if(myItemList.size()<=0 || myItemList == null) {%>
      <%}else{ %>
      	<%for(int i = 0 ; i<myItemList.size(); i++) {
      		if(myItemList.get(i).get("CODE2").equals("MCDEFAULT"))
     			continue;
      	%>
      	<input type="hidden" name="myFolder" id="myFolder<%=i %>" value="<%=myItemList.get(i).get("CODE2")%>">
      	<div <%if(st_my_groups.equals(myItemList.get(i).get("CODE2"))) {%> class="FPDFolder_on" <%}else{ %> class="FPDFolder" <%} %> onclick="javascript:clickFolder('<%=myItemList.get(i).get("CODE2")%>')"><p class="HeartWon"><p class="HeartNUm"><%=CommonUtil.nvl(myItemList.get(i).get("VALUE1"),"0")%></p></p><p class="HeartFont"><%=myItemList.get(i).get("TEXT1")%></p></div>
      	<%} %>
      <%} %>
        <div class="FPDFolder_add" onclick="javascript:doAction('addCateg','');" style="cursor: pointer;"><p class="Plus"></p><p class="PlusFont"><%=CommonLang.get("HTITLE1116")%><!--새폴더--></p></div>
      </div>
      <div class="FolderHide"></div>
      <div class="FPDFolder_setting" onclick="javascript:doAction('setCateg','');" style="cursor: pointer;"><p class="setting"></p><p class="settingFont"><%=CommonLang.get("HTITLE1117")%><!--폴더관리--></p></div>
    </div>
	<script >
     const box = document.querySelector('.FPDFolderBox');
    
    box.addEventListener('scroll', function(){
      const isEnd = box.scrollLeft + box.clientWidth >= box.scrollWidth - 1;
      box.classList.toggle('is-end', isEnd);
    });   
    </script>      
    <div class="FavoriteSearch1280 mt35">
    <table class="FavoriteSearchTable" >
        <tr>
          <th width="80px"><%=CommonLang.get("HTITLE13")%><!--품목명--></th>
          <td width="250px"><input class="input40" style="width:190px" name="st_description" id="st_description" type="text" value="<%=st_description %>" onKeyDown="kepEnter_v2()"/></td>
          <th width="80px"><%=CommonLang.get("HTITLE12")%><!--품목코드--></th>
          <td width="250px"><input class="input40" style="width:190px" name="st_buyer_item_no" id="st_buyer_item_no" type="text" value="<%=st_buyer_item_no %>" onKeyDown="kepEnter_v2()"/></td>
          <th width="80px"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
          <td width="250px"><input class="input40" style="width:190px" name="st_specification" id="st_specification" type="text" value="<%=st_specification %>" onKeyDown="kepEnter_v2()"/></td>
          <th width="80px"><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
          <td width="210px"><input class="input40" style="width:190px" name="st_maker_name" id="st_maker_name" type="text" value="<%=st_maker_name %>" onKeyDown="kepEnter_v2()"/></td>
		</tr>           
      </table>
    </div>
    <div class="SearchResultBtnBox"><div class="SearchResultBtnBox1280"><div class="Center"> <button class="ButOutline_Medium" onclick="javascript:doAction('reload',''); return false;" ><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></button> <button class="ButDarkGray_Medium" onclick="javascript:doAction('search',''); return false;"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></button></div>         </div> </div>         
	<div class="container"  >
      <!--리스트정렬-->
      <div class="SearchResultTitSum mt50 pb20">
        <%=CommonLang.get("HTITLE921") %><!-- 총 --> <%=grid_cnt %><%=CommonLang.get("HTITLE595") %><!-- 건 -->
        <div class="buttonRight">
         <button class="ButOutline_Medium" onclick="javascript:doAction('removeCheck'); return false;"><%=CommonLang.get("HTITLE25")%><!--삭제--></button>
         <button class="ButOutline_Medium" onclick="javascript:doAction('saveCheckCateg'); return false;"><%=CommonLang.get("HTITLE1118")%><!--폴더이동--></button>
         <button class="ButPrimary_Medium" onclick="javascript:doAction('cartCheckItem'); return false;"><%=CommonLang.get("HTITLE11")%><!--장바구니--></button>
        </div>
      </div> 
      <div class="Array">
      	<div class="buttonLeft"><label class="CheckLargeLabel"><input type="checkbox" id="CheckedAll" name="CheckedAll" onchange="javascript:checkedAll();"><span class="CheckLargeCustom"></span> <%=CommonLang.get("HTITLE1119")%><!--전체 선택--></label> </div>
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
			  <td class="PDimg" name="PDimg">
			  		<%if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){%>
			  			<div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
			  		<%} %>
			  		<%if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){%>
			  			<div class="OpacityBox"><%=CommonLang.get("HTITLE394") %><!-- 단종 --></div>
			  		<%} %>
			  		<%if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){%>
					    <p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p>
					<%} %>
				<a href="javascript:getBuyerCatalogDisplayPop_v2('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');" >
			  	<%if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){%>
			  		<img src="/resources/imgs/noimage.gif">
			  	<%}else{ %>
			  		<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"  name="image1">
			  	<%} %>
			  	</a>
	          	   <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
                   <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
                   <input type="hidden" name="st_cart_seq" value="<%=CommonUtil.nvl(rowData.get("CART_SEQ"))%>">
	          		<input type="hidden" name="st_my_group" value="<%=CommonUtil.nvl(rowData.get("MY_GROUP"))%>">
	          		<input type="hidden" name="st_product_close_flag" value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
	          		
	          <td ><a href="javascript:getBuyerCatalogDisplayPop_v2('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');" >
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
<%-- 	             <button class="List" onclick="javascript:doAction('remove','<%=j%>'); return false;"><%=CommonLang.get("HTITLE25")%><!--삭제--></button> --%>
<%-- 	             <button class="Favorit" onclick="javascript:doAction('saveCateg','<%=j%>'); return false;"><%=CommonLang.get("HTITLE1118")%><!-- 폴더이동 --></button> --%>
	             <button class="Cart" onclick="javascript:doAction('cartItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE11")%><!-- 장바구니 --></button>
	             <%if ( p060000094 == true ) {%>
         			<%if(p060000102==false) {%>
		          		<button onclick="javascript:doAction('reqItem','<%=j%>'); return false;" class="ListReq_s"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>    
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
                   <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
                   <input type="hidden" name="st_cart_seq" value="<%=CommonUtil.nvl(rowData.get("CART_SEQ"))%>">
	          		<input type="hidden" name="st_my_group" value="<%=CommonUtil.nvl(rowData.get("MY_GROUP"))%>">
	          		<input type="hidden" name="st_product_close_flag" value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
	          	<td>
	          		<a href="javascript:getBuyerCatalogDisplayPop_v2('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
		  			<div class="img">
		  				<%if(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("Y")){%> 
					          <div class="OpacityBox"><%=CommonLang.get("HTITLE596") %><!-- 품절 --></div>
					    <%}%>
					    <%if(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("Y")){%> 
					          <div class="EstimateBox"><%=CommonLang.msg("MSG693") %><!-- 미등록품목은 견적의뢰를 통해 --></br><%=CommonLang.msg("MSG694") %><!--  품목 등록 후, 구매가 가능합니다. --></div>
					    <%}%>
					    <%if(!CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM")).equals("") ){%>
						      <div class="BrList"><p class="EcoFriendly"><%=CommonUtil.nvl(rowData.get("BUY_GREEN_ITEM_NM"))%></p></div>
						<%} %>
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
	              			<input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>');return false;}">
	              			<button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
            			</div>
		             	<button class="But_Cart" onclick="javascript:doAction('cartItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE11")%><!--장바구니--></button>
	           			<%if(p060000102==false) {%>
	      					<button class="Btn_EstimateSmall" onclick="javascript:doAction('reqItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE39") %><!-- 견적의뢰 --></button>
	      				<%} %>
	      				
	      			<%}else{ %>
	      				<div class="NumInput">
			              <button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','M','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">-</button>
			              <input type="text" name="st_order_qty" id="st_order_qty" size="4" value="<%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13){event.preventDefault(); javascript:getPriceUpdate(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>');return false;}">
			              <button onclick="javascript:getOrderQty(this.value,'<%=j%>','<%=rowData.get("UNIT_PRICE")%>','P','<%=rowData.get("PUR_UNIT_QTY")%>'); return false;">+</button>
            			</div>
	              		<button class="But_Cart" onclick="javascript:doAction('cartItem','<%=j%>'); return false;"><%=CommonLang.get("HTITLE11")%><!--장바구니--></button>
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
           <button class="ButOutline_Medium" onclick="javascript:doAction('removeCheck'); return false;"><%=CommonLang.get("HTITLE25")%><!--삭제--></button>
           <button class="ButOutline_Medium" onclick="javascript:doAction('saveCheckCateg'); return false;"><%=CommonLang.get("HTITLE1118")%><!--폴더이동--></button>
           <button class="ButPrimary_Medium" onclick="javascript:doAction('cartCheckItem'); return false;" ><%=CommonLang.get("HTITLE11")%><!--장바구니--></button>
         </div>
      </div>
      <!-- 페이징 -->
	<div class="Paging mt20">
<!--        <button class="ButPagLeft02"></button> -->
<!--        <button class="ButPagLeft01"></button> -->
	<%=CommonUtil.getPageSearchView("kepSearch",grid_paging_cnt, curPage ,onepagerow) %>
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
  </div><!--/containerBox -->
 


<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" />
	<input type="hidden" id="st_type" name="st_type"  value="ITEM">
	<input type="hidden" name="TEXT1" id="TEXT1" value="" /> 
	<input type="hidden" name="TEXT2" id="TEXT2" value="" /> 
	<input type="hidden" name="TEXT3" id="TEXT3" value="" /> 
	<input type="hidden" name="TEXT4" id="TEXT4" value="" /> 
</form>

<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	<input type="hidden" name="st_query" id="st_query" value=""> 
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
         <button class="ButQuaternary_large" style=" width:100px" onclick="javascript:kep_confirm_cancel(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:kep_confirm_location(); return false;"><%=CommonLang.get("HTITLE592") %><!-- 이동 --></button>
         <button class="ButPrimary_large" style=" width:100px" onclick="javascript:kep_confrim_search();return false;"><%=CommonLang.get("HTITLE591") %><!-- 계속검색 --></button>
       </div>  
     </div><!-- wrapPopup 끝-->  
 </div><!-- DIVpopup 끝-->
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";
var g_row = "";

// 최초 화면 함수 
function kep_onload_view(){
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
}
  

var st;
//기능함수
function doAction(str , gubun) {
	switch (str) {
	case "search":	 //조회 
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		document.forms.searchForm.st_buyer_item_no.value = "";
		document.forms.searchForm.st_description.value = "";
		document.forms.searchForm.st_specification.value = "";
		document.forms.searchForm.st_maker_name.value = "";
// 		document.forms.searchForm.st_list_type.value = "list";
		document.forms.searchForm.st_my_groups.value = "";

// 		jspTableClean("table_list");
		break; 
		
	case "remove": // 나의상품 담기한결과 삭제
		saveProcess("D",gubun);
		break;  
	
	case "cartItem": // 장바구니 담기
		saveProcess("C",gubun);
		break;
	case "removeCheck": // 나의상품 담기한결과 삭제
		saveCheckProcess("D");
		break;  
	
	case "cartCheckItem": // 장바구니 담기
		saveCheckProcess("C");
		break; 
	case "addCateg": // 새폴더
		var myItemListSize = "<%=myItemListSize%>";
// 		if(myItemListSize >=7){
// 			//폴더는 최대 7개까지 추가 가능합니다.
<%-- 			var text = "<%=CommonLang.msg("MSG689")%>  "; --%>
// 			openLayerPopText2(text,but1text,but1func,but1width);
// 			return;
// 		}
		popupSel = "addCateg";
// 		openSearchPopup("/common/addMyCatalogPop.do","","600,450,no");
		var src = '/common/addMyCatalogPop.do';
		openLayerPop(src,"450px","300px");
		break;
	case "setCateg": //폴더관리
// 		openSearchPopup("/common/addMyCatalogPop.do","","600,450,no");
		var src = '/common/setMyCatalogPop_v2.do';
		openLayerPop(src,"500px","520px");
		break;
	case "saveCateg": // 폴더이동
		var myItemListSize = "<%=myItemListSize%>";
		if(myItemListSize == 0){
			//관심상품 폴더를 먼저 추가해주세요.
			var text = "<%=CommonLang.msg("MSG680")%>  ";
			 openLayerPopText2(text,but1text,but1func,but1width);
			 return;
		}
		popupSel = "saveCateg";
		g_row = gubun;
		var src = '/common/saveMyCatalogPop_v2.do';
		openLayerPop(src,"520px","520px");
		break;
	case "saveCheckCateg": // 폴더이동
		var myItemListSize = "<%=myItemListSize%>";
		if(myItemListSize == 0){
			//관심상품 폴더를 먼저 추가해주세요.
			var text = "<%=CommonLang.msg("MSG680")%>  ";
			 openLayerPopText2(text,but1text,but1func,but1width);
			 return;
		}
		saveCheckCateg();
		break;
	case "reqItem": // 신규견적입력
		saveRqdtProcess(gubun);
		break; 	
	case "reqGplItem": // GPL, 미계약, 단종 건 견적입력
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
	document.forms.searchForm.st_list_type.value = $("#st_list_type").val();
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit(); 
} 

function saveCheckCateg(){
	var tot_cnt  = $("#display_item_cnt").val();
	var chk_cnt = 0;
	
	if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        //  목록에 표시된 상품이 없습니다.
    	var text = "<%=CommonLang.msg("MSG16") %>  ";
		 openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    var type = $("#st_list_type").val();
    if(type == "list"){
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
        	//폴더 이동할 상품을 선택해주세요.
        	var text = "<%=CommonLang.msg("MSG678") %>";
    		openLayerPopText2(text,but1text,but1func,but1width);
            return;
        }
    }else{
    	if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm2.lnCheck0");
            if(box.checked == true) chk_cnt++;
        }else{
            for(var j = 0; j < tot_cnt; j++){
                 var box = eval("document.forms.contentForm2.lnCheck" + j);
                 if(box.checked == true){
                      chk_cnt++;
                 }
            }
        }
        if(chk_cnt == "0"){
        	//폴더 이동할 상품을 선택해주세요.
        	var text = "<%=CommonLang.msg("MSG678") %>";
    		openLayerPopText2(text,but1text,but1func,but1width);
            return;
        }
    }
    
    
    popupSel = "saveCheckCateg";
	var src = '/common/saveMyCatalogPop_v2.do';
	openLayerPop(src,"520px","500px");
}




/*
 * 나의상품삭제 D
 * 장바구니담기 C
 * 나의분류저장 S
 */
function saveProcess(flag,y_num){   
	var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var p060000077 = "<%=p060000077%>"; //MOQ
	var p060000089 = "<%=p060000089%>"; //주문배수
	
	var type = $("#st_list_type").val();
	if(type == "list"){
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
				var st_my_group     = document.forms.contentForm.st_my_group.value;
				var st_cart_seq     = document.forms.contentForm.st_cart_seq.value;
				var st_min_order_qty = document.forms.contentForm.st_min_order_qty.value;
				var st_pur_unit_qty = document.forms.contentForm.st_pur_unit_qty.value;

                if (flag == "C"){ // 장바구니
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
                          var text = "<%=CommonLang.msg("MSG18") %>";
                  		  openLayerPopText2(text,but1text,but1func,but1width);
                          document.forms["contentForm"].st_order_qty.focus();
                          return;
                    }
                    query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+"&&";
                }else if (flag == "S"){ // 나의분류저장
                	query = st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                }else{ // 관심상품삭제
                	query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                }
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
				var st_my_group     = document.forms.contentForm.st_my_group[y_num].value;
				var st_cart_seq     = document.forms.contentForm.st_cart_seq[y_num].value;
				var st_min_order_qty = document.forms.contentForm.st_min_order_qty[y_num].value;
				var st_pur_unit_qty = document.forms.contentForm.st_pur_unit_qty[y_num].value;
				
                    if (flag == "C"){ // 장바구니
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
                          	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
             <%--                  alert( " <%=CommonLang.msg("MSG18") %>    "); --%>
                              var text = "<%=CommonLang.msg("MSG18") %>";
                      		  openLayerPopText2(text,but1text,but1func,but1width);
                              document.forms["contentForm"].st_order_qty[y_num].focus();
                              return;
                        }
						query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
						  query += "&&";
                    }else if (flag == "S"){ // 나의분류저장
                    	query += st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                    	query += "&&";
                    }else{ // 관심상품삭제
                    	query += st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                    	query += "&&";
                    }
        }
	}else{
		if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm2.lnCheck0" ); 
            if(box.checked == true){
            	var order_qty     = document.forms.contentForm2.st_order_qty.value;
                var st_agent_flag = document.forms.contentForm2.st_agent_flag.value;
		        var st_item_no   = document.forms.contentForm2.st_item_no.value;
				var st_order_qty = document.forms.contentForm2.st_order_qty.value;
				var st_agent     = document.forms.contentForm2.st_agent_code.value;
				var contract_no  = document.forms.contentForm2.st_contract_no.value;
				var contract_seq = document.forms.contentForm2.st_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm2.st_byit_comorg_code.value;
				var st_my_group     = document.forms.contentForm2.st_my_group.value;
				var st_cart_seq     = document.forms.contentForm2.st_cart_seq.value;
				var st_min_order_qty = document.forms.contentForm2.st_min_order_qty.value;
				var st_pur_unit_qty = document.forms.contentForm2.st_pur_unit_qty.value;

                if (flag == "C"){ // 장바구니
                	//MOQ 주문 통제 특수로직 적용한 고객사 한정
              		if(p060000077 == "true"){
              			if(Number(order_qty) < Number(st_min_order_qty)){
              				//최소주문수량에 맞게 수량을 설정해주세요.
              				var text = "<%=CommonLang.msg("MSG611")%>";
              		  		openLayerPopText2(text,but1text,but1func,but1width);
              				document.forms["contentForm2"].st_order_qty.focus();
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
              	       		document.forms["contentForm2"].st_order_qty.focus();
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
                    query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+"&&";
                }else if (flag == "S"){ // 나의분류저장
                	query = st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                }else{ // 관심상품삭제
                	query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                }
            }
        }else{
                var order_qty     = document.forms.contentForm2.st_order_qty[y_num].value;
                var st_agent_flag = document.forms.contentForm2.st_agent_flag[y_num].value;
				var st_item_no   = document.forms.contentForm2.st_item_no[y_num].value;
				var st_order_qty = document.forms.contentForm2.st_order_qty[y_num].value;
				var st_agent     = document.forms.contentForm2.st_agent_code[y_num].value;
				var contract_no  = document.forms.contentForm2.st_contract_no[y_num].value;
				var contract_seq = document.forms.contentForm2.st_contract_seq[y_num].value;
				var byit_comorg_code = document.forms.contentForm2.st_byit_comorg_code[y_num].value;
				var st_my_group     = document.forms.contentForm2.st_my_group[y_num].value;
				var st_cart_seq     = document.forms.contentForm2.st_cart_seq[y_num].value;
				var st_min_order_qty = document.forms.contentForm2.st_min_order_qty[y_num].value;
				var st_pur_unit_qty = document.forms.contentForm2.st_pur_unit_qty[y_num].value;

                    if (flag == "C"){ // 장바구니
                    	//MOQ 주문 통제 특수로직 적용한 고객사 한정
                  		if(p060000077 == "true"){
                  			if(Number(order_qty) < Number(st_min_order_qty)){
                  				//최소주문수량에 맞게 수량을 설정해주세요.
                  				var text = "<%=CommonLang.msg("MSG611")%>";
                  		  		openLayerPopText2(text,but1text,but1func,but1width);
                  				document.forms["contentForm2"].st_order_qty[y_num].focus();
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
                  	       		document.forms["contentForm2"].st_order_qty[y_num].focus();
                  	       		return;				
                  			}            	
                  		}
                        if(!kepChkDecimal(order_qty,3)){
                          	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
             <%--                  alert( " <%=CommonLang.msg("MSG20") %>    "); --%>
                              var text = "<%=CommonLang.msg("MSG20") %>";
                      		  openLayerPopText2(text,but1text,but1func,but1width);
                              document.forms["contentForm2"].st_order_qty[y_num].focus();
                              return;
                        }
						query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
						  query += "&&";
                    }else if (flag == "S"){ // 나의분류저장
                    	query += st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                    	query += "&&";
                    }else{ // 관심상품삭제
                    	query += st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
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
function saveCheckProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var query   = "";
    var p060000077 = "<%=p060000077%>"; //MOQ
	var p060000089 = "<%=p060000089%>"; //주문배수
	
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        //  목록에 표시된 상품이 없습니다.
    	var text = "<%=CommonLang.msg("MSG16") %>  ";
		 openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    var type = $("#st_list_type").val();
    if(type == "list"){
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
        	if(flag == "C"){
        		//장바구니에 등록할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG664") %>";
        	}else if(flag == "D"){
        		//관심상품에서 삭제할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG677") %>";
        	}
    		openLayerPopText2(text,but1text,but1func,but1width);
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
    				var st_my_group     = document.forms.contentForm.st_my_group.value;
    				var st_cart_seq     = document.forms.contentForm.st_cart_seq.value;
    				var st_min_order_qty = document.forms.contentForm.st_min_order_qty.value;
    				var st_pur_unit_qty = document.forms.contentForm.st_pur_unit_qty.value;

                    if (flag == "C"){ // 장바구니
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
                  		
    					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+"&&";
                    }else if (flag == "S"){ // 나의분류저장
                    	query = st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                    }else{ // 나의상품삭제
                    	query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
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
    				var st_my_group     = document.forms.contentForm.st_my_group[i].value;
    				var st_cart_seq     = document.forms.contentForm.st_cart_seq[i].value;
    				var st_min_order_qty = document.forms.contentForm.st_min_order_qty[i].value;
    				var st_pur_unit_qty = document.forms.contentForm.st_pur_unit_qty[i].value;

                    if(box.checked == true){
                        
                        if (flag == "C"){ // 장바구니
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
    						query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
    						query += "&&";
                        }else if (flag == "S"){ // 나의분류저장
                        	query += st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                        	query += "&&";
                        }else{ // 나의상품삭제
                        	query += st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                        	query += "&&";
                        }
                    }
                }
            }
        }
    }else{
    	if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm2.lnCheck0");
            if(box.checked == true) chk_cnt++;
        }else{
            for(var j = 0; j < tot_cnt; j++){
                 var box = eval("document.forms.contentForm2.lnCheck" + j);
                 if(box.checked == true){
                      chk_cnt++;
                 }
            }
        }
        if(chk_cnt == "0"){
        	if(flag == "C"){
        		//장바구니에 등록할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG664") %>";
        	}else if(flag == "D"){
        		//관심상품에서 삭제할 상품을 선택해주세요.
        		var text = "<%=CommonLang.msg("MSG677") %>";
        	}
    		openLayerPopText2(text,but1text,but1func,but1width);
            return;
        }else{
            if(eval(tot_cnt) < 2){
                var box = eval("document.forms.contentForm2.lnCheck0" ); 
                if(box.checked == true){
                	var order_qty     = document.forms.contentForm2.st_order_qty.value;
                    var st_agent_flag = document.forms.contentForm2.st_agent_flag.value;
    		        var st_item_no   = document.forms.contentForm2.st_item_no.value;
    				var st_order_qty = document.forms.contentForm2.st_order_qty.value;
    				var st_agent     = document.forms.contentForm2.st_agent_code.value;
    				var contract_no  = document.forms.contentForm2.st_contract_no.value;
    				var contract_seq = document.forms.contentForm2.st_contract_seq.value;
    				var byit_comorg_code = document.forms.contentForm2.st_byit_comorg_code.value;
    				var st_my_group     = document.forms.contentForm2.st_my_group.value;
    				var st_cart_seq     = document.forms.contentForm2.st_cart_seq.value;
    				var st_min_order_qty = document.forms.contentForm2.st_min_order_qty.value;
    				var st_pur_unit_qty = document.forms.contentForm2.st_pur_unit_qty.value;

                    if (flag == "C"){ // 장바구니
                    	//MOQ 주문 통제 특수로직 적용한 고객사 한정
                  		if(p060000077 == "true"){
                  			if(Number(order_qty) < Number(st_min_order_qty)){
                  				//최소주문수량에 맞게 수량을 설정해주세요.
                  				var text = "<%=CommonLang.msg("MSG611")%>";
                  		  		openLayerPopText2(text,but1text,but1func,but1width);
                  				document.forms["contentForm2"].st_order_qty.focus();
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
                  	       		document.forms["contentForm2"].st_order_qty.focus();
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
                  		
    					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+"&&";
                    }else if (flag == "S"){ // 나의분류저장
                    	query = st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                    }else{ // 나의상품삭제
                    	query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "@@"+st_cart_seq + "&&";
                    }
                }
            }else{
                for(var i = 0; i <tot_cnt; i++){
                    var box = eval("document.forms.contentForm2.lnCheck" + i);
                    var order_qty     = document.forms.contentForm2.st_order_qty[i].value;
                    var st_agent_flag = document.forms.contentForm2.st_agent_flag[i].value;
    				var st_item_no   = document.forms.contentForm2.st_item_no[i].value;
    				var st_order_qty = document.forms.contentForm2.st_order_qty[i].value;
    				var st_agent     = document.forms.contentForm2.st_agent_code[i].value;
    				var contract_no  = document.forms.contentForm2.st_contract_no[i].value;
    				var contract_seq = document.forms.contentForm2.st_contract_seq[i].value;
    				var byit_comorg_code = document.forms.contentForm2.st_byit_comorg_code[i].value;
    				var st_my_group     = document.forms.contentForm2.st_my_group[i].value;
    				var st_cart_seq     = document.forms.contentForm2.st_cart_seq[i].value;
    				var st_min_order_qty = document.forms.contentForm2.st_min_order_qty[i].value;
    				var st_pur_unit_qty = document.forms.contentForm2.st_pur_unit_qty[i].value;

                    if(box.checked == true){
                        
                        if (flag == "C"){ // 장바구니
                        	//MOQ 주문 통제 특수로직 적용한 고객사 한정
                      		if(p060000077 == "true"){
                      			if(Number(order_qty) < Number(st_min_order_qty)){
                      				//최소주문수량에 맞게 수량을 설정해주세요.
                      				var text = "<%=CommonLang.msg("MSG611")%>";
                      		  		openLayerPopText2(text,but1text,but1func,but1width);
                      				document.forms["contentForm2"].st_order_qty[i].focus();
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
                      	       		document.forms["contentForm2"].st_order_qty[i].focus();
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
    						query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
    						query += "&&";
                        }else if (flag == "S"){ // 나의분류저장
                        	query += st_item_no + "@@" + st_order_qty + "@@" + st_my_group  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
                        	query += "&&";
                        }else{ // 나의상품삭제
                        	query += st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code+ "@@"+st_cart_seq ;
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
	kep_showConfirm(); 
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
    		var st_item_no   = document.forms["contentForm"].st_item_no.value;
             query = st_item_no;
         }else{
    		var st_item_no   = document.forms["contentForm"].st_item_no[y_num].value;
             query += st_item_no + "@@";
         }
    }else{
    	if(eval(tot_cnt) < 2){
            var st_item_no   = document.forms["contentForm2"].st_item_no.value;
             query = st_item_no;
         }else{
    		var st_item_no   = document.forms["contentForm2"].st_item_no[y_num].value;
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
	kep_showConfirm();
}


function kep_showConfirm(){
	
	
	var runFlag = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	
	var msg = "";
    if (runFlag == "CsaveProcess"){
    	runProcess();
<%--     	msg = "<%=CommonLang.get("HTITLE11")%>";	//장바구니 --%>
<%--     	$("#confirmCartMsg").text(msg+" <%=CommonLang.msg("MSG348") %>\n"+msg+"<%=CommonLang.msg("MSG349") %>");	//으로 저장하시고	보기 화면으로 이동하시겠습니까? --%>
//     	$("#confirmCartArea").show();
//     	$("#confirmCartAreaOverlay").show();
    }else if(runFlag == "DsaveProcess"){ //관심상품 삭제
    	// 선택하신 품목을 관심상품에서 삭제하시겠습니까?
    	var text = "<%=CommonLang.msg("MSG676")%>";
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:runProcess('"+runFlag+"','"+query+"','"+flag+"')";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "60px";
		var but2widthC = "60px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
    }else if(runFlag == "SsaveProcess"){ //폴더 이동
    	runProcess(runFlag,query,flag);
    }else{
    	runRqdtGplProcess();
<%--     	$("#confirmCartMsg").text("<%=CommonLang.msg("MSG498") %>");	//견적 임시 저장하시고 신규견적 임시저장 조회 화면으로 이동하시겠습니까? --%>
//     	$("#confirmCartArea").show();
//     	$("#confirmCartAreaOverlay").show();
    }

//     $('body,html').animate({
// 		scrollTop: 0
// 	}, 100);
	
//     if (runFlag == "CsaveProcess"){
//     	// 으로 저장하시고 보기 화면으로 이동하시겠습니까?
<%-- 		$("#confirmMsg").text(msg+"<%=CommonLang.msg("MSG348")%>"+"\n"+msg+"<%=CommonLang.msg("MSG349")%>"); --%>
// 		$("#confirmArea").show(); 
//     }else if(runFlag == "DsaveProcess"){
//     	// 선택하신 품목을 나의상품에서 삭제하시겠습니까?
<%--         if(!confirm("<%=CommonLang.msg("MSG350")%>")){ --%>
//             return;
//         }else{
//         	runProcess(runFlag,query,flag);
//         }
//     }else if(runFlag == "SsaveProcess"){
//     	// 선택하신 품목 분류 저장 하시겠습니까?
<%--         if(!confirm("<%=CommonLang.msg("MSG351")%>")){ --%>
//             return;
//         }else{
//         	runProcess(runFlag,query,flag);
//         }    	
//     }
}

// 계속검색
function kep_confrim_search(){ 
	$("#confirm4").val("search");
	$("#confirmCartArea").hide();
	$("#confirmCartAreaOverlay").hide();
	runProcess();
}

// 이동
function kep_confirm_location(){ 
	var runProcessCheck = $("#confirm1").val();
	$("#confirm4").val("location");
	$("#confirmCartArea").hide();
	$("#confirmCartAreaOverlay").hide();
	runProcess();
}

// 취소
function kep_confirm_cancel(){ 
	$("#confirm4").val("");
	$("#confirmCartArea").hide();
	$("#confirmCartAreaOverlay").hide();
}



/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 
 */
 function runRqdtGplProcess() {  	
	$("#confirm4").val("save");
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	
	document.forms.locationForm.st_query.value = query;
	kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationGpl.do","locationForm","save"); 
}
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
	
	if (gubun == "CsaveProcess"){ // 장바구니 
		document.forms.processForm.st_use_flag.value = "C"; // 장바구니
		document.forms.processForm.st_query2.value = query;		
		document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm",gubun); 
	}else if (gubun == "DsaveProcess"){ // 나의상품삭제 
		closePopText1();
		$("#confirm4").val("search");
		document.forms.processForm.st_use_flag.value = "R"; // 나의상품삭제
		document.forms.processForm.st_query2.value = query;		
		kepAjaxFormCall("/mdcm/removeBuyerMdCmMyGoodsLisList.do","processForm",gubun); 
	}else if (gubun == "SsaveProcess"){ //폴더 이동
		$("#confirm4").val("search");
		document.forms.processForm.st_use_flag.value = "R"; // 나의상품삭제
		document.forms.processForm.st_query2.value = query;		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmMyGroupLisList.do","processForm",gubun); 
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
   		 
       }else if(pMethod == "SsaveProcess"){
    	   //폴더가 이동되었습니다.
           var text = "<%=CommonLang.msg("MSG682")%>  ";
     		 openLayerPopText2(text,but1text,but1funcSearch,but1width);
       }else if (pMethod == "DsaveProcess"){
    	   //관심상품 정상적으로 삭제되었습니다.  
          var text = "<%=CommonLang.msg("MSG675") %>  ";
  		 openLayerPopText2(text,but1text,but1funcSearch,but1width);
       }else if(pMethod == "save"){
    	    var text = "<%=CommonLang.msg("MSG697")%>";//신규견적목록에 등록되었습니다.
	       	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
	       	var but2textC = "<%=CommonLang.get("HTITLE1123")%>"; //신규견적목록 확인
	       	var but1funcC = "javascript:thisPopClose2(); return false;";
	       	var but2funcC = "javascript:goGpl(); return false;";
	       	var but1widthC = "110px";
	       	var but2widthC = "140px";
	       	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
       }else{
    	 //폴더가 추가되었습니다.
           var text = "<%=CommonLang.msg("MSG684")%>  ";
   		 openLayerPopText2(text,but1text,but1funcSearch,but1width);
       } 
        
      }else{
         if(pMethod == "CsaveProcess"){
        	var text = sMsg; //이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다.
          	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
          	var but2textC = "<%=CommonLang.get("HTITLE1122")%>"; //장바구니 가기
          	var but1funcC = "javascript:thisPopClose2(); return false;";
          	var but2funcC = "javascript:goCart(); return false;";
          	var but1widthC = "120px";
          	var but2widthC = "120px";
          	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
          }else if (pMethod == "DsaveProcess"){ 
      		//관심상품삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
     		 var text = "<%=CommonLang.msg("MSG674")%>";
       		 openLayerPopText2(text,but1text,but1func,but1width);
     	} else if (pMethod == "SsaveProcess"){ 
     		//폴더 이동에 실패하였습니다.다시 한 번 시도해 주시기 바랍니다. 
     		 var text = "<%=CommonLang.msg("MSG683")%>";
      		 openLayerPopText2(text,but1text,but1func,but1width);
     	}else if (pMethod == "save"){ 
      		//견적 임시 저장 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
		    var text = "<%=CommonLang.msg("MSG499") %>";
		     openLayerPopText2(text,but1text,but1func,but1width);
		}else{
       	 //폴더 이동에 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
            var text = "<%=CommonLang.msg("MSG685")%>  ";
    		 openLayerPopText2(text,but1text,but1func,but1width);
        } 
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "CsaveProcess"){ 
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 var text = "<%=CommonLang.msg("MSG26")%>";
  		 openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "DsaveProcess"){ 
		//관심상품삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
		 var text = "<%=CommonLang.msg("MSG674")%>";
  		 openLayerPopText2(text,but1text,but1func,but1width);
	} else if (pMethod == "SsaveProcess"){ 
		//폴더 이동에 실패하였습니다.다시 한 번 시도해 주시기 바랍니다. 
		 var text = "<%=CommonLang.msg("MSG683")%>";
 		 openLayerPopText2(text,but1text,but1func,but1width);
	} else if (pMethod == "save"){ 
  		//견적 임시 저장 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
	    var text = "<%=CommonLang.msg("MSG499") %>";
	     openLayerPopText2(text,but1text,but1func,but1width);
	} else{
      	 //폴더 이동에 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
        var text = "<%=CommonLang.msg("MSG685")%>  ";
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
//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
//분류 선택 ROW
var g_row = "";
//분류선택
function getBuyerMyGroupPop(row){
	// 분류추가.
	g_row = row;
	openSearchPopup("/common/addMyCatalogPop.do?st_mygroup_yn=Y","","600,450,no");
}
function setPopupReturn(value1,value2){
    var tot_cnt  =  $("#display_item_cnt").val();
    
    if(popupSel == "saveCateg"){
    	if(eval(tot_cnt) < 2){    	
	    	document.forms.contentForm.st_my_group.value = value1;
	    }else{
	    	document.forms.contentForm.st_my_group[g_row].value = value1;
	    }
    	saveProcess("S",g_row);
    }else if(popupSel == "saveCheckCateg"){
    	var type = $("#st_list_type").val();
        if(type == "list"){
             if(eval(tot_cnt) < 2){
                 var box = eval("document.forms.contentForm.lnCheck0" ); 
                 if(box.checked == true){
                 	document.forms.contentForm.st_my_group.value = value1;
                 }
             }else{
                 for(var i = 0; i <tot_cnt; i++){
                     var box = eval("document.forms.contentForm.lnCheck" + i);
                     if(box.checked == true){
                     	document.forms.contentForm.st_my_group[i].value = value1;
                     }
                 }
             }
        }else{
        	if(eval(tot_cnt) < 2){
                var box = eval("document.forms.contentForm2.lnCheck0" ); 
                if(box.checked == true){
                	document.forms.contentForm2.st_my_group.value = value1;
                }
            }else{
                for(var i = 0; i <tot_cnt; i++){
                    var box = eval("document.forms.contentForm2.lnCheck" + i);
                    if(box.checked == true){
                    	document.forms.contentForm2.st_my_group[i].value = value1;
                    }
                }
            }
        }
        saveCheckProcess("S");
    }else if(popupSel == "addCateg"){
    	$("#confirm4").val("search");
    	document.forms.processForm.TEXT1.value = value1;
    	kepAjaxFormCall("/mdcm/saveBuyerMdAmGoodsCategLis_v2.do","processForm","addCateg");
    }
}

function clickFolder(value){
	$("#st_my_groups").val(value);
	document.forms.searchForm.st_buyer_item_no.value = "";
	document.forms.searchForm.st_description.value = "";
	document.forms.searchForm.st_specification.value = "";
	document.forms.searchForm.st_maker_name.value = "";
	doAction("search");
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
function checkedAll(){
	var isChecked =$("#CheckedAll").is(":checked");
	for (var i = 0; i < <%=grid_cnt%>; i++) {
		$("input[name=lnCheck"+i+"]").prop('checked', isChecked);
	}
}

function thisPopClose(){
	closePopText2();
	var confirm4 = $("#confirm4").val();
	if (confirm4 == "search"){ 
     	 kepSearch($("#curPage").val());          	   
    }else if(confirm4 == "save"){
    	$('#locationForm').attr("action", "/mprq/showBuyerMpRqRequestQuotation_v2.do?menuId=br00101000000&tabIndex=2").submit();
    }else{     
    	$('#locationForm').attr("action", "<%=p060000036%>").submit();   
    }
}
function thisPopClose2(){
	closePopText1();
	kepSearch($("#curPage").val());  
}
function reloadFunc(){
	clickFolder("");
}
</script>
</html>
