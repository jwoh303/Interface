<%--
**********************************************
* 메뉴 : 납품관리>납기지연
* 화면 : 납기지연
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2020-06-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/kep_common.js"></script>

<script>
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {}; //화면용
	initsheet.Cols = [ 
		  { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사코드",		SaveName:"BUYER_CODE"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
		, { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
		, { Align:"Right",	Width:120,	Edit:false,	Hidden:false,	Type:"AutoSum",	Header:"수주미접수 건수",	SaveName:"DO_CNT"}
		, { Align:"Right",	Width:120,	Edit:false,	Hidden:false,	Type:"AutoSum",	Header:"납품예정일 건수",	SaveName:"DS_CNT"}
		, { Align:"Right",	Width:120,	Edit:false,	Hidden:false,	Type:"AutoSum",	Header:"표준납기일 건수",	SaveName:"IV_CNT"}
	];
	
	var initsheet2 = {}; //엑셀용
	initsheet2.Cols = [ 
		  { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사코드",		SaveName:"BUYER_CODE"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
		, { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT_CODE"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
		, { Align:"Right",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"수주미접수 건수",	SaveName:"DO_CNT"}
		, { Align:"Right",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"납품예정일 건수",	SaveName:"DS_CNT"}
		, { Align:"Right",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"표준납기일 건수",	SaveName:"IV_CNT"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME");	// 협력사
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M")); //default 1달
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	mySheet.SetSumValue(0,"- 합 계 -");
	mySheet.SetCellAlign(mySheet.LastRow(),0,"Center");
	mySheet.SetCellAlign(mySheet.LastRow(),4,"Right");
	mySheet.SetCellAlign(mySheet.LastRow(),5,"Right");
	mySheet.SetCellAlign(mySheet.LastRow(),6,"Right");
	mySheet.SetMergeCell (mySheet.LastRow(), 0, 1, 4);
	
}

// 기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if($("#st_buyer_code").val()==""){
				alert("고객사를 선택해 주십시요.");
				return;
			}
			if(kepGetDateDiff('st_from_date','st_to_date','D') > 93){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvDeliveryDelayList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			$("#st_buyer_code").val('');		
			$("#st_agent_code").val('');
			mySheet.RemoveAll();
			mySheet.SetSumValue(0,"- 합 계 -");
			break;
			
		case "excelDown": //엑셀 다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			if($("#st_buyer_code").val()==""){
				alert("고객사를 선택해 주십시요.");
				return;
			}
			if(kepGetDateDiff('st_from_date','st_to_date','D') > 93){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
			
			$("#pageflag").val('0');
			var param = {FileName:"납기지연리스트.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_CODE|BUYER_NAME|AGENT_CODE|AGENT_NAME|DO_CNT|DS_CNT|IV_CNT|"};
			kepDownExcel(document.searchCondition ,mySheet2 , "/mpiv/excelMasterMpIvDeliveryDelayList.do", param);
			$("#pageflag").val('1');
			break;
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
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
//엑셀다운로드 클릭 후 처리 
function mySheet2_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvDeliveryDelayList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer";
			break;
		case "seller": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());

	if (column == 'AGENT_NAME') { // 협력사 클릭 한 경우
		var com_code = mySheet.GetCellValue(Row,"AGENT_CODE");
		getAgentDisplayPop(com_code);
	} 
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer") {	// 구매회원사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);	
	} else if (popupSel == "seller") {	// 협력회원사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>납기 지연</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->			
            	<table  class="cont_t_list01" >
					<caption>납기 지연</caption>
					<colgroup>
							<col width="5%" />
							<col width="34%" />
							<col width="6%" />
							<col width="20%" />
							<col width="6%" />
							<col width="20%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>발주일</th>
							<td >
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:75px; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:75px; text-align:center;" >
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
								<input type="hidden" name="st_agent_code" id="st_agent_code"  style="width:80%value ="">
								<a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            <table style="width:100%;">
				<tr>
					<td align="left">
		           		<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		               	<label for="b_no02" class="hidden">정렬개수선택</label>
							<select name="onepagerow" style="width: 70px;" >
							<option value="10" selected>10건</option>
							<option value="20">20건</option>
							<option value="30">30건</option>
							<option value="40">40건</option>
							<option value="50">50건</option>
							<option value="200">200건</option>
						</select>
					</td>
				</tr>
			</table>
		</form>
					
		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<div style="display:none;">
			<script type="text/javascript">
				createIBSheet("mySheet2", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		
		<table style="width:100%;">
			<tr>
				<td height="25" align="left">
					*수주미접수 건수(D-2일) : 발주 생성일 기준 D-2일 수주미접수 건 (예 - 발주생성일이 6/24인 경우 6/26 수주미접수)
					<br>
					*납품예정일 건수(D-2일) : 납품 예정일 기준 D-2일 거래명세서 미작성 건 (예 - 납품예정일이 6/24인 경우 6/26 거래명세서 미작성)
					<br>
					*표준납기일 건수(D+3일) : 표준 납기일 기준 D+3일  수주미접수나 거래명세서 미작성 건 (예 - 표준납기일이 6/24인 경우 6/19 수주미접수나 거래명세서 미작성)
			    </td>
			    <td height="25" align = "right" valign="middle">
 			        <span class="btn_06"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			    </td>
			</tr>
		</table>
	
<!--내용 종료-->	                 

</body>
</html>
