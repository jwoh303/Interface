<%--
**********************************************
* 메뉴 : wms->출고>출고지시및 거래 명세표
* 화면 : 출고지시 및 거래명세표(입고번호별)
* 기능 : 출고지시 및 거래명세표 (입고번호별)
* 프로그램 ID : PG_08_M_006_03
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-2
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
//두산모트롤BG 창원공장) 납품요청일 익월 출고지시 불가 
//SLOGIC-BEGIN(P08-0000002-02) 
boolean pP08_0000002_02 = CommonUtil.getSpecialCheckReturn(CommonUtil.nvl((String) request.getParameter("st_BUYER"),""),"P08-0000002-02");
//SLOGIC-END

//	두산인프라 코어 I/F 전송대상 
//SLOGIC-BEGIN(P08-0000001-02) 
boolean pP08_0000001_01 = CommonUtil.getSpecialCheckReturn(CommonUtil.nvl((String) request.getParameter("st_BUYER"),""),"P08-0000001-01");
//SLOGIC-END

//출고 후 거래 명세서 띄우기 금지
//SLOGIC-BEGIN(P08-0000001-02) 
boolean pP08_0000007_01= CommonUtil.getSpecialCheckReturn(CommonUtil.nvl((String) request.getParameter("st_BUYER"),""),"P08-0000007-01");
//SLOGIC-END


	
	//화승네트워크여부 
	String pP08_0000011id ="";

	Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(CommonUtil.nvl((String) request.getParameter("st_BUYER"),""));
	if(_map!=null){
		pP08_0000011id = _map.get("SLG_ID");

	}

	String st_hub_yn = CommonUtil.nvl((String) request.getParameter("HUB_YN"),"N");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
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
var checkpP08_0000002_02 = <%=pP08_0000002_02%>;
var checkpP08_0000001_01 =<%=pP08_0000001_01%>;
var checkpP08_0000007_01 = <%=pP08_0000007_01 %>;

