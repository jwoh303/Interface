<%--
**********************************************
* 메뉴 : 
* 화면 : 요청번호 팝업
* 기능 : 
* 프로그램 ID : PG_11_M_007_01
* 담당자 : 손상민 ( 설계 : 김상근 )
* 착수일 : 2014-09-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
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
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> formData = new HashMap<String,String>();
	
	if (_gridList != null &&  _gridList.size() > 0){
		formData = (Map<String,String>)_gridList.get(0);
	}

%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var org_process_type = "";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false},
	    			{Align : "Center",SaveName : "DOC_TYPE_TEXT",		Header : "유형",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    		    {Align : "Center",SaveName : "DOC_TYPE",		Header : "거래유형타입",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "제품코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Center",SaveName : "REF_PR_NO",		Header : "관리번호",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    		    {Align : "Center",SaveName : "PROCESS_TYPE",		Header : "거래유형",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "PROCESS_TEXT",		Header : "거래유형",	Type : "Text",	Width : 70, EditLen : 110,	Edit : false, Hidden : false, FontColor:"${blueColor}", BackColor:"${optColor}"} ,
	    		    {Align : "Center",SaveName : "WAREHOUSE_CODE",		Header : "물류센터",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "WAREHOUSE_NAME",		Header : "물류센터",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false, FontColor:"${blueColor}", BackColor:"${optColor}"} ,			
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품명",	Type : "Text",	Width : 200, EditLen : 50,	Edit : true, Hidden : false, BackColor:"${optColor}", ToolTip:true} ,
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 150, EditLen : 250,	Edit : true, Hidden : false, BackColor:"${optColor}", ToolTip:true} ,
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 4,	Edit : true, Hidden : false, BackColor:"${optColor}"} ,
	    			{Align : "Center",SaveName : "PRICE_RATE",		Header : "단가율",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "CTL_TARGET_PRICE",		Header : "판매단가",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ITEM_AMT",		Header : "총금액",	Type : "Int",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},	    			
	    			{Align : "Right",SaveName : "TARGET_PRICE",		Header : "I/F매출",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "LIST_PRICE",		Header : "I/F매입",	Type : "Float",	Width : 100, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${optColor}"} ,
	    			{Align : "Right",SaveName : "LIST_PRICE_HIDDEN",		Header : "I/F매입",	Type : "Float",	Width : 100, EditLen : 110,	Edit : true, Hidden : true} ,
	    			{Align : "Right",SaveName : "TARGET_QTY",		Header : "수량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "RD_DATE",		Header : "납기요청일",	Type : "Date",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false,ToolTip:true},
	    			{Align : "Left",SaveName : "REQ_USER_NAME",		Header : "요청자",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true,ToolTip:true},
	    			{Align : "Left",SaveName : "REQ_USER_INFO",		Header : "요청자",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true,ToolTip:true},
	    		    {Align : "Left",SaveName : "REMARK",		Header : "비고",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false, ToolTip:true},
	    		    {Align : "Left",SaveName : "DELY_TO_LOCATION_TEXT",		Header : "도착지",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false, ToolTip:true},

	    		    {Align : "Center",SaveName : "A",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "DELY_TO_LOCATION",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "CUR",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "SELLER_ITEM_NO",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "SELLER",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "MAKER_NAME",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "PR_NO",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "PR_SEQ",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "LEGACY_PO_NO",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "LEGACY_PO_SEQ",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "REF_ADD_USER_ID",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "REQ_USER_ID",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "REQ_DEPT",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "AGENT",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "CONTRACT_NO",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "REMARK2",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "PRODUCT_CLOSE_FLAG",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "BUYER",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "REQ_USER_INFO",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "ADD_USER_TEL",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "CMS_CATLG_ID",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "CMS_CATEG_ID",		Header : "AA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    		    {Align : "Center",SaveName : "CTL_LIST_PRICE",		    Header : "AAA",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : true}
	    		    
	    ];

	initsheet.HeaderMode = { Sort : 0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

// 	//하이퍼링크 설정
 	setLinkCol(mySheet, "DOC_TYPE_TEXT");
	setLinkCol(mySheet, "PROCESS_TEXT");
 	setLinkCol(mySheet, "WAREHOUSE_NAME");
 	setLinkCol(mySheet, "AGENT_NAME");
 	
 	mySheet.SetCellFontUnderline(0,"DOC_TYPE_TEXT", true);
 	mySheet.SetCellFontUnderline(0,"PROCESS_TEXT", true);
 	mySheet.SetCellFontUnderline(0,"AGENT_NAME", true);
 	
	
	var buyer = "${st_buyer}";

	if( buyer == "KRKOLO0001" || buyer == "KRKOLO0002" || buyer == "KRKOLO0003" || buyer == "KRKOLO0011" || buyer == "KRKOLO0012" || buyer == "KRKOLO0013" ||
		buyer == "KRKOLO0015" || buyer == "KRKOLO0016" || buyer == "KRKTPI0001" || buyer == "KRKOLO0099" || buyer == "KRKOLO0107" || buyer == "KRKOLO0106" || 
		buyer == "KRKOLO0108" || buyer == "KRKOLO0111" || buyer == "KRKOLO0110" || buyer == "KRKOLO0109" || buyer == "KRKOLO0112" || buyer == "KRKTPI0002") {
		mySheet.SetColHidden("REQ_USER_NAME", true);
		mySheet.SetColHidden("REQ_USER_INFO", false);
	} else{
		mySheet.SetColHidden("REQ_USER_NAME", false);
		mySheet.SetColHidden("REQ_USER_INFO", true);				
		
	}
 	
	kepSearch(document.searchCondition ,  mySheet , "/mpif/getMasterMpIfRequestNoDetailPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
var g_approval_yn = "N";
function doAction(str) {
	st = new Date();
  	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
  	
	if ((str == 'save' || str == 'po' ) && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");return;
	}
  	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpif/getMasterMpIfRequestNoDetailPop.do" , pagingMode );
		
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "changeListPrice":
			var margin_rate = $("#st_margin").val();
			var target_price = "";
			var change_list_price = "";

			if (!kepIsNumberString(kepTrimStr(margin_rate))) {
				alert("단가는숫자만 입력 가능합니다.");
				$("#st_margin").val('');
				return;
			}

			var totrow = mySheet.RowCount();
			if( totrow<= 0) return;
	
			for(var idx=1; idx<=totrow; idx++){
				var agent = mySheet.GetCellValue(idx, "AGENT");
				if(agent !='KRSESI0003'){
					target_price = mySheet.GetCellValue(idx, "TARGET_PRICE");
					change_list_price = target_price * eval((100-margin_rate)/100);
					mySheet.SetCellValue(idx, "LIST_PRICE",change_list_price);
				}
			}
			break;
		case "save": //임시저장
			if(!chkFieldData(selectedGrid)){//필드값 체크
				return;
			}
			if(confirm("임시저장 하시겠습니까?")) {
				kepSave(document.searchCondition ,  mySheet , "/mpif/saveMasterMpIfRequestNoDetailPop.do" , "SELECTED" );
			}
			break;
		case "savePrice": //단가저장
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			var docuNo = $("#docu_status").val();
			if(docuNo != ""){
				alert("결재진행중 상태입니다.");
				return;
			}
			//선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert(" 변경 할 대상을 선택해 주십시요.");
				return;
			}
			for(var i=0; i<arrRow.length; i++){
				var selected = eval(mySheet.GetCellValue(arrRow[i],"SELECTED"));             //체크
				if(selected == "1"){
					var list_price = eval(mySheet.GetCellValue(arrRow[i],"LIST_PRICE"));             //매입단가
					var list_price_hidden = eval(mySheet.GetCellValue(arrRow[i],"LIST_PRICE_HIDDEN")); //히든맹비단가
					if(list_price == list_price_hidden){
						alert(i+1+"번째 단가 변경내역이 없습니다.");
						return;
					}
				}				
			}
			if(confirm("단가 임시저장 하시겠습니까?")) {
				g_approval_yn = "Y";
				kepSave(document.searchCondition ,  mySheet , "/mpif/savePriceMasterMpIfRequestNoDetailPop.do" , "SELECTED" );
			}
			break;		
		
		case "po": //구매발주
			var docuNo = $("#docu_status").val();
			if(docuNo != ""){
				alert("결재진행중 상태입니다.");
				return;
			}
			if(!chkFieldData(selectedGrid)){//필드값 체크
				return;
			}
			var buyer = $("#st_buyer_code").val();
			if(buyer != "KRKOLO0001" && buyer != "KRKOLO0002" && buyer != "KRKOLO0003" && buyer != "KRKOLO0035" && buyer != "KRKOLO0037"
				&& buyer != "KRKTPI0001" && buyer != "KRKOLO0011" && buyer != "KRKOLO0013" && buyer != "KRKOLO0015" && buyer != "KRKOLO0044" && buyer != "KRKOLO0118"
				&& buyer != "KRHWAS0031") {
					if(!chkPrice(selectedGrid)){ //단가 체크
						return;
					}
			} 
			if(chkProcessType(selectedGrid)){ //거래유형 체크직납 제외)
				if(confirm(" 구매발주 하시겠습니까?")) {
					kepSave(document.searchCondition ,  mySheet , "/mpif/poMasterMpIfRequestNoDetailPop.do" , "SELECTED" );
				}
			}
			
			break;
			
	}

}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "getCompanyDisplayPop": // 고객사 상세정보
			var ID = $("#st_buyer_code").val();
			openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+ID,'800,550,no');
			break;
	}
}


