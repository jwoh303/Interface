<%--
**********************************************
* 메뉴 : 마감현황>회계수불>수불집계표
* 화면 : 수불집계표
* 기능 : 
* 프로그램 ID : PG_10_M_013_03
* 담당자 : 최명진[추후 담당자 제조운영1팀 예정자 홍석규] ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<style type="text/css">
<!--
	table.ui-datepicker-calendar { display:none; }
-->
</style>
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
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:1};
	initsheet.Cols = [ 
   		 { Align:"Center",Width:80,		Edit:false,	EditLen:200,	Hidden:false,	Type:"Date",							Header:"연월",					SaveName:"YYYYMM"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",							Header:"기초수량",				SaveName:"BASIC_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",							Header:"기초금액",				SaveName:"BASIC_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"입고수량(증가)",		SaveName:"GR_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"입고금액(증가)",		SaveName:"GR_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"출고수량(감소)",		SaveName:"CHUL_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"출고금액(감소)",		SaveName:"CHUL_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"조정수량",				SaveName:"JO_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"조정금액",				SaveName:"JO_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"기말수량",				SaveName:"LAST_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"기말금액",				SaveName:"LAST_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"선입고후마감수량",	SaveName:"BEFORE_GR_CLOSE_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"선입고후마감금액",	SaveName:"BEFORE_GR_CLOSE_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"후입고선마감수량",	SaveName:"AFTER_GR_CLOSE_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"후입고선마감금액",	SaveName:"AFTER_GR_CLOSE_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"선출고후마감수량",	SaveName:"BEFORE_CHU_CLOSE_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"선출고후마감금액",	SaveName:"BEFORE_CHUL_CLOSE_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"후출고선마감수량",	SaveName:"AFTER_CHUL_CLOSE_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"후출고선마감금액",	SaveName:"AFTER_CHUL_CLOSE_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"미배송수량",			SaveName:"NOT_DELY_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"미배송금액",			SaveName:"NOT_DELY_AMT"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"창고재고수량",			SaveName:"STOCK_QTY"}
   		,{ Align:"right",	Width:120,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Float",		PointCount:3,		Header:"창고재고금액",			SaveName:"STOCK_AMT"}
   	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	// 조회조건 초기화
	kepSetCalenderYearMonth("st_from_date");
	kepSetCalenderYearMonth("st_to_date");
	
	// 조회조건 일자 설정
	$("#st_from_date").val( kepGetNowTimeStr('YYYYMM','/').substring(0, 5) + "01" );
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMM','/').substring(0, 5) + "12" );
}
	
var st;
var mt;
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {

	switch (str) {
		case "search": // 조회
			current_page = -1;
			if ( !searchValidate() )
				return;
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClRecinpayTotalList.do" , pagingMode );
			break;
		
		case "excelDown": // 엑셀다운로드
			var param = {FileName:"수불집계표.xlsx"};
			kepDownExcel(document.searchCondition ,mySheet , "/cmcl/excelMasterCmClRecinpayTotalList.do", param);
			break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}

// 조회조건 체크
function searchValidate() {
	var start_date = $("#st_from_date").val().replace(/[/]/gi,"");
	var end_date = $("#st_to_date").val().replace(/[/]/gi,"");
	
	if ( start_date > end_date ) {
		alert("조회 종료일은 시작일보다 작을 수 없습니다");
		return false;
	}

	return true;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
   	
	if (msg != "") {
		alert(msg);
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>수불집계표</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
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
					<caption>수불집계표</caption>
					<colgroup>
						<col width="8%" />
						<col width="92%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th><font color="#FF6600">*</font>조회기간</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c; padding-bottom:10px;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		
		<!--버튼영역-->
            <div class="btnArea">
          	<span class="fl">
				<span class="btn_05 mr04" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>
		 </div>
    
<!--내용 종료-->	                 

</body>
</html>
