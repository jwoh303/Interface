<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재문서 상세
* 기능 : 결재문서 상세
* 프로그램 ID : BU0701002
* 담당자 : 최찬규
* 착수일 : 2026-02-02
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String, Object> ht = (Map<String, Object>) request.getAttribute("data"); // 조회된결과   
String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),""); // tab_id

String COMPANY = CommonUtil.nvl((String) request.getParameter("COMPANY"),"");  //  (조회조건)
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");  //  (조회조건)
String FLAG = CommonUtil.nvl((String) request.getParameter("FLAG"),"");  //  (조회조건)
String biz_url = CommonUtil.nvl((String)ht.get("biz_url"),"");  // 공통테이블이서 가지고온 각업무별 url 
String new_biz_url = CommonUtil.nvl((String)ht.get("new_biz_url"),"");  // 공통테이블이서 가지고온 각업무별 url 리뉴얼용

String action_base = CommonUtil.nvl((String)ht.get("action_base"),"");  // 공통테이블이서 가지고온 각업무별 action url
String biz_jsp = CommonUtil.nvl((String)ht.get("biz_jsp"),""); // 공통테이블이서 가지고온 각업무별 jsp 파일명
String pass_status = CommonUtil.nvl((String)ht.get("pass_status"),"");  // 상태
String user_id = CommonUtil.nvl((String)ht.get("user_id"),"");  // 상태
String pass_status_text = CommonUtil.nvl((String)ht.get("pass_status_text"),"");  // 상태
String pass_add = CommonUtil.nvl((String)ht.get("pass_add"),"");  // 결재자의견
String approval_user_id = CommonUtil.nvl((String)ht.get("approval_user_id"),"");  // 현재 결재할 사용자
String DOCU_TITLE = CommonUtil.nvl((String)ht.get("subject"),"");  // 제목
String approval_yn = CommonUtil.nvl((String)ht.get("approval_yn"),"N");  // 대신 결재할 수 있는 아이디 여부

String key_1 = CommonUtil.nvl((String)ht.get("key_1"),"");  // key_1 -- PrNo
String key_2 = CommonUtil.nvl((String)ht.get("key_2"),"");  // key_2
String key_3 = CommonUtil.nvl((String)ht.get("key_3"),"");  // key_3
String extif_tp = CommonUtil.nvl((String)ht.get("extif_tp"),"");  // extif_tp
String extif_tp_text = CommonUtil.nvl((String)ht.get("extif_tp_text"),"");  // extif_tp_text

String PASS_TP = CommonUtil.nvl((String) request.getParameter("PASS_TP"),"");  //  (조회조건)
String RECV_FLAG = CommonUtil.nvl((String) request.getParameter("RECV_FLAG"),"");  //  (조회조건)
String dt_displaly =CommonUtil.nvl((String) request.getParameter("DT_DISPLAY"),"");  

String content = CommonUtil.nvl((String)ht.get("content"),""); // 내용
content = content.replaceAll("&lt;br&gt;", "\n");

String cnt = CommonUtil.nvl(String.valueOf(ht.get("cnt")),"");  //품목수
String price = CommonUtil.nvl(String.valueOf(ht.get("price")),"");  //금액
//KRKORE0001 운영사 결재선 체크
String userDepartment = "";
String userDepartmentName = "";
String buyer = ""; 
String userid = "";
String budget_flag = "";
String userType = "";
String bycaComonrgLevel = "";
if (_sessionInfo != null){  
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode());
	userDepartment    = CommonUtil.nvl((String)_sessionInfo.getDepartment());
	userDepartmentName = CommonUtil.nvl((String) _sessionInfo.getDepartmentName());
	budget_flag           = CommonUtil.nvl((String)_sessionInfo.getBudgetFlag());  // 구매사 예산 사용여부 
	userType = CommonUtil.nvl((String)_sessionInfo.getUserType());
	bycaComonrgLevel = CommonUtil.nvl((String) _sessionInfo.getBycaComorgLevel());
} 
String apprId = CommonUtil.getCode3RoleReturn("APPR", userDepartment, COMPANY, "CODE2");

//p060000059 결재지정/변경 버튼 비활성화 SLOGIC
boolean p060000059= CommonUtil.getSpecialCheckReturn(buyer,"P06-0000059");

 //SLOGIC-BEGIN(P06-0000050)
String reportText= CommonLang.get("HTITLE704");//품의서출력 // default 버튼명 
String reportid = "RD_06_S_003_03";  //default
Map<String, String> p060000050 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000050");   // com_code , 특수로직아이디
if (p060000050 != null){
	reportText= CommonUtil.nvl(p060000050.get("COL01_DATA"),reportText); // 레포트 버튼명
	reportid = CommonUtil.nvl(p060000050.get("COL02_DATA"),reportid); // 레포트아이디
	if (extif_tp.equals("NS")){	// 소싱합의  
		reportid = CommonUtil.nvl(p060000050.get("COL04_DATA"),reportid);	// 레포트아이디
	}
	else if(extif_tp.equals("PX")){ //구매발주
		reportid = CommonUtil.nvl(p060000050.get("COL05_DATA"),reportid);	// 레포트아이디
	}
}

String PXreportid = "RD_06_S_003_12"; //구매발주 품의서 default;
Map<String, String> p060000051 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000051");   // com_code , 특수로직아이디
if (p060000051 != null){
// 	reportText= CommonUtil.nvl(p060000051.get("COL01_DATA"),reportText); // 레포트 버튼명
	PXreportid = CommonUtil.nvl(p060000051.get("COL02_DATA"),reportid); // 레포트아이디
} 
String PRreportid = "RD_06_B_002_12"; //구매요청 품의서 default;
Map<String, String> p060000016 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000016");   // com_code , 특수로직아이디
if (p060000016 != null){
// 	reportText= CommonUtil.nvl(p060000016.get("COL01_DATA"),reportText); // 레포트 버튼명
	PRreportid = CommonUtil.nvl(p060000016.get("COL02_DATA"),reportid); // 레포트아이디
} 
String NSreportid = "RD_06_B_002_14"; //소싱합의 품의서 default;
Map<String, String> p060000076 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000076");   // com_code , 특수로직아이디
if (p060000076 != null){
// 	reportText= CommonUtil.nvl(p060000076.get("COL01_DATA"),reportText); // 레포트 버튼명
	NSreportid = CommonUtil.nvl(p060000076.get("COL02_DATA"),reportid); // 레포트아이디
} 






//주문요청 품의
boolean bag00003 = CommonUtil.getSpecialCheckReturn(buyer,"BAG00003"); // 품목별 구매사유 노출(깨끗한나라)

//주문 품의
boolean bag00004 = CommonUtil.getSpecialCheckReturn(buyer,"BAG00004"); // 품목별 구매사유 노출(깨끗한나라)
//SLOGIC-END

//주문요청 품의
boolean bag00005 = CommonUtil.getSpecialCheckReturn(buyer,"BAG00005"); // 예산계정 변경 가능
//주문 품의
boolean bag00006 = CommonUtil.getSpecialCheckReturn(buyer,"BAG00006"); // 예산계정 변경 가능

//견적상세 팝업
boolean p04402705 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4027-05");