//거래유형 체크
function chkProcessType(selectedGrid){
	var rtn = true;
/*	
  	var arrRow     = selectedGrid.split("|");
	var totrow = arrRow.length;

    for(var idx=0; idx<totrow; idx++){
    	var process_type= mySheet.GetCellValue(arrRow[idx], "PROCESS_TYPE");
    	if(process_type != "0" && process_type != "2"){
    		alert("거래유형이 '직납' 또는 'TR' 의 경우에만 구매발주 가능합니다.");
          	rtn=false;
        }
    }
*/    
    return rtn;
}


function chkPrice(selectedGrid){
	var rtn = true;
  	var arrRow     = selectedGrid.split("|");
	var totrow = arrRow.length;
	
	//var list_price = Number(mySheet.GetCellValue(Row, "LIST_PRICE")); 
	//var list_price_hidden = Number(mySheet.GetCellValue(Row, "LIST_PRICE_HIDDEN")); 
	
    for(var idx=0; idx<totrow; idx++){
    	
    	var target_price      = mySheet.GetCellValue(arrRow[idx], "TARGET_PRICE");
    	var list_price        = mySheet.GetCellValue(arrRow[idx], "LIST_PRICE");
    	var ctl_target_price = mySheet.GetCellValue(arrRow[idx], "CTL_TARGET_PRICE");
    	var ctl_list_price = mySheet.GetCellValue(arrRow[idx], "CTL_LIST_PRICE");
    		
    	if(eval(ctl_target_price) == eval(target_price) && eval(list_price) == eval(ctl_list_price))
    	{
    		rtn = true;
    	}else{
    	
	    	if(eval(target_price) < eval(list_price)){
		       alert("역마진이므로 발주 내실 수 없습니다.");
		       rtn=false;
		    }
		    else if(eval(target_price) == eval(list_price)){
		       alert("노마진이므로 발주 내실 수 없습니다.");
		       rtn=false;
		    }
	    	
    	}

    }

    return rtn;
}