var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var carExist;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "MSDS_NO",		Header : "MSDS NO",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "PO_QTY",		Header : "발주수량",Type:"Float", Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "WMS_GR_QTY",		Header : "입고(재고)수량",	Type:"Float", Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "IVK_QTY",		Header : "*출고수량",	Type:"Float", Format:"${qtyFormat}",	Width : 100, EditLen : 12,	Edit : true, Hidden : false,BackColor:"${notnullColor}"},
	    			{Align : "Right",SaveName : "BOX_QTY",		Header : "박스수량",	Type:"Float", Format:"${qtyFormat}",	Width : 100,	EditLen : 12,	Edit : true,BackColor:"${optColor}",Hidden : false},
	    			{Align : "Right",SaveName : "IV_QTY",		Header : "기출고수량",	Type:"Float", Format:"${qtyFormat}",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",SaveName : "IVK_DATE",		Header : "*출고일자",	Type:"Date",Format:"Ymd",Width : 100, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
	    			{Align : "Center",SaveName : "SCHEDULED_DATE",		Header : "출고예정일",	Type:"Date",Format:"Ymd",Width : 100,	EditLen : 110,	Edit :true  ,BackColor:"${optColor}"},
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 50, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "출고단가",Type : "Float", Format:"${priceFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "WMS_IVK_AMT",		Header : "출고금액",	Type : "Float", Format:"${priceFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CAR_ID",		Header : "차량아이디",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false ,Hidden:true},
	    			{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"차량", 	SaveName:"CAR_NO_IMG",BackColor:"${optColor}" },
	    			{Align : "Left",SaveName : "CAR_NO",		Header : "차량번호",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "CAR_PERSON_NAME",		Header : "차량기사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "CAR_PERSON_TEL",		Header : "연락처",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지연사유",	SaveName:"DELAY_REMARK_IMG",BackColor:"${optColor}"},
	    			{Align : "Left",SaveName : "PO_REMARK",		Header : "비고",	Type : "Text",	Width : 230, EditLen : 110,	Edit : false, Hidden : false}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"BYIT_COMORG_CODE"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"CONTRACT_NO"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"CONTRACT_SEQ"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"BUYER"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"PROCESS_TYPE"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"PO_SEQ"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"INV_SEQ"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"WMS_GW_QTY"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"PO_NO"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"INV_NO"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"DELAY_REMARK"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"DOC_TYPE"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"PR_USER_ID"}
	];
	initsheet.Cfg = { FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "MSDS_NO");
	setLinkCol(mySheet, "DELAY_REMARK_IMG");
	setLinkCol(mySheet, "CAR_NO_IMG");
	setLinkCol(mySheet, "CAR_NO");	
 	mySheet.SetCellFontUnderline(0,"CAR_NO", true);
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiReleaseTransPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiReleaseTransPop.do" , pagingMode );
			break;
		case "save":
			//if("KRXPR00465" ==document.searchCondition.st_BUYER.value || "KRXPR00466" == document.searchCondition.st_BUYER.value ) 현재 미사용 고객사들이어서 빠짐 delivery person set 기능임
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 	 	
	 	 	if(selectedGrid.length == 0)
	 	 	{
	 	        alert(" 출고지시 대상을 선택해 주십시요.");
	 	        return;
	 	 	}
	 	 	var curMonth = kepGetNowTimeStr('YYYYMMDD','').substring(0, 6);
	 		// (주)두산 모트롤BG 창원공장 출고지시 제한
			if(checkpP08_0000002_02 &&( <%=CommonUtil.nvl((String) request.getParameter("st_RD_DATE_value"),"").substring(0, 6)  %>  > curMonth ) ){
				alert("(주)두산 모트롤BG 창원공장은 납품요청일이 익월일 경우\n출고지시를 할 수 없습니다");
				return;
			}
	 		//묶음배송건 출고지시 불가
	 		if(document.searchCondition.st_bd_flag.value == "Y"){
				alert('묶음배송건이므로 요청번호 팝업 통해서 출고지시 바랍니다. ');
 				return;
	 		}
			for(var i = 0 ; i <arrRow.length; i++)
			{
	 	 		if(mySheet.GetCellValue(arrRow[i],'BUYER') == "KRDAEW0016"){
	 	 			
	 	 			if(mySheet.GetCellValue(arrRow[i],'CAR_NO') == ''){
	 	 					alert('차량정보를 입력 해주세요 ');
	 	 					mySheet.SelectCell(arrRow[i], 'CAR_NO_IMG', 1);
	 	 					return;
	 	 			}
	 	 			
	 	 		}
				
	 	 		var sum = mySheet.GetCellValue(arrRow[i],'IVK_QTY');
	 	 		
				for(var j = 0 ; j <arrRow.length; j++)
				{
					if(mySheet.GetCellValue(arrRow[i],'IVK_DATE') !=mySheet.GetCellValue(arrRow[j],'IVK_DATE'))
					{
						alert('출고일자가 다른 것끼리 출고지시 할 수 없습니다');
						return;
					}
				}
				for(var k = i+1; k < arrRow.length; k++) {
					if(mySheet.GetCellValue(arrRow[i],'PROCESS_TYPE') != "2") { // TR이 아닌경우
						if(mySheet.GetCellValue(arrRow[i],'STDCATLG_ID') == mySheet.GetCellValue(arrRow[k],'STDCATLG_ID')) {
							sum += mySheet.GetCellValue(arrRow[k],'IVK_QTY');
						}
					}
				}
				if(sum > mySheet.GetCellValue(arrRow[i],'WMS_GR_QTY')) {
					alert("입고(재고)수량 보다 출고수량 합산 값이 큽니다. 출고수량 확인바랍니다.");					
					return;
				}
//				if(eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) <= 0 )
//				{
//					alert('출고수량이 0이나 음수가 될 수 없습니다');
//					return;
//				}
				if(eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) > eval(mySheet.GetCellValue(arrRow[i],'WMS_GR_QTY')))
				{
					alert('재고가 부족한 제품이 있습니다');					
					return;
				}
				if(("KRX"==mySheet.GetCellValue(arrRow[i],'BUYER')) && eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) != eval(mySheet.GetCellValue(arrRow[i],'WMS_GR_QTY'))  )
				{
					alert('KEPMRO 주문은 발주수량을 분할 하여 출고 할 수 없습니다.');
					return;
				}				
			}
		    if(!confirm("출고지시를 하시겠습니까?")) {
		        return;
		    }else{		    		   	
		    	carExist = "";
		    	for(var m = 0 ; m <arrRow.length; m++)
		    	{
		    		if(mySheet.GetCellValue(arrRow[m],'CAR_NO' ) != ""){
		    			carExist = "Y";
		    		}	
		    	}
		    	
				kepSave(document.searchCondition ,  mySheet , "/wmgi/saveMasterWmGiReleaseTransPop.do" , "SELECTED" );
		    }
			break;
		case "cart":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 	 	var itemCount = 0;
	 	 	var isStck = 'true';
	 	 	if(selectedGrid.length == 0)
	 	 	{
	 	        alert(" 장바구니에 담을 제품을 선택 하세요.");
	 	        return;
	 	 	} 	 	
	 	 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		if(mySheet.GetCellValue(arrRow[i],'PROCESS_TYPE') == "2"){
	 	 			isStck = 'false';
	 	 		}else{
					itemCount++;
				}
	 	 	}
	 		if(isStck == 'false'){
	 			if(!confirm('재고/VMI 제품이 아닌것이 있습니다.\n계속 하시겠습니까')){
	 				return;
	 			}
	 		}

	 		if(itemCount == 0){
	 			alert('선택한 제품들 중에 재고/VMI 제품이 없습니다');
	 			return;
	 		}
		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    var st_STDCATLG_ID_arr ="";
		    var st_ST_CART_QTY_arr ="";
			for(var i = 0 ; i <arrRow.length; i++){
				
				st_STDCATLG_ID_arr = st_STDCATLG_ID_arr + mySheet.GetCellValue(arrRow[i], "STDCATLG_ID")+"@";
//				st_ST_CART_QTY_arr = st_ST_CART_QTY_arr + mySheet.GetCellValue(arrRow[i], "STDCATLG_ID")+"," + mySheet.GetCellValue(arrRow[i], "ST_CART_QTY")+"@";
		
			}
			openSearchPopup('/wmgi/showMasterWmGiCartRegPop.do','?st_warehouse_code='+ware_house_code+'&st_STDCATLG_ID_arr='+st_STDCATLG_ID_arr , "1000,400,no"); 
			popupSel = "masterWmGiCartRegPop";
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
			break;
	}

}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}


