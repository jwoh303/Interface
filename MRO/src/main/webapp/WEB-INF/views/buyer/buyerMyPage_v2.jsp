<%--
**********************************************
* 메뉴 : 마이페이지
* 화면 : 마이페이지
* 기능 : 마이페이지
* 프로그램 ID : BU0800001
* 담당자 : 최찬규
* 착수일 : 2026-02-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head_v2.jspf"  %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _orderList = (List<Map<String,String>>) request.getAttribute("orderList"); // 조회된 결과
	List<Map<String,String>> _historyGoodsList = (List<Map<String,String>>) request.getAttribute("historyGoodsList"); // 조회된 결과
	List<Map<String,String>> _myGoodsList = (List<Map<String,String>>) request.getAttribute("myGoodsList"); // 조회된 결과
	List<Map<String,String>> _vocList = (List<Map<String,String>>) request.getAttribute("vocList"); // 조회된 결과
	List<Map<String,String>> _orderInfo = (List<Map<String,String>>) request.getAttribute("orderInfo"); // 조회된 결과
	List<Map<String,String>> _vocUser = (List<Map<String,String>>) request.getAttribute("vocUser"); // 조회된 결과 PM
	String _ds_user_id = "";
	String _ds_dept = "";
	if(_vocUser.size()>0 && _vocUser != null){
		_ds_user_id = _vocUser.get(0).get("KEP_USER_ID");
		_ds_dept= _vocUser.get(0).get("DEPARTMENT");
	}
	
	String email = "";
	String tel = "";
	String address = "";
	String user_name = "";
	String com_code = "";
	String chg_info_pwd_yn = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if(sessionInfo != null){
		email = sessionInfo.getEmail();
		tel = sessionInfo.getTel();
		address = sessionInfo.getAddressLoc();
		user_name = sessionInfo.getUserNameLoc();
		com_code = sessionInfo.getComCode();
		chg_info_pwd_yn = CommonUtil.nvl((String)sessionInfo.getChgInfoPwdYn(), ""); // 개인정보 클릭 시 비밀번호 인증 여부
	}
	
	Calendar cal = Calendar.getInstance();
	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH)+1;
	int pre_month = month -1;
	
	String st_cur_month = "";
	String st_pre_month = "";
	String st_cur_year_month = "";
	String st_pre_year_month = "";
	String st_year = ""+year;
	
	if(month <= 9){
		if(month == 1){
			st_cur_month = "0"+month;
			st_pre_month = "12";
			st_cur_year_month = year + st_cur_month;
			st_pre_year_month = (year-1)+st_pre_month;
		}else{
			st_cur_month = "0"+month;
			st_pre_month = "0"+(month-1);
			st_cur_year_month = year + st_cur_month;
			st_pre_year_month = year + st_pre_month;
		}
	}else{
		if(month == 10){
			st_cur_month = ""+month;
			st_pre_month = "09";
			st_cur_year_month = year + st_cur_month;
			st_pre_year_month = year + st_pre_month;
		}else{
			st_cur_month = ""+month;
			st_pre_month = ""+(month-1);
			st_cur_year_month = year + st_cur_month;
			st_pre_year_month = year + st_pre_month;
		}
	}
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	
	//SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
	String p060000036 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000036","COL01_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
