<%--
**********************************************
* 메뉴 : 상품검색>카테고리상품검색>상품목록>상품상세
* 화면 : 상품상세
* 기능 : 상품상세.
* 프로그램 ID : BU0201007
* 담당자 : 최찬규
* 착수일 : 2026-01-21
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
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<% 
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된 결과 getCatalogDisplayMain
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된 결과 getItemSeries
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList3 = (List<Map<String,String>>) request.getAttribute("data3"); // 조회된 결과 getItemAttrCheck
	List<Map<String,String>> _pathList = (List<Map<String,String>>) request.getAttribute("_data_path"); // 조회된 결과
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.	
	
	String stdcateg_id = CommonUtil.nvl((String) request.getParameter("stdcateg_id"),"");
	String stdcatlg_id = CommonUtil.nvl((String) request.getParameter("stdcatlg_id"),"");
	String buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");
	String buyer_tem_no = CommonUtil.nvl((String) request.getParameter("buyer_tem_no"),"");
	String category_no = CommonUtil.nvl((String) request.getParameter("category_no"),"");
	String key_flag = CommonUtil.nvl((String) request.getParameter("key_flag"),"");
	String cata = CommonUtil.nvl((String) request.getParameter("cata"),"");	
	String byca_comorg_code = CommonUtil.nvl((String) request.getParameter("byca_comorg_code"),"");	
	String sort_gubun = CommonUtil.nvl((String) request.getParameter("sort_gubun"),"");
	String sort_change = CommonUtil.nvl((String) request.getParameter("sort_change"),"");
	String image_status = CommonUtil.nvl((String) request.getParameter("image_status"),"");
	String maker_name = CommonUtil.nvl((String) request.getParameter("maker_name"),"");
	String st_detail_gubun = CommonUtil.nvl((String) request.getParameter("st_detail_gubun"),"");
	String product_flag = CommonUtil.nvl((String) request.getParameter("product_flag"),"");
	String st_return = CommonUtil.nvl((String) request.getParameter("st_return"),"");
	
	int rec_cnt_att = 0;
	int rec_cnt = 0;
	int rec_cnt_cldm = 0;

	Map<String,String> rowData1 = null; 
	Map<String,String> rowData3 = null;
   
   if (_gridList3 != null){
	rec_cnt_att = _gridList3.size();
   }
   if (_gridList2 != null){
	rec_cnt = _gridList2.size();
   }
   if (_gridList1 != null){
	rec_cnt_cldm = _gridList1.size();
	rowData1 = _gridList1.get(0);
   }



   	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String SessionComCode = "";
	String agent_open_flag = "";
	String session_lang = "";
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
		agent_open_flag =  CommonUtil.nvl((String)sessionInfo.getAgentOpenFlag());
		session_lang = CommonUtil.nvl((String)sessionInfo.getLang());
		
	}  
	
	
	//SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
	String p060000036 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000036","COL02_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	//안전인증서 표기 여부
	boolean p04405701 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4057-01");
    //MOQ를 이용하여 주문 통제
    boolean p060000077 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000077"); 
    //주문배수를 이용하여 주문 통제
    boolean p060000089 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000089");
	//SLOGIC-END
	
%> 

