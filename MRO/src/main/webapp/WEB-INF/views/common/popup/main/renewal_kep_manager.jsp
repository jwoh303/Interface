<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="java.util.*"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<title>가입 승인 담당자 찾기</title>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<link rel="stylesheet" type="text/css" href="/resources/css/buyer_base.css" />
<link rel="stylesheet" type="text/css" href="/resources/css/main_com.css" />

</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
int company_cnt = 0;
if(_dataList != null && _dataList.size()>0){
	company_cnt = _dataList.size();
}
String h_irs_no1 = CommonUtil.nvl((String) request.getParameter("h_irs_no1"),"");  //  (조회조건) 
String h_irs_no2 = CommonUtil.nvl((String) request.getParameter("h_irs_no2"),"");  //  (조회조건) 
String h_irs_no3 = CommonUtil.nvl((String) request.getParameter("h_irs_no3"),"");  //  (조회조건) 
String business_cond = CommonUtil.nvl((String) request.getParameter("business_cond"),"");  //  (조회조건)
String init = CommonUtil.nvl((String) request.getParameter("init"),"Y");  //  (조회조건) 
%>
<script type="text/javascript">
//최초 화면 함수 
function kep_onload_view(){	
	<%if(init.equals("Y")){%>
	
	<%}else{%>
		$("#companyInfo").show();
		var company_cnt = "<%=company_cnt%>";
		if(company_cnt == "0"){
			$("#companyInfo").html("<%=CommonLang.msg("MSG1003")%>"); //검색 결과가 없습니다.
			return;
		}else if(company_cnt == "1"){
			<%if(_dataList != null && _dataList.size()>0){%>
			$("#companyDtInfo1").show();
			$("#companyDtInfo1").html('<%=_dataList.get(0).get("COM_CODE")%> / <%=_dataList.get(0).get("COM_NAME_LOC")%>');
			$("#comCode").val("<%=_dataList.get(0).get("COM_CODE")%>");
			kepAjaxFormCallNoBar("/common/getKepManager_v2.do","kepManagerPop","getKep");
			<%}%>
		}else{	
			<%if(_dataList != null && _dataList.size()>0){%>
// 				$("#companyInfo").html("");
				$("#companyDtInfo").show();
				<%for(int i =0; i<company_cnt; i++){%>
					var htmlTmp = "";
					<%if(i == 0){%>
						htmlTmp = "<option value='"+"<%=_dataList.get(i).get("COM_CODE")%>"+"' selected>"+'<%=_dataList.get(i).get("COM_CODE")%> / <%=_dataList.get(i).get("COM_NAME_LOC")%>'+"</option>";
					<%}else{%>
						htmlTmp = "<option value='"+"<%=_dataList.get(i).get("COM_CODE")%>"+"'>"+'<%=_dataList.get(i).get("COM_CODE")%> / <%=_dataList.get(i).get("COM_NAME_LOC")%>'+"</option>";
					<%}%>
					$("#companyDtInfo").append(htmlTmp);
				<%}%>
				companySel();
			<%}%>
		}
	<%}%>
	
}

function doAction(str){
	switch (str) {
	case "search":
		
		if( isEmpty($("input[name=h_irs_no1]").val()) || isEmpty($("input[name=h_irs_no2]").val()) || isEmpty($("input[name=h_irs_no3]").val()) ) {
			alert("<%=CommonLang.msg("MSG1004")%>"); //사업자번호를 입력해주시기 바랍니다.
			return;
		}else{
			if($("#h_irs_no1").val().length != 3 || $("#h_irs_no2").val().length != 2 || $("#h_irs_no3").val().length != 5){ //3,2,5 자리가 아닌 경우
				alert("<%=CommonLang.msg("MSG1005")%>"); //사업자번호를 정확하게 입력해주시기 바랍니다.
				return;
			}
		}
		$("#init").val("N");
		$("#companyDtInfo1").hide();
		$("#companyDtInfo1").html("");
		$("#companyDtInfo").hide();
		$("#kepManagerInfo").hide();
		$("#kepManagerDtInfo").html("");
		$('#kepManagerPop').attr("action", "/common/getCompanyInfo_v2.do").submit();
		break;
	}
}
function companySel(){
	var com_code = $("#companyDtInfo").val();
	$("#comCode").val(com_code);
	kepAjaxFormCallNoBar("/common/getKepManager_v2.do","kepManagerPop","getKep");
}

function kepAjaxSuccess(pMethod , response){
	if(pMethod == "getKep"){
		var data = response.data;
		if(data.length > 0){
			$("#kepManagerDtInfo").html("<%=CommonLang.get("HTITLE803")%>"+" : "+data[0].USER_NAME_LOC+" ("+data[0].PHONE_NUMBER+")"); //담당자 : 
			$("#kepManagerInfo").show();
		}else{
			$("#kepManagerDtInfo").html("<%=CommonLang.msg("MSG1006")%>");//담당자가 없습니다.
			$("#kepManagerInfo").show();
		}
	}	
}

function  kepAjaxError(pMethod , response) {
	if(pMethod == "getKep"){
		alert("<%=CommonLang.msg("MSG14")%>"); //처리중 오류가 발생 하였습니다.확인 후 다시 시도하여 주십시요
		return;
	}
}
</script>
<body onload="kep_onload_view()">
<div class="wrapPopup"  >
<form name="kepManagerPop" id="kepManagerPop" method="post" >
<input type="hidden" name="business_cond" id="business_cond"  value="<%=business_cond%>">
<input type="hidden" name="init" id="init"  value="<%=init%>">
<input type="hidden" name="comCode" id="comCode"  value="">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1533")%><!-- 가입 승인 담당자 찾기 --></div>
  <div class="Popup_GrayBox"><%=CommonLang.msg("MSG1007")%><!-- 승인 담당자를 확인하기 위해, 귀사의 사업자등록 번호를 입력해주세요 -->  </div>
  <div class="mt10" style="text-align:center">
    <input class="input42" maxlength="3" style="width:80px"  name="h_irs_no1" id="h_irs_no1" value="<%=h_irs_no1 %>" type="text" onkeydown="kepEnter()" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/> - 
    <input class="input42" maxlength="2" style="width:80px"  name="h_irs_no2" id="h_irs_no2" value="<%=h_irs_no2 %>" type="text" onkeydown="kepEnter()" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/> - 
    <input class="input42" maxlength="5" style="width:80px"  name="h_irs_no3" id="h_irs_no3" value="<%=h_irs_no3 %>" type="text" onkeydown="kepEnter()" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
    <button class="ButDarkGray_Medium"  style=" width:100px" onclick="javascript:doAction('search');return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>   
  </div>
  <div class="Popup_BlueBox mt20 ac font500 " id="companyInfo" style="display: none;">
  	<span id="companyDtInfo1" style="display: none;"></span>
  	<select name="companyDtInfo" id="companyDtInfo" class="Select40" style="width:95%; display: none;" onchange="javascript:companySel();">
<!--      <option value="">고객사명 : 고객사 코드</option> -->
    </select>
  </div>
  <div class="UserCheckBoxIn-Popup mt20 pt20" id="kepManagerInfo" style="display: none;"><img src="/resources/imgs/Check_blue_big.png" /><span id="kepManagerDtInfo"></span></div> 
</form> 
</div><!-- wrapPopup 끝-->  

</body>
</html>