%>  
<body onLoad="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerHeader_v2"/>
<c:param name="part" value="buyerHeader_v2"/>
</c:import>   
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<!--서브타이틀-->  
  <div class="SubPageTit">
    <%=CommonLang.get("HTITLE987") %><!-- 마이페이지 --> 
    <div class="SubPageGuide">
      <ul>
        <li><img src="/resources/imgs/Icon_Home.png" /></li>
        <li><%=CommonLang.get("HTITLE987") %><!-- 마이페이지 --> </li>
      </ul>
    </div>   
  </div>
  <div class="container">
	<div class="MYDashboard mt10">
      <div class="MYinfo">
        <div class="MYinfoName"><%=user_name %></div>
        <%
		if("Y".equals(chg_info_pwd_yn)){ //비밀번호 인증 여부
		%>
			<button class="MYPageBtn mt10" onclick="location.href='/main/sub_pw_insert.do'; return false;"><%=CommonLang.get("HTITLE445") %><!-- 개인정보 --></button>
		<%
		}else{
		%>
			<button class="MYPageBtn mt10" onclick="location.href='/mdam/showBuyerMdAmUserInfo.do?menuId=br00701000000'; return false;"><%=CommonLang.get("HTITLE445") %><!-- 개인정보 --></button>
		<%
		}
		%>
        <div class="MYinfoBottom">
	        <div class="MYinfoList"><img src="/resources/imgs/icon_callphone.png" /> <%=tel %></div> 
	        <div class="MYinfoList mt05"><img src="/resources/imgs/icon_email.png" /> <%=email %></div> 
	        <div class="MYinfoList mt05"><img src="/resources/imgs/icon_location.png" /> <%=address %></div> 
        </div>
      </div>
      <div class="MYODinfo">
        <div class="MYODTit"><%=CommonLang.get("HTITLE835") %><!-- 주문정보 --> <button class="MYODView mt15" onclick="location.href='/mpso/showBuyerMpSoOrderProgress.do?menuId=br00201000000'; return false;" ><%=CommonLang.get("HTITLE1097") %><!-- 주문내역 확인 --></button></div>
        <div class="MYODBox mt10">
          <div class="MYODList"><p><%=year %><%=CommonLang.get("HTITLE1072")%><!--년 주문--></p> <p><%=CommonUtil.formatNumber(_orderInfo.get(0).get("YEAR_CNT"),true,0,3) %><%=CommonLang.get("HTITLE595") %><!-- 건 --></p> <p><%=CommonUtil.formatNumber(_orderInfo.get(0).get("YEAR_AMT"),true,0,3) %><%=CommonLang.get("HTITLE660") %><!-- 원 --></p></div>
          <div class="MYODList"><p><%=pre_month %><%=CommonLang.get("HTITLE1073")%><!--월 주문--></p> <p><%=CommonUtil.formatNumber(_orderInfo.get(0).get("PRE_MONTH_CNT"),true,0,3) %><%=CommonLang.get("HTITLE595") %><!-- 건 --></p> <p><%=CommonUtil.formatNumber(_orderInfo.get(0).get("PRE_MONTH_AMT"),true,0,3) %><%=CommonLang.get("HTITLE660") %><!-- 원 --></p></div>
          <div class="MYODList"><p><%=month %><%=CommonLang.get("HTITLE1073")%><!--월 주문--></p> <p><%=CommonUtil.formatNumber(_orderInfo.get(0).get("CUR_MONTH_CNT"),true,0,3) %><%=CommonLang.get("HTITLE595") %><!-- 건 --></p> <p><%=CommonUtil.formatNumber(_orderInfo.get(0).get("CUR_MONTH_AMT"),true,0,3) %><%=CommonLang.get("HTITLE660") %><!-- 원 --></p></div>
        </div>
      </div>
	</div><!-- MYDashboard 끝 -->
	<div class="MYPD mt30">
	  <div class="MYPDBox" style="height: 950px;">
        <div class="MYPDListTit"><%=CommonLang.get("HTITLE1016") %> <!-- 관심상품 --> <button class="MYPageBtn" onclick="location.href='/mdcm/getBuyerMdCmMyGoodsSearchList.do'; return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button></div>
		<%if(_myGoodsList == null || _myGoodsList.size() == 0){%>
			<div class="MYNOdate mt20 mb50">
	          <p class="mt40" style="margin-top: 440px !important;"><img src="/resources/imgs/Icon_Warning01.png" /></p>
	          <p class="mt20"><%=CommonLang.msg("MSG615") %><!-- 관심상품이 없습니다. --></p>
			</div>	
		<%}else{%>
			<%for(int i = 0; i<_myGoodsList.size(); i++){ 
				if(i==5)
					break;
	          		Map<String,String> rowData = _myGoodsList.get(i);
	          	%>
	          	<table class="MYPDList mt20">
	            <input type="hidden" name="st_item_no" id="st_item_no_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
	            <input type="hidden" name="st_contract_no" id="st_contract_no_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
	            <input type="hidden" name="st_contract_seq" id="st_contract_seq_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
	            <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
	            <input type="hidden" name="st_product_close_flag" id="st_product_close_flag_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>">
	            <input type="hidden" name="st_agent" id="st_agent_my<%=i %>" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
	              <tr>
					<td><div class="MYPDListName mt20"><a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEG_ID"))%>', '','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>');"><div class="Code"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></div><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></div></a>
		              <dl class="MYPDListDetail mt10">
		                <dt><%=CommonLang.get("HTITLE14") %><!-- 규격 --></dt><dd><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></dd><br/>
		                <dt><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></dt><dd><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%> / <%=CommonUtil.nvl(rowData.get("ORIGIN_TEXT"))%></dd><br/>
		                <dt><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></dt><dd><%=CommonUtil.nvl(rowData.get("AGENT_NAME"))%></dd><br/>
		                <dt><%=CommonLang.get("HTITLE52") %><!-- 단위 --></dt><dd><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></dd>
					   </dl>             
					</td>
					<td><div class="MYPDPrice mt05 mb15"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3) %><%=CommonLang.get("HTITLE660") %><!-- 원 --></div>
			  		  <button onclick="javascript:doAction('my_cartItem','<%=i%>'); return false;" class="ButCart40"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
					</td>
				  </tr>
				</table>
	            <%} %>
		<%} %>
	  </div>
      <div class="MYPDBox"  style="height: 950px;">
        <div class="MYPDListTit"><%=CommonLang.get("HTITLE1015") %><!-- 자주 구매하는 상품 --> <%=CommonLang.get("HTITLE1095") %><!-- (최근 3개월 기준) --><button class="MYPageBtn" onclick="location.href='/mdcm/getBuyerMdCmHistoryGoodsSearchList.do'; return false;" ><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button></div>
        <%if(_historyGoodsList == null || _historyGoodsList.size() == 0){%>
        	<div class="MYNOdate mt20 mb50">
	          <p class="mt40" style="margin-top: 440px !important;"><img src="/resources/imgs/Icon_Warning01.png" /></p>
	          <p class="mt20"><%=CommonLang.msg("MSG614") %><!-- 자주 구매하는 상품이 없습니다. --></p>
			</div>
		<%}else{%>
			<%for(int i = 0; i<_historyGoodsList.size(); i++){
				if(i==5)
					break;
          		Map<String,String> rowData = _historyGoodsList.get(i);
          	%>
        <table class="MYPDList mt20">
            <input type="hidden" name="st_item_no" id="st_item_no<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
            <input type="hidden" name="st_contract_no" id="st_contract_no<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
            <input type="hidden" name="st_contract_seq" id="st_contract_seq<%=i %>" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
            <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code<%=i %>" value="<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>">
            <input type="hidden" name="st_agent" id="st_agent<%=i %>" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
              
          <tr>
			<td><div class="MYPDListName mt20"><div class="BuyNum"><%=CommonUtil.bnvl(rowData.get("PR_SEQ"))%><%=CommonLang.get("HTITLE1027") %><!-- 회 구매 --></div><a href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("STDCATEG_ID"))%>','<%=CommonUtil.nvl(rowData.get("STDCATLG_ID"))%>','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CATEG_ID"))%>', '','ITEM','<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>', '<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>', '<%=CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG"))%>','<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>');"><div class="Code"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></div><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></div></a>
              <dl class="MYPDListDetail mt10">
                <dt><%=CommonLang.get("HTITLE14") %><!-- 규격 --></dt><dd><%=CommonUtil.bnvl(rowData.get("SPECIFICATION"))%></dd><br/>
                <dt><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></dt><dd><%=CommonUtil.bnvl(rowData.get("MAKER_NAME"))%> / <%=CommonUtil.nvl(rowData.get("ORIGIN_TEXT"))%></dd><br/>
                <dt><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></dt><dd><%=CommonUtil.bnvl(rowData.get("AGENT_NAME"))%></dd><br/>
                <dt><%=CommonLang.get("HTITLE52") %><!-- 단위 --></dt><dd><%=CommonUtil.bnvl(rowData.get("UNIT_MEASURE"))%></dd>
			   </dl>             
             </td>
			<td><div class="MYPDPrice mt05 mb15"><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3) %><%=CommonLang.get("HTITLE660") %><!-- 원 --></div>
			  <button onclick="javascript:doAction('cartItem','<%=i%>'); return false;" class="ButCart40"><%=CommonLang.get("HTITLE161") %><!-- 장바구니 --></button>
			</td>
		  </tr>
		</table>
            <%} %>
		<%} %>
	  </div>
	</div><!-- MYPD mt30 끝 -->
	<div class="MYInquiry mt10 mb30" >
		<div class="MYInquiryTit mb20"><%=CommonLang.get("HTITLE1070")%><!--나의문의--> <button class="MYPageBtn" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=1&menuId=br00601000000'; return false;"><%=CommonLang.get("HTITLE1013") %><!-- 전체보기 --></button></div>
        <div class="MYChat-container" >
        <%if(_vocList == null || _vocList.size() == 0){%>
        	<div class="MYNOdate mb50">
	          <p class="mt35"><img src="/resources/imgs/Icon_Warning01.png" /></p>
	          <p class="mt20"><%=CommonLang.msg("MSG636")%><!--등록하신 문의내역이 없습니다.--></p>
	          <p class="mt05"><%=CommonLang.msg("MSG637")%><!--궁금한 사항은 문의해보세요.--></p>
	          <button class="ButOutline_Small mt30" onclick="javascript:showCommonCoCoVocBuyerReqCreateRegPop('<%=_ds_user_id %>','<%=_ds_dept %>'); return false;" ><%=CommonLang.get("HTITLE1071")%><!--문의하기--></button>
        	</div>
        <%}else{ %>
        	<%for(int i = 0; i<_vocList.size(); i++){
				if(i==4)
					break;
          		Map<String,String> rowData = _vocList.get(i);
        	%>
        	<div class="MYChat-item">
              <button class="MYChat-question">
                <table width="100%">
                  <tr>
                    <th width="100px">
                    <%if(CommonUtil.bnvl(rowData.get("RECV_FLAG")).equals("FB")){ %>
                    	<span class=" " style="color:#2172ec"><%=CommonLang.get("HTITLE1099")%><!--답변완료--></span>
                    <%}else{ %>
                    	<span><%=CommonLang.get("HTITLE1100")%><!--답변대기--></span>
                    <%} %>
                    </th>
                    <td width="80px"><%=CommonUtil.bnvl(rowData.get("CLAIM_TEXT"))%></td>
                    <td width="*" ><%=CommonUtil.bnvl(rowData.get("REQ_REMARK_SUB"))%></td>
                    <td width="100px"><%=CommonUtil.bnvl(rowData.get("REQ_DATE"))%></td>
                  </tr>
                </table>
                <span class="MYChatarrow"><img src="/resources/imgs/arrow_down.png" /></span>
              </button>
              <div class="MYChat-answer">
                <table width="100%" >
                  <tr>
                    <td width="180px"></td>
                    <td width="*">
                    <%=CommonLang.get("HTITLE12") %><!-- 품목코드 --> <%=CommonUtil.bnvl(rowData.get("BUYER_ITEM_NO"))%>
                    </br>
                    <%=CommonUtil.bnvl(rowData.get("REQ_REMARK"))%>
                    </td>
                  </tr>
                  <tr>
                    <td></td>
                    <%if(CommonUtil.bnvl(rowData.get("RECV_FLAG")).equals("FB")){ %>
                    <td style="padding-right:80px">
                      <table width="100%" class="Kepanswer" >
                        <tr>
                          <td width="50px" ><span class="ChipsRound_Blue"><%=CommonLang.get("HTITLE1101")%><!--답변--></span></td>
                          <td width="*"> 
                           <%=CommonUtil.bnvl(rowData.get("DF_REMARK"))%>
                           </td>
                           <td width="100px" style="text-align:right" ><%=CommonUtil.bnvl(rowData.get("DF_DATE"))%></td>
                        </tr>
                        <tr>
                          <td></td>
                          <td colspan="2" class="NewMYChat" ><%=CommonLang.msg("MSG655")%><!--문의에 대한 답변이 부족하거나 추가문의사항이 있으시면 새로운 문의사항으로 등록해주세요--> <button class="ButMSmallDarkGray" onclick="javascript:showCommonCoCoVocBuyerReqCreateRegPop('<%=CommonUtil.nvl(rowData.get("DS_USER_ID"))%>','<%=CommonUtil.nvl(rowData.get("DS_DEPT"))%>'); return false;"><%=CommonLang.get("HTITLE1102")%><!--새로운 문의하기--></button> </td>
                          
                      </table>                     
                    </td>
                    <%}else{ %>
                    <td valign="bottom"><button class="ChipsDefault_Gray" style="cursor:pointer" onclick="javascript:vocCancel('<%=CommonUtil.nvl(rowData.get("VC_NO"))%>','<%=CommonUtil.nvl(rowData.get("REQ_USER_ID"))%>'); return false;"><%=CommonLang.get("HTITLE1103")%><!--문의취소하기--></button> </td>
                    <%} %>
                    
                  </tr>                                                     
                </table>  
               </div>
            </div>
            <%} %>
        <%} %>
            
        </div>
        <script>
          const ChatItems = document.querySelectorAll(".MYChat-item");
          ChatItems.forEach(function(item){
            const question = item.querySelector(".MYChat-question");
            const answer = item.querySelector(".MYChat-answer");
        
            question.addEventListener("click", function(){
              if (item.classList.contains("active")) {
                // 닫기
                answer.style.maxHeight = null;
                item.classList.remove("active");
              } else {
                // 열기
                answer.style.maxHeight = answer.scrollHeight + "px";
                item.classList.add("active");
              }
            });
          });
        </script>        
	</div><!-- MYInquiry mt30 끝 -->
         
  </div><!-- container 끝 -->
