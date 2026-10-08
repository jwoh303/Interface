<%--
**********************************************
* 메뉴 : 재고 >조립부품 조회 
* 화면 : 조립부품서 조회
* 기능 : 조립지시서 생성 팝업
* 프로그램 ID : PG_08_M_015_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-2
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
	    			{Align : "Left",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,Hidden:false, Edit : false},
	    			{Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "ASSEMBLY_QTY",		Header : "*조립수량",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : true, Hidden : false,BackColor:"${notnullColor}" },
	    			{Align : "Right",SaveName : "ASSEMBLY_QTY_PRE",		Header : "조립수량전",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : true, Hidden : true,BackColor:"${notnullColor}" },
	    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "AVAIL_QTY",		Header : "재고수량",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Right",SaveName : "STC_SELLER_PRICE",		Header : "재고원가",Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
	    			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
	    			{Align : "Left",SaveName : "ORIGIN_CODE",		Header : "원산지",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	var initsheet2 = {};
	initsheet2.Cols = [  
	                   
		    			{Align : "Left",SaveName : "SUB_ID",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "DESCRIPTION_LOC",		Header : "품목명",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "ASSEMBLY_QTY",		Header : "작업수량",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "AVAIL_QTY",		Header : "재고수량",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "STC_SELLER_PRICE",		Header : "재고원가",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : true},
		    			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Left",SaveName : "ORIGIN_CODE",		Header : "원산지",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
		];	
	
	initsheet2.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
	var initsheet3 = {};
	initsheet3.Cols = [  
	                   
		    			{Align : "Left",SaveName : "SUB_ID",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 110,	Edit : false, Hidden : false},
		    			{Align : "Right",SaveName : "SUM_QTY",		Header : "재고수량",	Type : "Float", Format:"Integer",	Width : 100, EditLen : 110,	Edit : false, Hidden : false}
		];
	initsheet3.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet3, initsheet3,pagingMode);

	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblDirectionsCreationPop.do" , pagingMode );
	kepSearch(document.searchCondition ,  mySheet2 , "/wmst/getMasterWmStAssmblDirectionsCreationPop2.do" , pagingMode );
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStAssmblDirectionsCreationPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save":
			
			for(var k = 1 ; k<mySheet.GetTotalRows()+1 ; k++){
				if( eval(mySheet.GetCellValue(k,'ASSEMBLY_QTY'))==0  || eval(mySheet.GetCellValue(k,'ASSEMBLY_QTY')) =="" || eval(mySheet.GetCellValue(k,'ASSEMBLY_QTY'))<0){
					alert("조립수량은 0보다 큰 값이어야 합니다. ");
					mySheet.SelectCell(k, 'ASSEMBLY_QTY');
					return;
				}
			}
			
			
			if(mySheet2.GetTotalRows() >0){
				
				for(var i=1 ; i<mySheet2.GetTotalRows()+1;i++){
					

					var subAssemblyQty	= eval(mySheet2.GetCellValue(i,'ASSEMBLY_QTY'));
					var subStckQty			= eval(mySheet2.GetCellValue(i,'AVAIL_QTY'));
					if(subAssemblyQty > subStckQty){
						alert(mySheet2.GetCellValue(i,'SUB_ID')+" 품목이 \n\n재고 수량이 부족합니다\n\n부품수량 : "+subAssemblyQty+"  , 재고수량 : "+subStckQty);
						mySheet2.SelectCell(i, 'SUB_ID');
						return;
					}
					
				}
				if(!confirm("조립지시서를 생성 하시겠습니까?")){
					return;
				}
				kepSave(document.searchCondition ,  mySheet , "/wmst/saveMasterWmStAssmblDirectionsCreationPop.do" , "BUYER_ITEM_NO"  );
			}
			break;
	}

}



function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag){
	

	
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	if(column == "ASSEMBLY_QTY"){

		$('#st_bomid').val(mySheet.GetCellValue(Row, "BUYER_ITEM_NO"));
		document.searchCondition.st_bomid.value = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		kepSearch(document.searchCondition ,  mySheet3 , "/wmst/getMasterWmStAssmblDirectionsCreationPopChange.do" , pagingMode );
		grbRow = Row;

		
	}


}

function mySheet3_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	

	var asemb_qty = eval(mySheet.GetCellValue(grbRow, "ASSEMBLY_QTY"))  - eval(mySheet.GetCellValue(grbRow, "ASSEMBLY_QTY_PRE"));

	var sum_qty;
	for(var i = 1 ; i <mySheet2.GetTotalRows()+1 ; i++){

		for(var j=1 ; j<mySheet3.GetTotalRows()+1;j++){
			
			if(mySheet2.GetCellValue(i,"SUB_ID") ==mySheet3.GetCellValue(j,"SUB_ID")){
		
				sum_qty = eval(mySheet2.GetCellValue(i, 'ASSEMBLY_QTY') )+(eval(asemb_qty)*eval(mySheet3.GetCellValue(j,"SUM_QTY") ));
				//sum_qty = (eval(asemb_qty)*eval(mySheet3.GetCellValue(j,"SUM_QTY") ));
				mySheet2.SetCellValue(i, 'ASSEMBLY_QTY',sum_qty);
				
				if( eval(sum_qty)  >eval(mySheet2.GetCellValue(i, 'AVAIL_QTY'))){
					mySheet2.SetCellFontColor(i, 'ASSEMBLY_QTY', "#FF0000");
					mySheet2.SetCellFontBold(i, 'ASSEMBLY_QTY', 1);
				}
				else{
					mySheet2.SetCellFontColor(i, 'ASSEMBLY_QTY', "#000000");
					mySheet2.SetCellFontBold(i, 'ASSEMBLY_QTY', 0);
				}
			}
		}
		
		
	}
	mySheet.SetCellValue(grbRow, "ASSEMBLY_QTY_PRE", mySheet.GetCellValue(grbRow, "ASSEMBLY_QTY") );

}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){return;}	

	
	if (msg != "") {
		alert(msg);
	}

	
}


//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg) {
	loader_obj("N");
	//if(!checkedSession(stCode)){return;}
	
	if(code == 1){
		alert("조립지시서가 생성되었습니다");
		opener.doAction('search');
		window.close();
	}else{
		alert("조립지시서 생성중 오류가 발생했습니다");	
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "BUYER_NAME" ){ 
			kepConfirm();
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
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_sel_item_no"  name="st_sel_item_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_sel_item_no"),"") %>">	
	<input type="hidden" id="st_warehouse_code"  name="st_warehouse_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>">	
    <input type="hidden" name="st_assembly_type" value="ASS">	
     <input type="hidden" name="st_bomid" value="">	
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
        	<h1 class="title">조립 부품서 조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:498px">
        	<!--버튼영역-->
            <!--조회영역-->

            <h4><b>조립상품</b></h4>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:150px">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "150px");
				</script>
			</div>
			<br/>
            <h4><b>부품품목</b></h4>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:225px">
				<script type="text/javascript">
					createIBSheet("mySheet2", "", "225px");
				</script>
			</div>
			<br/>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c;height:225px;display:none;">
				<script type="text/javascript">
					createIBSheet("mySheet3", "", "225px");
				</script>
			</div>			
			        <!--버튼영역-->
			<span class="fr">
				<span class="btn_08 mr04"><a href="javascript:doAction('save')">조립지시서 생성</a></span>
			</span>
	
		</div>	
        
    </div>
</form> 
</body>
</html>