<body onLoad="kep_onload_view()">
<!--내용 시작-->
<div class="wrapPopup">
	<div class="PopupTit" style=" width:800px"> <span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
	<% if (rowData1 != null) { %>
	<form name = "contentForm" id="contentForm" method = "post">
      <table class="PopupPDInfor" >
        <colgroup>
      		<col width="300px" />
      		<col width="530px" />
    	</colgroup> 
        <tr>
	        <td>
	        <%if(CommonUtil.nvl(rowData1.get("OVER_SHORT_FLAG")).equals("Y")){ %>
	        	<div class="OpacityBox">품절</div>
	        <%} %>
	        <%
              //녹색구매제품
              if(!CommonUtil.nvl(rowData1.get("BUY_GREEN_ITEM_NM")).equals("")){
            %>
	        <div class="EcoFriendly"><%=rowData1.get("BUY_GREEN_ITEM_NM") %></div>
	        <%} %>
        <% if(rowData1.get("IMGFILE_NAME").equals("")){ %>
	        <img class="img" src="/resources/images/noimage.gif" name = "image1"/>
	        </td>
	        <input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir"  value="">
			<input type="hidden" name="st_imgfile_name" id="st_imgfile_name"  value="">
        <%}else{ %>
	        <img class="img" name = "image1" src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData1.get("IMGFILE_DIR")+"/"+rowData1.get("IMGFILE_NAME")%>" onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"/>
	        </td>
	        <input type="hidden" name="st_imgfile_dir"  id="st_imgfile_dir" value="<%=rowData1.get("IMGFILE_DIR")%>">
			<input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value="<%=rowData1.get("IMGFILE_NAME")%>">
        <%} %>
          
          <td>
            <table class="PDInfor" width="470px" >
              <colgroup>
          		<col width="120px" />
          		<col width="350px" />
          	  </colgroup>
              <thead>
              <tr>
                <th colspan="2">
				<%
				//사용자 언어타입이 영어일 영문 품명 표기
				if(session_lang.equals("EN")) {
				%> 
                   	<%=rowData1.get("DESCRIPTION_ENG")%>
            		<%
				}else{
				%>
					<%=rowData1.get("DESCRIPTION_LOC")%>
            		<%
				}
				%>
				</th>
              </tr>
              </thead>
              <tbody>
              <tr>
                <th><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
                <td><%=rowData1.get("BUYER_ITEM_NO")%></td>
              </tr>
              <tr>
                <th><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
                <td>
                <%
				//사용자 언어타입이 영어일 영문 품명 표기
				if(session_lang.equals("EN")) {
				%> 
                   	<%=rowData1.get("SPECIFICATION_ENG")%>
            		<%
				}else{
				%>
					<%=rowData1.get("SPECIFICATION")%>
            		<%
				}
				%>
                </td>
              </tr>
              <tr>
                <th><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
                <td><%=rowData1.get("MAKER_NAME")%></td>
              </tr>
              <tr>
                <th><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></th>
                <td><%=rowData1.get("ORIGIN")%></td>
              </tr>
              <tr>
                <th><%=CommonLang.get("HTITLE52")%><!-- 단위 --></th>
                <td><%=rowData1.get("UNIT_MEASURE")%></td>
              </tr>
              <% if(!rowData1.get("P070000033_CHECK").equals("") && rowData1.get("SG118_CHECK").equals("Y")){ %>
              <tr>
                <th><%=CommonLang.get("HTITLE985")%><!-- 보관조건 --></th>
                <td><%=rowData1.get("TEMP_COND")%> / <%=rowData1.get("TEMP_RANGE")%></td>
              </tr>
              <%} %>
              <tr >
                <th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></th>
                <td><%=rowData1.get("IMAGE_CNT")%><%=CommonLang.get("HTITLE96")%><!-- 개 --> &nbsp; <button class="ButDownload_Tiny_Outline" onclick="attachFileDownload('<%=rowData1.get("IMAGE_KEY")%>'); return false;"><%=CommonLang.get("HTITLE1032") %><!-- 전체다운로드 --></button></td>
              	<input type="hidden" name="st_image_key"  id="st_image_key" value="<%=rowData1.get("IMAGE_KEY")%>">
              </tr>
              <% if(!rowData1.get("MSDS_NO").equals("") && !rowData1.get("MSDS_NO").equals("MS88888888") && !rowData1.get("MSDS_NO").equals("MS99999999")){ %>
              <tr>
                <th><%=CommonLang.get("HTITLE914") %><!-- MSDS --></th>
                <td><a href="javascript:getMsdsInfoPop('<%=rowData1.get("MSDS_NO")%>');" style="text-decoration: underline;"><%=rowData1.get("MSDS_NO")%></a></td>
              </tr>
              <%} %>
              <%
		      //안전인증서 표기 여부
		      if((p04405701 == true)) {
		      %>    
		      <tr>
                <th><%=CommonLang.get("HTITLE915")%><!-- 안전인증서 --></th>
                <td><%=rowData1.get("SAFETY_FLAG_TEXT")%></td>
              </tr>
		      <%
		      }
		      %>
              </tbody>
            </table>
            <div class="SellerSelect mt25">
              <button id="SSleftBtn" onclick="return false;"></button>
              <div class="SSelectArea" id="SSellerArea">
              <% 
				String title1 = "";
				String title2 = "";
				String title3 = "";
				String title4 = "";
				String title5 = "";
				String title6 = "";
				String title7 = "";
				String title8 = "";
				String title9 = "";
				String title10 = "";
				String title11 = "";
				String title12 = "";
				String title13 = "";
				
				if(rec_cnt_att == 0) {  
					title1 = CommonLang.get("HTITLE144");		//협력사
					title2 = CommonLang.get("HTITLE12");		//품목코드
					title3 = CommonLang.get("HTITLE174");		//단가 
					title4 = CommonLang.get("HTITLE896");		//신청수량
					title5 = CommonLang.get("HTITLE122")+"1";	//비고1
					title6 = CommonLang.get("HTITLE122")+"2";	//비고1
					title7 = CommonLang.get("HTITLE122")+"3";	//비고1
					title8 = CommonLang.get("HTITLE122")+"4";	//비고1
					title9 = CommonLang.get("HTITLE122")+"5";	//비고1
					title10 = CommonLang.get("HTITLE1028");		//최소주문
					title11 = CommonLang.get("HTITLE939");		//주문배수
					title12 = CommonLang.get("HTITLE1033");		//배송일수
					title13 = CommonLang.get("HTITLE699");		//재고수량
				}  
				 
				for(int i =0 ; i < rec_cnt; i++){
				  Map<String,String> rowData2 = _gridList2.get(i);
				
				
				  if(rec_cnt_att > 0) { 
					title1 = CommonLang.get("HTITLE144");		//협력사
					title2 = CommonLang.get("HTITLE12");		//품목코드
					title3 = CommonLang.get("HTITLE174");		//단가 
					title4 = CommonLang.get("HTITLE896");		//신청수량
					title5 = rowData2.get("ATTB_NM1");
					title6 = rowData2.get("ATTB_NM2");
					title7 = rowData2.get("ATTB_NM3");
					title8 = rowData2.get("ATTB_NM4");
					title9 = rowData2.get("ATTB_NM5");
					title10 = CommonLang.get("HTITLE1028");		//최소주문
					title11 = CommonLang.get("HTITLE939");		//주문배수
					title12 = CommonLang.get("HTITLE1033");		//배송일수
					title13 = CommonLang.get("HTITLE699");		//재고수량
				  }
				%>
                <div class="SSelectBox" onClick="oneSelect('<%=i%>')">
                <input type="hidden" name="st_com_code" id="st_com_code<%=i %>" value="${sessionInfo.comCode}">
					<input type="hidden" name="st_user_id" id="st_user_id<%=i %>" value="${sessionInfo.userId}">
					<input type="hidden" name="st_mail" id="st_mail<%=i %>"  value="${sessionInfo.email}">
					<input type="hidden" name="st_user_name" id="st_user_name<%=i %>"  value="${sessionInfo.userNameLoc}">
					<input type="hidden" name="temp_contract_no"  id="temp_contract_no<%=i %>"  value="<%=rowData2.get("CONTRACT_NO")%>">
					<input type="hidden" name="temp_contract_seq" id="temp_contract_seq<%=i %>"  value="<%=rowData2.get("CONTRACT_SEQ")%>">
					<input type="hidden" name="temp_agent_code"   id="temp_agent_code<%=i %>"  value="<%=rowData2.get("AGENT")%>">
					<input type="hidden" name="temp_byit_comorg_code"   id="temp_byit_comorg_code<%=i %>"  value="<%=rowData2.get("BUYER")%>">
					<input type="hidden" name="temp_item_no"   id="temp_item_no<%=i %>"  value="<%=rowData2.get("BUYER_ITEM_NO")%>">
					<input type="hidden" name="st_item_type_co" id="st_item_type_co<%=i %>" value="<%=CommonUtil.nvl(rowData2.get("PRODUCT_CLOSE_FLAG"))%>">
					<input type="hidden" name="st_description2" id="st_description2<%=i %>"  value="<%=CommonUtil.nvl(rowData2.get("DESCRIPTION"))%>">
					<input type="hidden" name="st_specification2" id="st_specification2<%=i %>" value="<%=CommonUtil.nvl(rowData2.get("SPECIFICATION"))%>">
					<input type="hidden" name="st_unit_price"  id="st_unit_price<%=i %>" value="<%=CommonUtil.nvl(rowData2.get("UNIT_PRICE"))%>">
					<input type="hidden" name="emp_user_id"  id="emp_user_id<%=i %>"  value="<%=CommonUtil.nvl(rowData1.get("USER_ID"))%>"/>
			    	<input type="hidden" name="emp_dept"  id="emp_dept<%=i %>"  value="<%=CommonUtil.nvl(rowData1.get("DEPARTMENT"))%>"/>
			    	<input type="hidden" name="st_min_order_qty"  id="st_min_order_qty<%=i %>"  value="<%=CommonUtil.nvl(rowData2.get("MIN_ORDER_QTY"))%>"/>
			    	<input type="hidden" name="st_pur_unit_qty"  id="st_pur_unit_qty<%=i %>"  value="<%=CommonUtil.nvl(rowData2.get("PUR_UNIT_QTY"))%>"/>
                  <label class="CheckLargeLabel"><input type="checkbox" name="agentCheck" id="lnCheck<%=i %>" value="<%=i %>"
                  <%if(i == 0){%> checked <%}%>><span class="CheckLargeCustom"></span>
                  	<%if(agent_open_flag.equals("N")){ %>
                  		<%=CommonLang.get("HTITLE820")%><!-- 코리아이플랫폼㈜ -->
                  	<%}else{ %>
                  		<%=rowData2.get("COM_NAME_LOC")%>
                  	<%} %>
                  </label>
                  <table class="BoxSellerTable mt20">
                    <colgroup>
                      <col width="90px" />
                      <col width="100px" />
                    </colgroup>  
                    <tr>
                      <th><%=title12 %></th>
                      <td><%=rowData2.get("DELIVERY_LT")%><%=CommonLang.get("HTITLE834")%><!-- 일 --></td>
                    </tr>
                    <%if(!rowData2.get("STOCK_CNT").equals("")) {%>
                    <tr>
                      <th><%=title13 %></th>
                      <td><%=CommonUtil.formatNumber(rowData2.get("STOCK_CNT"),true,0,3)%><%=CommonLang.get("HTITLE96")%><!-- 개 --></td>
                    </tr>
                    <%} %>
                    <tr>
                      <th><%=title10 %></th>
                      <td><%=CommonUtil.formatNumber(rowData2.get("MIN_ORDER_QTY"),true,0,3)%><%=CommonLang.get("HTITLE96")%><!-- 개 --></td>
                    </tr>
                    <tr>
                      <th><%=title11 %></th>
                      <td><%=CommonUtil.formatNumber(rowData2.get("PUR_UNIT_QTY"),true,0,3)%><%=CommonLang.get("HTITLE96")%><!-- 개 --></td>
                    </tr>
                    <tr>
                      <th><%=title3 %></th>
                      <td><span><%=CommonUtil.formatNumber(rowData2.get("UNIT_PRICE"),true,0,3)%></span><%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
                    </tr>
                  </table>
                </div>
                <%} %>
                <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=rec_cnt%>"  />
              </div>
              <button id="SSrightBtn" onclick="return false;"></button>
            </div>
			<script>
            const boxes = document.querySelectorAll('.SSelectBox');
            
            boxes.forEach(function(SSelectBox) {
              const checkbox = SSelectBox.querySelector('input[type="checkbox"]');
            
              // ✅ 박스 전체 클릭 시 체크 + 선택
              SSelectBox.addEventListener('click', function(e) {
                // label 내부의 checkbox 클릭일 경우 중복 방지
                if (e.target.tagName.toLowerCase() === 'input') return;
            
                // 모든 박스 초기화
                boxes.forEach(function(b){
                  b.querySelector('input[type="checkbox"]').checked = false;
                  b.classList.remove('SSelected');
                });
            
                // 현재 박스 선택
                checkbox.checked = true;
                SSelectBox.classList.add('SSelected');
              });
            
              // ✅ 체크박스 클릭 시도 동일하게 작동 (라디오처럼 1개만)
              checkbox.addEventListener('change', function(){
                boxes.forEach(function(b){
                  b.querySelector('input[type="checkbox"]').checked = false;
                  b.classList.remove('SSelected');
                });
                checkbox.checked = true;
                SSelectBox.classList.add('SSelected');
              });
            });
            
            // 좌우 이동
            const scrollArea = document.getElementById('SSellerArea');
            document.getElementById('SSleftBtn').addEventListener('click', function(){
              scrollArea.scrollBy({ left: -240, behavior: 'smooth' });
            });
            document.getElementById('SSrightBtn').addEventListener('click', function(){
              scrollArea.scrollBy({ left: 240, behavior: 'smooth' });
            });
            </script>                        
    	<div class="Popup_GrayBox mt15 ml25" style="width:430px" >
          <div class="NumInput">
            <button id="" onclick="javascript:getOrderQty('M'); return false;">-</button>
			<input type="text" name="st_temp_qty" id="st_temp_qty" size="4" value="<%=CommonUtil.nvl(_gridList2.get(0).get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate();" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:getPriceUpdate();">
			<button onclick="javascript:getOrderQty('P'); return false;">+</button>
          </div><br/>
          <script>
			function changeNumber(delta) {
              const input = document.getElementById('quantity');
              let value = parseInt(input.value) || 0;
              value += delta;
              if (value < parseInt(input.min)) value = parseInt(input.min);
              input.value = value;
			}
          </script> 
          <p class="NumTxt01 mt10"> <%=CommonLang.get("HTITLE1028") %><!-- 최소주문 --> <span id="pdRightMinOrderQty"><%=CommonUtil.formatNumber(_gridList2.get(0).get("MIN_ORDER_QTY"),true,0,3)%></p> 
          <p class="NumTxt02 mt10"> <%=CommonLang.get("HTITLE1029") %><!-- 주문배수 --> <span id="pdRightPurUnitQty"><%=CommonUtil.formatNumber(_gridList2.get(0).get("PUR_UNIT_QTY"),true,0,3)%></span></p> 
          <div class="PDDAllPric" id="pdRightSumPrice"></div>                   
		</div>
        <div class="PopupListBtnBox_Center  mt20">
          <button class="ButQuaternary_large" onclick="javascript:doAction('myItem',''); return false;"><%=CommonLang.get("HTITLE1031") %><!-- 즐겨찾기 --></button>
          <button class="ButPrimary_large" onclick="javascript:doAction('cartItem',''); return false;"><%=CommonLang.get("HTITLE11") %><!-- 장바구니 --></button>
        </div>         
      </td>
    </tr>
  </table>
	</form>
    <%} %>
  </div>

