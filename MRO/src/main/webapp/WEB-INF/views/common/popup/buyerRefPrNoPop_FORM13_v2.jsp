<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form13)
* 기능 : 관리번호 팝업(form13)
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-08-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String popType = (String)request.getAttribute("popType"); // 조회된 결과

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode()); 
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");  //  (조회조건)
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건)
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");  //  (조회조건)

%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view(){
}

function setReturn(){
	var st_ref_pr_no = $("#st_ref_pr_no").val();
	if(st_ref_pr_no == ""){
		//관리번호가 선택되지 않았습니다.관리번호란을 클릭하여 선택하여 주십시요.
		var text = "<%=CommonLang.msg("MSG122")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var tab_id = "<%=st_tab_id%>";
	var st_row = "<%=st_row%>";
	if(tab_id == ""){
		opener.setPopupReturn(st_row,st_ref_pr_no);
	}else{
		opener.tabs[tab_id]["setPopupReturn"](st_row,st_ref_pr_no);
	}
	this.close();	
}
</script>
</head>
<body onload="kep_onload_view()">
<div class="wrapPopup"  >
<form name="searchForm" id="searchForm" method=post >

  <div class="PopupTit"><%=st_title %> </div>
  <table  class="PopupSearchTableNoline mt10" width="100%">
    <tr>
    <%if(popType.equals("TYPE36")) {%>
      	<select name="st_ref_pr_no"  id="st_ref_pr_no" class="CART_PDbox_Select mt15" style="width:387px;">
         	<%=CommonUtil.getCodeBComboList(st_buyer,"REF_PR_SEL","M014","ICOMCOD2","","") %>
      	</select>
    <%}else if(popType.equals("TYPE37")) {%>
    	<select name="st_ref_pr_no" id="st_ref_pr_no" class="CART_PDbox_Select mt15" style="width:387px;">
            <%=CommonUtil.getTextValueComboList(st_buyer,"REF_PR_SEL","M014","ICOMCOD2","","") %>
        </select>
    <%} %>
    </tr>
	</table>
	<div class="h15"></div>
  	<div class="PopupListBtnBox_Center mt15">
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button> 
    </div>
    </form> 
</div><!-- wrapPopup 끝-->  
</body>
</html>
