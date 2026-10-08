<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 수정요청 현황

* 화면 : 상품정보 수정요청 현황
* 기능 : 요청자(구매담당자)가 자기가 낸 상품정보 수정요청의 진행상태를 확인하고 취소한다.
*        - 그리드 행 단위는 '변경항목 1건' — 같은 요청번호가 여러 줄로 펼쳐진다.
*        - 승인/반려는 DB관리파트 화면(별도)에서 한다. 여기 버튼은 [요청취소] 하나뿐.
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-04
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
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤 (번호 페이징은 makePageIndex2 가 따로 그린다 - 상품정보 목록과 같은 규약)
var current_page = -1;	// 현재 페이지 번호 (-1 : 조회 직후 1페이지)
/* 요청 단위로 세로 병합할 열. 변경항목·기존·변경·변경사유·대체코드는 행마다 달라 제외한다. */
var MERGE_COLS = ["SELECTED","REQ_NO","CMS_CATLG_ID","REQ_STATUS_NM","STATUS_NM","DESCRIPTION_LOC"
                 ,"MODEL_INFO","SPECIFICATION","MAKER_NAME","ORIGIN_NAME","ORDER_MEASURE"
                 ,"REQ_USER_NAME","REQ_DATETIME","REJECT_REASON","PROC_USER_NAME","PROC_DATETIME"];
var popupSel = "";		// 어떤 팝업의 콜백인지 구분

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"요청번호",	SaveName:"REQ_NO"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품정보코드",	SaveName:"CMS_CATLG_ID"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"진행상태",	SaveName:"REQ_STATUS_NM"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"진행상태코드",	SaveName:"REQ_STATUS"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"상품상태",	SaveName:"STATUS_NM"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:25,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION_LOC"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"모델번호",	SaveName:"MODEL_INFO"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:25,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"단위",	SaveName:"ORDER_MEASURE"}
		,{ Align:"Center",	Width:110,	Edit:false,	EditLen:25,	Type:"Text",	Header:"변경항목",	SaveName:"JOB_COLUMN_NM"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:25,	Type:"Text",	Header:"기존",	SaveName:"OLD_TEXT"}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:25,	Type:"Text",	Header:"변경",	SaveName:"NEW_TEXT"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:25,	Type:"Text",	Header:"변경사유",	SaveName:"CHANGE_REASON"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:25,	Type:"Text",	Header:"대체코드",	SaveName:"ALT_CODE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:25,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:25,	Type:"Text",	Header:"요청일시",	SaveName:"REQ_DATETIME"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:25,	Type:"Text",	Header:"반려사유",	SaveName:"REJECT_REASON"}
		,{ Align:"Center",	Width:90,	Edit:false,	EditLen:25,	Type:"Text",	Header:"처리담당자",	SaveName:"PROC_USER_NAME"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:25,	Type:"Text",	Header:"처리일시",	SaveName:"PROC_DATETIME"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Hidden:true,	Type:"Text",	Header:"변경항목수",	SaveName:"ITEM_CNT"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	// 정렬 차단 - 정렬하면 요청번호 구간이 흩어져 아래 세로 병합이 깨진다(SQL 이 요청번호 DESC + 순번으로 이미 고정)
	initsheet.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	// 짝수 행 줄무늬 제거 - 병합한 열은 한 칸이라 줄무늬가 안 보여, 병합 안 한 [변경항목] 뒤쪽만 얼룩져 보인다
	mySheet.SetDataAlternateBackColor("#FFFFFF");

	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	$("#st_from_date").val( kepToMonthAdd("1","M") );          // 당일 -1개월 (요청일 기준 한 달 이전까지)
	$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );  // 오늘
}

// 기능함수
function doAction(str) {
	switch (str) {
	case "search":	// 조회
		// 품목명/모델번호/규격은 2글자 이상 입력 시에만 조회 (상품정보 목록과 같은 기준)
		var itemName = $.trim($("#st_item_name").val());
		var modelInfo = $.trim($("#st_model_info").val());
		var specification = $.trim($("#st_specification").val());
		if(itemName != "" && itemName.length < 2){
			alert("품목명은 2글자 이상 입력하세요.");
			return;
		}
		if(modelInfo != "" && modelInfo.length < 2){
			alert("모델번호는 2글자 이상 입력하세요.");
			return;
		}
		if(specification != "" && specification.length < 2){
			alert("규격은 2글자 이상 입력하세요.");
			return;
		}
		current_page = -1;
		kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdCmCmsItemChangeReqStatusList.do", pagingMode);
		break;

	case "reload":	// 초기화
		kepReload('searchCondition');
		// ⚠ kepReload 는 화면의 모든 checkbox 를 켠다 - 이 화면엔 조회조건 체크박스가 없지만,
		//    hidden 으로 들고 다니는 대량입력 값은 스스로 지워야 한다.
		$("#st_req_no").val("");
		$("#st_req_no_multi").val("");
		$("#st_cmscatlg").val("");
		$("#st_cmscatlg_multi").val("");
		$("#st_maker_code").val("");
		$("#st_maker_name").val("");
		$("#st_from_date").val( kepToMonthAdd("1","M") );
		$("#st_to_date").val( kepGetNowTimeStr("YYYYMMDD","/") );
		mySheet.RemoveAll();
		$("#pageindex").html("");
		break;

	case "cancel":	// 요청취소
		doCancel();
		break;
	}
}