<form id="searchCondition" name="searchCondition" method="post">
	<input type="hidden" id="BUYER"  name="BUYER" value="${sessionInfo.comCode}">
	<input type="hidden" id="USERID"  name="USERID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_year"  name="st_year" value="<%=st_year%>">
	<input type="hidden" id="st_cur_year_month"  name="st_cur_year_month" value="<%=st_cur_year_month%>">
	<input type="hidden" id="st_pre_year_month"  name="st_pre_year_month" value="<%=st_pre_year_month%>">
</form>
<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" name="stdcateg_id" id="stdcateg_id" value="" />
	<input type="hidden" name="stdcatlg_id" id="stdcatlg_id" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="com_code" id="com_code" value="" />
	<input type="hidden" name="buyer_tem_no" id="buyer_tem_no" value="" />
	<input type="hidden" name="category_no" id="category_no" value="" />
	<input type="hidden" name="key_flag" id="key_flag" value="" />
	<input type="hidden" name="cata" id="cata" value="" />
</form>
<form name="processForm" id="processForm" method="post">
	<input type="hidden" name="st_query2" id="st_query2" value="" /> 
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="" />
	<input type="hidden" name="st_user_id" id="st_user_id" value="" />
	<input type="hidden" name="st_vc_no" id="st_vc_no" value="" />
