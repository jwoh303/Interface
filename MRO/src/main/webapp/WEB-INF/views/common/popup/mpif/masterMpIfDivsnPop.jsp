<%--
**********************************************
* 메뉴 : 
* 화면 : 분할 팝업
* 기능 : 
* 프로그램 ID : PG_11_M_004_02
* 담당자 : 개발5 ( 설계 : 김상근 )
* 착수일 : 2014-
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String buyer = CommonUtil.nvl((String) request.getParameter("buyer"),"");							//  (조회조건)
String legacy_po_no = CommonUtil.nvl((String) request.getParameter("legacy_po_no"),"");		//  (조회조건)
String legacy_po_seq = CommonUtil.nvl((String) request.getParameter("legacy_po_seq"),"");	//  (조회조건)
String buyer_item_no = CommonUtil.nvl((String) request.getParameter("buyer_item_no"),"");	//  (조회조건)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
			{ Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",			SaveName:"sStatus"}
			,{ Align:"Center",	Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
			,{ Align:"Center",	Width:70,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"차수",			SaveName:"AGENT_SEQ"}
			,{ Align:"Right",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"수량",			SaveName:"ITEM_QTY"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"단가",			SaveName:"TARGET_PRICE"}
			,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"금액",			SaveName:"ITEM_AMT"}
			,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"납품유형",		SaveName:"PROCESS_TYPE"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"협력사",			SaveName:"AGENT_NAME"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"실협력사",		SaveName:"ORIGIN_AGENT_NAME"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실협력사",		SaveName:"ORIGIN_AGENT"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"AGENT"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"BUYER"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"PURCHASER_USER_DEPT"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"BYIT_COMORG_CODE"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"COMORG_LEVEL"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"CONTRACT_NO"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"실공급사",		SaveName:"CONTRACT_SEQ"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME");
	doAction("search");
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	if (str =="del"  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search":		//조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mpif/getMasterMpIfDivsnPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save":			// 저장
			if (checkSubmit()) {
				kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpIfDivsnPopList.do", -1 );
			}
			break;	
		case "del":			// 고객사별 담당자 삭제
			if (confirm("선택하신 항목을 삭제 하시겠습니까?")) {
				kepSave(document.searchCondition, mySheet, "/mpif/deleteMasterMpIfDivsnPopList.do", 1);
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
	if (msg != "") {
		alert(msg);
	}
	
	for (var i=mySheet.RowCount()+1; i <= 5; i++) {
		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, "AGENT_SEQ", i);
		mySheet.SetCellValue(rows, "ITEM_QTY", 0, 0);
		mySheet.SetCellValue(rows, "TARGET_PRICE", 0);
		mySheet.SetCellValue(rows, "ITEM_AMT", 0);
		mySheet.SetCellValue(rows, "sStatus", "R");
	}

	if (current_page==-1) {
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "agent": // 고객사 M
			openSearchPopup("/mpif/showMasterMpIfOrderStatusPop.do", "?GUBUN=divs&BUYER=" + $("#buyer").val() + "&BUYER_ITEM_NO=" + $("#buyer_item_no").val() + "&PURCHASER_USER_DEPT=" + $("#purchaser_user_dept").val() + "&BYIT_COMORG_CODE=" + $("#byit_comorg_code").val() + "&COMORG_LEVEL=" + $("#comorg_level").val(), "900,350,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(val1, val2, val3, val4, val5, val6, val7) {
	switch (popupSel) {
		case "agent":				// 취급가능품목
			var item_qty = mySheet.GetCellValue(grbRow, "ITEM_QTY");
		
			 if (item_qty != 0) {
		         mySheet.SetCellValue(grbRow, "ITEM_AMT", item_qty*val5);
		     }

			mySheet.SetCellValue(grbRow, "AGENT", val1);
			mySheet.SetCellValue(grbRow, "AGENT_NAME", val2);
			mySheet.SetCellValue(grbRow, "CONTRACT_NO", val3);
			mySheet.SetCellValue(grbRow, "CONTRACT_SEQ", val4);
			mySheet.SetCellValue(grbRow, "TARGET_PRICE", val5);
			mySheet.SetCellValue(grbRow, "PROCESS_TYPE", val6);
			mySheet.SetCellValue(grbRow, "ORIGIN_AGENT", val7);
			
			break;
	}
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpif/getMasterMpIfDivsnPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if (column == 'AGENT_NAME') { // 요청자
		doPop("agent");
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if (Row < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'ITEM_QTY') { // 요청자
		var temp_qty = 0;
		var item_qty = $("#item_qty").val();

		if (Value > item_qty || Value == 0) {
	        alert( Row + "번째 줄 수량에 1 이상 " + item_qty + " 이하의 숫자를 입력해 주십시요");
	        if (mySheet.CellSearchValue(Row, Col) == "") {
	        	mySheet.SetCellValue(Row, "ITEM_QTY", 0, 0);
	        	mySheet.SetCellValue(Row, "ITEM_AMT", 0, 0);
	        } else {
	        	mySheet.SetCellValue(Row, "ITEM_QTY", mySheet.CellSearchValue(Row, Col), 0);
	        	mySheet.SetCellValue(Row, "ITEM_AMT", mySheet.GetCellValue(Row, "ITEM_QTY") * mySheet.GetCellValue(Row, "TARGET_PRICE"), 0);
	        }
	        return;
	    }
		
		for (var i = 1; i <= mySheet.RowCount(); i++ ) {
			temp_qty +=  mySheet.GetCellValue(i, "ITEM_QTY");
		}

		if (temp_qty > item_qty) {
			alert("분할수량의 총 합이 발주수량을 초과하였습니다.\n\n확인 후 다시 입력해 주십시요");
			if (mySheet.CellSearchValue(Row, Col) == "") {
	        	mySheet.SetCellValue(Row, "ITEM_QTY", 0, 0);
	        	mySheet.SetCellValue(Row, "ITEM_AMT", 0, 0);
	        } else {
	        	mySheet.SetCellValue(Row, "ITEM_QTY", mySheet.CellSearchValue(Row, Col), 0);
	        	mySheet.SetCellValue(Row, "ITEM_AMT", mySheet.GetCellValue(Row, "ITEM_QTY") * mySheet.GetCellValue(Row, "TARGET_PRICE"), 0);
	        }
			 
			return;
		}
		
		mySheet.SetCellValue(Row, "ITEM_AMT", Value * mySheet.GetCellValue(Row, "TARGET_PRICE"));
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//변경 여부 체크
function checkRow() {
	var check = true;

	for (var i = 1; i <= mySheet.RowCount(); i++ ) {
		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	if (check) {
		alert("변경된 항목이 없습니다.");
		return false;
	}
	return true;
}

function checkSubmit() {
	if (!checkRow()) return false;
	
	for (var i = 1; i <= mySheet.RowCount(); i++ ) {

		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
			
			if (kepTrimStr(mySheet.GetCellValue(i, "ITEM_QTY")) == "") {
				alert(i + "번째 줄에 수량을 입력하여 주십시요");
				mySheet.SelectCell(i, "ITEM_QTY");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "AGENT")) == "") {
				alert(i + "줄에 공급사를 선택하여 주십시요");
				mySheet.SelectCell(i, "AGENT");
				return false;
			}
		}
	}
	
	var conf = confirm("변경된 항목을 저장 하시겠습니까?");
	return conf;
}

function popClose() {
	opener.setPopupReturn();
	self.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
	<input type="hidden" id="buyer"  name="buyer" value="<%=buyer%>" />
	<input type="hidden" id="legacy_po_no"  name="legacy_po_no" value="<%=legacy_po_no%>" />
	<input type="hidden" id="legacy_po_seq"  name="legacy_po_seq" value="<%=legacy_po_seq%>" />
	<input type="hidden" id="buyer_item_no"  name="buyer_item_no" value="<%=buyer_item_no%>" />
	<input type="hidden" id="item_qty"  name="item_qty" value='<%=CommonUtil.nvl(_rowData.get("ITEM_QTY"))%>' />
	<input type="hidden" id="purchaser_user_dept"  name="purchaser_user_dept" value='<%=CommonUtil.nvl(_rowData.get("PURCHASER_USER_DEPT"))%>' />
	<input type="hidden" id="byit_comorg_code"  name="byit_comorg_code" value='<%=CommonUtil.nvl(_rowData.get("BYIT_COMORG_CODE"))%>' />
	<input type="hidden" id="comorg_level"  name="comorg_level" value='<%=CommonUtil.nvl(_rowData.get("COMORG_LEVEL"))%>' />
	<input type="hidden" id="ref_if_no"  name="ref_if_no" value='<%=CommonUtil.nvl(_rowData.get("REF_IF_NO"))%>' />
	<input type="hidden" id="add_date"  name="add_date" value='<%=CommonUtil.nvl(_rowData.get("ADD_DATE"))%>' />
	<input type="hidden" id="rd_date"  name="rd_date" value='<%=CommonUtil.nvl(_rowData.get("RD_DATE"))%>' />
	
	<div id="popWrapper" style="height:420px;">
    	<div id="popHeader">
        	<h1 class="title">분할 팝업</h1>
            <p class="popClose"><a href="javascript:popClose()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div class="contArea" style="height:340px;" >
        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>LOG IN 정보</caption>
	                <colgroup>
	                    <col width="13%" />
	                    <col width="20%" />
	                    <col width="13%" />
	                    <col width="20%" />
	                    <col width="13%" />
	                    <col width="*" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">발주번호</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("LEGACY_PO_NO"))%></td>
	                        <th scope="row">발주행번</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("LEGACY_PO_SEQ"))%></td>
	                        <th scope="row">품목코드</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("BUYER_ITEM_NO"))%></td>
						</tr>
						<tr>
	                        <th scope="row">품명</th>
	                      	<td colspan="5"><%=CommonUtil.nvl(_rowData.get("DESCRIPTION_LOC"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">규격</th>
	                      	<td colspan="5"><%=CommonUtil.nvl(_rowData.get("SPECIFICATION"))%></td>
	                    </tr>
	                    <tr>
							<th scope="row">수량</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("ITEM_QTY"))%></td>
	                        <th scope="row">단위</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("UNIT_MEASURE"))%></td>
	                        <th scope="row">단가</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("UNIT_PRICE"))%></td>
						</tr>
						<tr>
	                        <th scope="row">비고</th>
	                      	<td colspan="5"><%=CommonUtil.nvl(_rowData.get("REMARK"))%></td>
	                    </tr>
					</tbody>
				</table>
            
				<!--grid-->
				<div class="mt20" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "133px");
					</script>
				</div>
				<div id="pageindex"></div>
			
			
			<!--버튼영역-->
			<div class="btnArea">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
				</span>
			</div>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
