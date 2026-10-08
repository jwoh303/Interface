<%--
**********************************************
* 메뉴 : 주문요청처리 > 수령희망일 변경
* 화면 : 수령희망일 변경 팝업
* 기능 : 수령희망일을 일괄 변경한다.
* 프로그램 ID : BU0501009
* 담당자 : 최찬규
* 착수일 : 2026-04-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
</head>
<%

String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),""); // tab_id
String info = CommonUtil.nvl((String)request.getParameter("info"), ""); //이전 페이지에서 넘겨온 대상 품목 데이터들
if(info == null) info = "[]"; //null 방지

%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

function init(){
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			  { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"PR_NO",		Header:"<%=CommonLang.get("HTITLE1179")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*주문요청번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
				,{ Align:"Right",	SaveName:"TARGET_QTY",				Header:"<%=CommonLang.get("HTITLE651")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*요청수량*/
				,{ Align:"Right",	SaveName:"RECV_QTY",				Header:"<%=CommonLang.get("HTITLE242")%>",				Type:"Float",		Width:90,	Edit:true,	EditLen:100,	Hidden:false}/*승인수량*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"AMT",				Header:"<%=CommonLang.get("HTITLE1059")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*주문금액*/
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHighlightAfterSort(2);
	mySheet.SetHeaderBackColor("#f2f7ff");	
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	var infoList = <%=info%>;
	
	mySheet.RenderSheet(0);
	for(var i = 0; i<infoList.length; i++){
		// 대상품목 그려주기
		var newIndex = 0;
		newIndex = mySheet.DataInsert(-1);
		mySheet.SetCellValue(newIndex, "PR_NO", infoList[i].PR_NO);
		mySheet.SetCellValue(newIndex, "BUYER_ITEM_NO", infoList[i].BUYER_ITEM_NO);
		mySheet.SetCellValue(newIndex, "DESCRIPTION", infoList[i].DESCRIPTION);
		mySheet.SetCellValue(newIndex, "UNIT_PRICE", infoList[i].UNIT_PRICE);
		mySheet.SetCellValue(newIndex, "TARGET_QTY", infoList[i].TARGET_QTY);
		mySheet.SetCellValue(newIndex, "RECV_QTY", infoList[i].RECV_QTY);
		mySheet.SetCellValue(newIndex, "UNIT_MEASURE", infoList[i].UNIT_MEASURE);
		mySheet.SetCellValue(newIndex, "AMT", infoList[i].AMT);
	}
	mySheet.RenderSheet(1);
	
	
	$("#itemCnt").html("("+mySheet.RowCount()+")");
}

//납품예정일 변경에 따른 이벤트
function dateCheck(){
	var st_rd_date = $("#st_rd_date").val().replace(/[/]/gi,"");
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	
	if(st_rd_date < cur_date){
// 		금일 날짜 이후로 선택해주세요
		var text = "<%=CommonLang.msg("MSG791")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_rd_date").val("");
		return;
	}
}
function confirm(){
	var st_rd_date = $("#st_rd_date").val().replace(/[/]/gi,"");
	var tab_id = "<%=tab_id%>";
	opener.tabs[tab_id]["setPopupReturn"](st_rd_date);
	self.close();
}


</script> 
<body onload="init()">
<form name="buyerMpPoRejectReasonPop" id="buyerMpPoRejectReasonPop" method=post > 
	
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1251")%><!--수령희망일 일괄등록--><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Importance_Popup_red01 mt10"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG792")%><!--입력한 수령희망일이 선택한 모든 항목에 일괄 적용됩니다.--></div>
  <div class="Popup_GrayBox mt10">
    <table class="TableNoLine">
      <tr>
        <th><div class="tit mr30" ><%=CommonLang.get("HTITLE831")%><!-- 수령희망일 --></div></th>
        <td><div class="datepicker-wrap" style="width:130px;height:35px;border-radius:6px;"><div class="date-input" style="width:125px" data-datepicker><input type="text" placeholder="" id="st_rd_date" name="st_rd_date"  readonly onchange="javascript:dateCheck();" /><span> </span></div></div></td>
      </tr>
    </table>
  </div>   
  <div class="PopupTitSub" ><%=CommonLang.get("HTITLE1252")%><!--대상품목--><p style="display:inline-block; margin-left:5px" id="itemCnt"></p> </div>  
  <div class="ScrollBox " style="height:169px">
       	<script type="text/javascript">
          	createIBSheet("mySheet", "", "100%");
        </script>
  </div>   
  <div class="PopupListBtnBox_Center mt30">
    <button class="ButQuaternary_large closePopup" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></button>
    <button class="ButPrimary_large" onclick="javascript:confirm();return false;"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></button>
  </div>  
</div><!-- wrapPopup 끝-->
</form> 
</body>
</html>
