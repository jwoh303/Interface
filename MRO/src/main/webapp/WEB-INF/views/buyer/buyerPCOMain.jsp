<%@page import="com.diquest.ir.util.common.DateUtil"%>
<%@page import="com.ctc.wstx.util.DataUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head.jspf"  %>
</head>
<% 
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _buyerBoard = (List<Map<String,String>>) request.getAttribute("buyerBoard"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _ntBoard = (List<Map<String,String>>) request.getAttribute("ntBoard"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _vocUser = (List<Map<String,String>>) request.getAttribute("vocUser"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _statusCount = (List<Map<String,String>>) request.getAttribute("statusCount"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _companyPass = (List<Map<String,String>>) request.getAttribute("companyPass"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _manualInfo = (List<Map<String,String>>) request.getAttribute("manualInfo"); // 조회된 결과
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _shotcutSsso = (List<Map<String,String>>) request.getAttribute("shotcutSsso"); // 조회된 결과
	
	String currentDate = DateTimeUtil.getFormatString("yyyyMMdd");
	String currentYear = currentDate.substring(0,4);
	String currentMonth = currentDate.substring(4,6);
	String currentDay = currentDate.substring(6,8);
	String check_date					= currentDate;
 
	Map<String,String> _statusCountData = null;
	if (_statusCount == null || _statusCount.size() == 0){
	}else{
		_statusCountData = _statusCount.get(0);
	}
	
	Map<String,String> _companyPassData = null;
	String PASS_FLAG = "";
	if (_companyPass == null || _companyPass.size() == 0){
	}else{
		_companyPassData = _companyPass.get(0);
		PASS_FLAG = _companyPassData.get("PASS_FLAG"); 
	}
	
	Map<String,String> _manualInfoData = null;
	String MANUAL_FLAG = "";
	if (_manualInfo == null || _manualInfo.size() == 0){
	}else{
		_manualInfoData = _manualInfo.get(0);
		MANUAL_FLAG = _manualInfoData.get("MANUAL_FLAG"); 
	}
	
	String SSO_COM_CODE = "";
	String SSO_USER_ID = "";
	String SSO_PASSWORD = "";
	Map<String,String> _shotcutSssoData = null;
	if (_shotcutSsso == null || _shotcutSsso.size() == 0){
	}else{
		/*
		_shotcutSssoData = _shotcutSsso.get(0); 
		SSO_COM_CODE = _shotcutSssoData.get("COM_CODE"); 
		SSO_USER_ID = _shotcutSssoData.get("USER_ID"); 
		SSO_PASSWORD = _shotcutSssoData.get("PASSWORD"); 
		
		request.getSession().setAttribute("session_SSO_COM_CODE", SSO_COM_CODE); 
		request.getSession().setAttribute("session_SSO_USER_ID", SSO_USER_ID); 
		request.getSession().setAttribute("session_SSO_PASSWORD", SSO_PASSWORD); 
		*/
	}
	
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String sessionUserName = "";
	String sessionComCode = "";
	String sessionBycaComorgCode = "";
	String sessionUserId = "";
	if (sessionInfo != null){ 
		sessionUserName =  CommonUtil.nvl((String)sessionInfo.getComNameLoc());  
		sessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId());  
		sessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());  
		sessionBycaComorgCode =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());  
	}  
	
	 //SLOGIC-BEGIN(P06-0000036)
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do?upperId=b00000000000&leftMenu=N";
	String p060000036 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000036","COL01_DATA"); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	}
	//SLOGIC-END
	
	boolean cowayFlag = false;
	//SLOGIC-BEGIN(P06-0000036) 
    //코웨이일경우
    String p060000036_COWAY = CommonUtil.getSpecialCheckReturn(sessionComCode,"P06-0000036","COL03_DATA"); // 권한특수로직
    if ("COWAY".equals(p060000036_COWAY)){
    	cowayFlag = true;
    	request.getSession().setAttribute("SESSION_COWAY_FLAG","Y"); // 코웨이구분
    }
    //SLOGIC-END 
%>  
<body onload="kep_onload_view();">

<script type="text/javascript">

 
//최초 화면 함수 
function kep_onload_view(){  
	//alert($('#main_cart_cnt').val());
	$('#top_cart_cnt').html($('#main_cart_cnt').val());
}


function chsngeEmp(){
	
	var value = kepSelectOptionVal("st_emp"); 
	var tmpArrp = value.split("@@");
    //document.forms[0].emp_image.src = "/attfiles/EMPLOYEE_IMAGE/"+tmpArrp[1]+".jpg";
    //alert(tmpArrp[1]);
//     document.getElementById("emp_img").src = "/attfiles/EMPLOYEE_IMAGE/"+tmpArrp[1]+".jpg";
    document.getElementById("emp_img").src = "/item_image/ITEM_IMAGE/EMPLOYEE_IMAGE/"+tmpArrp[1]+".jpg";
    document.getElementById("emp_pos").innerText = tmpArrp[3] ;
    document.getElementById("emp_name").innerText = tmpArrp[2] + tmpArrp[3] ;
    document.getElementById("emp_tel").innerText = tmpArrp[5] ;
    document.getElementById("emp_mobile").innerText = tmpArrp[6] ;
    document.getElementById("emp_email").href = "mailto:"+tmpArrp[4];
    document.getElementById("emp_email").innerText = tmpArrp[4] ;
    document.getElementById("emp_user_id").vlaue  = tmpArrp[1] ;
    document.getElementById("emp_dept").vlaue       = tmpArrp[7] ;
    
}

function showCommonCoCoVocBuyerReqCreateRegPop(){	
	openSearchPopup('/coco/showCommonCoCoVocBuyerReqCreateRegPop.do','?st_ds_user_id='+$('#emp_user_id').val()+'&st_ds_dept='+$('#emp_dept').val(),'800,380,no');    
}
function showDetailPop(value1,value2){	
	openSearchPopup("/none/showSellerNoNeNoticeDetailPop.do", "?st_btype="+value1+"&st_bid="+value2, "800,600,no");    
}
function showNoticeListPop(){
	openSearchPopup('/none/showSellerNoNeNoticeListPop.do','?st_company=<%=sessionComCode%>','700,455,no');
}
function showSearchDetailPop(){
	openSearchPopup('/coco/showCommonCoCoCateSearchDetailPop.do','','600,180,no');
}
function getGreenBuyPopup(){
	openSearchPopup('/buyer/showBuyerGreenBuy.do','','955,685,no');
}
function setDetailSearch(st_description , st_specification , st_maker , st_categoty_name){ 
	
	document.forms.searchDiDetailForm.st_description.value = st_description;  
	document.forms.searchDiDetailForm.st_specification.value = st_specification;
	document.forms.searchDiDetailForm.st_maker.value = st_maker;
	document.forms.searchDiDetailForm.st_categoty_name.value = st_categoty_name;
	
	document.searchDiDetailForm.searchTargetIDX_CATEGORY_NO.value = "";	 
	document.searchDiDetailForm.onepagerow.value = "10";
	document.searchDiDetailForm.curPage.value = "1";
	document.searchDiDetailForm.st_image_status.value = "";
	document.searchDiDetailForm.groupCategoryText.value = "";
	document.searchDiDetailForm.groupMakerName.value = "";
	document.searchDiDetailForm.searchSort.value = "";
	document.searchDiDetailForm.st_sort_change.value = "";	 
	document.searchDiDetailForm.upperId.value = "b00100000000";
	document.searchDiDetailForm.action = "/mdcm/getBuyerMdCmPCODiLisList.do";
	document.searchDiDetailForm.submit();
	
}

function manualDown(type){ 
	if(type=="A"){location.href="/resources/excel/company/PUNCHOUT/ERP_Manual.ppt";} //ERP메뉴얼
	else if(type=="B"){location.href="/resources/excel/company/PUNCHOUT/IP_Manual.zip";} //IP메뉴얼
	else if(type=="C"){location.href="/resources/excel/company/PUNCHOUT/2014_IP.zip";} //단가재계약
    
} 

function kepEditForm(bid,btype){ 
	
	document.forms.searchCondition.BID.value = bid;
	document.forms.searchCondition.BTYPE.value = btype;
	$('#searchCondition').attr("action", "/mdam/getBuyerMdAmNoticeManageDetail.do").submit();    
} 
		
//쿠키정보가져오기
function getCookie(name) {
	var nameOfCookie = name + "=";
	var x = 0

	while ( x <= document.cookie.length ) {
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie ) {
			if ( (endOfCookie=document.cookie.indexOf( ";",y )) == -1 )
				endOfCookie = document.cookie.length;
				return unescape( document.cookie.substring(y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
		break;
	}
	return "";
}  
			
</script>

<div id="wrapper">
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="mainBuyerLeft"/>
<c:param name="part" value="b00000000000"/>
</c:import>
</div>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
     <div id="container">
  
    	<div id="centerCont">
        	
        	<div class="loginInfo" >
            	<span class="infoName">[ ${sessionInfo.comNameLoc} ] ${sessionInfo.userNameLoc} 님</span> <br/>
                코리아e플랫폼 사이트를 방문해 주셔서 감사합니다. <br/>

                 <div class="searchList">
                    <a href="/mdcm/showBuyerMdCmCategoryPCOSearch.do?upperId=b00100000000"><span class="searchListFirst"><img src="/resources/images/searchList_01.gif" /><br/>카테고리상품</span></a>
                    <a href="/mdcm/getBuyerMdCmHistoryGoodsSearchList.do?upperId=b00100000000"><span class="searchListLast"><img src="/resources/images/searchList_02.gif" /><br/>이력상품</span></a>
                    <a href="/mdcm/getBuyerMdCmMyPunchOutList.do?upperId=b00100000000"><span class="searchListLast"><img src="/resources/images/searchList_03.gif" /><br/>나의등록상품</span></a>
                    <a href="javascript:showSearchDetailPop()"><span class="searchListLast"><img src="/resources/images/searchList_04.gif" /><br/>상세검색</span></a>
        		</div>
            </div>
            
        </div>
        
     	<div id="centerCont2">
        	<!--고객서비스-->
            <div id="cusServiceArea">
                <p class="cusServiceTit"><img src="/resources/images/b_custservice_icon.gif" alt="사진이미지" /> &nbsp;&nbsp;Customer Service</p>
                
                <select name="st_emp"  id="st_emp" class="site" onchange="chsngeEmp()">
                    <% 
                	Map<String,String> _vocUserData = null;
                	Map<String,String> _vocUserData2 = null;
                	if (_vocUser == null || _vocUser.size() == 0){
                	}else{
                		for (int i=0; i<_vocUser.size(); i++){
                			_vocUserData2 = _vocUser.get(0);  
                		_vocUserData = _vocUser.get(i);  
                    %>
                        <option value="<%=CommonUtil.nvl(_vocUserData.get("BUYER"))%>@@<%=CommonUtil.nvl(_vocUserData.get("USER_ID"))%>@@<%=CommonUtil.nvl(_vocUserData.get("USER_NAME_LOC"))%>@@<%=CommonUtil.nvl(_vocUserData.get("POSITION_NAME"))%>@@<%=CommonUtil.nvl(_vocUserData.get("EMAIL"))%>@@<%=CommonUtil.nvl(_vocUserData.get("PHONE_NUMBER"))%>@@<%=CommonUtil.nvl(_vocUserData.get("MOBILE_PHONE"))%>@@<%=CommonUtil.nvl(_vocUserData.get("DEPARTMENT"))%>"><%=CommonUtil.nvl(_vocUserData.get("USER_NAME_LOC"))%></option> 
                    <% }
                    }
                    %>
                </select>
                  <% if (_vocUserData2 != null){ %>
                  <p class="image"><img src="/item_image/ITEM_IMAGE/EMPLOYEE_IMAGE/<%=CommonUtil.nvl(_vocUserData2.get("USER_ID"))%>.jpg" alt="사진이미지"   id="emp_img" onerror="javasrcipt:this.src='/resources/images/cusService.gif'"  width="90" height="120" /></p>
                <p class="cusServicename" id="emp_name"><%=CommonUtil.nvl(_vocUserData2.get("USER_NAME_LOC"))%><%=CommonUtil.nvl(_vocUserData2.get("POSITION_NAME"))%></p>
                <ul class="cusServiceList">
                    <li>이메일 : <span class="text02" id="emp_email"><%=CommonUtil.nvl(_vocUserData2.get("EMAIL"))%></span></li>
                    <li>전  화 : <span class="text02" id="emp_tel"><%=CommonUtil.nvl(_vocUserData2.get("PHONE_NUMBER"))%></span></li>
                    <li>모바일 : <span class="text02" id="emp_mobile"><%=CommonUtil.nvl(_vocUserData2.get("MOBILE_PHONE"))%></span></li>
                </ul>
                        <input type="hidden" name="emp_pos"  id="emp_pos"  value="<%=CommonUtil.nvl(_vocUserData2.get("POSITION_NAME"))%>"/>
                        <input type="hidden" name="emp_user_id"  id="emp_user_id"  value="<%=CommonUtil.nvl(_vocUserData2.get("USER_ID"))%>"/>
                        <input type="hidden" name="emp_dept"  id="emp_dept"  value="<%=CommonUtil.nvl(_vocUserData2.get("DEPARTMENT"))%>"/>
                <p class="cusServiceBtn"><a href="javascript:showCommonCoCoVocBuyerReqCreateRegPop()"><img src="/resources/images/b_btn_request.gif" alt="요청" /></a> 
                <a href="/main/getCustomerCenterList.do?upperId=b00000000000"><img src="/resources/images/b_btn_result.gif" alt="처리결과보기" /></a></p>
                <%} %>
            </div>
            <!--거래정보-->
            <div id="mInfoArea" >
                <p class="mInfoTit"><img src="/resources/images/b_mInfo.gif" alt="사진이미지" /> &nbsp;&nbsp;거래정보 <span  class="mInfodate">［&nbsp;&nbsp;<%=CommonUtil.formatDateKor(new Date() ) %>&nbsp;&nbsp; ］</span></p>
                <!--    <p class="mInfoTime">최근 일주일 이내</p>-->
                <div class="mInfo">
                    <p class="mInfo01">장바구니</br><a href="/mdcm/getBuyerMdCmCartPunchOutList.do?upperId=b00100000000"><span class="mInfo01Value"><%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%></span></a></p>
                    <p class="mInfo02">주문진행</br><a href="/mpso/getBuyerMpSoOrderProgressList.do?upperId=b00100000000"><span class="mInfo02Value"><%=CommonUtil.bnvl(_statusCountData.get("PR_CNT"))%></span></a></p>
            		<p class="mInfo03">납기도래</br><a href="/mpso/showBuyerMpSoDeliveryCommingPunchOutSearch.do?upperId=b00100000000"><span class="mInfo03Value"><%=CommonUtil.bnvl(_statusCountData.get("IV_CNT"))%></span></a></p>
            		<p class="mInfo04">입고대상</br><a href="/wmgr/getBuyerWmGrWarehousingReg.do?upperId=b00100000000"><span class="mInfo04Value"><%=CommonUtil.bnvl(_statusCountData.get("GR_CNT"))%></span></a></p>
                    <p class="mInfo05">신규견적요청</br><a href="/mprq/showBuyerMpRqQuotaProceStateList.do?upperId=b00100000000"><span class="mInfo05Value"><%=CommonUtil.bnvl(_statusCountData.get("SOUR_CNT"))%></span></a></p>
                    <input type="hidden" name="main_cart_cnt" id="main_cart_cnt" value="<%=CommonUtil.bnvl(_statusCountData.get("CART_CNT"))%>">
                   <%
   					request.getSession().setAttribute("session_CART_CNT", CommonUtil.bnvl(_statusCountData.get("CART_CNT")));
   					%> 
                </div>
            </div>
        </div>
        
        <div id="centerCont3">
        
            <!--kep 공지사항-->
            <div id="kepNotice">
            	<p class="kepNoticeTit">KeP 공지사항<a href="javascript:showNoticeListPop()"> <img src="/resources/images/b_btn_more.gif" alt="더보기" /></a></p>
                <ul>
                                        <% 
                	Map<String,String> _ntBoardData = null;
                	if (_ntBoard == null || _ntBoard.size() == 0){
                	}else{
                		for (int i=0; i<_ntBoard.size(); i++){
                			_ntBoardData = _ntBoard.get(i);  
                    %>
                            <li><a href="javascript:showDetailPop('NT','<%=CommonUtil.bnvl(_ntBoardData.get("BID"))%>');"><span class="title"><%=CommonUtil.textMore(CommonUtil.nvl(_ntBoardData.get("SUBJECT")),20)%></span></a> <span class="date"><%=CommonUtil.nvl(_ntBoardData.get("REG_DATE"))%></span></li>
                                                <% }
                    }
                    %> 
                </ul>
            </div>
            
            <div id="kepBanner"  style="position:relative;">
				<table  class="ManualDown">
                	<colgroup>
                        <col width="50%" />
                        <col width="50%" />
					</colgroup>
                    <tr>
                    	<th class="ManualDowntit"  colspan="2">매뉴얼 다운로드 <img src="/resources/images/b_Manual.gif"/></th>
                    </tr>
                    <tr>
                        <td height="129px"><a href="javascript:manualDown('A')"><img src="/resources/images/b_Manual06.gif" /><br>ERP 메뉴얼</a></td>
                        <td><a href="javascript:manualDown('B')"><img src="/resources/images/b_Manual07.gif" /> <br>IP 메뉴얼</a></td>
                    </tr>
                </table>                
                
                <div class="bannerBox">
                     <p class="bannerBoxtit"> 단가계약 리스트<span class="brimg"><img src="/resources/images/b_price.gif" /></span>
                     <p class="bannerBoxtxt"><span class="bannerBoxtxt01">2014년~2015년</span></br>
                     Koreab2b.com이 제공하는 </br>
                     2014 ~5년 단가계약리스트입니다.</br></br>
                     <a href="javascript:manualDown('C')"><img src="/resources/images/b_bannerLink.gif" alt="더보기" /></a> </p>
                   
                </div>
                <div class="bannerBox">
                     <p class="bannerBoxtit"> 녹색구매 친환경상품<span class="brimg"><img src="/resources/images/b_green.gif"  /></span>
                     <p class="bannerBoxtxt"><span class="bannerBoxtxt01">녹색구매 친환경상품</span></br>
                     환경마트인증제품, 우수재활용 </br>
                     마크제품, 에너지절약마크인</br>
                     증제품, 유해물질 저감물품,</br>
                     폐기물저감물품, 기타</br>
                       <a href="javascript:getGreenBuyPopup();" > <img src="/resources/images/b_bannerLink.gif" alt="더보기" /></a> </p>
                </div>
            </div>
        
        </div>
    </div>
<form name="searchCondition" id="searchCondition" method="post">
		<input type="hidden" id="st_user_id" name="st_user_id"  value="<%=sessionUserId%>">
			<input type="hidden" id="st_byca_comorg_code" name="st_byca_comorg_code"  value="<%=sessionBycaComorgCode%>">
			<input type="hidden" name="curPage" id="curPage" value="1" />
			<input type="hidden" id="upperId"  name="upperId" value="b00000000000">   
			<input type="hidden" name="BID" id="BID" value="" />
			<input type="hidden" name="BTYPE" id="BTYPE" value="" />  
</form> 
 
<form name="searchDiDetailForm"  id="searchDiDetailForm"method="post">
       <input type="hidden" name="onepagerow" value="" /> 
       <input type="hidden" name="curPage" value="" /> 
       <input type="hidden" name="st_image_status" value="" /> 
       <input type="hidden" name="st_sort_change" value="" /> 
<input type="hidden" name="upperId" id="upperId"  value="b00100000000" /> 
<input type="hidden" name="groupCategoryText" id="groupCategoryText" />
<input type="hidden" name="groupMakerName" id="groupMakerName" />
<input type="hidden" name="searchSort" id="searchSort"  /> 
<input type="hidden" name="searchTarget" id="searchTarget"  value="ALL" />  
<input type="hidden"  name="searchTargetIDX_CATEGORY_NO"  id="searchTargetIDX_CATEGORY_NO"  value=""   /> <!--   IDX_CATEGORY_NO  로 바뀌면, 카테고리번호에 해당하는 정보만 가져올 수 있을 듯 합니다. -->
<input type="hidden"  name="searchTerm"  id="searchTerm"  /> 
<input type="hidden"  name="st_description"  id="st_description"  /> 
<input type="hidden"  name="st_specification"  id="st_specification"  /> 
<input type="hidden"  name="st_maker"  id="st_maker"  /> 
<input type="hidden"  name="st_categoty_name"  id="st_categoty_name"  /> 
<input type="hidden"  name="searchMode"  id="searchMode" value="detail"  /> 
</form>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
<!-----------------------------------------------------------------------------------------------footer------------------------------------------------------------------------------------------------------->
    
</div> 
</body>
</html>


