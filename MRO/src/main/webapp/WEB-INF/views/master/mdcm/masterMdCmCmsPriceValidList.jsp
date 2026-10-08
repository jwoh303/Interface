<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>매입단가유효일 관리
* 화면 : 매입단가유효일 관리 (p17)
* 기능 : 매입단가유효일 조회/관리. 단가유효일연장/단가합의요청/재소싱진행. 상품정보코드·구매정보코드 클릭 시 상세 팝업
* 담당자 : 홍준우
* 착수일 : 2026-06-25
**********************************************
--%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String userId         = sessionInfo.getUserId();
%>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		// ★ Cols[0].Header 가 빈문자("")면 IBS_InitSheet(ibsheetinfo.js:553)가 헤더행 생성을 스킵 → 컬럼 헤더명 미표시.
		//    숨김 상태(Status) 컬럼을 맨 앞에 두어(=truthy Header) 헤더가 정상 노출되게 함.
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,	Edit:true,	EditLen:100,	Type:"DummyCheck",	Header:"",			SaveName:"SELECTED"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"고객사\n전용코드",	SaveName:"BUYER_ITEM_CODE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품정보코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:25,	Type:"Text",	Header:"카테고리",		SaveName:"CMS_CATEG_ID"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:25,	Type:"Text",	Header:"품명",			SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:25,	Type:"Text",	Header:"규격",			SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:85,	Edit:false,	EditLen:25,	Type:"Text",	Header:"제조사",			SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:25,	Type:"Text",	Header:"원산지",			SaveName:"ORIGIN_CODE_NAME"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:25,	Type:"Text",	Header:"단위",			SaveName:"ORDER_MEASURE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"모델번호",		SaveName:"MODEL_INFO"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상태",			SaveName:"USE_STATUS"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"구매정보코드(키)",	SaveName:"BUY_INFO_ID"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:5,	Type:"Text",	Header:"구매정보코드",	SaveName:"BUY_INFO_SEQ"}
		,{ Align:"Left",	Width:95,	Edit:false,	EditLen:25,	Type:"Text",	Header:"협력사명",		SaveName:"VENDOR_NAME"}
		,{ Align:"Right",	Width:75,	Edit:false,	EditLen:25,	Type:"Int",		Header:"단가",			SaveName:"UNIT_PRICE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Int",		Header:"조달일수",		SaveName:"LEADTIME"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:25,	Type:"Int",		Header:"MOQ",			SaveName:"MOQ"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Int",		Header:"발주배수",		SaveName:"ORDER_MULTIPLE"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:25,	Type:"Text",	Header:"거래유형",		SaveName:"TRADE_TYPE"}
		,{ Align:"Center",	Width:65,	Edit:false,	EditLen:25,	Type:"Text",	Header:"배송조건",		SaveName:"DELIVERY_COND"}
		,{ Align:"Center",	Width:95,	Edit:true,	EditLen:10,	Type:"Date",	Format:"yyyy-MM-dd",	Header:"매입단가\n유효일",	SaveName:"PRICE_VALID_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"협력사\n상품코드",	SaveName:"VENDOR_ITEM_CODE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"세액구분",		SaveName:"TAX_TYPE"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"온도조건",		SaveName:"TEMP_COND"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"회신상태",		SaveName:"REPLY_STATUS"}
		,{ Align:"Right",	Width:75,	Edit:false,	EditLen:25,	Type:"Int",		Header:"회신단가",		SaveName:"REPLY_PRICE"}
		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:50,	Type:"Text",	Header:"회신비고",		SaveName:"REPLY_REMARK"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정 : 상품정보코드 / 구매정보코드 / 카테고리
	setLinkCol(mySheet, "CMS_CATLG_ID");
	setLinkCol(mySheet, "BUY_INFO_SEQ");
	setLinkCol(mySheet, "CMS_CATEG_ID");

	//단가유효일 검색 입력칸에 표준 달력(datepicker) 부착
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	//단가유효일 조회 디폴트 : 당일 기준 -2개월 ~ +2개월
	setDefaultDateRange();
}

//검색 단가유효일 디폴트값(당일 -2개월 ~ +2개월) 세팅 - 표준 함수 사용(yyyy/mm/dd)
function setDefaultDateRange(){
	$("#st_from_date").val(kepToMonthAdd("2","M")); // 당일 -2개월
	$("#st_to_date").val(kepToMonthAdd("2","P"));   // 당일 +2개월
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdCmCmsPriceValidList.do", pagingMode);
		break;

	case "reload":	// 초기화
		kepReload('searchCondition');
		setDefaultDateRange();
		mySheet.RemoveAll();
		break;

	case "catelist": // 카테고리조회 (KeP표준 카테고리 팝업)
		openSearchPopup("/mprq/showMasterMpRqKepStndrdCategorySelPop.do","", "721,670,no");
		break;

	case "extend": // 단가유효일연장 (당일 기준 1년 뒤 자동)
		alert("화면 레이아웃 단계입니다. 단가유효일연장(당일+1년 자동변경)은 후속 작업에서 연결됩니다.");
		break;

	case "agree": // 단가합의요청 (협력사 발송)
		alert("화면 레이아웃 단계입니다. 단가합의요청(협력사 발송)은 후속 작업에서 연결됩니다.");
		break;

	case "resourcing": // 재소싱진행 (CH 채번 신규견적의뢰)
		alert("화면 레이아웃 단계입니다. 재소싱진행(신규견적의뢰)은 후속 작업에서 연결됩니다.");
		break;

	case "excelDown": // 엑셀다운로드
		alert("화면 레이아웃 단계입니다. 엑셀다운로드는 후속 작업에서 연결됩니다.");
		break;

	case "save": // 저장
		alert("화면 레이아웃 단계입니다. 저장 기능은 후속 작업에서 연결됩니다.");
		break;
	}
}

