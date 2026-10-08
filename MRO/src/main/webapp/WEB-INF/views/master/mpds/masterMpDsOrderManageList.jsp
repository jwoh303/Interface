<%--
**********************************************
* 메뉴 : 도안관리>발주관리
* 화면 : 발주관리
* 기능 : 도안관련 발주목록을 조회한다.
* 프로그램 ID : PG_07_M_002_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-13
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
var iconBl = "/resources/images/icon_bl.gif";
var iconBl01 = "/resources/images/icon_bl01.gif";
var iconWhite = "/resources/images/icon_w.gif";
// var diskOn = "/resources/images/disk_on.gif";
// var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태|상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"|",	SaveName:"SELECTED"}
			        ,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청공장|요청공장",	SaveName:"BUYER_NAME"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공장코드|공장코드",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드|품목코드",	SaveName:"BUYER_ITEM_NO"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명|품목명",	SaveName:"DESCRIPTION", ToolTip:true}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자|요청자",	SaveName:"ADD_NAME"}
			        ,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"주문일|주문일",	SaveName:"ADD_DATE"}
			        ,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"발주일|발주일",	SaveName:"PO_DATE"}
			        ,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품요청일|납품요청일",	SaveName:"RD_DATE"}
			        ,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품예정일|납품예정일",	SaveName:"DS_DATE"}
			        ,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일|입고일",	SaveName:"GR_DATE"}
			        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위|단위",	SaveName:"UNIT_MEASURE"}
			        ,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Number",	Header:"납품예정수량|납품예정수량",	SaveName:"DS_QTY", BackColor:"${optColor}"}
			        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Number",	Header:"입고수량|입고수량",	SaveName:"GR_QTY"}
			        ,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"상태|주문",	SaveName:"STATUS_PR"}
			        ,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"상태|발주",	SaveName:"STATUS_PO"}
			        ,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"상태|접수",	SaveName:"STATUS_DS"}
			        ,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"상태|납품",	SaveName:"STATUS_IV"}
			        ,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"상태|입고",	SaveName:"STATUS_GR"}
			        ,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상태|입고",	SaveName:"STATUS_GR_TEXT"}
			        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고|비고",	SaveName:"REMARK_IMG"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고|비고",	SaveName:"REMARK"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조모집단|제조모집단",	SaveName:"REF_NO"}
			        ,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"제조모집단|제조모집단",	SaveName:"REF_NO_IMG"}
			        ,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:true,	Type:"text",	Header:"|",	SaveName:"STATUS"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"납품처|납품처",	SaveName:"DELY_TO_LOCATION_TEXT"}
			        ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"납품처|납품처",	SaveName:"DELY_TO_LOCATION_TEXT_IMG"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEQ|SEQ",	SaveName:"SEQ"} 
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"분할SEQ|분할SEQ",	SaveName:"DS_SEQ"}
			        ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"변경이력|변경이력",	SaveName:"HIS_COUNT"}
			        ,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"변경이력|변경이력",	SaveName:"HIS_COUNT_IMG"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"납품수량|납품수량",	SaveName:"IV_QTY"}	
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"도안상태|도안상태",	SaveName:"PACKAGE_STATUS"}
			        ,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공급사|공급사",	SaveName:"AGENT_NAME"}
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:6};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, iconWhite);
	mySheet.SetImageList(3, iconBl);
	mySheet.SetImageList(4, iconBl01);
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "REMARK_IMG");
	setLinkCol(mySheet, "REF_NO_IMG");
	setLinkCol(mySheet, "DELY_TO_LOCATION_TEXT_IMG");
	setLinkCol(mySheet, "PACKAGE_STATUS");
	setLinkCol(mySheet, "HIS_COUNT_IMG");
	
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
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mpds/getMasterMpDsOrderManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			mySheet.RemoveAll();
		break;

	case "save": // 저장
	
		for (var i=0; i<arrRow.length; i++){
// 			var item_qty    = mySheet.GetCellValue(arrRow[i],"DS_QTY");
// 			var iv_qty    = mySheet.GetCellValue(arrRow[i],"IV_QTY");
			var item_status    = mySheet.GetCellValue(arrRow[i],"STATUS");

// 			if(eval(iv_qty)>eval(item_qty)) {
// 				alert("현재 송장생성 수량보다 작은 수량은 입력 할 수 없습니다.");
// 				return;
// 			}

			if(item_status !="PR" && item_status!="PO" && item_status !="DS") {
				alert("주문, 발주, 접수 상태에서만 수량변경 가능합니다.");
				return;
			}
			
		}
		
		if(confirm("수량변경 하시겠습니까?")) {
			kepSave(document.searchCondition ,  mySheet , "/mpds/saveMasterMpDsOrderManageList.do" , "SELECTED" );
		}
		break;
		
	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
