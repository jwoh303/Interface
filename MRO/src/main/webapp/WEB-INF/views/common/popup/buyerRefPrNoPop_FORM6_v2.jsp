<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form6)
* 기능 : 관리번호 팝업(form6)
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String cond0_code = (String)request.getAttribute("cond0_code"); // 조회된 결과
String cond1_code = (String)request.getAttribute("cond1_code"); // 조회된 결과

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode()); 
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
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

var popupSel = "";
var st_buyer = "<%=st_buyer%>";
var st_ref_pr_no = "";
function kep_onload_view(){
	
}
function setReturn(){
	if(set_ref_pr_no()){
		var tab_id = "<%=st_tab_id%>";
		var st_row = "<%=st_row%>";
		if(tab_id == ""){
			opener.setPopupReturn(st_row,st_ref_pr_no);
		}else{
			opener.tabs[tab_id]["setPopupReturn"](st_row,st_ref_pr_no);
		}
		this.close();	
	}	
}

function set_ref_pr_no(){

	if(kepIsEmpty("st_cond0") || kepIsEmpty("st_cond1")){
		//그룹웨어 품의번호 또는 GL계정 미입력 되었습니다
		var text = "<%=CommonLang.msg("MSG853")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return false;
	}
	
	var cond0 = document.forms.searchForm.st_cond0.value;
	var cond1 = document.forms.searchForm.st_cond1.value;

	st_ref_pr_no = cond0 + "^" + cond1;
	
	return true;
}
</script>
</head>
<body onload="kep_onload_view()">
<div class="wrapPopup"  >
<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">

  <div class="PopupTit"><%=st_title %> </div>
  <table  class="PopupSearchTableNoline mt10" width="100%">
	<colgroup>
      <col width="130px" />
      <col width="*" />
	</colgroup>
    <tr>
    	<th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1343")%><!--품의번호--></th>
        <td><input class="input40" style="width:365px" name="st_cond0" id="st_cond0" type="text" value="<%=cond0_code %>" maxlength="400"/></td>
	</tr>
    <tr>        
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1344") %><!-- G/L ACCOUNT --></th>
      <td><select name="st_cond1" id="st_cond1" class="Select40" style="width:385px">
          <%= CommonUtil.getCodeBComboList(st_buyer,"SEL","M014","ICOMCOD2",cond1_code,"TEXT1") %>
        </select>
      </td>
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
