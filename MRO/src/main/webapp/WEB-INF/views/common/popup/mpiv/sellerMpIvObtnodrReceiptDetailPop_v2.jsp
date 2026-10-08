<%--
**********************************************
* 메뉴 : 
* 화면 : 수주접수 상세
* 기능 : 수주상세내역을 확인하고, 납품예정일을 입력하여 수주접수처리 한다.
* 프로그램 ID : SU0502003
* 담당자 : 최찬규
* 착수일 : 2025-09-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>

<%
	@SuppressWarnings (value="unchecked")

	//SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String user_id      = _sessionInfo.getUserId();
	String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String p_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String p_po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	
	
	Map<String,String> detailInfo = (Map<String,String>) request.getAttribute("detailInfo"); // 조회결과 - 상세정보
	
	Map<String,String> orderRecvHeader = (Map<String,String>) request.getAttribute("orderRecvHeader"); // 조회결과 - 발주서인쇄 정보 조회
	
	Map<String,String> specialLogicInfo = (Map<String,String>) request.getAttribute("specialLogicInfo"); // 조회결과 - 특수로직 정보 조회
	
	// 발주서인쇄, 납부지시서 이벤트 시 사용
	String buyer_tr = "";
	String seller = "";
	String ref_if_no = "";
	String add_user_id = "";
	String agent_code = "";
	
	if(orderRecvHeader != null){
		
		buyer_tr = CommonUtil.nvl(orderRecvHeader.get("BUYER2"));
		seller = CommonUtil.nvl(orderRecvHeader.get("SELLER"));
		ref_if_no = CommonUtil.nvl(orderRecvHeader.get("REF_IF_NO"));
		add_user_id = CommonUtil.nvl(orderRecvHeader.get("ADD_USER_ID"));
		agent_code = CommonUtil.nvl(orderRecvHeader.get("AGENT"));
		
		//buyer_tr = "KRDAEW0016";
	}
	
	//SLOGIC-START
	/*
	장바구니 필드추가 제어 
	-TYPE1: 윈체  수량길이 필드 추가
	*/
	String p060000080 =  CommonUtil.getSpecialCheckReturn(p_buyer,"P06-0000080","COL01_DATA");
	//SLOGIC-END
	
	// MSDS 수주접수 통제 예외 협력사 확인
	boolean p060000079 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000079");
	
	// 직납(택배) 불가 고객사 리스트 > 거래유형 변경요청 비활성화
	boolean p060000119 = CommonUtil.getSpecialCheckReturn(p_buyer,"P06-0000119");
	
	// 보관조건, 보관온도 입력 필수 대상 고객사
	String p070000033 = "";
	Map<String, String> p070000033_map = CommonUtil.getSpecialCheckReturnMap(p_buyer,"P07-0000033");
	if (p070000033_map != null){
    	p070000033= CommonUtil.nvl(p070000033_map.get("COL01_DATA"),""); // 유형별 값
    }
%>
<script type="text/javascript">

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

var reject_yn = "N"; // 수주거부 입력

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

//팝업호출
var gridIndex = 0;

