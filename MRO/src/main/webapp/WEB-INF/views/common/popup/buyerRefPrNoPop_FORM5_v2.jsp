<%--
**********************************************
* 메뉴 : 
* 화면 : 관리번호 팝업(form5)
* 기능 : 관리번호 팝업(form5)
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
String cond2_code = (String)request.getAttribute("cond2_code"); // 조회된 결과
String cond2_name = (String)request.getAttribute("cond2_name"); // 조회된 결과
String cond3_code = (String)request.getAttribute("cond3_code"); // 조회된 결과
String cond3_name = (String)request.getAttribute("cond3_name"); // 조회된 결과
String cond4_code = (String)request.getAttribute("cond4_code"); // 조회된 결과
String cond4_name = (String)request.getAttribute("cond4_name"); // 조회된 결과

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfoPop.getComCode()); 
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
String st_remark = CommonUtil.nvl((String) request.getParameter("st_remark"),"");  //  (조회조건)
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
var st_ref_pr_no_text = "";
var popupSel = "";
var st_buyer = "<%=st_buyer%>";

function kep_onload_view(){
	
<%-- 	//라디오데이터 셋팅	cond0 - 회계단위(C021), cond1 - 원가(M014) FLAG값 Y인 경우만 보여줌  --%>
	kepAjaxCommonQueryIdRadioMedium_v2("cont_st_cond0","common.mpso.selectUOACombo","st_cond0","<%=cond0_code%>", st_buyer);
	kepAjaxCommonQueryIdRadioMedium_v2("cont_st_cond1","common.mpso.selectCostCombo","st_cond1","<%=cond1_code%>", st_buyer);
}
//코스트센터 팝업
function getCond2Pop(){
	popupSel = "COND2";
	
	var st_gbn = "<%=CommonLang.get("HTITLE1265")%>"; //코스트센터
	var st_type = "C020";
	var st_code = "";
	var st_text = "";
	
    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "700,510,no");		
}

// 프로젝트코드 팝업
function getCond4Pop(){
	popupSel = "COND4";
	
	var st_gbn = "<%=CommonLang.get("HTITLE1341")%>"; //프로젝트코드
	var st_type = "C022";
	var st_code = "";
	var st_text = "";

    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "700,510,no");		
}

//계정코드 팝업
function getCond3Pop(){
	popupSel = "COND3";
	
	openSearchPopup("/coco/showCommonCoCoAccountPop.do", "?open=Y&st_com_code="+st_buyer, "480,500,no");
}