// 		var param = {FileName:"발주관리목록.xlsx"};
		var param = {FileName:"발주관리목록.xlsx",DownCols:"BUYER_NAME|BUYER|BUYER_ITEM_NO|DESCRIPTION|ADD_NAME|ADD_DATE|PO_DATE|RD_DATE|DS_DATE|GR_DATE|UNIT_MEASURE|DS_QTY|GR_QTY|STATUS_PR|STATUS_PO|STATUS_DS|STATUS_IV|STATUS_GR|REMARK|REF_NO|DELY_TO_LOCATION_TEXT|SEQ|DS_SEQ|PACKAGE_STATUS|AGENT_NAME"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpds/excelMasterMpDsOrderManageList.do", param);
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
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMpDsOrderManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerOffPo": // 발주팝업
			openSearchPopup('/mpds/showMasterMpDsOrderCreationPop.do','?BUSINESS_COND=B&MULTI=N','937,650,no');
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BUYER_ITEM_NO') { // 품목코드
		popupSel = "masterMpDsOrderInfoConfirmPop";
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var add_date = mySheet.GetCellValue(Row,"ADD_DATE");
		var seq = mySheet.GetCellValue(Row,"SEQ");
		var po_status = mySheet.GetCellValue(Row,"STATUS");
		var ds_seq = mySheet.GetCellValue(Row,"DS_SEQ");
		openSearchPopup('/mpds/getMasterMpDsOrderInfoConfirmPop.do','?st_buyer='+buyer+'&st_add_date='+add_date+'&st_seq='+seq+'&st_po_status='+po_status+'&st_ds_seq='+ds_seq,'620,440,no');
	}else if (column == "REMARK_IMG" ){ 
		popupSel = "remarkReturnPop";
		var remark = mySheet.GetCellValue(Row, "REMARK");
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");// 비고

	}else if (column == "REF_NO_IMG" ){ 
		popupSel = "remarkReturnPop";
		var remark = mySheet.GetCellValue(Row, "REF_NO");
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");// 제조모집단

	}else if (column == "DELY_TO_LOCATION_TEXT_IMG" ){
		popupSel = "remarkReturnPop";
		var remark = mySheet.GetCellValue(Row, "DELY_TO_LOCATION_TEXT");
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+remark, "500,230,no");// 납품처
		
	}else if (column == "PACKAGE_STATUS" ){	//도안상태
		var buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var off_buyer = mySheet.GetCellValue(Row, "BUYER");
		var off_add_date = mySheet.GetCellValue(Row, "ADD_DATE");
		var off_seq = mySheet.GetCellValue(Row, "SEQ");
		
		popupSel = (off_buyer == "KRDONG0732")?"/mpds/showMasterMpDsSeed.do":"/mpds/showMasterMpDscropProtect.do";
		openSearchPopup(popupSel,'?popflag=Y&st_buyer_item_no='+buyer_item_no+'&st_off_buyer='+off_buyer+'&st_off_add_date='+off_add_date+'&st_off_seq='+off_seq,'1224,670,no');
	
	}else if (column == "HIS_COUNT_IMG" ){ 
		var hisCnt = mySheet.GetCellValue(Row, "HIS_COUNT");
		if(hisCnt != null && hisCnt != "" && parseInt(hisCnt) > 0){
			popupSel = "viewDbOffPoHistory";
			var buyer = mySheet.GetCellValue(Row, "BUYER");
			var seq = mySheet.GetCellValue(Row, "SEQ");
			openSearchPopup('/common/viewDbOffPoHistoryPop.do','?st_buyer='+buyer+'&st_seq='+seq,'950,308,no');// 변경이력
		}
	}
	return;
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerOffPo") {	// 발주
		doAction('search');	

	}else	if (popupSel == "masterMpDsOrderInfoConfirmPop") { 
		doAction('search');	
		
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>발주관리</h3>
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
			
            	<table class="cont_t_list01" width="887"><!-- 마이페이지 닫힐때 width="887"-->
					<caption>발주관리</caption>
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
				          <th  >
							<select name="st_date_type" id="st_date_type" class="TitSelect">
								<option value="ADD_DATE">주문일</option>
								<option value="PO_DATE">발주일</option>
								<option value="RD_DATE">납품요청일</option>
							</select>
						  </th>
					      <td colspan="3"> 
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
		                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>								
							</td>
					          <th>요청공장</th>
					          <td>
								<select name="st_buyer_code" >
									<option value="ALL" selected>전체</option>
									<option value="KRDONG0110">(주)동부한농 인천공장</option>
									<option value="KRDONG0107">(주)동부한농 구미공장</option>
									<option value="KRDONG0128">(주)동부아그로텍 전주공장</option>
									<option value="KRDONG0732">(주)동부팜한농 안성공장</option><!-- SM000010 추가 -->
								</select>
							  </td>
					        </tr>
						<tr> 
				          <th>품목코드</th>
				          <td><input type="text" name="st_buyer_item_no" style="width:87%" value="" onkeydown="kepEnter()"></td>
				          <th  >진행상태</th>
				          <td >
				            <select   name="st_po_status" id="st_po_status">
								<option value="ALL" >전체</option>
								<option value="PR" >주문</option>
								<option value="PO" >발주</option>
								<option value="DS" >접수</option>
								<option value="IV" >납품</option>
								<option value="GR" >입고</option>	
							</select>
							</td>
				          <th>진행완료 제외</th>
				          <td>
					            <input class="Noborder" type="checkbox" name="st_gr_exception" id="st_gr_exception" checked>
				           </td>
						</tr>
						<tr>
				          <th>품목명</th>
				          <td><input type="text" name="st_description" style="width:87%" value="" onkeydown="kepEnter()"></td> 
				          <th>발주자</th>
				          <td><input type="text" name="st_purchaser_name" style="width:87%" value="" onkeydown="kepEnter()"></td>
				          <th></th><td></td>
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
							</select>
						</td>
			        <td align="right">
	           		<span class="btn_02"><a href="javascript:doPop('buyerOffPo');">발주</a></span>
			        </td>
		   		</tr>
			</table>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "324px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">수량변경</a></span>
  					<span class="btn_05" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
