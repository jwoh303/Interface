<%--
**********************************************
* 메뉴 : 견적관리>벌크소싱이력관리
* 화면 :벌크소싱이력관리
* 기능 : 벌크소싱 이력관리 화면
* 프로그램 ID : 
* 담당자 : 현명환 ( 설계 : 현명환)
* 착수일 : 2014-11-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconR="/resources/images/icon_r.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
// 	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [ 
	 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
	,{ Align:"Center",	Width:30,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",ColMerge:0}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER",ColMerge:0}
	,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",	SaveName:"COM_NAME_LOC",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"벌크소싱구분",	SaveName:"BULK_TYPE",ColMerge:0}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"견적번호",	SaveName:"BULK_NO",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"평가방법",	SaveName:"EVLT_METHOD",ColMerge:0}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SG코드",	SaveName:"SG_NO",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"SG명",	SaveName:"SG_NM",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO",ColMerge:0}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION",ColMerge:0}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION",ColMerge:0}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사명",	SaveName:"MAKER_NAME",ColMerge:0}
	,{ Align:"Left",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE",ColMerge:0}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"원산지명",	SaveName:"ORIGIN_NAME",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"원산지코드",	SaveName:"ORIGIN_CODE",ColMerge:0}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"기존협력사명",	SaveName:"EXT_AGENT_NAME",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"거래유형코드",	SaveName:"PROCESS_TYPE",ColMerge:0}
	,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_NM",ColMerge:0}
	,{ Align:"right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", Header:"수량(년)",	SaveName:"BULK_QTY",ColMerge:0}
	,{ Align:"right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", Header:"기존단가",	SaveName:"EXT_BULK_UNIT_PRICE",ColMerge:0}
	,{ Align:"right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Format:"${priceFormat}", Header:"기존금액",	SaveName:"EXT_BULK_AMT",ColMerge:0}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"기존협력사유통레벨",	SaveName:"EXT_DSTBT_LV",ColMerge:0}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"배송지역",	SaveName:"DLVR_ZONE",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자명",	SaveName:"KEP_USER_NM",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"담당자연락처",	SaveName:"KEP_USER_PHONE",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록일",	SaveName:"ADD_DATE",ColMerge:0}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"등록자",	SaveName:"ADD_NAME",ColMerge:0}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"수정일",	SaveName:"CHANGE_DATE",ColMerge:0}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"수정자",	SaveName:"CHANGE_NAME",ColMerge:0}
	,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"비고",	SaveName:"REMARK",ColMerge:0}
	,{ Align:"right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",  Format:"${priceFormat}", Header:"의뢰건수",	SaveName:"REQ_CNT",ColMerge:0}
	,{ Align:"right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",  Format:"${priceFormat}", Header:"접수건수",	SaveName:"RECV_CNT",ColMerge:0}
	,{ Align:"right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	  Format:"${priceFormat}", Header:"견적단가",	SaveName:"BULK_UNIT_PRICE",ColMerge:0}
	,{ Align:"right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	  Format:"${priceFormat}", Header:"견적금액",	SaveName:"BULK_AMT",ColMerge:0}
	,{ Align:"right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	  Format:"${priceFormat}", Header:"절감금액",	SaveName:"RDCT_AMT",ColMerge:0}
	,{ Align:"right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	  Format:"${priceFormat}", Header:"절감율(%)",	SaveName:"RDCT_RATE",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"선정협력사",	SaveName:"SELECT_AGENT_NAME",ColMerge:0}
	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"대체품여부",	SaveName:"REPLACEMENT_YN",ColMerge:0}
	,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사비고",	SaveName:"AGENT_REMARK",ColMerge:0}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"담당자ID",	SaveName:"KEP_USER_ID",ColMerge:0}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,5);
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');
	kepAjaxCommonQueryIdCombo('st_kep_reg_user_id','getKepUserList','SEL','');

	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	
	// 다중선택콤보(공통) - 생성
	kepAjaxCommonTotalMultiCombo('st_status', 'M126', 'ALL', '');
}

	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		if (kepIsValueNull($('#st_buyer_code').val())){
			alert("고객사는 필수입니다.");
			return;
		}		
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mprq/getMasterMpRqQuotationBulkHistroyList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_buyer_code').val("");
		mySheet.RemoveAll();
		
		// 다중선택콤보(공통) - 초기화
		init_multiCombo("st_status");
		
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		break;
	case "loadExcel": //  ExcelImport
		// 엑셀 업로드 조건 체크
		mySheet.RemoveAll();
		var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||3||1|2|4|5||6|7|8|9|10||11|12|13||14|15|16|17|18|||||||20|21|22|23|24|25|26|27|28|29|19|"};
		mySheet.LoadExcel(params);
		break;
	case "save": // 견적복원
		for (var i=0; i<arrRow.length; i++){
		if (kepIsValueNull($('#st_buyer_code').val())){
			alert("고객사는 필수입니다.");
			return;
		}		
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMpRqQuotationBulkHistroyList.do" , "SELECTED" );
		break;
		
	}
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

	if (msg != "") {
		alert(msg);
	}
	
}

function mySheet_OnMouseMove(Button, Shift, X, Y) { 
	var row = mySheet.MouseRow();

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
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationBulkHistroyList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerMulti": // 고객사 M
			popupSel = "buyerMulti";
			openSearchPopup("/none/showCommonNoNeBuyerChoiceMultiPop.do","?search_opt=2&disable_yn=Y",'1000,500,no')
			break;
	}
}
//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {

	//alert("저장");
	return;
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}

function attach_popup(image_key){
    var left = 0;
    var top = 0;
    var width = 800;
    var height = 400;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
//  var loc = "http://safety.koreab2b.com/kr/common/popup/attach_view_pop_doosanmeca.jsp?st_image_key="+image_key;
    var loc = "http://safety.koreab2b.com/file/view.wu?fileUploadId=fileUploadPop&bizType=BOARD&fileUuid="+image_key+"&callback=setFileImage&callbackParam=0%2CCSTMR_ATTCH_FILE_NO_IMAGE%2CCSTMR_ATTCH_FILE_NO&removeBtnUnvisible=false";
    window.open(loc,'attach_popup', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMulti") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	} else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value1!="")? remarkOn : remarkOff);

	} else if(popupSel == "remarkReturn2Pop") {	// SCM비고
		mySheet.SetCellValue(grbRow, 'SCM_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'SCM_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
		
	} else if (popupSel == "maker"){ // 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
		
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>벌크소싱이력관리</h3>
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
			<input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>벌크소싱이력관리</caption>
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
							<th>등록일자</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<th><font color="#FF6600">*</font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:55%" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:55%" value="">
								<a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							
						</tr>
						<tr> 
							<th>벌크소싱구분</th>
							<td>
								<input type="text" class="input_type_text" id="st_bulk_tpye" name="st_bulk_tpye" style="width:87%;" value=""  onkeydown="kepEnter()">
							</td>
							<th>담당자</th>
							<td>
								<select id="st_kep_user_id" name="st_kep_user_id" style="width:90%;height:20px"></select>
							</td>
							<th>등록자</th>
							<td>
								<select id="st_kep_reg_user_id" name="st_kep_reg_user_id" style="width:90%;height:20px"></select>
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
  	          	<span class="fl">
  					<span class="btn_04 mr04"><a href="javascript:doAction('loadExcel');">EXCEL업로드</a></span>
  					<span class="btn_04 mr04"><a href="/resources/excel/work/MAIN/MasterMpRqQuotationBulk.xls">양식다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