/* 요청취소.
 * 그리드는 변경항목 단위 행이라 같은 요청번호가 여러 줄 체크될 수 있다 - 요청번호로 접어서 보낸다.
 * 진행상태가 [요청]이 아닌 건은 서버에서 걸러지지만, 화면에서 먼저 알려 준다. */
function doCancel() {
	var reqNos = [];
	var hasDone = false;

	for (var r = mySheet.HeaderRows(); r <= mySheet.LastRow(); r++) {
		if (mySheet.GetCellValue(r, "SELECTED") != 1) { continue; }

		if (mySheet.GetCellValue(r, "REQ_STATUS") != "REQ") { hasDone = true; continue; }

		var no = mySheet.GetCellValue(r, "REQ_NO");
		if (no != null && ("" + no) != "" && $.inArray("" + no, reqNos) < 0) { reqNos.push("" + no); }
	}

	// 처리된 건이 하나라도 섞여 있으면 진행하지 않는다 - 골라낸 것만 취소되면 몇 건이 빠졌는지 알기 어렵다
	if (hasDone) {
		alert("요청건만 취소 가능합니다.");
		return;
	}
	if (reqNos.length == 0) {
		alert("취소할 요청을 선택해 주세요.");
		return;
	}
	if (!confirm(reqNos.length + "건 요청 취소하시겠습니까?")) { return; }

	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/saveMasterMdCmCmsItemChangeReqCancel.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		traditional: true,			// st_req_no=A&st_req_no=B 형태로 보낸다 (서버가 MultiValueMap 으로 받는다)
		data: { st_req_no: reqNos },
		success: function( response ) {
			alert(response.Message);
			if (response.Result && response.Result.Code == 1) { doAction('search'); }
		},
		error: function( response ) {
			alert("요청취소에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(current_page == -1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);
	}

	var totRow = mySheet.RowCount();
	if( totRow <= 0) return;

	mergeByReqNo();		// 같은 요청번호끼리 세로로 묶는다(체크박스 포함)

	if (msg != "") {
		alert(msg);
	}
}

/* ── 요청 단위 세로 병합 ───────────────────────────────────────────────
 * 한 요청(REQ_NO)이 변경항목 수만큼 행으로 펼쳐진다. 설계서 목업처럼 요청 단위 열은
 * 한 칸으로 묶어 보이게 하고, 체크박스도 요청당 하나만 보이게 한다.
 * ★ 자동 머지(msPrevColumnMerge)를 쓰지 않는다 - 그건 "값이 같으면 붙인다"라서
 *   체크박스 열(값이 전부 0)이 서로 다른 요청까지 한 덩어리로 만든다.
 *   그래서 요청번호로 구간을 잘라 SetMergeCell 로 강제 머지한다.
 * ★ 조회할 때마다 다시 걸어야 한다(행이 새로 그려지면 머지가 풀린다).
 * ⚠ 헤더 정렬은 막아 뒀다(HeaderMode.Sort:0) - 정렬하면 구간이 흩어져 머지가 깨진다. */
function mergeByReqNo() {
	var first = mySheet.HeaderRows();
	var last  = mySheet.LastRow();
	if (last < first) { return; }

	var cols = [];
	for (var i = 0; i < MERGE_COLS.length; i++) {
		var c = mySheet.SaveNameCol(MERGE_COLS[i]);
		if (c > -1) { cols.push(c); }
	}

	var start = first;
	for (var r = first; r <= last + 1; r++) {
		var same = (r <= last) && (mySheet.GetCellValue(r, "REQ_NO") == mySheet.GetCellValue(start, "REQ_NO"));
		if (same) { continue; }
		var span = r - start;
		if (span > 1) {
			for (var i = 0; i < cols.length; i++) { mySheet.SetMergeCell(start, cols[i], span, 1); }
		}
		start = r;
	}
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdCmCmsItemChangeReqStatusList.do?page="+current_page, pagingMode);
}

// 검색조건 팝업 호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "maker": // 제조사 (텍스트 조회 불가 - 팝업으로만 고른다)
			openSearchPopup("/common/agentRegMakerCodePop.do", "?st_alias_yn=Y", "820,464,no");
			break;
		// 대량입력은 범용 팝업 재사용(엑셀 열 복붙). header_text 가 제목·그리드 헤더가 된다.
		// ⚠ openSearchPopup 이 내부에서 encodeURI 를 걸므로 여기서는 날것으로 넘긴다(미리 인코딩하면 이중 인코딩).
		case "reqNoMulti": // 요청번호
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=요청번호", "300,371,no");
			break;
		case "catlgMulti": // 상품코드
			openSearchPopup("/common/multiSearchCondPop.do", "?header_text=상품코드", "300,371,no");
			break;
	}
}

