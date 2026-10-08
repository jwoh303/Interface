<%--
**********************************************
* 메뉴 : 
* 화면 : 나의 메뉴 지정 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 :  고영일 ( 설계 : 김지현 )
* 착수일 : 2014-10-16
**********************************************
--%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String st_open_yn = CommonUtil.nvl((String) request.getParameter("st_open_yn"), "N");
%>

<script type="text/javascript">
<!--

function kep_onload(){
	<% if(!"Y".equals(st_open_yn)){ %>
		$('#buyerMyMenuPop').attr("action", "/none/getCommonNoNeBuyerMyMenuPop.do").submit();
	<% } %>
}

function saveMyMenu(){

	if($(".myMenuBox input[name=menuItem]:checked").length == 0){
		alert("<%=CommonLang.msg("MSG419") %>");	//선택된 메뉴가 없습니다. 나의 메뉴를 지정해주세요.
		return;
	}
	
	var checkedItem = $(".myMenuBox input[name=menuItem]:checked"); 
	
	if(checkedItem.length > 6){
		alert("<%=CommonLang.msg("MSG420") %>");	//나의 메뉴 지정은 최대 6개까지 할 수 있습니다.
		return;
	}
	
	var arry_prty_value = "";
	$(checkedItem).each(function(){
		arry_prty_value += $(this).val() + "||";
	});
	//선택하신 메뉴를 나의 메뉴로 지정 하시겠습니까?
	if(confirm("<%=CommonLang.msg("MSG421") %>")){
		var pData = { arry_prty_value : arry_prty_value, st_user_id : $("#st_user_id").val()};
		kepAjaxCall("/none/saveCommonNoNeBuyerMyMenu.do",pData,"saveMyMenu");
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if ( pMethod == "saveMyMenu" ) {
		var msg = response.msg.MSG;
		if(msg == "INSERT_OK"){
			
			var myMenuList =  response.msg.MY_MENU_LIST;
			var myMenuObj = $(".header_gnb", opener.document);
			$(myMenuObj).find("li").remove();
			var menuStr = "";
			var menuItem = null;

			for(var inx = 0 ; inx < myMenuList.length ; inx++){
				menuItem = myMenuList[inx];
				menuStr = "";
				menuStr += "<li>";
				if(inx > 0){
					menuStr += "<img src=\"/resources/images/br_header_gnb.gif\" alt=\"" + menuItem.NAME + "\" />";
				}
				menuStr += " <a href=\"" + menuItem.URL + "?upperId=" + menuItem.TOPMENUID + "\">" + menuItem.NAME + "</a>";
				menuStr += "</li>";
				$(myMenuObj).append(menuStr);
			}
			
			alert("<%=CommonLang.msg("MSG31") %>");	//저장 되었습니다.
			self.close();
			return;
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "saveMyMenu"){ 
		 alert("<%=CommonLang.msg("MSG422") %>  "); //나의 메뉴 저장에 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
	}
}

 //-->
</script> 
<body onload="javascript:kep_onload();">
<form name="buyerMyMenuPop" id="buyerMyMenuPop" method=post >
	<input type="hidden" id="st_user_id" name="st_user_id" value="<%=st_user_id %>" />
	<input type="hidden" id="st_open_yn" name="st_open_yn" value="Y" />
	
	<div class="myMenuBox" >
		<div class="myMenuHeader"><span class="myMenu"><%=CommonLang.get("HTITLE724") %><!-- 나의메뉴 지정 --></span> <span class="myMenuNum"> * <%=CommonLang.get("HTITLE725") %><!-- 최대 6개까지 지정 --> &nbsp;&nbsp;&nbsp;<a href="javascript:self.close();"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></span></div>
<% 
	if(_dataList != null && _dataList.size() > 0){
		List<Map<String, String>> menuList = new ArrayList<Map<String, String>>();
		Map<String, String> menuItem = null;
		int menuCnt = 0;
		System.out.println("_dataList.size()  ::: " + _dataList.size());
		for(int inx = 0 ; inx < _dataList.size() ; inx++){
			Map<String, String> _rowData = _dataList.get(inx);
			String menuLevel = CommonUtil.nvl((String)_rowData.get("LVL"));
			
			if("1".equals(menuLevel)){
				if(menuItem != null){
					menuCnt = 0;
					menuList.add(menuItem);
				}
				menuItem = new HashMap<String, String>();
				menuItem.put("menuUpperName", CommonUtil.nvl((String)_rowData.get("NAME")));
				menuItem.put("menuUpperKey", CommonUtil.nvl((String)_rowData.get("MENU_ID")));
			} else {
				if("1".equals(CommonUtil.nvl((String)_rowData.get("IS_LEAF")))){
					menuItem.put("menuKey" + menuCnt, CommonUtil.nvl((String)_rowData.get("MENU_ID")));
					menuItem.put("menuValue" + menuCnt, CommonUtil.nvl((String)_rowData.get("NAME")));
					menuItem.put("myMenuYn" + menuCnt++, CommonUtil.nvl((String)_rowData.get("MY_MENU_YN")));
				}
			}
			
			if((inx+1) == _dataList.size()){
				System.out.println("if((inx+1) == _dataList.size())");
				menuList.add(menuItem);
			}
		}
		
		for(int inx = 0 ; inx < menuList.size() ; inx++){
			Map<String, String> _detailData = menuList.get(inx);
			Set mapKey =  _detailData.keySet();
			
			String listNum = "";
			// 메뉴명이 관리자 인경우 class 번호를 09으로 한다. ( 관리자 MENU_ID :  b00109000000)
			if( "b00109000000".equals(CommonUtil.nvl((String)_detailData.get("menuUpperKey"))) ){
				listNum = "09";
			}else{
				listNum = CommonUtil.lpad(String.valueOf(inx + 1), 2, '0');
			}
%>
			<div class="List<%=listNum %>">
				<p class="myMenubIG"><%=CommonUtil.nvl((String)_detailData.get("menuUpperName")) %></p>
				<ul>
<%
			for(int keyInx = 0 ; keyInx < ( ( mapKey.size() - 1 ) / 3 ) ; keyInx++){
				String menuKey = CommonUtil.nvl((String)_detailData.get("menuKey"+keyInx));
				String menuValue = CommonUtil.nvl((String)_detailData.get("menuValue"+keyInx));
				String myMenuYn = CommonUtil.nvl((String)_detailData.get("myMenuYn"+keyInx));
%>
					<li><input name="menuItem" type="checkbox" value="<%=menuKey %>" class="myMenucheck" <%if("Y".equals(myMenuYn)){ %>checked="checked"<%} %> > <%=menuValue %></li>
<%
			}
%>
				</ul>
			</div>
<%
		}
	}
%>
			<div class="myMenuline" ></div>
		<div class="myMenubtn" ><span class="btn_04 "><a href="javascript:saveMyMenu();"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a></span></div>
	</div><!--나의메뉴지정 끝-->
</form> 
</body>
</html>