<form name="processForm" id="processForm" method="post">	 
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/>
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id_session" id="st_user_id_session" value="${sessionInfo.userId}">
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" />
</form>

<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	<input type="hidden" name="categ_code" id="categ_code" value="<%=stdcateg_id %>" />
	<input type="hidden" name="stdcatlg_id" id="stdcatlg_id" value="<%=stdcatlg_id %>" />
	<input type="hidden" name="buyer" id="buyer" value="<%=buyer %>" />
	<input type="hidden" name="com_code" id="com_code" value="<%=com_code %>" />
	<input type="hidden" name="buyer_tem_no" id="buyer_tem_no" value="<%=buyer_tem_no %>" />
	<input type="hidden" name="category_no" id="category_no" value="<%=category_no %>" />
	<input type="hidden" name="key_flag" id="key_flag" value="<%=key_flag %>" />
	<input type="hidden" name="cata" id="cata" value="<%=cata %>" /> 
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/> 
	<input type="hidden" name="byca_comorg_code" id="byca_comorg_code" value="<%=byca_comorg_code %>"> 
	<input type="hidden" name="st_sort_gubun" id="st_sort_gubun" value="<%=sort_gubun %>"> 
	<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=sort_change %>"> 
	<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>"> 
	<input type="hidden" name="maker_name" id="maker_name" value="<%=maker_name %>">
	<input type="hidden" name="st_categ_id" id="st_categ_id" value="">
	<input type="hidden" name="st_pid"  id="st_pid"  value="">
	<input type="hidden" name="st_categ_level" id="st_categ_level" value="">
	<input type="hidden" name="st_categ_type" id="st_categ_type" value="">
	<input type="hidden" name="st_categ_sys_code" id="st_categ_sys_code" value="">
	<input type="hidden" name="st_byca_comorg_code" id="st_byca_comorg_code" value="">
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
</body>
<script>
//alert layer용
var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
// var but1funcSearch = "javascript:thisPopClose(flag); return false;";
var but1width = "120px";