var g_query = "";
// var productGbn = KepSheetComboData("M132","SEL");
// var comboInfo = {ComboCode: productGbn.ComboCode, ComboText:productGbn.ComboText};
//최초 화면 함수 
function kep_onload_view(){
	
	//RD_DATE=고객수령희망일, ST_DATE=표준납품일
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:35,	Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"BUYER",				Header:"고객사코드",			Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"BUYER_NAME",			Header:"고객사",			Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",				Type:"Text", FontColor:"#3a72c7", Cursor:"Pointer",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"품목명",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"MAKER_PART_NO",		Header:"모델번호",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"단가",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Format:"${priceFormat}"}
			,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"수량",				Type:"Float",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"단위",				Type:"Text",		Width:50,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"ITEM_AMT",			Header:"합계",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}
			,{ Align:"Center",	SaveName:"RD_DATE",				Header:"고객수령희망일",		Type:"Date",		Width:110,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"DS_GUBUN",			Header:"납품구분",				Type:"CheckBox",	Width:110,	Edit:true,	EditLen:100,	Hidden:false, ItemText:"전량|분할",  ItemCode:"전량|분할", MaxCheck:1, RadioIcon:1,BackColor:"${optColor}"}
			,{ Align:"Center",	SaveName:"DS_DATE",				Header:"납품예정일",			Type:"Date",		Width:110,	Edit:true,	EditLen:10,		Hidden:false,BackColor:"${optColor}",Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"DELAY_REASON_COMBO",	Header:"지연사유",				Type:"Combo",		Width:180,	Edit:false,	EditLen:100,	Hidden:false, ComboText:"선택|재고부족|수입지연|제작지연|발주확인지연|기타",	ComboCode:"|재고부족|수입지연|제작지연|발주확인지연|기타",BackColor:"${optColor}"}
			,{ Align:"Left",	SaveName:"DELAY_REASON_TEXT",	Header:"지연사유",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}
			,{ Align:"Left",	SaveName:"DELAY_REASON",		Header:"지연사유",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"ITEM_MAKE_TYPE_TEXT",	Header:"품목구분",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_YN",		Header:"파일첨부",				Type:"Button",		Width:82,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type02'}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"파일첨부",				Type:"Text",		Width:82,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"품목비고",				Type:"Text",		Width:230,	Edit:false,	EditLen:100,	Hidden:false}
		<%if(p060000080.equals("TYPE1")) {%>
			,{ Align:"Left",	SaveName:"SIZE_LEN_QTY",		Header:"길이/수량",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SIZE_YN",				Header:"SIZE_YN",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SIZE_LEN",			Header:"SIZE_LEN",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SIZE_QTY",			Header:"SIZE_QTY",			Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:true}
		<%}%>
			,{ Align:"Center",	SaveName:"ST_DATE",				Header:"표준납품일",			Type:"Date",		Width:82,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_NO",				Header:"PO_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"PO_SEQ",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"SELLER",				Header:"SELLER",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DS_FLAG",				Header:"DS_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"H_DS_FLAG",			Header:"H_DS_FLAG",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"COD_CHECK",			Header:"MSDS대상",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"MSDS_CHECK",			Header:"MSDS매핑필요",			Type:"Text",		Width:110,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"REQ_CHECK",			Header:"REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TEMP_REQ_CHECK",		Header:"TEMP_REQ_CHECK",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			
			,{ Align:"Center",	SaveName:"TEMP_CHECK",			Header:"TEMP_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"HARMFUL_CHECK",		Header:"유해화학물질",			Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SG118_CHECK",			Header:"SG118_CHECK",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUYER_NEED_DELI",		Header:"BUYER_NEED_DELI",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"QUERY_TEXT",			Header:"QUERY_TEXT",		Type:"Text",		Width:80,	Edit:false,	Hidden:true}
			,{ Align:"Center",	SaveName:"REJECT_REASON",		Header:"REJECT_REASON",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REJECT_REASON_TEXT",	Header:"REJECT_REASON_TEXT",Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"REJECT_IMAGE_KEY",	Header:"REJECT_IMAGE_KEY",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PH_PO_DATE",			Header:"PH_PO_DATE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"WAREHOUSE_CODE",		Header:"WAREHOUSE_CODE",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TR_WAREHOUSE_YN",		Header:"TR_WAREHOUSE_YN",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"BUY_CLOSE_DATE_CHK",	Header:"BUY_CLOSE_DATE_CHK",Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"TEMP_COND",			Header:"TEMP_COND",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
// 	mySheet.SetColProperty("ITEM_MAKE_TYPE", comboInfo);
	
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	mySheet.SetTheme("DB", "DeepBlue");
	
// 	var datePickerInstance = new IBSheetDatePicker(mySheet, {
// 	    columns: ['DS_DATE'],  // 달력을 적용할 컬럼들
// 	    dateFormat: '-',                         // 날짜 구분자 (YYYY.MM.DD)
// // 	    displayFormat:'YYYY-MM-DD',
// 	    saveFormat: 'YYYYMMDD',               // 저장 형식
// 	    yearFirst: true,                         // 년도를 월 앞에 표시
// 	    autoClose: false,                        // 날짜 선택 후 자동 닫기 비활성화
// 	    autoInit: true,                          // 자동 초기화
// 	    onChange: function(data) {
// 	        console.log('[사용자 콜백] 날짜 변경:', data);
// 	    }
// 	});
	
	kepSearch(document.contentForm, mySheet, "/mpiv/getSellerMpIvObtnodrReceiptDetailPop_v2.do" , pagingMode);
}
</script>
<script type="text/javascript">

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	$("#itemCnt").html("("+mySheet.RowCount()+")");
	$("#buyerItemCnt").text(mySheet.RowCount());
	
	for(var i = 1; i<=mySheet.RowCount();i++){
		<%if(p060000080.equals("TYPE1")) {%>
		if(mySheet.GetCellValue(i,"SIZE_YN") == "Y"){
			mySheet.SetCellValue(i,"SIZE_LEN_QTY",mySheet.GetCellValue(i,"SIZE_LEN")+"/"+mySheet.GetCellValue(i,"SIZE_QTY"));
		}
		<%}%>
		mySheet.SetCellValue(i,"DS_GUBUN","전량:1|분할:0");
		
		// 납품예정일 기본 설정(고객수령희망일 or 오늘일자) 및 납품지연사유 활성화 로직(표준납품일 기준)
		var today_date = kepGetNowTimeStr('YYYYMMDD','');
		var ds_date = mySheet.GetCellValue(i, "DS_DATE");
		var rd_date = mySheet.GetCellValue(i, "RD_DATE");
		var st_date = mySheet.GetCellValue(i, "ST_DATE"); 
		var delay_reason = mySheet.GetCellValue(i, "DELAY_REASON");
		
		// 납품예정일 기본 설정
		if(rd_date > today_date){
			mySheet.SetCellValue(i,"DS_DATE", rd_date);
		}else{
			mySheet.SetCellValue(i,"DS_DATE", today_date);
		}
		
		// 변경된 납품예정일로 지연사유 판단
		if(st_date < mySheet.GetCellValue(i, "DS_DATE") && delay_reason == ""){
			mySheet.SetCellEditable(i, "DELAY_REASON_COMBO", true);
			mySheet.SelectCell(i, "DELAY_REASON_COMBO");
		}else if(st_date >= mySheet.GetCellValue(i, "DS_DATE")){
			mySheet.SetCellEditable(i, "DELAY_REASON_COMBO", false);
			mySheet.SetCellValue(i, "DELAY_REASON_COMBO", "");
			mySheet.SetCellValue(i, "DELAY_REASON_TEXT", "");
		}

		mySheet.SetCellValue(i,"SELECTED",true);
	}
	
	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var st_buyer = mySheet.GetCellValue(Row, "BUYER");
	var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
	var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
	var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
	var st_byit_comorg_code = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
	var st_image_key = mySheet.GetCellValue(Row,"IMAGE_KEY");
	var st_image_key_yn = mySheet.GetCellValue(Row,"IMAGE_KEY_YN");	
	
	if(column == "BUYER_ITEM_NO"){
		var src = "/common/catalogDetailPop.do?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq+"&popupCheck=Y";
		openLayerPop2(src,"650px","600px");
// 		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_byit_comorg_code+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"650,600,no");
	}
	if(column == "IMAGE_KEY_YN"){
		if(st_image_key_yn == "")
			return;
		location.href="/common/download_v2.do?DOC_NO="+st_image_key;
	}
	if(column == "DS_GUBUN"){
		if(mySheet.GetCellValue(Row, "DS_GUBUN") == "전량:1|분할:0"){ //전량선택
			mySheet.SetCellValue(Row,"QUERY_TEXT",""); //분할납품 입력했던거 초기화
			mySheet.SetCellValue(Row,"DS_FLAG","N");
			mySheet.SetCellValue(Row,"BUYER_NEED_DELI","N");
		}
		if(mySheet.GetCellValue(Row, "DS_GUBUN") == "전량:0|분할:1"){ //분할선택
			<%
			// 특수로직 - 분할납품 제한 고객사 체크
			if(specialLogicInfo.get("EXP_DS_FLAG").equals("Y")) {
			%>
// 				alert("분할납품이 불가능한 고객사입니다.");
				var text = "분할납품이 불가능한 고객사입니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				mySheet.SetCellValue(Row,"DS_GUBUN","전량:1|분할:0");
				return;
			<%}else{%>
				if(mySheet.GetCellValue(Row,"DS_FLAG") == "Y"){
					var po_no = mySheet.GetCellValue(Row, "PO_NO");
					var buyer = mySheet.GetCellValue(Row, "BUYER");
					var po_seq = mySheet.GetCellValue(Row, "PO_SEQ");
					var po_qty = mySheet.GetCellValue(Row, "ITEM_QTY");
					var seller = mySheet.GetCellValue(Row, "SELLER");
					var ds_flag = mySheet.GetCellValue(Row, "DS_FLAG");
					var st_date = mySheet.GetCellValue(Row, "ST_DATE");
					var ds_delay_reason = mySheet.GetCellValue(Row, "DELAY_REASON");
					var check_flag = mySheet.GetCellValue(Row, "BUYER_NEED_DELI");
					var po_create_date = mySheet.GetCellValue(Row, "PH_PO_DATE");
					var description = mySheet.GetCellValue(Row,"DESCRIPTION");
					var query_text = mySheet.GetCellValue(Row,"QUERY_TEXT");
					
					var src = "/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do?po_no="+po_no+"&buyer="+buyer +"&po_seq="+po_seq +"&po_qty="+po_qty+"&seller="+seller+"&ds_flag="+ds_flag+"&st_date="+st_date+"&ds_delay_reason="+encodeURIComponent(ds_delay_reason)+"&query_text="+encodeURIComponent(query_text)+"&check_flag="+check_flag+"&po_create_date="+po_create_date+"&description="+encodeURIComponent(description)+"&popupCheck=Y";
					openLayerPop2(src,"640px","760px");
				}else{
// 					if(!confirm("분할하여 납품하시겠습니까?")) return;
					var text = "분할하여 납품하시겠습니까?";
					var but1textC = "확인";
					var but2textC = "취소";
					var but1funcC = "javascript:showSellerMpIvDivsnDeliveryPlanEntryPop(); return false;";
					var but2funcC = "javascript:closePopText1(); return false;";
					var but1widthC = "120px";
					var but2widthC = "120px";
					openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
					
				}
// 				openSearchPopup("/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do", "?po_no="+po_no+"&buyer="+buyer +"&po_seq="+po_seq +"&po_qty="+po_qty+"&seller="+seller+"&ds_flag="+ds_flag+"&st_date="+st_date+"&ds_delay_reason="+ds_delay_reason+"&query_text="+query_text+"&check_flag="+check_flag+"&po_create_date="+po_create_date+"&description="+description, "640,760,no");
				
			<%}%>
		}
	}
	
	return;
}
function showSellerMpIvDivsnDeliveryPlanEntryPop(){
	closePopText1();
	var po_no = mySheet.GetCellValue(grbRow, "PO_NO");
	var buyer = mySheet.GetCellValue(grbRow, "BUYER");
	var po_seq = mySheet.GetCellValue(grbRow, "PO_SEQ");
	var po_qty = mySheet.GetCellValue(grbRow, "ITEM_QTY");
	var seller = mySheet.GetCellValue(grbRow, "SELLER");
	var ds_flag = mySheet.GetCellValue(grbRow, "DS_FLAG");
	var st_date = mySheet.GetCellValue(grbRow, "ST_DATE");
	var ds_delay_reason = mySheet.GetCellValue(grbRow, "DELAY_REASON");
	var check_flag = mySheet.GetCellValue(grbRow, "BUYER_NEED_DELI");
	var po_create_date = mySheet.GetCellValue(grbRow, "PH_PO_DATE");
	var description = mySheet.GetCellValue(grbRow,"DESCRIPTION");
	var query_text = mySheet.GetCellValue(grbRow,"QUERY_TEXT");
	
	var src = "/mpiv/showSellerMpIvDivsnDeliveryPlanEntryPop.do?po_no="+po_no+"&buyer="+buyer +"&po_seq="+po_seq +"&po_qty="+po_qty+"&seller="+seller+"&ds_flag="+ds_flag+"&st_date="+st_date+"&ds_delay_reason="+encodeURIComponent(ds_delay_reason)+"&query_text="+encodeURIComponent(query_text)+"&check_flag="+check_flag+"&po_create_date="+po_create_date+"&description="+encodeURIComponent(description)+"&popupCheck=Y";
	openLayerPop2(src,"640px","760px");
}
function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(Col);	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == "DELAY_REASON_COMBO"){
		if(mySheet.GetCellValue(Row, "DELAY_REASON_COMBO") == "기타"){ //기타면 사유 입력 가능하도록
			mySheet.SetCellValue(Row,"DELAY_REASON","");
			mySheet.SetCellEditable(Row, "DELAY_REASON_TEXT", true);
			mySheet.SelectCell(Row,"DELAY_REASON_TEXT");
		}else{ //기타 아니면 선택한 사유를 reason에 저장
			mySheet.SetCellValue(Row,"DELAY_REASON",mySheet.GetCellValue(Row, "DELAY_REASON_COMBO"));
			mySheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
			mySheet.SetCellEditable(Row, "DELAY_REASON_TEXT", false);
		}
	}
	if(column == "DELAY_REASON_TEXT"){ //기타인 경우 입력한 text를 reason에 저장
		if(mySheet.GetCellValue(Row, "DELAY_REASON_COMBO") == "기타"){
			mySheet.SetCellValue(Row,"DELAY_REASON",mySheet.GetCellValue(Row, "DELAY_REASON_TEXT"));			
		}
	}
	if(column == "DS_GUBUN"){
		//이전꺼랑 비교해서 checkbox 해제 안되도록
		if(OldValue == "전량:1|분할:0" && Value == "전량:0|분할:0"){  
			mySheet.SetCellValue(Row,"DS_GUBUN","전량:1|분할:0");
		}
		if(OldValue == "전량:0|분할:1" && Value == "전량:0|분할:0"){
			mySheet.SetCellValue(Row,"DS_GUBUN","전량:0|분할:1");
		}
		
		if(OldValue == "전량:1|분할:0" && Value == "전량:0|분할:1"){  
			mySheet.SetCellValue(Row,"DS_DATE","");
			mySheet.SetCellValue(Row,"DELAY_REASON","");
			mySheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
			mySheet.SetCellValue(Row,"DELAY_REASON_COMBO","");
			mySheet.SetCellEditable(Row,"DS_DATE",false);
			mySheet.SetCellEditable(Row,"DELAY_REASON_TEXT",false);
			mySheet.SetCellEditable(Row,"DELAY_REASON_COMBO",false);
		}
		if(OldValue == "전량:0|분할:1" && Value == "전량:1|분할:0"){  //전량에서 분할 바뀌면 데이터 싹 초기화
			mySheet.SetCellValue(Row,"DS_DATE","");
			mySheet.SetCellValue(Row,"DELAY_REASON","");
			mySheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
			mySheet.SetCellValue(Row,"DELAY_REASON_COMBO","");
			mySheet.SetCellEditable(Row,"DS_DATE",true);
			mySheet.SetCellValue(Row,"QUERY_TEXT",""); //분할납품 입력했던거 초기화
			mySheet.SetCellValue(Row,"DS_FLAG","N");
			mySheet.SetCellValue(Row,"BUYER_NEED_DELI","N");
		}
	}
	if(column == "DS_DATE"){
		if(RaiseFlag == 1) return;
		var st_date = mySheet.GetCellValue(Row, "ST_DATE");
		var ds_date = mySheet.GetCellValue(Row, "DS_DATE");
		var delay_reason = mySheet.GetCellValue(Row, "DELAY_REASON");
		var cur_date = kepGetNowTimeStr("YYYYMMDD","");
		if(ds_date < cur_date && ds_date !=""){
// 			alert("납품예정일을 금일 이후 날짜로 입력하여 주십시요.");
			var text = "납품예정일을 금일 이후 날짜로 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			mySheet.SetCellValue(Row,"DS_DATE","");
            mySheet.SelectCell(Row,"DS_DATE");
            return;
		}
		// 지연사유 판정: 표준납품일(ST_DATE)보다 늦을 경우에만 지연사유 필수
		if(st_date < ds_date && delay_reason == ""){
// 			alert("납품지연사유를 입력하여 주십시요.");
			var text = "납품지연사유를 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			mySheet.SetCellEditable(Row, "DELAY_REASON_COMBO", true);
			mySheet.SelectCell(Row,"DELAY_REASON_COMBO");
			return;
		}else if(st_date >= ds_date){
			mySheet.SetCellEditable(Row, "DELAY_REASON_COMBO", false);
			mySheet.SetCellValue(Row, "DELAY_REASON_COMBO", "");
			mySheet.SetCellValue(Row,"DELAY_REASON_TEXT","");
		}
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
// 		alert(msg.msg);
		var text = msg.msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	if ( code > 0 ) {
		//저장 성공시 처리
// 		doAction("search");
	}
}
function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "agent": // 고객사
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "825,700,no");
			break;
		case "processTypeChange": // 거래유형 변경요청
			popupSel = "processTypeChange";
			var src = "/mpiv/showSellerMpIvProcessTypeChangePop.do?value1="+value1+'&value2='+value2+'&value3='+value3;
			openLayerPop2(src,"680px","450px");
// 			openSearchPopup("/mpiv/showSellerMpIvProcessTypeChangePop.do",'?value1='+value1+'&value2='+value2+'&value3='+value3,"680,450,no");
			break;
	}
}