// 팝업 콜백
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	switch (popupSel) {
		case "maker":
			$("#st_maker_code").val(value1);
			$("#st_maker_name").val(value2);
			break;
		case "reqNoMulti":
			var reqNos = kepCleanMultiCode(value1);
			$("#st_req_no_multi").val(reqNos);
			$("#st_req_no").val(kepMultiName(reqNos, "@"));
			break;
		case "catlgMulti":
			var codes = kepCleanMultiCode(value1);
			$("#st_cmscatlg_multi").val(codes);
			$("#st_cmscatlg").val(kepMultiName(codes, "@"));
			break;
	}
	popupSel = "";	// 초기화
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA">
			<h3>상품정보 수정요청 현황</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">

            	<table class="cont_t_list01" style="width:100%">
						<caption>상품정보 수정요청 현황</caption>
						<colgroup>
							<col width="8%" />
						    <col width="17%" />
						    <col width="8%" />
						    <col width="17%" />
						    <col width="8%" />
						    <col width="17%" />
						    <col width="8%" />
						    <col width="17%" />
						</colgroup>
						<tbody>
							<tr>
								<th>요청일</th>
								<td colspan="3">
									<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:85px; text-align:center;" value=""> -
									<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:85px; text-align:center;" value="">
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
									<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>
								</td>
								<th>요청번호</th>
								<td>
									<input type="text" class="input_type_text" id="st_req_no" name="st_req_no" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="kepClear('st_req_no_multi');">
									<input type="hidden" name="st_req_no_multi" id="st_req_no_multi" value ="">
			                        <a href="javascript:doPop('reqNoMulti');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser('st_req_no_multi','st_req_no');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>상품코드</th>
								<td>
									<input type="text" class="input_type_text" id="st_cmscatlg" name="st_cmscatlg" style="width:60%;" value="" onkeydown="kepEnter()" onKeyUp="kepClear('st_cmscatlg_multi');">
									<input type="hidden" name="st_cmscatlg_multi" id="st_cmscatlg_multi" value ="">
			                        <a href="javascript:doPop('catlgMulti');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser('st_cmscatlg_multi','st_cmscatlg');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
							</tr>
							<tr>
								<th>변경항목</th>
								<td>
									<!-- ⚠ 이 목록은 매퍼(masterMdCmCmsItemChangeReq-sql.xml)의 JOB_COLUMN DECODE 와 같은 9개여야 한다 -->
									<select name="st_job_column" id="st_job_column" style="width:90%;">
										<option value="" selected="selected">전체</option>
										<option value="STATUS">상품상태</option>
										<option value="DESCRIPTION_LOC">품목명</option>
										<option value="MODEL_INFO">모델번호</option>
										<option value="SPECIFICATION">규격</option>
										<option value="MAKER_CODE">제조사</option>
										<option value="ORIGIN_CODE">원산지</option>
										<option value="ORDER_MEASURE">단위</option>
										<option value="ITEM_GUBUN">상품구분</option>
										<option value="TR_HANDLE_TYPE">TR취급가능여부</option>
									</select>
								</td>
								<th>변경항목수</th>
								<td>
									<select name="st_item_cnt" id="st_item_cnt" style="width:90%;">
										<option value="" selected="selected">전체</option>
										<option value="SINGLE">단일항목</option>
										<option value="MULTI">복수항목</option>
									</select>
								</td>
								<th>품목명</th>
								<td>
									<input type="text" class="input_type_text" id="st_item_name" name="st_item_name" style="width:90%;" value="" onkeydown="kepEnter()">
								</td>
								<th>모델번호</th>
								<td>
									<input type="text" class="input_type_text" id="st_model_info" name="st_model_info" style="width:90%;" value="" onkeydown="kepEnter()">
								</td>
							</tr>
							<tr>
								<th>규격</th>
								<td>
									<input type="text" class="input_type_text" id="st_specification" name="st_specification" style="width:90%;" value="" onkeydown="kepEnter()">
								</td>
								<th>제조사</th>
								<td>
			                        <input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:65%;" value = "" readonly>
			                        <input type="hidden" name="st_maker_code" id="st_maker_code" value ="">
			                        <a href="javascript:doPop('maker');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:kepEraser('st_maker_code','st_maker_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>요청자</th>
								<td>
									<input type="text" class="input_type_text" id="st_req_user_name" name="st_req_user_name" style="width:90%;" value="" onkeydown="kepEnter()">
								</td>
								<th></th>
								<td></td>
							</tr>
						</tbody>
					</table>
			</div>

           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" onchange="doAction('search');">
					<option value="100" selected>100건</option>
					<option value="300">300건</option>
					<option value="500">500건</option>
					<option value="1000">1000건</option>
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
  					<span class="btn_03"><a href="javascript:doAction('cancel');">요청취소</a></span>
  				</span>
  			 </div>

<!--내용 종료-->

</body>
</html>
