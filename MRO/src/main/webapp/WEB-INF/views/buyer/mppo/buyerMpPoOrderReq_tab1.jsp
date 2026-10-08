<%--
**********************************************
* 메뉴 : 주문 > 주문요청처리
* 화면 : 전체 탭
* 기능 : 주문요청현황에 대한 리스트를 확인 할 수 있다
* 프로그램 ID : BU0201006
* 담당자 : 최찬규
* 착수일 : 2026-04-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="java.sql.Timestamp"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
// 	String buyer1 = CommonUtil.nvl((String)_sessionInfo.getComCode());

@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String buyer             = "";
	String SessionComCode             = "";
	String zip_code          = "";
	String SessionUserId            = "";
	String userName          = "";
	String SessionUserDept          = "";
	String userTel           = "";
	String email             = "";
	String fax_no            = "";
	String mobile            = "";
	
	String SessionComorgLevel = "";
	String SessionComorgCode  = "";
	String using_catal_type  = "";
	String location_code     = "";
	String location_name     = "";
	String purchaseDeptCode  = "";
	String purchaseDeptName  = ""; 
	
	String img_view_flag  = ""; 
	String budget_flag   = ""; 
	String SessionAgentOpenFlag = ""; 
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		buyer             = sessionInfo.getComCode();      
		SessionComCode             = sessionInfo.getComCode();      
		SessionUserId            = sessionInfo.getUserId();
		userName          = sessionInfo.getUserNameLoc();
		SessionUserDept          = sessionInfo.getDepartment(); 
		userTel           = sessionInfo.getTel();
		email             = sessionInfo.getEmail();
		fax_no            = sessionInfo.getFax();
		mobile            = sessionInfo.getmPhone();
		using_catal_type  = sessionInfo.getUsingCatalType();
		
		zip_code          = sessionInfo.getZipCode();
		SessionComorgLevel = sessionInfo.getBycaComorgLevel();
		SessionComorgCode  = sessionInfo.getBycaComorgCode();      
		location_code     = CommonUtil.nvl(sessionInfo.getDelyToLocation());
		location_name     = CommonUtil.nvl(sessionInfo.getDelyToLocationName());
		purchaseDeptCode  = sessionInfo.getPurchaseDept();
		purchaseDeptName  = sessionInfo.getPurchaseDeptName();
		
		img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
		
		budget_flag           = sessionInfo.getBudgetFlag();
		SessionAgentOpenFlag  = sessionInfo.getAgentOpenFlag();
	} 	

	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, buyer);
	
	String group_mng_flag = "N";
	
	if(getCodeTGCM == true){
	   group_mng_flag = "Y"; 
	}
	
	//엑셀다운로드 기능 통제
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");
	
	boolean bca00004 = CommonUtil.getSpecialCheckReturn(buyer,"BCA00004");
	