function setPopupReturn(){
	if(popupSel == "processTypeChange"){
		parent.doAction("search");
		parent.closePop();
	}
}
//분할납품 팝업 리턴
function setDSQuery(query,ds_date,buyer_need_check,delay_reason){
	mySheet.SetCellValue(mySheet.GetSelectRow(),"DS_FLAG","Y");
	mySheet.SetCellValue(mySheet.GetSelectRow(),"QUERY_TEXT",query);
	mySheet.SetCellValue(mySheet.GetSelectRow(),"BUYER_NEED_DELI",buyer_need_check);
	mySheet.SetCellEditable(mySheet.GetSelectRow(), "DS_DATE", false);
	if(delay_reason != ""){
		if(delay_reason != "재고부족" && delay_reason != "수입지연" && delay_reason != "제작지연" && delay_reason != "발주확인지연"){ //기타인 경우
			mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON_COMBO","기타");
			mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON_TEXT",delay_reason);
			mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON",delay_reason);
			mySheet.SetCellEditable(mySheet.GetSelectRow(), "DELAY_REASON_TEXT", false);
			mySheet.SetCellEditable(mySheet.GetSelectRow(), "DELAY_REASON_COMBO", false);
		}else{
			mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON_COMBO",delay_reason);
			mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON_TEXT","");
			mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON",delay_reason);
			mySheet.SetCellEditable(mySheet.GetSelectRow(), "DELAY_REASON_TEXT", false);
			mySheet.SetCellEditable(mySheet.GetSelectRow(), "DELAY_REASON_COMBO", false);
		}
	}else{
		mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON_COMBO","");
		mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON_TEXT","");
		mySheet.SetCellValue(mySheet.GetSelectRow(),"DELAY_REASON","");
		mySheet.SetCellEditable(mySheet.GetSelectRow(), "DELAY_REASON_TEXT", false);
		mySheet.SetCellEditable(mySheet.GetSelectRow(), "DELAY_REASON_COMBO", false);
	}
	mySheet.SetCellValue(mySheet.GetSelectRow(),"DS_DATE",ds_date);
}

