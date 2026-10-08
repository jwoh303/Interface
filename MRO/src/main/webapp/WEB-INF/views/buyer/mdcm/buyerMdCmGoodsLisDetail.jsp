<%--
**********************************************
* 메뉴 : 상품검색>카테고리상품검색>상품목록>상품상세
* 화면 : 상품상세
* 기능 : 상품상세.
* 프로그램 ID : PG_06_B_061_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-14
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
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
		agent_open_flag =  CommonUtil.nvl((String)sessionInfo.getAgentOpenFlag());
		
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
	//안전인증서 표기 여부
	boolean p04405701 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4057-01");
    //MOQ를 이용하여 주문 통제
    boolean p060000077 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000077"); 
    //주문배수를 이용하여 주문 통제
    boolean p060000089 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000089");
	//SLOGIC-END
	
%> 

<body onLoad="kep_onload_view()">
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

	 <h3><%=CommonLang.get("HTITLE894")%><!-- 상품상세정보 --></h3>
	    <table class="cont_t_list01" >
			<caption>조회</caption>
                <colgroup>
                    <col width="100%" />
                 </colgroup>
				<tbody>
				<tr><th><h4>
			
<%
if(p060000052 == true){
	if(_pathList.size() > 0){
		Map<String,String> pathData = null;
		for (int j=0; j<_pathList.size(); j++) {
			pathData = _pathList.get(j);
			if(j == _pathList.size()-1){
	%> 
		<%=CommonUtil.nvl(pathData.get("CATEG_NAME"))%>
	<%  }else{ %>
		<a   href="javascript:getNextCategory('<%=CommonUtil.nvl(pathData.get("CATEG_SYS_CODE"))%>','<%=CommonUtil.nvl(pathData.get("CATEG_NAME"))%>'
		,'<%=CommonUtil.nvl(pathData.get("STD_CATEG_ID"))%>','<%=CommonUtil.nvl(pathData.get("PID"))%>','<%=CommonUtil.nvl(pathData.get("DEPTH"))%>','<%=CommonUtil.nvl(pathData.get("CATEG_TYPE"))%>'
		,'<%=CommonUtil.nvl(pathData.get("COM_CODE"))%>');"><%=CommonUtil.nvl(pathData.get("CATEG_NAME"))%>&nbsp;&nbsp;>&nbsp;&nbsp;</a>
	<%    
    		}
		}
	}
}
%>
				</h4></th></tr>
				</tbody>
			</table>
	<form name = "contentForm" id="contentForm" method = "post">	 
<% if (rowData1 != null) { %>	 
        	<div id="productInfoArea">    
       		  <div id="imageArea">
                	<div id="proImg" title="이미지">
					  <% if(rowData1.get("IMGFILE_NAME").equals("")){ %>
						<img src="/resources/images/noimage.gif" name = "image1" width="250" height="250">
						<input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir"  value="">
						<input type="hidden" name="st_imgfile_name" id="st_imgfile_name"  value="">
					  <% }else { %>
						<img src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData1.get("IMGFILE_DIR")+"/"+rowData1.get("IMGFILE_NAME")%>" onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name = "image1" width="250" height="250">
						<input type="hidden" name="st_imgfile_dir"  id="st_imgfile_dir" value="<%=rowData1.get("IMGFILE_DIR")%>">
						<input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value="<%=rowData1.get("IMGFILE_NAME")%>">
					  <% } %>
					</div>
                    <p class="plusImg"  title="이미지크게보기">
					<a href="javascript:getBigImage('<%=rowData1.get("IMGFILE_DIR")%>','<%=rowData1.get("IMGFILE_NAME")%>')">
					<img src="/resources/images/btn_zoom.gif" alt="확대" style="vertical-align:middle; margin-right:10px;" />
					<%=CommonLang.get("HTITLE901")%><!-- 이미지 크게보기 --></a>
					</p>
                </div>
				<div id="proInfoArea">
              		<%
					//사용자 언어타입이 영어일 영문 품명 표기
					if(h_get_session_user_lang.equals("EN")) {
					%> 
                    	<p class="proName"><%=rowData1.get("DESCRIPTION_ENG")%></p>
             		<%
					}else{
					%>
						<p class="proName"><%=rowData1.get("DESCRIPTION_LOC")%></p>
             		<%
					}
					%>
                    <ul class="infoBg">
                    	<li><span class="title"><%=CommonLang.get("HTITLE512")%><!-- 카테고리명 --></span><span class="info"><%=rowData1.get("CATEGORY_TEXT")%></span></li>
              			<%
						//사용자 언어타입이 영어일 영문 품명 표기
						if(h_get_session_user_lang.equals("EN")) {
						%> 
                        	<li><span class="title"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></span><span class="info"><%=rowData1.get("DESCRIPTION_ENG")%></span></li>
              			<%
						}else{
						%>
							<li><span class="title"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></span><span class="info"><%=rowData1.get("DESCRIPTION_LOC")%></span></li>
              			<%
						}
						%> 
                        <li><span class="title"><%=CommonLang.get("HTITLE710")%><!-- 품목상세설명 --></span><span class="info"><%=rowData1.get("ITEM_DETAIL_DESC")%></span></li>
              			<%
						//사용자 언어타입이 영어일 영문 규격 표기
						if(h_get_session_user_lang.equals("EN")) {
						%> 
                        	<li><span class="title"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></span><span class="info"><%=rowData1.get("SPECIFICATION_ENG")%></span></li>
              			<%
						}else{
						%>
							<li><span class="title"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></span><span class="info"><%=rowData1.get("SPECIFICATION")%></span></li>
              			<%
						}
						%>
                        <li><span class="title"><%=CommonLang.get("HTITLE52")%><!-- 단위 --></span><span class="info"><%=rowData1.get("UNIT_MEASURE")%></span></li>
                    </ul>
                    <ul class="infoBgNone">
<% if(!rowData1.get("MSDS_NO").equals("") && !rowData1.get("MSDS_NO").equals("MS88888888") && !rowData1.get("MSDS_NO").equals("MS99999999")){ %>
						<li><span class="title">MSDS</span><span class="info"><a style="color:#ee3212" href="javascript:getMsdsInfoPop('<%=rowData1.get("MSDS_NO")%>')"><u><%=rowData1.get("MSDS_NO")%></u></a></span></li>
<%} %>
<% if(!rowData1.get("P070000033_CHECK").equals("") && rowData1.get("SG118_CHECK").equals("Y")){ %>
						<li><span class="title"><%=CommonLang.get("HTITLE985")%><!-- 보관조건 --></span><span class="info"><%=rowData1.get("TEMP_COND")%> / <%=rowData1.get("TEMP_RANGE")%></span></li>
<%} %>
                    	<li><span class="title"><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></span><span class="info"><%=rowData1.get("MAKER_NAME")%></span></li>
                        <li><span class="title"><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></span><span class="info"><%=rowData1.get("ORIGIN")%></span></li>
                        <li><span class="title"><%=CommonLang.get("HTITLE895")%><!-- 제조사모델 NO --></span><span class="info"><%=rowData1.get("MAKER_PART_NO")%></span></li>
        <%
      //안전인증서 표기 여부
        if((p04405701 == true)) {
        %>    
        	<li><span class="title"><%=CommonLang.get("HTITLE915")%><!-- 안전인증서 --></span><span class="info"><%=rowData1.get("SAFETY_FLAG_TEXT")%></span></li>
        <%
        }
        %>
                        <li>
                        	<span class="title"><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></span><span class="info">
									<%
                                        if(!rowData1.get("IMAGE_KEY").equals("")) {
                                    %> 
                                    	<a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData1.get("IMAGE_KEY"))%>')"><img name="st_image_key_img" src="/resources/images/disk_on.gif"   style="margin-top:5px" border="0"></a> 
                                    <%
                                        }else {
                                    %> 
                                    	<img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:5px" border="0"> 
                                    <%
                                        }
                                    %>
                        	</span>
                        </li>
