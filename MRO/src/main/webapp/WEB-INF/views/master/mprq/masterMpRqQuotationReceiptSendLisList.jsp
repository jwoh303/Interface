<%--
**********************************************
* 메뉴 : 견적관리>업체선정 및 견적제출(두중)>견적접수및견적제출 목록
* 화면 : 견적접수및견적제출 목록
* 기능 : 두산중공업 전용 견적접수 및 견적제출을 위한 목록화면
* 프로그램 ID : PG_04_M_008_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-07-03
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
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
	initsheet.Cfg = {MergeSheet:msPrevColumnMerge + msHeaderOnly};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus",ColMerge:0}
							,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",	SaveName:"BUYER_NAME"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"QUOTATION_NO"}
							,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차수",	SaveName:"REVISION"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"접수건수",	SaveName:"BIDDING_COUNT"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",	SaveName:"QUOTATION_STATUS"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적순번",	SaveName:"QUOTATION_SEQ", Hidden:true, ColMerge:0}
							,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO", ColMerge:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적마감일",	SaveName:"ATOS_END_DATE",ColMerge:0}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"회신요청일",	SaveName:"BTOA_END_DATE",ColMerge:0}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"BTOA_END_FLAG",	SaveName:"BTOA_END_FLAG" , Hidden:true,ColMerge:0}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"ATOS_END_FLAG",	SaveName:"ATOS_END_FLAG" , Hidden:true,ColMerge:0}
							,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선정유무",	SaveName:"PICKED_UP_AGENT",ColMerge:0}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"KeP담당자",	SaveName:"KEP_USER_NAME",ColMerge:0}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"KEP_USER_ID",	SaveName:"KEP_USER_ID" , Hidden:true,ColMerge:0}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//SLOGIC-BEGIN(P04-4036) 두중일 경우
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserDooSanList','SEL','${sessionInfo.userId}');
	//SLOGIC-BEGIN(P04-4036)
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
	setLinkCol(mySheet, "KEP_USER_NAME");	//담당자
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("5","M"));
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	
	mySheet.SetDataAlternateBackColor("#FFFFFF"); 
	
	if ("${param.gubun}" == "search"){
		doAction('search');
	}
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
		current_page = -1;
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
			alert("조회기간을 6개월 단위로 조회가 가능합니다.\n\n6개월 이상의 데이타는 S/R 요청 바랍니다.");
			return;
		}
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqQuotationReceiptSendLisList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
	
		//SLOGIC-BEGIN(P04-4036) 두중일 경우
		//콤보데이터 셋팅		
		kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserDooSanList','SEL','${sessionInfo.userId}');
		//SLOGIC-END
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("5","M"));
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		
		$('#st_buyer_name').val("두산중공업(주)");
		$('#st_buyer_code').val("KRDOOD0001");
		mySheet.RemoveAll();
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
   	
	for(var i=1; i<=totRow;i++){
		if (mySheet.GetCellValue(i, "QUOTATION_STATUS") == "견적완료"){
			mySheet.SetCellFontColor(i,"QUOTATION_STATUS","#0000FF");
			mySheet.SetCellFontBold(i, "QUOTATION_STATUS",1);
		}
		if (mySheet.GetCellValue(i, "BTOA_END_FLAG") == "Y"){
			mySheet.SetCellFontColor(i,"BTOA_END_DATE","#FF0000");
		}
		if (mySheet.GetCellValue(i, "ATOS_END_FLAG") == "Y"){
			mySheet.SetCellFontColor(i,"ATOS_END_DATE","#0000FF");
		}
		if (mySheet.GetCellValue(i, "PICKED_UP_AGENT") == "선정"){
			mySheet.SetCellFontColor(i,"PICKED_UP_AGENT","green");
		}
	}
	
	if (msg != "") {
		alert(msg);
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationReceiptSendLisList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
	case "buyerMulti": // 고객사 M
		popupSel = "buyerMulti";
		openSearchPopup("/common/safetyCompanyCodePop.do",'?COM_TYPE=B',"880,450,no");
		break;
		case "masterMpRqBuyerQuotationReceiptSendCntPop": // 고객사 M
			popupSel = "masterMpRqBuyerQuotationReceiptSendCntPop";
			openSearchPopup("/mprq/showMasterMpRqBuyerQuotationReceiptSendCntPop.do",'?buyer_flag=1',"500,350,no"); // buyer_flag = 1(두중)
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'KEP_USER_NAME') { // 담당자
		var kep_user_id = mySheet.GetCellValue(Row,"KEP_USER_ID");
		openSearchPopup("/common/kepManagerPop.do", '?st_user_id='+kep_user_id, "430,194,no");
		

	}else if (column == "QUOTATION_NO" ){ 
		
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var revision = mySheet.GetCellValue(Row, "REVISION");

		location.href = '/mprq/showMasterMpRqQuotationReceiptSend.do?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_revision='+revision;

	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMulti") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	} else if (popupSel == "masterMpRqBuyerQuotationReceiptSendCntPop") {	// 고객사 견적접수 및 제출 건수
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>업체선정 및 견적제출(두중)</h3>
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
			
            	<table  class="cont_t_list01" >
					<caption>업체선정 및 견적제출(두중)</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
	                    <col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>회신요청일</th>
							<td colspan="3">
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span>							
							</td>
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="두산중공업(주)" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" required="고객사" value="KRDOOD0001">
								<a href="javascript:doPop('masterMpRqBuyerQuotationReceiptSendCntPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
						<tr> 
							<th>상태</th>
							<td>
								<select id="st_status" name="st_status" style="width:90%;height:20px;" >
									<option value="" selected>전체</option>
									<option value="견적미완료">견적미완료</option>
									<option value="견적완료">견적완료</option>
								</select>
							</td>
							<th>담당자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px;" ></select>
							</td>
							<th>견적번호</th>
							<td>
								<input type="text" id="st_quotation_no" name="st_quotation_no" style="width:87%;" value="" onkeyup="kepToUpper('st_quotation_no')" onkeydown="kepEnter()">
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10">10건</option>
					<option value="20" selected>20건</option>
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
  			
<!--내용 종료-->	                 

</body>
</html>