var agentIndex = 0; // 공급사 선택 index


const priceBox = document.getElementById('Price-Box');
const footer = document.querySelector('.footer');
const PDDcontainer = document.querySelector('.PDDcontainer');
const PDDright = document.querySelector('.PDDright');

function updatePriceBoxPosition() {
  const rightRect = PDDright.getBoundingClientRect();
  const footerRect = footer.getBoundingClientRect();
  const viewportHeight = window.innerHeight;

  // .PDDright의 문서 좌표 기준 왼쪽 위치 계산
  const rightLeft = rightRect.left + window.scrollX;

  // footer가 화면에 들어왔는지 확인
  const footerTop = footerRect.top + window.scrollY;
  const viewportBottom = window.scrollY + viewportHeight;

  if (viewportBottom >= footerTop) {
    // footer 진입 시 PDDcontainer 내부에 고정
    priceBox.classList.remove('price-fixed');
    priceBox.classList.add('price-absolute');
    priceBox.style.PDDleft = ""; // fixed PDDleft 해제
  } else {
    // 일반 스크롤 시 화면 하단 고정
    priceBox.classList.remove('price-absolute');
    priceBox.classList.add('price-fixed');
    priceBox.style.PDDleft = rightLeft+"px"; // 옵션박스의 왼쪽 라인 기준
  }
}

