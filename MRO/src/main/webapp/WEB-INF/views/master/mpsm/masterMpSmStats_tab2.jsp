<%--
**********************************************
* 메뉴 : 실적/정산현황
* 화면 : 실적조회 탭
* 기능 : 실적조회 탭
* 프로그램 ID : 
* 담당자 : 최찬규  
* 착수일 : 2026-05-13
**********************************************
--%> 
<%@ page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<%
SessionInfo _sessionInfoStat = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String year = CommonUtil.formatDate(new Date(), CommonUtil.YYYYMMDD).substring(0,4);

//고객사 그룹통합여부 여부
String st_user_id = _sessionInfoStat.getUserId();
String buyer = _sessionInfoStat.getComCode();

boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, buyer);
String group_mng_flag = "N";
String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_com_code2"),"");  // 계열사정보
if(getCodeTGCM == true){
	group_mng_flag = "Y"; 
}

//엑셀다운로드 기능 통제
boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");

%>
<script type="text/javascript">
var mySheet3 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.masterMpSmStats_tab2 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.masterMpSmStats_tab2.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	init:function(){
		
		var initsheet3 = {};
		initsheet3.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet3.Cols = [
				 { Align:"Left",		Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE405")%>",	SaveName:"BUYER_NAME"}/*사업장명*/
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"<%=CommonLang.get("HTITLE314")%>",			SaveName:"GUBUN"}/*구분*/
						,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"<%=CommonLang.get("HTITLE406")%>",			SaveName:"AMT_YEAR"}/*계*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"1<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_01"}/*1월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"2<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_02"}/*2월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"3<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_03"}/*3월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"4<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_04"}/*4월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"5<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_05"}/*5월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"6<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_06"}/*6월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"7<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_07"}/*7월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"8<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_08"}/*8월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"9<%=CommonLang.get("HTITLE427")%>",			SaveName:"AMT_09"}/*9월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"10<%=CommonLang.get("HTITLE427")%>",		SaveName:"AMT_10"}/*10월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"11<%=CommonLang.get("HTITLE427")%>",		SaveName:"AMT_11"}/*11월*/
						,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"12<%=CommonLang.get("HTITLE427")%>",		SaveName:"AMT_12"}/*12월*/
		];
		
		
		IBS_InitSheet(mySheet3, initsheet3, this.pagingMode);
		
		mySheet3.SetHighlightAfterSort(2);
		
		mySheet3.SetHeaderBackColor("#f2f7ff");
		mySheet3.SetTheme("DB", "DeepBlue");
		
		
		kepAjaxCommonQueryIdSearchTwoCombo('st_from_year_2','yearCodeList','03','','SEL', '<%=year%>');
	},
	
	search:function(){
		if(isEmpty($("#st_from_year_2").val())){
			//기준년도를 선택하세요.
			var text = "<%=CommonLang.msg("MSG302")%>";
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			$("#st_from_year_2").focus();
			return;
		}

		var st_re_flag = "1";
		var st_po_flag = "1";
		var st_gr_flag = "1";
		var st_ar_ap_flag = "1";
		
		if(document.getElementById("chk_re_flag_2").checked == true){
			st_re_flag = "1";
		}else{
			st_re_flag = "0";
		}
		
		if(document.getElementById("chk_po_flag_2").checked == true){
			st_po_flag = "1";
		}else{
			st_po_flag = "0";
		}
		
		if(document.getElementById("chk_gr_flag_2").checked == true){
			st_gr_flag = "1";
		}else{
			st_gr_flag = "0";
		}
		
		if(document.getElementById("chk_ar_ap_flag_2").checked == true){
			st_ar_ap_flag = "1";
		}else{
			st_ar_ap_flag = "0";
		}
		
		$('#st_chk_re_flag_2').val(st_re_flag);
		$('#st_chk_po_flag_2').val(st_po_flag);
		$('#st_chk_gr_flag_2').val(st_gr_flag);
		$('#st_chk_ar_ap_flag_2').val(st_ar_ap_flag);
		
		var st_chk_flag = st_re_flag + st_po_flag + st_gr_flag + st_ar_ap_flag;
		
		document.forms.searchCondition2.st_chk_flag.value = st_chk_flag;
		
		kepSearch_v2(document.searchCondition2, mySheet3, "/mpsm/getMasterMpSmWarhsngResultList.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition2');
		mySheet3.RemoveAll();
		document.forms.searchCondition2.st_chk_re_flag.value = "1";
		document.forms.searchCondition2.st_chk_po_flag.value = "1";
		document.forms.searchCondition2.st_chk_gr_flag.value = "1";
		document.forms.searchCondition2.st_chk_ar_ap_flag.value = "1";
		
		document.forms.searchCondition2.st_chk_flag.value = "1111";
		document.forms.searchCondition2.st_from_year.value = "<%=year%>";
		
	},
	doAction:function(str,value1,value2,value3){
		switch (str) {
		default:
			break;
		}
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	}
};
//조회 후처리
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.masterMpSmStats_tab2.but1text,tabs.masterMpSmStats_tab2.but1func,tabs.masterMpSmStats_tab2.but1width);
	}
	
}
//그리드 표시후 처리	 
function mySheet3_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