//헤더 더블클릭시 복사
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	
	if (mySheet.ColSaveName(Col) == "CAR_NO"){ // 차량번호 
		var varCAR_ID = mySheet.GetCellValue(arrRow[0], "CAR_ID");
		var varCAR_NO = mySheet.GetCellValue(arrRow[0], "CAR_NO");
		var varCAR_PERSON_NAME = mySheet.GetCellValue(arrRow[0], "CAR_PERSON_NAME");
		var varCAR_PERSON_TEL = mySheet.GetCellValue(arrRow[0], "CAR_PERSON_TEL");
		
		if(kepIsValueNull(varCAR_NO)){
			alert("복사할 차량을 선택하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet.SetCellValue(arrRow[idx], "CAR_ID", varCAR_ID);
			mySheet.SetCellValue(arrRow[idx], "CAR_NO", varCAR_NO);
			mySheet.SetCellValue(arrRow[idx], "CAR_PERSON_NAME", varCAR_PERSON_NAME);
			mySheet.SetCellValue(arrRow[idx], "CAR_PERSON_TEL", varCAR_PERSON_TEL);
		}
	}
	
	
}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	
	var st_buyer = document.searchCondition.st_BUYER.value;
	getDeliCompany(st_buyer);
	
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
		if($("#st_hub_yn").val() == "Y"){ // 간선
			mySheet.SetCellEditable(i, "IVK_QTY", 0);
			var color = mySheet.GetCellBackColor(i, "PO_QTY");
			
			mySheet.SetColBackColor("IVK_QTY", "");
		}else{
			if(mySheet.GetCellValue(i,"WMS_GW_QTY")=="0")
			{
				mySheet.SetCellEditable(i, "SELECTED", 0);
				mySheet.SetCellEditable(i, "IVK_DATE", 0);
				
			}else{
				mySheet.SetCellEditable(i, "SELECTED", 1);
				
				mySheet.SetCellEditable(i, "IVK_DATE", 1);
			}
			
			if(mySheet.GetCellValue(i,"DOC_TYPE")=="0")
			{
				mySheet.SetCellEditable(i, "IVK_QTY", 0);
			}else {
				mySheet.SetCellEditable(i, "IVK_QTY", 1);
			}
			if(eval(mySheet.GetCellValue(i,"WMS_GW_QTY")) > eval(mySheet.GetCellValue(i,"WMS_GR_QTY")) ){
				
				mySheet.SetCellFontColor(i,"IVK_QTY","#FF0000") ;
				mySheet.SetCellValue(i,"IVK_QTY",mySheet.GetCellValue(i,"WMS_GW_QTY")) ;
				
			}
			else
			{	
				mySheet.SetCellValue(i,"IVK_QTY",mySheet.GetCellValue(i,"WMS_GW_QTY")) ;
			}
			
			mySheet.SetCellValue(i, 'CAR_NO_IMG', remarkOn);
			if(mySheet.GetCellValue(i,"DELAY_REMARK") == "" )
			{
				mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOff);
			}
			else{
				mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOn);
			}
		}
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//function openIvUpdate(buyer, ik_no){
	//document.searchCondition.inv_no.value = ik_no;
	//document.searchCondition.buyer.value = buyer;
	//kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrTrGrCreDoosanIF.do" , "SELECTED"  );