<% if(!rowData1.get("BUY_GREEN_ITEM_NM").equals("")){ %>
						<li><span class="title"><%=CommonLang.get("HTITLE956")%><!-- 녹색구매제품 --></span><span class="info"><%=rowData1.get("BUY_GREEN_ITEM_NM")%></span></li>
<%} %>
                </div>
                
<%} %>
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
	title10 = CommonLang.get("HTITLE938");		//MOQ
	title11 = CommonLang.get("HTITLE939");		//주문배수
	title12 = CommonLang.get("HTITLE578");		//조달일수
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
	title10 = CommonLang.get("HTITLE938");		//MOQ
	title11 = CommonLang.get("HTITLE939");		//주문배수
	title12 = CommonLang.get("HTITLE578");		//조달일수
	title13 = CommonLang.get("HTITLE699");		//조달일수
  }
	%>
 					
<!--협력사 단가-->
                <div class="bigo">
                    <div class="bigoRight">
						 	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
							<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
							<input type="hidden" name="st_mail" id="st_mail"  value="${sessionInfo.email}">
							<input type="hidden" name="st_user_name" id="st_user_name"  value="${sessionInfo.userNameLoc}">
							<input type="hidden" name="temp_contract_no"  id="temp_contract_no"  value="<%=rowData2.get("CONTRACT_NO")%>">
							<input type="hidden" name="temp_contract_seq" id="temp_contract_seq"  value="<%=rowData2.get("CONTRACT_SEQ")%>">
							<input type="hidden" name="temp_agent_code"   id="temp_agent_code"  value="<%=rowData2.get("AGENT")%>">
							<input type="hidden" name="temp_byit_comorg_code"   id="temp_byit_comorg_code"  value="<%=rowData2.get("BUYER")%>">
							<input type="hidden" name="temp_item_no"   id="temp_item_no"  value="<%=rowData2.get("BUYER_ITEM_NO")%>">
							<input type="hidden" name="st_item_type_co"  value="<%=CommonUtil.nvl(rowData2.get("PRODUCT_CLOSE_FLAG"))%>">
							<input type="hidden" name="st_description2" id="st_description2"  value="<%=CommonUtil.nvl(rowData2.get("DESCRIPTION"))%>">
							<input type="hidden" name="st_specification2"  value="<%=CommonUtil.nvl(rowData2.get("SPECIFICATION"))%>">
							<input type="hidden" name="st_unit_price"  value="<%=CommonUtil.nvl(rowData2.get("UNIT_PRICE"))%>">
							<input type="hidden" name="emp_user_id"  id="emp_user_id"  value="<%=CommonUtil.nvl(rowData1.get("USER_ID"))%>"/>
					    	<input type="hidden" name="emp_dept"  id="emp_dept"  value="<%=CommonUtil.nvl(rowData1.get("DEPARTMENT"))%>"/>
					    	<input type="hidden" name="st_min_order_qty"  id="st_min_order_qty"  value="<%=CommonUtil.nvl(rowData2.get("MIN_ORDER_QTY"))%>"/>
					    	<input type="hidden" name="st_pur_unit_qty"  id="st_pur_unit_qty"  value="<%=CommonUtil.nvl(rowData2.get("PUR_UNIT_QTY"))%>"/>
							
                        <ul>
							<li><span class="title">	<input type="checkbox" name="lnCheck<%=i %>" id="check"  style="vertical-align:middle"	
							<%
							if(i == 0){
							%> checked <%}%> onClick="oneSelect('<%=i%>')">&nbsp; 
							<%=title1 %></span><span class="info">
							<%if(agent_open_flag.equals("N")){ %>
								<a href="javascript:getAgentDisplayPop('KRKORE0001');"><%=CommonLang.get("HTITLE820")%></a><!-- 코리아이플랫폼㈜ -->
							<%}else{ %>
								<a href="javascript:getAgentDisplayPop('<%=rowData2.get("AGENT")%>');"><%=rowData2.get("COM_NAME_LOC")%></a>
							<%}%>
							</span></li>
							<li><span class="title"><%=title2 %></span><span class="info">
								<%=rowData2.get("BUYER_ITEM_NO")%>
							</span></li>
							<li><span class="title"><%=title12 %></span><span class="info">
								<%=rowData2.get("DELIVERY_LT")%> <%=CommonLang.get("HTITLE834")%><!-- 일 -->
							</span></li>
							<%
								if(!rowData2.get("STOCK_CNT").equals("")) {
							%>
								<li>
									<span class="title"><%=title13 %></span>
									<span class="info"><%=rowData2.get("STOCK_CNT")%></span>
								</li>							
							<%
								}
							%>
							<li><span class="title"><%=title3 %></span><span class="Pricing">
							<img src="/resources/images/icon_won.gif" alt="원">
							<%=CommonUtil.formatNumber(rowData2.get("UNIT_PRICE"),true,0,3)%>
							</span></li>
							<%
								//MOQ 통제 적용
								if(p060000077==true) {
							%>
								<li>
									<span class="title"><%=title10 %></span>
									<span class="info"><%=rowData2.get("MIN_ORDER_QTY")%></span>
								</li>
							<%
								}
							%>
							<%
								//주문배수 통제 적용
								if(p060000089==true) {
							%>
								<li>
									<span class="title"><%=title11 %></span>
									<span class="info"><%=rowData2.get("PUR_UNIT_QTY")%></span>
								</li>
							<%
								}
							%>
							<li>
								<span class="title"><%=title4 %></span><span class="info">
									<input type="text" name="st_temp_qty" id="st_temp_qty" class="input_type_text2" title="" style="width:70px; height:20px; padding-right:5px; text-align:right;" value="1" />
								</span>
							</li>
                        </ul>
                    </div>
                    <div class="bigoLeft">
                        <ul>
							<li><span class="title">&nbsp;</span><span class="info">&nbsp;</span></li>
							<li><span class="title">&nbsp;</span><span class="info">&nbsp;</span></li>
							<li><span class="title">&nbsp;</span><span class="info">&nbsp;</span></li>
							<li><span class="title">&nbsp;</span><span class="info">&nbsp;</span></li>
							<li><span class="title">&nbsp;</span><span class="info">&nbsp;</span></li>
                        </ul>
                    </div>
                </div>
