<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form7)
* 기능 : 관리번호 팝업(form7)
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


String cond1_code = (String)request.getAttribute("cond1_code"); // 조회된 결과
String cond1_name = (String)request.getAttribute("cond1_name"); // 조회된 결과
String cond2_code = (String)request.getAttribute("cond2_code"); // 조회된 결과
String cond2_name = (String)request.getAttribute("cond2_name"); // 조회된 결과
String cond3_code = (String)request.getAttribute("cond3_code"); // 조회된 결과
String cond3_name = (String)request.getAttribute("cond3_name"); // 조회된 결과

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode()); 
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");  //  (조회조건)
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
String st_cart_yn = CommonUtil.nvl((String) request.getParameter("st_cart_yn"),"N");  //  (조회조건)
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건)
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");  //  (조회조건)
String st_modify_yn = CommonUtil.nvl((String) request.getParameter("st_modify_yn"),"N");  //  (조회조건)


boolean SolbPlantYn = CommonUtil.getCodeCheckReturn("SOLB02", sessionInfoPop.getComCode());
boolean SolbCostCenterYn = CommonUtil.getCodeCheckReturn("SOLB03", sessionInfoPop.getComCode());
boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", sessionInfoPop.getUserId(), sessionInfoPop.getComCode());

String group_mng_flag = "N";

if(getCodeTGCM == true){
	   group_mng_flag = "Y"; 
}
%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";


var st_ref_pr_no = "";
var st_ref_pr_no_text = "";

function kep_onload_view(){
	
}
//플랜트 팝업
function getCond1Pop(){
popupSel = "COND1";
var st_buyer = $("#st_com_code").val();
var st_gbn = "<%=CommonLang.get("HTITLE1266") %>"; //플랜트
var st_type = "C031";
var st_code = "";
var st_text = "";
openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "695,500,no");		
}

//코스트센터 팝업
function getCond2Pop(){
popupSel = "COND2";
var st_buyer = $("#st_com_code").val();
var st_gbn = "<%=CommonLang.get("HTITLE1265") %>"; //코스트센터
var st_type = "C020";
var st_code = "";
var st_text = "";

openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "695,500,no");		

}

//계정 팝업
function getCond3Pop(){
popupSel = "COND3";
var st_buyer = $("#st_com_code").val();
var st_gbn = "<%=CommonLang.get("HTITLE428") %>"; //계정
var st_type = "M014";
var st_code = "";
var st_text = "";
openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "695,500,no");

}


function setReturn(){
	if(set_ref_pr_no()){	
		var tab_id = "<%=st_tab_id%>";
		var st_row = "<%=st_row%>";
		if(tab_id == ""){
			opener.setPopupReturn(st_row,st_ref_pr_no,'');
		}else{
			opener.tabs[tab_id]["setPopupReturn"](st_row,st_ref_pr_no,'');
		}
		this.close();	
	}	
}

function set_ref_pr_no(){

var cond1 = "";
var cond2 = "";
var cond3 = "";	
var cond1_name = "";
var cond2_name = "";
var cond3_name = "";
	
cond1 = document.forms.searchForm.st_cond1_code.value;
cond2 = document.forms.searchForm.st_cond2_code.value;
cond3 = document.forms.searchForm.st_cond3_code.value;

st_ref_pr_no = cond1 + "^" + cond2 + "^" + cond3;	
return true;
}

function setPopupReturn(value1,value2,value3){
if(popupSel == "COND1"){
	document.forms.searchForm.st_cond1_code.value = value2;
	document.forms.searchForm.st_cond1_name.value = value3;
}else if(popupSel == "COND2"){
	document.forms.searchForm.st_cond2_code.value = value2;
	document.forms.searchForm.st_cond2_name.value = value3;
}else if(popupSel == "COND3"){
	document.forms.searchForm.st_cond3_code.value = value2;
	document.forms.searchForm.st_cond3_name.value = value3;
}
}

function buyerChange() {
document.forms.searchForm.st_cond1_code.value = '';
document.forms.searchForm.st_cond1_name.value = '';
document.forms.searchForm.st_cond2_code.value = '';
document.forms.searchForm.st_cond2_name.value = '';
document.forms.searchForm.st_cond3_code.value = '';
document.forms.searchForm.st_cond3_name.value = '';
}

