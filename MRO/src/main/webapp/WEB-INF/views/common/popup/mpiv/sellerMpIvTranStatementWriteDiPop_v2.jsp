<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서작성
* 기능 : 거래명세서를 작성하기위한 팝업
* 프로그램 ID : SU0503006
* 담당자 : 최찬규
* 착수일 : 2025-10-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
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
<script src="/resources/js/common.js"></script>
</head>
 
<%
	@SuppressWarnings (value="unchecked")

// 	String p_buyer		= CommonUtil.nvl((String)request.getAttribute("st_buyer"));
// 	String p_gr_flag	= CommonUtil.nvl((String)request.getAttribute("st_gr_flag"));
// 	String p_process_type	= CommonUtil.nvl((String)request.getAttribute("st_process_type"));
// 	String p_buyer_name	= CommonUtil.nvl((String)request.getAttribute("st_buyer_name"));
// 	String p_com_code	= CommonUtil.nvl((String)request.getAttribute("st_com_code"));
	
	String p_buyer		= CommonUtil.nvl((String)request.getParameter("st_buyer"));
	String p_gr_flag	= CommonUtil.nvl((String)request.getAttribute("st_gr_flag"));
	String p_process_type	= CommonUtil.nvl((String)request.getParameter("st_process_type"));
	String p_buyer_name	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String p_com_code	= CommonUtil.nvl((String)request.getParameter("st_com_code"));
	
	// 운영사 업무대행에서 호출시 사용. (p_proxy_yn == Y)
	String p_proxy_yn	= CommonUtil.nvl((String)request.getAttribute("st_proxy_yn"));
	String p_agent	= CommonUtil.nvl((String)request.getAttribute("st_agent"));
	String p_agent_name	= CommonUtil.nvl((String)request.getAttribute("st_agent_name"));
	
	if(p_gr_flag.equals("")){
		p_gr_flag = "GR";
	}
	
	if(!p_proxy_yn.equals("Y")){
		p_agent = p_com_code;
	}
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

//최초 화면 함수 
function init(){
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"LEGACY_PO_NO",		Header:"발주번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"CD_ITEM_QTY",			Header:"납품품목수",			Type:"Int",			Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PO_CREATE_DATE",		Header:"발주일",				Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Left",	SaveName:"PO_NO",				Header:"PO번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Right",	SaveName:"CD_TTL_AMT",			Header:"납품총금액",			Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}
			,{ Align:"Center",	SaveName:"RD_DATE",				Header:"납기요청일",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"PLANT",				Header:"PLANT",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			
			,{ Align:"Center",	SaveName:"TR_BUYER",			Header:"TR_BUYER",			Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER",				Header:"BUYER",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"AGENT",				Header:"PLANT",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CNT_SEQ",				Header:"CNT_SEQ",			Type:"Int",			Width:150,	Edit:false,	EditLen:100,	Hidden:true}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.contentForm, mySheet, "/mpiv/getSellerMpIvTranStatementWriteDiPop_v2.do" , pagingMode);
	
}
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var rowCount = mySheet.RowCount();
	var seq_tot = 0;
	for(var i = 1; i<=rowCount; i++){
		seq_tot += mySheet.GetCellValue(i,"CNT_SEQ");
	}
	if(seq_tot < 100){ //100개 이하면 전체 선택
		for(var i = 1; i<=rowCount; i++){
			mySheet.SetCellValue(i,"SELECTED",true);
		}
	}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
// 납품서 생성
function setDHIMCreate(){

	var tot_cnt  = $("#display_item_cnt").val();
	var po_no = "";
	var query = "";
	var buyer = $("#st_buyer").val();
	var agent = $("#st_agent").val();
	var gr_flag = $("#st_gr_flag").val();
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("항목을 선택하여 주세요.");
		var text = "항목을 선택하여 주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	for(var idx = 0; idx<arrRow.length; idx++){
		po_no	= mySheet.GetCellValue(arrRow[idx],"PO_NO");	//PO번호
		query += "'"+po_no+"',";
	}
	
	query = query.substring(0,query.length-1);
	
	$("#st_query").val(query);
	
	kepAjaxFormCall("/mpiv/getSellerMpIvTranStatementWriteDiPoList.do","contentForm","btnPoSearch");
		
	return;

}