//수주거부 팝업 호출
function setRejectReason(x){
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("품목을 선택해주세요.");
		var text = "품목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
// 	alert("수주거부는 해당 발주번호 내 모든 품목에 적용되며, 납품이 불가합니다.");
	var text = "수주거부는 해당 발주번호 내 모든 품목에 적용되며, 납품이 불가합니다.";
	var but1funcTmp = "javascript:showSellerMpIvDeliveryRejectReasonPop("+x+"); return false;";
	openLayerPopText2(text,but1text,but1funcTmp,but1width);
}
function showSellerMpIvDeliveryRejectReasonPop(x){
	closePopText2();
	$("#x").val(x);
	var buyer = "<%=p_buyer%>";
	var po_no = "<%=p_po_no%>";
	
	var src = "/mpiv/showSellerMpIvDeliveryRejectReasonPop.do?buyer="+buyer+"&po_no="+po_no;
	openLayerPop(src,"800px","850px");
// 	openSearchPopup("/mpiv/showSellerMpIvDeliveryRejectReasonPop.do", "?buyer="+buyer+"&po_no="+po_no, "800,850,no");
}

// 수주거부 팝업 리턴
function setRejectReasonText(value1, value2, value3){ // 거부사유, 거부 상세사유, 첨부파일
	for(var i = 1; i<=mySheet.RowCount();i++){
		mySheet.SetCellValue(i,"REJECT_REASON",value1);
		mySheet.SetCellValue(i,"REJECT_REASON_TEXT",value2);
		mySheet.SetCellValue(i,"REJECT_IMAGE_KEY",value3);
		
		//나머지값들은 초기화
		mySheet.SetCellValue(i,"DS_FLAG","N");
		mySheet.SetCellValue(i,"DS_DATE","");
		mySheet.SetCellValue(i,"DELAY_REASON","");
		mySheet.SetCellValue(i,"DELAY_REASON_COMBO","");
		mySheet.SetCellValue(i,"DELAY_REASON_TEXT","");
		mySheet.SetCellEditable(i,"DELAY_REASON_TEXT",false);
		mySheet.SetCellValue(i,"BUYER_NEED_DELI","N");
	}
	
	reject_yn = "Y";
	
	setDeliverySchedule();
}


// 확인
function setDeliverySchedule(){
	
// 	if(reject_yn != "Y"){
// 		var checkRows = mySheet.FindCheckedRow("SELECTED");
// 		var arrRow = checkRows.split("|");
		
// 		// 선택된 항목 유무 체크
// 		if (checkRows.length == 0) {
// 			alert("품목을 선택해주세요.");
// 			return;
// 		}
// 	}
	
	
    var query = "";
    var check_cnt = 0;
    var buyer        = "";
    var po_no        = "";
    var po_seq       = "";
    var po_qty       = "";
    var seller       = "";
    var cd_date      = "";
    var cd_qty       = "";
    var ds_flag      = "";
    var user_id      = "<%=user_id%>";
    var delay_reason = "";
    var max_cd_date = "";
    var rd_date     = "";
    var query_text  = "";
	var ds_date		= "";
	var st_date		= "";
	var reject_reason = "";
	var buyer_need_deli = "";
	var po_create_date = "";
	var reject_image_key = "";
	
	var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
	var msds_check	= ""; //BYIT.MSDS_NO의 null여부
	var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
	var temp_req_check   = ""; //KEP_CMC_REQ 의 상태 체크(TEMP_COND 입력여부)
	var harmful_check   = ""; //유해화학물질 여부 체크
	var temp_check   = ""; //보관조건 체크
	var sg118_check = ""; // 시약류 체크
	var buyer_item_no_arr = []; //등록해야할 품목코드
	var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
	var tempMng_no_reg_buyer_item_no_arr = []; //카탈로그에 보관조건 미등록 품목코드
	var p070000033 = ""; // 보관조건이 필수인 고객사 목록
	var temp_cond = ""; // 보관조건 유형(실온/정온/냉장/냉동/극냉동)
	
	var process_type = "";
	var warehouse_code = "";
	var tr_warehouse_yn = "";
	
	document.forms["processForm"].st_monitor.value = "AGENT_S_0";
	
	// 매입단가유효일 진행 통제
	var buy_close_date_chk = ""; // 매입단가유효일 체크
	
	// 물류센터 다른지 체크
	var  warehouse_code_tmp = mySheet.GetCellValue(1, "WAREHOUSE_CODE"); // 첫행 물류센터 
	
	for(var i = 1 ; i<=mySheet.RowCount(); i++){
    	cod_check = mySheet.GetCellValue(i,"COD_CHECK");
    	msds_check = mySheet.GetCellValue(i,"MSDS_CHECK");
    	req_check = mySheet.GetCellValue(i,"REQ_CHECK");
    	temp_req_check = mySheet.GetCellValue(i,"TEMP_REQ_CHECK");
    	
    	temp_check = mySheet.GetCellValue(i,"TEMP_CHECK");
    	p070000033 = $("#p070000033").val();
    	sg118_check = mySheet.GetCellValue(i,"SG118_CHECK");
    	
    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 수주접수 통제
     		buyer_item_no_arr.push(mySheet.GetCellValue(i,"BUYER_ITEM_NO"));
     	}
    	
    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
    		msds_no_reg_buyer_item_no_arr.push(mySheet.GetCellValue(i,"BUYER_ITEM_NO"));
     	}
    	
    	if(p070000033 != "" && sg118_check == "Y" && temp_check=="Y"){ // 보관조건 입력 필수 고객사 & 카탈로그에 보관조건 미등록 품목 통제 - 2025.06.27 HSJ
    		if(temp_req_check == "Y"){ //협력사제출,제출(오분류) 상태이고 보관조건을 입력한 데이터가 있는 경우 -> 진행하지말고 기다리라고 안내
    			var text = "해당 품목 ("+mySheet.GetCellValue(i,"BUYER_ITEM_NO")+") 은 보관온도 조건 입력 요청이 접수되어 현재 KeP 담당자 검토 단계에서 처리 중입니다.</br>동일 품목에 대한 추가 요청은 접수되지 않으니 검토 완료까지 잠시만 기다려 주세요.";
    			openLayerPopText2(text,but1text,but1func,but1width);
    			return
    		}else{
	    		tempMng_no_reg_buyer_item_no_arr.push(mySheet.GetCellValue(i,"BUYER_ITEM_NO"));
    		}
     	}
     	
        buyer       = mySheet.GetCellValue(i,"BUYER");
        po_no       = mySheet.GetCellValue(i,"PO_NO");
        po_seq      = mySheet.GetCellValue(i,"PO_SEQ");
        po_qty      = mySheet.GetCellValue(i,"ITEM_QTY");
        cd_date     = mySheet.GetCellValue(i,"DS_DATE");
        cd_qty      = mySheet.GetCellValue(i,"ITEM_QTY");
        ds_flag     = mySheet.GetCellValue(i,"DS_FLAG");
        seller      = mySheet.GetCellValue(i,"SELLER");
        delay_reason= mySheet.GetCellValue(i,"DELAY_REASON");
        rd_date     = mySheet.GetCellValue(i,"RD_DATE");
//     	rd_date     = rd_date.replace(/[/]/gi,"");
        query_text  = mySheet.GetCellValue(i,"QUERY_TEXT");    // 분할납품일 경우 이 변수에 값이 존재함
		ds_date		= mySheet.GetCellValue(i,"DS_DATE");
		st_date     = mySheet.GetCellValue(i,"ST_DATE");
