<%--
**********************************************
* 메뉴 : 운영자 이슈관리화면 > 발주관리 팝업
* 화면 : 이슈 관리 발주관리 팝업
* 기능 : 
*****************
--%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>

<!doctype html>
<html>
<head>
<!-- <script src="/resources/js/common.js"></script> -->
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/js/wms_tr_sheet.js"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _datamap = (Map<String,String>) request.getAttribute("rpt_data"); // 조회된결과

@SuppressWarnings (value="unchecked")
Map<String,String> _datamap1 = (Map<String,String>) request.getAttribute("data1"); // 조회된결과

@SuppressWarnings (value="unchecked")
Map<String,String> _datamap2 = (Map<String,String>) request.getAttribute("data2"); // 조회된결과



@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList3 = (List<Map<String,String>>) request.getAttribute("data3"); // 조회된결과

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList4 = (List<Map<String,String>>) request.getAttribute("data4"); // 조회된결과

String st_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");
String st_po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");

String pP08_0000011id ="";
Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(st_buyer);
if(_map!=null){
	pP08_0000011id = _map.get("SLG_ID");
}

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

var open_flag = ["+","+","+","+","+"];

var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

function kep_onload_view(){
	var initsheet = {};

	initsheet.HeaderMode = {Sort : 0,ColMove : 1};
	initsheet.Cfg={	
			MergeSheet:msFixedMerge + msHeaderOnly
	};
	initsheet.Headers = [
 		 {Text:"협력사|품목코드|발주일|매출단가|발주수량|매출금액|제조사|I/F발주번호", Align:"Center"}
 		,{Text:"발주항번|관리번호|납기요청일|매입단가|단위|매입금액|협력사품목코드|I/F발주항번", Align:"Center"}
		,{Text:"품목명|품목명|품목명|규격|규격|규격|규격|비고", Align:"Center"}	
 	];
	
	// mySheet 주문정보 상세
	initsheet.Cols = [
		[
			 { Align:"Left",	Width:200,	Edit:false,	Type:"Text",	Header:"협력사",		SaveName:"AGENT_NAME" }  
			,{ Align:"Center",	Width:200,	Edit:false,	Type:"Text",	Header:"품목코드",		SaveName:"BUYER_ITEM_NO"  } 
			,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",	Header:"발주일",		SaveName:"PO_ADD_DATE",	Format:"Ymd"}
			,{ Align:"Right",	Width:100,	Edit:false,	Type:"Float",	Header:"매출단가",		SaveName:"UNIT_PRICE",	Format:"${priceFormat}"}
			,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",	Header:"발주수량",		SaveName:"PO_QTY"} 
			,{ Align:"Right",	Width:100,	Edit:false,	Type:"Float",	Header:"매출금액",		SaveName:"UNIT_AMT",	Format:"${priceFormat}"} 
			,{ Align:"Center",	Width:150,	Edit:false,	Type:"Text",	Header:"제조사",		SaveName:"MAKER"} 
			,{ Align:"Center",	Width:275,	Edit:false,	Type:"Text",	Header:"I/F발주번호",	SaveName:"LEGACY_PO_NO"}   
			,{ Type:"Text",		Header:"상태",		SaveName:"STATUS",		Hidden:true}
		],
		[
			 { Align:"Center",	Width:200,	Edit:false,	Type:"Text",	Header:"발주항번",		SaveName:"PO_SEQ" }  
			,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",	Header:"관리번호",		SaveName:"REF_NO"} 
			,{ Align:"Center",	Width:120,	Edit:false,	Type:"Text",	Header:"납기요청일",	SaveName:"RD_DATE",	Format:"Ymd"}  
			,{ Align:"Right",	Width:100,	Edit:false,	Type:"Float",	Header:"매입단가",		SaveName:"AGENT_PRICE",	 Format:"${priceFormat}"} 
			,{ Align:"Center",	Width:100,	Edit:false,	Type:"Text",	Header:"단위",		SaveName:"UNIT_MEASURE"}
			,{ Align:"Right",	Width:100,	Edit:false,	Type:"Float",	Header:"매입금액",		SaveName:"AGENT_AMT",	 Format:"${priceFormat}"} 
			,{ Align:"Center",	Width:150,	Edit:false,	Type:"Text",	Header:"협력사 품목코드",	SaveName:"SELLER_ITEM_NO"} 
			,{ Align:"Center",	Width:275,	Edit:false,	Type:"Text",	Header:"I/F발주항번",	SaveName:"LEGACY_PO_SEQ"}
			,{ Hidden:true,		Type:"Text",	Header:"null",	SaveName:"STATUS" }
	 	],
		[ 
			 { Align:"Left",	Width:200,	Edit:false,	Type:"Text",	Header:"품목명",		SaveName:"DESCRIPTION",	ColSpan:3}   
			,{ Align:"Left",	Width:200,	Edit:false,	Type:"Text",	Header:"품목명",		SaveName:"DESCRIPTION"}  
			,{ Align:"Left",	Width:120,	Edit:false,	Type:"Text",	Header:"품목명",		SaveName:"DESCRIPTION"}   
			,{ Align:"Left",	Width:100,	Edit:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION",	ColSpan:4 } 
			,{ Align:"Left",	Width:100,	Edit:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}   
			,{ Align:"Left",	Width:100,	Edit:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}  
			,{ Align:"Left",	Width:150,	Edit:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}  
			,{ Align:"Left",	Width:275,	Edit:false,	Type:"Text",	Header:"비고",		SaveName:"PO_REMARK"} 
			,{ Hidden:true,		Type:"Text",	Header:"null2",	SaveName:"STATUS"} 
	 	]
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode); 

	// mySheet2 업무처리 내역 목록
	var initsheet2 = {};
	initsheet2.Cols = [ 
		 { Align:"Center",	Width:90,	Edit:false,	Hidden:false,	Type:"Text",		Header:"이슈등록일",		SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:120,	Edit:false,	Hidden:false,	Type:"Text",		Header:"이슈상태",			SaveName:"TYPE_NAME"}
		,{ Align:"Center",	Width:75,	Edit:false,	Hidden:false,	Type:"Text",		Header:"처리구분",			SaveName:"STATUS_TEXT"}
		,{ Align:"Left",	Width:280,	Edit:false,	Hidden:false,	Type:"Text",		Header:"상세사유",			SaveName:"AGENT_REMARK"}
		,{ Align:"Left",	Width:300,	Edit:false,	Hidden:false,	Type:"Text",		Header:"운영자 처리 내용",	SaveName:"ATOA_REMARK"}
		,{ Align:"Left",	Width:300,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사 전달사항",	SaveName:"KEP_REMARK"}
		,{ Align:"Center",	Width:120,	Edit:false,	Hidden:false,	Type:"Text",		Header:"작성자",			SaveName:"ADD_USER"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",		Header:"처리자",			SaveName:"CONFIRM_USER"}
		,{ Align:"Center",	Width:90,	Edit:false,	Hidden:false,	Type:"Text",		Header:"이슈처리일",		SaveName:"CONFIRM_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false,	Hidden:false,	Type:"Text",		Header:"처리예정일",		SaveName:"NOTICE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Image",		Header:"협력사첨부",		SaveName:"SELLER_IMAGE_KEY_IMG"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",		Header:"협력사첨부",		SaveName:"SELLER_IMAGE_KEY"}
	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	$("#st_sheet").val('1');
	$("#s_SAVENAME").val('AGENT_NAME|BUYER_ITEM_NO|CREATE_DATE|UNIT_PRICE|PO_QTY|AGENT_PRICE|MAKER|LEGACY_PO_NO|PO_SEQ|REF_NO|RD_DATE|UNIT_PRICE|UNIT_MEASURE|SELLER_ITEM_NO|LEGACY_PO_SEQ|DESCRIPTION|SPECIFICATION|PO_REMARK|STATUS|AGENT');
	kepSearchNoBar(document.searchCondition,  mySheet , "/mpso/getMasterMpSoIssueManageRemarkPop.do" , pagingMode );
	
	$("#st_sheet").val('2');
	$("#s_SAVENAME").val('');
	kepSearchNoBar(document.searchCondition,  mySheet2 , "/mpso/getMasterMpSoIssueManageRemarkPop.do" , pagingMode );
	
	//파일첨부이미지설정
	mySheet2.SetImageList(0, diskOff);
	mySheet2.SetImageList(1, diskOn);
	
	setLinkCol(mySheet2, "AGENT_REMARK");
	setLinkCol(mySheet2, "KEP_REMARK");
	setLinkCol(mySheet2, "ATOA_REMARK");
	setLinkCol(mySheet2, "SELLER_IMAGE_KEY_IMG");
	
	kep_listkepSetCalender2("st_notice_date", <%=_dataList4.size()%>);
	
	kepSetCalender("st_notice_date_2", 1);
	$('input[id="st_notice_date_2"]').datepicker("option", "disabled", true);
	
	for(var i = 0; i < open_flag.length;  i++){
		divShowHide(i);
	}
}

function divShowHide(num){
	var  con  = document.getElementById("div"+num);
	if(open_flag[num] == "+"){
		con.style.display = "block";
		open_flag[num] = "-";
		document.getElementById("show"+num).innerHTML ="▼";
	}else{
		con.style.display = "none";
		open_flag[num] = "+";
		document.getElementById("show"+num).innerHTML ="▶";
	}
	document.getElementById("btn"+num).innerHTML = open_flag[num];
}

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");

	if (msg != "") {
		alert(msg);
	}
	
	
	var totRow = mySheet.RowCount();
	for(var i=3; i <= totRow*3+2;i++){ // 0~2까지는  header
		var status = mySheet.GetCellValue(i, 'STATUS'); 
		if(status == "D"){
			mySheet.SetRowFontColor(i,"#F08080");
		}
	}
	
}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}
	
}

//그리드 셀클릭 이벤트
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());

	if (column == 'AGENT_REMARK') { // 업무처리 내역 목록 > 상세사유
		var return_remark = mySheet2.GetCellValue(Row, "AGENT_REMARK");
	
		//post 팝업 파라미터 설정
		var st_form_name = "remarkForm";
		var st_popup_url = "/common/remarkReturnPop.do";
		var st_popup_param = "st_return_remark@@"+return_remark;
		var st_popup_option = "500,230,no";
		
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}
	
	if (column == 'KEP_REMARK') { // 업무처리 내역 목록 > 협력사 전달사항
		var return_remark = mySheet2.GetCellValue(Row, "KEP_REMARK");
	
		//post 팝업 파라미터 설정
		var st_form_name = "remarkForm";
		var st_popup_url = "/common/remarkReturnPop.do";
		var st_popup_param = "st_return_remark@@"+return_remark;
		var st_popup_option = "500,230,no";
		
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}
	
	if (column == 'ATOA_REMARK') { // 업무처리 내역 목록 > 운영사 처리 내용
		var return_remark = mySheet2.GetCellValue(Row, "ATOA_REMARK");
	
		//post 팝업 파라미터 설정
		var st_form_name = "remarkForm";
		var st_popup_url = "/common/remarkReturnPop.do";
		var st_popup_param = "st_return_remark@@"+return_remark;
		var st_popup_option = "500,230,no";
		
		//post 팝업 호출
		openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
	}
	
	if(column == "SELLER_IMAGE_KEY_IMG"){
		var type="";
		var viewType="R";
		var image_key=mySheet2.GetCellValue(Row, "SELLER_IMAGE_KEY");
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
}

