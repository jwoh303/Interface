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
<%@ include file="../../common/include/head_v2.jspf"  %>
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
	//SLOGIC-END
	/*
		프로그램ID: PG_02_B_000834_008
		수정자: 현명환
		수정일: 2015.03.06
		펀치아웃 해당 내용 표시.
	*/
	boolean p060000052 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000052"); 
	
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
<div class="PDDcontainer" >
	<div class="PDDleft" >
	<% if (rowData1 != null) { %>
	<form name = "contentForm" id="contentForm" method = "post">
      <table class="PDDInfor mt50" >
        <colgroup>
          <col width="396px" />
          <col width="530px" />
        </colgroup>    
        <tr>
        	<input type="hidden" name="confirm1" id="confirm1" value="">
			<input type="hidden" name="confirm2" id="confirm2" value="">
			<input type="hidden" name="confirm3" id="confirm3" value="">
			<input type="hidden" name="confirm4" id="confirm4" value="">
<!--         <td><div class="OpacityBox">품절</div><img class="img" src="/resources/imgs/img01.jpg"/></td> -->
	        <td>
	        <div class="img">
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
	        </div>
	        </td>
	        <input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir"  value="">
			<input type="hidden" name="st_imgfile_name" id="st_imgfile_name"  value="">
        <%}else{ %>
	        <img class="img" name = "image1" src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData1.get("IMGFILE_DIR")+"/"+rowData1.get("IMGFILE_NAME")%>" onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"/>
	        </div>
	        </td>
	        <input type="hidden" name="st_imgfile_dir"  id="st_imgfile_dir" value="<%=rowData1.get("IMGFILE_DIR")%>">
			<input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value="<%=rowData1.get("IMGFILE_NAME")%>">
        <%} %>
          
          <td>
            <table class="PDInfor ml30" >
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
                <th><%=CommonLang.get("HTITLE1454")%><!-- 모델번호 --></th>
                <td><%=rowData1.get("MAKER_PART_NO")%></td>
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
                <td>
                <%if(!rowData1.get("IMAGE_CNT").equals("0")) {%>
                <a href="javascript:attachFileDownload('<%=rowData1.get("IMAGE_KEY")%>');" style="text-decoration: underline;color:#2172ec;"><%=rowData1.get("IMAGE_CNT")%><%=CommonLang.get("HTITLE96")%><!-- 개 --></a>
                <%} %>
                </td>
              	<input type="hidden" name="st_image_key"  id="st_image_key" value="<%=rowData1.get("IMAGE_KEY")%>">
              </tr>
              <% if(!rowData1.get("MSDS_NO").equals("") && !rowData1.get("MSDS_NO").equals("MS88888888") && !rowData1.get("MSDS_NO").equals("MS99999999")){ %>
              <tr>
                <th><%=CommonLang.get("HTITLE914") %><!-- MSDS --></th>
                <td><a href="javascript:getMsdsInfoPop('<%=rowData1.get("MSDS_NO")%>');" style="text-decoration: underline;color:#2172ec;"><%=rowData1.get("MSDS_NO")%></a></td>
              </tr>
              <%} %>
              <%
		      //안전인증서 표기 여부
		      if(!rowData1.get("SAFETY_FLAG_TEXT").equals("")) {
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
                <div class="SSelectBox" id="SSelectBox<%=i %>" onClick="oneSelect('<%=i%>')">
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
          </td>
        </tr>
      </table>
      <% if(!rowData1.get("DETAIL_IMGFILE_DIR").equals("")){ %>
      	<div class="PDDetailImg" ><img class="img" src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData1.get("DETAIL_IMGFILE_DIR")+"/"+rowData1.get("DETAIL_IMGFILE_NAME")%>" onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"  name = "image2" ></div>
      <%} else if(!rowData1.get("DETAIL_ITEM_INFO").equals("")){ %>
      	<div class="PDDetailImg" ><%=rowData1.get("DETAIL_ITEM_INFO")%></div>
      <%} %>
    </div><!-- PDDleft -->
    <div class="PDDright">
      <div class="OptionBox">
        <div class="OptionBox_Code"><%=rowData1.get("BUYER_ITEM_NO")%></div>
        <div class="OptionBox_Pd">
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
		</div>
        <div class="OptionBox_Pric" id="pdRightPrice"><%=CommonUtil.formatNumber(_gridList2.get(0).get("UNIT_PRICE"),true,0,3)%><span><%=CommonLang.get("HTITLE660") %><!-- 원 --></span></div>
      </div>
      <div class="PriceBox" id="Price-Box">
        <div class="PDDOrderNum"> 
          <div class="NumInput" id="NumInputDiv">
          	<button id="" onclick="javascript:getOrderQty('M'); return false;">-</button>
			<input type="text" name="st_temp_qty" id="st_temp_qty" size="4" value="<%=CommonUtil.nvl(_gridList2.get(0).get("MIN_ORDER_QTY"), "1") %>"  onChange="javascript:getPriceUpdate();" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:getPriceUpdate();">
			<button onclick="javascript:getOrderQty('P'); return false;">+</button>
          </div><br/>
          <p class="NumTxt01"> <%=CommonLang.get("HTITLE1028") %><!-- 최소주문 --> <span id="pdRightMinOrderQty"><%=CommonUtil.formatNumber(_gridList2.get(0).get("MIN_ORDER_QTY"),true,0,3)%></span></p> 
          <p class="NumTxt02"> <%=CommonLang.get("HTITLE1029") %><!-- 주문배수 --> <span id="pdRightPurUnitQty"><%=CommonUtil.formatNumber(_gridList2.get(0).get("PUR_UNIT_QTY"),true,0,3)%></span></p>              
        </div>
		<script>
          function changeNumber(delta) {
            const input = document.getElementById('quantity');
            let value = parseInt(input.value) || 0;
            value += delta;
            if (value < parseInt(input.min)) value = parseInt(input.min);
            input.value = value;
          }
        </script>        
        <div class="PDDCartSave">
<!--           <div class="PDDAllNum"> 총 10개</div> -->
          <div class="PDDAllPric" id="pdRightSumPrice"></div>
          <button class="ButPrimary_large mt35 mb08" onclick="javascript:doAction('cartItem',''); return false;"><%=CommonLang.get("HTITLE11") %><!-- 장바구니 --></button><br/>
          <button class="ButOutline_large" onclick="javascript:doAction('reqVocItem','ZA'); return false;"><%=CommonLang.get("HTITLE1034") %><!-- 오류신고 --></button>
          <button class="ButOutline_large" onclick="javascript:doAction('reqVocImage','ZB'); return false;"><%=CommonLang.get("HTITLE1035") %><!-- 이미지요청 --></button>
			<%if(CommonUtil.nvl(rowData1.get("MY_ITEM_YN")).equals("Y")){ %>
	          <button class="ButFavorites40_on" onclick="javascript:doAction('myItem',''); return false;"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
			<%}else{ %>
			  <button class="ButFavorites40" onclick="javascript:doAction('myItem',''); return false;"><%=CommonLang.get("HTITLE1016") %><!-- 관심상품 --></button>
			<%} %>
        </div>
      </div><!-- PriceBox -->
    </div><!-- PDDright -->
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
	<input type="hidden" name="st_pf_my_group" id="st_pf_my_group" value="" />
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
         <button class="ButPrimary_large" style=" width:120px" onclick="javascript:kep_confirm_location(); return false;"><%=CommonLang.get("HTITLE1441") %><!-- 관심상품 보기 --></button>
         <button class="ButPrimary_large" style=" width:120px" onclick="javascript:kep_confrim_search();return false;"><%=CommonLang.get("HTITLE1442") %><!-- 계속 쇼핑하기 --></button>
    </div>
  </div>
</div>

</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>  
</div>
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
	$("#SSelectBox"+index).addClass("SSelected");
	var order_qty = $("#st_min_order_qty"+index).val();
	var unit_price = $("#st_unit_price"+index).val();
	var st_sum_price = kepGetRound((order_qty * unit_price),3);
    $("#pdRightSumPrice").html(kepCommaNum(st_sum_price)+"<span>"+"<%=CommonLang.get("HTITLE660") %>"+"</span>"); //원
}
 
