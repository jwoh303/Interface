<%--
**********************************************
* 메뉴 : 
* 화면 : 출고지시 및 거래명세표(LEGACY_NO별)
* 기능 : 출고지시 및 거래명세표 (Legacy번호별)
* 프로그램 ID : PG_08_M_006_04
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-4
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_BUYER"),"");
//대우 조선해양 다중 출고 지시 불가
//SLOGIC-BEGIN(P08-0000005-02) 
boolean pP08_0000005_02 = CommonUtil.getSpecialCheckReturn(st_buyer,"P08-0000005-02");
//SLOGIC-END

//두산모트롤BG 창원공장) 납품요청일 익월 출고지시 불가 
//SLOGIC-BEGIN(P08-0000002-02) 
boolean pP08_0000002_02 = CommonUtil.getSpecialCheckReturn(st_buyer,"P08-0000002-02");
//SLOGIC-END



//두산인프라 코어 I/F 전송대상 
//SLOGIC-BEGIN(P08-0000001-01)
boolean pP08_0000001_01 = CommonUtil.getSpecialCheckReturn(st_buyer,"P08-0000001-01");
//SLOGIC-END


	//화승네트워크여부 
	String pP08_0000011id ="";

	Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(CommonUtil.nvl((String) request.getParameter("st_BUYER"),""));
	if(_map!=null){
		pP08_0000011id = _map.get("SLG_ID");

	}
	String legacy_no = CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/js/common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	//  Y: 번호 페이징, N :스크롤
