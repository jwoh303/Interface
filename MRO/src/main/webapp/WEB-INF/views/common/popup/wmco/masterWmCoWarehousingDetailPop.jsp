<%--
**********************************************
* 메뉴 : 
* 화면 : 입고번호(거래명세서상세)
* 기능 : 
* 프로그램 ID : PG_08_M_900_12
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-5-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	rowData = _dataList.get(0);
}

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_hub_yn = CommonUtil.nvl((String) request.getParameter("st_hub_yn"),"N");

//두산모트롤BG 창원공장) 납품요청일 익월 출고지시 불가 
//SLOGIC-BEGIN(P08-0000002-02) 
boolean pP08_0000002_02 = CommonUtil.getSpecialCheckReturn(st_buyer,"P08-0000002-02");
//SLOGIC-END

//SLOGIC-BEGIN(P08-0000011) 
String pP08_0000011id ="";

Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(st_buyer);
if(_map!=null){
	pP08_0000011id = _map.get("SLG_ID");
}

//입고라벨 미사용 대상 고객사(TR이어도 고객사 고유의 양식 사용)
String st_no_tag_check_yn = "N";
boolean st_no_tag_check = CommonUtil.getCodeCheckReturn("M204", st_buyer);
if(st_no_tag_check == true){
	st_no_tag_check_yn = "Y";
}else{
	st_no_tag_check_yn = "N";
}

//품목라벨 자체 사용 고객사(KEP 품목라벨은 중복되어 출력되지 않아야 함)
String st_no_itemTag_check_yn = "N";
boolean st_no_itemTag_check = CommonUtil.getCodeCheckReturn("M206", st_buyer);

if(st_no_itemTag_check == true){
	st_no_itemTag_check_yn = "Y";
}else{
	st_no_itemTag_check_yn = "N";
}

// 고객사 고유 품목라벨 사용
String p070000034 = "";
Map<String, String> p070000034_map = CommonUtil.getSpecialCheckReturnMap(st_buyer,"P07-0000034");

if (p070000034_map != null){
	p070000034 = CommonUtil.nvl(p070000034_map.get("COL01_DATA"),""); // 품목라벨 mrd
}

//일반 거래명세서 외 특수상황 출력 필요 고객사
String siv00001_TYPE = "";
String siv00001_RD1 = "";
String siv00001_RD2 = "";