function setReturn(){
	if(set_ref_pr_no()){
		var cond5 = document.forms.searchForm.st_remark.value;
		
		if (!fnCheckInputByteStr(cond5, 400)) {
			//용도는 영문 400자, 한글 200자 까지 입력할수 있습니다.
			var text = "<%=CommonLang.msg("MSG814")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		var tab_id = "<%=st_tab_id%>";
		var st_row = "<%=st_row%>";
		if(tab_id == ""){
			opener.setPopupReturn(st_row,st_ref_pr_no, cond5);
		}else{
			opener.tabs[tab_id]["setPopupReturn"](st_row,st_ref_pr_no, cond5);
		}
		
		this.close();	
	}	
}

function set_ref_pr_no(){
	var cond0 = "";
	var cond1 = "";
	var cond2 = "";
	var cond3 = "";
	var cond4 = "";
	var cond0_name = "";
	var cond1_name = "";
	var cond2_name = "";
	var cond3_name = "";
	var cond4_name = "";
	
	cond0 = document.forms.searchForm.st_cond0.value;
	cond1 = document.forms.searchForm.st_cond1.value;
	cond2 = document.forms.searchForm.st_cond2_code.value;
	cond3 = document.forms.searchForm.st_cond3_code.value;
	cond4 = document.forms.searchForm.st_cond4_code.value;
	
	cond0_name = $("#st_cond0 option:selected").text();
	cond1_name = $("#st_cond1 option:selected").text();
	cond2_name = document.forms.searchForm.st_cond2_name.value;
	cond3_name = document.forms.searchForm.st_cond3_name.value;
	cond4_name = document.forms.searchForm.st_cond4_name.value;
	
	if(cond1 == "" || cond2 == "" || cond3 == "" || cond0 == ""){
		//필수입력 사항을 선택하여 주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG815")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return false;
	}

	st_ref_pr_no = cond0 + "^" + cond1 + "^" + cond2 + "^" + cond3 + "^" + cond4;
	remark = document.forms.searchForm.st_remark.value;
	return true;
}

function setPopupReturn(value1,value2,value3){
	if(popupSel == "COND2"){
		document.forms.searchForm.st_cond2_code.value = value2;
		document.forms.searchForm.st_cond2_name.value = value3;
	}else if(popupSel == "COND3"){
		document.forms.searchForm.st_cond3_code.value = value1;
		document.forms.searchForm.st_cond3_name.value = value2;
	}else if(popupSel == "COND4"){
		document.forms.searchForm.st_cond4_code.value = value2;
		document.forms.searchForm.st_cond4_name.value = value3;
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<div class="wrapPopup"  >
<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">

  <div class="PopupTit"><%=st_title %></div>
  <table  class="PopupSearchTableNoline mt10" width="100%" >
	<colgroup>
      <col width="185px" />
      <col width="495px" />
	</colgroup>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1339")%><!--회계단위--></th>
      <td>
      	<div id = "cont_st_cond0"></div>
      </td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1340")%><!--원가--></th>
      <td>
      <div id = "cont_st_cond1"></div>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE1265")%><!-- 코스트센터 --></th>
      <td ><div class="SearchPopupInput38" style="width:168px; display:inline-block">
        <input type="text" name="st_cond2_code" id="st_cond2_code" style=" width:85%; " value="<%=cond2_code%>" readonly>
        <button type="button" onclick="javascript:getCond2Pop(); return false;"></button>
      </div> <input class="input40" style="width:295px" name="st_cond2_name" id="st_cond2_name" type="text" value="<%=cond2_name%>" readonly /></td>
    </tr>
    <tr>
      <th><span class="F6495F">*</span> <%=CommonLang.get("HTITLE428")%><!-- 계정 --></th>
      <td><div class="SearchPopupInput38" style="width:168px; display:inline-block">
        <input type="text" name="st_cond3_code" id="st_cond3_code" style=" width:85%; " value="<%=cond3_code%>" readonly>
        <button type="button" onclick="javascript:getCond3Pop(); return false;"></button>
      </div> <input class="input40" style="width:295px" name="st_cond3_name" id="st_cond3_name" type="text" value="<%=cond3_name%>" readonly/></td>
    </tr>
    <tr>
      <th><span class="f2f7ff">*</span> <%=CommonLang.get("HTITLE1341")%><!--프로젝트코드--></th>
      <td><div class="SearchPopupInput38" style="width:168px; display:inline-block">
        <input type="text" name="st_cond4_code" id="st_cond4_code" style=" width:85%; " value="<%=cond4_code%>" readonly>
        <button type="button" onclick="javascript:getCond4Pop(); return false;"></button>
      </div> <input class="input40" style="width:295px" name="st_cond4_name" id="st_cond4_name" type="text" value="<%=cond4_name%>" readonly/></td>
    </tr>
    <tr>
      <th><span class="f2f7ff">*</span>  <%=CommonLang.get("HTITLE122")%><!-- 비고 --><br /><span class="f2f7ff">*</span>  <%=CommonLang.get("HTITLE1342")%><!--(연구소/개발프로젝트명)--></th>
      <td colspan="3"><input class="input40" style="width:469px" name="st_remark"  id="st_remark" maxlength="400" type="text" value="<%=st_remark%>"/></td>
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