%>
<script type="text/javascript">
var mySheet1 = new ibsheetObject();
var mySheet3 = new ibsheetObject();
window.tabs = window.tabs || {};
tabs.buyerMpPoOrderReq_tab1 = {
	//alert layer용
	but1text : "<%=CommonLang.get("HTITLE516")%>",/* 확인 */
	but1func : "javascript:closePopText2(); return false;",
	but1funcSearch : "javascript:tabs.buyerMpPoOrderReq_tab1.thisPopClose(); return false;",
	but1width : "120px",
	pagingMode : "N",
	current_page : "1",
	popupSel : "",
	grbRow : "",
	init:function(){
		if($("#st_from_date_1").val() ==  ""){
			$("#st_from_date_1").val(kepToMonthAdd("1","M"));
			$("#st_to_date_1").val(kepGetNowTimeStr('YYYYMMDD','/'));
		}
		
		var initsheet1 = {};
		initsheet1.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet1.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
				,{ Align:"Center",	SaveName:"NO",					Header:"<%=CommonLang.get("HTITLE44")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true} /*번호*/
				,{ Align:"Center",	SaveName:"STATUS_TEXT",				Header:"<%=CommonLang.get("HTITLE136")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*진행상태*/
				,{ Align:"Left",	SaveName:"BUYER_NAME_LOC",		Header:"<%=CommonLang.get("HTITLE291")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*고객사명*/
				,{ Align:"Center",	SaveName:"PR_NO",		Header:"<%=CommonLang.get("HTITLE1179")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"} /*주문요청번호*/
				,{ Align:"Left",	SaveName:"REQ_DEPT",			Header:"<%=CommonLang.get("HTITLE135")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청부서*/
				,{ Align:"Left",	SaveName:"ADD_USER_NAME",				Header:"<%=CommonLang.get("HTITLE133")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*요청자*/
				,{ Align:"Left",	SaveName:"PUR_DEPT",			Header:"<%=CommonLang.get("HTITLE188")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주부서*/
				,{ Align:"Left",	SaveName:"PUR_USER_NAME",			Header:"<%=CommonLang.get("HTITLE187")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*발주자*/
				,{ Align:"Center",	SaveName:"GYULJAE_FLAG",				Header:"<%=CommonLang.get("HTITLE253")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false} /*결재유무*/
				,{ Align:"Center",	SaveName:"AGENT_NAME",			Header:"<%=CommonLang.get("HTITLE567")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"}/*협력사명*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
				
				,{ Align:"Right",	SaveName:"TARGET_QTY",				Header:"<%=CommonLang.get("HTITLE651")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*요청수량*/
				,{ Align:"Right",	SaveName:"RECV_QTY",				Header:"<%=CommonLang.get("HTITLE242")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*승인수량*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",				Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"AMT",				Header:"<%=CommonLang.get("HTITLE1059")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*주문금액*/
				,{ Align:"Center",	SaveName:"RD_DATE",			Header:"<%=CommonLang.get("HTITLE831")%>",				Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"} /*수령희망일*/
				,{ Align:"Left",	SaveName:"BUDGET_DEPT_NAME",			Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산부서*/
				,{ Align:"Left",	SaveName:"ACCOUNT_NAME",				Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true} /*예산계정*/
				
				,{ Align:"Center",	SaveName:"REF_PR_TEXT",			Header:"REF_PR_TEXT",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"RECV_FLAG",			Header:"RECV_FLAG",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUYER",			Header:"BUYER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_SEQ",			Header:"CONTRACT_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"BYIT_COMORG_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT_CODE",			Header:"AGENT_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_SEQ",			Header:"PR_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"STATUS_CODE",			Header:"STATUS_CODE",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"GW_NO",			Header:"GW_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
		];
		
		IBS_InitSheet(mySheet1, initsheet1, this.pagingMode);
		mySheet1.SetHighlightAfterSort(2);
		
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		
		IBS_InitSheet(mySheet3, initsheet1, this.pagingMode);
	},
	
	search:function(){
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		var com_code = $("#st_com_code_1").val();
		if(com_code.indexOf("GROUP") >=0){
			$("#st_group_info_1").val(com_code);
		}else{
			$("#st_group_info_1").val("");
		}
		$("#st_all_page_1").val("N");
		this.current_page = 1;
		kepSearch_v2(document.searchCondition1, mySheet1, "/mppo/getBuyerMpPoOrderReqList_v2.do?page="+this.current_page, this.pagingMode);
	},
	search2:function(){
		if (kep_dateSearchCheck($("#st_from_date_1").val(),$("#st_to_date_1").val()) == false) return;
		var diff = kepGetDateDiff('st_from_date_1','st_to_date_1','D');
		if (eval(diff)>372){
			var text = "<%=CommonLang.msg("MSG617")%>";//1년 이내 조회만 가능합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		
		var com_code = $("#st_com_code_1").val();
		if(com_code.indexOf("GROUP") >=0){
			$("#st_group_info_1").val(com_code);
		}else{
			$("#st_group_info_1").val("");
		}
		$("#st_all_page_1").val("Y");
		kepSearch_v2(document.searchCondition1, mySheet3, "/mppo/getBuyerMpPoOrderReqList_v2.do", this.pagingMode);
	},
	reload:function(){
		kepReload_v2('searchCondition1');
		kepMonth_v2('st_from_date_1','st_to_date_1','1');
		$("#st_req_dept_code_1").val("");
		$("#st_pur_dept_code_1").val("");
		mySheet1.RemoveAll();
		mySheet3.RemoveAll();
	},
	doAction:function(str){
		switch (str) {
		case "reqDepartmentErase":
			$("#st_req_dept_code_1").val("");
			$("#st_req_dept_name_1").val("");
			break;
		case "purDepartmentErase":
			$("#st_pur_dept_code_1").val("");
			$("#st_pur_dept_name_1").val("");
			break;
		default:
			break;
		}
	},
	doPop:function(str,value1,value2,value3,value4){
		this.popupSel = str;
		var com_code = $("#st_com_code_1").val();
		if(com_code == ""){
			var text = "<%=CommonLang.msg("MSG239")%>";//고객사를 전체 아닌 값으로 선택해야 합니다.
			openLayerPopText2(text,this.but1text,this.but1func,this.but1width);
			return;
		}
		switch (str) {
		case "purDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerMpPoOrderReq_tab1", "720,580,no"); 
			break;
		case "reqDepartment":
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+com_code+"&tab_id=buyerMpPoOrderReq_tab1", "720,580,no"); 
			break;
		case "purUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerMpPoOrderReq_tab1", "780,550,no");
			break;
		case "reqUser":
			openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code='+com_code+'&dept_code='+"&tab_id=buyerMpPoOrderReq_tab1", "780,550,no");
			break;
		default:
			break;
		}
	},
	pageSearch:function(param){
		$("#st_all_page_1").val("N");
		this.current_page = param.page;
		kepSearch_v2(document.searchCondition1, mySheet1, "/mppo/getBuyerMpPoOrderReqList_v2.do?page="+this.current_page, this.pagingMode);
	},
	setPopupReturn:function(value1,value2,value3){
		if (this.popupSel == "purDepartment") {
			$("#st_pur_dept_code_1").val(value1);
			$("#st_pur_dept_name_1").val(value2);
		} else if(this.popupSel == "reqDepartment") {
			$("#st_req_dept_code_1").val(value1);
			$("#st_req_dept_name_1").val(value2);
		}else if(this.popupSel == "purUser") {
			$("#st_pur_user_id_1").val(value1);
			$("#st_pur_user_name_1").val(value2);
		}else if(this.popupSel == "reqUser") {
			$("#st_req_user_id_1").val(value1);
			$("#st_req_user_name_1").val(value2);
		}
	},
	thisPopClose:function(){
		closePopText2();
		this.search();
	},
	excelDown:function(){
		if(mySheet3.RowCount() == 0){
			var text ="<%=CommonLang.msg("MSG347")%>"; //"조회된 데이터가 없습니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		
		mySheet3.SetWaitImageVisible(true);
		
		var downRow = "|0";
		for(var i = 1; i <= mySheet3.RowCount(); i++) {
			downRow += "|"+i;
		}
		
		var downCol = "";
		for(var i=0; i<= mySheet3.LastCol(); i++){
			if(!mySheet3.GetColHidden(i) && mySheet3.ColSaveName(i) !="SELECTED" && mySheet3.GetCellProperty(1, i, "Type") != "Image"){
				downCol += "|"+i;
			}
		}
		
		if(downRow == "|0"){
			downRow = "";
		}
		var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
		
		var fileName = "주문요청현황_";
		
		var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
		mySheet3.Down2Excel(param);
	},
	buyerChange:function(){
		$("#st_req_dept_code_1").val("");
		$("#st_req_dept_name_1").val("");
		$("#st_pur_dept_code_1").val("");
		$("#st_pur_dept_name_1").val("");
	}
};
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab1.but1text,tabs.buyerMpPoOrderReq_tab1.but1func,tabs.buyerMpPoOrderReq_tab1.but1width);
	}
	
	var group_mng_flag = "<%=group_mng_flag%>";
	if(group_mng_flag == "Y"){ //통합고객사 -> 고객사명 컬럼 노출
		mySheet1.SetColHidden("BUYER_NAME_LOC",false);
	}

	var budget_flag = "<%=budget_flag%>";
	if(budget_flag == "Y"){
		mySheet1.SetColHidden("BUDGET_DEPT_NAME",false);
		mySheet1.SetColHidden("ACCOUNT_NAME",false);
	}
	
	var bca00004 = "<%=bca00004%>";
	if(bca00004 == "true"){
		for(var i = 1; i<=mySheet1.RowCount(); i++){
			mySheet1.SetCellValue(i,"REF_PR_NO",mySheet1.GetCellValue(i,"REF_PR_TEXT"));
		}
	}
	
	for(var i = 1 ; i<=mySheet1.RowCount(); i++){
		var status = mySheet1.GetCellValue(i,"STATUS_CODE");
		if(status == "STATUS01"){ //주문요청
			mySheet1.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE194")%>");
		}else if(status == "STATUS02"){ //요청반려
			mySheet1.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE192")%>");
		}else if(status == "STATUS03"){ //주문결재중
			mySheet1.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE195")%>");
		}else if(status == "STATUS04"){ //주문결재반려
			mySheet1.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE261")%>");
		}else if(status == "STATUS05"){ //주문완료
			mySheet1.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE1005")%>");
		}
	}
	

	makePageIndex_v3( mySheet1 , tabs.buyerMpPoOrderReq_tab1.current_page , document.searchCondition1.onepagerow.value,"buyerMpPoOrderReq_tab","1");	
}
function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,tabs.buyerMpPoOrderReq_tab1.but1text,tabs.buyerMpPoOrderReq_tab1.but1func,tabs.buyerMpPoOrderReq_tab1.but1width);
	}
	
	var group_mng_flag = "<%=group_mng_flag%>";
	if(group_mng_flag == "Y"){ //통합고객사 -> 고객사명 컬럼 노출
		mySheet3.SetColHidden("BUYER_NAME_LOC",false);
	}
	
	var bca00004 = "<%=bca00004%>";
	if(bca00004 == "true"){
		for(var i = 1; i<=mySheet3.RowCount(); i++){
			mySheet3.SetCellValue(i,"REF_PR_NO",mySheet3.GetCellValue(i,"REF_PR_TEXT"));
		}
	}
	
	for(var i = 1 ; i<=mySheet3.RowCount(); i++){
		var status = mySheet3.GetCellValue(i,"STATUS_CODE");
		if(status == "STATUS01"){ //주문요청
			mySheet3.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE194")%>");
		}else if(status == "STATUS02"){ //요청반려
			mySheet3.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE192")%>");
		}else if(status == "STATUS03"){ //주문결재중
			mySheet3.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE195")%>");
		}else if(status == "STATUS04"){ //주문결재반려
			mySheet3.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE261")%>");
		}else if(status == "STATUS05"){ //주문완료
			mySheet3.SetCellValue(i,"STATUS_TEXT","<%=CommonLang.get("HTITLE1005")%>");
		}
	}
	
	tabs.buyerMpPoOrderReq_tab1.excelDown();
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	tabs.buyerMpPoOrderReq_tab1.grbRow = Row;
	
	var buyer = mySheet1.GetCellValue(Row,"BUYER");
	var pr_no = mySheet1.GetCellValue(Row,"PR_NO");
	var pr_seq = mySheet1.GetCellValue(Row,"PR_SEQ");
	var gw_no = mySheet1.GetCellValue(Row,"GW_NO");
	var recv_flag = mySheet1.GetCellValue(Row,"RECV_FLAG");
	var agent_code = mySheet1.GetCellValue(Row,"AGENT_CODE");
	
	if(column == "PR_NO"){ //PR번호 클릭 시
		if(pr_no != ""){
			if(gw_no != ""){
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,890,no"); 
			}else{
				openSearchPopup('/mpiv/getCommonMpIvOdrreqDetailPop_v2.do','?BUYER='+buyer+'&PR_NO='+pr_no+'&PR_SEQ='+pr_seq+'&RECV_FLAG='+recv_flag+"&gw_no="+gw_no , "1330,690,no"); 
			}
		}
	}else if(column == "AGENT_NAME"){
		var src = "/common/agentInfoDisplayPop.do?st_com_code="+agent_code; 
		openLayerPop(src,"800px","680px");
	}
	return;
}
</script>
<form id="searchCondition1" name="searchCondition1" method="post">
		<input type="hidden" name="s_SAVENAME" />
		<input type="hidden" name="st_user_id" id="st_user_id_1" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_dept" id="st_user_dept_1" value="<%=SessionUserDept%>">

		<input type="hidden" name="st_buyer"    value ="${sessionInfo.comCode}"> 
		<input type="hidden" name="st_userid"    value ="${sessionInfo.userId}"> 
        <input type="hidden" name="onepagerow" id="onepagerow_1" value="<%=request.getParameter("rowCnt")%>">
        <input type="hidden" id="pageflag_1" name="pageflag" value="1" />
        <input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag_1" value="<%=group_mng_flag%>">
        <input type="hidden" name="st_group_info" id="st_group_info_1" value="">
        <input type="hidden" name="st_all_page" id="st_all_page_1" value="N">
        
	<div id="Search1" class="SearchContent">
      <div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> <%=CommonLang.msg("MSG789")%><!--주문요청 건의 진행상태와 처리내역을 조회할 수 있으며, 주문요청번호 클릭 시 상세 내용을 확인할 수 있습니다.--></div>
      <table class="TabSearchTable" >
        <colgroup>
          <col width="66px" />
          <col width="155px" />
          <col width="56px" />
          <col width="320px" />
          <col width="66px" />
          <col width="135px" />
          
          <col width="56px" />
          <col width="200px" />
          <col width="66px" />
          <col width="160px" />
        </colgroup>           	
        <tr>
          <th><%=CommonLang.get("HTITLE423") %><!-- 기간 --></th>
          <td colspan="5">
            <select name="st_date_type" id="st_date_type_1" class="Select40" style=" float:left; width:125px; margin-right:7px">
              <option value="PR_DATE"><%=CommonLang.get("HTITLE1235") %><!-- 주문요청일 --></option>
              <option value="PO_DATE"><%=CommonLang.get("HTITLE185") %><!-- 주문일 --></option>
            </select>
            <div class="Buyer-datepicker-wrap" style=" width:231px; margin-right:8px">
              <div class="Buyer-date-input"  data-datepicker><input style=" " id="st_from_date_1" name="st_from_date" type="text" placeholder="" readonly /><span> </span></div>
              <span class="Buyer-dash">~</span>
              <div class="Buyer-date-input" data-datepicker><input type="text"  id="st_to_date_1" name="st_to_date" placeholder="" readonly /><span></span></div>
            </div>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','1'); return false;">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button> 
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','2'); return false;">2<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','3'); return false;">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></button>
            <button class="But_Month" style="width:73px" onclick="javascript:kepMonth_v2('st_from_date_1','st_to_date_1','12'); return false;">1<%=CommonLang.get("HTITLE424") %><!-- 년 --></button>
          </td>
          <th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>
          <td>
            <input type="text" class="input40"  value="" id="st_req_user_name_1" name="st_req_user_name" style=" width:163px;" onKeyDown="kepEnter_v3('buyerMpPoOrderReq_tab1')">