<%}%> 

 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=rec_cnt%>"  />
                    <!--버튼영역-->
                    <div class="PDbtnArea">
                    <p>
                        <span class="btn_shopping_pd" title="품목정보 오류신고"><a href="javascript:doAction('reqVocItem','ZA');"><%=CommonLang.get("HTITLE889")%><!-- 품목정보 오류신고 --></a></span>
                        <span class="btn_shopping_pd" title="품목이미지 요청"><a href="javascript:doAction('reqVocImage','ZB');"><%=CommonLang.get("HTITLE890")%><!-- 품목이미지 요청 --></a></span>		
                    </p>
<%
//두산중공업 펀치아웃 
//SLOGIC-BEGIN(P06-0000052)
if(p060000052 == true) {
	if(product_flag.equals("C")){
%>
		                <span class="btn_order" title="견적의뢰"><a href="javascript:doAction('saveReq','');"><%=CommonLang.get("HTITLE39")%><!-- 견적의뢰 --></a></span>
	<%} %>
                        <span class="btn_order" title="장바구니담기"><a href="javascript:doAction('cartPItem','');"><%=CommonLang.get("HTITLE11")%><!-- 장바구니담기 --></a></span> 
                        <span class="btn_shopping" title="나의상품등록"><a href="javascript:doAction('myPItem','');"><%=CommonLang.get("HTITLE10")%><!-- 나의상품등록 --></a></span>
                        <span class="btn_shopping" title="이전화면"><a href="javascript:doAction('kep_Pback')"><%=CommonLang.get("HTITLE821")%><!-- 이전화면 --></a></span>
<%
}else{
%>
                        <span class="btn_order" title="장바구니담기"><a href="javascript:doAction('cartItem','');"><%=CommonLang.get("HTITLE11")%><!-- 장바구니담기 --></a></span> 
                        <span class="btn_shopping" title="나의상품등록"><a href="javascript:doAction('myItem','');"><%=CommonLang.get("HTITLE10")%><!-- 나의상품등록 --></a></span>
                        <span class="btn_shopping" title="이전화면"><a href="javascript:doAction('kep_back')"><%=CommonLang.get("HTITLE821")%><!-- 이전화면 --></a></span>
<%
}
%>
                    </div>
                </div>