var popupSel = "";
var grbRow;
var checkpP08_0000002_02 = <%=pP08_0000002_02%>;
var checkpP08_0000005_02 = <%=pP08_0000005_02%>;
var checkpP08_0000001_01 =<%=pP08_0000001_01%>;
var agentImg = "/resources/images/btn_search03.gif";
var carExist;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Center",SaveName : "STATUS_TEXT",		Header : "상태",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "PROCESS_TEXT",		Header : "구분",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "PO_NO",		Header : "발주번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "GR_NO",		Header : "입고번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "STDCATLG_ID",		Header : "표준코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "PO_QTY",		Header : "발주수량",	Type : "Float", Format:"${qtyFormat}", Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "WMS_GR_QTY",		Header : "입고(재고)수량",	Type : "Float", Format:"${qtyFormat}", 	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "IVK_QTY",		Header : "*출고수량",	Type : "Float", Format:"${qtyFormat}", Width : 100, EditLen :12,	Edit : false, Hidden : false ,BackColor:"${notnullColor}"},
	    			{Align : "Right",SaveName : "BOX_QTY",		Header : "박스수량",	Type : "Float", Format:"${qtyFormat}",	Width : 100,	EditLen : 12,	Edit : false,BackColor:"${optColor}"},
	    			{Align : "Right",SaveName : "WMS_IVK_QTY",		Header : "기출고수량",	Type : "Float", Format:"${qtyFormat}", 	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "IVK_DATE",		Header : "*출고일자",	Type:"Date",Format:"Ymd",	Width : 100, EditLen : 110,	Edit : false, Hidden : false,BackColor:"${notnullColor}"},
	    			{Align : "Center",SaveName : "SCHEDULED_DATE",		Header : "출고예정일",	Type:"Date",Format:"Ymd",Width : 100,	EditLen : 110,	Edit : false ,BackColor:"${optColor}"},
	    			{Align : "Center",SaveName : "RD_DATE",		Header : "납품요청일",	Type:"Date",Format:"Ymd",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Right",SaveName : "UNIT_PRICE",		Header : "출고단가",Type : "Float", Format:"${priceFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Right",SaveName : "UNIT_AMT",		Header : "출고금액",	Type : "Float", Format:"${priceFormat}",Width : 100,	EditLen : 110,	Edit : false, Hidden : true},
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"협력사",	SaveName:"AGENT_IMG"},
	    			{Align : "Center",SaveName : "AGENT_TEXT",		Header : "협력사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "ADD_USER_NAME_VIEW",		Header : "요청자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden :true},
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청자",	SaveName:"ADD_USER_IMG"},
	    			{Align : "Center",SaveName : "DELY_TO_LOCATION",		Header : "배송처",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"차량", 	SaveName:"CAR_NO_IMG",BackColor:"${optColor}" },
	    			{Align : "Center",SaveName : "CAR_ID",		Header : "차량아이디",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false ,Hidden:true},
	    			{Align : "Left",SaveName : "CAR_NO",		Header : "차량번호",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "CAR_PERSON_NAME",		Header : "차량기사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "CAR_PERSON_TEL",		Header : "연락처",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
	    			{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지연사유",	SaveName:"DELAY_REMARK_IMG",BackColor:"${optColor}"},
	    			{Align : "Center",SaveName : "PO_REMARK",		Header : "비고",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : false},	    			
	    			{Align : "Center",SaveName : "AGENT",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "DOC_TYPE",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "BUYER",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "LEGACY_PO_NO",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "LEGACY_PO_SEQ",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "INV_SEQ",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "BYIT_COMORG_CODE",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},    			
	    			{Align : "Center",SaveName : "HD_REMARK",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "SORT_STATUS",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "PROCESS_TYPE",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "PROCESS_TEXT",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "ADD_USER_NAME",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "ADD_USER_TEL",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "IMG_NO",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "PO_SEQ",		Header : "",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"DELAY_REMARK"}
	    			,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"IVK_QTY_ORG"}
	];
	initsheet.Cfg = {FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "ADD_USER_IMG");
	setLinkCol(mySheet, "AGENT_IMG");
	setLinkCol(mySheet, "DELAY_REMARK_IMG");
	setLinkCol(mySheet, "CAR_NO_IMG");
	setLinkCol(mySheet, "CAR_NO");	
 	mySheet.SetCellFontUnderline(0,"CAR_NO", true);
	mySheet.SetImageList(0, agentImg);
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiLegacyNoPop.do" , pagingMode );

}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiLegacyNoPop.do" , pagingMode );
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
		case "save": //출고지시
			//if("KRXPR00465" ==document.searchCondition.st_BUYER.value || "KRXPR00466" == document.searchCondition.st_BUYER.value ) 현재 미사용 고객사들이어서 빠짐 delivery person set 기능임
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 	 	if(selectedGrid.length == 0)
	 	 	{
	 	        alert(" 출고지시 대상을 선택해 주십시요.");
	 	        return;
	 	 	}
	 		//묶음배송건 출고지시 불가
	 		if(document.searchCondition.st_bd_flag.value == "Y"){
				alert('묶음배송건이므로 요청번호 팝업 통해서 출고지시 바랍니다. ');
 				return;
	 		}
	 	 	if(checkpP08_0000005_02)
	 	 	{
				for(var i = 0 ; i <arrRow.length; i++)
				{
					var legacyCheck = 0;
					for(var j = 0 ; j <arrRow.length; j++)
					{
						if((mySheet.GetCellValue(arrRow[i],'LEGACY_PO_NO') == mySheet.GetCellValue(arrRow[j],'LEGACY_PO_NO') ) && (mySheet.GetCellValue(arrRow[i],'LEGACY_PO_SEQ') == mySheet.GetCellValue(arrRow[j],'LEGACY_PO_SEQ') ) )
						{
							legacyCheck++;
						}
						if(legacyCheck > 1){
							alert("동일한 구매사발주에 대해서 송장에 다중으로 출고지시 할 수 없습니다");
							return;
						}
					}
				}
	 	 	}
	 	 	var curMonth = kepGetNowTimeStr('YYYYMMDD','').substring(0, 6);
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
				
				if(checkpP08_0000002_02 &&( mySheet.GetCellValue(arrRow[i],'RD_DATE').substring(0, 6)  > curMonth ) ){
					alert("(주)두산 모트롤BG 창원공장은 납품요청일이 익월일 경우\n출고지시를 할 수 없습니다");
					return;
				}
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
				
				if(eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) > eval(mySheet.GetCellValue(arrRow[i],'WMS_GR_QTY')))
				{
					alert('재고가 부족한 제품이 있습니다');					
					return;
				}				
				if(eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) <= 0 )
				{
					alert('출고수량이 0이나 음수가 될 수 없습니다');
					return;
				}
				if(("KRX"==mySheet.GetCellValue(arrRow[i],'BUYER')) && eval(mySheet.GetCellValue(arrRow[i],'IVK_QTY')) != eval(mySheet.GetCellValue(arrRow[i],'PO_QTY'))  )
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
				kepSave(document.searchCondition ,  mySheet , "/wmgi/saveMasterWmGiLegacyNoPop.do" , "SELECTED" );
				break;	
		    }
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

//function openIvUpdate(st_buyer,ik_no){
	//document.searchCondition.inv_no.value = ik_no;
	//document.searchCondition.buyer.value = st_buyer;
	//kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrTrGrCreDoosanIF.do" , "SELECTED"  );