//기능함수
var str = "";
function doAction(str , gubun) {
	var text = "";
	switch (str) { 
 
	case "myItem": // 나의상품 담기 
		document.getElementById("st_my_groups").style.display = "inline-block";
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
	$("#pdRightPrice").html(kepCommaNum(st_unit_price)+"<span>"+"<%=CommonLang.get("HTITLE660") %>"+"</span>");
	
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

	var msg = "";
	
	if(flag == "C"){
		//MOQ 주문 통제 특수로직 적용한 고객사 한정
		if(p060000077 == "true"){
			if(Number(order_qty) < Number(st_min_order_qty)){
				//최소주문수량에 맞게 수량을 설정해주세요
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
	       		//주문배수에 맞게 수량을 설정해주세요.
	   			var text = "<%=CommonLang.msg("MSG609")%>";
		  		openLayerPopText2(text,but1text,but1func,but1width);
	       		document.forms["contentForm"].st_temp_qty.focus();
	       		return;				
			}            	
		}
	    if(!kepChkDecimal(order_qty,3)){
			//수량을 숫자형식으로 입력해주세요.(ex : 1,2,10,20..)</br>소숫점은 3자리까지 가능합니다.
			var text = "<%=CommonLang.msg("MSG610")%>";
	  		openLayerPopText2(text,but1text,but1func,but1width);
			document.forms["contentForm"].st_temp_qty.focus();
			return;
		} else {
			query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
			query += "&&";
		}
	}else{
		query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
		query += "&&";
	}
	
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	kep_showConfirm();	 
//     var flagProcess = flag+"saveProcess";
// 	runProcess(flagProcess,query,flag);
}

/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 
 */
function runProcess() { 
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val();
	var flag = $("#confirm3").val();
// 	closePopText1();
	if (gubun == "CsaveProcess" ||gubun == "RsaveProcess"){ // 장바구니 남의상품
		var st_my_groups =$("#st_my_groups_code").val();
		document.forms.processForm.st_use_flag.value = flag; 
		document.forms.processForm.st_query2.value = query;
		document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		
		if (gubun == "RsaveProcess"){ // 관심상품
			document.forms.processForm.st_pf_my_group.value = st_my_groups;	
		}else{
			document.forms.processForm.st_pf_my_group.value = "";
		} 
		
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
        	var text = "<%=CommonLang.msg("MSG695")%>";//장바구니에 추가되었습니다.
        	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
        	var but2textC = "<%=CommonLang.get("HTITLE1122")%>"; //장바구니 가기
        	var but1funcC = "javascript:closePopText1(); return false;";
        	var but2funcC = "javascript:thisPopClose('CsaveProcess'); return false;";
        	var but1widthC = "120px";
        	var but2widthC = "120px";
        	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
        	
       }else if(pMethod == "RsaveProcess") {
    		 //관심상품으로 등록 되었습니다.
    		   <%--           alert("<%=CommonLang.msg("MSG23") %>   "); --%>
    		             var text = "<%=CommonLang.msg("MSG669") %>";
    	   var confirm4 = $("#confirm4").val();
    	   if(confirm4 == "location"){
    		   openLayerPopText2(text,but1text,"javascript:thisPopClose('RsaveProcess'); return false;",but1width);
    	   }else{
    		   openLayerPopText2(text,but1text,but1func,but1width);
    	   }
<%--     	    var text = "<%=CommonLang.msg("MSG696")%>";//선택하신 상품이 관심상품에 담겼습니다. 관심상품으로 이동하시겠습니까? --%>
<%-- 	       	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기 --%>
<%-- 	       	var but2textC = "<%=CommonLang.get("HTITLE1123")%>"; //관심상품 가기 --%>
// 	       	var but1funcC = "javascript:closePopText1(); return false;";
// 	       	var but2funcC = "javascript:thisPopClose('RsaveProcess'); return false;";
// 	       	var but1widthC = "120px";
// 	       	var but2widthC = "120px";
// 	       	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
       }
      }else{
         if(pMethod == "CsaveProcess"){
        	var text = sMsg; //이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다.
          	var but1textC = "<%=CommonLang.get("HTITLE1121")%>"; //쇼핑 계속하기
          	var but2textC = "<%=CommonLang.get("HTITLE1122")%>"; //장바구니 가기
          	var but1funcC = "javascript:closePopText1(); return false;";
          	var but2funcC = "javascript:goCart(); return false;";
          	var but1widthC = "120px";
          	var but2widthC = "120px";
          	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
          }else if(pMethod == "RsaveProcess") { //중복이어도 그냥 이동 OR 계속 쇼핑
        	  var confirm4 = $("#confirm4").val();
	       	   if(confirm4 == "location"){
	       			thisPopClose('RsaveProcess');
	       	   }
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
		//관심상품등록 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG671")%>";
	  	   openLayerPopText2(text,but1text,but1func,but1width);
	}  else{
		 //다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG523")%>";
	  	   openLayerPopText2(text,but1text,but1func,but1width);
	}
	 
	
} 
function thisPopClose(flag){
	closePopText1();
	if(flag== "CsaveProcess"){
		$('#locationForm2').attr("action", "<%=p060000036%>").submit();
	}else if(flag == "RsaveProcess"){
		$('#locationForm2').attr("action", "/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit();
	}
}
function goCart(){
	closePopText1();
	location.href = "<%=p060000036%>";
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
    	$("#confirmMyGroupMsg").text("<%=CommonLang.msg("MSG696")%>");//관심상품으로 저장할 폴더를 선택해주세요.
    	$("#confirmMyGroupArea").show();
    	$("#confirmMyGroupAreaOverlay").show();
    }

//     $('body,html').animate({
// 		scrollTop: 0
// 	}, 100);
	
	
	
	 //runProcess(runFlag,query,flag);
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
	var st_description = "<%=rowData1.get("DESCRIPTION_LOC")%>";
	openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?st_ds_user_id='+$('#emp_user_id'+agentIndex).val()+'&st_ds_dept='+$('#emp_dept'+agentIndex).val()+'&st_title='+text+'&st_code='+code+'&st_buyer_item_no='+st_buyer_item_no+'&st_description='+st_description,'560,540,no');    
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
//    			//품목의 주문수량(숫자)을 입력하여 주십시요.
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
	if(kepTrimStr(doc_no) == ""){
		//첨부파일이 없습니다.
		var text = "<%=CommonLang.msg("MSG612") %>  ";
		 openLayerPopText2(text,but1text,but1func,but1width);
		 return;
	}else{
		location.href="/common/download_v2.do?DOC_NO="+doc_no;
	}
}
function attachMsdsFileDownload(doc_no){
	if(kepTrimStr(doc_no) == ""){
		//첨부파일이 없습니다.
		var text = "<%=CommonLang.msg("MSG612") %>  ";
		 openLayerPopText2(text,but1text,but1func,but1width);
		 return;
	}else{
		location.href="/common/downloadMulti_v2.do?DOC_NO="+doc_no;
	}
}
//계속검색
function kep_confrim_search(){
	var runFlag = $("#confirm1").val();
	$("#confirm4").val("search");
	$("#confirmCartArea").hide();
	$("#confirmCartAreaOverlay").hide();
	$("#confirmMyGroupArea").hide();
	$("#confirmMyGroupAreaOverlay").hide();
	if(runFlag == "CsaveProcess" || runFlag == "RsaveProcess"){
		runProcess();
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
//text타입에서 엔터 눌렀을때 브라우저 자동 submit이 되면서 파일찾기가 열리는 현상 때문에 text타입에서 엔터 막기
$(document).on('keydown', 'input[type=text]', function(e) {
  if (e.key === 'Enter') e.preventDefault();
});
</script> 
</html>
