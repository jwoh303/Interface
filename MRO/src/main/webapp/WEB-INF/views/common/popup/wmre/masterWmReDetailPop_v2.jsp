<%--
**********************************************
* 메뉴 : 교환/반품현황
* 화면 : 교환/반품현황 상세 팝업
* 기능 : 
* 프로그램 ID : BU0403002
* 담당자 : 최찬규
* 착수일 : 2026-04-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String wmre_no = (String) request.getParameter("WMRE_NO");
%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>

<script>
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

var st;
var mt;
function popupOnload(){
	

	// 조회조건 초기화
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
			 ,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
			 ,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
			 ,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:215,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
			 ,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:260,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
			 ,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
			 ,{ Align:"Right",	SaveName:"WMRE_QTY",				Header:"<%=CommonLang.get("HTITLE45")%>",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*수량*/
			 ,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
			 ,{ Align:"Right",	SaveName:"ITEM_AMT",				Header:"<%=CommonLang.get("HTITLE922")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*합계*/
			 
			 ,{ Align:"Center",	SaveName:"PR_NO",			Header:"PR_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			 ,{ Align:"Center",	SaveName:"PO_NO",			Header:"PO_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			 ,{ Align:"Center",	SaveName:"NAME_FLAG",		Header:"NAME_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			 ,{ Align:"Center",	SaveName:"WMRE_TYPE_NAME",	Header:"WMRE_TYPE_NAME",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			 ,{ Align:"Center",	SaveName:"B_REQ_REMARK",	Header:"B_REQ_REMARK",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			 ,{ Align:"Center",	SaveName:"CANCEL_REMARK",	Header:"CANCEL_REMARK",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	
	kepSearch_v2(document.searchForm ,  mySheet , "/wmre/getMasterWmReExchangeManageList_v2.do" , pagingMode );
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	$("#st_name_flag").html(mySheet.GetCellValue(1,"NAME_FLAG"));
	$("#st_po_no").html(mySheet.GetCellValue(1,"PO_NO"));
	$("#st_wmre_type").html(mySheet.GetCellValue(1,"WMRE_TYPE_NAME"));
	$("#st_req_remark").html(mySheet.GetCellValue(1,"B_REQ_REMARK"));
	$("#st_cancel_remark").html(mySheet.GetCellValue(1,"CANCEL_REMARK"));
}
</script>
<body onload="popupOnload(); ">
<form name = "searchForm"  id = "searchForm" method = "post" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_WMRE_NO"  name="st_WMRE_NO" value="<%=wmre_no%>">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	
	<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1231")%><!--교환/반품상세--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopTableThLTdL" width="100%">
    <colgroup>
      <col width="13%" />
      <col width="20%" />
      <col width="13%" />
      <col width="20%" />
      <col width="13%" />
      <col width="20%" />
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th>
      <td><p class="ChipsLarge_Yellow" style="display:inline-block; margin-left:10px;line-height:13px;" id="st_name_flag"></p></td>
      <th><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
      <td id="st_po_no"></td>
      <th><%=CommonLang.get("HTITLE1213")%><!-- 신청구분 --></th>
      <td id="st_wmre_type"></td>
    </tr>
  </table> 
  <div class="PopupTitSub" ><%=CommonLang.get("HTITLE1104")%><!-- 품목정보 --></div>  
  <div class="ScrollBox " style="height:165px">
   	<script type="text/javascript">
        createIBSheet("mySheet", "", "100%");
    </script>
  </div>  
  <div class="PopupTitSub" ><%=CommonLang.get("HTITLE1229")%><!--교환/반품 사유--></div> 
  <div class="Popup_GrayBox" id="st_req_remark"></div>
  <div class="PopupTitSub" ><%=CommonLang.get("HTITLE1230")%><!--교환/반품 취소사유--></div> 
  <div class="Popup_GrayBox" id="st_cancel_remark"></div>
    
  <div class="PopupListBtnBox_Center mt20" >
    <button class="ButPrimary_large"  onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
  </div>  
</div><!-- warp 끝-->
</form> 
</body>
</html>