//}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	var msgArrr = msg.split("@@");
	var ik_no = msgArrr[0].substring(2);
	var st_buyer = document.searchCondition.st_BUYER.value;
	var st_user_id = document.searchCondition.st_user_id.value;
	var st_warehouse_code = document.searchCondition.st_warehouse_code.value; 
 	var ktag_flag =document.searchCondition.st_KTAG_USE_FLAG.value; 
	
 	if(code =="1"){
 		// 간선 아닌경우 = 기존 출고지시
 		if($("#st_hub_yn").val() != "Y"){
 			//SLOGIC-BEGIN(P06-0000028)
 			//if( checkpP08_0000001_01) //두산인프라
 			//{
 				//openIvUpdate(st_buyer,ik_no);
 			//}//SLOGIC-END
 			
 			alert("정상적으로 출고지시가 되었습니다.\n\n거래명세서 번호는  " + ik_no + " 입니다.");
 			
 			if(!checkpP08_0000007_01){
 				if("P08-0000011-23"=="<%=pP08_0000011id%>" ){
 					//화승 네트워크인 경우에는 부서를 조회
 					setWmsTrSheet("<%=pP08_0000011id%>",carExist,msgArrr[1],st_warehouse_code,st_buyer, ik_no, st_user_id , "<%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"")%>",'','', '');
 				}else{
 					setWmsTrSheet("<%=pP08_0000011id%>",carExist,"", st_warehouse_code, st_buyer, ik_no, st_user_id , "<%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"")%>",'','', "<%=CommonUtil.nvl((String) request.getParameter("st_PROCESS_TEXT"),"") %>", "<%=CommonUtil.nvl((String) request.getParameter("st_INV_NO"),"")%>");
 				}
 			}
 			
 			if ($("#ktag_selectbox2").val() == "1") {
 				sheetTagListWin1(st_buyer,ik_no);
 			}else if ($("#ktag_selectbox2").val() == "4") {
 				sheetTagListWin4(st_buyer,ik_no);
 			}else if ($("#ktag_selectbox2").val() == "12") {
 				sheetTagListWin12(st_buyer,ik_no);
 			}
 			
 			//일양택배 택배라벨 출력기능
			if(msgArrr[1] == "Y"){
				var url ="/coco/showReportViewer.do";
				var param = encodeURI("?fileName=RD_06_X_002_16&param=[" + st_buyer + "][" + ik_no + "]");
				window.open(url + "" + param, "", "width=770,height=800,resizable=YES,top=0,left=0");
			}
			//한진택배 택배라벨 출력기능
			if(msgArrr[1] == "HJ"){
				var url ="/coco/showReportViewer.do";
				var param = encodeURI("?fileName=RD_06_X_002_81&param=[" + st_buyer + "][" + ik_no + "]");
				window.open(url + "" + param, "", "width=770,height=800,resizable=YES,top=0,left=0");
			}
 			
 			opener.doAction('search');
 	 		this.close();
 		}else{ // 간선
 			alert("정상적으로 출고지시가 되었습니다.");
 			
 			opener.doAction('search');
 	 		this.close();
 		}
 	}else {
		  if(msg!= ''){
		      alert(msg);
		  }
	      return;
	 }
}

function sheetTagListWin1(buyer,ik_no) {
	
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = $("#ktag_box_qty").val();
	//var param = encodeURI("?fileName=RD_06_X_002_12&param=["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer);
	//window.open(url +""+param, "", "width=770,height=600,resizable=YES,top=0,left=200");
	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer;
    reportOpen("RD_06_X_002_17", param);
	return;
}

