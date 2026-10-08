<%--
**********************************************
* 메뉴 : 주문관리>재고관리>재고이동요청등록
* 화면 : 재고이동요청등록
* 기능 : 
* 프로그램 ID : PG_06_M_015_00
* 담당자 : 이수영 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();

var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
			 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
			,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
			,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Html",				Header:"품목코드",			SaveName:"STDCATLG_ID"}
			,{ Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목명",				SaveName:"DESCRIPTION"}
			,{ Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"규격",				SaveName:"SPECIFICATION"}
			,{ Align:"Right",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"재고수량",			SaveName:"AVAIL_QTY"}
			,{ Align:"Right",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"이동요청수량",		SaveName:"REQ_QTY",						KeyField:true,		BackColor:"${notnullColor}"}
			,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"요청자",				SaveName:"REQ_USER_NM"}
			,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동요청일",		SaveName:"REQ_DATE",					KeyField:true,		BackColor:"${notnullColor}"}
			,{ Align:"Left",		Width:500,	Edit:false,	EditLen:500,	Hidden:false,	Type:"Text",				Header:"비고",				SaveName:"MOVE_REMARK",									BackColor:"${optColor}"}
			,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"재고이동번호",		SaveName:"MOVE_NO"}
			,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"재고이동순번",		SaveName:"MOVE_SEQ"}
			,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"출발물류센터",		SaveName:"WAREHOUSE_CODE_FR"}
			,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"도착물류센터",		SaveName:"WAREHOUSE_CODE_TO"}
			,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"요청자",				SaveName:"REQ_USER_ID"}
			,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"이동요청시간",		SaveName:"REQ_TIME"}
			,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"품목코드",			SaveName:"STDCATLG"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	var initsheet2 = {};
	initsheet2.Cols = [ 
			 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",			SaveName:"sStatus"}
			,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",					SaveName:"SELECTED"}
			,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Html",				Header:"품목코드",		SaveName:"STDCATLG"}
			,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Number",			Header:"이동요청수량",	SaveName:"REQ_QTY"}
			,{ Align:"Center",		Width:500,	Edit:false,	EditLen:500,	Hidden:false,	Type:"Text",				Header:"비고",			SaveName:"MOVE_REMARK"}
	];
	
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_warehouse_code_fr','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseFrList','SEL','');		//출발물류센터
	kepAjaxCommonQueryIdSearchTwoCombo('st_warehouse_code_to','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseToList', '', '', 'SEL','');		//도착물류센터
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL',$("#st_user_id").val());		//요청자
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	if ((str =="save" || str =="del")  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if ($("#st_warehouse_code_fr").val() == "") {
				alert("출발물류센터를 선택해주십시요.");
				$("#st_warehouse_code_fr").focus();
				return;
			}
			if ($("#st_warehouse_code_to").val() == "") {
				alert("도착물류센터를 선택해주십시요.");
				$("#st_warehouse_code_to").focus();
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoStockMovemntRequestRegList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			mySheet.RemoveAll();
			break;
		case "addRow":	 // 조회
			var rows = mySheet.DataInsert(-1);
			var cmStatus =  "<a href=\"javascript:doPop('stdcatlgId');\"><img src='/resources/images/btn_search03.gif' /></a>";
			mySheet.SetCellValue(rows, "STDCATLG_ID",cmStatus);
			mySheet.SelectCell(rows, "STDCATLG_ID");
			mySheet.SetCellAlign(rows, "STDCATLG_ID", "Right");
			mySheet.SetCellEditable(rows, "REQ_QTY", 1);
			mySheet.SetCellEditable(rows, "REQ_DATE", 1);
			mySheet.SetCellEditable(rows, "MOVE_REMARK", 1);
			mySheet.SetCellValue(rows, "SELECTED", 1);
			break;
		case "delRow":
			for (var i=arrRow.length; i >= 0; i--) {
				if (mySheet.GetCellValue(arrRow[i], "sStatus") == "I") {
					mySheet.RowDelete(arrRow[i], 0);
				}
			}
			break;
		case "save": // 저장
			if (checkSubmit()) {
				kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoStockMovemntRequestRegList.do" , -1);
			}
			break;
		case "del": // 취소
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mpso/delMasterMpSoStockMovemntRequestRegList.do" , "SELECTED" );
			break;
		case "warehouseCode":
			mySheet.RemoveAll();
			kepAjaxCommonQueryIdSearchTwoCombo('st_warehouse_code_to','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseToList', $("#st_warehouse_code_fr").val(), '', 'SEL','');		//도착물류센터
			break;	
		case "loadExcel" : //  ExcelImport
			// 엑셀 업로드 조건 체크
			if ($("#st_warehouse_code_fr").val() == "") {
				alert("출발물류센터를 선택해주십시요.");
				$("#st_warehouse_code_fr").focus();
				return;
			}
			if ($("#st_warehouse_code_to").val() == "") {
				alert("도착물류센터를 선택해주십시요.");
				$("#st_warehouse_code_to").focus();
				return;
			}
			mySheet2.RemoveAll();
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"|1|2|3|4|"};
			mySheet2.LoadExcel(params);
			break;
		case "searchExcel" :
			kepSearch(document.searchCondition,  mySheet, "/mpso/getMasterMpSoStockMovemntRequestRegExcel.do" , pagingMode );
			break;
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "stdcatlgId":						// 대리점권보유품목
			if ($("#st_warehouse_code_fr").val() == "") {
				alert("출발물류센터를 선택해주십시요.");
				$("#st_warehouse_code_fr").focus();
				return;
			}
			openSearchPopup('/mpso/showMasterMpSoStockMovemntStdcatlgPop.do', '?st_warehouse_code_fr='+$("#st_warehouse_code_fr").val(), '700, 510,no');
			break;
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet2_OnLoadExcel() {
	var stdcatlg_id = "";

	for (var i = 1; i <= mySheet2.RowCount(); i++ ) {
		if (mySheet2.GetCellValue(i, "STDCATLG") != "") {
			stdcatlg_id += mySheet2.GetCellValue(i, "STDCATLG") + "@@";
		}
	}
	
	if (stdcatlg_id != "") {
		$("#st_stdcatlg_id").val(stdcatlg_id);
		doAction("searchExcel");
	} else {
		alert("Excel 업로드된 데이타가 없습니다.");
	}
}

function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1) {
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	for (var i = 1; i <= mySheet2.RowCount(); i++ ) {
		mySheet.SetCellValue(i, "REQ_QTY", mySheet2.GetCellValue(i, "REQ_QTY"));
		mySheet.SetCellValue(i, "MOVE_REMARK", mySheet2.GetCellValue(i, "MOVE_REMARK"));
		mySheet.SetCellEditable(i, "REQ_QTY", 1);
		mySheet.SetCellEditable(i, "REQ_DATE", 1);
		mySheet.SetCellEditable(i, "MOVE_REMARK", 1);
		mySheet.SetCellValue(i, "SELECTED", 1);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoStockMovemntRequestRegList.do?page="+current_page , pagingMode );
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


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4) {

	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "stdcatlgId") {	// 원산지
		var cmStatus =  "&nbsp;<a href=\"javascript:doPop('stdcatlgId');\"><img src='/resources/images/btn_search03.gif' /></a>";
		mySheet.SetCellValue(grbRow, 'STDCATLG', value1);
		mySheet.SetCellValue(grbRow, 'STDCATLG_ID', value1 + cmStatus);
		mySheet.SetCellValue(grbRow, 'DESCRIPTION', value2);
		mySheet.SetCellValue(grbRow, 'SPECIFICATION', value3);
		mySheet.SetCellValue(grbRow, 'AVAIL_QTY', value4);
		mySheet.SetCellAlign(grbRow, "STDCATLG_ID", "Right");
	}
	grbRow="";	//초기화
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
		alert("행추가된 항목이 없습니다.");
		return false;
	}
	return true;
}

