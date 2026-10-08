<%--
**********************************************
* 메뉴 : 재고>재고이동>재고이동입고
* 화면 : 재고이동입고
* 기능 : 
* 프로그램 ID : PG_08_M_030_00
* 담당자 : 이수영 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
// 공통
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String _warehouseCode = "";

if (_gridList != null) {
	Map<String,String> _rowData = _gridList.get(0);
	_warehouseCode = _rowData.get("WAREHOUSE_CODE");	
}

String _whAdmin = _sessionInfo.getWhAdmin();
%> 
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
				{ Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",					SaveName:"sStatus"}
				,{ Align:"Center",	Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",							SaveName:"SELECTED"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"재고이동요청번호",	SaveName:"MOVE_NO"}
				,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"재고이동요청순번",	SaveName:"MOVE_SEQ"}
				,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"출발물류센터",			SaveName:"WAREHOUSE_CODE_FR"}
				,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"도착물류센터",			SaveName:"WAREHOUSE_CODE_TO"}
				,{ Align:"Left",	Width:210,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"출발물류센터",			SaveName:"WAREHOUSE_CODE_FR_TEXT"}
				,{ Align:"Left",	Width:210,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"도착물류센터",			SaveName:"WAREHOUSE_CODE_TO_TEXT"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목코드",				SaveName:"STDCATLG_ID"}
				,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목명",					SaveName:"DESCRIPTION"}
				,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"규격",					SaveName:"SPECIFICATION"}
				,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"이동요청수량",			SaveName:"REQ_QTY"}
				,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"재고수량",				SaveName:"AVAIL_QTY"}
				,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"출고수량",				SaveName:"INV_QTY"}
				,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"입고수량",				SaveName:"GR_QTY"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동요청일자",			SaveName:"REQ_DATE"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동요청자",			SaveName:"REQ_USER_NM"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동출고일자",			SaveName:"INV_DATE"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동출고시간",			SaveName:"INV_TIME"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동출고자",			SaveName:"INV_USER_NM"}
				,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동입고일자",			SaveName:"GR_DATE",										KeyField:true,		BackColor:"${notnullColor}"}
				,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"비고",					SaveName:"MOVE_REMARK"}
				,{ Align:"Left",	Width:300,	Edit:true,	EditLen:500,	Hidden:true,	Type:"Text",				Header:"비고",					SaveName:"CONTRACT_NO"}
				,{ Align:"Left",	Width:300,	Edit:true,	EditLen:500,	Hidden:true,	Type:"Text",				Header:"비고",					SaveName:"CONTRACT_SEQ"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	setLinkCol(mySheet, "STDCATLG_ID");
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_warehouse_code_to','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseToList','ALL','<%=_warehouseCode%>');								//도착물류센터
	kepAjaxCommonQueryIdSearchTwoCombo('st_warehouse_code_fr','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseFrList', '<%=_warehouseCode%>', '', 'ALL','');				//출발물류센터
	
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
	if ( "<%=_whAdmin%>" != "A" && "<%=_warehouseCode%>" == "") {
		alert("조회 권한이 없습니다.\n관리자에게 문의 바랍니다.");
		return;
	}

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str != "warehouseCode" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val());
			if(kepGetDateDiff("st_to_date" ,"st_from_date" ,'M' ) +3 < 0 ){
				alert('조회는 3개월 이내만 가능 합니다.');
				return ;
			} 			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/wmst/getMasterWmStStockMovemntWarhsngList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
				mySheet.RemoveAll();
			break;
		
		case "save": // 저장
			if (!checkSubmit())
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmst/saveMasterWmStStockMovemntWarhsngList.do" , "SELECTED" );
			break;
		
		case "warehouseCode":
			kepAjaxCommonQueryIdSearchTwoCombo('st_warehouse_code_to','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseToList', $("#st_warehouse_code_fr").val(), '', 'SEL','');		//도착물류센터
			break;		
		
		case "del": // 취소
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/wmst/delMasterWmStStockMovemntWarhsngList.do" , "SELECTED" );
			break;
			
		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
		    var param = {FileName:"재고이동입고.xlsx",Merge:1,SheetDesign:1,DownCols:"WAREHOUSE_CODE_FR_TEXT|WAREHOUSE_CODE_TO_TEXT|STDCATLG_ID|DESCRIPTION|SPECIFICATION|REQ_QTY|AVAIL_QTY|INV_QTY|GR_QTY|REQ_DATE|REQ_USER_NM|INV_DATE|INV_TIME|INV_USER_NM|GR_DATE|MOVE_REMARK"};
			kepDownExcel(document.searchCondition, mySheet, "/wmst/excelMasterWmStStockMovemntWarhsngList.do", param);
			$("#pageflag").val('1');
			break;
	}
}

function doPop(str, val1, val2, val3, val4) {
	switch (str) {
		case "stdcatlg":
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+val1+'&BYIT_COMORG_CODE='+val2+'&CONTRACT_NO='+val3+'&CONTRACT_SEQ='+val4, "800,255,no");
			break;
	}	
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
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
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'STDCATLG_ID') {
		doPop("stdcatlg", mySheet.GetCellValue(grbRow,"STDCATLG_ID"), mySheet.GetCellValue(grbRow,"WAREHOUSE_CODE_FR"), mySheet.GetCellValue(grbRow,"CONTRACT_NO"), mySheet.GetCellValue(grbRow,"CONTRACT_SEQ"));
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStStockMovemntWarhsngList.do?page="+current_page , pagingMode );
}

function checkSubmit() {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	for (var i=0; i < arrRow.length; i++) {
		
		if (kepTrimStr(mySheet.GetCellValue(arrRow[i], "GR_DATE")) == "") {
			alert("품목코드 " + mySheet.GetCellValue(arrRow[i], "STDCATLG_ID") + "의 이동입고일자를 선택해주세요.");
			return false;
		}
	}
	
	return confirm('선택한 항목을 입고확정 하시겠습니까?');
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고이동입고</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}" />
			<input type="hidden" name="st_warehouse_code" id="st_warehouse_code" value="<%=_warehouseCode%>" />
			
            	<table  class="cont_t_list01" >
					<caption>재고이동입고</caption>
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
							<td>이동출고일</td>
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
						<tr>
							<td>출발물류센터</td>
							<td>
								<select id="st_warehouse_code_fr" name="st_warehouse_code_fr" style="width:80%;height:20px"></select>
							</td>
							<td>도착물류센터</td>
							<td>
								<select id="st_warehouse_code_to" name="st_warehouse_code_to" style="width:80%;height:20px" <%=_whAdmin.equals("Y") ? "" : "disabled"%>></select>
							</td>
							<td>재고이동번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_move_no" name="st_move_no" style="width:80%;" value="" onkeyup="kepToUpper('st_move_no')" onkeydown="kepEnter()" />
							</td>
						</tr>
						<tr> 
							<td>품목코드</td>
							<td>
								<input type="text" class="input_type_text" id="st_stdcatlg_id" name="st_stdcatlg_id" style="width:80%;" value="" onkeyup="kepToUpper('st_stdcatlg_id')" onkeydown="kepEnter()" />
							</td>
							<td>품목명</td>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:80%;" value="" onkeydown="kepEnter()" />
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
  					createIBSheet("mySheet", "100%", "334px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
			<div class="btnArea">
				<span class="fl">
					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
				</span>
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">입고확정</a></span>
  				</span>
  			</div>
<!--내용 종료-->	                 

</body>
</html>