function sheetTagListWin4(buyer,ik_no) {
	
	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = 1;	// 품목태그는 수량 관계없이 항상 기본 1장씩 출력(한애희)
	var fileName = "";
	var print_size = $("#ktag_selectbox3").val();
	
	//var param = encodeURI("?fileName=RD_06_X_002_12&param=["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer);
	//window.open(url +""+param, "", "width=770,height=600,resizable=YES,top=0,left=200");
	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]";
	
	if(print_size == "L"){
 		fileName = "RD_06_X_002_20";
 	}else if(print_size == "N"){
 		fileName = "RD_06_X_002_19";
 	}
	
    reportOpen(fileName, param);
	return;
}

function sheetTagListWin12(buyer,ik_no) {

	var seller = "KRKORE0001";
	var legacy_po_no = "";
	var pur_id = "";
	var ktag_start = $("#ktag_selectbox").val();
	var url ="/coco/showReportViewer.do";
	var ktag_box_qty = $("#ktag_box_qty").val();

//     var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]";   
//    	alert(param);
//     reportOpen("RD_06_X_002_12", param); 

	//var param = encodeURI("?fileName=RD_06_X_002_11&param=["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer);
	//window.open(url +""+param, "", "width=770,height=800,resizable=YES,top=0,left=200");
	var param = "["+ik_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]["+ktag_start+"]["+ktag_box_qty+"]&inv_no="+ik_no+"&buyer="+buyer;   
    reportOpen("RD_06_X_002_11", param); 
	return;
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiReleaseTransPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if(column=='BUYER_ITEM_NO')
	{
		if(mySheet.GetCellValue(Row,'BUYER_ITEM_NO')!=""){

			if(mySheet.GetCellValue(Row,'DOC_TYPE')!="X"){
				var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
				var BYIT_COMORG_CODE = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
				var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
				var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
				openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+BUYER_ITEM_NO+'&BYIT_COMORG_CODE='+BYIT_COMORG_CODE+'&CONTRACT_NO='+CONTRACT_NO+'&CONTRACT_SEQ='+CONTRACT_SEQ, "800,260,no"); 
			}
		}
	}else 	if(column=="DELAY_REMARK_IMG" )
	{
		var st_DELAY_REMARK = mySheet.GetCellValue(Row,'DELAY_REMARK');
		var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
		var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
		openSearchPopup('/wmco/showMasterWmCoDelayPop.do','?st_DELAY_REMARK='+st_DELAY_REMARK+'&st_BUYER='+st_BUYER+'&st_PO_NO='+st_PO_NO, "500,220,no"); 
		popupSel = "masterWmCoDelayPop";

	}else	if(column=="CAR_NO_IMG" )
	{
			var buyer = mySheet.GetCellValue(Row,'BUYER');
			openSearchPopup('/wmgr/showMasterWmGrIntervalsInfoPop.do','?BUYER='+buyer, "800,380,no"); 
			popupSel = "masterWmGrIntervalsInfoPop";		
	}else	if(column=="MSDS_NO" )
	{
			var st_msds_no = mySheet.GetCellValue(Row,'MSDS_NO');
			if(st_msds_no == ""){
				alert("선택한 MSDS 정보가 없습니다.");
				return;
			}else{
				openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+st_msds_no+"&st_btn_yn=N",'750,580,no'); 
				popupSel = "msdsDetailPop";
			}
	}
	
	return;
}
//셀의 값을 편집 완료하고, 기존 값이 변경되었을 때 이벤트가 발생한다.
function mySheet_OnChange(Row, Col, Value) {
	
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column=='IVK_QTY')
	{
	       var ivk_qty      = mySheet.GetCellValue(Row,'IVK_QTY');          // 출고수량
	       var org_ivk_qty  = mySheet.GetCellValue(Row,'WMS_GW_QTY');           // ORG_출고수량
	        if( (isEmpty(ivk_qty) || eval(ivk_qty) > eval(org_ivk_qty) || eval(ivk_qty) <= 0) && ivk_qty != 0){
	            alert("출고수량을 확인 후 다시 입력해 주십시요");
	            mySheet.SetCellValue(Row,"IVK_QTY",mySheet.GetCellValue(Row,"WMS_GW_QTY")) ;
	            return;
	        }else{
				if(eval(mySheet.GetCellValue(Row,"IVK_QTY")) >= eval(mySheet.GetCellValue(Row,"WMS_GR_QTY")) ){
					
					mySheet.SetCellFontColor(Row,"IVK_QTY","#FF0000") ;
				}
	        }
	}else if(column=='IVK_DATE'){
		
		mySheet.SetCellValue(Row,"SELECTED","1");
		
	}
}
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "buyer_multi":
			 var com_code = "<%=CommonUtil.nvl((String) request.getParameter("st_AGENT"),"") %>";  
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code , "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		break;
	}
}

