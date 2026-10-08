<%--
**********************************************
* 메뉴 : 견적관리>벌크소싱 프로젝트 관리
* 화면 : 벌크소싱 프로젝트 관리
* 기능 : 벌크소싱 프로젝트 등록/조회/수정화면
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2025-06-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%String st_user_dept = _sessionInfo.getDepartment();
String st_user_id = _sessionInfo.getUserId(); // 삭제
%>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.HeaderMode = {			Sort : 1,			ColMove : 1,			ColResize : 1		};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:60,	Edit:false,	Hidden:true,	Type:"Status",		Header:"상태|상태",			SaveName:"sStatus"}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",		Header:"프로젝트코드|프로젝트코드",SaveName:"PROJECT_STATUS_CODE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:40,	Edit:true,	Hidden:false,	Type:"Radio",		Header:" | ",				SaveName:"SELECTED",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",		Header:"등록일|등록일",			SaveName:"ADD_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",		Header:"시작일|시작일",			SaveName:"PROJECT_START_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",		Header:"종료일|종료일",			SaveName:"PROJECT_END_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",		Header:"유형|유형",			SaveName:"PROJECT_TYPE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",		Header:"프로젝트코드|프로젝트코드",SaveName:"BURQ_NO",ColMerge:0,Sort:1}
		,{ Align:"Left",	Width:300,	Edit:false,	Hidden:false,	Type:"Text",		Header:"프로젝트명|프로젝트명",	SaveName:"PROJECT_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:110,	Edit:false,	Hidden:false,	Type:"Text",		Header:"사업부서|사업부서",	SaveName:"KEP_DEPT",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:110,	Edit:false,	Hidden:false,	Type:"Float",		Header:"품목|품목",			SaveName:"TOTAL_ITEM_CNT",ColMerge:0,Sort:1}
		,{ Align:"Right",	Width:110,	Edit:false,	Hidden:false,	Type:"Float",		Header:"총금액|총금액",			SaveName:"TOTAL_AMT",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:66,	Edit:false,	Hidden:false,	Type:"Text",		Header:"PM|PM",				SaveName:"PM_NAME",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",		Header:"프로젝트 진행 현황|상태",	SaveName:"PROJECT_STATUS",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"프로젝트 진행 현황|SG분류 개시",	SaveName:"SG_START_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"프로젝트 진행 현황|소싱 개시",	SaveName:"RFQ_START_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"프로젝트 진행 현황|견적 마감",	SaveName:"RFQ_END_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"프로젝트 진행 현황|취합 완료",	SaveName:"RFQ_MERGE_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"프로젝트 진행 현황|사업팀 제출",	SaveName:"RFQ_SUBMIT_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Date",		Header:"프로젝트 진행 현황|품의 완료",	SaveName:"RFQ_APPROVAL_DATE",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Date",		Header:"프로젝트 진행 현황|SG분류 개시",	SaveName:"SG_START_DATE_SCHD",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Date",		Header:"프로젝트 진행 현황|소싱 개시",	SaveName:"RFQ_START_DATE_SCHD",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Date",		Header:"프로젝트 진행 현황|견적 마감",	SaveName:"RFQ_END_DATE_SCHD",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Date",		Header:"프로젝트 진행 현황|취합 완료",	SaveName:"RFQ_MERGE_DATE_SCHD",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Date",		Header:"프로젝트 진행 현황|사업팀 제출",	SaveName:"RFQ_SUBMIT_DATE_SCHD",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Date",		Header:"프로젝트 진행 현황|품의 완료",	SaveName:"RFQ_APPROVAL_DATE_SCHD",ColMerge:0,Sort:1}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode,5);

	mySheet.SetCountPosition(3);
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");
	
	//콤보데이터 셋팅		
	// 프로젝트 유형 콤보데이터
	kepAjaxCommonTotalCombo('st_project_type', 'BURQ01', 'ALL','','','');
// 	다중선택콤보(공통) - 생성
	kepAjaxCommonTotalMultiCombo('st_kep_dept', 'BURQ06', 'ALL', '');
	kepAjaxCommonTotalMultiCombo('st_project_status', 'BURQ02', 'ALL', '');

	//하이퍼링크 설정
	setLinkCol(mySheet, "BURQ_NO");	//프로젝트 코드
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	
	doAction('search');

}
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");	

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 372 ){
				alert("조회기간은 12개월까지 조회가 가능합니다.\n\n12개월 이상의 데이터는 S/R 요청 바랍니다.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBulkQuotationProjectList.do", pagingMode);
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			
			mySheet.RemoveAll();

			// 다중선택콤보(공통) - 초기화
			init_multiCombo("st_kep_dept");
			init_multiCombo("st_project_status");
			
			$("#st_from_date").val(kepToDateAdd("7","M"));
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
			$('#st_project_status').val('');
			$('#st_kep_dept').val('');
			break;
		case "new": // 신규 등록
			doPop("new");
			break;
			
		case "excelDown": // 조회결과 다운로드
			//엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 372 ){
				alert("조회기간은 12개월까지 조회가 가능합니다.\n\n12개월 이상의 데이터는 S/R 요청 바랍니다.");
				return;
			}

		    $("#pageflag").val('0');
		    
			var cols = "";
		    var param = {FileName:"벌크소싱프로젝트관리_"+$("#st_from_date").val() + "_" + $("#st_to_date").val()+".xlsx", HiddenColumn:1 ,Merge:1,SheetDesign:1,DownCols:""}; 
			kepDownExcel(document.searchCondition ,mySheet , "/mprq/excelMasterMpRqBulkQuotationProjectList.do", param);