window.addEventListener('scroll', updatePriceBoxPosition);
window.addEventListener('resize', updatePriceBoxPosition);
updatePriceBoxPosition();
</script>
<script type="text/javascript"> 


function kep_onload_view(){	 
	var index = "";
	$("input[name='agentCheck']:checked").each(function(e){
// 		index = $(this).attr("id");
		index = $(this).val();
	});
	
	var order_qty = $("#st_min_order_qty"+index).val();
	var unit_price = $("#st_unit_price"+index).val();
	var st_sum_price = kepGetRound((order_qty * unit_price),3);
    $("#pdRightSumPrice").html(kepCommaNum(st_sum_price)+"<span>"+"<%=CommonLang.get("HTITLE660") %>"+"</span>"); //원
}
 
function setProxyByitDisplay(buyer,buyer_item_no,contract_no,contract_seq) {
	//alert("고객사 카탈로그 상세조회 팝업 준비중..구현.");
	
	var catalog_com_code = buyer;
	var buyer = buyer;
	var buyer_item_no = buyer_item_no;
	
	openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+catalog_com_code+"&st_buyer_item_no="+buyer_item_no,"988,768,no");
	
}
 
 
function getNextCategory(categ_sys_code, categ_name, std_categ_id, pid, depth, categ_type, byca_comorg_code){
	document.locationForm.st_categ_id.value = std_categ_id; // 표준카테고리ID
	document.locationForm.st_pid.value = pid; 
	document.locationForm.st_categ_level.value = depth;
	document.locationForm.st_categ_type.value = categ_type;
	document.locationForm.st_categ_sys_code.value = categ_sys_code;
	document.locationForm.st_byca_comorg_code.value = byca_comorg_code; 


	$('#locationForm').attr("action", "/mdcm/showBuyerMdCmCategoryPCOSearch.do").submit();   
}
function kep_back(){
	
	<% if ("Y".equals(st_detail_gubun)) {%>
	// 검색엔진을 통하여 조회 후 상세화면 이므로 돌아갈
	// 검색클릭으로 처리한다.
	actionBuyerMdCmGoodsDiLisList2();
	<%}else{%>
	$('#locationForm').attr("action", "/mdcm/getBuyerMdCmGoodsLisList.do").submit();   
	<%}%> 
	
}

