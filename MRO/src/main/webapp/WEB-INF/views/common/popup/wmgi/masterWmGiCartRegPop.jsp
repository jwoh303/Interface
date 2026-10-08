<%--
**********************************************
* 메뉴 : wms ->출고 ->출고지시 및 거래 명세표 
* 화면 : 장바구니 담기
* 기능 : 발주번호 내 장바구니 담기
* 프로그램 ID : PG_08_M_006_02
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-7
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
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

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
	    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,Hidden:false}, 
	    			{Align : "Left",SaveName : "BUYER_ITEM_NO",		Header : "상품코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "COM_STCK_QTY",		Header : "*보충재고량",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : true, Hidden : false, BackColor:"${notnullColor}"},
	    			{Align : "Right",SaveName : "LIST_PRICE",		Header : "매입단가",	Type : "Float",     Format:"${priceFormat}",	Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "상품코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:true, Edit : false},
	    			{Align : "Left",SaveName : "AGENT_NAME",		Header : "협력사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "INCOME_PATH",		Header : "공급경로",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AVAIL_QTY",		Header : "가용재고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "MIN_ORDER_QTY",		Header : "최소발주량",	Type : "Float",  Format:"${qtyFormat}",Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "MAX_STOCK_QTY",		Header : "최대재고",	Type : "Float",  Format:"${qtyFormat}",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
	    			,{Align : "Center",SaveName : "CONTRACT_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true}
	    			,{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true}
	    			,{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true}
	    			,{Align : "Center",SaveName : "AGENT",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true}
	    			,{Align : "Center",SaveName : "PROCESS_TYPE",		Header : "",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false,Hidden:true}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,4);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "AGENT_NAME");
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiCartRegPop.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiCartRegPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "cart":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 		var checkCount = 0;
	 	 	if(selectedGrid.length == 0)
	 	 	{
	 	        alert(" 장바구니에 담을 제품을 선택 하세요.");
	 	        return;
	 	 	}
			for(var i = 0 ; i <arrRow.length; i++){
				if(eval(mySheet.GetCellValue(arrRow[i],'COM_STCK_QTY')) <=0){
					alert('수량을 0이나 음수로 지정 할 수 없습니다.');
					return;
				}
				checkCount++;
			}
			if(!confirm("장바구니에 담으시겠습니까?")){
				return;
			}else{
				kepSave(document.searchCondition ,  mySheet , "/wmgi/saveMasterWmGiCartRegPop.do" , "SELECTED" );
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

	
	if("" !=document.searchCondition.st_ST_CART_QTY_arr.value ){
		var st_ST_CART_QTY_a = (document.searchCondition.st_ST_CART_QTY_arr.value).split("@");
		var st_arr  ="";
		//COM_STCK_QTY 담기
		for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
		{	
			for(var j=0 ; j<st_ST_CART_QTY_a.length; j++){
				st_arr = st_ST_CART_QTY_a[j].split(",");
				if(mySheet.GetCellValue(i, "BUYER_ITEM_NO") == st_arr[0]){

					mySheet.SetCellValue(i,"COM_STCK_QTY",  eval(mySheet.GetCellValue(i, "COM_STCK_QTY")) +eval(st_arr[1]) );
				}
			}
			
		}
	}else{
		for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
		{	
			mySheet.SetCellValue(i,"COM_STCK_QTY",  0);
		}
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
	
	if(code =="1" )
	{
		//alert( msg.substring(2));  //PG_06_M_014_00이동  mpso/showMasterMpSoStockSuppleOrder.do
		if(confirm('장바구니에 저장되었습니다\n장바구니 화면으로 이동 하시겠습니까?')) {	
		//	javascript:tab("재고보충발주","mpso/showMasterMpSoStockSuppleOrder.do")
			MainTab.InsertItem("재고보충발주", "mpso/showMasterMpSoStockSuppleOrder.do");
			parent.window.close();
		}else{
			parent.window.close();
		}
	}else{
		alert(msg);
	}
}
//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgi/getMasterWmGiCartRegPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_ITEM_NO" ){ 
		if(mySheet.GetCellValue(Row,'BUYER_ITEM_NO')!=""){
			var BUYER_ITEM_NO = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
			var BYIT_COMORG_CODE =  document.searchCondition.st_warehouse_code.value;
			var CONTRACT_NO = mySheet.GetCellValue(Row, "CONTRACT_NO");
			var CONTRACT_SEQ = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
			//삭제됨
	
		}
	}else if(column == "AGENT_NAME"){
		
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!=""){
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code , "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
		
	}
	
	return;
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
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_USER_ID"  name="st_USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">		
	<input type="hidden" id="st_STDCATLG_ID_arr"  name="st_STDCATLG_ID_arr" value="<%=CommonUtil.nvl((String) request.getParameter("st_STDCATLG_ID_arr"),"") %>">	
		<input type="hidden" id="st_ST_CART_QTY_arr"  name="st_ST_CART_QTY_arr" value="<%=CommonUtil.nvl((String) request.getParameter("st_ST_CART_QTY_arr"),"") %>">			
	<div id="popWrapper" style="height:395px;">
    	<div id="popHeader">
        	<h1 class="title">장바구니 담기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <!--조회영역-->
        	
            
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
			<span class="fr">
				http://130.100.101.32:7900/
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
