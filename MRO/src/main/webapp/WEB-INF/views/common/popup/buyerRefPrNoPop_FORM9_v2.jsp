<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form9)
* 기능 : 관리번호 팝업(form9)
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-05-08
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
Map<String,String> _data = (Map<String,String>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");


String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode());
String st_account_type =  CommonUtil.nvl((String) request.getParameter("st_account_type"), "");
String ref_pr_no =  CommonUtil.nvl((String) request.getParameter("st_ref_no"), "");
String ref_pr_no_text =  CommonUtil.nvl((String) request.getParameter("st_ref_no_text"), "");
String code = CommonUtil.nvl( _data.get("CODE"), "");
String text1 = CommonUtil.nvl( _data.get("TEXT1"), "");


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

var st_ref_pr_no = "";
// 사용자 조회 팝업
// function account_list(){
<%-- 	var st_buyer = '<%=st_buyer%>'; --%>
<%-- 	var st_account_type = '<%=st_account_type%>'; --%>
	
	
// 	openSearchPopup("/mpso/getBuyerMpSoRefPrNoListNexePop.do","?st_account_type="+st_account_type+"&st_buyer="+st_buyer, "500,500,no");

// }
function account_list(){
	var st_buyer = '<%=st_buyer%>';
	var st_gbn = "<%=CommonLang.get("HTITLE1354") %>"; //코드명
	var st_type = "M014";
	var st_code = "";
	var st_text = "";
	var st_text4 = '<%=st_account_type%>';
	var st_title = "<%=CommonLang.get("HTITLE1353") %>"; //고정자산번호 검색
	
	openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text+"&st_text4="+st_text4+"&st_title="+st_title, "700,510,no");
}
	

function setReturn(){
		var st_ref_pr_no = document.forms.searchForm.st_ref_pr_no.value;
		var st_ref_pr_no_text = document.forms.searchForm.st_ref_pr_no_text.value;
		if(st_ref_pr_no == "") {
			//고정자산번호를 선택하세요
			var text = "<%=CommonLang.msg("MSG859")%>";
			openLayerPopText2(text,but1text,but1func,but1width); 
			return;
		}
		
		var tab_id = "<%=st_tab_id%>";
		var st_row = "<%=st_row%>";
		if(tab_id == ""){
			opener.setPopupReturn(st_row,st_ref_pr_no,st_ref_pr_no_text);
		}else{
			opener.tabs[tab_id]["setPopupReturn"](st_row,st_ref_pr_no,st_ref_pr_no_text);
		}
		
		this.close();	
	
}

function deleteRefNo() {
	document.forms.searchForm.st_ref_pr_no_text.value = "";
	document.forms.searchForm.st_ref_pr_no.value = "";
}



function setPopupReturn(value1,value2,value3){		
	document.forms.searchForm.st_ref_pr_no_text.value = value2 + "(" + value3 + ")";
	document.forms.searchForm.st_ref_pr_no.value = value2;
}
</script>
</head>
<body onload="kep_onload_view()">
<div class="wrapPopup"  >
<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" name="st_com_code" id="st_com_code" value="" readonly disabled="disabled">

  <div class="PopupTit"><%=st_title %> </div>
  <table  class="PopupSearchTable mt10" width="100%">
	<colgroup>
      <col width="100px" />
      <col width="100px" />
      <col width="*" />
	</colgroup>
    <tr>
      <th rowspan="2" >■ <%=CommonLang.get("HTITLE1355")%><!--투자--></th>
      <th><%=CommonLang.get("HTITLE1356")%><!--투자 번호--></th>
      <td> <%=code %></td>
    </tr> 
    <tr>
      <th><%=CommonLang.get("HTITLE1357")%><!--투자 명--></th>
      <td> <%=text1 %></td>
    <tr> 
    <tr>
      <th>■ <%=CommonLang.get("HTITLE1358")%><!--고정자산--></th>
      <th><%=CommonLang.get("HTITLE976")%><!-- 고정자산번호 --></th>
      <td><div class="SearchPopupInput38" style="width:300px; display:inline-block">
        <input type="text" name="st_ref_pr_no_text" id="st_ref_pr_no_text" style=" width:85%; " value="<%=ref_pr_no_text%>" readonly>
        <button type="button" onclick="javascript:account_list(); return false;" ></button>
        <input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no" style="width:40%" value="<%=ref_pr_no%>">
      </div></td>
    <tr> 
	</table>
  	<div class="PopupListBtnBox_Center mt15">
    <button class="ButDarkGray_Medium" style="width:100px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE124") %><!-- 저장 --></button> 
    <button class="ButOutline_Medium" style="width:100px" onclick="javascript:deleteRefNo(); return false;" ><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></button>
    <button class="ButOutline_Medium" style="width:100px" onclick="javascript:this.close(); return false;" ><%=CommonLang.get("HTITLE497") %><!-- 닫기 --></button>
    </div>
    </form> 
</div><!-- wrapPopup 끝-->  
</body>
</html>