<% if(!rowData1.get("DETAIL_IMGFILE_DIR").equals("")){ %>
		<div style="clear:both; border-top:1px solid #cdcdcd; width:1200px; margin-bottom:20px">
               <div ><img src="<%=CommonUtil.realImgS3UploadPath+"/"+rowData1.get("DETAIL_IMGFILE_DIR")+"/"+rowData1.get("DETAIL_IMGFILE_NAME")%>" onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name = "image2" ></div>
           </div>
           <div id="productInfoArea">
               <div class="PDbtnArea">
                   <span class="btn_order" title="장바구니담기"><a href="javascript:doAction('cartItem','');"><%=CommonLang.get("HTITLE11")%><!-- 장바구니담기 --></a></span>
                   <span class="btn_shopping" title="나의상품등록"><a href="javascript:doAction('myItem','');"><%=CommonLang.get("HTITLE10")%><!-- 나의상품등록 --></a></span>
                   <span class="btn_shopping" title="이전화면"><a href="javascript:doAction('kep_back')"><%=CommonLang.get("HTITLE821")%><!-- 이전화면 --></a></span> 
               </div>
           </div>

<%} else if(!rowData1.get("DETAIL_ITEM_INFO").equals("")){ %>
		<div style="clear:both; border-top:1px solid #cdcdcd; width:1200px; margin-bottom:20px">
               <div ><%=rowData1.get("DETAIL_ITEM_INFO")%></div>
           </div>
           <div id="productInfoArea">
               <div class="PDbtnArea">
                   <span class="btn_order" title="장바구니담기"><a href="javascript:doAction('cartItem','');"><%=CommonLang.get("HTITLE11")%><!-- 장바구니담기 --></a></span>
                   <span class="btn_shopping" title="나의상품등록"><a href="javascript:doAction('myItem','');"><%=CommonLang.get("HTITLE10")%><!-- 나의상품등록 --></a></span>
                   <span class="btn_shopping" title="이전화면"><a href="javascript:doAction('kep_back')"><%=CommonLang.get("HTITLE821")%><!-- 이전화면 --></a></span> 
               </div>
           </div>

<%} %>
       


                </div>

</form>
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
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript"> 


