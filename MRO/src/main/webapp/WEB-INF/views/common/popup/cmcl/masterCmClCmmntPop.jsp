<%--
**********************************************
* 메뉴 : 마감공통팝업
* 화면 : 적요 팝업
* 기능 : 
* 프로그램 ID : PG_10_M_006_01
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String editFlag		= request.getParameter("st_edit_flag");
	String tableName	= request.getParameter("st_table_name");
	String buyer		= request.getParameter("st_buyer");
	String taxBillNo	= request.getParameter("st_tax_bill_no");
	String site			= request.getParameter("st_site_type");
	String suppPrice			= request.getParameter("st_suppPrice");
	String taxPrice			= request.getParameter("st_taxPrice");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>세금 계산서 적요수정</title>
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
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",		SaveName:"sStatus"}
		,{ Align:"Center",	Width:146,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"항목번호",	SaveName:"ITEM_SEQ"}
		,{ Align:"left",		Width:146,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목",		SaveName:"REMARK_DESCRIPTION"}
		,{ Align:"left",	Width:166,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"규격",		SaveName:"REMARK_SPECIFICATION"}
		,{ Align:"right",	Width:50,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"수량",		SaveName:"REMARK_QTY"}
		,{ Align:"right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"단가",		SaveName:"REMARK_PRICE"}
		,{ Align:"right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"공급가액",	SaveName:"SUPP_PRICE"}
		,{ Align:"right",	Width:80,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"세액",		SaveName:"TAX_PRICE"}
		,{ Align:"left",	Width:140,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"비고",		SaveName:"REMARK"}
		
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClCmmntPop.do" , pagingMode );
}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClCmmntPop.do" , pagingMode );
			break;
		
		case "save": // 수정
			if ( !checkRow() )
				return;
			if ( !confirm('수정 하시겠습니까?') )
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClCmmntPop.do", -1 );
			break;
		case "amt": //공급가액 계산
			for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
				var qty = mySheet.GetCellValue(i, "REMARK_QTY");
				var price = mySheet.GetCellValue(i, "REMARK_PRICE");
				var item_prece = qty*price;
				if(qty != "" && price!= ""){
					mySheet.SetCellValue(i,"SUPP_PRICE",item_prece);
					mySheet.SetCellValue(i,"TAX_PRICE",Math.round(item_prece*0.1));
				}

			}
			break;
	}

}

// 변경 여부 체크
function checkRow() {
	var check = true;
	var ptotalSum = "<%=suppPrice%>";
	var ptotalTax =  "<%=taxPrice%>";
	var totalSum = 0;
	var totalTax = 0;
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		totalSum = totalSum+mySheet.GetCellValue(i, "SUPP_PRICE");
		totalTax = totalTax+mySheet.GetCellValue(i, "TAX_PRICE");
	}
	if(ptotalSum != totalSum){
		alert("공급가액 합계가 맞지 않습니다.");
		return false;		
	}
	if(ptotalTax != totalTax){
		alert("세액 합계가 맞지 않습니다.");
		return false;		
	}
	if ( check ) {
		alert("변경된 항목이 없습니다.");
		return false;
	}
	
	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var rowCnt = mySheet.RowCount();
	if(rowCnt ==0){
		for ( var i = 0; i <= 30; i++ ) {
			var rows = mySheet.DataInsert(-1);
			var ptotalSum = "<%=suppPrice%>";
			var ptotalTax =  "<%=taxPrice%>";
			mySheet.SetCellValue(rows, 'sStatus', 'R');
			if(i ==0){
				mySheet.SetCellValue(rows, 'REMARK_DESCRIPTION', 'MRO품목외');
				mySheet.SetCellValue(rows, 'SUPP_PRICE', ptotalSum);
				mySheet.SetCellValue(rows, 'TAX_PRICE', ptotalTax);
			}
		}
		mySheet.SetSelectRow(1);					
	}else{
		for ( var i = rowCnt + 1; i <= 100; i++ ) {
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, 'sStatus', 'R');
		}
		mySheet.SetSelectRow(1);		
	}
	if (msg != "") {
		alert(msg);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		opener.doAction("search");
		this.close();
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	
	grbRow = Row;
	
	return;
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=buyer%>">
	<input type="hidden" id="st_tax_bill_no" name="st_tax_bill_no"	value="<%=taxBillNo%>">
	<input type="hidden" id="st_site_type" name="st_site_type"	value="<%=site%>">
	<input type="hidden" id="st_table_name" name="st_table_name"	value="<%=tableName%>">
	
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">적요 팝업</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "180px");
				</script>
			</div>
		</div>	
    </div>
  		<div class="btnArea mr25">
			<span class="fr">
				<span class="btn_05 mr04"><a href="javascript:doAction('amt');">공급가액계산</a></span>
				<span class="btn_02"><a href="javascript:doAction('save');">수정</a></span>
			</span>
		</div>
</form> 
</body>
</html>