</form>
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>   
</div>
</body>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
}

var st;
//기능함수
function doAction(str,index) {
	switch (str) {
	case "cartItem": // 최근구매상품 내 > 장바구니 담기
		saveProcess("C",index,"");
		break;
	case "my_cartItem": // 관심상품 내 > 장바구니 담기
		saveProcess("C",index,"_my");
		break;
	}
}

function vocCancel(vc_no,user_id){
	$("#st_vc_no").val(vc_no);
	$("#st_user_id").val(user_id);
	kepAjaxFormCall("/main/vocCancel_v2.do","processForm","vocCancel");
}
function saveProcess(flag,index,gubun){    
    var query   = "";
    
    var order_qty     = 1;
    var st_item_no   = $("#st_item_no"+gubun+index).val();
	var st_order_qty = 1;
	var st_agent     = $("#st_agent"+gubun+index).val();
	var st_contract_no  = $("#st_contract_no"+gubun+index).val();
	var st_contract_seq = $("#st_contract_seq"+gubun+index).val();
	var st_byit_comorg_code = $("#st_byit_comorg_code"+gubun+index).val();
	//단종여부 
	var st_product_close_flag = $("#st_product_close_flag"+gubun+index).val();
    if(st_contract_no == null || st_contract_no ==""|| st_contract_no =="PC"){
    	//계약정보 없는 품목은 등록이 불가능 합니다.
		var text = "<%=CommonLang.msg("MSG344") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
    	return;
    }
    //단종이고 단종일때 단가 비노출이면 처리 불가능.
    if(st_product_close_flag=="Y" && g_product_close_flag=="Y"){
    	//해당 품목은 단종되었습니다.
		var text = "<%=CommonLang.msg("MSG117") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
    	return;
    }else{
		query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + st_contract_no  + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "&&";
		document.forms["processForm"].st_query2.value = query;
		document.forms["processForm"].st_use_flag.value = flag;
		document.forms["processForm"].st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
		
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","CsaveProcess");
    }
}
function goCart(){
	closePopText1();
	location.href = "<%=p060000036%>";
}

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

