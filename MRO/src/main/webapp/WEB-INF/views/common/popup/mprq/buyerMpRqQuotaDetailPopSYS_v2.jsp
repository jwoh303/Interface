<%--
**********************************************
* 메뉴 : 
* 화면 : 견적상세
* 기능 : 견적상세
* 프로그램 ID : BU0301005
* 담당자 : 이민아
* 착수일 : 2026-02-11
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
<%@ include file="../../include/head_v2.jspf"  %>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />

<script>
window.calendarPositionOffset = {
		top:-150,
		left:-250
	};
</script>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataMap = (Map<String,String>) request.getAttribute("data"); // 조회된 결과

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)  
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)  
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");  //  (조회조건)  
String reporttype = CommonUtil.nvl((String) request.getParameter("reportType"),"");  //  (조회조건)
String reportid = CommonUtil.nvl((String) request.getParameter("reportId"),"");  //  (조회조건)
String type = CommonUtil.nvl((String) request.getParameter("type"),"");  //  (조회조건) 호출한 탭의 숫자
String st_idx = CommonUtil.nvl((String) request.getParameter("st_idx"),"");  //  (조회조건) ibsheet에서 클릭한 행 숫자
String st_page = CommonUtil.nvl((String) request.getParameter("st_page"),"2");
String status = CommonUtil.nvl(_dataMap.get("SOURCING_STATUS"),"");

String com_code = _sessionInfo.getComCode();
String user_group = _sessionInfo.getUserGroup();
String user_id = _sessionInfo.getUserId();

