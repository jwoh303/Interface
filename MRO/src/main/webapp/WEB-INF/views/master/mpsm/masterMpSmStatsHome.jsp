<%--
**********************************************
* 메뉴 : 고객사 > 관리자 > 통계 > 실적조회
* 화면 : 실적조회
* 기능 : 
* 프로그램 ID : 
* 담당자 :  ( 설계 : 공통 )
* 착수일 : 2017-08-10
**********************************************
--%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String year = CommonUtil.formatDate(new Date(), CommonUtil.YYYYMMDD).substring(0,4);

//고객사 그룹통합여부 여부
String st_user_id = _sessionInfo.getUserId();
String buyer = _sessionInfo.getComCode();

boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, buyer);
String group_mng_flag = "N";
String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_com_code2"),"");  // 계열사정보
if(getCodeTGCM == true){
	group_mng_flag = "Y"; 
}
%>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {FrozenCol:0};
	initsheet.Cols = [
						 { Align:"Left",		Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"사업장명",	SaveName:"BUYER_NAME"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분",			SaveName:"GUBUN"}
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"계",			SaveName:"AMT_YEAR"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"1월",			SaveName:"AMT_01"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"2월",			SaveName:"AMT_02"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"3월",			SaveName:"AMT_03"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"4월",			SaveName:"AMT_04"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"5월",			SaveName:"AMT_05"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"6월",			SaveName:"AMT_06"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"7월",			SaveName:"AMT_07"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"8월",			SaveName:"AMT_08"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"9월",			SaveName:"AMT_09"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"10월",		SaveName:"AMT_10"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"11월",		SaveName:"AMT_11"}
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"12월",		SaveName:"AMT_12"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	kepAjaxCommonQueryIdSearchTwoCombo('st_from_year','yearCodeList','03','','SEL', '<%=year%>');
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 // 조회
			if(isEmpty($("#st_from_year").val())){
				alert("<%=CommonLang.msg("MSG302")%>");	//기준년도를 선택하세요.
				$("#st_from_year").focus();
				return;
			}
	
			var st_re_flag = "1";
			var st_po_flag = "1";
			var st_gr_flag = "1";
			var st_ar_ap_flag = "1";
			
			if(document.getElementById("chk_re_flag").checked == true){
				st_re_flag = "1";
			}else{
				st_re_flag = "0";
			}
			
			if(document.getElementById("chk_po_flag").checked == true){
				st_po_flag = "1";
			}else{
				st_po_flag = "0";
			}
			
			if(document.getElementById("chk_gr_flag").checked == true){
				st_gr_flag = "1";
			}else{
				st_gr_flag = "0";
			}
			
			if(document.getElementById("chk_ar_ap_flag").checked == true){
				st_ar_ap_flag = "1";
			}else{
				st_ar_ap_flag = "0";
			}
			
			$('#st_chk_re_flag').val(st_re_flag);
			$('#st_chk_po_flag').val(st_po_flag);
			$('#st_chk_gr_flag').val(st_gr_flag);
			$('#st_chk_ar_ap_flag').val(st_ar_ap_flag);
			
			var st_chk_flag = st_re_flag + st_po_flag + st_gr_flag + st_ar_ap_flag;
			
			document.forms.searchCondition.st_chk_flag.value = st_chk_flag;
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpsm/getMasterMpSmWarhsngResultList.do" , pagingMode );
		break;
		
	case "kep_reload":	 //초기화
		kepReload('searchCondition');
	
		document.forms.searchCondition.st_chk_re_flag.value = "1";
		document.forms.searchCondition.st_chk_po_flag.value = "1";
		document.forms.searchCondition.st_chk_gr_flag.value = "1";
		document.forms.searchCondition.st_chk_ar_ap_flag.value = "1";
		
		document.forms.searchCondition.st_chk_flag.value = "1111";
		document.forms.searchCondition.st_from_year.value = "<%=year%>";
		
		mySheet.RemoveAll();
		break; 
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
}

$(window).resize(function() { // 화면 리사이즈시 다시검사....
	var winWidth = $(window).width();
	//alert(winWidth);
	if (winWidth < 1200) {
		$(".divGridArea").css("width", "995px");
	} else  {
		$(".divGridArea").css("width", "97%");		
	}  
});
</script>
</head>

<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<form name = "searchCondition" method = "post">
	<div id="ContArea" class="divGridArea" style="min-height: 230px;">
	<h3><%=CommonLang.get("HTITLE401") %><!-- 실적조회 --></h3>
    <div id="searchBtnA">
		<!--버튼영역-->
        	<span class="btn_search"><a href="javascript:doAction('search')"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
        	<span class="btn_reset" title="초기화"><a href="javascript:doAction('kep_reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
   		</div>        	
        <!--조회영역-->
			<div id="cont_searchA" class="divGridArea">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" id="onepagerow" name="onepagerow" value="100">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		    <input type="hidden" name="st_chk_flag" id="st_chk_flag" value="1111">
		    <input type="hidden" name="st_chk_re_flag" id="st_chk_re_flag" value="1">
		    <input type="hidden" name="st_chk_po_flag" id="st_chk_po_flag" value="1">
		    <input type="hidden" name="st_chk_gr_flag" id="st_chk_gr_flag" value="1">
		    <input type="hidden" name="st_chk_ar_ap_flag" id="st_chk_ar_ap_flag" value="1">
    
            	<table  class="cont_t_list01" style="width:100%;">
					<caption><%=CommonLang.get("HTITLE401") %><!-- 실적조회 --></caption>
					<colgroup>
						<col width="5%" />
						<col width="10%" />
						<col width="5%" />
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE402") %><!-- 기준년도 --></td>
							<td>
								<select id="st_from_year" name="st_from_year" style="width:100px;height:20px"></select>
							</td>
							
						<%if(group_mng_flag.equals("Y")){%>
							<td><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></td>
							<td>
								<select name="st_com_code2" id="st_com_code2" style="width:180px;height:20px;">
									<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
						        </select>
							</td>
						<%}else{%>
							<td></td>
							<td ><input type="hidden" name="st_com_code2" id="st_com_code2" value="${sessionInfo.comCode}"></td>
						<%}%>
						
							<td colspan="2">
								<input type="checkbox" class="Noborder" id="chk_re_flag" name="chk_re_flag" checked="checked"/>&nbsp;<%=CommonLang.get("HTITLE403") %><!-- 견적 -->&nbsp;&nbsp; 
								<input type="checkbox" class="Noborder" id="chk_po_flag" name="chk_po_flag" checked="checked"/>&nbsp;<%=CommonLang.get("HTITLE162") %><!-- 발주 -->&nbsp;&nbsp;
								<input type="checkbox" class="Noborder" id="chk_gr_flag" name="chk_gr_flag" checked="checked"/>&nbsp;<%=CommonLang.get("HTITLE270") %><!-- 입고 -->&nbsp;&nbsp;
								<input type="checkbox" class="Noborder" id="chk_ar_ap_flag" name="chk_ar_ap_flag" checked="checked"/>&nbsp;<%=CommonLang.get("HTITLE404") %><!-- 마감 -->&nbsp;&nbsp;
							</td>
						</tr>
					</tbody>
				</table>
            </div>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "360px");
			</script>
		</div>
<!--내용 종료-->	
		</div>
	</form>
	</div>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
</div>
</body>
</html>