//기능함수
function doAction(str) {
	
	switch (str) {
		case "save":
			var idx = $('input[name=st_selected]:checked').val();
			
			if(idx == "" || idx == null){
				alert("처리할 이슈를 선택해주시기 바랍니다.");
				return;
			}
			
			var status = $("select[id='st_status"+idx+"']").val();

			if(status == null || status == ""){
				alert("승인처리 방식을 선택해주시기 바랍니다.");
				return;
			}
			document.getElementById('st_status').value=status;
			
			var remark_text = $("textarea[id='st_kep_remark"+idx+"']").val();
			document.getElementById('st_remark').value=remark_text;

			var atoa_remark_text = $("textarea[id='st_atoa_remark"+idx+"']").val();
			document.getElementById('st_remark_atoa').value=atoa_remark_text;
			
			var notice_date = $('input[id=st_notice_date'+idx+']').val();
			
			if(TrimCommon(atoa_remark_text) == ""){
				alert("운영사 처리내용은 입력 필수입니다.");
				return;
			}
			
			if(status == 'B'){
				if(TrimCommon(remark_text) == ""){
					alert("반려 처리시 협력사 전달사항은 필수입니다.");
					return;
				}
				
			}else if(status == "RE"){
				if(notice_date == null || notice_date == ""){
					alert("재확인 처리시 재확인일자는 필수입니다.");
					return;
				}
			}
			
			if(notice_date != "" && status != "RE"){
				alert("재확인 처리 외에 재확인일자는 저장되지 않습니다.");
				notice_date = "";
			}
			
			document.getElementById('st_notice_date').value=notice_date.replaceAll('/', "");
			
			if (!fnCheckInputByteStr(remark_text, 170)) {
				alert("협력사 전달사항은 약 영문 200자, 한글 100자까지 입력할 수 있습니다.");
				return;
			}
			
			if (!fnCheckInputByteStr(atoa_remark_text, 170)) {
				alert("운영자 처리내용은 약 영문 200자, 한글 100자까지 입력할 수 있습니다.");
				return;
			}
			
			if(status == 'B' || status == "CM"){
				document.getElementById('st_notice_date').value = "";
			}
			
			
			if($('input[id="st_voc_auto"]').is(":checked")){
				if($('input[id="st_type'+idx+'"]').val()!= "E"){
					alert("VOC 자동등록은 이슈상태가 수주거부인 경우만  사용 가능합니다.");
					return;
				}
				document.getElementById('st_voc_autoYN').value='Y';	
			}else{
				document.getElementById('st_voc_autoYN').value='N';
			}
			
			document.getElementById('st_seq').value=$('input[id=st_seq'+idx+']').val();
			document.getElementById('st_type').value=$('input[id=st_type'+idx+']').val();				
			document.getElementById('st_po_seq').value=$('input[id=st_po_seq'+idx+']').val();	
			document.getElementById('st_ds_seq').value=$('input[id=st_ds_seq'+idx+']').val();
			document.getElementById('st_req_remark').value=$('input[id=st_agent_remark'+idx+']').val();
			document.getElementById('st_remark_atoa').value=$('textarea[id=st_atoa_remark'+idx+']').val();
			document.getElementById('st_process_type').value=$('input[id=st_ch_process_type'+idx+']').val();
			document.getElementById('st_parcel').value=$('input[id=st_parcel_yn'+idx+']').val();
			document.getElementById('st_process_type_code').value= "<%=CommonUtil.nvl(_datamap2.get("PROCESS_TYPE_CODE"))%>";
			document.getElementById('st_warehouse_code').value=  "<%=CommonUtil.nvl(_datamap2.get("WAREHOUSE_CODE"))%>";

			if($('input[id="st_po_multi"]').is(":checked")){
				document.getElementById('st_po_multiYN').value="Y";
			}else{
				document.getElementById('st_po_multiYN').value="N";
			}
			kepAjaxPopFormCall("/mpso/updatMasterMpSoIssueManageRemarkPop.do","masterMpSoIssueManageRemarkPop","save");
			
			break;
		case "saveMemo":
			var memo_text = $("textarea[id='st_memo_text']").val();
			if (isEmpty(memo_text)){
				alert("등록할 내용이 없습니다.");
				return;
			}
			
			if (!fnCheckInputByteStr(memo_text, 400)) {
				alert("한글 기준 최대 200자까지 입력할 수 있습니다.");
				return;
			}
			
			if(document.querySelector("input[name='st_memo_type']:checked").value == '2'){
				document.getElementById('st_memo_issue_type').value = "I";
				var notice_date = $('input[id=st_notice_date_2]').val();
				if(notice_date == null || notice_date == ""){
					alert("신규 이슈 등록 시 재확인일자는 필수입니다.");
					return;
				}
				
				document.getElementById('st_status').value='S';
				document.getElementById('st_notice_date').value=notice_date.replaceAll('/', "");
				document.getElementById('st_remark').value=memo_text;
			}else if(document.querySelector("input[name='st_memo_type']:checked").value == '1'){
				document.getElementById('st_status').value='CM';
				document.getElementById('st_notice_date').value = "";
				document.getElementById('st_remark').value='[운영자 메모] '+memo_text;
				document.getElementById('st_memo_issue_type').value = "M";
				document.getElementById('st_memo_remark').value = memo_text;
			}
			
			if($('input[id="st_po_multi2"]').is(":checked")){
				document.getElementById('st_po_multiYN').value="Y";
			}else{
				document.getElementById('st_po_multiYN').value="N";
			}
			
			kepAjaxPopFormCall("/mpso/insertMasterMpSoIssueManageMemo.do","masterMpSoIssueManageRemarkPop","saveMemo");
			
			break;
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxPopSuccess(pMethod , response){  
	if (pMethod == "save"){
		alert("저장이 완료되었습니다.");
		opener.doAction("search");
		window.close();
	} else if(pMethod=="saveMemo"){
		alert("저장이 완료되었습니다.");
		opener.doAction("search");
		window.close();
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxPopError(pMethod , response) { 
	var msg = response.Message;
	
	if (!isEmpty(msg)){	
		alert(msg);
	}
	return;
}
// 달력 날짜 선택시 콜백함수
function calenderChange(){
	
}

function sheetWin(idx){
	var buyer	= "<%=_datamap2.get("BUYER")%>";
	var inv_no	= $("input[id='inv_no"+idx+"']").val(); 
	var rpt_url = "<%=_datamap.get("RPT_URL")%>";
	var seller	= "<%=_datamap2.get("SELLER")%>";
	var legacy_po_no = "<%=CommonUtil.nvl(_datamap2.get("LEGACY_PO_NO"))%>";
	var pur_id = "<%=_datamap2.get("PURCHASER_ID")%>";
	var legacy_iv_serial = $("input[id='legacy_iv_s"+idx+"']").val();
	var legacy_po_seq = $("input[id='legacy_po_seq"+idx+"']").val();
	var tr_buyer = "<%=_datamap2.get("TR_BUYER")%>";
	var print_gbn = '';	// 0:발주서, 1:납품서
	
	
	var warehouse_code = "<%=_datamap2.get("TR_BUYER")%>";
	var user_id = $("#st_user_id").val();
	
	var legacy_po_seq = $("#st_legacy_po_seq_tot").val();
	var legacy_iv_serial = $("#st_legacy_iv_serial").val();
	
	var process_type="<%=_datamap1.get("PROCESS_TYPE")%>";
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";

	if(process_type == "직납"){
		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
	}else{
		setWmsTrSheet("<%=pP08_0000011id%>","", "", warehouse_code, buyer, inv_no, "", legacy_po_no, legacy_po_seq, legacy_iv_serial, "");
	}
	
	return;
}
function check(idx){
	if($('input[id="st_type'+idx+'"]').val()!= "E"){
		$('input[id="st_voc_auto"]').attr('disabled', true);
		$('input[id="st_voc_auto"]').attr('checked', false);
	}else{
		$('input[id="st_voc_auto"]').attr('disabled', false);
	}
}

function status_change(value1, value2, value3){
	if(value2 == "OK"){ // 확인완료 허용 - 운영이슈, 납품예정일지연, 장납기
		if(value1 != "C" && value1 != "F" && value1 != "H"){
			alert("해당 이슈상태는 [확인완료] 선택 불가");
			$("select[id='st_status"+value3+"']").val("RE");
			return;
		}
	}else if(value2 == "CM" || value2 == "B"){  // 승인반려 허용 - 거래유형 변경요청, 수주거부 요청, 납품예정일 변경요청, 수주접수 초기화요청
		if(value1 != "D" && value1 != "E" && value1 != "G" && value1 != "I"){
			alert("해당 이슈상태는 [승인/반려] 선택 불가");
			$("select[id='st_status"+value3+"']").val("RE");
			return;
		}
	}
}

function dateTypeChange(value1){
	if(value1 == "BA"){
		$("#st_from_date").val("");
		$("#st_to_date").val("");
	}
}

function autoRadioSelect(idx, tot){
	for(var i=0; i<tot; i++){
		$("input[name='st_selected'][value='" + i + "']").prop('checked', false);
	}
	
	$("input[name='st_selected'][value='" + idx + "']").prop('checked', true);
	
	var remark_text = $("textarea[id='st_kep_remark"+idx+"']").val();
	document.getElementById('st_remark').value=remark_text;

	var atoa_remark_text = $("textarea[id='st_atoa_remark"+idx+"']").val();
	document.getElementById('st_remark_atoa').value=atoa_remark_text;
	
	if (!fnCheckInputByteStr(remark_text, 170)) {
		alert("협력사 전달사항은 약 영문 200자, 한글 100자까지 입력할수 있습니다.");
		return;
	}
	
	if (!fnCheckInputByteStr(atoa_remark_text, 170)) {
		alert("운영자 처리내용은 약 영문 200자, 한글 100자까지 입력할수 있습니다.");
		return;
	}
	
	check(idx);
}
function changeType(type){
	if(type == 1){
		$('input[id="st_notice_date_2"]').val("");
		$('input[id="st_notice_date_2"]').datepicker("option", "disabled", true);
		document.getElementById("st_memo_text").placeholder = "1회성 단순 메모 (한글 기준 최대 200자 작성)";
	}else if(type == 2){
		$('input[id="st_notice_date_2"]').datepicker("option", "disabled", false);
		document.getElementById("st_memo_text").placeholder = "재확인이 필요한 이슈 입력 (최대 50자 작성)";
	}
}
//팝업함수호출
function doPop(str, value1) {
	popupSel = str;

	switch (str) {
		case 	"attach": //요청파일 첨부보기
			if(value1 == ""){
				alert("첨부된 파일이 없습니다.");
			}else{
				var viewType="R";
				var st_type = ''; // 수주거부용 타입
				
				openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+value1+"&TYPE="+st_type+"&viewType="+viewType, "500,430,no");
			}
			break;
	}
}
</script> 

<style>
.PopNewBox{background-color:#fff; border-radius:5px; margin-top:10px;}
.PopTableBox{display:block; margin:0px 15px; padding-bottom:10px;  }
.PopTitle_s {display:block; margin-bottom:5px; height:46px;line-height:50px; padding-left:15px;  font-size:16px; font-weight:bold; letter-spacing:-1.5px; color:#000; border-bottom:0px solid #eaeaea  }
.PopTitle_s b{ font-size:16px;line-height:46px; margin-right:5px;}
.PopTitle_s span{float:right; margin-right:15px; margin-top:10px; width:30px; height:30px; line-height:30px; font-size:30px; letter-spacing:-1px;color:#000; text-align:center; border-radius:50px; background-color:#fff}
</style>
<body onLoad="kep_onload_view()">
	<form name="searchCondition" id="searchCondition" method="post">
		<input type="hidden" id="st_sheet" name="st_sheet" value="1">
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="">
		<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>"> 
		<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=st_po_no%>"> 
		<input type="hidden" id="st_po_no"  name="st_po_seq" value="<%=st_po_seq%>">
	</form>
	 <form name="masterMpSoIssueManageRemarkPop" id="masterMpSoIssueManageRemarkPop" method="post" >
		<input type="hidden" id="st_user_id" name="st_user_id"	value="<%=_sessionInfo.getUserId()%>">
		<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>"> 
		<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=st_po_no%>">
		<input type="hidden" id="st_po_seq"  name="st_po_seq" value="<%=st_po_seq%>">
		<input type="hidden" id="st_ds_seq"  name="st_ds_seq" value="">
		<input type="hidden" id="st_type" name="st_type" value="">
 		<input type="hidden" id="st_seq" name="st_seq"	value="">
		<input type="hidden" id="st_remark"  name="st_remark" value="">
		<input type="hidden" id="st_req_remark"  name="st_req_remark" value="">
		<input type="hidden" id="st_remark_atoa"  name="st_remark_atoa" value="">
		<input type="hidden" id="st_status" name="st_status" value="">
		<input type="hidden" id="st_notice_date" name="st_notice_date" value="">
		<input type="hidden" id="st_po_multiYN" name="st_po_multiYN" value="N">
		<input type="hidden" id="st_voc_autoYN" name="st_voc_autoYN" value="N">
		<input type="hidden" id="st_process_type" name="st_process_type" value="">
		<input type="hidden" id="st_parcel" name="st_parcel" value="">
		<input type="hidden" id="st_memo_issue_type" name="st_memo_issue_type" value="">
		<input type="hidden" id="st_memo_remark"  name="st_memo_remark" value="">
		<input type="hidden" id="st_process_type_code" name="st_process_type_code" value="">
		<input type="hidden" id="st_warehouse_code" name="st_warehouse_code" value="">
	 </form>
	<div id="popWrapper" >
		<div id="popHeader">
		   	<h1 class="title">발주 관리</h1>
		    <p class="popClose"><a href="javascript:self.close()">
 			    <img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
		    </a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="background-color:#f5f5f5"  >
        	<!--품목 정보-->
            <div  class="PopNewBox" >
                <a href="javascript:divShowHide('0');"><div class="PopTitle_s"><b id="show0"></b> 품목 정보 <span id="btn0"></span></div></a>
                 <div id="div0" class="PopTableBox"> 
                    <table  class="cont_t_list06" summary="품목 정보" style="width:100%;">
                        <caption>품목 정보</caption>
                        <colgroup>
                            <col width="18%" />
                            <col width="30%" />
                            <col width="18%" />
                            <col width="*" />
                        </colgroup>
                        <tbody>
                        <tr> 
                            <th scope="row" class="center"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(_datamap1.get("BUYER_ITEM_NO"))%></td>
                            <th scope="row" class="center"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(_datamap1.get("AGENT_NAME"))%></td>
                        </tr>
                        <tr>
                            <th scope="row" class="center"><%=CommonLang.get("HTITLE13") %><!--품목명--></th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(_datamap1.get("DESCRIPTION"))%></td>
                            <th scope="row" class="center"><%=CommonLang.get("HTITLE15") %><!--제조사--></th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(_datamap1.get("MAKER"))%></td>
                        </tr>
                        <tr>
                            <th scope="row" class="center"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(_datamap1.get("SPECIFICATION"))%></td>
                            <th scope="row" class="center"><%=CommonLang.get("HTITLE164") %><!-- 매입단가 --></th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(CommonUtil.formatNumber(_datamap1.get("AGENT_PRICE"),true,0,3))%></td>
                        </tr>
                        <tr>
                            <th scope="row" class="center"><%=CommonLang.get("HTITLE708") %><!-- 거래유형 --></th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(_datamap1.get("PROCESS_TYPE"))%></td>
                            <th scope="row" class="center">매출단가</th>
                            <td scope="row" class="center"><%=CommonUtil.nvl(CommonUtil.formatNumber(_datamap1.get("UNIT_PRICE"),true,0,3))%></td>
                        </tr>
                        </tbody>
                   </table> 
                </div>
        	</div>
            <!--주문 정보-->
            <div  class="PopNewBox" >
                <a href="javascript:divShowHide('1');"><div class="PopTitle_s"><b id="show1"></b> 주문 정보 <span id="btn1"></span></div></a>
                <div id="div1" class="PopTableBox"> 
                    <table  class="cont_t_list06 mb15" summary="주문 정보" style="width:100%;">
                        <caption>주문 정보</caption>
                        <colgroup>
                            <col width="18%" />
                            <col width="30%" />
                            <col width="18%" />
                            <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr> 
                                <th scope="row" class="center"><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></th>
                                <td scope="row" class="center"><%=CommonUtil.nvl(_datamap2.get("BUYER_NAME"))%></td>
                                <th scope="row" class="center"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
                                <td scope="row" class="center"><%=CommonUtil.formatDate(CommonUtil.nvl(_datamap2.get("PO_CREATE_DATE")))%></td>
                            </tr>
                            <tr>
                                <th scope="row" class="center"><%=CommonLang.get("HTITLE188")%>/<%=CommonLang.get("HTITLE187")%><!-- 발주부서/발주자 --></th>
                                <td scope="row" class="center"><%=CommonUtil.nvl(_datamap2.get("PO_DEPT_NAME"))%> / <%=CommonUtil.nvl(_datamap2.get("PO_USER_NAME"))%></td>
                                <th scope="row" class="center"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
                                <td scope="row" class="center"><%=CommonUtil.nvl(_datamap2.get("PO_NO"))%></td>
                            </tr>
                            <tr>
                                <th scope="row" class="center"><%=CommonLang.get("HTITLE135")%>/<%=CommonLang.get("HTITLE187")%><!-- 요청부서/발주자 --></th>
                                <td scope="row" class="center"><%=CommonUtil.nvl(_datamap2.get("REQ_DEPT_NAME"))%> / <%=CommonUtil.nvl(_datamap2.get("REQ_USER_NAME"))%></td>
                                <th scope="row" class="center">매입합계</th>
                                <td scope="row" class="center"><%=CommonUtil.nvl(CommonUtil.formatNumber(_datamap2.get("AGENT_AMT"),true,0,3))%></td>
                            </tr>
                            <tr>
                                <th scope="row" class="center">거래유형</th>
                                <td scope="row" class="center"><%=CommonUtil.nvl(_datamap2.get("PROCESS_TYPE"))%></td>
                                <th scope="row" class="center">매출합계</th>
                                <td scope="row" class="center"><%=CommonUtil.nvl(CommonUtil.formatNumber(_datamap2.get("PO_AMT"),true,0,3))%></td>
                            </tr>
                            <tr>
                                <th scope="row" class="center"><%=CommonLang.get("HTITLE485")%><!-- 도착지 --></th>
                                <td colspan="3"><%=CommonUtil.nvl(_datamap2.get("DELY_TO_LOCATION"))%></td>
                            </tr>
                            <tr>
                                <th scope="row" class="center"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
                                <td colspan="3"><%=CommonUtil.nvl(_datamap2.get("REMARK"))%></td>
                            </tr>
                          </tbody>
                     </table> 
                    <div style="border-top:2px solid #3c639c; left:0;">
                        <script type="text/javascript">
                            createIBSheet("mySheet", "100%", "210px");
                        </script>
                    </div>
                     <b><font color="#990000">금액합계&nbsp;<%=CommonUtil.nvl(CommonUtil.formatNumber(_datamap2.get("PO_AMT"),true,0,3))%>&nbsp;원</font>&nbsp; <b>※삭제건은 붉은색 글씨로 표기됩니다.</b>
                </div>
            </div>
        	<!--납품 정보-->
            <div  class="PopNewBox" >
                <a href="javascript:divShowHide('2');"><div class="PopTitle_s"><b id="show2"></b>납품 정보 <span id="btn2" ></span></div></a>
                 <div id="div2" class="PopTableBox"> 
                    <table  class="cont_t_list06"  style="width:100%">
                        <caption>납품 정보</caption>
                        <colgroup>
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                            <col width="14%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col" class="center">거래유형</th>
                                <th scope="col" class="center">납품예정수량/단위</th>
                                <th scope="col" class="center">표준납기일</th>
                                <th scope="col" class="center">요구납기일</th>
                                <th scope="col" class="center">납품예정일</th>
                                <th scope="col" class="center">협력사 택배정보</th>
                                <th scope="col" class="center">TR 택배정보</th>
                            </tr>
                            <tr>
                              <th scope="col" class="center">거래명세서 번호</th>
                              <th colspan="6" scope="col" class="center">납품 진행 현황</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% 
                        if(_dataList3 == null || _dataList3.size() < 1){
                        %>
                            <td class="TextTop" align="center" colspan="7" style="text-align:center;">조회된 데이터가 없습니다</td>        
                        </tbody>
                        <%
                        }else{
                            String unit_measure = _dataList3.get(0).get("UNIT_MEASURE");
                            String item_qty = String.valueOf(_dataList3.get(0).get("ITEM_QTY"));
                            for (int j=0; j<_dataList3.size(); j++) {
                                Map<String,String> _tmp3 = _dataList3.get(j);
    
                                String day1 = "";
                                String day2 = "";
                                String day3 = "";
                                String day5 = "";
                                
                                if(_tmp3.get("DATE1") != null){
                                    day1 = _tmp3.get("DATE1") + _tmp3.get("TIME1");
                                }
                                
                                if(_tmp3.get("DATE2") != null){
                                    day2 = _tmp3.get("DATE2") + _tmp3.get("TIME2");
                                }
                                
                                if(_tmp3.get("DATE3") != null){
                                    day3 = _tmp3.get("DATE3") + _tmp3.get("TIME3");
                                }
                                
                                if(_tmp3.get("DATE5") != null){
                                    day5 = _tmp3.get("DATE5") + _tmp3.get("TIME5");
                                }
                        %>
                            <tr>
                                <td class="center"><%=_tmp3.get("PROCESS_TYPE")%></td>
                                <td class="center"><%=CommonUtil.formatNumber(_tmp3.get("CD_QTY"),true,0,3) %> / <%=_tmp3.get("UNIT_MEASURE")%></td>
                                <td class="center"><%=CommonUtil.formatDate(CommonUtil.nvl(_tmp3.get("ST_DATE"), ""))%></td>
                                <td class="center"><%=CommonUtil.formatDate(CommonUtil.nvl(_tmp3.get("RD_DATE"), ""))%></td>
                                <td class="center"><%=CommonUtil.formatDate(CommonUtil.nvl(_tmp3.get("DS_DATE"), ""))%></td>
                                <td class="center">
                                    <%=CommonUtil.nvl(_tmp3.get("AGENT_PARCEL_COM_NAME"))%>
                                    <br><a href="<%=CommonUtil.nvl3(_tmp3.get("AGENT_PARCEL_REAL_URL"), "")%>" target='_blank'><%=CommonUtil.nvl(_tmp3.get("AGENT_PARCEL_INV_NO"))%></a>
                                </td>
                                <td class="center">
                                    <%=CommonUtil.nvl(_tmp3.get("TR_PARCEL_COM_NAME"))%>
                                    <br><a href="<%=CommonUtil.nvl3(_tmp3.get("TR_PARCEL_REAL_URL"), "")%>" target='_blank'><%=CommonUtil.nvl(_tmp3.get("TR_PARCEL_INV_NO"))%></a>
                                </td>
                            </tr>
                            <tr>
                                <td rowspan="2" class="center"><a href="javascript:sheetWin('<%=j%>');" style="text-decoration:underline; color:blue"><%=CommonUtil.nvl(_tmp3.get("INV_NO"), "")%></a>
                                    <input type="hidden" id="inv_no<%=j%>" value="<%=CommonUtil.nvl(_tmp3.get("INV_NO"), "")%>">
                                    <input type="hidden" id="legacy_po_seq<%=j%>"value="<%=CommonUtil.nvl(_tmp3.get("LEGACY_PO_SEQ"))%>">
                                    <input type="hidden" id="legacy_iv_s<%=j%>"value="<%=CommonUtil.nvl(_tmp3.get("LEGACY_IV_SERIAL"))%>">
                                </td>
                                
                                <td class="center" <%if(_tmp3.get("STATUS_TEXT").equals("발주")){%>style="background-color:#ffd700;background-clip:content-box;padding:2px"
                                    <%}else{ %>style="background-color:#eaeaea;background-clip:content-box;padding:3px"<%} %>>발주</td>
                                <td class="center" <%if(_tmp3.get("STATUS_TEXT").equals("수주접수")){%>style="background-color:#ffd700;background-clip:content-box;padding:2px"
                                    <%}else{ %>style="background-color:#eaeaea;background-clip:content-box;padding:3px"<%} %>>수주접수</td>
                                <td class="center" <%if(_tmp3.get("STATUS_TEXT").equals("배송중")){%>style="background-color:#ffd700;background-clip:content-box;padding:2px"
                                    <%}else{ %>style="background-color:#eaeaea;background-clip:content-box;padding:3px"<%} %>>배송중</td>
                                <td class="center" <%if(_tmp3.get("STATUS_TEXT").equals("협력사배송완료")){%>style="background-color:#ffd700;background-clip:content-box;padding:2px"
                                    <%}else{ %>style="background-color:#eaeaea;background-clip:content-box;padding:3px"<%} %>>협력사 배송완료</td>
                                <td class="center" <%if(_tmp3.get("STATUS_TEXT").equals("TR입고완료")){%>style="background-color:#ffd700;background-clip:content-box;padding:2px"
                                    <%}else{ %>style="background-color:#eaeaea;background-clip:content-box;padding:3px"<%} %>>TR 입고완료</td>
                                <td class="center" <%if(_tmp3.get("STATUS_TEXT").equals("TR배송완료")){%>style="background-color:#ffd700;background-clip:content-box;padding:2px"
                                    <%}else{ %>style="background-color:#eaeaea;background-clip:content-box;padding:3px"<%} %>>TR 배송완료</td>
                            </tr>
                            <tr>
                                <td class="center">
                                	<%=CommonUtil.formatDate(day1, 3)%>
                                </td>
                                <td class="center">
                                    <% if(_tmp3.get("DATE2") != null){%>
                                    <%=CommonUtil.formatDate(day2, 3)%>
                                    <%} %>
                                </td>
                                <td class="center">
                                    <% if(_tmp3.get("DATE3") != null){%>
                                    <%=CommonUtil.formatDate(day3, 3)%>
                                    <%} %>
                                </td>
                                <td class="center">
                                    <% if(_tmp3.get("DATE4") != null){%>
                                    <%=_tmp3.get("DATE4")%>
                                    <br> <%-- // 협력사 자차 일때는 DATE4_1(실적등록일)이 안보여야 함 --%>
                                    	<% if(_tmp3.get("PARCEL_YN").equals("Y")){%>
                                    		<% if(_tmp3.get("DATE4_1") != null ) {%>
                                    (<%=_tmp3.get("DATE4_1")%>)
                                    <%		}
                                    	}
                                    }%>
                                </td>
                                <td class="center">
                                    <% if(_tmp3.get("DATE5_HUB") != null){%>
                                    	<%=_tmp3.get("DATE5_HUB")%>&nbsp;(간선:<%=_tmp3.get("HUB_NAME")%>)
                                    <%} %>
                                    <% if(_tmp3.get("DATE5") != null){%>
                                    	<% if(_tmp3.get("DATE5_HUB") != null){%>
                                    		<br>
                                    	<%} %>
                                    	<%=CommonUtil.formatDate(day5, 1)%>&nbsp;(도착:<%=_tmp3.get("WAREHOUSE_INIT_NAME")%>)
                                    <%} %>
                                </td>
                                <td class="center">
                                    <% if(_tmp3.get("DATE6") != null) {%>
                                    <%=_tmp3.get("DATE6")%>
                                    <br> <%-- // 센터 자차 일때는 DATE6_1(실적등록일)이 안보여야 함 --%>
                                    	<% if(_tmp3.get("TR_PARCEL_INV_NO") != null){%>
                                    (<%=_tmp3.get("DATE6_1")%>)
                                    <%		} 
                                    }%>
                                </td>
                            </tr>
                         </tbody>
                        <%
                            }
                        %>
                        <span> 총 발주 수량 : <%=item_qty%> <%=unit_measure%></span>
                        <%
                        }
                        %>
                     </table>
                     <font color="RED">※ 괄호 날짜 : 택배사 배송완료일</font>
                </div>
        	</div>
            <!--이슈 사항-->
            <div  class="PopNewBox" >
                <a href="javascript:divShowHide('3');"><div class="PopTitle_s"><b id="show3"></b>이슈 사항 <span id="btn3"></span></div></a>
                <div id="div3" class="PopTableBox"> 
                    <table  class="cont_t_list06"  style="width:100%">
                        <caption>이슈 사항</caption>
                        <colgroup>
                            <col width="4%" />
                            <col width="7%" />
                            <col width="11%" />
                            <col width="23%" />
                            <col width="5%" />
                            <col width="*" />
                            <col width="12%" />
                            <col width="*" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col" class="center" rowspan="2">선택</th>
                                <th scope="col" class="center" rowspan="2">처리예정일</th>
                                <th scope="col" class="center" rowspan="2">이슈상태</th>
                                <th scope="col" class="center" rowspan="2">상세사유</th>
                                <th scope="col" class="center" rowspan="2">협력사 첨부</th>
                                <th scope="col" class="center" rowspan="2"><font color="red">*</font>운영자 처리내용<br>(협력사 미노출)</th>
                                <th scope="col" class="center">처리구분</th>
                                <th scope="col" class="center" rowspan="2">협력사 전달사항<br>(협력사 노출)</th>
                            </tr>
                            <tr>
                                <th scope="col" class="center">재확인일자</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                        if(_dataList4 == null || _dataList4.size() < 1){
                        %>
                            <td class="TextTop" align="center" colspan="8" style="text-align:center;">조회된 데이터가 없습니다</td>        
                        </tbody>
                        <%
                        }else{
                            for (int j=0; j<_dataList4.size(); j++) {
                                Map<String,String> _tmp4 = _dataList4.get(j);
                        %> 
                            <input type="hidden" id="st_seq<%=j%>" value="<%=_tmp4.get("SEQ")%>">
                            <input type="hidden" id="st_type<%=j%>" value="<%=_tmp4.get("TYPE")%>">
                            <input type="hidden" id="st_po_seq<%=j%>" value="<%=_tmp4.get("PO_SEQ")%>">
                            <input type="hidden" id="st_ds_seq<%=j%>" value="<%=_tmp4.get("DS_SEQ")%>">
                            <input type="hidden" id="st_agent_remark<%=j%>" value="<%=_tmp4.get("AGENT_REMARK")%>">
                            <input type="hidden" id="st_ch_process_type<%=j%>" value="<%=_tmp4.get("CH_PROCESS_TYPE")%>">
                            <input type="hidden" id="st_parcel_yn<%=j%>" value="<%=_tmp4.get("PARCEL_YN")%>">
                            
                            <tr>
                                <td rowspan="2" class="center"><input type="radio" name="st_selected" value="<%=j%>" onClick="check(<%=j%>)"></td>
                                <td rowspan="2" class="center"><%=_tmp4.get("NOTICE_DATE")%></td>
                                <td rowspan="2" class="center"><%=_tmp4.get("TYPE_NAME")%></td>
                            
                            <!-- 거래유형 변경요청 -->
                            <%if("D".equals(_tmp4.get("TYPE"))){ %>
                                <td rowspan="2" class="left">
                                    -기본 거래유형 : <%=CommonUtil.nvl(_tmp4.get("RE_PROCESS_TYPE_TEXT"))%><br>
                                    -변경요청 거래유형 : <%=CommonUtil.nvl(_tmp4.get("CH_PROCESS_TYPE_TEXT"))%> ( <%=CommonUtil.nvl(_tmp4.get("PARCEL_YN_TEXT"))%> )<br>
                                    -사유 : <%=CommonUtil.nvl(_tmp4.get("AGENT_REMARK"))%>
                                </td>
                            <!-- 수주거부 요청 -->
                            <%}else if("E".equals(_tmp4.get("TYPE"))){ %>
                                <td rowspan="2" class="left">
                                    거부사유 | 상세사유 (납품가능단가,규격,대체품목 등) :<br>
                                    <%=CommonUtil.nvl(_tmp4.get("AGENT_REMARK"))%>
                                </td>
                            <!-- 납품예정일 변경요청 -->
                            <%}else if("G".equals(_tmp4.get("TYPE"))){ %>	                        
                                <td rowspan="2" class="left">
                                    -기존 납품예정일 : <%=CommonUtil.nvl(_tmp4.get("RE_DS_DATE"))%><br>
                                    -변경 납품예정일 : <%=CommonUtil.nvl(_tmp4.get("CH_DS_DATE"))%><br>
                                    -사유 : <%=CommonUtil.nvl(_tmp4.get("AGENT_REMARK"))%>
                                </td>
                            <!-- 수주접수 초기화요청 -->
                            <%}else if("I".equals(_tmp4.get("TYPE"))){ %>	                        
                                <td rowspan="2" class="left">
                                    -사유 : <%=CommonUtil.nvl(_tmp4.get("AGENT_REMARK"))%>
                                </td>
                            <%}else{%>
                                <td rowspan="2" class="left"><%=CommonUtil.nvl(_tmp4.get("AGENT_REMARK"))%></td>
                            <%}%>						
                                <td rowspan="2" class="center" style="padding:2px 3px">
                            <%if(_tmp4.get("SELLER_IMAGE_KEY") != null && !_tmp4.get("SELLER_IMAGE_KEY").equals("")) { %>
                                    <a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(_tmp4.get("SELLER_IMAGE_KEY"))%>')">
                                        <img name="st_image_key_img" src="/resources/images/disk_on.gif" border="0">
                                    </a>
                            <%}else {%>
                                     <img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0">
                            <%}%>
                                </td>
                            
                                <td rowspan="2" class="center" style="padding:2px 3px">
                                    <textarea id="st_atoa_remark<%=j%>" rows="4" style="width:95%" maxlength="100" placeholder="100자 이내 입력 가능" onKeyUp="autoRadioSelect(<%=j%>, <%=_dataList4.size()%>)"></textarea>
                                </td>
                                
                                <td class="center">
                                    <select id="st_status<%=j%>" name="st_status" style="width:95px;" onChange="javascript:status_change('<%=CommonUtil.nvl(_tmp4.get("TYPE"))%>',this.value,'<%=j%>')">
                                        <option value="RE">재확인</option>
                                        <option value="OK">확인완료</option>
                                        <option value="CM">승인</option>
                                        <option value="B">반려</option>
                                    </select>
                                </td>
                                
                                <td rowspan="2" class="center" style="padding:2px 3px">
                                    <textarea id="st_kep_remark<%=j%>" rows="4" style="width:95%" maxlength="100" placeholder="100자 이내 입력 가능" onKeyUp="autoRadioSelect(<%=j%>, <%=_dataList4.size()%>)"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td class="center">
                                    <input type="text" class="input_type_text" name="st_notice_date" id="st_notice_date<%=j%>" readOnly style="width:65px; text-align:center;" value="">
                                </td>
                            </tr>
                         </tbody>
                        <% 	}	
                        }%>
                     </table>
                    <div class="btnArea mt05">
                        <span class="fl"><font color="red"><b>※ 수주미접수/수주거부요청/거래유형변경/수주접수 초기화요청 건에 대한 처리는 발주단위로 일괄 반영 됩니다.</b></font></span>
                        <span class="fr">
                            <label><input style="vertical-align: middle;" type="checkbox" id="st_voc_auto" name="st_voc_auto" disabled> VOC 자동등록(수주거부전용)</label>
                            <label>
                            	<input style="vertical-align: middle;" type="checkbox" id="st_po_multi" name="st_po_multi"> 동일발주 일괄 적용
                            </label>
                            <span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
                        </span> 
                    </div>
                </div>
            </div>            
        	<!--등록-->
            <div  class="PopNewBox">
                <a href="javascript:divShowHide('4');"><div class="PopTitle_s"><b id="show4"></b> 등록<span id="btn4"></span></div></a>
                <div id="div4" class="PopTableBox"> 
                    <label><input type="radio" name="st_memo_type" value="1" checked onClick="changeType('1')" style="vertical-align:middle"> 운영자 메모</label>&nbsp;&nbsp;
                    <label><input type="radio" name="st_memo_type" value="2" onClick="changeType('2')" style="vertical-align:middle"> 신규 이슈</label>&nbsp;&nbsp;&nbsp;&nbsp;
                    재확인일자&nbsp; <input type="text" class="input_type_text" name="st_notice_date_2" id="st_notice_date_2" readOnly style="width:65px;  height:21px; text-align:center; margin-bottom:2px" value="">
                    <br>
                    <textarea id = "st_memo_text" rows="4" style="width:100%" placeholder="1회성 단순 메모 (한글 기준 최대 200자 작성)"></textarea>
                    <div class="btnArea mt05"  style="margin-bottom:0px" >
                    	<label>
                    	<input style="vertical-align: middle;" type="checkbox" id="st_po_multi2" name="st_po_multi2" <%if(st_po_seq.equals("000000")){ %>checked disabled<%} %>> 동일발주 일괄 적용
                    	</label>
                    	<span class="btn_02"><a href="javascript:doAction('saveMemo');">등록</a></span>
                    </div>
                </div>
			</div> 
            <!--업무처리 내역 목록-->           
            <div  class="PopNewBox" >
                <div class="PopTitle_s" style="background-color:#d3e4f2";><b>▼</b>업무처리 내역 목록</div>
                <div class="PopTableBox">
                    <div style="border-top:2px solid #3c639c; left:0;">
                        <script type="text/javascript">
                            createIBSheet("mySheet2", "100%", "380px");
                        </script>
                    </div>
                    <!--버튼추가예정-->
                    <!--div class="btnArea mt05"  style="margin-bottom:0px" >
                    	<span class="btn_06"><a href="javascript:doAction('saveMemo');">협력사 DM발송</a></span>
                    </div-->
                </div>
            </div>
            
          
            
			<br>
        </div>
	</div>
</body>
</html>