// 애경 결재 상신 후 추가 로직
boolean bqt00002 = CommonUtil.getSpecialCheckReturn(com_code, "BQT00002");
%>
<script>
var mySheet1 = new ibsheetObject();
var pagingMode = "N";

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch= "javascript:thisPopClose(); return false;";
var but1width = "120px";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet1 = {};
	initsheet1.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet1.Cols = [
		 { Align:"Center",	SaveName:"SEQ",					Header:"번호",		Type:"Seq",		Width:40,	Edit:true,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"SOURCING_STATUS",Header:"진행상태",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"REVISION",			Header:"차수",		Type:"Text",	Width:80,	Edit:false,	EditLen:100, 	Hidden:false}
		,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",		Type:"Text",	Width:220,	Edit:false,	EditLen:100,	Hidden:false}							
		,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",		Type:"Text",	Width:150,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"SPECIFICATION",		Header:"규격",		Type:"Text",	Width:150,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"ITEM_QTY",			Header:"수량",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"LEAD_TIME",			Header:"배송일자",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"BUYER_TARGET_PRICE",	Header:"목표단가",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"BTOA_REMARK",			Header:"비고",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"CANCEL_REMARK",		Header:"취소사유",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"IMAGE_KEY_CNT",		Header:"첨부",		Type:"Button",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	ClassName:'Type03'}
		,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"첨부",		Type:"Text",	Width:80,	Edit:false,	EditLen:100,	Hidden:true}		
		,{ Align:"Center",	SaveName:"KEP_USER_NAME",		Header:"KeP담당자",	Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"KEP_USER_TEL",		Header:"전화번호",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"KEP_USER_EMAIL",		Header:"이메일",		Type:"Text",	Width:60,	Edit:false,	EditLen:100,	Hidden:false}
		,{ Align:"Center",	SaveName:"SOURCING_STATUS",		Header:"진행상태",		Type:"Text",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}
	];
	
	IBS_InitSheet(mySheet1, initsheet1, pagingMode);
	
	mySheet1.SetHighlightAfterSort(2);
	mySheet1.SetHeaderBackColor("#f2f7ff");
	mySheet1.SetTheme("DB", "DeepBlue");
	
	kepSearch(document.contentForm2, mySheet1, "/common/getBuyerMpRqDetailAllPop_v2.do" , pagingMode);

}
//조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	
	if(column == "IMAGE_KEY_CNT"){
		if(mySheet1.GetCellValue(Row, "IMAGE_KEY") == "")
			return;
		var st_image_key = mySheet1.GetCellValue(Row, "IMAGE_KEY");
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}
	
	return;
}
function quotation_print() { // 견적서 출력
	var buyer = "<%=st_buyer%>";
	var quotation_no = "<%=st_quotation_no%>";
	var quotation_seq = "<%=st_quotation_seq%>";
	var revision = "<%=st_revision%>";
	var agent = "<%=st_agent%>";
	
	if(isEmpty(agent)) {
		//견적서가 발행되지 않은 품목입니다.
        var text ="<%=CommonLang.msg("MSG111")%>";
        openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	open_flag = "N";   // 협력사는 무조건 안보이게 되어있음
	var fileName = "<%=reportid%>";
	var type = "<%=reporttype%>";
	var pageType = "<%=type%>"; 
	
	if(pageType == "3"){ // 단가합의 화면에서 연 경우
		//SLOGIC-BEGIN(P04-4027-02)
		var param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+buyer_item_no+"]";
		if (type == "A"){
			param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+buyer_item_no+"]";
		} else if (type == "E"){
			var query = "";
			param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+query+"]";
		} else if (type == "F"){
			param =  "["+buyer_item_no+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+buyer+"]";
		}
		
	}else{ // type == 1 OR type == 2
		var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+agent+"]["+open_flag+"]";
		if (type == "A"){
			param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+open_flag+"]";
		}
	}
	
  	reportOpen(fileName,param);
/*
A	RD_04_B_004_01
B	RD_04_M_004_03
C	RD_04_B_006_02
D	RD_04_B_004_05
E	RD_04_B_006_03
F	RD_04_B_006_04
*/
	//SLOGIC-END
  	reportOpen(fileName,param);
  	
  	param = encodeURI(param);
  	
<%-- 	if(<%=bqt00001%> == true && pageType != 3){//셰플러코리아만 견적서 상세 출력. --%>
// 		var url = "/coco/showReportViewer.do";
// 		window.open(url + "" + "?fileName=RD_04_M_004_11&param="+param, "","width=770,height=800,resizable=YES");	
// 	}
	
	return;
}

function cancelRqdt(){ //견적취소
	
	if(isEmpty($("#st_cancle_remark").val())){
		var text = "취소사유를 입력하여 주십시오";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_cancle_remark").focus();
		return;
	}
	
    var text = "상품 견적을 취소하시겠습니까?";	
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveBuyerMprqCancelList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function saveBuyerMprqCancelList_v2(){
	var temp_remark = $("#st_cancle_remark").val().replace(/\r?\n/g, '<br>');
	closePopText1();
	opener.tabs["buyerMpRqQuota_tab<%=type%>"]["setPopupReturn"]("cancelRqdt","<%=st_idx%>",temp_remark);
	self.close();
	return;
}
function negoSubmit(){ // 네고요청 

   	var st_confirm_price = <%=CommonUtil.nvl(String.valueOf(_dataMap.get("ATOB_UNIT_PRICE")))%>; // 견적단가 --%>
   	
   	if(st_confirm_price == "0") {
   		var text = "<%=CommonLang.msg("MSG599")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return false;
    }

	
	var today = kepGetNowTimeStr('YYYYMMDD','');
	var st_btoa_end_date = $('#st_btoa_end_date').val().replace(/\//g, '');

	if(kepIsValueNull($('#st_btoa_nego_price').val())) {
		var text ="<%=CommonLang.msg("MSG524")%>";	//Nego 단가(숫자형식)를 입력하여 주십시요.
		$('#st_btoa_nego_price').focus();
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	if(!kepIsNumChk('st_btoa_nego_price',2)) {
		var text ="<%=CommonLang.msg("MSG524")%>";	//Nego 단가(숫자형식)를 입력하여 주십시요.
		$('#st_btoa_nego_price').focus();
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}	
	
	if($('#st_btoa_nego_price').val() <= 0) {
		var text ="<%=CommonLang.msg("MSG525")%>";	//Nego 단가를 입력하여 주십시요.
		$('#st_btoa_nego_price').focus();
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(kepIsValueNull($('#st_btoa_end_date').val())) {
		var text ="<%=CommonLang.msg("MSG526")%>";	//Nego 회신 요청일을 입력하여 주십시요.
		$('#st_btoa_end_date').focus();
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	if (st_btoa_end_date < today){
		var text ="<%=CommonLang.msg("MSG527")%>";	//오늘 이후의 날짜를 선택하세요.
		$('#st_btoa_end_date').focus();
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(kepIsValueNull($('#st_btoa_end_date').val())) {
		var text ="<%=CommonLang.msg("MSG526")%>";	//Nego 회신 요청일을 입력하여 주십시요.
		$('#st_btoa_end_date').focus();
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	if(isEmpty($("#st_nego_remark").val())){
		var text = "요청사항을 입력하여 주십시오";
		$("#st_nego_remark").focus();
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var text = "Nego 요청하시겠습니까?";	
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveBuyerMprqNegoList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
}
function saveBuyerMprqNegoList_v2(){
	var temp_remark = $("#st_nego_remark").val().replace(/\r?\n/g, '<br>');
	var nego_price = $("#st_btoa_nego_price").val();
	var btoa_end_date = $('#st_btoa_end_date').val().replace(/\//g, '');
	
	closePopText1();
	opener.tabs["buyerMpRqQuota_tab<%=type%>"]["setPopupReturn"]("negoRqdt","<%=st_idx%>",nego_price,temp_remark,btoa_end_date);
}

function confirmKepPrice(){ // 단가합의
	var msds_yn = $("#st_msds_yn").val();
	var msds_status = $("#st_msds_status").val();
	var st_confirm_price = $("#st_confirm_price").val();
	
	if(st_confirm_price == 0 || st_confirm_price == "0" || st_confirm_price == "") {
		var text = "<%=CommonLang.msg("MSG599")%>"; //견적단가 0원인 건은 합의할 수 없습니다. KEP담당자에게 문의 바랍니다.
		openLayerPopText2(text, but1text, but1func, but1width); 
		return;
	}
	if($("#st_item_gubun").val() == "I"){
		doos_item_no_back = $("#st_doos_item_no_back").val();
    	if(kepIsValueNull(kepTrimStr(doos_item_no_back))) {
    		var text = "<%=CommonLang.msg("MSG84")%>"; //재고코드가 입력되지 않았습니다.
			openLayerPopText2(text,but1text,but1func,but1width);
             return;
        }	            		
	}
	if(msds_yn == "Y"){
    	if(msds_status != "A"){
              var text = "<%=CommonLang.msg("MSG784")%>"; //MSDS가 승인되지 않았습니다.
				  openLayerPopText2(text,but1text,but1func,but1width);
              return;
        }	            		
    }
	
	var text = "<%=CommonLang.msg("MSG361")%>";	//단가합의 하시겠습니까?
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:proceedConfirmKepPrice(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
	return;
}

function proceedConfirmKepPrice() {
	closePopText1();
	var chkFlag = false;
	var chkGridValue = {};
	var formArr = getFormToArr_v2("document.forms.contentForm1",chkFlag,chkGridValue);
	
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value = formArr[0];
		$("#process").html(formArr[1]);
	} else {
		var text = "<%=CommonLang.msg("MSG13")%>"; //그리드 데이터 변환에 실패하였습니다.
		openLayerPopText2(text, but1text, but1func, but1width); 
        return;
	}
	
	kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntMulti.do", "processForm", "confirmKepPrice");
}

function cartCheck() { // 장바구니 담기
	var tmpQuery = "";
   
   	if("<%=CommonUtil.nvl(_dataMap.get("BTOA_USER_ID"))%>" != "<%=user_id%>"){
   		var text = "<%=CommonLang.msg("MSG103")%>";//본인 요청건만 장바구니담기가 가능합니다.
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
   	}
   	if("<%=status%>" != 'RQ02' && "<%=status%>" != 'RQ03'){ // 장바구니, 합의완료 (COD1.C023)
		var text = "<%=CommonLang.msg("MSG101")%>"; //합의완료된 품목들만 장바구니에 담을수 있습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
      	}
   	if("<%=CommonUtil.nvl(_dataMap.get("PRODUCT_CLOSE_FLAG"))%>" == "T"){
   		var text = "<%=CommonLang.msg("MSG102")%>"; //인터페이스 품목입니다.
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
	}	        	   
   	
   	tmpQuery = "<%=CommonUtil.nvl(_dataMap.get("QUOTATION_NO"))%>"+"@@"+"<%=_dataMap.get("QUOTATION_SEQ")%>"+"@@"+"<%=CommonUtil.formatNumber(String.valueOf(_dataMap.get("REVISION")),true,0,0)%>"
		   	+"@@"+"<%=CommonUtil.nvl(_dataMap.get("BUYER"))%>"+"@@"+"<%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%>"
		   	+"@@"+"<%=CommonUtil.nvl(_dataMap.get("CONTRACT_NO"))%>"+"@@"+"<%=CommonUtil.nvl(_dataMap.get("CONTRACT_SEQ"))%>"
		   	+"@@"+"<%=CommonUtil.nvl(_dataMap.get("AGENT"))%>"+"@@"+"<%=CommonUtil.nvl(_dataMap.get("BYCA_COMORG_CODE"))%>"
		   	+"@@"+"<%=CommonUtil.nvl(String.valueOf(_dataMap.get("ITEM_QTY")))%>"+"&&";
    
    $("#st_query").val(tmpQuery);
    
	var text = "<%=CommonLang.msg("MSG104")%>";	//장바구니에 담으시겠습니까?
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveBuyerMpRqQuotaReqList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function cartClose(){
	closePopText2(); self.close();
}
function saveBuyerMpRqQuotaReqList_v2(){
	closePopText1();
	kepAjaxFormCall("/mprq/saveBuyerMpRqQuotaProceState_v2.do","contentForm1","cartCheck"); 	
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if (pMethod == 'cartCheck'){
		var text =  response.msg;
		var but1func_2 = "javascript:cartClose(); return false;";
		opener.tabs["buyerMpRqQuota_tab<%=type%>"]["setPopupReturn"]("cartCheck");
		openLayerPopText2(text,but1text,but1func_2,but1width);
	}	
	
	var buyer = "<%=com_code%>";
	if (pMethod == 'confirmKepPrice'){
		if(response.msg.usrmsg == "N"){ //결재안함
			var text =  response.msg.msg;
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
			return;
		}else{
			if (response.msg.passflag == "N"){ //결재여부 선택
				btn3Layer(buyer,response.msg.usrmsg);
			} else { // 필수
				if (response.msg.buyerpopflag == "Y") {
					window.open(response.msg.callurl,"AppPop");
					doAction('search');
				} else {
					var type = "NS"; // 소싱합의
					openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer+'&nu_tot_price='+$("#st_confirm_price").val()+'&nu_tot_cnt=1', "800,860,no");	
				}
			}
		}
	}else if (pMethod=="nonPassAgrmnt") {
		var text =  response.msg.msg;
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
		return;
	}else if (pMethod=="APPROVAL_PRICE"){
		var text =  response.msg.ATTR1;
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
		return;
	}
}
//ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	var text =  "<%=CommonLang.msg("MSG418")%>"; // 오류발생하였습니다.</br>다시 한 번 시도해 주시기 바랍니다.
	openLayerPopText2(text,but1text,but1func,but1width);
}
function btn3Layer(buyer,docu_no){
	//단가합의 방식에 따라 전자결재 진행 여부를 선택해주세요. 
	var text = "<%=CommonLang.msg("MSG783")%>";
	var content = "<%=CommonLang.msg("MSG782")%>";
	var but1textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but2textC = "<%=CommonLang.get("HTITLE1201")%>"; // 전자결재
	var but3textC = "<%=CommonLang.get("HTITLE131")%>"; // 단가합의
	var but1funcC = "javascript:closePopText3(); return false;";
	var but2funcC = "javascript:exec('1','"+buyer+"','"+docu_no+"'); return false";
	var but3funcC = "javascript:exec('2'); return false";
	var but1widthC = "120px";
	var but2widthC = "120px";
	var but3widthC = "120px";
	openLayerPopText3(text,content, but1textC, but2textC,but3textC, but1funcC, but2funcC,but3funcC, but1widthC, but2widthC, but3widthC);
}

function exec(flag,buyer,docu_no){
	closePopText3();
	
	if(flag == "1"){ //전자결재
		var type = "NS";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+docu_no+'&PARAM1='+buyer+'&nu_tot_price='+$("#st_confirm_price").val()+'&nu_tot_cnt=1', "800,860,no");
	}else{ //단가합의
		kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntNonPass.do","processForm","nonPassAgrmnt");
	}
}
function kepApprovalReturn(flag,docu_no){	
	var buyer = "";
	buyer = document.forms.contentForm1.st_buyer2.value;	
	if("<%=bqt00002%>" === "true"){		
		document.forms.aekyApprForm.ak_docu_no.value = docu_no;
		callAekyAppr();
	}else{
		opener.tabs["buyerMpRqQuota_tab<%=type%>"]["search"]();
		self.close();	
	}
	
	
}
function callAekyAppr(){
	kepAjaxFormCallAsync("/mpso/buyerNewCreateOrder.do","aekyApprForm","APPROVAL_PRICE");
}

function kepAjaxFormCallAsync(pUrl,pForm,pMethod) {    
	loader_obj("Y");
	$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: pUrl,
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: $("#"+pForm+"").serialize(),
		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT
		      async: false,
		      success:function( response ) {
		    	 loader_obj("N");
		    	 if(typeof response.Message != 'undefined'){
		    		 kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
		    		 return;
		    	} 
		    	 kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
			   },
			   error:function( response, textStatus) {				   
				   	loader_obj("N");
				   	if(textStatus == 'timeout'){
				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
				   	} 				   	
				 	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
				if(response.status == '403'){
					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
					location.href = "/login/sub_login.do";
					return;
				} 				  
				kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
			   }
		});  
}
function thisPopClose(){
	closePopText2();
	opener.tabs["buyerMpRqQuota_tab<%=type%>"]["search"]();
	self.close();
}
function downLoadFile(image_key){
	location.href="/common/download_v2.do?DOC_NO="+image_key;
}
</script>
<body onload="kep_onload_view()">
<div class="wrapPopup" >
  <div class="PopupTit" style="flex-shrink:0;">견적상세<span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopByerTab mt10">
  	<button class="TabTit active" data-tab="Search1">선택품목</button>
  	<button class="TabTit" data-tab="Search2">전체품목</button>
  </div>
	<div id="Search1" class="PopByerContent active">
	  <div class="PopupTitSub">기본정보</div>
	  <%if(_dataMap != null && !_dataMap.isEmpty()){  	%>
	  <table class="PopupTableTxt">
	    <colgroup>
	      <col width="150px" />
	      <col width="250px" />
	      <col width="150px" />
	      <col width="250px" />
	  	</colgroup>
	    <tr>
	      <th>견적번호</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("QUOTATION_NO"))%></td>
	      <th>진행상태</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("SOURCING_STATUS_TEXT"))%></td>
	    </tr>
	  	<tr>
	      <th>견적요청일</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("BTOA_DATE"))%></td>
	      <th>회신요청일</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("BTOA_END_DATE"))%></td>
	    </tr>
	  	<tr>
	      <th>요청자</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("BUYER_NAME"))%> <%=CommonUtil.nvl(_dataMap.get("BTOA_USER_NAME"))%></td>
	      <th>요청부서</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("BUYER_DEPT_NAME"))%></td>
	    </tr>
	    <tr>
	      <th>KeP담당자(총괄)</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("MIS_USER_NAME"))%>(<%=CommonUtil.nvl(_dataMap.get("MIS_USER_TEL"))%>)<br/>
	        <%=CommonUtil.nvl(_dataMap.get("MIS_USER_EMAIL"))%>
	      </td>
	      <th>KeP담당자(견적)</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("KEP_USER_NAME"))%>(<%=CommonUtil.nvl(_dataMap.get("KEP_USER_TEL"))%>)<br/>
	        <%=CommonUtil.nvl(_dataMap.get("KEP_USER_EMAIL"))%>
	      </td>
	    </tr>        
	  </table>
	  <div class="PopupTitSub">상품정보</div> 
	  <table class="PopupTableTxt">
	    <colgroup>
	      <col width="150px" />
	      <col width="250px" />
	      <col width="150px" />
	      <col width="250px" />
	    </colgroup>  
	  	<tr>
	      <th>품목코드</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%></td>
	      <th>카테고리</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("BUYER_CATEG_PATH"))%></td>
	    </tr>
	    <tr>
	      <th>품목명</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("DESCRIPTION"))%></td>
	      <th>모델번호</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("MAKER_PART_NO"))%></td>
	    </tr>
	    <tr>
	      <th>규격</th>
	      <td colspan="3"><%=CommonUtil.nvl(_dataMap.get("SPECIFICATION"))%></td>
	    </tr>
	  	<tr>
	      <th>제조사</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("MAKER_NAME"))%></td>
	      <th>원산지</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("ORIGIN_NAME"))%></td>
	    </tr>
	    <tr>
	      <th>수량</th>
	      <td><%=CommonUtil.formatNumber(String.valueOf(_dataMap.get("ITEM_QTY")),true,0,0)%></td>
	      <th>단위</th>
	      <td><%=CommonUtil.nvl(_dataMap.get("UNIT_MEASURE"))%></td>
	    </tr>
	    <tr>
	      <th>MSDS 요청여부</th>
	      <td>
			<%=CommonUtil.nvl(_dataMap.get("BUYER_MSDS_YN")) %>
	      </td>
	      <th>배송일수</th>
	      <td>
	   		<%=CommonUtil.nvl(_dataMap.get("LEAD_TIME"))%>
	      </td>
	    </tr> 
	    <tr>
	      <th>첨부파일</th>
	      <td>
	        <%if(!CommonUtil.nvl(_dataMap.get("IMAGE_KEY_CNT")).equals("0")) {%>
	        <button class="ButDownload_Tiny" onclick="javascript:downLoadFile('<%=CommonUtil.nvl(_dataMap.get("IMAGE_KEY"))%>'); return false;">첨부( <%=CommonUtil.nvl(_dataMap.get("IMAGE_KEY_CNT")) %>)</button>
	        <%} %>
	      </td>
	      <th>견적단가</th>
	      <td>
	        <font style="red"><%=CommonUtil.formatNumber(_dataMap.get("ATOB_UNIT_PRICE"),true,0,3)%>원</font> 
	      </td>
	    </tr>
	    <tr>
	   	  <th>MSDS상태</th>
	      <td colspan="3">
	        <%=CommonUtil.nvl(_dataMap.get("MSDS_TYPE_TEXT"))%>
	      </td>
	    </tr>
	    <tr>
	   	  <th>고객사 비고</th>
	      <td colspan="3">
	        <%=CommonUtil.nvl(_dataMap.get("BTOA_REMARK"))%>
	      </td>
	    </tr>
	    <tr>
		  <th>KeP 비고</th>
	      <td colspan="3">
	        <%=CommonUtil.nvl(_dataMap.get("ATOB_REMARK"))%>
	      </td>
	    </tr>
	    <tr>
	      <th>취소사유</th>
	      <td colspan="3">
	      <% if(!st_page.equals("1")){ %>
   	 	  	<%if(status.equals("RQ10") || status.equals("RQ13") || status.equals("RQ14")){ // 견적요청, 단가합의대상,Nego 합의 대상일때만 견적취소 가능. %>
   	 	     	<input type="text" name="st_cancle_remark"	 id="st_cancle_remark" value="" class="input30" style="width:98%;">
   	 	  	<%} else{ %> 
	        	<%=CommonUtil.nvl(_dataMap.get("CANCEL_REMARK"))%>
        	<%} %>
          <%}else{ %>
          	<%=CommonUtil.nvl(_dataMap.get("CANCEL_REMARK"))%>
          <%} %>
	      </td>
	    </tr>
	    <tr>
	      <th>지연정보</th>
	      <td colspan="3">
	        <%=CommonUtil.nvl(_dataMap.get("DELAY_REASON_TEXT"))%>
	      </td>
	    </tr>
	  </table>
	  	<form name="contentForm1" id="contentForm1" method="post" >
		 	<input type="hidden" name="st_buyer2" id="st_buyer2" value="<%=CommonUtil.nvl(_dataMap.get("BUYER"))%>" >
			<input type="hidden" name="st_quotation_no2" id="st_quotation_no2" value="<%=CommonUtil.nvl(_dataMap.get("QUOTATION_NO"))%>" >
			<input type="hidden" name="st_quotation_seq2" id="st_quotation_seq2" value="<%=_dataMap.get("QUOTATION_SEQ")%>" >
			<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%>" >
			<input type="hidden" name="st_buyer_item_no2" id="st_buyer_item_no2" value="<%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%>" >
			<input type="hidden" name="st_buyer_item_no3" id="st_buyer_item_no3" value="<%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%>" >
			<input type="hidden" name="st_rivision" id="st_rivision" value="<%=CommonUtil.nvl(String.valueOf(_dataMap.get("REVISION")))%>">
			<input type="hidden" name="st_revision2" id="st_revision2" value="<%=CommonUtil.nvl(String.valueOf(_dataMap.get("REVISION")))%>">
			<input type="hidden" name="st_user_id" id="st_user_id" value="<%=user_id%>">
			<input type="hidden" name="st_confirm_user_id2" id="st_confirm_user_id2" value="<%=user_id%>">
			<input type="hidden" name="st_buyer" id="st_buyer" value="<%=CommonUtil.nvl(_dataMap.get("BUYER"))%>">
			<input type="hidden" name="st_agent2" id="st_agent2" value="<%=CommonUtil.nvl(_dataMap.get("AGENT"))%>">
			
			<input type="hidden" name="st_description" id="st_description" value="<%=CommonUtil.nvl(_dataMap.get("DESCRIPTION"))%>">
			<input type="hidden" name="st_specification" id="st_specification" value="<%=CommonUtil.nvl(_dataMap.get("SPECIFICATION"))%>">
			<input type="hidden" name="st_unit_measure" id="st_unit_measure" value="<%=CommonUtil.nvl(_dataMap.get("UNIT_MEASURE"))%>">
			<input type="hidden" name="st_maker_name" id="st_maker_name" value="<%=CommonUtil.nvl(_dataMap.get("MAKER_NAME"))%>">
			<input type="hidden" name="st_lead_time" id="st_lead_time" value="<%=CommonUtil.nvl(_dataMap.get("LEAD_TIME"))%>">
			<input type="hidden" name="st_origin_code" id="st_origin_code" value="<%=CommonUtil.nvl(_dataMap.get("ORIGIN_CODE"))%>">
			
			<input type="hidden" name="st_confirm_price" id="st_confirm_price" value="<%=CommonUtil.nvl(String.valueOf(_dataMap.get("ATOB_UNIT_PRICE")))%>">
			<input type="hidden" name="st_target_price" id="st_target_price" value="<%=CommonUtil.nvl(String.valueOf(_dataMap.get("BUYER_TARGET_PRICE")))%>">
			<input type="hidden" name="st_stoa_list_price" id="st_stoa_list_price" value="<%=CommonUtil.nvl(String.valueOf(_dataMap.get("STOA_LIST_PRICE")))%>">
			<input type="hidden" name="st_item_qty" id="st_item_qty" value="<%=CommonUtil.nvl(String.valueOf(_dataMap.get("ITEM_QTY")))%>">
			
			<input type="hidden" name="st_contract_no" id="st_contract_no" value="<%=CommonUtil.nvl(_dataMap.get("CONTRACT_NO"))%>">
			<input type="hidden" name="st_contract_seq" id="st_contract_seq" value="<%=CommonUtil.nvl(String.valueOf(_dataMap.get("CONTRACT_SEQ")))%>">
			<input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code" value="<%=CommonUtil.nvl(_dataMap.get("BYCA_COMORG_CODE"))%>">
			<input type="hidden" name="st_product_close_flag" id="st_product_close_flag" value="<%=CommonUtil.nvl(_dataMap.get("PRODUCT_CLOSE_FLAG"))%>">
			<input type="hidden" name="st_cms_catlg_id"	id="st_cms_catlg_id"		value="<%=CommonUtil.nvl(_dataMap.get("CMS_CATLG_ID"))%>">
			<!-- 프로세스 및 상태 플래그 -->
			<input type="hidden" name="st_pass_yn" id="st_pass_yn" value="<%=CommonUtil.nvl(_dataMap.get("PASS_YN"))%>">
			<input type="hidden" name="st_confirm_yn" id="st_confirm_yn" value="<%=CommonUtil.nvl(_dataMap.get("CONFIRM_YN"))%>">
			<input type="hidden" name="st_pre_gr_flag" id="st_pre_gr_flag" value="<%=CommonUtil.nvl(_dataMap.get("PRE_GR_FLAG"))%>">
			<input type="hidden" name="st_nego_yn" id="st_nego_yn" value="<%=CommonUtil.nvl(_dataMap.get("NEGO_YN"))%>">
			<input type="hidden" name="st_snd_chk_yn" id="st_snd_chk_yn" value="<%=CommonUtil.nvl(_dataMap.get("SND_CHK"))%>">
			<input type="hidden" name="st_import_flag" id="st_import_flag" value="<%=CommonUtil.nvl(_dataMap.get("IMPORT_FLAG"))%>">
			<input type="hidden" name="st_nocode_yn" id="st_nocode_yn" value="<%=CommonUtil.nvl(_dataMap.get("NOCODE_YN"))%>">
			<input type="hidden" name="st_green_flag" id="st_green_flag" value="<%=CommonUtil.nvl(_dataMap.get("GREEN_FLAG"))%>">
			<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=CommonUtil.nvl(_dataMap.get("GROUP_MNG_FLAG"))%>">
			<input type="hidden" name="st_process_type" id="st_process_type" value="<%=CommonUtil.nvl(_dataMap.get("PROCESS_TYPE"))%>">
			
			<!-- 비고 및 상세 설명 -->
			<input type="hidden" name="st_atob_remark" id="st_atob_remark" value="<%=CommonUtil.nvl(_dataMap.get("ATOB_REMARK"))%>">
			<input type="hidden" name="st_reject_remark2" id="st_reject_remark2" value="">
			<input type="hidden" name="st_cancle_remark" id="st_cancle_remark" value="">
			<input type="hidden" name="st_item_detail_desc" id="st_item_detail_desc" value="<%=CommonUtil.nvl(_dataMap.get("ITEM_DETAIL_DESC"))%>">
			
			<!-- MSDS 관련 정보 -->
			<input type="hidden" name="st_msds_yn" id="st_msds_yn" value="<%=CommonUtil.nvl(_dataMap.get("MSDS_YN"))%>">
			<input type="hidden" name="st_msds_status" id="st_msds_status" value="<%=CommonUtil.nvl(_dataMap.get("MSDS_STATUS"))%>">
			<input type="hidden" name="st_msds_no" id="st_msds_no" value="<%=CommonUtil.nvl(_dataMap.get("MSDS_NO"))%>">
			<input type="hidden" name="st_msds_type_text" id="st_msds_type_text" value="<%=CommonUtil.nvl(_dataMap.get("MSDS_TYPE_TEXT"))%>">
			<input type="hidden" name="st_msds_search_flag" id="st_msds_search_flag" value="<%=CommonUtil.nvl(_dataMap.get("MSDS_SEARCH_FLAG"))%>">
			
			<!-- 날짜 및 시간 -->
			<input type="hidden" name="st_btoa_end_date2" id="st_btoa_end_date2" value="">
			<input type="hidden" name="st_btoa_end_time2" id="st_btoa_end_time2" value="190000">
			<input type="hidden" name="st_sell_close_date" id="st_sell_close_date" value="<%=CommonUtil.nvl(_dataMap.get("SELL_CLOSE_DATE"))%>">
			<input type="hidden" name="st_buy_close_date" id="st_buy_close_date" value="<%=CommonUtil.nvl(_dataMap.get("BUY_CLOSE_DATE"))%>">
			
			<!-- 물류 및 품목 정보 -->
			<input type="hidden" name="st_reg_item_no2" id="st_reg_item_no2" value="<%=CommonUtil.nvl(_dataMap.get("REG_ITEM_NO"))%>">
			<input type="hidden" name="st_item_group" id="st_item_group" value="<%=CommonUtil.nvl(_dataMap.get("ITEM_GROUP"))%>">
			<input type="hidden" name="st_warehouse_code" id="st_warehouse_code" value="<%=CommonUtil.nvl(_dataMap.get("WAREHOUSE_CODE"))%>">
			<input type="hidden" name="st_below_comorg_code" id="st_below_comorg_code" value="<%=CommonUtil.nvl(_dataMap.get("BELOW_COMORG_CODE"))%>">
			<input type="hidden" name="st_item_gubun" id="st_item_gubun" value="<%=CommonUtil.nvl(_dataMap.get("ITEM_GUBUN"))%>">
			<input type="hidden" name="st_min_order_qty" id="st_min_order_qty" value="<%=CommonUtil.nvl(_dataMap.get("MIN_ORDER_QTY"))%>">
			<input type="hidden" name="st_pur_unit_qty" id="st_pur_unit_qty" value="<%=CommonUtil.nvl(_dataMap.get("PUR_UNIT_QTY"))%>">
			<%
			if(CommonUtil.nvl(_dataMap.get("ITEM_GUBUN")).equals("I")) {
			%>
				<input type="text" name="st_doos_item_no_back" id="st_doos_item_no_back"		maxlength="6"	value="<%=_dataMap.get("RE_ITEM_NO")%>">
				<input type="hidden" name="st_doos_item_no_first" id="st_doos_item_no_first"			value="<%=_dataMap.get("REG_ITEM_NO2")%>">
				<input type="hidden" name="st_kep_item_no" id="st_kep_item_no" size="20"  value="<%=_dataMap.get("REG_ITEM_NO")%>">
			<%}else{ %>
				<input type="hidden" name="st_doos_item_no_back" id="st_doos_item_no_back"			value="<%=_dataMap.get("REG_ITEM_NO2")%>">
				<input type="hidden" name="st_doos_item_no_first" id="st_doos_item_no_first"			value="<%=_dataMap.get("REG_ITEM_NO2")%>">
			<%} %>
			
			<!-- 미디어 및 시스템 카탈로그 -->
			<input type="hidden" name="st_image_key" id="st_image_key" value="<%=CommonUtil.nvl(_dataMap.get("IMAGE_KEY"))%>">
			<input type="hidden" name="st_imgfile_name" id="st_imgfile_name" value="<%=CommonUtil.nvl(_dataMap.get("IMGFILE_NAME"))%>">
			<input type="hidden" name="st_imgfile_dir" id="st_imgfile_dir" value="<%=CommonUtil.nvl(_dataMap.get("IMGFILE_DIR"))%>">
			<input type="hidden" name="st_cms_categ_id" id="st_cms_categ_id" value="<%=CommonUtil.nvl(_dataMap.get("CMS_CATEG_ID"))%>">
			
			<!-- 사용자 정보 -->
			<input type="hidden" name="st_load_user_id" id="st_load_user_id" value="<%=CommonUtil.nvl(_dataMap.get("LOAD_USER_ID"))%>">
			<input type="hidden" name="st_kep_user_id" id="st_kep_user_id" value="<%=CommonUtil.nvl(_dataMap.get("KEP_USER_ID"))%>">
			<input type="hidden" name="st_btoa_user_id" id="st_btoa_user_id" value="<%=CommonUtil.nvl(_dataMap.get("BTOA_USER_ID"))%>">
			
			<input type="hidden" name="st_query" id="st_query" value="" />
			
		  <% if(!st_page.equals("1")){ %>
		  <% if (status.equals("RQ13") || status.equals("RQ14") || status.equals("RQ09")){ // 단가합의대상, Nego합의 대상,합의결재반려 일때만 네고요청 / 단가합의 가능.%>
		   <div class="PopupTitSub">Nego요청</div> 
		  	<table class="PopupTableTxt">
		  	   <colgroup>
			      <col width="150px" />
			      <col width="300px" />
			      <col width="150px" />
			      <col width="200px" />
			    </colgroup>  
		  		<th>Nego 요청단가&nbsp;<font color="red">*</font></th>
		  		<td><input class="input30" type="text" id="st_btoa_nego_price" name = "st_btoa_nego_price" value="" >&nbsp;&nbsp;원</td>
		  		<th>Nego 회신요청일&nbsp;<font color="red">*</font></th>
		  		<td>
		  		<div class="datepicker-wrap" style="width:130px">
		  			<div class="date-input" style="width:125px" data-datepicker>
						<input type="text" placeholder="" name="st_btoa_end_date" id="st_btoa_end_date" readonly/>
						<span></span>
					</div>
				</div>
				</td>
				</tr>
				<tr>
				<th>요청사항&nbsp;<font color="red">*</font></th>
				<td colspan=3>
					<textarea id="st_nego_remark" name="st_nego_remark" style=" width:98%; height:50px; border:1px solid #DEDEDE;" placeholder="" onkeyup="fnCheckInputByte(this, '1000');" onchange="fnCheckInputByte(this,'1000');"></textarea>
				</td>
					
				</tr></td>
			</table>
			<%} %>
		<%} %>
		</form>
		<div class="h30"></div>
		<% if(!st_page.equals("1")){ %>
		<div class="PopupListBtnBox_Center">
		<%  	if( _dataMap.get("AGENT") != null && !_dataMap.get("AGENT").equals("") ){ // 협력사 선정 완료 시%>
			<button class="ButQuaternary_large" onclick="javascript:quotation_print(); return false;"><%=CommonLang.get("HTITLE128")%><!--견적서 출력--></button>
		<%	} 	if( status.equals("RQ10") || status.equals("RQ13") || status.equals("RQ14") ){ // 견적요청, 단가합의대상,Nego 합의 대상일때만 견적취소 가능. %> 
			<button class="ButQuaternary_large" onclick="javascript:cancelRqdt(); return false;"><%=CommonLang.get("HTITLE129")%><!--견적 취소--></button>
		<%	}	if( status.equals("RQ13") || status.equals("RQ14") || status.equals("RQ09") ){ // 단가합의대상, Nego합의 대상,합의결재반려 일때만 네고요청 / 단가합의 가능. %> 
			<button class="ButPrimary_large" onclick="javascript:negoSubmit(); return false;"><%=CommonLang.get("HTITLE130")%><!--네고요청--></button>
			<button class="ButPrimary_large" onclick="javascript:confirmKepPrice(); return false;"><%=CommonLang.get("HTITLE131")%><!--단가합의--></button>
		<%	}	 if(status.equals("RQ02") || status.equals("RQ03") || status.equals("RQ04")){ // 장바구니, 합의 완료일 떄만 %>
			<button class="ButPrimary_large" onclick="javascript:cartCheck(); return false;"><%=CommonLang.get("HTITLE11")%><!--장바구니--></button>
		<%	} %>
		</div>
		<%} %>
		<form name="processForm" id="processForm" method="post">	
			<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
			<input type="hidden" name="st_close_remark" id="st_close_remark"      value="">
			<input type="hidden" name="st_recv_flag" id="st_recv_flag"      value="">
			<div id="process"></div>
		</form>
	</div>
    <div id="Search2" class="PopByerContent">
		<form name="contentForm2" id="contentForm2" method="post" >
		 	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=CommonUtil.nvl(_dataMap.get("BUYER"))%>" >
			<input type="hidden" name="st_quotation_no" id="st_quotation_no" value="<%=CommonUtil.nvl(_dataMap.get("QUOTATION_NO"))%>" >
			<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="<%=_dataMap.get("QUOTATION_SEQ")%>" >
			<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%>" >
			<input type="hidden" name="st_revision" id="st_revision" value="<%=CommonUtil.formatNumber(String.valueOf(_dataMap.get("REVISION")),true,0,0)%>" >
			<input type="hidden" name="s_SAVENAME" />
		</form>
    	
		<div class="PopupTitSub">기본정보</div>
		<table class="PopupTableTxt">
			<colgroup>
				<col width="150px" />
				<col width="250px" />
				<col width="150px" />
				<col width="250px" />
			</colgroup>
			<tr>
				<th>견적번호</th>
				<td colspan=3><%=CommonUtil.nvl(_dataMap.get("QUOTATION_NO"))%></td>
			</tr>
			<tr>
				<th>견적요청일</th>
				<td><%=CommonUtil.formatDate(_dataMap.get("BTOA_DATE"),1)%></td>
				<th>회신요청일</th>
				<td><%=CommonUtil.formatDate(_dataMap.get("BTOA_END_DATE"),1)%></td>
			</tr>
			<tr>
			   <th>요청자</th>
			   <td style="vertical-align: top;"><%=CommonUtil.nvl(_dataMap.get("BUYER_NAME"))%></td>
				<th>요청부서</th>
				<td style="vertical-align: top;"><%=CommonUtil.nvl(_dataMap.get("BUYER_DEPT_NAME"))%></td>
			</tr>
			<tr>
				<th>KeP담당자(총괄)</th>
				<td><%=CommonUtil.nvl(_dataMap.get("MIS_USER_NAME"))%>(<%=CommonUtil.nvl(_dataMap.get("MIS_USER_TEL"))%>)<br/><%=CommonUtil.nvl(_dataMap.get("MIS_USER_EMAIL"))%>
				</td>
				<th>KeP담당자(견적)</th>
				<td><%=CommonUtil.nvl(_dataMap.get("KEP_USER_NAME"))%>(<%=CommonUtil.nvl(_dataMap.get("KEP_USER_TEL"))%>)<br/><%=CommonUtil.nvl(_dataMap.get("KEP_USER_EMAIL"))%>
			  </td>
			</tr>        
		</table>
		<div class="PopupTitSub">상품정보</div>