function chkFieldData(selectedGrid){
	var rtn = true;
  	var arrRow     = selectedGrid.split("|");
	var totrow = arrRow.length;
	var buyer = "${st_buyer}";
	
	for(var idx=0; idx<totrow; idx++){
        var description     = mySheet.GetCellValue(arrRow[idx], "DESCRIPTION");
        var specification   = mySheet.GetCellValue(arrRow[idx], "SPECIFICATION");
        var unit_measure    = mySheet.GetCellValue(arrRow[idx], "UNIT_MEASURE");
        var target_price    = mySheet.GetCellValue(arrRow[idx], "TARGET_PRICE");
        var list_price      = mySheet.GetCellValue(arrRow[idx], "LIST_PRICE");
        var target_qty      = mySheet.GetCellValue(arrRow[idx], "TARGET_QTY");
        var agent_name      = mySheet.GetCellValue(arrRow[idx], "AGENT_NAME");
		var process_type_cd      = mySheet.GetCellValue(arrRow[idx], "PROCESS_TYPE");
		var warehouse_code       = mySheet.GetCellValue(arrRow[idx], "WAREHOUSE_CODE");
		var warehouse_name       = mySheet.GetCellValue(arrRow[idx], "WAREHOUSE_NAME");
		var list_price        			= mySheet.GetCellValue(arrRow[idx], "LIST_PRICE");
		var list_price_hidden        = mySheet.GetCellValue(arrRow[idx], "LIST_PRICE_HIDDEN");
		var dely_to_loc        = mySheet.GetCellValue(arrRow[idx], "DELY_TO_LOCATION_TEXT");
		var dly_to_loc_pass_flag = "N";
		for(var jdx=0; jdx<totrow; jdx++){
			var dely_to_loc_2        = mySheet.GetCellValue(arrRow[jdx], "DELY_TO_LOCATION_TEXT");	
			if(dely_to_loc !=dely_to_loc_2 ){
				alert("도착지 정보가 다릅니다.");
				dly_to_loc_pass_flag ="Y";
		         return;
			}
		}
		if(dly_to_loc_pass_flag == "Y"){
	          rtn=false;			
		}
        if(isEmpty(description)){
          alert("품명이 입력되지 않았습니다."); 
          rtn=false;
        }
        if(isEmpty(specification)){
          alert("규격이 입력되지 않았습니다.");
          rtn=false;
        }
        if(isEmpty(unit_measure)){
          alert("단위가 입력되지 않았습니다.");
          rtn=false;
        }
		if(list_price != list_price_hidden){
			alert("매입단가가 변경되었습니다. \n단가저장 먼저 하세요.");
			return;
		}
        if(target_price == "0" || target_price == ""){
          alert("판매단가가 입력되지 않았습니다.");
          rtn=false;
        }
        if(list_price == "0" || list_price == ""){
          alert("매입단가가 입력되지 않았습니다.");
          rtn=false;
        }
        if(isEmpty(agent_name)){
          alert("공급사가 입력되지 않았습니다.");
          rtn=false;
        }
        if(target_qty == "0" || ( target_qty == null || target_qty == "" )){
          alert("수량이 입력되지 않았습니다.");
          rtn=false;
        }
        if( buyer != "KRKOLO0118" && target_qty < 0 ){
          alert("수량은 양수이어야 합니다.");
          rtn=false;
        }
    	if(process_type_cd != "0"){//거래유형이 직납이 아닐경우
			if(isEmpty(warehouse_code) || isEmpty(warehouse_name)){
				alert("물류센터를 지정해야 합니다.");
				rtn=false;
			}
		}		  
	}
	return rtn;
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if ( msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg.msg != "" && msg.usrmsg != "undefined" && msg.usrmsg != null ) {
		alert(msg.msg);
	}
	
	if (msg != ""&& msg != "undefined" && msg  != null  && msg != "[object Object]") {
		alert(msg);
	}
	//결재 팝업 호출
	if(code == 1 && g_approval_yn == "Y"){		
		g_approval_yn = "N";
		var type = "IF";
		var buyer_code	= $("#st_buyer_code").val();		
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+msg.usrmsg+'&PARAM1='+buyer_code, "1000,500,no");
	}else{
		g_approval_yn = "N";
	}	
	if(code>0){
		//저장 성공시 재조회
		//doAction('search');
		parent.opener.doAction('search');
		this.close();
	}
}

