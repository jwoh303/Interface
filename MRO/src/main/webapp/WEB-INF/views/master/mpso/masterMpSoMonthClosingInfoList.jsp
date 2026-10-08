<%--
**********************************************
* 메뉴 : 주문관리>월별마감정보조회
* 화면 : 월별마감정보조회
* 기능 : 입력한 기간동안의 마감내역을 조회한다
* 프로그램 ID : PG_06_M_010_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-19
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script>
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
					 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"주문번호",	SaveName:"PX_NO"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"단가",	SaveName:"AGENT_PRICE"}
					,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"발주수량",	SaveName:"PO_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"발주금액",	SaveName:"PO_AMT"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"납품총수량",	SaveName:"DELIVERY_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"납품금액",	SaveName:"DELIVERY_AMT"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"입고총수량",	SaveName:"GR_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"입고금액",	SaveName:"GR_AMT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품예정일",	SaveName:"DS_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"확정일",	SaveName:"DELIVERY_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사발주번호",	SaveName:"LEGACY_PO_NO"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사발주행번",	SaveName:"LEGACY_PO_SEQ"}
	];
 
	initsheet.Cfg = {FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");					//고객사
	setLinkCol(mySheet, "AGENT_NAME");					//협력사
	setLinkCol(mySheet, "PO_NO");							//발주번호
	setLinkCol(mySheet, "BUYER_ITEM_NO");				//품목코드
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	dateSetting();
	
// 	$("#st_from_date").val( kepToMonthAdd("1","M"));
// 	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}

function dateSetting() {
	// 일자 설정
	var tempDate = kepToMonthAdd("1", "M").replace(/[/]/gi, "");
	var tempYear = tempDate.substring(0, 4);
	var tempMonth = tempDate.substring(4, 6);
	var tempDay = lastDay(tempYear, tempMonth);

	$("#st_from_date").val(kepGetDateStr(tempYear + tempMonth + "01", "/"));
	$("#st_to_date").val(kepGetDateStr(tempDay, "/"));
}

//현재달의 마지막날(일자) 구하기
function lastDay(y, m) {
	var d2, s = "";
	var year, month, day;

	d2 = new Date(y, m, "");

	year = d2.getFullYear();
	month = (d2.getMonth() + 1);
	day = d2.getDate();

	if (month < 10) {
		month = "0" + month;
	}
	if (day < 10) {
		day = "0" + day;
	}

	s = year.toString() + month.toString() + day.toString();

	return (s);
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		if(isEmpty($("#st_buyer_code").val()) && isEmpty($("#st_agent_code").val())){
			alert("고객사 또는 협력사를 선택해 주십시요.");
			return;
		}
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
			alert("조회기간을 1개월 단위로 조회가 가능합니다.\n\n1개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoMonthClosingInfoList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
	
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/')); 
		
		kepEraser('st_buyer_code','st_buyer_name');
		kepEraser('st_agent_code','st_agent_name');
		
		break;
		
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"월별마감정보조회.xlsx",DownCols:"BUYER_NAME|AGENT_NAME|PX_NO|PO_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|AGENT_PRICE|UNIT_MEASURE|PO_QTY|PO_AMT|DELIVERY_QTY|DELIVERY_AMT|GR_QTY|GR_AMT|DS_DATE|DELIVERY_DATE|PO_CREATE_DATE|LEGACY_PO_NO|LEGACY_PO_SEQ|"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoMonthClosingInfoList.do", param);
		$("#pageflag").val('1');
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

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회 
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoMonthClosingInfoList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		case "agent_single": // 협력사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "agent_single";
			break;			
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
 
	if (column == 'BUYER_NAME') { // 고객사
		var ID = mySheet.GetCellValue(Row,"BUYER_CODE");
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+ID, "800,550,no");
	} else if (column == 'AGENT_NAME') { // 협력사
		var ID = mySheet.GetCellValue(Row,"AGENT_CODE");
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+ID, "800,550,no");
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var BUYER = mySheet.GetCellValue(Row,"BUYER_CODE");
		var BUYER_ITEM_NO = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var CONTRACT_NO = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var CONTRACT_SEQ = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		openSearchPopup("/common/catalogDetailPop.do", "?BUYER="+BUYER+"&BUYER_ITEM_NO="+BUYER_ITEM_NO+"&CONTRACT_NO="+CONTRACT_NO+"&CONTRACT_SEQ="+CONTRACT_SEQ, "800,290,no");
	} else if (column == 'PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER_CODE");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup("/common/mpso/poDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_print_flag=N", "900,550,no");
	}  

	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	if (popupSel == "buyer_single") {	// 구매회원사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);	
	} else if (popupSel == "agent_single") {	// 협력회원사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);	
	}

	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>월별마감정보조회</h3>
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
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" style="width:1024px;">
					<caption>월별마감정보조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="" />
						<col width="8%" />
						<col width="23%" />
						<col width="8%" />
                        <col width="23%" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>마감기준일</td>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
							</td>
							<td><font color="red"><b>*</b></font>고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td><font color="red"><b>*</b></font>협력사</td>
								<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:71%" value="" readonly onclick="javascript:doPop('agent_single');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">
								<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
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
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_05 mr04" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span> 
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
