<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form2)
* 기능 : 관리번호 팝업(form2)
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
String cond4_code = (String)request.getAttribute("cond4_code"); // 조회된 결과

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode()); 
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");  //  (조회조건)
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
String st_cond5 = CommonUtil.nvl((String) request.getParameter("st_remark"),"");  //  (조회조건)
String no_remark_flag = CommonUtil.nvl((String) request.getParameter("no_remark"),"");  //  (조회조건)
String st_cart_yn = CommonUtil.nvl((String) request.getParameter("st_cart_yn"),"N");  //  (조회조건)
String st_tab_id = CommonUtil.nvl((String) request.getParameter("st_tab_id"),"");  //  (조회조건)
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");  //  (조회조건)
String st_modify_yn = CommonUtil.nvl((String) request.getParameter("st_modify_yn"),"N");  //  (조회조건)

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
var st_buyer = "<%=st_buyer%>";

function kep_onload_view(){
	
}
//귀속부서 팝업
function getCond1Pop(){
	popupSel = "COND1";
	
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+st_buyer, "720,580,no");
}

// 관장부서 팝업
function getCond2Pop(){
	popupSel = "COND2";
	
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+st_buyer, "720,580,no");
}

// 계정코드 팝업
function getCond3Pop(){
	popupSel = "COND3";
	
	openSearchPopup("/coco/showCommonCoCoAccountPop.do", "?open=Y&st_com_code="+st_buyer, "480,500,no");
}


function setReturn(){
	if(set_ref_pr_no()){	
		var cond5 = "";
		cond5 = document.forms.searchForm.st_cond5_name.value;
		if (!fnCheckInputByteStr(cond5, 400)) {
			//용도는 영문 400자, 한글 200자 까지 입력할수 있습니다
			var text = "<%=CommonLang.msg("MSG814")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		var tab_id = "<%=st_tab_id%>";
		var st_row = "<%=st_row%>";
		if(tab_id == ""){
			opener.setPopupReturn(st_row,st_ref_pr_no,cond5,st_ref_pr_no_text);
		}else{
			opener.tabs[tab_id]["setPopupReturn"](st_row,st_ref_pr_no,cond5,st_ref_pr_no_text);
		}
		this.close();	
	}	
}

function set_ref_pr_no(){
	var cond1 = "";
	var cond2 = "";
	var cond3 = "";
	var cond4 = "";
	var cond1_name = "";
	var cond2_name = "";
	var cond3_name = "";
	var cond4_name = "";
	
	cond1 = document.forms.searchForm.st_cond1_code.value;
	cond2 = document.forms.searchForm.st_cond2_code.value;
	cond3 = document.forms.searchForm.st_cond3_code.value;
	cond4 = document.forms.searchForm.st_cond4.value;
	cond1_name = document.forms.searchForm.st_cond1_name.value;
	cond2_name = document.forms.searchForm.st_cond2_name.value;
	cond3_name = document.forms.searchForm.st_cond3_name.value;
	cond4_name = $("#st_cond4 option:selected").text();
	
	if(cond1 == "" || cond2 == "" || cond3 == "" || cond4 == ""){
		//필수입력 사항을 선택하여 주시기 바랍니다
		var text = "<%=CommonLang.msg("MSG815")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return false;
	}

	st_ref_pr_no = cond1 + "^" + cond2 + "^" + cond3 + "^" + cond4;
	st_ref_pr_no_text = cond1_name + " / " + cond2_name + " / " + cond3_name + " / " + cond4_name;
	return true;
}

function setPopupReturn(value1,value2,value3){
if(popupSel == "COND1"){
	document.forms.searchForm.st_cond1_code.value = value1;
	document.forms.searchForm.st_cond1_name.value = value2;
}else if(popupSel == "COND2"){
	document.forms.searchForm.st_cond2_code.value = value1;
	document.forms.searchForm.st_cond2_name.value = value2;
}else if(popupSel == "COND3"){
	document.forms.searchForm.st_cond3_code.value = value1;
	document.forms.searchForm.st_cond3_name.value = value2;
}
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
	<input type=hidden name="codeGubun" id="codeGubun"  value="buyerRefPrNoPopFORM2_v2">

  <div class="PopupTit"><%=st_title %> </div>
  <table  class="PopupSearchTableNoline mt10" width="100%">
	<colgroup>
      <col width="100px" />
      <col width="*" />
	</colgroup>
    <input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_buyer%>" readonly>	
   	<tr>
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE1268") %><!-- 귀속부서 --></th>
        <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond1_code" id="st_cond1_code" style=" width:85%; " readonly value="<%=cond1_code%>">
	        <button type="button" onclick="javascript:getCond1Pop(); return false;" ></button>
      </div> <input class="input40" style="width:200px" name="st_cond1_name" id="st_cond1_name" type="text" readonly value="<%=cond1_name%>" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE1269") %><!-- 관장부서 --></th>
        <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond2_code" id="st_cond2_code" style=" width:85%; " readonly value="<%=cond2_code%>">
	        <button type="button" onclick="javascript:getCond2Pop(); return false;" ></button>
      </div> <input class="input40" style="width:200px" name="st_cond2_name" id="st_cond2_name" type="text" readonly value="<%=cond2_name%>" /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE386") %><!-- 계정코드 --></th>
      <td><div class="SearchPopupInput38"style="width:158px; display:inline-block">
        <input type="text" name="st_cond3_code" id="st_cond3_code" style=" width:85%; " readonly value="<%=cond3_code%>">
        <button type="button" onclick="javascript:getCond3Pop(); return false;"></button>
      </div> <input class="input40" style="width:200px" name="st_cond3_name" id="st_cond3_name" type="text" readonly value="<%=cond3_name%>"/></td>
    </tr>
    <tr>        
      <th><span class="F6495F">*</span><%=CommonLang.get("HTITLE1270") %><!-- 세금코드 --></th>
      <td><select name="st_cond4" id="st_cond4" class="Select40" style="width:385px">
          <%= CommonUtil.getCodeBComboList(st_buyer,"SEL","M014","ICOMCOD2",cond4_code,"TEXT1") %>
        </select>
      </td>
    </tr>
    <%if(!no_remark_flag.equals("Y")){%>
    	<th><%=CommonLang.get("HTITLE1273")%><!--용도--></th>
        <td><input class="input40" style="width:365px" name="st_cond5_name" id="st_cond5_name" type="text" value="<%=st_cond5 %>" maxlength="400"/></td>
    <%}else{ %>
    	<input type="hidden" name="st_cond5_name"  id="st_cond5_name" maxlength="400" style="width:90%; ime-mode:active" value="<%=st_cond5%>" class="input_type_text">
    <%} %>
	</table>
	<div class="h15"></div>
  	<div class="PopupListBtnBox_Center mt15">
    <button class="ButDarkGray_Medium" style="width:120px" onclick="javascript:setReturn(); return false;" ><%=CommonLang.get("HTITLE124") %><!-- 저장 --></button> 
    </div> 
    </form>
</div><!-- wrapPopup 끝-->  
</body>
</html>