//그리드 셀 변경 이벤트
function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	if ( column == "LIST_PRICE" ) {
		var agent = mySheet.GetCellValue(Row, "AGENT"); 
		var list_price = Number(mySheet.GetCellValue(Row, "LIST_PRICE")); 
		var list_price_hidden = Number(mySheet.GetCellValue(Row, "LIST_PRICE_HIDDEN")); 
		var unit_price = Number(mySheet.GetCellValue(Row, "TARGET_PRICE"));
// 		alert(agent+"::"+list_price);
		
		if(agent == 'KRSESI0003' && list_price != list_price_hidden){
			alert('KWAY 유통 연계건은 매입단가 변경 할 수 없습니다.');
			mySheet.SetCellValue(Row, "LIST_PRICE", list_price_hidden);
			return;
		}
		if(!kepChkDecimal(list_price,2)){
	          alert("매입단가를 숫자로 입력하여 주시길 바랍니다.\n\n소수점 2자리까지 입력 할수 있습니다.");
	          mySheet.SetCellValue(Row, "LIST_PRICE", 0);
	          mySheet.SetCellValue(Row, "PRICE_RATE", 0);
	          return;
		}
        if(eval(list_price) <= 0) {
          alert("0 < 매입단가 < 1000000000");
          mySheet.SetCellValue(Row, "LIST_PRICE", list_price_hidden);
          return;
        }
		
		price_rate = (100-((eval(unit_price - list_price) / eval(unit_price))*100))/100;
// 		alert(price_rate);
		mySheet.SetCellValue(Row, "PRICE_RATE", kepGetRound(price_rate,3));
	}
	
}
	 