//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	if (popupSel == "masterWmGrIntervalsInfoPop") {	// 배송차량팝업
		
		var valueArr1 = value1.split('@');
	    var valueArr2 = value2.split('@');
		mySheet.SetCellValue(grbRow, 'CAR_ID', valueArr1[0]);
		mySheet.SetCellValue(grbRow, 'CAR_NO', valueArr1[1]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_NAME', valueArr2[0]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_TEL', valueArr2[1]);
	
		}else if(popupSel == "masterWmCoDelayPop") {
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK', value1);
			if(value1 == ""){
				mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOff);
			}
			else{
				mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOn);
			}
		}
grbRow="";	//초기화
}

function getDeliCompany(buyer) {  
	   
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/wmgi/getMasterWmGiBpReleaseDirectionsTranDeliCompany.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { buyer: buyer},
	     async : false,
	     success:function( response ) {
	    	 const noneOption = document.querySelector('#select_deliCompany option[value="N"]');
    	 	 if(response.Message == "IY") {	    	 		
	    	 	// 없음 값 숨기기
	    	 	noneOption.style.display = 'none';
	    	 	document.getElementById('select_deliCompany').value = 'IY';
    	 	 } else if(response.Message == "HJ") {
    	 		// 없음 값 숨기기
    	 		noneOption.style.display = 'none';
    	 		document.getElementById('select_deliCompany').value = 'HJ';
    	 	 } else {
    	 		noneOption.style.display = '';
    	 		document.getElementById('select_deliCompany').value = 'N';
    	 	 }
		 },
		 error:function( response ) {  		    	   
	    	 alert("오류발생하였습니다.");
		 }
    });
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<input type="hidden" id="st_AGENT"  name="st_AGENT" value="<%=CommonUtil.nvl((String) request.getParameter("st_AGENT"),"") %>">
	<input type="hidden" id="st_BUYER"  name="st_BUYER"  value="<%=CommonUtil.nvl((String) request.getParameter("st_BUYER"),"") %>">
	<input type="hidden" id="st_PO_NO"  name="st_PO_NO" value="<%=CommonUtil.nvl((String) request.getParameter("st_PO_NO"),"") %>">
	<input type="hidden" id="st_INV_NO"  name="st_INV_NO" value="<%=CommonUtil.nvl((String) request.getParameter("st_INV_NO"),"") %>">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">
	<input type="hidden" id="st_KTAG_USE_FLAG"  name="st_KTAG_USE_FLAG" value="<%=CommonUtil.nvl((String) request.getParameter("st_KTAG_USE_FLAG"),"") %>">
	<input type="hidden" id="st_bd_flag"  name="st_bd_flag" value="<%=CommonUtil.nvl((String) request.getParameter("st_bd_flag"),"") %>">			
    <input type="hidden" name="st_sys_type"			value="WMS">	
    <input type="hidden" name="inv_no"			value="">
    <input type="hidden" name="buyer"			value="">    	
	<input type="hidden" id="st_hub_yn" name="st_hub_yn" value="<%=st_hub_yn%>">
	
	<div id="popWrapper" style="height:565px;">
    	<div id="popHeader">
        	<h1 class="title">출고지시 및 거래명세표(입고번호별)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="50px" />
							<col width="18%" />
							<col width="50px" />
							<col width="18%" />
							<col width="50px" />
							<col width="30%" />
						</colgroup>
						
						<tbody>
						<tr>
							<th>고객사</th>
							<td><b><%=CommonUtil.nvl((String) request.getParameter("st_BUYER_NAME"),"") %></b></td>
							<th>발주번호</th>
							<td><b><%=CommonUtil.nvl((String) request.getParameter("st_PO_NO"),"") %></b><%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"").equals("")?"":"(" +CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"")+")"%></td>
							<th>발주일</th>
							 <td><%=CommonUtil.nvl((String) request.getParameter("st_PO_CREATE_DATE"),"") %></td>
						  </tr>
						  <tr>
							<th>납품요청일</th>
							<td><%=CommonUtil.nvl((String) request.getParameter("st_RD_DATE"),"") %></td>
							<th>입고번호</th>
							<td><b><%=CommonUtil.nvl((String) request.getParameter("st_INV_NO"),"") %></b></td>
							<th>구분&nbsp;</th>
							 <td><%=CommonUtil.nvl((String) request.getParameter("st_PROCESS_TEXT"),"") %>(<%=CommonUtil.nvl((String) request.getParameter("st_DOC_TEXT"),"") %>)</td>
						  </tr>
						  <tr>
							<th>요청자</th>
							<td><%=CommonUtil.nvl((String) request.getParameter("st_ADD_USER_NAME"),"") %><%=CommonUtil.nvl((String) request.getParameter("st_ADD_USER_TEL"),"").equals("")?"":"(" +CommonUtil.nvl((String) request.getParameter("st_ADD_USER_TEL"),"")+")"%></td>
							<th>입고일</th>
							<td><%=CommonUtil.nvl((String) request.getParameter("st_WMS_GR_DATE"),"") %></td>
							<th>협력사</th>
							 <td><u><a href="javascript:doPop('buyer_multi')"><%=CommonUtil.nvl((String) request.getParameter("st_AGENT_NAME"),"") %></a></u><%=CommonUtil.nvl((String) request.getParameter("st_AGENT_TEL_NO"),"").equals("")?"":"(" +CommonUtil.nvl((String) request.getParameter("st_AGENT_TEL_NO"),"")+")"%>
							 </td>
						  </tr>
						   <tr>
							<th>배송처</th>
							<td colspan="5"><%=CommonUtil.nvl((String) request.getParameter("st_DELY_TO_LOCATION"),"") %></td>
						  </tr>
						  <tr>
							<th>비고</th>
							<td colspan="5"><%=CommonUtil.nvl((String) request.getParameter("st_HD_REMARK"),"") %></td>
						  </tr>
					</tbody>
				</table>
             	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" onchange="javascript:doAction('search');">
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
					<option value="200">200건</option>
				</select>
			</span>		
			<br/>                
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:240px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "240px");
				</script>
			</div>
			 <p class="paging" id="pageindex"></p>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
        	<span class="fl" style="padding: 5px 20px;">	
  					<span class="btn_10_blue" style="color:#FFF;">
						택배사 선택&nbsp;
						<select id="select_deliCompany" name="select_deliCompany" style="width:65px; margin-top:3px">
		                    <option value="N" selected>없음</option>
		                    <option value="HJ">한진택배</option>
		                    <option value="IY">일양택배</option>		                    
	                    </select>
					</span>
  				</span>
			<span class="fr">
				<font color="#006699">출고수량이 
			</font><b><font color="#FF0000">빨간색</font></b><font color="#006699">은 가용재고가 
			부족한 상태입니다.</font>
								<span class ="btn_10_blue" style="color:#FFF; display: none;">
									KTAG출력위치
									<select id="ktag_selectbox" name="ktag_selectbox" style="width:40px; margin-top:3px">
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
				                    </select> 
          				       </span>
          				       