// 			mySheet.Down2Excel(param);
			$("#pageflag").val('1');
			break;
		case "finish": // 프로젝트 중단

			if (mySheet.RowCount() == 0){
				alert("조회된 데이터가 없습니다.");
				return;
			}

		if (isEmpty(arrRow[0])){
				alert("선택하신 프로젝트가 없습니다.");
				return;
			}
			
			if('G' == mySheet.GetCellValue(arrRow[0], "PROJECT_STATUS_CODE")){
				alert("이미 중단된 프로젝트입니다.");
				return;
			}
			
			if(!confirm("프로젝트 중단 시 모든 작업이 중단됩니다.\n정말로 중단하시겠습니까?")){
				return;
			};
			
			doPop("finish");
			
			break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}

	const std_arr = ['SG_START_DATE','RFQ_START_DATE','RFQ_END_DATE','RFQ_MERGE_DATE','RFQ_SUBMIT_DATE','RFQ_APPROVAL_DATE'];
	
	var maxRow = mySheet.RowCount();
	for(var i = 2; i < maxRow+2; i++){
		for(var arr_idx = 0; arr_idx < std_arr.length; arr_idx++){
			var date = mySheet.GetCellValue(i,std_arr[arr_idx]);
			var cur_date = kepGetNowTimeStr("YYYYMMDD","");
			var status = mySheet.GetCellValue(i,"PROJECT_STATUS");
			
			if(!isEmpty(date)){
				if(status == "중단"){
					mySheet.SetCellBackColor(i,std_arr[arr_idx],"#A6A6A6");
				}else if(date < cur_date){
					mySheet.SetCellBackColor(i,std_arr[arr_idx],"#FFD966");
				}else{
					mySheet.SetCellBackColor(i,std_arr[arr_idx],"#92D050");
				}
				
			}
		}
	}
}
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'BURQ_NO') { // BURQ 번호
		var st_burq_no = mySheet.GetCellValue(Row,"BURQ_NO");
		popupSel = "masterMpRqBulkQuotationDetailPop";
		openSearchPopup('/mprq/getMasterMpRqBulkQuotationDetailPop.do', '?st_burq_no='+st_burq_no, "800,800,no"); // 프로젝트 조회 및 수정
	}
	return;
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "new": // 신규 프로젝트 등록
			openSearchPopup('/mprq/showMasterMpRqBulkQuotationNewProjectPop.do','',"810,830,no");
			break;
		case "finish": // 프로젝트 중단
			var i = mySheet.FindCheckedRow("SELECTED");
			var burq_no = mySheet.GetCellValue(i, "BURQ_NO");

			openSearchPopup('/mprq/showMasterMpRqBulkQuotationAbortReasonPop.do','?burq_no='+burq_no,"600,130,no");
			break;
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel=="finish" || popupSel=="new" || popupSel == "masterMpRqBulkQuotationDetailPop"){
		if(value1 == "1"){
			doAction('search');
		}
	}
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA" >
			<h3>벌크소싱 프로젝트 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
		<!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
				<input type="hidden" name="s_SAVENAME">
            	<table  class="cont_t_list01" >
					<caption>벌크소싱 프로젝트 관리</caption>
					<colgroup>
						<col width="12%" />
						<col width="40%" />
						<col width="8%" />
						<col width="21%" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr class="center">
							<th>
								<label for="b_code" class="hidden">기간선택</label>
						  			<select name = "st_date_type" id="st_date_type" class="TitSelect" style="height:20px;">
							      		<option value="ADD" selected="selected">등록일</option>
										<option value="OPEN">시작일</option>
										<option value="CLOSE">종료일</option>
		                           </select>
							</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','12')">12개월</a></span>
							</td>
							<th class="center">프로젝트 유형</th>
							<td>
								<select id="st_project_type" name="st_project_type" style="width:200px;height:25px">
								</select>
							</td>
						</tr>
						<tr class="center"> 
							<th>
								<label for="b_code" class="hidden">프로젝트 정보 선택</label>
						  			<select name = "st_project_info" id="st_project_info" class="TitSelect" style="height:20px;">
							      		<option value="NAME" selected="selected">프로젝트 명</option>
										<option value="CODE">프로젝트 코드</option>
		                           </select>
		                    </th>
							<td>
								<input type="text" class="input_type_text" name="st_project_input" id="st_project_input" style="width:446px" value="">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:55%" value="">
							</td>
							<th>사업부서</th>
							<td>
								<!-- 다중선택콤보(공통) - input박스의 type은 hidden으로 생성 할것 , style, class는 select 박스에 상속 됨. -->
								<input type="hidden" name="st_kep_dept" id="st_kep_dept" value ="" style="width:200px;">
							</td>
						</tr>
						<tr class="center"> 
							<th>담당 PM</th>
							<td>
								<input type="text" class="input_type_text" id="st_project_mng_user" name="st_project_mng_user" style="width:446px;" value="" onkeydown="kepEnter()">
							</td>
							<th>진행상태</th>
							<td>
								<!-- 다중선택콤보(공통) - input박스의 type은 hidden으로 생성 할것 , style, class는 select 박스에 상속 됨. -->
								<input type="hidden" name="st_project_status" id="st_project_status" value ="" style="width:200px;">
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
		<br>
   		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<div class="btnArea">
			<span class="fl">
				<span class="btn_08 mr04"><a href="javascript:doAction('excelDown');">조회결과 다운로드</a></span>
			</span>
		<%if(st_user_dept.equals("138") || st_user_dept.equals("141") || st_user_dept.equals("095") || st_user_id.equals("KEP200008") || st_user_id.equals("KEP2129141") ) { // 구매기획팀(138) 소속만 확인 가능, (141, 실장님 아이디, 서경원프로님ㄴ)는 테스트 대비, %>
		<!--버튼영역-->
			<span class="fr">
				<span class="btn_06"><a href="javascript:doAction('finish');">프로젝트 중단</a></span>
				<span class="btn_06"><a href="javascript:doAction('new');">신규 등록</a></span>
			</span>
		<%} %>
		</div>
<!--내용 종료-->	                 

</body>
</html>