//     	st_date     = st_date.replace(/[/]/gi,"");
		reject_reason = mySheet.GetCellValue(i,"REJECT_REASON");
		buyer_need_deli = mySheet.GetCellValue(i,"BUYER_NEED_DELI");
		po_create_date = mySheet.GetCellValue(i, "PH_PO_DATE");
		reject_image_key = mySheet.GetCellValue(i, "REJECT_IMAGE_KEY");
		process_type = mySheet.GetCellValue(i, "PROCESS_TYPE");
    	warehouse_code = mySheet.GetCellValue(i, "WAREHOUSE_CODE");
    	tr_warehouse_yn = mySheet.GetCellValue(i, "TR_WAREHOUSE_YN");
    	temp_cond = mySheet.GetCellValue(i, "TEMP_COND");
    	harmful_check = mySheet.GetCellValue(i, "HARMFUL_CHECK");
    	
    	// 보관조건에 따른 거래유형 검증(아모레퍼시픽(TYPE1))
    	if(p070000033 == "TYPE1"){ // 아모레퍼시픽(TYPE1)
    		if(sg118_check == "Y"){ // 시약류
    			if(harmful_check != "Y"){ // 유해화학물질 여부
    				if(temp_cond != ""){
    					if(temp_cond == "A" || temp_cond == "B"){ // 실온(A), 정온(B)
                			if(process_type != "2"){
//                 				alert("실온/정온은 TR로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
                				var text = "실온/정온은 TR로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
                				openLayerPopText2(text,but1text,but1func,but1width);
                   				return;
                			}
                		}else{
                			if(process_type != "0"){
//                 				alert("냉장/냉동은 직납으로만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
                				var text = "냉장/냉동은 직납으로만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
                				openLayerPopText2(text,but1text,but1func,but1width);
                   				return;
                			}
                		}	
    				}
        		}	
    		}
    	}
    	
    	if(harmful_check == "Y"){ // 유해화학물질 여부
    		if(process_type != "0"){ // 무조건 직납
// 				alert("유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
				var text = "유해화학물질이 포함되어 직납만 가능합니다.(거래유형오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
   				return;
			}
    	}
    	
   		if(process_type == '2') {
   			if(tr_warehouse_yn == 'N' || warehouse_code == "" || warehouse_code == null || warehouse_code == 'null') {
//    				alert("해당 건 진행할 수 없습니다.(거래유형정보오류)\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
   				var text = "해당 건 진행할 수 없습니다.(거래유형정보오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
   				return;
   			}
   			// 같은 발주(TR)인데 물류센터가 다른지 체크
   			if(warehouse_code_tmp != warehouse_code) {
   				var text = "해당 건 진행할 수 없습니다.(물류센터정보오류)</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
   				return;   				
   			}
   		}
		
		if(reject_reason != ""){
			reject_yn = "Y";
			reject_reason = mySheet.GetCellValue(i, "REJECT_REASON") + " | " + mySheet.GetCellValue(i, "REJECT_REASON_TEXT");
		}
		
		if(reject_yn == "N"){
			// 매입단가유효일 진행 통제
	        buy_close_date_chk = mySheet.GetCellValue(i, "BUY_CLOSE_DATE_CHK");
			if(buy_close_date_chk == "Y"){
// 				alert("해당 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
				var text = "해당 건 진행할 수 없습니다.</br>화면에 표기된 KeP담당자에게 문의하시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(mySheet.GetCellValue(i,"DS_GUBUN") == "전량:0|분할:0"){
// 	        	alert("납품구분을 선택해주시기 바랍니다.");
	        	var text = "납품구분을 선택해주시기 바랍니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
	        	mySheet.SelectCell(i,"DS_GUBUN");
	        	return;
	        }
	        if(cd_date == ""){
// 	            alert("납품예정일을 입력해 주십시요");
	            var text = "납품예정일을 입력해주세요.";
				openLayerPopText2(text,but1text,but1func,but1width);
	            mySheet.SelectCell(i,"DS_DATE");
	            return;
	        }
	        var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	        if(cd_date < cur_date){
// 	            alert("납품예정일을 금일 이후 날짜로 입력해 주십시요");
	            var text = "납품예정일을 금일 이후 날짜로 입력해주세요.";
				openLayerPopText2(text,but1text,but1func,but1width);
	            mySheet.SelectCell(i,"DS_DATE");
	            return;
	        }
	        
	        if(buyer_need_deli == "N"){
	        	if((st_date < ds_date) && isEmpty(delay_reason)) {
// 	    			alert("납품지연사유를 입력하여 주십시요.");
	    			var text = "납품지연사유를 입력해주세요.";
					openLayerPopText2(text,but1text,but1func,but1width);
	    			mySheet.SelectCell(i,"DELAY_REASON_COMBO");
	    			return;
	    		}	
	        }
		}
		
        if(ds_flag=="N"){ // Y는 분할납품한 품목임
            max_cd_date = cd_date;
            if(reject_yn == "Y"){ //수주거부 시 
        		if(mySheet.GetCellValue(i,"SELECTED") != "0"){ //체크되어있는 품목만 insert
        			query +=  buyer         + "@@";
                    query +=  po_no         + "@@";
                    query +=  po_seq        + "@@";
                    query +=  po_qty        + "@@";
                    query +=  cd_date       + "@@";
                    query +=  cd_qty        + "@@";
                    query +=  "Y"           + "@@"; // DS_FLAG
                    query +=  seller        + "@@";
                    query +=  user_id       + "@@";
                    query +=  delay_reason  + "@@";
                    query +=  max_cd_date   + "@@";// ICOMPODT.DS_DATE 에 들어가는 값   , 분할접수일 경우 마지날 납품예정일
                    query +=  rd_date + "@@";
                    query +=  reject_reason + "@@";
                    query +=  buyer_need_deli + "@@";
                    query +=  st_date + "@@";
                    query +=  reject_image_key;
                    query +=  "^||^" ;
        		}
        	}else{
        		query +=  buyer         + "@@";
                query +=  po_no         + "@@";
                query +=  po_seq        + "@@";
                query +=  po_qty        + "@@";
                query +=  cd_date       + "@@";
                query +=  cd_qty        + "@@";
                query +=  "Y"           + "@@"; // DS_FLAG
                query +=  seller        + "@@";
                query +=  user_id       + "@@";
                query +=  delay_reason  + "@@";
                query +=  max_cd_date   + "@@";// ICOMPODT.DS_DATE 에 들어가는 값   , 분할접수일 경우 마지날 납품예정일
                query +=  rd_date + "@@";
                query +=  reject_reason + "@@";
                query +=  buyer_need_deli + "@@";
                query +=  st_date + "@@";
                query +=  reject_image_key;
                query +=  "^||^" ;
        	}
            
            document.forms["processForm"].st_monitor.value = "AGENT_S_S_S";
        }else{
            query +=  query_text;
            
            document.forms["processForm"].st_monitor.value = "AGENT_S_S_M";
        }
        
        mySheet.SetCellValue(i,"SELECTED",true); //품목들 체크
	}
    
	if(reject_yn == "N"){
		if(buyer_item_no_arr.length != 0 && <%=p060000079%> == false){ //수주접수 통제해야되는 건이 있는 경우(통제 예외 협력사도 아니어야 함)
			g_query = query;
			var text = "해당 품목 ("+buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 수주접수를 진행할 수 있습니다.</br>KeP 승인완료 전에는 수주접수가 제한됩니다.";
			var but1textC = "확인";
			var but2textC = "MSDS관리 바로가기";
			var but1funcC = "javascript:reqAndClose(); return false;";
			var but2funcC = "javascript:reqAndMove(); return false;";
			var but1widthC = "120px";
			var but2widthC = "170px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 			if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 				//KEP_CMC_REQ insert 코드
// 				if(setGridData(query)){
// 					document.forms.sellerMpIvObtnodrReceiptDetailPop.st_query.value = query;
// 					kepAjaxPopFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
// 				}
// 			}
			return;
		}else if(tempMng_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
			g_query = query;
			var text = "해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관온도 조건 제출이 필요합니다.</br>등록 후 KeP 승인이 완료되면 수주접수를 진행할 수 있습니다.</br>KeP 승인완료 전에는 수주접수가 제한됩니다.";
			var but1textC = "확인";
			var but2textC = "MSDS관리 바로가기";
			var but1funcC = "javascript:reqAndClose(); return false;";
			var but2funcC = "javascript:reqAndMove(); return false;";
			var but1widthC = "120px";
			var but2widthC = "170px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 			if(confirm("해당 품목 ("+tempMng_no_reg_buyer_item_no_arr+") 은 보관조건(온도) 확인이 필요한 대상입니다.\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 물질정보 제출 후 KEP에서 승인되면 수주접수 하시기 바랍니다\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
// 				//KEP_CMC_REQ insert 코드
// 				if(setGridData(query)){
// 					document.forms.sellerMpIvObtnodrReceiptDetailPop.st_query.value = query;
// 					kepAjaxPopFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
// 				}
// 			}
			return;
		}else if(msds_no_reg_buyer_item_no_arr.length != 0 && <%=p060000079%> == false){
			g_query = query;
			var text = "해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 MSDS 제출이 필요합니다.</br>MSDS 등록 후 KeP 승인이 완료되면 수주접수를 진행할 수 있습니다.</br>KeP 승인완료 전에는 수주접수가 제한됩니다.";
			var but1textC = "확인";
			var but2textC = "MSDS관리 바로가기";
			var but1funcC = "javascript:layerPopClose(); return false;";
			var but2funcC = "javascript:layerPopMove(); return false;";
			var but1widthC = "120px";
			var but2widthC = "170px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 			alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 수주접수 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
			return;
		}else{//통제 건 없는 경우 수주접수 진행
		    document.forms["sellerMpIvObtnodrReceiptDetailPop"].st_query.value  = query;
		    document.forms["processForm"].st_po_create_date.value = po_create_date;
		    
		    if(setGridData(query)){
// 				if(!confirm("수주접수 하시겠습니까?")){ 
// 					return;
// 				}
				var text = "수주접수 하시겠습니까?";
				var but1textC = "확인";
				var but2textC = "취소";
				var but1funcC = "javascript:saveSellerMpIvObtnodrReceiptDetailPop(); return false;";
				var but2funcC = "javascript:closePopText1(); return false;";
				var but1widthC = "120px";
				var but2widthC = "120px";
				openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);

// 				kepAjaxPopFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do","processForm","order"); 	
				
// 				kepSave(document.processForm, mySheet, "/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do", "SELECTED");
			}
		}
    }else{
    	if(setGridData(query)){
// 			if(!confirm("수주거부 하시겠습니까?")){
// 				return;
// 			}
			
			kepAjaxPopFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailRejectPop.do","processForm","reject");
		}
    }
}
function saveSellerMpIvObtnodrReceiptDetailPop(){
	closePopText1();
	kepAjaxPopFormCall("/mpiv/saveSellerMpIvObtnodrReceiptDetailPop.do","processForm","order");
}
//선택된 그리드 값을 셋팅
function setGridData(query) {
	var returnValue = true;

	var resultArr = new Array(2);
	resultArr = ['',''];
//	  for (i = 0; i < j; i++) {
	
		/*
		str[0] ==>KRKEPB0004		==> BUYER
		str[1] ==>PO04000131		==> PO_NO
		str[2] ==>000001			==> PO_SEQ
		str[3] ==>5					==> PO_QTY
		str[4] ==>20040916			==> CD_DATE
		str[5] ==>1					==> CD_QTY
		str[6] ==>Y					==> DS_FLAG
		str[7] ==>KRKORE0001		==> SELLER
		str[8] ==>KEPSE03			==> USER_ID 
		str[9] ==>지연사유				==> DS_DELAY_REASON
		str[10]==>20040916			==> MAX_CD_DATE				
		str[11]==>20040915			==> RD_DATE
		str[12]==>거부사유				==> REJECT_REASON
		str[13]==>고객사요청분할		==> BUYER_NEED_DELI
		str[14]==>표준납품일			==> ST_DATE
		str[15]==>수주거부 첨부			==> REJECT_IMAGE_KEY
		*/
		
	var inputCnt = $("input[name='st_query_text']").length;
		
	//var name = "st_buyer|st_po_no|st_po_seq|st_cd_qty|st_ds_date|st_cd_qty|st_ds_flag|st_user_id|st_delay_reason|st_max_cd_date|st_rd_date";
	
	var name = new Array(15);
	name = ['st_buyer','st_po_no','st_po_seq','st_po_qty','st_ds_date','st_cd_qty','st_ds_flag','st_seller','st_user_id','st_delay_reason','st_max_cd_date','st_rd_date','st_reject_reason', 'st_ds_yn', 'st_st_date', 'st_reject_image_key'];

	//resultArr[0] = name;
	
	var st_query = query.split("^||^");
	
	for(var j = 0; j < st_query.length-1; j++){
		
		var value = st_query[j].split("@@",-1);
		
		for(var k = 0; k < name.length; k++){
			
			
			resultArr[0] = resultArr[0]+ name[k] + "|";
			resultArr[1] = resultArr[1]+ "<input type='hidden' name='"+name[k]+"' id='"+name[k]+"' value='"+value[k]+"'>";
		}
	}

	//마지막에 | 를 없애기 위함
	if (resultArr[0] != "")  resultArr[0] = resultArr[0].substr(0, resultArr[0].length -1);
		
	if(resultArr != null && resultArr !=""){
		
		document.forms["processForm"].s_SAVENAME.value = resultArr[0];
		$("#process").html(resultArr[1]);
		
	} else {
// 		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		var text = "그리드 데이터 변환에 실패하였습니다.[getFormToArr]";
		openLayerPopText2(text,but1text,but1func,but1width);
		returnValue = false;
	}
	
	return returnValue;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxPopSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		if(pMethod == "order"){
// 			alert("수주접수 정상 등록 완료.\n납품예정일 준수 부탁 드립니다.");
			var text = "수주접수 정상 등록 완료.</br>납품예정일 준수 부탁 드립니다.";
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else if(pMethod == "msds"){
			parent.doAction('search');
			parent.closePop();
// 			alert("물질정보 등록요청 완료.\n물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 수주접수 하시기 바랍니다.");
		}else if(pMethod == "msdsMove"){
			parent.msdsMove();
			parent.closePop();
		}else if(pMethod == "reject"){
// 			alert("수주거부요청이 완료되었습니다.\n진행현황은 [납품관리 > 납품이슈현황]에서 확인 가능합니다.");
			var text = "수주거부요청이 완료되었습니다.</br>진행현황은 [납품관리 > 납품이슈현황]에서 확인 가능합니다.";
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
		}else{
			parent.doAction('search');
			parent.closePop();
		}
		
	}else{
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	return;
}
function thisPopClose(){
	closePopText2();
	parent.doAction('search');
	parent.closePop();
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxPopError(pMethod , response,msg){
	var msg = response.msg;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}

// 발주서 인쇄
function btnSheet(){
	var po_no        = "<%=p_po_no%>";
	var buyer       = "<%=p_buyer%>";
	var seller      = "<%=CommonUtil.nvl(specialLogicInfo.get("SELLER"))%>";
	var tr_buyer    = "<%=CommonUtil.nvl(specialLogicInfo.get("BUYER2"))%>";
	var ref_if_no   = "<%=CommonUtil.nvl(specialLogicInfo.get("REF_IF_NO"))%>";
	var add_user_id = "<%=CommonUtil.nvl(specialLogicInfo.get("ADD_USER_ID"))%>";

	<%
		String Agent_rptUrl = CommonUtil.nvl(specialLogicInfo.get("AGENT_RPT_URL"));
		
		if(Agent_rptUrl.equals("")){
			Agent_rptUrl = "RD_06_S_002_06";
		}
	%>
	
	var param =  "["+po_no+"]["+seller+"]["+buyer+"]";
	var fileName = "<%=Agent_rptUrl%>";
	
	//alert("RD_ID : " + fileName + ", param : " + param);
	
	//var param =  "[PO14004517][KRDAEW0023][KRKORE0001]";
	reportOpen(fileName,param);
	
	return;	
	
	//window.open("?po_no="+pono+"&buyer=<%--=buyer--%>&seller="+seller,"SWin","width=710,height=710,left=0, top=0,resizable=YES,scrollbars=YES");
}
function SheetWin_daewoo_3(){  //신규 납품지시서
	 var agent_code  = "<%--=String.valueOf(vt.elementAt(4)) --%>";
	 alert("납품지시서 레포팅 연결 예정");
	 window.open("/kr/epro/buy/sheet/daewoo_delivery_order_list.jsp?agent_code="+agent_code,"sheetWin_TEST_3","toolbar=yes,width=700,height=600,resizable=YES,scrollbars=YES,top=0,left=0");
}

function dsDateAll(){
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	
	// 선택된 항목 유무 체크
	if (checkRows.length == 0) {
// 		alert("품목을 선택해주세요.");
		var text = "품목을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	var rowList = new Array();
	var rowJson = "";
	var gridJsonList = "";
	
	for(var idx = 0; idx<arrRow.length; idx++){
		var param = {
				"BUYER_NAME" : mySheet.GetCellValue(arrRow[idx],"BUYER_NAME")
				,"PO_NO" : mySheet.GetCellValue(arrRow[idx],"PO_NO")
				,"BUYER_ITEM_NO" : mySheet.GetCellValue(arrRow[idx],"BUYER_ITEM_NO")
				,"DESCRIPTION" : mySheet.GetCellValue(arrRow[idx],"DESCRIPTION")
				,"UNIT_PRICE" : mySheet.GetCellValue(arrRow[idx],"UNIT_PRICE")
				,"ITEM_QTY" : mySheet.GetCellValue(arrRow[idx],"ITEM_QTY")
				,"UNIT_MEASURE" : mySheet.GetCellValue(arrRow[idx],"UNIT_MEASURE")
				,"ITEM_AMT" : mySheet.GetCellValue(arrRow[idx],"ITEM_AMT")
				,"ST_DATE" : mySheet.GetCellValue(arrRow[idx],"ST_DATE")
			};
		rowJson = JSON.stringify(param);
		rowList.push(rowJson);
	}

	gridJsonList =  "[" + rowList.toString() + "]";
	
	var url = "/mpiv/showSellerMpIvDsDateDelayReasonMultiPop_v2.do";
	openLayerPop3(url,gridJsonList,"","850px","700px");
	
// 	$("#info").val(gridJsonList);
// 	openSearchPopupPost("/mpiv/showSellerMpIvDsDateDelayReasonMultiPop_v2.do", 'dsDateReasonAllForm', 'dsDateReasonAllForm', "width=850,height=700,resizable=no,scrollbars=no, top=100, left=200");
	
	

// 	var input = document.getElementById("hiddenDate");
// 	window.openCalendar(input,function(selectedDate){
// 			var checkRows = mySheet.FindCheckedRow("SELECTED");
// 			var arrRow = checkRows.split("|");
			
// 			// 선택된 항목 유무 체크
// 			if (checkRows.length == 0) {
// 				alert("품목을 선택해주세요.");
// 				return;
// 			}
			
// 			//선택한 값으로 납품예정일 일괄 등록
// 			for(var idx=0; idx<arrRow.length; idx++){
// 				mySheet.SetCellValue(arrRow[idx], "DS_DATE",selectedDate);
// 			}
// 		});
	
// 	input.trigBtn = trigBtn;
	
	
// 	var fp1 = flatpickr("#hiddenDate",{
// 	    dateFormat: "Y/m/d",
// 	    locale: "ko",
// 	    onChange:function(selectedDates,instance){
// 	  		 if(selectedDates.length > 0){
// 	        		  var a = selectedDates[0];
// 	        		  var selDate = a.getFullYear()+String(a.getMonth()+1).padStart(2,'0')+String(a.getDate()).padStart(2,'0');
// 	        		  calendarCallback(selDate);
// 	        	  }
	  	  
// 	    }
// 	  });
	
// 	fp1.open();
}

function setDsDateReason(flag,ds_gubun,ds_date,delay_reason){
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	var arrRow = checkRows.split("|");
	if(checkRows == "") {
// 		alert('선택된 데이터가 없습니다.');
		var text = "선택된 데이터가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	for(var idx = 0; idx<arrRow.length; idx++){
		mySheet.SetCellValue(arrRow[idx],"DS_GUBUN",ds_gubun);
		if(flag == "all"){
			mySheet.SetCellEditable(arrRow[idx],"DS_DATE",true);
			mySheet.SetCellValue(arrRow[idx],"QUERY_TEXT",""); //분할납품 입력했던거 초기화
			mySheet.SetCellValue(arrRow[idx],"DS_FLAG","N");
			mySheet.SetCellValue(arrRow[idx],"BUYER_NEED_DELI","N");
			if(mySheet.GetCellValue(arrRow[idx],"ST_DATE") < ds_date){
				mySheet.SetCellEditable(arrRow[idx],"DELAY_REASON_COMBO",true);
				if(delay_reason != "" && delay_reason != "재고부족" && delay_reason != "수입지연" && delay_reason != "제작지연" && delay_reason != "발주확인지연"){ //기타인 경우
					mySheet.SetCellValue(arrRow[idx],"DELAY_REASON_COMBO","기타");
					mySheet.SetCellValue(arrRow[idx],"DELAY_REASON_TEXT",delay_reason);
					mySheet.SetCellValue(arrRow[idx],"DELAY_REASON",delay_reason);
					mySheet.SetCellEditable(arrRow[idx], "DELAY_REASON_TEXT", true);
					mySheet.SetCellEditable(arrRow[idx], "DELAY_REASON_COMBO", true);
				}else{
					mySheet.SetCellValue(arrRow[idx],"DELAY_REASON_COMBO",delay_reason);
					mySheet.SetCellValue(arrRow[idx],"DELAY_REASON_TEXT","");
					mySheet.SetCellValue(arrRow[idx],"DELAY_REASON",delay_reason);
					mySheet.SetCellEditable(arrRow[idx], "DELAY_REASON_TEXT", false);
					mySheet.SetCellEditable(arrRow[idx], "DELAY_REASON_COMBO", true);
				}
			}else{
				mySheet.SetCellValue(arrRow[idx],"DELAY_REASON_COMBO","");
				mySheet.SetCellValue(arrRow[idx],"DELAY_REASON_TEXT","");
				mySheet.SetCellValue(arrRow[idx],"DELAY_REASON","");
				mySheet.SetCellEditable(arrRow[idx], "DELAY_REASON_TEXT", false);
				mySheet.SetCellEditable(arrRow[idx], "DELAY_REASON_COMBO", false);
			}
			mySheet.SetCellValue(arrRow[idx],"DS_DATE",ds_date);
		}
	}
}

function reqAndClose(){
	closePopText1();
    if(setGridData(g_query)){
    	document.forms["sellerMpIvObtnodrReceiptDetailPop"].st_query.value = g_query;
    	kepAjaxPopFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msds");
    }
	
}
function reqAndMove(){
	closePopText1();
    if(setGridData(g_query)){
    	document.forms["sellerMpIvObtnodrReceiptDetailPop"].st_query.value = g_query;
    	kepAjaxPopFormCall("/mpiv/saveSellerMpIvChemicalInfo.do","processForm","msdsMove");
    }
}
function layerPopClose(){
	closePopText1();
    parent.doAction('search');
    parent.closePop();
}
function layerPopMove(){
	closePopText1();
    parent.msdsMove();
    parent.closePop();
}
</script> 
</head>

<body onload="kep_onload_view();">
<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="s_SAVENAME" />
<input type="hidden" name="st_buyer"   id="st_buyer"        value="<%=p_buyer%>">
<input type="hidden" name="st_po_no"    id="st_po_no"       value="<%=p_po_no%>">
<input type="hidden" name="p070000033"  id="p070000033"         value="<%=p070000033%>">
	<div class="wrapPopup">
	
	<%
        		String doc_type = "";
        		String pre_gr_flag = "";
        		String buyer_name = "";
        		String buyer2 = "";
        		String purchaser_name = "";
        		String po_create_date = "";
        		
        		String tel_no = "";
        		String agent_po_ttl_amt = "";
        		String vat_flag = "";
        		
        		String dely_to_location = "";
        		String po_remark = "";
        		String kep_user = "";
        		String pohd_dely_to_location = "";
        		
        		String process_type = "";
        		String process_type_text = "";
        		        		
        		String center_tel_no = "";
        		
        		String delivery_remark = "";

				if(detailInfo != null){
					
					doc_type = CommonUtil.nvl(detailInfo.get("DOC_TYPE"));
					pre_gr_flag = CommonUtil.nvl(detailInfo.get("KEPMRO_PRE_GR_FLAG"));
					buyer_name = CommonUtil.nvl(detailInfo.get("BUYER_NAME"));
	        		buyer2 = CommonUtil.nvl(detailInfo.get("BUYER2"));
	        		purchaser_name = CommonUtil.nvl(detailInfo.get("PURCHASER_NAME"));
	        		po_create_date = CommonUtil.formatStrinigDate(CommonUtil.nvl(detailInfo.get("PO_CREATE_DATE")));
	        		
	        		tel_no = CommonUtil.nvl(detailInfo.get("TEL_NO"));
	        		agent_po_ttl_amt = CommonUtil.formatNumber(CommonUtil.nvl(detailInfo.get("AGENT_PO_TTL_AMT")),true,0,3);
	        		vat_flag = CommonUtil.nvl(detailInfo.get("VAT_FLAG"));
	        		
	        		dely_to_location = CommonUtil.nvl(detailInfo.get("DELY_TO_LOCATION"));
	        		kep_user =  CommonUtil.nvl(detailInfo.get("KEP_USER_NAME"));
	        		
	        		process_type =  CommonUtil.nvl(detailInfo.get("PROCESS_TYPE"));
	        		process_type_text =  CommonUtil.nvl(detailInfo.get("PROCESS_TYPE_TEXT"));
	        		
	        		center_tel_no =  CommonUtil.nvl(detailInfo.get("CENTER_TEL_NO"));
	        		
	        		if("KRDAEH0123".equals(p_buyer) || "KRDAEH0133".equals(p_buyer) || "KRDAEH0134".equals(p_buyer)){
						po_remark = "";
					}else{
						po_remark = CommonUtil.nvl(detailInfo.get("PO_REMARK"));
					}
	        		pohd_dely_to_location = CommonUtil.nvl(detailInfo.get("POHD_DELY_TO_LOCATION"));
	        		
	        		delivery_remark = CommonUtil.nvl(detailInfo.get("DELIVERY_REMARK"));
				}
			%>
  <div class="PopupTit">수주접수 상세<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSub">발주정보  
  <%
	if(doc_type.equals("S")){
  %>
	<span style=" position:absolute; right:0px; font-size:13px">※ 선입고 발주건입니다.&nbsp;&nbsp;&nbsp;&nbsp;</span>
  <%
	} else if(doc_type.equals("F")){
  %>
	<span style=" position:absolute; right:0px; font-size:13px">※ 긴급 발주건입니다.&nbsp;&nbsp;&nbsp;&nbsp;</span>
  <%
	}
  %>
  </div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="190px" />
      <col width="120px" />
      <col width="190px" />
  	</colgroup>
    <tr>
      <th>발주번호</th>
      <td><%=p_po_no%></td>
      <th>발주일</th>
      <td><%=po_create_date%></td>
      <th>고객사</th>
      <td><%=buyer_name%></td>
      <th>발주자</th>
      <td><%=purchaser_name%></td>
    </tr>
    <tr>
      <th>품목수량</th>
      <td align="right" id="buyerItemCnt"></td>
      <th>발주금액</th>
      <td align="right"><%=agent_po_ttl_amt%></td>
      <th>거래유형</th>
      <td><%=process_type_text%></td>
      <th>KeP담당자</th>
      <td><%=kep_user%></td>
    </tr>
    <tr>
    	<th>비고</th>
    	<td colspan="7"><%=po_remark %></td>
    </tr>       
  </table>  
  <div class="PopupTitSub">배송정보</div>
  <table class="PopupTableTxt" width="1200px">
    <colgroup>
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="170px" />
      <col width="120px" />
      <col width="500px" />
  	</colgroup>
  	
<!--   	<tr> -->
<!--       <th>인수자명</th> -->
<!--       <td>김구매</td> -->
<!--       <th>연락처</th> -->
<!--       <td>02-5869-5823</td> -->
<!--       <th></th> -->
<!--       <td></td> -->
<!--     </tr> -->
    <tr>
      <th>배송지</th>
      <td colspan="5"><%=dely_to_location%>
      <%if(process_type.equals("2")) {%>
	      &nbsp;/ 수령자: 센터장&nbsp;/ 연락처 : <%=center_tel_no%> - <font color="#F6495F"><b>택배 발송 시 좌측 정보로 입력하여 발송바랍니다.</b></font>
      <%}%>
      </td>
    </tr>
    <tr>      
      <th>배송 특이사항</th>
      <td colspan="5"><%=delivery_remark %></td>
    </tr>
  </table>  
  <div class="PopupTitSub" style="position:relative;width:1200px;">주문품목
    <p style="display:inline-block; margin-left:5px" id="itemCnt"></p>
    <button class="ButOutline_Small"style="margin-left:7px" onclick="javascript:dsDateAll(); return false;">납품예정일 일괄등록</button>
    <span style=" position:absolute; right:0px; font-size:13px">※ 납품예정일은 배송지 도착일로 입력해주세요. </span>
  </div>  
  <div class="IBSheetTablePopup" width="1200px">
  	<script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>
  </div>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:1200px;">
    <button class="ButQuaternary_large" onclick="javascript:btnSheet(); return false;" >발주서출력</button>
    <%if(process_type.equals("2") && p060000119 == false){ %>
    <button class="ButQuaternary_large" onclick="javascript:doPop('processTypeChange', '<%=p_buyer%>', '<%=p_po_no%>', '<%=process_type%>'); return false;">거래유형변경요청</button>
    <%} %>
    <button class="ButQuaternary_large" onclick="javascript:setRejectReason(); return false;">수주거부</button>
    <button class="ButPrimary_large"  onclick="javascript:setDeliverySchedule(); return false;">수주접수</button>
  </div>  
</div><!-- warp 끝-->
</form> 
<form name="sellerMpIvObtnodrReceiptDetailPop" id="sellerMpIvObtnodrReceiptDetailPop" method=post >
	<!-- HIDDEN -->
	<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	
	<input type="hidden" id="x" name="x"		value="">
	<input type="hidden" name="st_query"    	value="">
	<input type="hidden" name="file_get_y"		value="">
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
	<input type="hidden" name="st_po_create_date" id="st_po_create_date"  value=""> <!-- 장납기 이슈등록 판단 기준-->
	<input type="hidden" name="st_monitor" id="st_monitor" value=""> <!-- 모니터링용. 남아있는거 보이면 삭제하세요-->
	<div id="process">
	
	</div>
</form>
<form name="dsDateReasonAllForm" id="dsDateReasonAllForm" method="post">	
	<input type="hidden" name="info" id="info"  value="">
</form>
</body>
</html>