<%if("Y".equals(st_hub_yn)){%>
							<span class ="btn_10_blue" style="width:115px; color:#FFF; display:none;">
<%}else{%>
							<span class ="btn_10_blue" style="width:115px; color:#FFF">
<%}%>
									박스수량: 
									<select id="ktag_box_qty" name="ktag_box_qty" style="width:40px; margin-top:3px">
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
	
								<span class="btn_10_blue" style="color:#FFF; display: none; ">
									K tag출력
									<select id="ktag_selectbox2" name="ktag_selectbox2" style="width:60px; margin-top:3px">
				                    <option value="12" >12칸</option>
				                    <option value="4" selected>4칸</option>
				                    <option value="1" >1칸</option>
				                    </select> 
								</span>

<%if("Y".equals(st_hub_yn)){%>
								<span class="btn_10_blue" style="color:#FFF; display: none;">
<%}else{%>
								<span class="btn_10_blue" style="color:#FFF;">
<%}%>								
									출력방식&nbsp;&nbsp;
									<select id="ktag_selectbox3" name="ktag_selectbox3" style="width:60px; margin-top:3px">
					                    <option value="L">라벨</option>
					                    <option value="N" selected>일반</option>
				                    </select>
								</span>
		<!--  <span qlass="btn_05 mr04"><a href="javascript:doAction('cart');">장바구니담기</a></span>-->
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">출고지시</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
