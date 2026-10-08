<%--
**********************************************
* 메뉴 : 
* 화면 : 마감일 및 시간 선택
* 기능 : 납품요청일을 선택하기 위한 팝업
* 프로그램 ID : PG_07_M_002_02
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
	    			,{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 80,	EditLen : 50,Hidden:false} 
	    			,{Align : "Center",SaveName : "RD_DATE",		Header : "납품요청일",	Type : "Date",	Width : 160, EditLen : 110,	Edit : true, Hidden : false}
	    			,{Align : "Center",SaveName : "ITEM_QTY",		Header : "수량",	Type : "Float",  Format:"${qtyFormat}", Width : 135, EditLen : 110,	Edit : true, Hidden : false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
// 	setLinkCol(mySheet, "BUYER_NAME");
// 	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsClosingDateChoicePop.do" , pagingMode );

	var rows = mySheet.DataInsert(-1);
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsClosingDateChoicePop.do" , pagingMode );
			break;
		case "save": //등록
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");

			if (selectedGrid.length == 0){
				alert("선택하신 행이 없습니다.");
				return;
			}

			var value1 = "";
			var value2 = "";
			var value3 = 0;
			var totrow = arrRow.length;
			var tot_qty	= document.forms.searchCondition.st_tot_qty.value;
			var remain_qty = tot_qty;
			var rowno = 0;
			for(var idx=0; idx<totrow; idx++){
				var rd_date = mySheet.GetCellValue(arrRow[idx], "RD_DATE");
				var item_qty = mySheet.GetCellValue(arrRow[idx], "ITEM_QTY");

				rowno = idx+1;
				if(kepTrimStr(rd_date)=="") {
					alert("납품요청일을 선택하여 주십시오.["+ rowno +" 번째행]");
					return ;
				}
				if(kepTrimStr(item_qty)=="") {
					alert("요청 수량 선택하여 주십시오.["+rowno+" 번째행]");
					return ;
				}
				remain_qty = eval(remain_qty)-eval(item_qty);
				
				if(eval(tot_qty) !=0 && eval(remain_qty)<0) {
					alert("입력하신 수량이 발주수량을 초과하였습니다.");
					mySheet.SetCellValue(arrRow[idx], "ITEM_QTY", "");
					return ;
				}

				
				if(idx < totrow-1){
					value1 += rd_date +"@@" 
					value2 += item_qty +"@@" 
				}else{
					value1 += rd_date 
					value2 += item_qty 
				}
				value3 = eval(value3) + eval(item_qty);
			}
			
			if(eval(tot_qty) !=0 && eval(remain_qty)>0) { 
				alert("납품계획이 발주수량보다 부족하오니 입력 바랍니다.");
				return ;
			}
			
			 opener.setPopupReturn(value1,value2,value3);
			 this.close();
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	}

}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
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
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsClosingDateChoicePop.do?page="+current_page , pagingMode );
}

// TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
}

// 체크박스에서 선택된 ROW를 한꺼번에 삭제 (단, 모든 데이타를 한꺼번에 삭제할수는 없다.)
// 재귀함수
function checkedDel() {

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	if (mySheet.RowCount() == 0){
		alert("행이 없습니다.");
	}
	
	if (selectedGrid.length == 0){
		alert("선택하신 행이 없습니다.");
		return;
	}
	
// 	if (!confirm("선택되어 있는 행은 모두 삭제 됩니다.\n삭제하시겠습니까?")) {
// 		return;
// 	}

    var rows=  mySheet.RowCount();
  
	while (rows >= 0) {
		var chkedYn = mySheet.GetCellValue(rows,"SELECTED");
		if (chkedYn == "1") {
			mySheet.RowDelete(rows);
		}
		rows--;
	}
	//순번 재배열
	mySheet.ReNumberSeq();
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

function mySheet_OnAfterEdit(Row, Col) { 
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == "ITEM_QTY" ){ 
		
		var rowcnt=  mySheet.RowCount();
		var checked_sum_qty=0;
		var remain_qty;
		var totval = $("#st_tot_qty").val();
		
		for(var idx=1; idx<=rowcnt; idx++) {
			var item_qty = mySheet.GetCellValue(idx, "ITEM_QTY");
			
			if(eval(item_qty) < 0){
				alert("수량은 1이상부터 입력가능합니다.");
				mySheet.SetCellValue(idx, "ITEM_QTY", "");
				return;
			}
			
			if(isEmpty(item_qty)) {
				continue;
			}
			checked_sum_qty += eval(item_qty);
		}
		
		remain_qty = eval(totval)-eval(checked_sum_qty);
		
		if(eval(remain_qty)<0) {
			alert("입력하신 수량이 발주수량을 초과하였습니다.");
			mySheet.SetCellValue(Row, "ITEM_QTY", "");
			return ;
		}else {
			$("#st_remain_qty").val(remain_qty);
		}
	}
	return;
}


//확인
function kepConfirm()
{
	var value1="";
	var value2="";
	opener.setPopupReturn(value1,value2);
	this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	
	<div id="popWrapper" style="height:294px;">
    	<div id="popHeader">
        	<h1 class="title">납품일 및 수량 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "150px");
				</script>
			</div>
<!-- 			<div id="pageindex"></div> -->
<!--        		<div id="cont_searchA"> -->
			<c:if test="${param.ds_qty != '' && param.ds_qty ne null }">
	           	<table class="cont_t_list01" style="width:100%">
					<tr>
						<td>
							남은수량 : <input type="text" id="st_remain_qty" name="st_remain_qty"  value="${param.ds_qty}" readonly style="border-width:0px;text-align:left;" size="4">
							총수량 : ${param.ds_qty} 
							<input type="hidden" id="st_tot_qty"  name="st_tot_qty"  value="${param.ds_qty}" readonly>
						</td>
					</tr>
				</table>
			</c:if>
			<c:if test="${param.ds_qty == '' || param.ds_qty eq null }">
	           	<table class="cont_t_list01" style="width:100%">
					<tr>
						<td>
							<input type="hidden" name="st_remain_qty" value="0" >
							<input type="hidden" name="st_tot_qty" value="0" >
						</td>
					</tr>
				</table>
			</c:if>			
<!--            </div>     -->
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
				<span class="btn_02 mr04"><a href="javascript:checkedDel();">삭제</a></span>
				<span class="btn_02 "><a href="javascript:doAction('save')">등록</a></span> 
			</span>
       </div>
       
   
	</div>	
        
    </div>
</form> 
</body>
</html>