//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpif/getMasterMpIfRequestNoDetailPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	popupSel = column;	  
	
	if (column == "PROCESS_TEXT" || column == "WAREHOUSE_NAME"){ 
		org_process_type = mySheet.GetCellValue(Row,    "PROCESS_TYPE");  // 거래유형 코드
		openSearchPopup("/coco/getCommonCoCoGoodsDlvyClssifyPop.do",'' , "500,250,no"); 
			
	}else if(column == "AGENT_NAME"){
		openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N','500,466,no');
		
	}else if(column == "DOC_TYPE_TEXT"){
        var docTypeText = mySheet.GetCellValue(Row, "DOC_TYPE_TEXT");
		if(docTypeText == "선조치"){
          mySheet.SetCellValue(Row, "DOC_TYPE_TEXT", "일반");
          mySheet.SetCellValue(Row, "DOC_TYPE", "N");
        }else{
            mySheet.SetCellValue(Row, "DOC_TYPE_TEXT", "선조치");
            mySheet.SetCellValue(Row, "DOC_TYPE", "S");
        }
	}
	return;
}

//헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if ( checkRows.length == 0 ) {
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
	if( mySheet.ColSaveName(Col) == "DOC_TYPE_TEXT" ) { //유형
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "DOC_TYPE_TEXT", mySheet.GetCellValue(arrRow[0], "DOC_TYPE_TEXT"));
			mySheet.SetCellValue(arrRow[idx], "DOC_TYPE", mySheet.GetCellValue(arrRow[0], "DOC_TYPE"));
		}
	}else if ( mySheet.ColSaveName(Col) == "PROCESS_TEXT" ) { //거래유형
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			var processType = mySheet.GetCellValue(arrRow[0], "PROCESS_TYPE");
			mySheet.SetCellValue(arrRow[idx], "PROCESS_TEXT", mySheet.GetCellValue(arrRow[0], "PROCESS_TEXT"));
			mySheet.SetCellValue(arrRow[idx], "PROCESS_TYPE", processType);
			if(processType == "0"){
				mySheet.SetCellValue(arrRow[idx], "WAREHOUSE_NAME", '');
				mySheet.SetCellValue(arrRow[idx], "WAREHOUSE_CODE", '');
			}else{
				mySheet.SetCellValue(arrRow[idx], "WAREHOUSE_NAME", mySheet.GetCellValue(arrRow[0], "WAREHOUSE_NAME"));
				mySheet.SetCellValue(arrRow[idx], "WAREHOUSE_CODE", mySheet.GetCellValue(arrRow[0], "WAREHOUSE_CODE"));
				
			}
		}
		
	}else if(mySheet.ColSaveName(Col) == "AGENT_NAME"){
		for ( var idx=0; idx<arrRow.length; idx++ ) {
			mySheet.SetCellValue(arrRow[idx], "AGENT_NAME", mySheet.GetCellValue(arrRow[0], "AGENT_NAME"));
			mySheet.SetCellValue(arrRow[idx], "AGENT", mySheet.GetCellValue(arrRow[0], "AGENT"));
		}
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13,value14,value15,value16){
	 
	//팝업 조회후 해당 항목에 값을 셋팅
	 if (popupSel == "PROCESS_TEXT" || popupSel == "WAREHOUSE_NAME") {	// 거래유형선택 
		  
	     if((org_process_type == "2" || org_process_type == "0") && ( value1 == "1" ||  value1 == "3"))
	     {
	        alert("직납 또는 TR 발주건은 재고 또는 VMI로 변경 불가입니다.\n\n시스템운영팀으로 연락 바랍니다.(02-3016-8914)");
	        return;
	     }
	     if(org_process_type == "1" && value1 == "3")
	     {
	        alert("재고 상품을 VMI 상품으로 변경 불가입니다.\n\n시스템운영팀으로 연락 바랍니다.(02-3016-8914)");
	        return;
	     }
	     if(org_process_type == "3" && value1 == "1")
	     {
	        alert("VMI 상품을 재고 상품으로 변경 불가입니다.\n\n시스템운영팀으로 연락 바랍니다.(02-3016-8914)");
	        return;
	     }
	     if(org_process_type == "1" && value1 == "1")
	     {
	        alert("재고 상품을 재고 상품으로 변경 불가입니다.\n\n시스템운영팀으로 연락 바랍니다.(02-3016-8914)");
	        return;
	     }
		mySheet.SetCellValue(grbRow, 'PROCESS_TYPE', value1);
		mySheet.SetCellValue(grbRow, 'PROCESS_TEXT', value2); 
		
		if (value1 != "0"){  
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_CODE', value3);   
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_NAME', value4);   
		}else{
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_CODE', "");   
			mySheet.SetCellValue(grbRow, 'WAREHOUSE_NAME', "");   
		}
		
		
		mySheet.SetCellValue(grbRow, 'SELECTED', '1'); 
	}else if (popupSel == "AGENT_NAME"){
		mySheet.SetCellValue(grbRow, 'AGENT', value1);
		mySheet.SetCellValue(grbRow, 'AGENT_NAME', value2);
	} 
	
	grbRow="";	//초기화
}
	
