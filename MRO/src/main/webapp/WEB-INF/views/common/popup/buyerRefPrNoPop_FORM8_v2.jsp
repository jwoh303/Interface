<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form8)
* 기능 : 관리번호 팝업(form8)
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

String st_cond1_id			= CommonUtil.nvl((String)request.getAttribute("st_cond1_id"));		// 사용자ID
String st_cond1_empno		= CommonUtil.nvl((String)request.getAttribute("st_cond1_empno"));	// 사용자사번
String st_cond2_id			= CommonUtil.nvl((String)request.getAttribute("st_cond2_id"));		// 관리자ID
String st_cond2_empno		= CommonUtil.nvl((String)request.getAttribute("st_cond2_empno"));	// 관리자사번
String st_cond3_number		= CommonUtil.nvl((String)request.getAttribute("st_cond3_number"));	// 품의번호
String st_cond4_reason		= CommonUtil.nvl((String)request.getAttribute("st_cond4_reason"));	// 구매사유

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode()); 

String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");
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

function getCond1Pop(){
	var st_buyer = $("#st_com_code").val();
	var st_gbn = "<%=CommonLang.get("HTITLE1346")%>"; //실사용자
	var st_type = "USER";
	var st_code = "";
	var st_text = "";
	
	openSearchPopup("/common/getUserInfoSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,520,no");

}
	
// 관리자 조회 팝업
function getCond2Pop(){
	var st_buyer = $("#st_com_code").val();
	var st_gbn = "<%=CommonLang.get("HTITLE526")%>";//관리자
	var st_type = "ADMIN";
	var st_code = "";
	var st_text = "";
	
	openSearchPopup("/common/getUserInfoSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,520,no");

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
// 		opener.setPopupReturn("Hans",st_ref_pr_no);
		this.close();	
	}else{
		//실사용자, 관리자, 품의번호 항목은 비워둘 수 없습니다
		var text = "<%=CommonLang.msg("MSG854")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
}

function set_ref_pr_no(){
	
	var cond1 = "";
	var cond2 = "";
	var cond3 = "";	
	var cond4 = "";
	var cond5 = "";
	var cond6 = "";	
		
	cond1 = document.forms.searchForm.st_cond1_id.value;
	cond2 = document.forms.searchForm.st_cond1_empno.value;
	cond3 = document.forms.searchForm.st_cond2_id.value;
	cond4 = document.forms.searchForm.st_cond2_empno.value;
	cond5 = document.forms.searchForm.st_cond3_number.value;
	cond6 = document.forms.searchForm.st_cond4_reason.value;
	
	// 필수 항목 중 1개라도 비어있다면
	if(isEmpty(cond1) || isEmpty(cond2) || isEmpty(cond3) || isEmpty(cond4) || isEmpty(cond5)){
		return false;
	}
	st_ref_pr_no = cond1 + "^" + cond2 + "^" + cond3 + "^" + cond4 + "^" + cond5 + "^" + cond6;
	return true;
}

function setPopupReturn(value1,value2,value3){
	
	if(value1 == "USER"){
		document.forms.searchForm.st_cond1_id.value = value2;
		document.forms.searchForm.st_cond1_empno.value = value3;
	}else if(value1 == "ADMIN"){
		document.forms.searchForm.st_cond2_id.value = value2;
		document.forms.searchForm.st_cond2_empno.value = value3;
	}
}
</script>
</head>
<body >
<div class="wrapPopup"  >
<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_buyer%>" readonly disabled="disabled">

  <div class="PopupTit"><%=st_title %></div>
  <table  class="PopupSearchTableNoline mt10" width="100%" >
	<colgroup>
      <col width="120px" />
      <col width="10px" />
      <col width="120px" />
      <col width="10px" />
      <col width="*" />
<!--       <col width="135px" /> -->
	</colgroup>
    <tr>
      	<td>
	      	<div class="SearchPopupInput38" style="width:130px;">
	        <input type="text" name="st_cond1_id" id="st_cond1_id" style=" width:78%;" value="<%=st_cond1_id%>" readonly placeholder="<%=CommonLang.get("HTITLE1346")%>"> <!-- 실사용자 -->
	        <button type="button" onclick="javascript:getCond1Pop(); return false;" id="st_asset_name_href" ></button> </div> </td>
      	<td></td>
      	<td>
	      	<div class="SearchPopupInput38" style="width:130px;">
	        <input type="text" name="st_cond2_id" id="st_cond2_id" style=" width:78%;" value="<%=st_cond2_id%>" readonly placeholder="<%=CommonLang.get("HTITLE526")%>"> <!-- 관리자 -->
	        <button type="button" onclick="javascript:getCond2Pop(); return false;" id="st_asset_name_href" ></button> </div> </td>
      	<td></td>
      	<td><input class="input40" style="width:200px" name="st_cond3_number" id="st_cond3_number" type="text" value="<%=st_cond3_number%>" placeholder="<%=CommonLang.get("HTITLE1343")%>"/> <!-- 품의번호 -->
      	</td>
    </tr>
    <tr>
    	<td><input class="input40" style="width:110px" name="st_cond1_empno" id="st_cond1_empno" type="text" value="<%=st_cond1_empno%>" readonly placeholder="<%=CommonLang.get("HTITLE454")%>"/><!-- 사번 --></td>
    	<td></td>
    	<td><input class="input40" style="width:110px" name="st_cond2_empno" id="st_cond2_empno" type="text" value="<%=st_cond2_empno%>" readonly placeholder="<%=CommonLang.get("HTITLE454")%>"/><!-- 사번 --></td>
    </tr>
    <tr>
    	<th><%=CommonLang.get("HTITLE1168") %><!-- 구매사유 --></th>
    	<td></td>
    	<td colspan = "3"><input class="input40" style="width:340px" name="st_cond4_reason" id="st_cond4_reason" type="text" value="<%=st_cond4_reason%>"/></td>
    </tr>
	</table>
  <div class="PopupListBtnBox_Center mt15">
    <!--button class="ButOutline_Medium" style="width:120px" >초기화</button--> 
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:setReturn(); return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button> 
  </div> 
</form>
</div><!-- wrapPopup 끝--> 
  
</body>
</html>