function kep_onload_view(){	 
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


	$('#locationForm').attr("action", "<%=h_sslurl%>/mdcm/showBuyerMdCmCategoryPCOSearch.do").submit();   
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
	
    var tot_cnt  = $("#display_item_cnt").val(); 
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" <%=CommonLang.msg("MSG511")%>     ");	//목록에 표시된 협력사가 없습니다.
        return;
    }
    if(eval(tot_cnt) < 2){
        
    }else{
        for(var j = 0; j < tot_cnt; j++){
             var box = eval("document.forms.contentForm.lnCheck" + j);
             box.checked = false;               
        }
        var box = eval("document.forms.contentForm.lnCheck" +num);
        box.checked = true;   
    }
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
        alert(" <%=CommonLang.msg("MSG511")%>     ");	//목록에 표시된 협력사가 없습니다.
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
    	 alert(" <%=CommonLang.msg("MSG512")%>    ");	//상품에 대한 협력사가 선택되지 않았습니다. 협력사와 수량을 선택해 주시기 바랍니다.
        return;
    }else if (eval(chk_cnt) > 1){
    	 alert(" <%=CommonLang.msg("MSG513")%>    ");	//상품에 대한 협력사가 하나만 선택 가능합니다.
    	 return
    }else {
    	 
		
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){
            	var order_qty     = document.forms.contentForm.st_temp_qty.value; 
		        var st_item_no   = document.forms.contentForm.temp_item_no.value;
				var st_order_qty = document.forms.contentForm.st_temp_qty.value;
				var st_agent     = document.forms.contentForm.temp_agent_code.value;
				var contract_no  = document.forms.contentForm.temp_contract_no.value;
				var contract_seq = document.forms.contentForm.temp_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.temp_byit_comorg_code.value;
				var st_min_order_qty =document.forms.contentForm.st_min_order_qty.value; //MOQ
				var st_pur_unit_qty =document.forms.contentForm.st_pur_unit_qty.value; //발주배수
				var p060000077 = "<%=p060000077%>"; //MOQ
				var p060000089 = "<%=p060000089%>"; //주문배수
	            //MOQ 주문 통제 특수로직 적용한 고객사 한정
	            if(p060000077 == "true"){
	    			if(Number(order_qty) < Number(st_min_order_qty)){
	                    //발주수량이 MOQ보다 수량이 작습니다. 발주수량을 MOQ보다 크게 입력하여 주십시오. 
	                	alert("<%=CommonLang.msg("MSG437")%>");
	                    document.forms.contentForm.st_temp_qty.focus();
	                    return;				
	    			}            	
	            }
	            //주문배수 주문 통제 특수로직 적용한 고객사 한정
	            if(p060000089 == "true"){
	            	var checkNum = order_qty%st_pur_unit_qty;
	    			if(checkNum != 0 ){
	                    //번째 품목의 주문배수만큼 주문 수량 입력 바랍니다. 
	                	alert("1"+"<%=CommonLang.msg("MSG533")%>");
	                    document.forms.contentForm.st_temp_qty.focus();
	                    return;				
	    			}            	
	            }				
                if(!kepChkDecimal(order_qty,3)){
                    alert( "  <%=CommonLang.msg("MSG18")%>   ");	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.
                    document.forms.contentForm.st_temp_qty.focus();
                    return;
                } else{
					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
				}
                result_st_order_qty = st_order_qty;
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                var order_qty     = document.forms.contentForm.st_temp_qty[i].value;
				var st_item_no   = document.forms.contentForm.temp_item_no[i].value;
				var st_order_qty = document.forms.contentForm.st_temp_qty[i].value;
				var st_agent     = document.forms.contentForm.temp_agent_code[i].value;
				var contract_no  = document.forms.contentForm.temp_contract_no[i].value;
				var contract_seq = document.forms.contentForm.temp_contract_seq[i].value;
				var byit_comorg_code = document.forms.contentForm.temp_byit_comorg_code[i].value;
				var st_min_order_qty =document.forms.contentForm.st_min_order_qty[i].value; //MOQ
				var st_pur_unit_qty =document.forms.contentForm.st_pur_unit_qty[i].value; //발주배수
				var p060000077 = "<%=p060000077%>"; //MOQ
				var p060000089 = "<%=p060000089%>"; //주문배수
				
                if(box.checked == true){
    	            //MOQ 주문 통제 특수로직 적용한 고객사 한정
    	            if(p060000077 == "true"){
    	    			if(Number(order_qty) < Number(st_min_order_qty)){
    	                    //발주수량이 MOQ보다 수량이 작습니다. 발주수량을 MOQ보다 크게 입력하여 주십시오. 
    	                	alert("<%=CommonLang.msg("MSG437")%>");
    	                    document.forms.contentForm.st_temp_qty[i].focus();
    	                    return;				
    	    			}            	
    	            }
    	            //주문배수 주문 통제 특수로직 적용한 고객사 한정
    	            if(p060000089 == "true"){
    	            	var checkNum = order_qty%st_pur_unit_qty;
    	    			if(checkNum != 0 ){
    	                    //번째 품목의 주문배수만큼 주문 수량 입력 바랍니다. 
    	                	alert(i+"<%=CommonLang.msg("MSG533")%>");
    	                    document.forms.contentForm.st_temp_qty[i].focus();
    	                    return;				
    	    			}            	
    	            }
                    if(!kepChkDecimal(order_qty,3)){
                        alert( i+"  <%=CommonLang.msg("MSG20")%>   ");	//번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.
                        document.forms.contentForm.st_temp_qty[i].focus();
                        return;
                    } else {
					  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
					  query += "&&";
					}
                    
                    result_st_order_qty = st_order_qty;
                }
            }
        }
    }	 
    
    var msg = "";
    if (flag == "C"){
    	msg = "<%=CommonLang.get("HTITLE161")%>";	//장바구니
    }else{
    	msg = "<%=CommonLang.get("HTITLE593")%>";	//나의상품
    }   
    
    // 주문수량을 (으)로 으로 저장하시고 보기 화면으로 이동하시겠습니까?
	if (confirm("<%=CommonLang.msg("MSG514")%> "+ result_st_order_qty + " <%=rowData1.get("UNIT_MEASURE")%><%=CommonLang.msg("MSG515")%>\n"+msg+" <%=CommonLang.msg("MSG348")%> "+msg+"<%=CommonLang.msg("MSG349")%>")==false) return; 	
	runProcess(flag+"saveProcess",query,flag);
}


/*
 * 펀치아웃 나의상품등록 R
 * 장바구니담기 C
 */
function savePCOProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0;
    var cnt     = 0;
    var result_st_order_qty = 0;
    var query   = "";
	var item_type_cnt_N = 0;
	var item_type_cnt_A = 0;
	var item_type_cnt_B = 0;
	var item_type_cnt_C = 0;
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" <%=CommonLang.msg("MSG511")%>     ");	//목록에 표시된 협력사가 없습니다.
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
    	 alert(" <%=CommonLang.msg("MSG512")%>    ");	//상품에 대한 협력사가 선택되지 않았습니다.\n 협력사와 수량을 선택해 주시기 바랍니다.
        return;
    }else if (eval(chk_cnt) > 1){
    	 alert(" <%=CommonLang.msg("MSG513")%>    ");	//상품에 대한 협력사가 하나만 선택 가능합니다.
    	 return
    }else {
    	 
		
        if(eval(tot_cnt) < 2){
            var box = eval("document.forms.contentForm.lnCheck0" ); 
            if(box.checked == true){

		        var st_item_no   = document.forms.contentForm.temp_item_no.value;
				var st_order_qty = document.forms.contentForm.st_temp_qty.value; 
				var st_agent     = document.forms.contentForm.temp_agent_code.value;
				var contract_no  = document.forms.contentForm.temp_contract_no.value;
				var contract_seq = document.forms.contentForm.temp_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.temp_byit_comorg_code.value;
            	var item_type =document.forms.contentForm.st_item_type_co.value;
				var st_description2 =document.forms.contentForm.st_description2.value;
				var st_specification2 =document.forms.contentForm.st_specification2.value;
				var st_unit_price =document.forms.contentForm.st_unit_price.value;
				var st_min_order_qty =document.forms.contentForm.st_min_order_qty.value; //MOQ
				var st_pur_unit_qty =document.forms.contentForm.st_pur_unit_qty.value; //발주배수
				var p060000077 = "<%=p060000077%>"; //MOQ
				var p060000089 = "<%=p060000089%>"; //주문배수
				
                if(!kepChkDecimal(st_order_qty,3)){
                    alert( " <%=CommonLang.msg("MSG18")%>    ");	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..) 소숫점은 3자리까지 가능합니다.
                    document.forms.contentForm.st_temp_qty.focus();
                    return;
                }
                if(item_type == "N"){
                    item_type_cnt_N++;	            	
                }else if(item_type == "A"){
                    item_type_cnt_A++;	  
    			}else if(item_type == "B"){
                	item_type_cnt_B++;
                }else if(item_type == "C"){
                	item_type_cnt_C++;
                }
				if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
					 alert( "  <%=CommonLang.msg("MSG516")%>     ");	//단가계약품목과 신규요청품목이 동시에 선택 되었습니다. 나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.
					 box.checked = false;
				     return;
				}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
					 alert( "  <%=CommonLang.msg("MSG517")%>     ");	//일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다. 나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.
					 box.checked = false;
				     return;
				}else if(item_type_cnt_C > 0){
					 alert( "  <%=CommonLang.msg("MSG518")%>     ");	//신규요청품목이 선택 되었습니다. 나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.
					 box.checked = false;
				     return;
				}
	            //MOQ 주문 통제 특수로직 적용한 고객사 한정
	            if(p060000077 == "true"){
	    			if(Number(st_order_qty) < Number(st_min_order_qty)){
	                    //발주수량이 MOQ보다 수량이 작습니다. 발주수량을 MOQ보다 크게 입력하여 주십시오. 
	                	alert("<%=CommonLang.msg("MSG437")%>");
	                    document.forms.contentForm.st_temp_qty.focus();
	                    return;				
	    			}            	
	            }
	            //주문배수 주문 통제 특수로직 적용한 고객사 한정
	            if(p060000089 == "true"){
	            	var checkNum = st_order_qty%st_pur_unit_qty;
	    			if(checkNum != 0 ){
	                    //번째 품목의 주문배수만큼 주문 수량 입력 바랍니다. 
	                	alert("1"+"<%=CommonLang.msg("MSG533")%>");
	                    document.forms.contentForm.st_temp_qty.focus();
	                    return;				
	    			}            	
	            }
				 query = st_item_no + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + st_description2 + "@@"  + st_specification2 +  "@@"  + st_unit_price + "@@" + st_order_qty+"&&";
                
                result_st_order_qty = st_order_qty;
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                if(box.checked == true){
    		        var st_item_no   = document.forms.contentForm.temp_item_no[i].value;
    				var st_order_qty = document.forms.contentForm.st_temp_qty[i].value; 
    				var st_agent     = document.forms.contentForm.temp_agent_code[i].value;
    				var contract_no  = document.forms.contentForm.temp_contract_no[i].value;
    				var contract_seq = document.forms.contentForm.temp_contract_seq[i].value;
    				var byit_comorg_code = document.forms.contentForm.temp_byit_comorg_code[i].value;
                	var item_type =document.forms.contentForm.st_item_type_co[i].value;
    				var st_description2 =document.forms.contentForm.st_description2[i].value;
    				var st_specification2 =document.forms.contentForm.st_specification2[i].value;
    				var st_unit_price =document.forms.contentForm.st_unit_price[i].value;
    				var st_min_order_qty =document.forms.contentForm.st_min_order_qty[i].value; //MOQ
    				var st_pur_unit_qty =document.forms.contentForm.st_pur_unit_qty[i].value; //발주배수
    				var p060000077 = "<%=p060000077%>"; //MOQ
    				var p060000089 = "<%=p060000089%>"; //주문배수  

                    if(!kepChkDecimal(st_order_qty,3)){
                        alert( " <%=CommonLang.msg("MSG18")%>    ");	//첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..) 소숫점은 3자리까지 가능합니다.
                        document.forms.contentForm.st_temp_qty.focus();
                        return;
                    }
                    if(item_type == "N"){
                        item_type_cnt_N++;	            	
                    }else if(item_type == "A"){
                        item_type_cnt_A++;	  
        			}else if(item_type == "B"){
                    	item_type_cnt_B++;
                    }else if(item_type == "C"){
                    	item_type_cnt_C++;
                    }
    				if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
    					 alert( "  <%=CommonLang.msg("MSG516")%>     ");	//단가계약품목과 신규요청품목이 동시에 선택 되었습니다. 나의상품등록은 단가계약품목이나  일회성_미발주 품목만 선택하시기 바랍니다.
    					 box.checked = false;
    				     return;
    				}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
    					 alert( "  <%=CommonLang.msg("MSG517")%>     ");	//일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다. 나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.
    					 box.checked = false;
    				     return;
    				}else if(item_type_cnt_C > 0){
    					 alert( "  <%=CommonLang.msg("MSG518")%>     ");	//신규요청품목이 선택 되었습니다. 나의상품등록은 단가계약품목이나 일회성_미발주 품목만 선택하시기 바랍니다.
    					 box.checked = false;
    				     return;
    				}
    	            //MOQ 주문 통제 특수로직 적용한 고객사 한정
    	            if(p060000077 == "true"){
    	    			if(Number(st_order_qty) < Number(st_min_order_qty)){
    	                    //발주수량이 MOQ보다 수량이 작습니다. 발주수량을 MOQ보다 크게 입력하여 주십시오. 
    	                	alert("<%=CommonLang.msg("MSG437")%>");
    	                    document.forms.contentForm.st_temp_qty[i].focus();
    	                    return;				
    	    			}            	
    	            }
    	            //주문배수 주문 통제 특수로직 적용한 고객사 한정
    	            if(p060000089 == "true"){
    	            	var checkNum = st_order_qty%st_pur_unit_qty;
    	    			if(checkNum != 0 ){
    	                    //번째 품목의 주문배수만큼 주문 수량 입력 바랍니다. 
    	                	alert(i+"<%=CommonLang.msg("MSG533")%>");
    	                    document.forms.contentForm.st_temp_qty[i].focus();
    	                    return;				
    	    			}            	
    	            }
    				 query = st_item_no + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code + "@@" + st_description2 + "@@"  + st_specification2 +  "@@"  + st_unit_price + "@@" + st_order_qty+"&&";
                    
                    result_st_order_qty = st_order_qty;
                }
            }
        }
    }	 
    
    var msg = "";
    if (flag == "C"){
    	msg = "<%=CommonLang.get("HTITLE161")%>";	//장바구니
    }else{
    	msg = "<%=CommonLang.get("HTITLE593")%>";	//나의상품
    }   
    
 // 주문수량을 (으)로 으로 저장하시고 보기 화면으로 이동하시겠습니까?
	if (confirm("<%=CommonLang.msg("MSG514")%> "+ result_st_order_qty + " <%=rowData1.get("UNIT_MEASURE")%><%=CommonLang.msg("MSG515")%>\n"+msg+" <%=CommonLang.msg("MSG348")%> \n"+msg+"<%=CommonLang.msg("MSG349")%>")==false) return; 	
	runProcess(flag+"savePCOProcess",query,flag);
}