Map<String, String> siv00001_map = CommonUtil.getSpecialCheckReturnMap(st_buyer, "SIV00001");
if (siv00001_map != null){
	siv00001_TYPE = CommonUtil.nvl(siv00001_map.get("COL01_DATA"),""); // 상황 TYPE
	siv00001_RD1 = CommonUtil.nvl(siv00001_map.get("COL02_DATA"),""); // 추가출력 mrd
	siv00001_RD2 = CommonUtil.nvl(siv00001_map.get("COL03_DATA"),""); // 추가출력 mrd
}
//SLOGIC-END
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var carExist = ""; //차량유무
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var CarOn = "/resources/images/btn_search03.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1},  
		    			{Align : "Center",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:true, Edit : false},
		    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 250, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "ITEM_QTY",		Header : "발주수량",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "GR_QTY",		Header : "입고수량",	Type:"Float", Format:"${qtyFormat}", Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "WMS_GR_QTY",		Header : "기입고수량",	Type:"Float", Format:"${qtyFormat}", Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "AGENT_PRICE",		Header : "매입단가",	Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Right",SaveName : "AGENT_ITEM_AMT",		Header : "매입금액",	Type : "Float", Format:"${priceFormat}",Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "매출단가",	Type : "Float", Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "매출금액",	Type : "Float", Format:"${priceFormat}",Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Right",SaveName : "BOX_QTY",		Header : "* 박스수량",	Type:"Float", Format:"${qtyFormat}", Width : 100, EditLen : 110,	Edit :true, Hidden : false,  BackColor:"${notnullColor}"},
		    			{Align : "Center",SaveName : "SCHEDULED_DATE",		Header : "* 출고예정일",	Type : "Date",	Format:"Ymd", Width : 100,	EditLen : 110,	Edit : true, BackColor:"${notnullColor}" },
		    			{Align : "Left",SaveName : "CAR_ID",		Header : "차량아이디",	Type : "Text",	Width : 100, Hidden:true,	EditLen : 110,	Edit : false},
						{Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"차량", 	SaveName:"CAR_NO_IMG",BackColor:"${optColor}",},
		    			{Align : "Right",SaveName : "CAR_NO",		Header : "차량번호",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, Hidden:false},
		    			{Align : "Left",SaveName : "CAR_PERSON_NAME",		Header : "차량기사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "CAR_PERSON_TEL",		Header : "연락처",	Type : "Text",	Width : 100,	EditLen : 110,	Edit :false},
						{Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지연사유",	SaveName:"DELAY_REMARK_IMG",BackColor:"${optColor}" },
						{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지연사유",	SaveName:"DELAY_REMARK"},
		    			{Align : "Left",SaveName : "PO_REMARK",		Header : "비고",	Type : "Text",	Width : 400,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "REF_PR_NO",		Header : "관리번호",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false},
		    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BYIT_COMORG_CODE"},
		    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_NO"},
		    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"CONTRACT_SEQ"},
		    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"BUYER"},
		    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_SEQ"},
		    			{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"", SaveName:"INV_QTY"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
   
	mySheet.SetImageList(1, CarOn);
	kepSearch(document.searchCondition ,  mySheet , "/wmco/getMasterWmCoWarehousingDetailPop.do" ,pagingMode );
	//doAction('init');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "CAR_NO_IMG");
	setLinkCol(mySheet, "DELAY_REMARK_IMG");
	
	mySheet.SetImageList(1, CarOn);
	
<%if(!st_hub_yn.equals("Y")){%>
	kepSetCalender("st_ivk_date");
<%}%>
	$("#st_ivk_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}

var st;
var mt;
//기능함수

function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			mySheet.RemoveAll();
			kepSearch(document.searchCondition ,  mySheet , "/wmco/getMasterWmCoWarehousingDetailPop.do" , pagingMode );
			break;
			
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
			
		case "init":
			$('#masterWmCoWarehousingDetail').attr("action", "/wmco/getMasterWmCoWarehousingDetail.do").submit();   
			break;
			
		case "save": // 저장
		 	var row_num = 0;
		 	var ivk_flag = document.getElementById('st_ivk_flag').checked;
		 	
		 	var hub_iv_yn = document.searchCondition.st_hub_iv_yn.value;
		 	
			// 간선 센터 미출고 확인
		 	if(hub_iv_yn == "N"){
		 		alert("간선 센터에서 출고지시를 먼저 실행하시기 바랍니다.");
		 		return;
		 	}
		 	
		 	//출고지시
		 	if(ivk_flag){	
		 		//묶음배송건 출고지시 불가
		 		if(document.searchCondition.st_dely_bun_flag.value == "Y"){
 					alert('묶음배송건은 입고확정 처리만 가능 합니다. ');
	 				return;
		 		}
		 		
		 		for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
		 			//SLOGIC-BEGIN(P08-0000002-02) 
		 			if(<%=pP08_0000002_02%>){
		 				alert("(주)두산 모트롤BG 창원공장은 출고지시에 제약이 있으므로,\n출고 메뉴를 통해서 출고지시 하시기 바랍니다.");
		 				return;
		 			}
		 			//SLOGIC-END
		 			
		 	 		if(mySheet.GetCellValue(i,'BUYER') == "KRDAEW0016"){
		 	 			if(mySheet.GetCellValue(i,'CAR_NO') == ''){
	 	 					alert('차량정보를 입력 해주세요 ');
	 	 					mySheet.SelectCell(i, 'CAR_NO_IMG', 1);
	 	 					return;
		 	 			}
		 	 		}
		 		}

		 		if(!confirm("센터 입고 및 출고를 하시겠습니까?")) {
		 	    	return;
		 	    }else{
		 	    	//차량정보 유무를 판단한다.
		 	    	carExist = "";
		 	    	
			 		for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
			 			if(mySheet.GetCellValue(i, 'CAR_ID') != ""){
			 				carExist = "Y";
			 			}
					}
			 		
			 		document.searchCondition.st_ivk_yn.value ="Y";
			 		kepSaveAll(document.searchCondition ,  mySheet , "/wmco/saveMasterWmCoWarehousingDetail.do");
		 	    }
		 	}else{ //입고
		 		document.searchCondition.st_ivk_yn.value ="";
		 	 	
		 	 	if(mySheet.length == 0){
		 	        alert(" 입고확정 대상을 선택해 주십시요.");
		 	        return;
		 	 	}
		 	 	
		 	    if(!confirm("센터 입고를 하시겠습니까?")) {
		 	    	return;
		 	    }else{
			 		//IBS_SaveName(document.searchCondition ,mySheet);
			 		//var info = FormQueryStringEnc(document.searchCondition , true);
			 		//mySheet.DoAllSave("/wmco/saveMasterWmCoWarehousingDetail.do", info);
		 	    	kepSaveAll(document.searchCondition ,  mySheet , "/wmco/saveMasterWmCoWarehousingDetail.do");
		 	    }
		 	}
		 	
			break;			
	}
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}
	
	for(i= 1 ; i<mySheet.GetTotalRows()+1; i++){
		mySheet.SetCellValue(i, 'CAR_NO_IMG', CarOn);
		
		if(mySheet.GetCellValue(i,"DELAY_REMARK")==""){
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOff);
		}else{
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOn);
		}
	}
}

