<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../common/include/head.jspf"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/resources/js/tab/ibmditab.js"></script>
<script type="text/javascript" src="/resources/js/tab/ibmditabinfo.js"></script>
<script type="text/javascript" src="/resources/js/tab/ibmditabscroll.js"></script>
<% 
	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	String session_st_gw_no = CommonUtil.nvl((String)request.getSession().getAttribute("session_st_gw_no"),""); // 결재상신 메일 관련 sso 처리를 위한 결재번호 리턴
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String empNo = "";
	if (sessionInfo != null){ 
		empNo =  CommonUtil.nvl((String)sessionInfo.getEmpNo());  // 분기처리를 위함( asis 마감화면용)
	}
	String ymdh = CommonUtil.getCurrentDay_Time("YYYYMMDDHH");
	String mailOpen = CommonUtil.nvl((String) request.getParameter("mailOpen"),""); // 조회조건 메일	 결재바로보기에서 왔을경우에만  결재대상조회 
%>
<script src="/resources/js/kep_common.js"></script>
<title>ajax_display</title>
<script type="text/javaScript">
<!--
function init() {
	MainTab.Init(1, true, true);
	//글자수에 따른 텝너비 조정	
	MainTab.SetTabItemLayout(10);
	//MainTab.SetTabUserWidth(150);
	
	$("#ContAreaFrame").hide();
	var tabId = $("#initTabId").val();
	
	if(!isEmpty(tabId)){
		
		var buyerCode = $("#initBuyerCode").val();
		var buyerName = $("#initBuyerName").val();
		
		doActionTab(tabId, buyerCode, buyerName);
	}
	
	
	//결재바로 가기(참고로 밑의 css가 깨져서리) 버튼 클릭시 아래의 화면의 이동하며, 결재팝업까지 자동으로 뜸
	//결재바로 가기에서 바로 왔다는 것을 구분하기 위하여 session_st_gw_no 에 값을 넣어 추후 구분처리한다.
	<% if ("Y".equals(mailOpen) && !"".equals(session_st_gw_no)){%>	 
		tab("결재대상조회","/mdap/showNewPassRecvList.do");
	<%}%> 
	
}

function MainTab_OnAfterDelete(index)
{
	//탭count가 없으면 기본Frame 화면 보여줌.
	if(MainTab.GetCount() == 0){
		$("#ContAreaFrame").hide();
		$("#ContAreaFrame2").show();
		leftShowHidden('show');
	}
}


function tab(title, url, exceptFlag) {
		//글자수에 따른 텝너비 조정	
		//MainTab.SetTabUserWidth(150);
// 		alert(title+"::"+url);
		//MainTab.InsertItem("발주진행관리", "/mpso/showMasterMpSoProgressBody.do");
		
		$("#ContAreaFrame").show();
		$("#ContAreaFrame2").hide();
		
		//고객사/운영사 공유화면 제어 
		 // 결재상신 메일 관련 sso 처리를 위한 결재대상조회 이동
		if(url.indexOf("/mdap/showNewPassRecvList.do") > -1){ 
			url = url+"?moveToBuyer=Y&mailOpen=<%=mailOpen%>";
			//고객사/운영사 공유화면 제어 	
		}else if(url.indexOf("/mdap/") > -1){ 
			url = url+"?moveToBuyer=Y";
			
		}else if(url.indexOf("/master/mdam/") > -1){
			url = url+"?moveToMaster=Y";
		}else if(url.indexOf("st_link_gubun=CLOSE") > -1 ){
			var empNo = "<%=empNo%>";
			var ymdh = "<%=ymdh%>";
			url = url+"&st_emp_no="+empNo+"&st_datetime="+ymdh;
// 			alert("url : " + url);
		}
		var tempIdx = MainTab.FindTabTitle(title);
		if(tempIdx==-1){
			MainTab.InsertItem(title, url);
		}else{
			if(exceptFlag == "Y"){
				MainTab.InsertItem(title, url);	
			}else{
				MainTab.SetSelectedIndex(tempIdx);	
			}
		}
		leftShowHidden('hide');
}