<!-- 	  	<div class="IBSheetBuyer" style="width:800px;"> -->
			<script type="text/javascript">
				createIBSheet("mySheet1", "790px", "500px");
			</script>
<!-- 		</div> -->
	    <!--IBSheetBuyer 끝 --> 
	</div>
</div><!-- warp 끝-->
<%} %>
<script>
	const tabLinks = document.querySelectorAll(".TabTit");
	const tabContents = document.querySelectorAll(".PopByerContent");
	
	tabLinks.forEach(function(link,index){
		link.addEventListener("click", function() {
			// 모든 탭 버튼, 컨텐츠 비활성화
			tabLinks.forEach(function(btn){btn.classList.remove("active")});
			tabContents.forEach(function(content) {content.classList.remove("active")});
			
			// 클릭한 탭 활성화
			link.classList.add("active");
			document.getElementById(link.dataset.tab).classList.add("active");
			currIndex = index; //클릭한 index 를 현재 index 로 저장
		  	if(index == 1){
// 		  		kepSearch(document.contentForm2, mySheet1, "/common/getBuyerMpRqDetailAllPop_v2.do" , this.pagingMode);
		  	}
		});
	});
  </script>
<!-- 애경 단가합의 결재정보 -->
<form name="aekyApprForm" id="aekyApprForm" method="post">	
	<input type="hidden" name="ak_docu_no" id="ak_docu_no" value="" />	
</form>
</body>
</html>