//확인
function kepConfirm()
{ 
 	opener.setPopupReturn('','');
	 this.close();
}
function kepApprovalReturn(flag,docu_no){
	//결재상신시에 페이지 새로고침.
	location.reload();
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="${st_buyer}">
	<input type="hidden" id="st_pr_no"  name="st_pr_no" value="${st_pr_no}">

	
	<div id="popWrapper" style="height:410px;">
    	<div id="popHeader">
        	<h1 class="title">I/F 임시저장, 발주</h1>
            <p class="popClose"><a href="javascript:kepConfirm();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
<!--             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div> -->
            <!--조회영역-->
<!--         	<div id="cont_searchA"> -->
            	<table class="cont_t_list06" style="width:100%">
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="12%" />
						<col width="35%" />
					</colgroup>
					<tbody>
				        <tr>
				          <th>구매대행번호</th>
				          <td class="left" >${st_pr_no} &nbsp;<a class="hyperLink" href="javascript:doPop('getCompanyDisplayPop');">(${st_buyer_name})</a></td>
				          <th>결재번호</th>
				          <td><%=formData.get("DOCU_STATUS")%>
				          	<input type="hidden" name="docu_status" id="docu_status" value ="<%=formData.get("DOCU_STATUS")%>">
				          </td>
				        </tr>
				        <tr>
				          <th>제목</th>
				          <td><%=formData.get("PR_SUBJECT")%></td>
				          <th>발주일</th>
				          <td><%=CommonUtil.formatStrinigDate(formData.get("ADD_DATE"))%></td>
				        </tr>
				        <tr>
				          <th>발주자</th>
				          <td><%=formData.get("ADD_USER_NAME")%></td>
				          <th>발주부서</th>
				          <td><%=formData.get("ADD_USER_DEPT_TEXT")%></td>
				        </tr>
				        <tr>
				          <th>비고</th>
				          <td><%=formData.get("REMARK")%></td>
				          <th>물품합계</th>
				          <td><%=CommonUtil.formatNumber(formData.get("PRICE"),true,0,3)%></td>
				        </tr>
					</tbody>
				</table>
<!--             </div> -->
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
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "225px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fl">
<!-- 				<label>※ 상기내용을 수정하여도 카탈로그는 변경되지 않습니다.</label> -->
			</span>
			<span class="fr">			
				매익율&nbsp;<input type="text" id="st_margin" name="st_margin"  style="width:30px;text-align:right;vertical-align:middle;ime-mode:disabled;" >%
				<span class="btn_02 mr04"><a href="javascript:doAction('changeListPrice')">단가변경</a></span>&nbsp;&nbsp;&nbsp;
				<span class="btn_02 mr04"><a href="javascript:doAction('savePrice')">단가저장</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">임시저장</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('po')">구매발주</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