function kep_Pback(){
	
	<% if ("Y".equals(st_detail_gubun)) {%>
	// 검색엔진을 통하여 조회 후 상세화면 이므로 돌아갈
	// 검색클릭으로 처리한다.
	actionBuyerMdCmGoodsDiLisList2();
	<%}else{%>
		<%if ("CATA".equals(st_return)) {%>
			$('#locationForm').attr("action", "/mdcm/getBuyerMdCmGoodsLisList.do").submit();
		<%}%>
	<%}%> 
	
}


//기능함수
var str = "";
function doAction(str , gubun) {
	var text = "";
	switch (str) { 
 
	case "myItem": // 나의상품 담기 
		saveProcess("R");
		break;  
	case "cartItem": // 장바구니 담기
		saveProcess("C");
		break;  
	case "kep_back": // 이전화면
		kep_back();
		break;  
	case "saveReq": //견적의뢰
		saveReq();
		break;
	case "myPItem": // 펀치아웃용나의상품 담기 
		savePCOProcess("R");
		break;  
	case "cartPItem": // 펀치아웃용장바구니 담기
		savePCOProcess("C");
		break;
	case "kep_Pback": // 이전화면
		kep_Pback();
		break;  
	case "reqVocItem":
		text = "<%=CommonLang.get("HTITLE889")%>";	// 품목정보 오류신고
		showCommonCoCoVocBuyerReqCreateRegPop(gubun, text);
		break;
	case "reqVocImage":
		text = "<%=CommonLang.get("HTITLE890")%>";	// 품목이미지 요청
		showCommonCoCoVocBuyerReqCreateRegPop(gubun, text);
		break;
	}
}

function oneSelect(num){
	agentIndex = num;
	
	var st_min_order_qty = $("#st_min_order_qty"+agentIndex).val();
	var st_pur_unit_qty = $("#st_pur_unit_qty"+agentIndex).val();
	var st_unit_price = $("#st_unit_price"+agentIndex).val();
	document.forms["contentForm"].st_temp_qty.value = st_min_order_qty;
	$("#pdRightMinOrderQty").html(st_min_order_qty);
	$("#pdRightPurUnitQty").html(st_pur_unit_qty);
	$("#pdRightPrice").html(st_unit_price);
	
	var st_sum_price = kepGetRound((st_min_order_qty * st_unit_price),3);
    $("#pdRightSumPrice").html(kepCommaNum(st_sum_price)+"<span>"+"<%=CommonLang.get("HTITLE660") %>"+"</span>"); //원
}
/*
 * 나의상품등록 R
 * 장바구니담기 C
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var result_st_order_qty = 0;
    var query   = "";
    
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
<%--         alert(" <%=CommonLang.msg("MSG511")%>     ");	//목록에 표시된 협력사가 없습니다. --%>
        var text = "<%=CommonLang.msg("MSG511")%>  ";
  		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    
	var order_qty     = document.forms["contentForm"].st_temp_qty.value;
	var st_item_no   = $("#temp_item_no"+agentIndex).val();
	var st_order_qty = document.forms["contentForm"].st_temp_qty.value;
	var st_agent     = $("#temp_agent_code"+agentIndex).val();
	var contract_no  = $("#temp_contract_no"+agentIndex).val();
	var contract_seq = $("#temp_contract_seq"+agentIndex).val();
	var byit_comorg_code = $("#temp_byit_comorg_code"+agentIndex).val();
	var st_min_order_qty = $("#st_min_order_qty"+agentIndex).val();
	var st_pur_unit_qty = $("#st_pur_unit_qty"+agentIndex).val();
	var p060000077 = "<%=p060000077%>"; //MOQ
	var p060000089 = "<%=p060000089%>"; //주문배수

	//MOQ 주문 통제 특수로직 적용한 고객사 한정
	if(p060000077 == "true"){
		if(Number(order_qty) < Number(st_min_order_qty)){
			//발주수량이 MOQ보다 수량이 작습니다. 발주수량을 MOQ보다 크게 입력하여 주십시오. 
<%-- 			alert("<%=CommonLang.msg("MSG437")%>"); --%>
			//수량을 최소주문보다 크게 입력 바랍니다.
			var text = "<%=CommonLang.msg("MSG611")%>";
	  		openLayerPopText2(text,but1text,but1func,but1width);
			document.forms["contentForm"].st_temp_qty.focus();
			return;				
		}            	
	}
	//주문배수 주문 통제 특수로직 적용한 고객사 한정
	if(p060000089 == "true"){
		var checkNum = order_qty%st_pur_unit_qty;
		if(checkNum != 0 ){
       		//주문배수만큼 수량 입력 바랍니다. 
<%--    			alert(i+"<%=CommonLang.msg("MSG533")%>"); --%>
   			var text = "<%=CommonLang.msg("MSG609")%>";
	  		openLayerPopText2(text,but1text,but1func,but1width);
       		document.forms["contentForm"].st_temp_qty.focus();
       		return;				
		}            	
	}
    if(!kepChkDecimal(order_qty,3)){
<%-- 		alert( i+"  <%=CommonLang.msg("MSG20")%>   ");	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다. --%>
		//수량을 숫자형식으로 입력해주세요.(ex : 1,2,10,20..)</br>소숫점은 3자리까지 가능합니다.
		var text = "<%=CommonLang.msg("MSG610")%>";
  		openLayerPopText2(text,but1text,but1func,but1width);
		document.forms["contentForm"].st_temp_qty.focus();
		return;
	} else {
		query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		query += "&&";
	}
	result_st_order_qty = st_order_qty;
	
    var msg = "";
    if (flag == "C"){
    	msg = "<%=CommonLang.get("HTITLE161")%>";	//장바구니
    }else{
    	msg = "<%=CommonLang.get("HTITLE593")%>";	//나의상품
    }   
    
    var flagProcess = flag+"saveProcess";
    // 주문수량을 (으)로 으로 저장하시고 보기 화면으로 이동하시겠습니까?
<%-- 	if (confirm("<%=CommonLang.msg("MSG514")%> "+ result_st_order_qty + " <%=rowData1.get("UNIT_MEASURE")%><%=CommonLang.msg("MSG515")%>\n"+msg+" <%=CommonLang.msg("MSG348")%> "+msg+"<%=CommonLang.msg("MSG349")%>")==false) return; 	 --%>
	var text = "<%=CommonLang.msg("MSG514")%> "+ result_st_order_qty + " <%=rowData1.get("UNIT_MEASURE")%><%=CommonLang.msg("MSG515")%>"+"</br>"+msg+" <%=CommonLang.msg("MSG348")%> "+msg+"<%=CommonLang.msg("MSG349")%>";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:runProcess('"+flagProcess+"','"+query+"','"+flag+"'); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "100px";
	var but2widthC = "100px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}

/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 
 */