function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_multi":
			openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+"<%=CommonUtil.nvl(rowData.get("AGENT")) %>" , "800,600,no");
			popupSel = "masterMdCpCompyDetailViewPop";
			
			break;
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(code==1){
		alert("정상적으로 센터 입고 및 출고지시가 되었습니다.");		
		var st_user_id = document.searchCondition.st_user_id.value;
		var st_warehouse_code = document.searchCondition.st_warehouse_code.value; 
		
		if("P08-0000011-23"=="<%=pP08_0000011id%>" ){
			//화승 네트워크인 경우에는 부서를 조회
			setWmsTrSheet("<%=pP08_0000011id%>",carExist ,msg.substring(20),st_warehouse_code, "<%=st_buyer%>", msg.substring(10,20), st_user_id , "<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%>");
		}else{
			setWmsTrSheet("<%=pP08_0000011id%>",carExist ,"",st_warehouse_code, "<%=st_buyer%>", msg.substring(10,20), st_user_id , "<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%>");
		}
		//저장 성공시 재조회
		 opener.doAction('search');
		 this.close();
		 
	}else if(code==0){
		alert("센타 입고 및 출고지시가 실패 하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다");
	}else if(code==2){
		alert("정상적으로 센타 입고가 되었습니다.");
		opener.doAction('search');
		this.close();
	}else if(code==3){
		alert("센타 입고가 실패 하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다");
	}else if(code == 5){
		var msgGr =  msg.split("@@");
		alert("입고번호 "+ msgGr[1]+"는 기 등록된 입고 입니다.");
	}
}

//페이지 인덱스 눌렀을 경우 조회

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	if((column == 'BUYER_ITEM_NO')){
		if(mySheet.GetCellValue(Row, 'BUYER_ITEM_NO') !=""){
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ , "800,260,no"); 
		}
	}
	
	if(column=="CAR_NO_IMG" ){
		var buyer = mySheet.GetCellValue(Row,'BUYER');
		openSearchPopup('/wmgr/showMasterWmGrIntervalsInfoPop.do','?BUYER='+buyer , "800,400,no"); 
		popupSel = "masterWmGrIntervalsInfoPop";
	}
	
	if(column=="DELAY_REMARK_IMG" ){
		var st_DELAY_REMARK = mySheet.GetCellValue(Row,'DELAY_REMARK');
		var st_BUYER = document.searchCondition.st_buyer.value;
		var st_PO_NO = document.searchCondition.st_po_no.value;
		openSearchPopup('/wmco/showMasterWmCoDelayPop.do','?st_DELAY_REMARK='+st_DELAY_REMARK+'&st_BUYER='+st_BUYER+'&st_PO_NO='+st_PO_NO , "500,220,no"); 
		popupSel = "masterWmCoDelayPop";
	}
	
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterWmGrIntervalsInfoPop") {	// 배송차량팝업
		var valueArr1 = value1.split('@');
	    var valueArr2 = value2.split('@');
		mySheet.SetCellValue(grbRow, 'CAR_ID', valueArr1[0]);
		mySheet.SetCellValue(grbRow, 'CAR_NO', valueArr1[1]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_NAME', valueArr2[0]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_TEL', valueArr2[1]);
	}else if(popupSel = "masterWmCoDelayPop"){
		var valueArr1 = value1;
		mySheet.SetCellValue(grbRow, 'DELAY_REMARK', valueArr1);
		
		if(valueArr1==""||valueArr1==null){
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOff);
		}else{
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOn);
		}
	}
	
	grbRow="";	//초기화
}

//확인
function kepConfirm(){
	opener.doAction('search');
	this.close();
}