function checkSubmit() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	if (!checkRow()) return false;
	
	if ($("#st_warehouse_code_fr").val() == "") {
		alert("출발물류센터를 선택해주십시요.");
		$("#st_warehouse_code_fr").focus();
		return false;
	}
	if ($("#st_warehouse_code_to").val() == "") {
		alert("도착물류센터를 선택해주십시요.");
		$("#st_warehouse_code_to").focus();
		return false;
	}
	
	for (var i = 0; i < arrRow.length; i++ ) {
		if (mySheet.GetCellValue(arrRow[i], "sStatus") != 'R' ) {
			if (kepTrimStr(mySheet.GetCellValue(arrRow[i], "STDCATLG_ID")) == "") {
				alert("품목코드를 선택해주세요.");
				mySheet.SelectCell(arrRow[i], "STDCATLG_ID");
				return false;
			}
	
			if (mySheet.GetCellValue(arrRow[i], "REQ_QTY") == "") {
				alert("이동요청수량을 입력해주세요.");
				mySheet.SelectCell(arrRow[i], "REQ_QTY");
				return false;
			}
			
			if (Number(mySheet.GetCellValue(arrRow[i], "AVAIL_QTY")) == 0) {
				alert("품목코드 " + mySheet.GetCellValue(arrRow[i], "STDCATLG") + "의 재고수량이 없습니다.");
				mySheet.SelectCell(arrRow[i], "REQ_QTY");
				return false;
			}
			
			if (mySheet.GetCellValue(arrRow[i], "REQ_QTY") >  mySheet.GetCellValue(arrRow[i], "AVAIL_QTY") ) {
				alert("품목코드 " + mySheet.GetCellValue(arrRow[i], "STDCATLG")  + "의 이동요청 수량은 재고수량보다 많을 수 없습니다.");
				mySheet.SelectCell(arrRow[i], "REQ_QTY");
				return false;
			}
			
			if (mySheet.GetCellValue(arrRow[i], "REQ_DATE") == "") {
				alert("품목코드 " + mySheet.GetCellValue(arrRow[i], "STDCATLG")  + "의 이동요청일을 선택해 주세요.");
				mySheet.SelectCell(arrRow[i], "REQ_DATE");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(arrRow[i], "MOVE_REMARK")) != "") {
				if (!fnCheckInputByteStr(mySheet.GetCellValue(arrRow[i], "MOVE_REMARK"), 500)) {
					alert("품목코드 " + mySheet.GetCellValue(arrRow[i], "STDCATLG")  + "의 비고는 영문 500자, 한글 200자 까지 입력할수 있습니다.");
					return false;
				}
			}
		}
	}
	
	var conf = confirm("재고이동 요청 등록을 저장하시겠습니까?");
	return conf;
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고이동요청등록</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition"  name="searchCondition" method="post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}" />
			<input type="hidden" name="st_stdcatlg_id" id="st_stdcatlg_id" value="" />
			
            	<table  class="cont_t_list01" >
					<caption>재고이동요청등록</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td><font color="red"><b>*</b></font> 출발물류센터</td>
							<td>
								<select id="st_warehouse_code_fr" name="st_warehouse_code_fr" style="width:80%;height:20px" onchange="doAction('warehouseCode');"></select>
							</td>
							<td><font color="red"><b>*</b></font> 도착물류센터</td>
							<td>
								<select id="st_warehouse_code_to" name="st_warehouse_code_to" style="width:80%;height:20px"></select>
							</td>
							<td>요청자</td>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:80%;height:20px"></select>
							</td>
						</tr>
						<tr>
							<td>요청일</td>
							<td colspan="5">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  					createIBSheet("mySheet2", "100%", "0px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('addRow');">행추가</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('delRow');">행삭제</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">EXCEL업로드</a></span>
  					<span class="btn_05 mr04"><a href="/resources/excel/work/WMS/masterMpSoStockMovemntRequestCreation.xls">양식다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  					<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