function setPoResult(res){

	//console.log(res);
	
	var proxy_yn = "<%=p_proxy_yn%>";
	
	var agent_name 	= "<%=p_agent_name%>";
	var agent 		= "<%=p_agent%>";
		
	if(proxy_yn != "Y"){
		agent_name 	= $("#st_com_name").val();
		agent 		= $("#st_com_code").val();	
	}
	
	var po_no 		= res.results;
	var portal_user_id	= "20493";
	var portal_password = "20493";
	
//	var loc  = 'http://doowin.doosaninfracore.com/keplogin.do?';
//			loc +=  'agent='+agent+'&agent_name='+agent_name+'&po_no='+po_no+'&portal_user_id='+portal_user_id+'&portal_password='+portal_password;


	//document.agent_invoice_di_pop_c.action = "http://doowin.doosaninfracore.com/keplogin.do";
	//document.agent_invoice_di_pop_c.target = "_blank";
	/*document.agent_invoice_di_pop_c.agent.value = agent;
	document.agent_invoice_di_pop_c.agent_name.value = agent_name;
	document.agent_invoice_di_pop_c.po_no.value = po_no;
	document.agent_invoice_di_pop_c.portal_user_id.value = portal_user_id;
	document.agent_invoice_di_pop_c.portal_password.value = portal_password;
*/
	
	//console.log("agnet ==> " + agent);
	//console.log("agent_name ==> " + agent_name);
	//console.log("po_no ==> " + po_no);
	//console.log("portal_user_id ==> " + portal_user_id);
	//console.log("portal_password ==> " + portal_password);
	
	
	$("#agent").val(agent);
	$("#agent_name").val(agent_name);
	$("#po_no").val(po_no);
	$("#portal_user_id").val(portal_user_id);
	$("#portal_password").val(portal_password);
	
	//document.agent_invoice_di_pop_c.submit();

	//document.contentForm.action = "http://doowin.doosanmachinetools.com/keplogin.do";
	document.forms["contentForm"].action = "https://partner.dn-solutions.com/keplogin.do";
	document.forms["contentForm"].target = "_blank";
	document.forms["contentForm"].submit();
	
	//	window.open(loc,"newW","left=0,top=0,width=1024,height=760,resizable=yes,scrollbars=no");
//		top.window.close();
		
// message ==> 510080786500020@@510080786500020@@510081537900020@@510081880900010@@510082106900040@@510082628200020@@510082981700010@@510083017700110@@510083037900010@@510083037900020@@510083421400070@@510083421400080@@
		
}	


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	//var msg = response.Message;
	
	if(pMethod == "btnPoSearch"){
		
		setPoResult(response);
		
	}
	
	// 특수로직 추가 후 주석 풀기!!! 
	//opener.setQuery();
	//window.close();
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}
</script> 

<body>
<form name="contentForm" id="contentForm" method = "post">
<input type="hidden" name="s_SAVENAME" />
<!-- HIDDEN -->
<input type="hidden" id="st_query" name="st_query" value="">
<input type="hidden" id="st_buyer" name="st_buyer" value ="<%=p_buyer%>">
<input type="hidden" id="st_agent" name="st_agent"  value ="<%=p_agent%>">
<input type="hidden" id="st_gr_flag" name="st_gr_flag"  value ="<%=p_gr_flag%>">
<input type="hidden" id=st_process_type name="st_process_type"  value ="<%=p_process_type%>">

<!-- 두산인프라 인터페이스시 사용 -->
<input type="hidden" id="agent" name="agent" value =""/>
<input type="hidden" id="agent_name" name="agent_name" value =""/>
<input type="hidden" id="po_no" name="po_no" value =""/>
<input type="hidden" id="portal_user_id" name="portal_user_id" value =""/>
<input type="hidden" id="portal_password" name="portal_password" value =""/>

<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.comNameLoc}">

<input type="hidden" name="st_proxy_yn" id="st_proxy_yn" value="<%=p_proxy_yn%>">


	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit">거래명세서 작성 - 두산인프라코어 전용<span><a href="javascript:parent.closePop3();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="IBSheetTablePopup" width="1100px" style="height: 500px;">
  	<script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>
  </div>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:1050px;">
    <button class="ButPrimary_large" onclick="javascript:setDHIMCreate(); return false;" >납품서생성</button>
  </div>  
</div><!-- warp 끝-->
</form> 

</body>
</html>