function saveReq(){
	var buyer = document.forms.contentForm.st_com_code.value; 
	var user_id = document.forms.contentForm.st_user_id.value;
	var mail = document.forms.contentForm.st_mail.value;
	var user_name = document.forms.contentForm.st_user_name.value;
	var dept_code  = "";
	var dept_name = "";
	var phone_no = "";
	var query = "";
	var chk_cnt = 0;
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mdcm/getRqUserInfo.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: {param1: buyer,param2: user_id},
	     async : false,
	     success:function( response ) {  		    	  
	    	 	 		    	  
   	 	if (response.data.length > 0){
		    	  for (var i=0; i<response.data.length; i++){ 
		    		  if(i==response.data.length-1){
		    			  dept_code = $.trim(eval("response.data["+i+"].DEPT_CODE"));
		    			  dept_name = $.trim(eval("response.data["+i+"].DEPT_NAME"));
		    			  phone_no = $.trim(eval("response.data["+i+"].PHONE_NO"));
		    	  	  }
	 		      }	 
   		  }
		      },
		 error:function( response ) {  		    	   
	    	 alert("<%=CommonLang.msg("MSG15")%>");	//오류발생하였습니다.
		      }
   });  

	var tot_cnt  = $("#display_item_cnt").val(); 
	var item_type_cnt_N = 0;
	var item_type_cnt_A = 0;
	var item_type_cnt_B = 0;
	var item_type_cnt_C = 0;
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
        alert(" <%=CommonLang.msg("MSG16")%>     ");	//목록에 표시된 상품이 없습니다.
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
        alert(" <%=CommonLang.msg("MSG17")%>   ");	//하나 이상의 상품이 선택되어야 합니다.
        return;
    }else{
		if (tot_cnt < 2) {
			var box = eval("document.forms.contentForm.lnCheck0" ); 
	        if(box.checked == true){
	        	var item_type =document.forms.contentForm.st_item_type_co.value;
	            var buyer_item_no = document.contentForm.temp_item_no.value;
                
	            if(item_type == "N"){
	                item_type_cnt_N++;	            	
	            }else if(item_type == "A"){
	                item_type_cnt_A++;	  
				}else if(item_type == "B"){
	            	item_type_cnt_B++;
	            }else if(item_type == "C"){
	            	item_type_cnt_C++;
	            }
				if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
					 alert( "  <%=CommonLang.msg("MSG519")%>    ");	//단가계약품목과 신규요청품목이 동시에 선택 되었습니다. 신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.
				     return;
				}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
		      		alert( "  <%=CommonLang.msg("MSG520")%>    ");	//일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다. 신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.
		      		return;
		 		}else if((item_type_cnt_A > 0) || (item_type_cnt_N > 0)){
		      		alert( "  <%=CommonLang.msg("MSG521")%>    ");	//단가계약품목이나 일회성_미발주 품목이 선택 되었습니다. 신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.
		      		return;
		 		}

				query = buyer_item_no + "@@" +  item_type+ "@@" +user_id+"@@"+user_name+ "@@"+dept_code  +"@@"+dept_name +"@@"+phone_no +"@@"+mail+"&&";
	        }
		}else{
	        for(var k = 0; k < tot_cnt; k++){
	        	var box = eval("document.forms.contentForm.lnCheck" + k);
	            if(box.checked == true){
	            	var item_type =document.forms.contentForm.st_item_type_co[k].value;
	            	var buyer_item_no = document.contentForm.temp_item_no[k].value;
	                
	                if(item_type == "N"){
	                    item_type_cnt_N++;	            	
	                }else if(item_type == "A"){
	                    item_type_cnt_A++;	  
	    			}else if(item_type == "B"){
	                	item_type_cnt_B++;
	                }else if(item_type == "C"){
	                	item_type_cnt_C++;
	                }
		    		if((item_type_cnt_N > 0) && (item_type_cnt_C > 0)){
		    			 alert( "  <%=CommonLang.msg("MSG519")%>    ");	//단가계약품목과 신규요청품목이 동시에 선택 되었습니다. 신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.
		    		     return;
		    		}else if((item_type_cnt_A > 0) && (item_type_cnt_C > 0)){
		          		alert( "  <%=CommonLang.msg("MSG520")%>    ");	//일회성_미발주품목과 신규요청품목이 동시에 선택 되었습니다. 신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.
		          		return;
		     		}else if((item_type_cnt_A > 0) || (item_type_cnt_N > 0)){
		          		alert( "  <%=CommonLang.msg("MSG521")%>    ");	//단가계약품목이나 일회성_미발주 품목이 선택 되었습니다. 신규견적의뢰는 신규요청품목만 선택하시기 바랍니다.
		          		return;
		     		}

		    		query += buyer_item_no + "@@" +  item_type+ "@@" +user_id+"@@"+user_name+ "@@"+dept_code  +"@@"+dept_name +"@@"+phone_no +"@@"+mail;
		   		 	query += "&&";
	            }
	        }
		}
    }
    var flag = "Q";
	if (confirm("<%=CommonLang.msg("MSG522")%>")==false) return;	//선택된 품목으로 신규견적의뢰 화면으로 이동하시겠습니까? 	
	runProcess(flag+"savePCOProcess",query,flag);
    
}