//}

//셀의 값을 편집 완료하고, 기존 값이 변경되었을 때 이벤트가 발생한다.
function mySheet_OnChange(Row, Col, Value) {
	
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column=='IVK_QTY')
	{
	       var ivk_qty      = mySheet.GetCellValue(Row,'IVK_QTY');          // 출고수량
	       var org_ivk_qty  = mySheet.GetCellValue(Row,'IVK_QTY_ORG');           // ORG_출고수량
	        if( isEmpty(ivk_qty) || eval(ivk_qty) > eval(org_ivk_qty) || eval(ivk_qty) <= 0){
	            alert("출고수량을 확인 후 다시 입력해 주십시요");
	            mySheet.SetCellValue(Row,"IVK_QTY",mySheet.GetCellValue(Row,"IVK_QTY_ORG")) ;
	            return;
	        }else{
				if(eval(mySheet.GetCellValue(Row,"IVK_QTY")) >= eval(mySheet.GetCellValue(Row,"IVK_QTY_ORG")) ){
					
					mySheet.SetCellFontColor(Row,"IVK_QTY","#FF0000") ;
				}
	        }
	}else if(column=='IVK_DATE'){
		
		mySheet.SetCellValue(Row,"SELECTED","1");
		
	}
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

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	var msgArrr = msg.split("@@");
	var ik_no = msgArrr[0].substring(2);
	var st_buyer = document.searchCondition.st_BUYER.value;
	var st_user_id = document.searchCondition.st_user_id.value;
	var st_warehouse_code = document.searchCondition.st_warehouse_code.value;  
	
	if(code =="1" )
	{
	
	      //if( checkpP08_0000001_01) //두산인프라
	      //{
	    	  //openIvUpdate(st_buyer,ik_no);
	      //}
		 alert("정상적으로 출고지시가 되었습니다.\n\n거래명세서 번호는  " + ik_no + " 입니다.");

	   	//두산중공업, 대우조선 빠짐 
		if( ( "<%=pP08_0000011id%>"!="P08-0000011-01" ) &&  ( "<%=pP08_0000011id%>"!="P08-0000011-02" ) ){

			if("P08-0000011-23"=="<%=pP08_0000011id%>" ){
				//화승 네트워크인 경우에는 부서를 조회

				setWmsTrSheet("<%=pP08_0000011id%>",carExist,msgArrr[1],st_warehouse_code,st_buyer, ik_no, st_user_id , "<%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"")%>",'','', '');
				
			}else{ 
				setWmsTrSheet("<%=pP08_0000011id%>",carExist,"", st_warehouse_code, st_buyer, ik_no, st_user_id , "<%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"")%>",'','', '');
			
			}
				

		}
	    	  

	      opener.doAction('search');
	      this.close();
	}else {
		  if(msg!= ''){
		      alert(msg);
		  }

	      return;
	 }
		
	
	
}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{
		if(mySheet.GetCellValue(i,"STATUS_TEXT")=="출고예정"){
			mySheet.SetCellEditable(i, "SELECTED", 1);

			if(eval(mySheet.GetCellValue(i,"IVK_QTY")) > eval(mySheet.GetCellValue(i,"WMS_GR_QTY")) ){
				
				mySheet.SetCellFontColor(i,"IVK_QTY","#FF0000") ;
			}
			mySheet.SetCellEditable(i, "IVK_QTY", 1);
			mySheet.SetCellEditable(i, "IVK_DATE", 1);
			mySheet.SetCellEditable(i, "SCHEDULED_DATE", 1);
			mySheet.SetCellEditable(i, "BOX_QTY", 1);
		}else{
			mySheet.SetCellEditable(i, "SELECTED", 0);

			mySheet.SetCellEditable(i, "IVK_QTY", 0);
			mySheet.SetCellEditable(i, "IVK_DATE", 0);
			mySheet.SetCellEditable(i, "SCHEDULED_DATE", 0);
			mySheet.SetCellEditable(i, "BOX_QTY", 0);
		}
		
		if(mySheet.GetCellValue(i,"AGENT_NAME")!="")
		{
			mySheet.SetCellValue(i, 'AGENT_IMG', agentImg);
		}
		mySheet.SetCellValue(i, 'ADD_USER_IMG', agentImg);
		
		mySheet.SetCellValue(i, 'CAR_NO_IMG', agentImg);
		mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', agentImg);

	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiLegacyNoPop.do?page="+current_page , pagingMode );
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
	}else if(column=="ADD_USER_IMG" )
	{
		if(mySheet.GetCellValue(Row,'ADD_USER_NAME')!="")
		{
			var st_ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
			var st_ADD_USER_TEL = mySheet.GetCellValue(Row,'ADD_USER_TEL');
			var st_POHD_REMARK = mySheet.GetCellValue(Row,'HD_REMARK');
			openSearchPopup('/wmco/showMasterWmCoRequestPop.do','?st_ADD_USER_NAME='+st_ADD_USER_NAME+'&st_ADD_USER_TEL='+st_ADD_USER_TEL+'&st_POHD_REMARK='+st_POHD_REMARK, "500,220,no"); 
			popupSel = "masterWmCoRequestPop";
		}
	}else  if(column=="AGENT_IMG" )
	{
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else 	if(column=="DELAY_REMARK_IMG" )
	{
		var st_DELAY_REMARK = mySheet.GetCellValue(Row,'DELAY_REMARK');
		var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
		var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
		openSearchPopup('/wmco/showMasterWmCoDelayPop.do','?st_DELAY_REMARK='+st_DELAY_REMARK+'&st_BUYER='+st_BUYER+'&st_PO_NO='+st_PO_NO , "500,220,no"); 
		popupSel = "masterWmCoDelayPop";

	}else	if(column=="CAR_NO_IMG" )
	{
			var buyer = mySheet.GetCellValue(Row,'BUYER');
			openSearchPopup('/wmgr/showMasterWmGrIntervalsInfoPop.do','?BUYER='+buyer , "800,380,no"); 
			popupSel = "masterWmGrIntervalsInfoPop";
				
	}

	return;
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
	
		}