</script>
<form id="searchCondition2" name="searchCondition2" method="post">
		<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag_2" name="pageflag" value="1">
			<input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=request.getParameter("rowCnt")%>">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id_2" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code_2" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag_2" value="<%=group_mng_flag%>">
		    <input type="hidden" name="st_chk_flag" id="st_chk_flag_2" value="1111">
		    <input type="hidden" name="st_chk_re_flag" id="st_chk_re_flag_2" value="1">
		    <input type="hidden" name="st_chk_po_flag" id="st_chk_po_flag_2" value="1">
		    <input type="hidden" name="st_chk_gr_flag" id="st_chk_gr_flag_2" value="1">
		    <input type="hidden" name="st_chk_ar_ap_flag" id="st_chk_ar_ap_flag_2" value="1">

	<div id="Search2" class="SearchContent">
      <table class="TabSearchTable" >
        <colgroup>
          <%if(group_mng_flag.equals("Y")){%>
          	<col width="70px" />
          	<col width="160px" />
          	<col width="70px" />
          	<col width="160px" />
          	<col width="820px" />
          <%}else{ %>
          	<col width="70px" />
          	<col width="1210px" />
          <%} %>
          
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE402") %><!-- 기준년도 --></th>
          <td>
            <select name="st_from_year" id="st_from_year_2" class="Select40" style="float:left;width:140px; margin-right:30px">
            </select>
            <%if(group_mng_flag.equals("Y")){%>
            </td>
	           	<th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
	           	<td><select name="st_com_code2" id="st_com_code2_2" class="Select40" style="float:left;width:140px; margin-right:30px">
	           			<%= CommonUtil.getCode3ComboList(_sessionInfoStat.getComCode(), "ALL", "TGCM",_sessionInfoStat.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
	           		</select>
	           	</td>
	           	<td>
            <%}else{ %>
            	<input type="hidden" name="st_com_code2" id="st_com_code2_2" value="${sessionInfo.comCode}">
            <%} %> 
            <label class="CheckLargeLabel"><input type="checkbox" id="chk_re_flag_2" name="chk_re_flag" checked="checked"><span class="CheckLargeCustom"></span><%=CommonLang.get("HTITLE403") %><!-- 견적 --></label>
            <label class="CheckLargeLabel"><input type="checkbox" id="chk_po_flag_2" name="chk_po_flag" checked="checked"><span class="CheckLargeCustom"></span><%=CommonLang.get("HTITLE162") %><!-- 발주 --></label>
            <label class="CheckLargeLabel"><input type="checkbox" id="chk_gr_flag_2" name="chk_gr_flag" checked="checked"><span class="CheckLargeCustom"></span><%=CommonLang.get("HTITLE270") %><!-- 입고 --></label>
            <label class="CheckLargeLabel"><input type="checkbox" id="chk_ar_ap_flag_2" name="chk_ar_ap_flag" checked="checked"><span class="CheckLargeCustom"></span><%=CommonLang.get("HTITLE404") %><!-- 마감 --></label>
          	</td>
		</tr>               
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.masterMpSmStats_tab2.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.masterMpSmStats_tab2.search(); return false;"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button> 
      </div>
      <div class="IBSheetBuyer mt30 mb10" style="border:1px solid #eee; background-color:#fff; height:400px;background-color:#f6f5f6">
      	<script type="text/javascript">
			createIBSheet("mySheet3", "100%", "100%");
		</script>
      </div><!--IBSheetBuyer 끝 --> 
      <div class="h50"></div>        
    </div><!--Tab1끝 -->
</form> 