function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	
    if(sMsg == "CREATE_OK"){
        if(pMethod == "CsaveProcess")
        {
        	var text = "<%=CommonLang.msg("MSG557")%>";//장바구니에 저장하였습니다. 장바구니 화면으로 이동하시겠습니까?
        	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
        	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
        	var but1funcC = "javascript:goCart(); return false;";
        	var but2funcC = "javascript:closePopText1(); return false;";
        	var but1widthC = "100px";
        	var but2widthC = "100px";
        	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
        	
       }else if(pMethod == "vocCancel"){
    	   //문의가 취소되었습니다.
    	   var text = "<%=CommonLang.msg("MSG690")%>";
   		openLayerPopText2(text,but1text,but1funcSearch,but1width);
       }
      }else{
    	  
         if(pMethod == "CsaveProcess")
          {
        	 //품목코드 () 은 이미 장바구니에 저장된 항목입니다.
<%--             alert("<%=CommonLang.msg("MSG352") %>" + sMsg + "<%=CommonLang.msg("MSG353") %>  "); --%>
            var text = "<%=CommonLang.msg("MSG352") %>" + sMsg + "<%=CommonLang.msg("MSG353") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
          }else if(pMethod == "vocCancel"){
       	   //장바구니담기 실패하였습니다.다시 한 번 시도해 주시기 바랍니다.
       	   var text = "<%=CommonLang.msg("MSG691")%>";
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
		var text = "<%=CommonLang.msg("MSG26") %>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	 
	
} 
function showCommonCoCoVocBuyerReqCreateRegPop(st_user_id,st_dept){
	if(st_user_id == ""){
		var text = "담당자가 배정되어있지 않습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?st_ds_user_id='+st_user_id+'&st_ds_dept='+st_dept,'560,540,no');
}
function thisPopClose(){
	closePopText2();
	location.reload();
}
</script>
</html>