grbRow="";	//초기화
}
//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
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
	<input type="hidden" id="st_LEGACY_PO_NO"  name="st_LEGACY_PO_NO"  value="<%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"") %>">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">	
	<input type="hidden" id="st_bd_flag"  name="st_bd_flag" value="<%=CommonUtil.nvl((String) request.getParameter("st_bd_flag"),"") %>">
	<input type="hidden" name="st_sys_type"			value="WMS">	
    <input type="hidden" name="inv_no"			value="">
    <input type="hidden" name="buyer"			value="">    	
	<div id="popWrapper" style="height:495px;">
    	<div id="popHeader">
        	<h1 class="title">출고지시 및 거래명세표(LEGACY_NO별)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
            	<table class="cont_t_list06" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="45px" />
							<col width="28%" />
							<col width="50px" />
							<col width="25%" />
							<col width="45px" />
							<col width="15%" />
						</colgroup>
						
						<tbody>
						<tr>
						   <th>고객사</th>
							<td><b><%=CommonUtil.nvl((String) request.getParameter("st_BUYER_NAME"),"") %></b></td>
							<th>LEGACY_NO</th>
							<td><b><%=CommonUtil.nvl((String) request.getParameter("st_LEGACY_PO_NO"),"") %></b>(발주일:<%=CommonUtil.nvl((String) request.getParameter("st_PO_CREATE_DATE"),"")%>)</td>
							<th>요청자</th>
							<td><%=CommonUtil.nvl((String) request.getParameter("st_ADD_USER_NAME"),"") %><%=CommonUtil.nvl((String) request.getParameter("st_ADD_USER_TEL"),"").equals("")?"":"(" +CommonUtil.nvl((String) request.getParameter("st_ADD_USER_TEL"),"")+")"%></td>
						 </tr>
						  <tr>
							<th>비고</th>
							<td colspan="3"><%=CommonUtil.nvl((String) request.getParameter("st_HD_REMARK"),"") %></td>
							<th>구분&nbsp;</th>
							 <td><%=CommonUtil.nvl((String) request.getParameter("st_PROCESS_TEXT"),"") %>(<%=CommonUtil.nvl((String) request.getParameter("st_DOC_TEXT"),"") %>)</td>
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
 			<div class="ib_product" style="border-top:2px solid #3c639c;height:255px;">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "255px");
				</script>
			</div>
			 <p class="paging" id="pageindex"></p>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
							<font color="#006699">출고수량이 
			</font><b><font color="#FF0000">빨간색</font></b><font color="#006699">은 가용재고가 
			부족한 상태입니다.</font>
				<!--  <span class="btn_05 mr04"><a href="javascript:doAction('cart');">장바구니담기</a></span>-->
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">출고지시</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
