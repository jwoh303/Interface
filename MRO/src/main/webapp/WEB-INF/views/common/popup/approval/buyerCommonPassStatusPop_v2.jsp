<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재현황보기
* 기능 : 결재현황보기
* 프로그램 ID : BU0701005
* 담당자 : 최찬규
* 착수일 : 2026-02-02
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String _CRUD =  CommonUtil.nvl((String)request.getAttribute("CRUD")); // 조회된결과
String COMPANY = CommonUtil.nvl((String) request.getParameter("COMPANY"),"");  //  (조회조건)
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");  //  (조회조건)
String TITLE = CommonUtil.nvl((String) request.getParameter("title"),"");  //  (조회조건)
String TYPE = CommonUtil.nvl((String) request.getParameter("type"),"");  //  (조회조건)

%>
<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N";


function setQuery()
{     
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
			,{ Align:"Center",	SaveName:"ORDER_NO",			Header:"<%=CommonLang.get("HTITLE140")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false} /*순번*/
			,{ Align:"Center",	SaveName:"PASS_TP_TEXT",		Header:"<%=CommonLang.get("HTITLE306")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false} /*유형*/
			,{ Align:"Center",	SaveName:"PASS_TP",				Header:"<%=CommonLang.get("HTITLE306")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true} /*유형*/
			,{ Align:"Center",	SaveName:"USER_NM",				Header:"<%=CommonLang.get("HTITLE325")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*이름*/
			,{ Align:"Center",	SaveName:"USER_POS",			Header:"<%=CommonLang.get("HTITLE476")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*직급*/
			,{ Align:"Center",	SaveName:"USER_DEPT",			Header:"<%=CommonLang.get("HTITLE329")%>",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*부서*/
			,{ Align:"Center",	SaveName:"PASS_KN",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*상태*/
			,{ Align:"Center",	SaveName:"REFER_DATE",			Header:"<%=CommonLang.get("HTITLE1048")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*열람일시*/
			,{ Align:"Center",	SaveName:"PASS_DATE",			Header:"<%=CommonLang.get("HTITLE1049")%>",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*결재일시*/
			,{ Align:"Left",	SaveName:"PASS_ADD",			Header:"<%=CommonLang.get("HTITLE1050")%>",				Type:"Text",		Width:220,	Edit:false,	EditLen:100,	Hidden:false}/*결재자의견*/
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.buyerCommonPassStatusPop, mySheet, "/common/approval/getCommonApprovalListPop_v2.do" , pagingMode);
	
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var flag = false; //반려여부
	for(var i = 1; i<=mySheet.RowCount(); i++){
		if(flag){
			mySheet.SetCellFontColor(i,"PASS_KN","#BDBDBD"); //반려 이후는 회색처리
		}
		if(mySheet.GetCellValue(i,"PASS_KN") == "결재반려"){
			flag = true;
		}
	}
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
</script> 
<body onload="setQuery()">
	 <form name=buyerCommonPassStatusPop id=buyerCommonPassStatusPop method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="VIEW" id="VIEW"  value="buyerCommonPassStatusPop_v2"> 
	  <input type="hidden" name="COMPANY" id="COMPANY"  value="<%=COMPANY%>">
	  <input type="hidden" name="DOCU_NO" id="DOCU_NO"  value="<%=DOCU_NO%>">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1051")%><!--결재진행현황--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopTableThL1TdL" width="100%">
    <colgroup>
      <col width="15%" />
      <col width="35%" />
      <col width="15%" />
      <col width="35%" />
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE304") %><!-- 제목 --></th>
      <td><%=TITLE %></td>
      <th><%=CommonLang.get("HTITLE770") %><!-- 결재대상 --></th>
      <td><%=TYPE %></td>
    </tr>
  </table>
  </br>
  <div class="IBSheetBuyer" style="height:247px; width: 1070px;" >
   	 <script type="text/javascript">
       	createIBSheet("mySheet", "", "100%");
     </script>
  </div><!--IBSheetBuyer 끝 -->
	<div class="h50"></div> 
  <div class="PopupListBtnBox_Center mt20" ><button class="ButPrimary_large"  onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button></div>  
</div><!-- warp 끝-->
</form> 
</body>
</html>