//중메뉴 select
function selectSubMenu(st_upper_id){

	var param =  { part: st_upper_id,page: 'masterLeft'};
	kepAjaxHtmlCall("/menu/menu.do",param,"selectSubMenu");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxHtmlSuccess(pMethod , data) {

	if (pMethod == "selectSubMenu") {
		$("#subLeft").html(data);
		return;
	}else if(pMethod == "getMasterMdAmProxyHome"){ 
		$("#MainTab_divArea").html(data);
		return;
	}
}

//ajax 공통 호출후 오류시 처리 함수
function  kepAjaxHtmlError(pMethod , response) {
	
	if (pMethod == "selectSubMenu") {
		$("#subLeft").hide();
		alert("메뉴 구성 중 오류 발생하였습니다.");
		return;
	}else if(pMethod == "getMasterMdAmProxyHome"){ 
		return;
	}
} 

//-->
</script>
</head>
<body onload="init();"> 
	<input type="hidden" id="initTabId" value="${param.tabId}"/>
	<input type="hidden" id="initBuyerCode" value="${param.st_buyer_code}"/>
	<input type="hidden" id="initBuyerName" value="${param.st_buyer_name}"/>
	
	<div id="wrapper" style="display:inline-block; width:100%;height:100%;">
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="masterHeader" />
			<c:param name="part" value="masterHeader" />
			<c:param name="script" value="Y" />
			<c:param name="upperId" value="${param.upperId}" />
		</c:import>
		
		<div id="container2" style="width:100%; min-height:800px;">
			<div id="subLeft">
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="masterLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			</div>
			
			<!--내용 시작  -->
			<div id="ContAreaFrame" style="display:inline-block; position:absolute; top:0px;left:25px; bottom:58px; right:0px; margin-left: 1px; z-index:1;">
				<script type="text/javascript">
					createIBTab("MainTab", "98%", "100%", "myTheme");
				</script>
			</div>
			
			<!-- 비어있는 Frame 영역을 기본Frame으로 채워줌. -->
			<div id="ContAreaFrame2" style="display:inline-block; position:absolute; top:-20px;left:0px; bottom:58px; right:0px; margin-left: 1px; z-index:0; pointer-events: none;">
				<c:choose>
		        	<c:when test="${fn:indexOf(param.upperId,'m002') > -1 }">
 			        	    <div id="admin_home">
						     	<img src="/resources/images/bg_Proxbuy.jpg">	       
							</div>
		        	</c:when> 
		        	<c:when test="${fn:indexOf(param.upperId,'m003') > -1 }">
 			        	    <div id="admin_home">
						     	<img src="/resources/images/bg_Deadline.jpg">	       
							</div>
		        	</c:when> 	
		        	<c:when test="${fn:indexOf(param.upperId,'m007') > -1 }">
 	 			        	    <div id="admin_home">
						     	<img src="/resources/images/bg_Statistics.jpg">	       
							</div>
		        	</c:when> 		     
		        	<c:when test="${fn:indexOf(param.upperId,'m008') > -1 }">
  			        	    <div id="admin_home">
						     	<img src="/resources/images/bg_voc.jpg">	       
							</div>
		        	</c:when> 	
		        	<c:when test="${fn:indexOf(param.upperId,'m005') > -1 }">
						 <div id="admin_home">
								<div id="main_table_div">
									<div class="WmsBox" > 
									</div>
								</div>      
							</div>

		        	</c:when>
		        	<c:when test="${fn:indexOf(param.upperId,'m009') > -1 }">
  			        	    <div id="admin_home">
						     	<img src="/resources/images/Improving.jpg"/>
							</div>
		        	</c:when> 	 			        	
		        	<c:otherwise> 
  			        	    <div id="admin_home">
						     	<img src="/resources/images/SR_bg.gif">	       
							</div>
					  </c:otherwise> 	  		        	
	        	</c:choose>
			</div>
			<!--내용 종료-->
		</div>
<%-- 			<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %> --%>
	</div>

</body>
</html>