function runProcess(gubun,query,flag) {  	
	closePopText1();
	if (gubun == "CsaveProcess" ||gubun == "RsaveProcess"){ // 장바구니 남의상품
		document.forms.processForm.st_use_flag.value = flag; 
		document.forms.processForm.st_query2.value = query;
		document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm",gubun);		
	}else if (gubun == "CsavePCOProcess" ||gubun == "RsavePCOProcess"){ // 펀치아웃장바구니 남의상품
		document.forms.processForm.st_use_flag.value = flag; 
		document.forms.processForm.st_query2.value = query;
		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmPopularGoods.do","processForm",gubun);
	}else if (gubun == "QsavePCOProcess"){ // 펀치아웃장바구니 남의상품
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
    if(sMsg == "CREATE_OK"){
        if(pMethod == "CsaveProcess"){
<%--            alert("<%=CommonLang.msg("MSG22")%>   ");	//장바구니에 저장되었습니다. --%>
           var text = "<%=CommonLang.msg("MSG22")%>";
	  	   openLayerPopText2(text,but1text,"javascript:thisPopClose('CsaveProcess'); return false;",but1width);
<%--            $('#locationForm2').attr("action", "<%=p060000036%>").submit();     --%>
       }else if(pMethod == "RsaveProcess") {
<%--           alert("<%=CommonLang.msg("MSG23")%>   ");	//나의상품으로 등록 되었습니다. --%>
          var text = "<%=CommonLang.msg("MSG23")%>";
	  	   openLayerPopText2(text,but1text,"javascript:thisPopClose('RsaveProcess'); return false;",but1width);
//           $('#locationForm2').attr("action", "/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit();   
       }
      }else{
         if(pMethod == "CsaveProcess"){
        	//품목코드 () 은 이미 장바구니에 저장된 항목입니다.
            var text = "<%=CommonLang.msg("MSG352")%>" + sMsg + ") <%=CommonLang.msg("MSG24")%>";
 	  	   openLayerPopText2(text,but1text,but1func,but1width);
          }else if(pMethod == "RsaveProcess") {
        	//품목코드 () 은 이미 나의 상품으로 저장된 항목입니다.
            var text = "<%=CommonLang.msg("MSG352")%>" + sMsg + ") <%=CommonLang.msg("MSG25")%>";
  	  	   openLayerPopText2(text,but1text,but1func,but1width);
          }
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "CsaveProcess"||pMethod == "CsavePCOProcess"){ 
		//장바구니담기 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG26")%>";
	  	   openLayerPopText2(text,but1text,but1func,but1width);
	}else if (pMethod == "RsaveProcess"||pMethod == "RsavePCOProcess"){ 
		//나의상품등록 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG27")%>";
	  	   openLayerPopText2(text,but1text,but1func,but1width);
	}  else{
		 //다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG523")%>";
	  	   openLayerPopText2(text,but1text,but1func,but1width);
	}
	 
	
} 

//레이어용
// function thisPopClose(flag){
// 	closePopText2();
// 	if(flag== "CsaveProcess"){
<%-- 		parent.setPopupReturn("<%=p060000036%>"); --%>
// 	}else if(flag == "RsaveProcess"){
// 		parent.setPopupReturn("/mdcm/getBuyerMdCmMyGoodsSearchList.do");
// 	}
// 	parent.closePop();
// }
//일반팝업용
function thisPopClose(flag){
	closePopText2();
	if(flag== "CsaveProcess"){
		opener.setPopupReturn("<%=p060000036%>");
	}else if(flag == "RsaveProcess"){
		opener.setPopupReturn("/mdcm/getBuyerMdCmMyGoodsSearchList.do");
	}
	self.close();
}
// 상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageReSizeView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
//MSDS팝업
function getMsdsInfoPop(msds_no){
	openSearchPopup("/coco/showCommonCoCoMsdsDetailPop_v2.do","?st_msds_no="+msds_no,'750,700,no');
}
// VOC 팝업
function showCommonCoCoVocBuyerReqCreateRegPop(code, text){
	var st_buyer_item_no = "<%=buyer_tem_no%>";
	openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?st_ds_user_id='+$('#emp_user_id'+agentIndex).val()+'&st_ds_dept='+$('#emp_dept'+agentIndex).val()+'&st_title='+text+'&st_code='+code+'&st_buyer_item_no='+st_buyer_item_no,'800,380,no');    
}

//팝업함수호출
var popupSel  = "";
function doPop(str,value1, value2, value3, value4, value5) {
	switch (str) {
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	}
}

//품목 합계값
function getPriceUpdate(){
    var st_sum_price = "";
    var st_order_qty = "";
    var st_unit_price = $("#st_unit_price"+agentIndex).val();
   	 st_order_qty = document.forms["contentForm"].st_temp_qty.value;
   	 if (!kepIsNumberString(kepTrimStr(st_order_qty))) {
   			//품목의 주문수량(숫자)을 입력하여 주십시요.
   		 var text = "<%=CommonLang.msg("MSG120") %>  ";
   		 openLayerPopText2(text,but1text,but1func,but1width);
   		 document.forms["contentForm"].st_temp_qty.value = "1";
   		 document.forms["contentForm"].st_temp_qty.focus();
   		$("#pdRightSumPrice").html(kepCommaNum(unit_price)+"<span>"+"<%=CommonLang.get("HTITLE660") %>"+"</span>"); //원
   	 }else{
            st_sum_price = kepGetRound((st_order_qty * st_unit_price),3);
            $("#pdRightSumPrice").html(kepCommaNum(st_sum_price)+"<span>"+"<%=CommonLang.get("HTITLE660") %>"+"</span>"); //원
   	 }
    
}

//주문수량 기능 g_gbn P: 주문수량 1 플러스/ M: 주문수량 1마이너스, pur_unit_qty : 주문배수
function getOrderQty(g_gbn){
	var st_order_qty = ""; //주문수량
	var st_tobe_order = "";//변경후 주문수량
	var st_sum_price = "";//합계 금액
	var st_pur_unit_qty = $("#st_pur_unit_qty"+agentIndex).val();
	var st_unit_price = $("#st_unit_price"+agentIndex).val();
	st_order_qty = document.forms["contentForm"].st_temp_qty.value;
	
	if(g_gbn == "P"){
		st_tobe_order = parseInt(st_order_qty) + parseInt(st_pur_unit_qty);
	}else if(g_gbn == "M"){
		st_tobe_order = parseInt(st_order_qty) - parseInt(st_pur_unit_qty);
		if(st_tobe_order < 1){
     			//품목의 주문수량(숫자)을 입력하여 주십시요.
      		var text = "<%=CommonLang.msg("MSG120") %>  ";
     		 openLayerPopText2(text,but1text,but1func,but1width);
      		 return;
		}
	}
	document.forms["contentForm"].st_temp_qty.value = st_tobe_order;
	st_sum_price = kepGetRound((st_tobe_order * st_unit_price),3);
    $("#pdRightSumPrice").html(kepCommaNum(st_sum_price)+"<span>"+"<%=CommonLang.get("HTITLE660") %>"+"</span>"); //원
	
	
}

function attachFileDownload(doc_no){
	if(doc_no == ""){
		//첨부파일이 없습니다.
		var text = "<%=CommonLang.msg("MSG612") %>  ";
		 openLayerPopText2(text,but1text,but1func,but1width);
		 return;
	}else{
		location.href="/common/download_v2.do?DOC_NO="+doc_no;
	}
}
function attachMsdsFileDownload(doc_no){
	if(doc_no == ""){
		//첨부파일이 없습니다.
		var text = "<%=CommonLang.msg("MSG612") %>  ";
		 openLayerPopText2(text,but1text,but1func,but1width);
		 return;
	}else{
		location.href="/common/downloadMulti_v2.do?DOC_NO="+doc_no;
	}
}
</script> 
</html>