//그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	return DATA;
}
//엑셀 다운로드 후 처리
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
//조회 후처리
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

	if (msg != "") {
		alert(msg);
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdCmCmsPriceValidList.do?page="+current_page, pagingMode);
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column == "CMS_CATLG_ID"){ // 상품정보 상세 (p7)
		var st_msds_no = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
		openSearchPopup("/mdcm/showMasterMdCmCmsItemDetailPop.do","?st_msds_no="+st_msds_no, "1300,800,no");
	}else if(column == "BUY_INFO_SEQ"){ // 구매정보 상세 (p15)
		var st_msds_no  = mySheet.GetCellValue(Row,"CMS_CATLG_ID");
		var st_buy_info = mySheet.GetCellValue(Row,"BUY_INFO_ID");
		openSearchPopup("/mdcm/showMasterMdCmCmsBuyInfoDetailPop.do","?st_msds_no="+st_msds_no+"&st_buy_info="+st_buy_info, "1300,800,no");
	}else if(column == "CMS_CATEG_ID"){ // 카테고리 선택 (KeP표준 카테고리 팝업)
		openSearchPopup("/mprq/showMasterMpRqKepStndrdCategorySelPop.do","", "721,670,no");
	}
	return;
}

// 카테고리 SelPop 선택 반환 → 검색조건 카테고리 필터 채움
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	$("#st_cata_code").val(value3);   // 카테고리 ID
	$("#st_cata_name").val(value4);   // 카테고리 경로
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA">
		<h3>매입단가유효일 관리</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>
	<!--조회영역-->
	<form name="searchCondition" method="post">
		<div id="cont_searchA">
			<!--HIDDEN-->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" name="onepagerow" id="onepagerow" value="10">

			<table class="cont_t_list01" style="width:100%">
				<caption>매입단가유효일 관리</caption>
				<colgroup>
					<col width="8%" />
					<col width="17%" />
					<col width="8%" />
					<col width="17%" />
					<col width="8%" />
					<col width="17%" />
					<col width="25%" />
				</colgroup>
				<tbody>
					<tr>
						<th>단가유효일</th>
						<td colspan="6">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:12%; text-align:center;" value=""> -
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:12%; text-align:center;" value="">
							<input type="checkbox" class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시
						</td>
					</tr>
					<tr>
						<th>카테고리</th>
						<td>
							<input type="text" class="input_type_text" name="st_cata_name" id="st_cata_name" style="width:60%;" value="">
							<input type="hidden" name="st_cata_code" id="st_cata_code" value="">
							<a href="javascript:doAction('catelist');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_cata_code','st_cata_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>상품정보코드</th>
						<td>
							<input type="text" class="input_type_text" id="st_catlg_id" name="st_catlg_id" style="width:90%;" value="" onkeydown="kepEnter()">
						</td>
						<th>
							<select name="st_item_type" id="st_item_type" class="TitSelect">
								<option value="de" selected="selected">품명</option>
								<option value="sp">규격</option>
							</select>
						</th>
						<td>
							<input type="text" class="input_type_text" id="st_item_keyword" name="st_item_keyword" style="width:90%;" value="" onkeydown="kepEnter()">
						</td>
						<td></td>
					</tr>
					<tr>
						<th>협력사명</th>
						<td>
							<input type="text" class="input_type_text" id="st_agent_name" name="st_agent_name" style="width:90%;" value="" onkeydown="kepEnter()">
						</td>
						<th>담당자</th>
						<td>
							<input type="text" class="input_type_text" id="st_manager" name="st_manager" style="width:90%;" value="" onkeydown="kepEnter()">
						</td>
						<th>상품상태</th>
						<td>
							<select name="st_status" id="st_status" style="width:50%;">
								<option value="" selected="selected">전체</option>
								<option value="Y">사용</option>
								<option value="N">휴면</option>
								<option value="E">만료예정</option>
								<option value="X">만료</option>
							</select>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>회신상태</th>
						<td>
							<select name="st_reply_status" id="st_reply_status" style="width:50%;">
								<option value="" selected="selected">전체</option>
								<option value="N">미회신</option>
								<option value="C">변경요청</option>
								<option value="A">합의완료</option>
							</select>
						</td>
						<th>&nbsp;</th>
						<td>&nbsp;</td>
						<th>&nbsp;</th>
						<td>&nbsp;</td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>

		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow2" style="width: 70px;" onchange="document.getElementById('onepagerow').value=this.value;">
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

	<!--세무구분 자동반영 안내-->
	<p style="margin:6px 0; color:#c0392b; font-size:13px;">※ 해당 화면에서 변경된 세무구분은 카탈로그에도 자동 반영됩니다.</p>

	<!--버튼영역-->
	<div class="btnArea">
		<span class="fl">
			<span class="btn_05 mr04"><a href="javascript:doAction('extend');">단가유효일연장</a></span>
			<span class="btn_05 mr04"><a href="javascript:doAction('agree');">단가합의요청</a></span>
			<span class="btn_05 mr04"><a href="javascript:doAction('resourcing');">재소싱진행</a></span>
			<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</span>
		<span class="fr">
			<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
		</span>
	</div>

<!--내용 종료-->
</body>
</html>