<!--             <input type="hidden"  value="" id="st_req_user_id_1" name="st_req_user_id" style=" width:113px;" readonly> -->
<!--             <button type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.doPop('reqUser'); return false;"></button> -->
          </td>
          <th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
          <td><div class="TabShIconTwo" style="width:163px ">
            <input type="text"  value="" id="st_req_dept_name_1" name="st_req_dept_name" style=" width:95px;" readonly>
            <input type="hidden"  value="" id="st_req_dept_code_1" name="st_req_dept_code" style=" width:95px;" readonly>
            <button class="Search" type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.doPop('reqDepartment'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.doAction('reqDepartmentErase'); return false;"></button></div>
          </td>
        </tr>
		<tr>
          <th><%=CommonLang.get("HTITLE136") %><!-- 진행상태 --></th>
          <td>
            <select name="st_status" id="st_status_1" class="Select40" style="width:125px;">
              <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
              <option value="GA,PT"><%=CommonLang.get("HTITLE194") %><!-- 주문요청 --></option>
              <option value="PC"><%=CommonLang.get("HTITLE1005") %><!-- 주문완료 --></option>
              <option value="PS"><%=CommonLang.get("HTITLE195") %><!-- 주문결재중 --></option>
              <option value="PR"><%=CommonLang.get("HTITLE261") %><!-- 주문결재반려 --></option>
              <option value="RR"><%=CommonLang.get("HTITLE192") %><!-- 요청반려 --></option>
            </select> 
          </td>
          <th><%=CommonLang.get("HTITLE552") %><!-- 검색어 --></th>
          <td >
            <select name="st_search_type" id="st_search_type_1" class="Select40" style=" float:left;width:140px; margin-right:5px">
              <option value="PR"><%=CommonLang.get("HTITLE1179") %><!-- 주문요청번호 --></option>
              <option value="DE"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
              <option value="RN"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></option>
              <option value="BC"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
            </select>  
            <input class="input40" style="width:120px" name="st_search_code" id="st_search_code_1" type="text" onKeyDown="kepEnter_v3('buyerMpPoOrderReq_tab1')"/>
          </td>  
          <th><%=CommonLang.get("HTITLE253") %><!-- 결재유무 --></th>
          <td >
            <select name="st_gyuljae" id="st_gyuljae_1" class="Select40" style=" float:left;width:93px; margin-right:5px">
              <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
              <option value="Y">Y</option>
              <option value="N">N</option>
            </select>  
          </td>
          <th><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></th>
          <td>
            <input type="text"  class="input40" value="" name="st_pur_user_name" id="st_pur_user_name_1" style=" width:163px;" onKeyDown="kepEnter_v3('buyerMpPoOrderReq_tab1')">
<!--             <input type="hidden" name="st_pur_user_id" id="st_pur_user_id_1" value=""> -->
<!--             <button type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.doPop('purUser'); return false;"></button> -->
            </td>
          <th><%=CommonLang.get("HTITLE188") %><!-- 발주부서 --></th>
          <td><div class="TabShIconTwo" style="width:163px ">
            <input type="text"  value=""  name="st_pur_name_code" id="st_pur_dept_name_1" style=" width:95px;" readonly>
            <input type="hidden" name="st_pur_dept_code" id="st_pur_dept_code_1" value="" readonly>
            <button class="Search" type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.doPop('purDepartment'); return false;"></button><button class="Delete" type="button" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.doAction('purDepartmentErase'); return false;"></button></td>
		</tr>
		<%if(group_mng_flag.equals("Y")) {%>
		<tr>
          <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
	      <td>
		      <select name="st_com_code" id="st_com_code_1" class="Select40" style="width:125px;" onchange="javascript:tabs.buyerMpPoOrderReq_tab1.buyerChange();">
		        <%= CommonUtil.getCode3ComboList(request.getParameter("buyer"), "ALL", "TGCM",request.getParameter("userid"), "ICOMCOD3", request.getParameter("buyer"), "") %>
		       </select>
	      </td>
	    </tr>
		  <%}else{ %>
		  <input type="hidden" name="st_com_code" id="st_com_code_1" value="${sessionInfo.comCode}">
		  <%} %>           
      </table>
      <div class="SearchBtnBox">
        <button class="ButOutline_Medium" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.reload(); return false;"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button> 
        <button class="ButDarkGray_Medium" onclick="javascript:tabs.buyerMpPoOrderReq_tab1.search(); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button>
      </div>
      <div class="ArraySub mt30 mb10">
        <div class="buttonLeft">
        <%if(p170000001 ==false){%>
          <button class="But_ExcelDown40" onclick="tabs.buyerMpPoOrderReq_tab1.search2(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        <%} %> 
        </div>
	  </div>
      <div class="IBSheetBuyer">
      	<script type="text/javascript">
          	createIBSheet("mySheet1", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 --> 
      <div class="IBSheetBuyer" style="display: none;">
      	<script type="text/javascript">
          	createIBSheet("mySheet3", "", "100%");
        </script>
      </div><!--IBSheetBuyer 끝 --> 
      <div class="PagingCenter mt10" id="pageindex1"></div> 
      <div class="h50"></div>         
    </div><!--Tab1끝 --> 
</form>