/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 
 */
function runProcess(gubun,query,flag) {  	
	 
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
           alert("<%=CommonLang.msg("MSG22")%>   ");	//장바구니에 저장되었습니다.
           $('#locationForm2').attr("action", "<%=p060000036%>").submit();    
       }else if(pMethod == "RsaveProcess") {
          alert("<%=CommonLang.msg("MSG23")%>   ");	//나의상품으로 등록 되었습니다.
          $('#locationForm2').attr("action", "/mdcm/getBuyerMdCmMyGoodsSearchList.do").submit();   
       } else if(pMethod == "CsavePCOProcess") {
           alert("<%=CommonLang.msg("MSG22")%>   ");	//장바구니에 저장되었습니다.
           $('#locationForm2').attr("action", "/mdcm/getBuyerMdCmCartPunchOutList.do").submit();    
       }else if(pMethod == "RsavePCOProcess") {
           alert("<%=CommonLang.msg("MSG22")%>   ");	//장바구니에 저장되었습니다.
           $('#locationForm2').attr("action", "/mdcm/getBuyerMdCmMyPunchOutList.do").submit();    
       }else if(pMethod == "QsavePCOProcess") {
    	   $('#locationForm2').attr("action", "/mprq/getBuyerMpRqTempQuotationPCO.do").submit();
       }
      }else{
         if(pMethod == "CsaveProcess"){
            alert("<%=CommonLang.msg("MSG352")%>" + sMsg + ") <%=CommonLang.msg("MSG24")%>  ");	//품목코드 () 은 이미 장바구니에 저장된 항목입니다.
          }else if(pMethod == "RsaveProcess") {
            alert("<%=CommonLang.msg("MSG352")%>" + sMsg + ") <%=CommonLang.msg("MSG25")%>  ");	//품목코드 () 은 이미 나의 상품으로 저장된 항목입니다.
          } else if(pMethod == "CsavePCOProcess") {
        	  alert("<%=CommonLang.msg("MSG352")%>" + sMsg + ") <%=CommonLang.msg("MSG24")%>  ");  //품목코드 () 은 이미 장바구니에 저장된 항목입니다.
          } else if(pMethod == "RsavePCOProcess") {
        	  alert("<%=CommonLang.msg("MSG352")%>" + sMsg + ") <%=CommonLang.msg("MSG24")%>  ");	//품목코드 () 은 이미 장바구니에 저장된 항목입니다.
          }
      }  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "CsaveProcess"||pMethod == "CsavePCOProcess"){ 
		 alert("<%=CommonLang.msg("MSG26")%>  "); //장바구니담기 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
	}else if (pMethod == "RsaveProcess"||pMethod == "RsavePCOProcess"){ 
		 alert("<%=CommonLang.msg("MSG27")%>  "); //나의상품등록 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
	}  else{
		 alert("<%=CommonLang.msg("MSG523")%>  ");	//다시 한 번 시도해 주시기 바랍니다.
	}
	 
	
} 
// 상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageReSizeView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
//MSDS팝업
function getMsdsInfoPop(msds_no){
	openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=N",'750,580,no');
}
// VOC 팝업
function showCommonCoCoVocBuyerReqCreateRegPop(code, text){
	var st_buyer_item_no = "<%=buyer_tem_no%>";
	openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?st_ds_user_id='+$('#emp_user_id').val()+'&st_ds_dept='+$('#emp_dept').val()+'&st_title='+text+'&st_code='+code+'&st_buyer_item_no='+st_buyer_item_no,'800,380,no');    
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
</script> 
</html>