function sheetWin() {
	var st_no_tag_check_yn = "<%=st_no_tag_check_yn%>";
	if(st_no_tag_check_yn == "Y"){
		alert("해당 고객사는 입고라벨을 사용하지 않습니다.");
		return;
	}
	
	var buyer = "<%=st_buyer%>";
	var inv_no = $("#st_inv_no").val();
	var rpt_url = "RD_06_S_001_170"; // 일반프린터
	var seller = "KRKORE0001";
	var ktag_box_qty = $("#st_gr_box_qty").val();
	var legacy_iv_serial = "";
	var tr_buyer = $("#st_warehouse_code").val();
	var print_gbn = "1";
	var legacy_po_no = "";
	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+ktag_box_qty+"]";
	
	var dely_to_location_code = $("#st_dely_to_location_code").val();
	var cqdt_item_no = $("#st_cqdt_item_no").val();
		
	openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
	
	if("<%=st_no_itemTag_check_yn%>" == "Y"){
		rpt_url = "<%=p070000034%>";
		param = "["+inv_no+"]["+seller+"]["+buyer+"]";
		
		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
	}
	
	// 특수 상황에 RD파일 추가 출력 필요 고객사 START
	if("<%=siv00001_TYPE%>" != ""){
		if("<%=siv00001_TYPE%>" == "TYPE01"){ // 세스코
			if(dely_to_location_code == "DS431" && cqdt_item_no != ""){ // DS431 : 안성물류센터
				// 기본 박스라벨 출력
				rpt_url = "<%=siv00001_RD1%>";
    			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
    			
    			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
    			
				if(cqdt_item_no != "X"){ // X가 아니면 품목바코드도 출력
					rpt_url = "<%=siv00001_RD2%>";
        			param = "["+inv_no+"]["+seller+"]["+buyer+"]";
        			
        			openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
				}
			}
		}
	}
	// 특수 상황에 RD파일 추가 출력 필요 고객사 END
	
	return;
}

function sheetTagListWin4() {
	var buyer = "<%=st_buyer%>";
	var ik_no = $("#st_inv_no").val();
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = "1";
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var fileName = "RD_06_X_002_19"; // 일반프린터
	
	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";
	
    reportOpen(fileName, param);
	return;
}

function sheetTagListWin12() {
	var buyer = "<%=st_buyer%>";
	var ik_no = $("#st_inv_no").val();
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = "1";
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var fileName = "RD_06_X_002_21"; // 일반프린터
	
	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";
	
    reportOpen(fileName, param);
	return;
}
</script> 
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method = "post">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
	<input type="hidden" id="st_po_no"  name="st_po_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_po_no"),"") %>">
	<input type="hidden" id="st_inv_no"  name="st_inv_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_inv_no"),"") %>">
	<input type="hidden" id="st_dely_bun_flag"  name="st_dely_bun_flag" value="<%=CommonUtil.nvl((String) request.getParameter("st_dely_bun_flag"),"") %>">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("ware_house_code"),"") %>">
	<input type="hidden" name="st_doc_type" value ="<%=CommonUtil.nvl(rowData.get("DOC_TYPE"))%>">
	<input type="hidden" name="st_ivk_yn" id="st_ivk_yn">
	<input type="hidden" id="st_hub_yn"  name="st_hub_yn" value="<%=st_hub_yn%>">
	<input type="hidden" id="st_hub_iv_yn"  name="st_hub_iv_yn" value="<%=CommonUtil.nvl(rowData.get("HUB_IV_YN"))%>">
	<input type="hidden" id="st_dely_to_location_code"  name="st_dely_to_location_code" value="<%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION_CODE"))%>">
	<input type="hidden" id="st_cqdt_item_no"  name="st_cqdt_item_no" value="<%=CommonUtil.nvl(rowData.get("CQDT_ITEM_NO"))%>">
	
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">TR 입고확정</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"   style="height:448px;">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%;">
						<caption>조회</caption>
						<colgroup>
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
							<col width="10%" />
							<col width="20%" />
						</colgroup>
						<tbody>

						<tr>
							<th>고객사</th>
							<td ><b><%=CommonUtil.nvl(rowData.get("COM_NAME")) %></b></td>
                  			<th >발주번호</th>
					  		<td ><%=CommonUtil.nvl(rowData.get("PO_NO")) %><%="".equals(CommonUtil.nvl(rowData.get("LEGACY_PO_NO")))?"":"("+CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))+")" %></td>
							<th >발주일</th>
							<td ><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
						 </tr>
						 <tr>
							<th >납품요청일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
                  			<th >입고번호</th>
					  		<td  ><b><%=CommonUtil.nvl(rowData.get("INV_NO")) %></b>(<%=CommonUtil.nvl(rowData.get("STATUS"))%>)</td>
							<th >구분</th>
							<td  ><%=CommonUtil.nvl(rowData.get("DOC_TEXT"))%></td>
						 </tr>
						 <tr>
							<th >입고예정일</th>
							<td  ><%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE_RE"))%></td>
                  			<th >협력사</th>
					  		<td colspan='3'  ><u><a href="javascript:doPop('buyer_multi')"><%=CommonUtil.nvl(rowData.get("AGENT_NAME")) %></a></u><%="".equals(CommonUtil.nvl(rowData.get("AGENT_TEL_NO")))?"":"("+CommonUtil.nvl(rowData.get("AGENT_TEL_NO"))+")"%></td>
					  	 </tr>
						 <tr>
							<th >요청자</th>
							<td ><%=CommonUtil.nvl(rowData.get("ADD_USER_NAME"))%><%="".equals(CommonUtil.nvl(rowData.get("ADD_USER_TEL")))?"":"("+CommonUtil.nvl(rowData.get("ADD_USER_TEL"))+")"%></td>
                  			<th >배송처</th>
					  		<td   colspan='3'><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td>
						 </tr>
						 <tr>
							<th >비고</th>
							<td   colspan='5'><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></td>
						 </tr>
					</tbody>
				</table>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c; height:225px;">
				<script type="text/javascript"> 
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
			<br/>
			
			<!--버튼영역-->
