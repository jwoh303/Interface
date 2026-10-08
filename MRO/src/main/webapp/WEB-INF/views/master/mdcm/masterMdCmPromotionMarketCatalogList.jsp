<%--
**********************************************
* 메뉴 : 구매대행>카탈로그>판촉물 전용 카탈로그 > 판촉물 전용 마켓 카탈로그 관리
* 화면 : 판촉물 전용 마켓 카탈로그 관리
* 기능 : 
* 프로그램 ID : PG_03_M_007_00
* 담당자 : 카탈개 ( 설계 : 권우재 )
* 착수일 : 2014-
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
	initsheet.Cols = [ 
	      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}
					 ,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"ITEM_NO"}
					,{ Align:"Center",	Width:270,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Center",	Width:320,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Center",	Width:92,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"제안일",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:63,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"STATUS"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Center",	Width:92,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"수정일",	SaveName:"CHANGE_DATE"}
					,{ Align:"Center",	Width:63,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분",	SaveName:"GUBUN"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사",	SaveName:"AGENT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"변경시간",	SaveName:"CHANGE_TIME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"KEP_DATE",	SaveName:"KEP_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"KEP_TIME",	SaveName:"KEP_TIME"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	
	
	setLinkCol(mySheet, "AGENT_NAME");	//공급사
	setLinkCol(mySheet, "ITEM_NO");	//상품코드
	
	
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

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmPromotionMarketCatalogList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_agent_code').val('');
		$('#st_categ_id').val('');
		$('#st_categ_type').val('');
		mySheet.RemoveAll();
		break;

	case "print": // 견적서출력
		var item_no = '';
		for(var inx = 0 ; inx < arrRow.length ; inx++){
			item_no += mySheet.GetCellValue(arrRow[inx],"ITEM_NO") + "@@";
		}
	
		var param = item_no;
		var fileName = "RD_09_A_001_00"; // RD_ID
		//var fileName = "RD_06_S_003_31"; // RD_ID
		
		//alert("RD_ID : " + fileName + ", param : " + param);
		
		//var param =  "[PO14004517][KRDAEW0023][KRKORE0001]";
		reportOpen(fileName,param);

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
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg) {
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmPromotionMarketCatalogList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "agent_single": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "agent_single";
			break;
			
		case "masterMdCmPromotionMarketCatalogSelPop": // 판촉물전용마켓 카테고리
			popupSel = "masterMdCmPromotionMarketCatalogSelPop";
			openSearchPopup('/mdcm/showMasterMdCmPromotionMarketCatalogSelPop.do','','528,510,no');
			break;
	}
	
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'ITEM_NO') { // 상품코드
		//var ID = mySheet.GetCellValue(Row,"ITEM_NO");
		//openSearchPopup('masterMdCmPromotionMarketCatalogPop','?user_id='+ID);
		
		//http://130.100.101.21:7004/kr/promote/promote_master_catalog_display.jsp?st_item_no=PP0561&st_list_item_no=ALL
		
		var ITEM_NO = mySheet.GetCellValue(Row,"ITEM_NO");
		//var RFQ_NO = mySheet.GetCellValue(Row,"RFQ_NO");

		openSearchPopup("/mdcm/getMasterMdCmItemDetailInfoModifyPop.do","?ITEM_NO="+ITEM_NO,"988,768,yes");
		popupSel = "itemDetailInfoModify";
	 
	} else if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT");
		//openSearchPopup('agent','?st_com_code='+agent);
		
		getAgentDisplayPop(agent);
		
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	 if (popupSel == "agent_single") { // 단일 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}else if (popupSel == "masterMdCmPromotionMarketCatalogSelPop") {	//KEP 표준카테고리 선택

		$("#st_categ_id").val(value1);
		$("#st_categ_type").val(value2);
		$("#st_category_path").val(value3);
		
		//표준카테고리 선택에 따른 속성 조회조건 추가
		//setSysopKssCategorySearch(value3, value5);
	}
	
	grbRow="";	//초기화
	
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>판촉물 전용 마켓 카탈로그 관리</h3>
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
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
			<table  class="cont_t_list01" >
				<caption>판촉물 전용 마켓 카탈로그 관리</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
				</colgroup>
						
				<tbody>
					<tr>
						<th>품목명/규격</th>
						<td width="210" class="bg2"  align="center">
							<input type="text" id="st_desc_spec" name="st_desc_spec" style="width:87%" value=""  onKeyDown="kepEnter()">
						</td>
						<th>제조사</th>
						<td width="210" class="bg2" align="center">
							<input type="text" id="st_maker_name" name="st_maker_name" style="width:87%" value="" onKeyDown="kepEnter()">
						</td>
						<th> 상태</th>
						<td class="bg2">
							<select name="st_status" id="st_status">
								<option value="ALL" >전체</option>
								<option value="요청">요청</option>
								<option value="게시" >게시</option>
								<option value="보관" >보관</option>
								<option value="반려" >반려</option>
								<option value="삭제" >삭제</option>
								<option value="추천">추천</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>품목코드</th>
						<td width="210" class="bg2"  align="center">
							<input type="text" name="st_item_no" id="st_item_no" style="width:87%" value="" onKeyUp="kepToUpper('st_item_no')" onKeyDown="kepEnter()">
						</td>
						<th>협력사</th>
						<td>
							<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:67%" value="" readonly onclick="javascript:doPop('agent_single');">
							<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">
							<a href="javascript:doPop('agent_single');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>구분</th>
						<td>
							<input type="radio" class="Noborder" name="st_item_flag" value="" checked="checked">전체&nbsp;
							<input type="radio" class="Noborder" name="st_item_flag" value="N" >일반&nbsp;
							<input type="radio" class="Noborder" name="st_item_flag" value="G" >기획
						</td>
					</tr>
					<tr>
						<th>카테고리</th>
						<td>
							<input type="text" id="st_category_path" name="st_category_path" maxlength="25"  value = "" style="width:67%;" class="input_type_text"  readonly>
							<a href="javascript:doPop('masterMdCmPromotionMarketCatalogSelPop');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_categ_id','st_category_path');"><img src="/resources/images/btn_eraser2.gif"></a>
							<input type="hidden" id="st_categ_id" name="st_categ_id" value = "">
							<input type="hidden" id="st_categ_type" name="st_categ_type" value = "">
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
			<span class="btn_04"><a href="javascript:doAction('print');">견적서출력</a></span>
		</span>
	</div>
	
<!--내용 종료-->
</body>
</html>