//결재경로관리 팝업
String _approvalUrl = "/common/popup/approval/approvalHumanEditPop.do";	// 결재경로 팝업 원 소스
Map<String, String> p110000007_map	= CommonUtil.getSpecialCheckReturnMap(COMPANY,"P11-0000007");
if (p110000007_map != null) {
	_approvalUrl = p110000007_map.get("COL01_DATA");
}
%>

<script type="text/javascript"> 
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N";
var grbRow = "";


function captureReturnKey(e) {   
    if(e.keyCode==13 && e.srcElement.type != 'textarea')   
    return false;   
}   

function excelDown() {
	
	if(mySheet2.RowCount() == 0){
		//조회된 데이터가 없습니다.
		var text = "<%=CommonLang.msg("MSG347")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	mySheet2.SetWaitImageVisible(true);
	
	var downRow = "|0";
	for(var i=1; i<=mySheet2.RowCount(); i++) {
			downRow += "|"+i;
	}
	
	var downCol = "";
	for(var i=0; i<=mySheet2.LastCol(); i++){
		if(!mySheet2.GetColHidden(i) && mySheet2.ColSaveName(i) !="SELECTED" && mySheet2.GetCellProperty(1, i, "Type") != "Image"){
			downCol += "|"+i;
		}
	}
	
	
	if(downRow == "|0"){
		downRow = "";
	}
	var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
	
	//결재대상
	var param = {FileName:"<%=CommonLang.get("HTITLE770")%>_"+nowTime, SheetName:"<%=CommonLang.get("HTITLE770")%>", DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
	mySheet2.Down2Excel(param);
	
}  

function fileDownload(doc_no){
	if(doc_no == ""){
		//첨부파일이 없습니다.
		var text = "<%=CommonLang.msg("MSG612") %>  ";
		 openLayerPopText2(text,but1text,but1func,but1width);
		 return;
	}else{
		location.href="/common/download_v2.do?DOC_NO="+doc_no;
	}
}
function approvalLine(COMPANY,DOCU_NO){
	var option = "?COMPANY="+ COMPANY;
	option = option + "&DOCU_NO="+ DOCU_NO;
	option = option + "&PASS_LINE_FLAG=N"; //나의 결재경로 안불러오도록
<%-- 	openSearchPopupPost('<%=_approvalUrl%>',"approvalPop","approvalPop","width=1230,height=680,resizable=no,scrollbars=no, top=0, left=0"); --%>
	openSearchPopup('<%=_approvalUrl%>',option, "1200,670,no"); 
}


function kep_onload_view(){ 
	 $("#DOCU_CONT").focus(); 
	 <% if(pass_status_text.equals("상신완료")) {%>
	 	$("#DOCU_CONT").attr("readonly",false);
	 <%}%>
	 
	 
	 var initsheet = {};
		initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
				,{ Align:"Center",	SaveName:"ORDER_NO",			Header:"<%=CommonLang.get("HTITLE140")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true} /*순번*/
				,{ Align:"Center",	SaveName:"PASS_TP_TEXT",		Header:"<%=CommonLang.get("HTITLE306")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false} /*유형*/
				,{ Align:"Center",	SaveName:"PASS_TP",				Header:"<%=CommonLang.get("HTITLE306")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true} /*유형*/
				,{ Align:"Center",	SaveName:"USER_NM",				Header:"<%=CommonLang.get("HTITLE325")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*이름*/
				,{ Align:"Center",	SaveName:"USER_POS",			Header:"<%=CommonLang.get("HTITLE476")%>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*직급*/
				,{ Align:"Center",	SaveName:"USER_DEPT",			Header:"<%=CommonLang.get("HTITLE329")%>",		Type:"Text",	Width:90,	Edit:false,	EditLen:100,	Hidden:false} /*부서*/
				,{ Align:"Center",	SaveName:"PASS_KN",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*상태*/
				,{ Align:"Center",	SaveName:"REFER_DATE",			Header:"<%=CommonLang.get("HTITLE1048")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*열람일시*/
				,{ Align:"Center",	SaveName:"PASS_DATE",			Header:"<%=CommonLang.get("HTITLE1049")%>",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*결재일시*/
				,{ Align:"Left",	SaveName:"PASS_ADD",			Header:"<%=CommonLang.get("HTITLE1050")%>",				Type:"Text",		Width:370,	Edit:false,	EditLen:100,	Hidden:false}/*결재자의견*/
				,{ Align:"Center",	SaveName:"MAIL_BUTTON",			Header:"<%=CommonLang.get("HTITLE1054")%>",				Type:"Button",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03',Cursor:"Pointer"}/*메일발송*/
				,{ Align:"Center",	SaveName:"CUR_ORDER_NO",			Header:"CUR_ORDER_NO",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"DOCU_USER_ID",			Header:"DOCU_USER_ID",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
		];
		
		IBS_InitSheet(mySheet, initsheet, pagingMode);
		mySheet.SetHighlightAfterSort(2);
		
		mySheet.SetHeaderBackColor("#f2f7ff");
		mySheet.SetTheme("DB", "DeepBlue");
		
		var initSheet2 = {};
		initSheet2.HeaderMode={Sort:0,HeaderCheck:0};
		initSheet2.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initSheet2.Cols = [
		<%if(extif_tp.equals("PR") || extif_tp.equals("PX")){%>
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",									Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
				,{ Align:"Center",	SaveName:"ORDER_NO",			Header:"<%=CommonLang.get("HTITLE44")%>",		Type:"Text",		Width:50,	Edit:true,	EditLen:100,	Hidden:true} /*번호*/
				,{ Align:"Center",	SaveName:"PR_NO",		Header:"<%=CommonLang.get("HTITLE186")%>",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*주문번호*/
				,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"<%=CommonLang.get("HTITLE12")%>",		Type:"Text",FontColor:"#3a72c7", Cursor:"Pointer",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Center",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}/*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",			Header:"<%=CommonLang.get("HTITLE14")%>",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*규격*/
				,{ Align:"Center",	SaveName:"AGENT_NAME",			Header:"<%=CommonLang.get("HTITLE144")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*협력사*/
				,{ Align:"Center",	SaveName:"RD_DATE",				Header:"<%=CommonLang.get("HTITLE831")%>",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"}/*수령희망일*/
				,{ Align:"Right",	SaveName:"TARGET_PRICE",			Header:"<%=CommonLang.get("HTITLE174")%>",		Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*단가*/
				,{ Align:"Right",	SaveName:"TARGET_QTY",			Header:"<%=CommonLang.get("HTITLE45")%>",		Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*수량*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",			Header:"<%=CommonLang.get("HTITLE52")%>",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"PO_AMT",			Header:"<%=CommonLang.get("HTITLE922")%>",		Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*합계*/
				,{ Align:"Center",	SaveName:"PR_BUDGET_DEPT",			Header:"<%=CommonLang.get("HTITLE268")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}/*예산부서*/
				,{ Align:"Center",	SaveName:"PR_ACCOUNT_TYPE",			Header:"<%=CommonLang.get("HTITLE676")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:true}/*계정정보*/
				,{ Align:"Center",	SaveName:"MSDS_NO",			Header:"<%=CommonLang.get("HTITLE914")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"}/*MSDS*/
				,{ Align:"Center",	SaveName:"IMAGE_KEY_YN",			Header:"<%=CommonLang.get("HTITLE119")%>",		Type:"Button",Cursor:"Pointer",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}/*첨부파일*/
				,{ Align:"Center",	SaveName:"PRDT_REMARK",			Header:"<%=CommonLang.get("HTITLE122")%>",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*비고*/
				,{ Align:"Center",	SaveName:"PR_REASON",			Header:"<%=CommonLang.get("HTITLE1168")%>",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}/*구매사유*/
				,{ Align:"Center",	SaveName:"REJECT_BUTTON",			Header:"<%=CommonLang.get("HTITLE1052")%>",									Type:"Button",	Width:80,	Edit:true,	EditLen:100,	Hidden:true,ClassName:'Type03' }/*부분반려*/
				,{ Align:"Center",	SaveName:"RECV_FLAG_TEXT",			Header:"<%=CommonLang.get("HTITLE1052")%>",									Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}/*부분반려*/
				,{ Align:"Center",	SaveName:"RETURN_REASON",			Header:"<%=CommonLang.get("HTITLE957")%>",		Type:"Text",		Width:200,	Edit:false,	EditLen:200,	Hidden:true}/*반려사유*/
				
				
				,{ Align:"Center",	SaveName:"ACCOUNT_TYPE",			Header:"ACCOUNT_TYPE",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"IMAGE_KEY",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",			Header:"BYIT_COMORG_CODE",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_SEQ",			Header:"CONTRACT_SEQ",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BUYER",			Header:"BUYER",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PR_SEQ",			Header:"PR_SEQ",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"REQ_DEPT",			Header:"REQ_DEPT",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"REQ_DEPT_NAME",			Header:"REQ_DEPT_NAME",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"REF_NO",			Header:"REF_NO",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"PO_NO",			Header:"PO_NO",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"RECV_FLAG",			Header:"RECV_FLAG",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
		<%}else if(extif_tp.equals("NS") || extif_tp.equals("NG")){%>
		  				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",									Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
		  				,{ Align:"Center",	SaveName:"ORDER_NO",			Header:"<%=CommonLang.get("HTITLE44")%>",		Type:"Text",		Width:50,	Edit:true,	EditLen:100,	Hidden:false} /*번호*/
		  				,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"<%=CommonLang.get("HTITLE126")%>",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:true} /*견적번호*/
		  				,{ Align:"Center",	SaveName:"BTOA_DATE",				Header:"<%=CommonLang.get("HTITLE127")%>",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"}/*견적의뢰일*/
		  				,{ Align:"Center",	SaveName:"BTOA_END_DATE",				Header:"<%=CommonLang.get("HTITLE51")%>",		Type:"Date",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, Format:"yyyy-MM-dd"}/*회신요청일*/
		  				,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"<%=CommonLang.get("HTITLE12")%>",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
		  				,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",		Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}/*품목명*/
		  				,{ Align:"Left",	SaveName:"SPECIFICATION",			Header:"<%=CommonLang.get("HTITLE14")%>",		Type:"Text",		Width:250,	Edit:false,	EditLen:100,	Hidden:false}/*규격*/
		  				,{ Align:"Center",	SaveName:"AGENT_NAME",			Header:"<%=CommonLang.get("HTITLE144")%>",		Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*협력사*/
		  				,{ Align:"Right",	SaveName:"BUYER_TARGET_PRICE",			Header:"<%=CommonLang.get("HTITLE611")%>",		Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*실적단가*/
		  				,{ Align:"Right",	SaveName:"ATOB_UNIT_PRICE",			Header:"<%=CommonLang.get("HTITLE145")%>",		Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*견적단가*/
		  				,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"<%=CommonLang.get("HTITLE45")%>",		Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*수량*/
		  				,{ Align:"Center",	SaveName:"UNIT_MEASURE",			Header:"<%=CommonLang.get("HTITLE52")%>",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
		  				,{ Align:"Center",	SaveName:"MSDS_NO",			Header:"<%=CommonLang.get("HTITLE914")%>",		Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false, FontColor:"#3a72c7", Cursor:"Pointer"}/*MSDS*/
		  				,{ Align:"Center",	SaveName:"IMAGE_KEY_YN",			Header:"<%=CommonLang.get("HTITLE119")%>",		Type:"Button",Cursor:"Pointer",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}/*첨부파일*/
		  				
		  				,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"IMAGE_KEY",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"QUOTATION_SEQ",			Header:"QUOTATION_SEQ",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"BUYER",			Header:"BUYER",			Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
		  				,{ Align:"Center",	SaveName:"KEP_USER_NAME",		Header:"<%=CommonLang.get("HTITLE146")%>",		Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}/*KEP담당자*/
		  				,{ Align:"Center",	SaveName:"ATOB_REMARK",			Header:"<%=CommonLang.get("HTITLE122")%>",		Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}/*비고*/
		  				,{ Align:"Center",	SaveName:"REVISION",			Header:"REVISION",		Type:"Text",	Width:50,	Edit:false,	EditLen:100,	Hidden:true}
		<%}%>
		  		];
		
		IBS_InitSheet(mySheet2, initSheet2, pagingMode);
		mySheet2.SetHighlightAfterSort(2);
		mySheet2.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
		
		mySheet2.SetHeaderBackColor("#f2f7ff");
		mySheet2.SetTheme("DB", "DeepBlue");
		
		kepSearch(document.buyerCommonMyPagePop, mySheet, "/common/approval/getCommonApprovalListPop_v2.do" , pagingMode);
}

/**
 * 메일 재발송기능
 */
function doMailSend(ordr_no, docu_user_id) {  	 
	var st_user_id = document.forms.buyerCommonMyPagePop.st_user_id.value;
	if(docu_user_id != st_user_id){
		//결재 상신자만 결재요청 메일 재발송이 가능 합니다.
		var text = "<%=CommonLang.msg("MSG644")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var pMethod ="mailSend";
	document.forms.buyerCommonMyPagePop.CUR_ORDER_NO.value  = ordr_no;
	kepAjaxFormCall("/common/approval/CommonApprovalMailSend.do","buyerCommonMyPagePop",pMethod); 
}
/**
 * FORM 을 넘기는 임시용
 * FORM 전체를 넘길는 submit 활용
 */
function approvalProcess(pMethod) {  	 

	var url = "";
	var passKn = "";
	var text = "";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "60px";
	var but2widthC = "60px";
	
	if (pMethod == "approval"){
		url = "<%=action_base%>Approval.do";
		text = "<%=CommonLang.get("HTITLE310")%>"; //결재
		text += " <%=CommonLang.msg("MSG389")%>"; //진행하시겠습니까?
		passKn = "1";
	}else if (pMethod == "reject"){
		if (kepIsEmpty("PASS_ADD") == true){
			//결재자의견에 반려사유가 입력되지 않았습니다.</br>이대로 반려 진행하시겠습니까?
			text = "<%=CommonLang.msg("MSG619")%>";
		}else{
			text = "<%=CommonLang.get("HTITLE238")%>"; //반려
			text += " <%=CommonLang.msg("MSG389")%>"; //진행하시겠습니까?
		}
		passKn = "3";
		url =  "<%=action_base%>Approval.do";
	}else if (pMethod == "cancel"){
		text = "<%=CommonLang.get("HTITLE229")%>"; //취소
		text += " <%=CommonLang.msg("MSG389")%>"; //진행하시겠습니까?
		passKn = "4";
		url = "<%=action_base%>Cancel.do";
	} else if (pMethod == "modify"){
		text = "<%=CommonLang.get("HTITLE781")%>"; //수정
		text += " <%=CommonLang.msg("MSG389")%>"; //진행하시겠습니까?
		url = "/common/approval/updateContent_v2.do";
	}
	
	but1funcC = "javascript:doApprovalProcess('"+passKn+"','"+url+"','"+pMethod+"'); return false;";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}

function doApprovalProcess(value1,url,pMethod){
	
	closePopText1();
	$("#PASS_KN").val(value1);//value1 = 1:결재 , 3:반려 , 4:취소 , "":수정
	kepAjaxFormCall(url,"buyerCommonMyPagePop",pMethod); 
}

function DraftSentenceView() //품의서출력
{
    var f = document.forms.buyerCommonMyPagePop;
    var docu_no = f.DOCU_NO.value;
    var company = f.COMPANY.value;
    var str = "<%=(String)ht.get("string_no")%>";
    var pr_no = "<%=key_1%>";
    var doc_title = "<%=CommonUtil.formatHTMLCode((String)ht.get("subject"))%>";
    var user_name = "<%=(String)ht.get("user_nm")%>";
    var buyer = "<%=COMPANY%>";
 
    reportOpen("<%=reportid%>","["+pr_no+"]["+buyer+"]["+docu_no+"]["+company+"]["+doc_title+"]["+user_name+"]");
 
   // window.open(loc,"DraftSentenceView","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
}
function prnSheet(){ //대상목록출력 (레거시에서 결재내역상세 팝업 > 품의서출력)
	var extif_tp = "<%=extif_tp%>";
		
	var buyer         = "<%=buyer%>"; //필수항목
	
	if(extif_tp == "PX"){
		var chgUserDept   = "<%=userDepartment%>"; //필수항목
		var addUserID     = "<%=userid%>"; //필수항목
		var prNo		  = mySheet2.GetCellValue(1,"REF_NO"); //다 같은 ref_no라서 첫번째꺼 가져오기
		var ref_no        = "";
		var add_date      = kepGetNowTimeStr('YYYYMMDD', '');
		var dept_name     = "<%=userDepartmentName%>";
		var dept_code     = "<%=userDepartment%>";
		var byca_comorg_level  = "<%=bycaComonrgLevel%>";
		var recv_flag     = mySheet2.GetCellValue(1,"RECV_FLAG"); //다 같은 recv_flag라서 첫번째꺼 가져오기
		var PO_NO     = mySheet2.GetCellValue(1,"PO_NO"); //다 같은 po_no라서 첫번째꺼 가져오기
		var fileName = "<%=PXreportid%>";
		var st_docu_subject = "<%=CommonUtil.formatHTMLCode(DOCU_TITLE)%>";
		//var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+chgUserDept+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"]";  // 통합된 파라미터
		var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"]["+PO_NO+"]["+st_docu_subject+"]";  // 통합된 파라미터
		console.log(param);
		reportOpen(fileName,param);
	}else if(extif_tp == "PR"){
		var chgUserDept   = "<%=userDepartment%>"; //필수항목
		var addUserID     = "<%=userid%>"; //필수항목
		var prNo          = "<%=key_1 %>";
		var ref_no        = "";
		var add_date      = kepGetNowTimeStr('YYYYMMDD', '');
		var dept_name     = "<%=userDepartmentName%>";
		var dept_code     = "<%=userDepartment%>";
		var byca_comorg_level  = "<%=bycaComonrgLevel%>";
		var recv_flag     = mySheet2.GetCellValue(1,"RECV_FLAG"); //다 같은 recv_flag라서 첫번째꺼 가져오기

		var fileName = "<%=PRreportid%>";
		//var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+chgUserDept+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"]";  // 통합된 파라미터
		var param =  "["+prNo+"]["+buyer+"]["+byca_comorg_level+"]["+recv_flag+"]["+add_date+"]["+dept_code+"]["+dept_name+"]["+ref_no+"][]";  // 통합된 파라미터
		console.log(param);
	  	reportOpen(fileName,param);
	}else if(extif_tp == "NS"){
		var nsNo          = "<%=key_1 %>";
		var fileName = "<%=NSreportid%>";
		
		var param =  "["+nsNo+"]["+buyer+"]";  // 통합된 파라미터
	  	reportOpen(fileName,param);
	}
}




function setPopupApprovalReturn(tmptmp1,tmptmp2,tmptmp3,tmptmp4,tmptmp5) {
	//alert(tmptmp1);
	//alert(tmptmp2);
	//alert(tmptmp3);
	$("#to").val(tmptmp1); // 결재
	$("#cc").val(tmptmp2); // 참조
	$("#ag").val(tmptmp5); // 합의
	$("#kto").html(tmptmp3); // 내용
	
	$("#toContent").val(tmptmp4); // 내용
}
function setPopupReturn(value1,value2,value3){
	if(popupSel == "rejectReasonPop"){
		var extif_tp = "<%=extif_tp%>";
		var query = "";
		var recv_flag = "";
		if(extif_tp == "PR"){ //구매요청
			recv_flag = "GR";
		}else if(extif_tp == "PX"){//구매발주
			recv_flag = "PR";
		} 

		var buyer = mySheet2.GetCellValue(grbRow,"BUYER");
		var pr_no = mySheet2.GetCellValue(grbRow,"PR_NO");
		var pr_seq = mySheet2.GetCellValue(grbRow,"PR_SEQ");
		query += buyer+"@@"+pr_no+"@@"+pr_seq+"@@"+recv_flag+"@@"+value1;
		
		document.forms.buyerCommonMyPagePop.st_query.value = query;
		
		kepAjaxFormCall("/common/popup/approval/rejectPrListPop_v2.do","buyerCommonMyPagePop","SAVE");
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	
	if (pMethod == "approval"){
		var text = "<%=CommonLang.get("HTITLE310")%>";//결재
		text += "<%=CommonLang.msg("MSG620")%>";//가 성공적으로 이루어 졌습니다.
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
		
	} else if (pMethod == "reject"){
		var text = "<%=CommonLang.get("HTITLE238")%>";//반려
		text += "<%=CommonLang.msg("MSG620")%>";//가 성공적으로 이루어 졌습니다.
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	} else if (pMethod == "cancel"){
		var text = "<%=CommonLang.get("HTITLE193")%>";//상신취소
		text += "<%=CommonLang.msg("MSG620")%>";//가 성공적으로 이루어 졌습니다.
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	} else if (pMethod == "modify"){
		var text = "<%=CommonLang.get("HTITLE781")%>";//수정
		text += "<%=CommonLang.msg("MSG621")%>";//이 성공적으로 이루어 졌습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
	} else if (pMethod == "request"){
		var text = "<%=CommonLang.get("HTITLE702")%>";//결재상신
		text += "<%=CommonLang.msg("MSG621")%>";//이 성공적으로 이루어 졌습니다.
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	} else if (pMethod == "SAVE"){
		var text = "<%=CommonLang.get("HTITLE238")%>";//반려
		text += "<%=CommonLang.msg("MSG620")%>";//가 성공적으로 이루어 졌습니다.
		openLayerPopText2(text,but1text,"javascript:thisPopReload(); return false;",but1width);
	} else if (pMethod == "mailSend"){
		var text = "<%=CommonLang.msg("MSG622")%>";//결재요청 메일을 재전송 하였습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
	} else if (pMethod == "runlWmReListPop"){
		var text = "<%=CommonLang.msg("MSG623")%>";//재실행 처리했습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	if (pMethod == "approval"){
		var text = "<%=CommonLang.get("HTITLE310")%>"; //결재
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
	}else if (pMethod == "return"){
		var text = "<%=CommonLang.get("HTITLE238")%>"; //반려
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
	}else if (pMethod == "cancel"){
		var text = "<%=CommonLang.get("HTITLE193")%>"; //상신취소
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
	} else if (pMethod == "modify"){
		var text = "<%=CommonLang.get("HTITLE781")%>"; //수정
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
	} else if (pMethod == "request"){
		var text = "<%=CommonLang.get("HTITLE702")%>"; //결재상신
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다. 
	} else if (pMethod == "SAVE"){
		var text = "<%=CommonLang.get("HTITLE238")%>"; //반려
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
	} else if (pMethod == "mailSend"){
		var text = "<%=CommonLang.get("HTITLE1053")%>"; //메일 재발송
		text += "<%=CommonLang.msg("MSG624")%>";//실패하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
	}
	
	openLayerPopText2(text,but1text,but1func,but1width);
}

function thisPopClose(){
	closePopText2();
	var tab_id = "<%=tab_id%>";
	opener.tabs[tab_id]["search"]();
	self.close();
	
}
function thisPopReload(){
	closePopText2();
	location.reload();
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
		//메일발송 버튼 활성화 (결재,합의 순번자)
		if((mySheet.GetCellValue(i,"CUR_ORDER_NO") == mySheet.GetCellValue(i,"ORDER_NO")) && (mySheet.GetCellValue(i,"PASS_TP")=="1" || mySheet.GetCellValue(i,"PASS_TP")=="3")){
			mySheet.SetCellValue(i,"MAIL_BUTTON","<%=CommonLang.get("HTITLE1054")%>"); //메일발송
		}
		
	}
	var extif_tp = "<%=extif_tp%>";
	if(extif_tp == "PR" || extif_tp == "PX"){ //주문요청,발주일때	
		mySheet.SetColWidth("PASS_ADD",610);
	}
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	var biz_url = "<%=new_biz_url%>";
	kepSearch(document.buyerCommonMyPagePop, mySheet2, biz_url , pagingMode);
}
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var extif_tp = "<%=extif_tp%>";
	var budget_flag = "<%=budget_flag%>";
	var pass_status_text = "<%=pass_status_text%>";
	
	var bag00003 = "<%=bag00003%>";
	var bag00004 = "<%=bag00004%>";
	
	var bag00005 = "<%=bag00005%>";
	var bag00006 = "<%=bag00006%>";
	
	var p04402705 = "<%=p04402705%>";
	
	var pass_status_text = "<%=pass_status_text%>";
	
	mySheet2.SetToolTipText(0,"IMAGE_KEY_YN","<%=CommonLang.get("HTITLE1393")%>"); //견적·주문 시 첨부한 파일
	
	if(extif_tp == "PR" || extif_tp == "PX"){ //주문요청,발주일때
		if(extif_tp == "PX"){ //주문발주일때 주문번호 컬럼 추가
			mySheet2.SetColHidden("PR_NO",false);
			if(bag00004 == "true"){ //구매사유 노출
				mySheet2.SetColHidden("PR_REASON",false);
			}
		}else if(extif_tp == "PR"){
			if(bag00003 == "true"){ //구매사유 노출
				mySheet2.SetColHidden("PR_REASON",false);
			}
			mySheet2.SetColWidth("SPECIFICATION",270);
		}
		
		if(budget_flag == "Y"){ //예산사용할 때 예산부서,계정 추가
			mySheet2.SetColHidden("PR_BUDGET_DEPT",false);
			mySheet2.SetColHidden("PR_ACCOUNT_TYPE",false);
		}
	}else if(extif_tp == "NS"){ //견적합의 결재 문서인 경우
		mySheet2.SetColHidden("QUOTATION_NO",false);
	}
	
	var rejectFlag = false;
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		mySheet2.SetCellValue(i,"ORDER_NO",i);
		if(mySheet2.GetCellValue(i,"RECV_FLAG_TEXT") != ""){ //부분반려 있을 시
			rejectFlag = true;
		}
		
		mySheet2.SetToolTipText(i, "PR_REASON", mySheet2.GetCellValue(i, "PR_REASON")); //구매사유 TOOLTIP처리
		mySheet2.SetToolTipText(i, "PRDT_REMARK", mySheet2.GetCellValue(i, "PRDT_REMARK")); //구매사유 TOOLTIP처리
		
		if(extif_tp == "PX"){ //주문발주일때 주문번호 컬럼 추가
			if(bag00006 == "true" && pass_status_text == "결재대기"){ //예산계정 변경
				mySheet2.SetCellFontColor(i,"PR_ACCOUNT_TYPE","#3a72c7");
				mySheet2.SetCellCursor(i,"PR_ACCOUNT_TYPE","Pointer");
			}
		}else if(extif_tp == "PR"){
			if(bag00005 == "true" && pass_status_text == "결재대기"){ //예산계정 변경
				mySheet2.SetCellFontColor(i,"PR_ACCOUNT_TYPE","#3a72c7");
				mySheet2.SetCellCursor(i,"PR_ACCOUNT_TYPE","Pointer");
			}
		}else if(extif_tp == "NS"){ //견적합의 결재 문서인 경우
			if(p04402705 == "true"){ //견적상세팝업 활성화
				mySheet2.SetCellFontColor(i,"QUOTATION_NO","#3a72c7");
				mySheet2.SetCellCursor(i,"QUOTATION_NO","Pointer");
			}
		}
	}
	
	
	if(pass_status_text == "결재대기"){
		if(mySheet2.RowCount()>1){
			mySheet2.SetColHidden("REJECT_BUTTON",false);
			for(var i = 1; i<=mySheet2.RowCount(); i++){
				mySheet2.SetCellValue(i,"REJECT_BUTTON","반려");
			}
		}
	}else{
		mySheet2.SetColHidden("RECV_FLAG_TEXT",false);
		mySheet2.SetColHidden("RETURN_REASON",false);
		if(rejectFlag){
			$("#rText").show();
			$("#rText2").show();
			$("#rAmt").show();
			$("#rAmt2").show();
		}
	}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	var docu_user_id = mySheet.GetCellValue(Row,"DOCU_USER_ID");
	var ordr_no = mySheet.GetCellValue(Row,"ORDER_NO");
	if(column == "MAIL_BUTTON"){ // 메일발송
		var st_user_id = document.forms.buyerCommonMyPagePop.st_user_id.value;
		if(docu_user_id != st_user_id){
			//결재 상신자만 결재요청 메일 재발송이 가능 합니다.
			var text = "<%=CommonLang.msg("MSG644")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		var pMethod ="mailSend";
		document.forms.buyerCommonMyPagePop.CUR_ORDER_NO.value  = ordr_no;
		kepAjaxFormCall("/common/approval/CommonApprovalMailSend.do","buyerCommonMyPagePop",pMethod);
	}
	return;
}
//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;
	
	var extif_tp = "<%=extif_tp%>";
	var pass_status_text = "<%=pass_status_text%>";
	
	var bag00005 = "<%=bag00005%>";
	var bag00006 = "<%=bag00006%>";
	var p04402705 = "<%=p04402705%>";
	
	var buyer = mySheet2.GetCellValue(Row,"BUYER");
	var pr_no = mySheet2.GetCellValue(Row,"PR_NO");
	var pr_seq = mySheet2.GetCellValue(Row,"PR_SEQ");
	var req_dept = mySheet2.GetCellValue(Row,"REQ_DEPT");
	var req_dept_name = mySheet2.GetCellValue(Row,"REQ_DEPT_NAME");
	var byit_comorg_code = mySheet2.GetCellValue(Row,"BYIT_COMORG_CODE");
	var contract_no = mySheet2.GetCellValue(Row,"CONTRACT_NO");
	var contract_seq = mySheet2.GetCellValue(Row,"CONTRACT_SEQ");
	var buyer_item_no = mySheet2.GetCellValue(Row,"BUYER_ITEM_NO");
	var image_key = mySheet2.GetCellValue(Row,"IMAGE_KEY");
	var msds_no = mySheet2.GetCellValue(Row,"MSDS_NO");
	
	var quotation_no = mySheet2.GetCellValue(Row,"QUOTATION_NO");
	var quotation_seq = mySheet2.GetCellValue(Row,"QUOTATION_SEQ");
	var revision = mySheet2.GetCellValue(Row,"REVISION");
	
	var budget_dept_name = mySheet2.GetCellValue(Row,"PR_BUDGET_DEPT");
	var budget_account_name = mySheet2.GetCellValue(Row,"PR_ACCOUNT_TYPE");
	var budget_account_code = mySheet2.GetCellValue(Row,"ACCOUNT_TYPE");
	var amt = mySheet2.GetCellValue(Row,"PO_AMT");
	
	if(column == "BUYER_ITEM_NO"){ // 품목코드 클릭 시
		//기존 공통 카탈로그
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+byit_comorg_code+"&BUYER_ITEM_NO="+escape(buyer_item_no)+"&CONTRACT_NO="+contract_no+"&CONTRACT_SEQ="+contract_seq+"&popupCheck=N";
		openLayerPop(src,"650px","600px");
		
		//새로 만든 품목 간략 팝업
// 		popupSel = "buyerMdCmGoodsLisDetailPop";
// 		var src = "/mdcm/getBuyerMdCmGoodsLisDetailPop_v2.do?stdcateg_id="+""+"&buyer="+byit_comorg_code+"&buyer_tem_no="+buyer_item_no;
// 		openLayerPop(src,"875px","880px");
		
// 		openSearchPopup('/mdcm/getBuyerMdCmGoodsLisDetailPop_v2.do','?stdcateg_id='+''+'&buyer='+byit_comorg_code+'&buyer_tem_no='+buyer_item_no,'875,880,no');
	}else if(column == "IMAGE_KEY_YN"){
		if(mySheet2.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		location.href="/common/download_v2.do?DOC_NO="+image_key;
// 		var src = '/common/fileUploadPop_v2.do?DOC_NO='+st_seller_image_key+'&viewType=R';
// 		openLayerPop(src,"600px","490px");
        
// 		openSearchPopup("/common/fileUploadPop_v2.do", '?DOC_NO='+image_key+'&viewType=R', "600,490,no");
	}else if(column == "REJECT_BUTTON"){
		if(mySheet2.GetCellValue(Row, "REJECT_BUTTON") == "")
			return;
		
		popupSel = "rejectReasonPop";
		
		var cancel_remark = "";
		viewType = 'rejectPr';
		var src = '/common/remarkCancelPop.do?cancel_remark='+cancel_remark+'&viewType='+viewType;
		openLayerPop(src,"500px","340px");
	}else if(column == "PR_ACCOUNT_TYPE"){
		if(extif_tp == "PX"){ //주문발주일때 주문번호 컬럼 추가
			if(bag00006 == "true" && pass_status_text == "결재대기"){ //예산계정 변경
				var st_form_name = "changeAccountForm";
				var st_popup_url = "/mpso/showBuyerMpSoChangeAccountPop.do";
				var st_popup_param = "open@@N^||^com_code@@"+buyer+"^||^"+"pr_no@@"+pr_no+"^||^"+"pr_seq@@"+pr_seq+"^||^"+"dept_code@@"+req_dept+"^||^"+"dept_name@@"+req_dept_name+"^||^"+"cur_dept_name@@"+budget_dept_name+"^||^"+"cur_account_name@@"+budget_account_name+"^||^"+"cur_account_code@@"+budget_account_code+"^||^"+"cur_amt@@"+amt;
				var st_popup_option = "760,830,no";
				//post 팝업 호출
				openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
			}
		}else if(extif_tp == "PR"){
			if(bag00005 == "true" && pass_status_text == "결재대기"){ //예산계정 변경
				var st_form_name = "changeAccountForm";
				var st_popup_url = "/mpso/showBuyerMpSoChangeAccountPop.do";
				var st_popup_param = "open@@N^||^com_code@@"+buyer+"^||^"+"pr_no@@"+pr_no+"^||^"+"pr_seq@@"+pr_seq+"^||^"+"dept_code@@"+req_dept+"^||^"+"dept_name@@"+req_dept_name+"^||^"+"cur_dept_name@@"+budget_dept_name+"^||^"+"cur_account_name@@"+budget_account_name+"^||^"+"cur_account_code@@"+budget_account_code+"^||^"+"cur_amt@@"+amt;
				var st_popup_option = "760,830,no";
				//post 팝업 호출
				openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
			}
		}
	}else if(column == "MSDS_NO"){
		if(msds_no != ""){
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop_v2.do","?st_msds_no="+msds_no, '750,700,no');
		}
	}else if(column == "QUOTATION_NO"){
		if(p04402705 == "true"){
			openSearchPopup("/common/getQuotDetailInfoPop_v2.do", "?st_buyer="+buyer+"&st_quotation_no="+quotation_no+"&st_quotation_seq="+quotation_seq+"&st_revision="+revision, "530,660,yes");
		}
	}
	return;
}
//그리드 셀클릭 이벤트
function mySheet2_OnChange(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
	return;
}

</script> 
<body onload="kep_onload_view()">
	 <form name=buyerCommonMyPagePop id=buyerCommonMyPagePop method=post onkeydown="return captureReturnKey(event)">  
<input type="hidden" name="s_SAVENAME" />
<input type="hidden" name="VIEW" id="VIEW"  value="buyerCommonPassStatusPop_v2"> 
<input type=hidden name="PASS_KN" id="PASS_KN">
<input type=hidden name="PASS_TP" id="PASS_TP" value="<%=PASS_TP%>">
<input type=hidden name="COMPANY" value="<%=COMPANY%>">
<input type=hidden name="DOCU_NO" value="<%=DOCU_NO%>">
<input type=hidden name="CUR_ORDER_NO"  value=""> 
<input type=hidden name="to" id="to" value="<%=(String)ht.get("to")%>">
<input type=hidden name="cc" id="cc"  value="<%=(String)ht.get("cc")%>">
<input type=hidden name="ag" id="ag"  value="<%=(String)ht.get("ag")%>">
<input type=hidden name="att_fn" value="<%=(Integer)ht.get("attach_cnt")%>">
<input type=hidden name="url" value="<%=request.getRequestURI()%>"> 
<input type=hidden name="DOC_TYPE" value="<%=(String)ht.get("extif_tp")%>">  <!--  상신일경우에는 수정 필요 -->
<input type=hidden name="EXTIF_TP" value="<%=(String)ht.get("extif_tp")%>">  <!--  상신일경우에는 수정 필요 -->
<input type=hidden name="DOCU_KN" value="1">  <!--  상신일경우에는 수정 필요 문서종류(1:결재문서) -->
<input type=hidden name="DOCU_TITLE" id="DOCU_TITLE" value="<%=CommonUtil.nvl((String)ht.get("subject")).replace("\"", "&quot;")%>">  <!--  상신일경우에는 수정 필요 --> 
<input type=hidden name="KEY_1" value="<%=key_1%>">  <!--  key_1 업무에서 만들어진 키  -->
<input type=hidden name="KEY_2" value="<%=key_2%>">  <!--  key_2 업무에서 만들어진 키  -->
<input type=hidden name="KEY_3" value="<%=key_3%>">  <!--  key_3 업무에서 만들어진 키  -->
 <input type=hidden name="toContent" id="toContent"  value=""> 
 <input type="hidden" name="FLAG" id="FLAG"  value="<%=FLAG%>">
 <input type="hidden" name="DT_DISPLAY" id="DT_DISPLAY"  value="<%=dt_displaly%>"> 
<input type="hidden" name="st_buyer" id="st_buyer"  value=""/>
<input type="hidden" name="st_pr_no" id="st_pr_no"  value=""/> 
<input type="hidden" name="st_pr_seq" id="st_pr_seq"  value=""/>
<input type="hidden" name="st_prrecv_flag" id="st_prrecv_flag"  value=""/>
<input type="hidden" name="st_return_reason" id="st_return_reason"  value=""/>  
<input type="hidden" name="st_query" id="st_query"  value=""/>
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">	
<input type="hidden" name="pass_status_text" id="pass_status_text" value="<%=pass_status_text%>">
 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1055")%><!--결재상세--><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopByerTab mt10">
   <button class="TabTit active" data-tab="Search1" onclick="return false;"><%=CommonLang.get("HTITLE1055")%><!--결재상세--></button>
   <button class="TabTit" data-tab="Search2" onclick="return false;"><%=CommonLang.get("HTITLE1056")%><!--대상목록--></button> 
  </div>
  <div id="Search1" class="PopByerContent active">
	<table class="PopTableThL1TdL mt20" width="100%">
      <colgroup>
        <col width="12%" />
        <col width="38%" />
        <col width="12%" />
        <col width="38%" />
  	  </colgroup>
      <tr>
        <th><%=CommonLang.get("HTITLE770") %><!-- 결재대상 --></th>
        <td colspan="3"><%=extif_tp_text %></td>
	  </tr>
      <tr>
        <th><%=CommonLang.get("HTITLE700") %><!-- 결재현황 --></th>
        <td colspan="3" style=" line-height:30px">
          <span class="ChipsDefault_Green mr05"><%=pass_status_text %></span> 
          <button class="RoundButton_LeftIcon24_00" id="detailBtn" style="display:inline-block; vertical-align:middle;" onclick="return false;"><img id="iconArrow" src="/resources/imgs/arrow_top_Btn40_02.png" /> <span id="btnText"><%=CommonLang.get("HTITLE1057") %><!-- 상세닫기 --></span></button>
          <%if(pass_status.equals("0") && user_id.equals(userid)) {%>
          	<%if(!(p060000059==true&&userType.equals("U"))){%>
          		<button class="ButOutlineBlue_Small" style=" float:right; vertical-align:middle;" onclick="approvalLine('<%=COMPANY%>','<%=DOCU_NO%>'); return false;"><%=CommonLang.get("HTITLE1062")%><!--결재경로 관리--></button>
          	<%} %>
          <%} %>
          <div class="searchWrap" id="searchWrap"  style="clear:both">
          	<div class="h1" style="height: 10px;"></div>
          	<%if(extif_tp.equals("PR") || extif_tp.equals("PX")) {%>
          		<div class="IBSheetBuyer" style="height:170px; width: 1440px;" >
          	<%}else{ %>
           	  <div class="IBSheetBuyer" style="height:170px; width: 1180px;" >
          	<%} %>
			   	 <script type="text/javascript">
			       	createIBSheet("mySheet", "", "100%");
			     </script>
			  </div><!--IBSheetBuyer 끝 -->
          </div>
		  <script>
              const detailBtn = document.getElementById('detailBtn');
              const searchWrap = document.getElementById('searchWrap');
              const btnText = document.getElementById('btnText');
              const iconArrow = document.getElementById('iconArrow');
            
              let isCollapsed = false; // 처음 열린 상태
            
              detailBtn.addEventListener('click', function(){
                isCollapsed = !isCollapsed;
                searchWrap.classList.toggle('collapsed', isCollapsed);
            
                if (isCollapsed) {
                  btnText.textContent = "<%=CommonLang.get("HTITLE1030")%>"; //상세보기
                  iconArrow.classList.add('rotate');
                } else {
                  btnText.textContent ="<%=CommonLang.get("HTITLE1057")%>"; //상세닫기
                  iconArrow.classList.remove('rotate');
                }
              });
		  </script>        
        </td>
	  </tr>
      <tr>
        <th><%=CommonLang.get("HTITLE304") %><!-- 제목 --></th>
        <td><%=(String)ht.get("subject")%></td>
        <th><%=CommonLang.get("HTITLE119") %><!-- 첨부파일 --><button class="But_question" onclick="return false;" ><img src="/resources/imgs/Icon_question.png" title="<%=CommonLang.get("HTITLE1387")%>"/></button><!-- 결재 상신 시 첨부한 파일 --></th>
        <td>
        <%if(CommonUtil.nvl((String)ht.get("image_key")) != null && !CommonUtil.nvl((String)ht.get("image_key")).equals("")) {%>
        <a href="javascrtip:fileDownload('<%=CommonUtil.nvl((String)ht.get("image_key"))%>');"><span class="font700"><%=CommonUtil.formatNumber(ht.get("image_key_cnt"),true,0,3)%> <%=CommonLang.get("HTITLE595")%><!-- 건 --></span></a> &nbsp;&nbsp;<button class="ButDownload_Tiny_Outline" onclick="javascrtip:fileDownload('<%=CommonUtil.nvl((String)ht.get("image_key"))%>'); return false;">다운로드</button>
        <%} %>
        </td>
	  </tr>
      <tr>
      	<%if(extif_tp.equals("PR") || extif_tp.equals("PX")){ %>
      	<th><%=CommonLang.get("HTITLE1058")%><!--주문품목수--></th>
        <td ><span class="font700"><%=CommonUtil.formatNumber(ht.get("cnt"),true,0,3)%> <%=CommonLang.get("HTITLE595")%><!-- 건 --></span></td>
        <th><%=CommonLang.get("HTITLE1059")%><!--주문금액--> &nbsp;<span style="color: red; display: none;" id="rText" >(<%=CommonLang.get("HTITLE1096")%><!--반려금액-->)</span></th>
        <td ><span class="font700"><%=CommonUtil.formatNumber(ht.get("price"),true,0,3)%> <%=CommonLang.get("HTITLE660")%><!-- 원 --></span>&nbsp;<span style="color: red; display: none;" id="rAmt" >(<%=CommonUtil.formatNumber(ht.get("rAmt"),true,0,3)%> <%=CommonLang.get("HTITLE660")%><!-- 원 -->)</span></td>
      	
     	<%}else if(extif_tp.equals("NG") || extif_tp.equals("NS")) {%>
      	<th><%=CommonLang.get("HTITLE1060")%><!--견적품목수--></th>
        <td ><span class="font700"><%=CommonUtil.formatNumber(ht.get("cnt"),true,0,3)%> <%=CommonLang.get("HTITLE595")%><!-- 건 --></span></td>
        <th><%=CommonLang.get("HTITLE1061")%><!--견적단가합산--></th>
        <td ><span class="font700"><%=CommonUtil.formatNumber(ht.get("price"),true,0,3)%> <%=CommonLang.get("HTITLE660")%><!-- 원 --></span></td>
		<%} %>
		
	  </tr>
      <tr style="height:137px;">
        <th><%=CommonLang.get("HTITLE441")%><!--내용--></th>
        <td colspan="3">
	        <div class="TextField">
	           <textarea  id="DOCU_CONT"  name="DOCU_CONT" style=" width:95%; height:100px;" maxlength="500" placeholder="" readonly="readonly"><%=content%></textarea>
	        </div>
        </td>
        <%if(pass_status_text.equals("결재대기")){ %>
        <tr>
        <th><%=CommonLang.get("HTITLE1050")%><!--결재자의견--> <span>*</span></th>
        <td colspan="3"><div class="TextField" id="limitedArea">
           <textarea id="PASS_ADD" name="PASS_ADD" style=" width:95%; height:25px;" maxlength="100" placeholder=""></textarea>
            <div class="meta" aria-live="polite"> <span id="count">0</span>/100 </div>
          </div>
		  <script>
          (function () {
            const wrap = document.getElementById('limitedArea');
            const ta   = document.getElementById('PASS_ADD');
            const cnt  = document.getElementById('count');
            const MAX  = parseInt(ta.getAttribute('maxlength'), 10);
            function update() {
              const len = ta.value.length;
              cnt.textContent = len;
            }
            // 초기 상태 반영 및 입력 시 업데이트
            update();
            ta.addEventListener('input', update);
          })();
		  </script>               
        </td>
	  </tr>
	  <%} %>
	</table>   
       
  </div><!--id="Search1"끝 -->  
  
  
  <div id="Search2" class="PopByerContent">
	<div class="PopupListBtnBox  mt20"><button class="But_ExcelDown40" onclick="javascript:excelDown(); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
    </div>
    <table class="PopTableThL1TdL mt10" width="100%">
     <colgroup>
      <col width="25%" />
      <col width="25%" />
      <col width="25%" />
      <col width="25%" />
  	 </colgroup>
     <tr>
     <%if(extif_tp.equals("PR") || extif_tp.equals("PX")){ %>
      	<th><%=CommonLang.get("HTITLE1058")%><!--주문품목수--></th>
        <td style="text-align:right"><span class="font700"><%=CommonUtil.formatNumber(ht.get("cnt"),true,0,3)%> <%=CommonLang.get("HTITLE595")%><!-- 건 --></span></td>
        <th><%=CommonLang.get("HTITLE1059")%><!--주문금액--> &nbsp;<span style="color: red; display: none;" id="rText2" >(<%=CommonLang.get("HTITLE1096")%><!--반려금액-->)</span></th>
        <td style="text-align:right"><span class="font700"><%=CommonUtil.formatNumber(ht.get("price"),true,0,3)%> <%=CommonLang.get("HTITLE660")%><!-- 원 --></span>&nbsp;<span style="color: red; display: none;" id="rAmt2" >(<%=CommonUtil.formatNumber(ht.get("rAmt"),true,0,3)%> <%=CommonLang.get("HTITLE660")%><!-- 원 -->)</span></td>
      	
     <%}else if(extif_tp.equals("NG") || extif_tp.equals("NS")) {%>
      	<th><%=CommonLang.get("HTITLE1060")%><!--견적품목수--></th>
        <td style="text-align:right"><span class="font700"><%=CommonUtil.formatNumber(ht.get("cnt"),true,0,3)%> <%=CommonLang.get("HTITLE595")%><!-- 건 --></span></td>
        <th><%=CommonLang.get("HTITLE1061")%><!--견적단가합산--></th>
        <td style="text-align:right"><span class="font700"><%=CommonUtil.formatNumber(ht.get("price"),true,0,3)%> <%=CommonLang.get("HTITLE660")%><!-- 원 --></span></td>
	<%} %>
     </tr>
    </table>
    <div class="h20"></div>
    <% if ("PX".equals(extif_tp) || "PR".equals(extif_tp)) { %>
    <div class="IBSheetBuyer" style="height:370px;width: 1580px;">
    <%}else{ %>
    <div class="IBSheetBuyer" style="height:370px;width: 1320px;">
    <%} %>
    	<script type="text/javascript">
    		createIBSheet("mySheet2", "", "100%");
    	</script>
	</div>
  </div><!--id="Search2" 끝 -->
  
  <div class="PopupListBtnBox_Center mt30">
      <button class="ButQuaternary_large closePopup" onclick="javascript:DraftSentenceView(); return false;"><%=reportText%></button>
      <% if (!"NG".equals(extif_tp)) { %>
      <button class="ButQuaternary_large closePopup" onclick="javascript:prnSheet(); return false;"><%=CommonLang.get("HTITLE1511") %><!-- 대상목록출력 --></button>
      <%} %>
      <%if(pass_status_text.equals("결재대기")) {%>
      <button class="ButQuaternary_large" onclick="javascript:approvalProcess('reject'); return false;"><%=CommonLang.get("HTITLE238") %><!-- 반려 --></button>
      <button class="ButPrimary_large" onclick="javascript:approvalProcess('approval'); return false;"><%=CommonLang.get("HTITLE310") %><!-- 결재 --></button>
      <%} %>
      <%if(pass_status.equals("0") && user_id.equals(userid)) {%>
      	<% if (!"NG".equals(extif_tp)) { %>
	      <button class="ButQuaternary_large" onclick="javascript:approvalProcess('cancel'); return false;"><%=CommonLang.get("HTITLE193") %><!-- 상신취소 --></button>
      	<%} %>
      <%} %>
      <%if(pass_status_text.equals("상신완료")) {%>
      <button class="ButPrimary_large" onclick="javascript:approvalProcess('modify'); return false;"><%=CommonLang.get("HTITLE781") %><!-- 수정 --></button>
      <%} %>
    </div>         
  <!-- 탭 스크립트 -->     
  <script>
      const tabLinks = document.querySelectorAll(".TabTit");
      const tabContents = document.querySelectorAll(".PopByerContent");
      tabLinks.forEach(function(link) {
        link.addEventListener("click", function() {
          // 모든 탭 버튼, 컨텐츠 비활성화
          tabLinks.forEach(function(btn){btn.classList.remove("active")});
          tabContents.forEach(function(content){content.classList.remove("active")});
    
          // 클릭한 탭 활성화
          link.classList.add("active");
          document.getElementById(link.dataset.tab).classList.add("active");
        });
      });
  </script> 
 
</div><!-- wrapPopup 끝-->       
</form>  
</body>

</html>