<%if(!st_hub_yn.equals("Y")){%>
			<span class="fl">
				<span class="btn_02 mr04"><a href="javascript:sheetWin();" style="text-align:center;cursor:hand">입고라벨</a></span>
				<span class ="btn_10_blue" style="width:115px; color:#FFF">
					박스수량 : 
					<select id="st_gr_box_qty" name="st_gr_box_qty" style="width:40px; margin-top:3px">
						<option value="1" >1</option>
						<option value="2" >2</option>
						<option value="3" >3</option>
						<option value="4" >4</option>
						<option value="5" >5</option>
						<option value="6" >6</option>
						<option value="7" >7</option>
						<option value="8" >8</option>
						<option value="9" >9</option>
						<option value="10" >10</option>
						<option value="11" >11</option>
						<option value="12" >12</option>
						<option value="13" >13</option>
						<option value="14" >14</option>
						<option value="15" >15</option>
						<option value="16" >16</option>
						<option value="17" >17</option>
						<option value="18" >18</option>
						<option value="19" >19</option>
						<option value="20" >20</option>
						<option value="21" >21</option>
						<option value="22" >22</option>
						<option value="23" >23</option>
						<option value="24" >24</option>
						<option value="25" >25</option>
						<option value="26" >26</option>
						<option value="27" >27</option>
						<option value="28" >28</option>
						<option value="29" >29</option>
						<option value="30" >30</option>
						<option value="31" >31</option>
						<option value="32" >32</option>
						<option value="33" >33</option>
						<option value="34" >34</option>
						<option value="35" >35</option>
						<option value="36" >36</option>
						<option value="37" >37</option>
						<option value="38" >38</option>
						<option value="39" >39</option>
						<option value="40" >40</option>
						<option value="41" >41</option>
						<option value="42" >42</option>
						<option value="43" >43</option>
						<option value="44" >44</option>
						<option value="45" >45</option>
						<option value="46" >46</option>
						<option value="47" >47</option>
						<option value="48" >48</option>
						<option value="49" >49</option>
						<option value="50" >50</option>
                   </select>
				</span>
				<span class="btn_05 mr04"><a href="javascript:sheetTagListWin4();" style="text-align:center;cursor:hand">품목라벨(4칸)</a></span>
				<span class="btn_05 mr04"><a href="javascript:sheetTagListWin12();" style="text-align:center;cursor:hand">품목라벨(12칸)</a></span>
			</span>
<%}%>			
			<span class="fr" style="display:<%="N".equals(CommonUtil.nvl(rowData.get("HUB_IV_YN")))?"none":"block"%>">
				<table border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
<%if(!st_hub_yn.equals("Y")){%>
							<input type="checkbox" name="st_ivk_flag" id="st_ivk_flag" value="Y" style="cursor:pointer;"><label for="st_ivk_flag" >출고지시</label>
							<input type="text" class="input_type_text" name="st_ivk_date" id="st_ivk_date" size="10" readOnly style="width:100px; text-align:center;" value=""/>
							<a href="javascript:kepCalendar('st_ivk_date')"></a>
<%}else{%>
							<input type="checkbox" name="st_ivk_flag" id="st_ivk_flag" value="Y" style="cursor:pointer;display: none;"><label for="st_ivk_flag" style="display: none;">출고지시</label>
							<input type="text" class="input_type_text" name="st_ivk_date" id="st_ivk_date" size="10" readOnly style="width:100px; text-align:center; display: none;" value=""/>
<%}%>
						</td>
						<td>
							&nbsp;<span class="btn_02 mr04"><a href="javascript:doAction('save');" style="text-align:center;cursor:hand">입고확정</a></span>
						</td>
					</tr>
				</table>
			</span>
		</div>	

    </div>
</form> 
</body>
</html>