function reload(){
	document.forms.searchForm.st_cond1_code.value = '';
	document.forms.searchForm.st_cond1_name.value = '';
	document.forms.searchForm.st_cond2_code.value = '';
	document.forms.searchForm.st_cond2_name.value = '';
	document.forms.searchForm.st_cond3_code.value = '';
	document.forms.searchForm.st_cond3_name.value = '';
}
</script>
</head>
<body onload="kep_onload_view()">
<div class="wrapPopup"  >
<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">
	<input type=hidden name="st_ref_no" id="st_ref_no"  value="<%=st_ref_no%>">
	<input type=hidden name="codeGubun" id="codeGubun"  value="buyerRefPrNoPopFORM7_v2">

  <div class="PopupTit"><%=st_title %> </div>
  <table  class="PopupSearchTableNoline mt10" width="100%">
	<colgroup>
      <col width="100px" />
      <col width="*" />
	</colgroup>
	<%if(st_modify_yn.equals("N")) {%> <!-- 수정x -->
	<% if(group_mng_flag.equals("Y") && st_cart_yn.equals("N")) {%>
    <tr>        
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
      <td><select name="st_com_code" id="st_com_code" class="Select40" style="width:385px" onchange="buyerChange()">
          <%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer, "") %>
        </select>
      </td>
    </tr>
    <% } else { %>
	<input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_buyer%>" readonly disabled="disabled">					    	
	<% } %>
    <tr>
      <th><%=CommonLang.get("HTITLE1266") %><!-- 플랜트 --></th>
        <%if(!SolbPlantYn) { %>
      <td>
        <input type="text" class="input40" name="st_cond1_code" id="st_cond1_code" style=" width:138px; " value="<%=cond1_code%>" readonly disabled="disabled">
        <input class="input40" style="width:200px" name="st_cond1_name" id="st_cond1_name" type="text" value="<%=cond1_name%>" readonly disabled="disabled"/></td>
        <%}else{ %>
      <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond1_code" id="st_cond1_code" style=" width:85%; " value="<%=cond1_code%>" readonly>
	        <button type="button" onclick="javascript:getCond1Pop(); return false;"></button>
      </div> <input class="input40" style="width:200px" name="st_cond1_name" id="st_cond1_name" value="<%=cond1_name%>" type="text" readonly /></td>
        <%} %>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1265") %><!-- 코스트센터 --></th>
      <%if(!SolbCostCenterYn) { %>
      <td>
        <input type="text" class="input40" name="st_cond2_code" id="st_cond2_code" style=" width:138px; " value="<%=cond2_code%>" readonly disabled="disabled">
        <input class="input40" style="width:200px" name="st_cond2_name" id="st_cond2_name" type="text" value="<%=cond2_name%>" readonly disabled="disabled"/></td>
      <%}else{ %>
        <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond2_code" id="st_cond2_code" style=" width:85%; " value="<%=cond2_code%>" readonly>
	        <button type="button" onclick="javascript:getCond2Pop(); return false;" ></button>
      </div> <input class="input40" style="width:200px" name="st_cond2_name" id="st_cond2_name" value="<%=cond2_name%>" type="text" readonly /></td>
        <%} %>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE428") %><!-- 계정 --></th>
      <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond3_code" id="st_cond3_code" style=" width:85%; " value="<%=cond3_code%>" readonly>
        <button type="button" onclick="javascript:getCond3Pop(); return false;"></button>
      </div> <input class="input40" style="width:200px" name="st_cond3_name" id="st_cond3_name" value="<%=cond3_name%>" type="text" readonly/></td>
    </tr>
    
    <%}else{ %> <!-- 수정 -->
    <input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_buyer%>" readonly>	
    	<tr>
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE1266") %><!-- 플랜트 --></th>
      <td>
        <input type="text" class="input40" name="st_cond1_code" id="st_cond1_code" style=" width:138px; " readonly disabled="disabled" value="<%=cond1_code%>">
        <input class="input40" style="width:200px" name="st_cond1_name" id="st_cond1_name" type="text" readonly disabled="disabled" value="<%=cond1_name%>"/></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE1265") %><!-- 코스트센터 --></th>
      <%if(!SolbCostCenterYn) { %>
      <td>
        <input type="text" class="input40" name="st_cond2_code" id="st_cond2_code" style=" width:138px; " readonly disabled="disabled" value="<%=cond2_code%>">
        <input class="input40" style="width:200px" name="st_cond2_name" id="st_cond2_name" type="text" readonly disabled="disabled" value="<%=cond2_name%>"/></td>
        <%}else{ %>
        <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond2_code" id="st_cond2_code" style=" width:85%; " readonly value="<%=cond2_code%>">
	        <button type="button" onclick="javascript:getCond2Pop(); return false;" ></button>
      </div> <input class="input40" style="width:200px" name="st_cond2_name" id="st_cond2_name" type="text" readonly value="<%=cond2_name%>" /></td>
        <%} %>
    </tr>
    <tr>
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE428") %><!-- 계정 --></th>
      <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond3_code" id="st_cond3_code" style=" width:85%; " readonly value="<%=cond3_code%>">
        <button type="button" onclick="javascript:getCond3Pop(); return false;"></button>
      </div> <input class="input40" style="width:200px" name="st_cond3_name" id="st_cond3_name" type="text" readonly value="<%=cond3_name%>"/></td>
    </tr>
    <%} %>
	</table>
	<div class="h15"></div>
  	<div class="PopupListBtnBox_Center mt15">
  	<%if(st_modify_yn.equals("N")) {%>
    	<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button> 
    	<%if(st_cart_yn.equals("N")) {%>
	    	<button class="ButOutline_Medium" style="width:120px" onclick="javascript:reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
    	<%} %>
    <%}else{ %>
   		<button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE124") %><!-- 저장 --></button> 
    <%} %>
    </div>
    </form> 
</div><!-- wrapPopup 끝-->  
</body>
</html>
