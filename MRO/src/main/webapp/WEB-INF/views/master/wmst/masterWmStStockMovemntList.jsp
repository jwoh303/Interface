<%--
**********************************************
* 메뉴 : 재고>재고이동>재고이동 조회
* 화면 : 재고이동 조회
* 기능 : 
* 프로그램 ID : PG_08_M_040_00
* 담당자 : 이수영 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var printOn="/resources/images/icon_print.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
				{ Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",					SaveName:"sStatus"}
				,{ Align:"Center",	Width:60,		Edit:true,	EditLen:100,	Hidden:true,	Type:"DummyCheck",	Header:"",							SaveName:"SELECTED"}
				,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"재고이동요청번호",	SaveName:"MOVE_NO"}
				,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"재고이동요청순번",	SaveName:"MOVE_SEQ"}
				,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"출발물류센터",			SaveName:"WAREHOUSE_CODE_FR"}
				,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"도착물류센터",			SaveName:"WAREHOUSE_CODE_TO"}
				,{ Align:"Left",	Width:210,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"출발물류센터",			SaveName:"WAREHOUSE_CODE_FR_TEXT"}
				,{ Align:"Left",	Width:210,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"도착물류센터",			SaveName:"WAREHOUSE_CODE_TO_TEXT"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"진행상태",				SaveName:"STATUS"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"진행상태",				SaveName:"STATUS_TEXT"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",			Header:"출력",					SaveName:"STATUS_IMG"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목코드",				SaveName:"STDCATLG_ID"}
				,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목명",					SaveName:"DESCRIPTION"}
				,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"규격",					SaveName:"SPECIFICATION"}
				,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"단위",					SaveName:"UNIT_MEASURE"}
				,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"이동요청수량",			SaveName:"REQ_QTY"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동요청일자",			SaveName:"REQ_DATE"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동요청등록일자",	SaveName:"ADD_DATE"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동요청등록시간",	SaveName:"ADD_TIME"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동요청자",			SaveName:"REQ_USER_NM"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"이동요청자",			SaveName:"REQ_USER_ID"}
				,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"이동출고수량",			SaveName:"INV_QTY"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동출고일자",			SaveName:"INV_DATE"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동출고시간",			SaveName:"INV_TIME"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동출고자",			SaveName:"INV_USER_NM"}
				,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"이동입고수량",			SaveName:"GR_QTY"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"이동입고일자",			SaveName:"GR_DATE"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동입고시간",			SaveName:"GR_TIME"}
				,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이동입고자",			SaveName:"GR_USER_NM"}
				,{ Align:"Left",	Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"비고",					SaveName:"MOVE_REMARK"}
				,{ Align:"Left",	Width:300,	Edit:true,	EditLen:500,	Hidden:true,	Type:"Text",				Header:"비고",					SaveName:"CONTRACT_NO"}
				,{ Align:"Left",	Width:300,	Edit:true,	EditLen:500,	Hidden:true,	Type:"Text",				Header:"비고",					SaveName:"CONTRACT_SEQ"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	setLinkCol(mySheet, "STDCATLG_ID");
	setLinkCol(mySheet, "STATUS_IMG");
	
	mySheet.SetImageList(1, printOn);
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');
	kepAjaxCommonQueryIdCombo('st_warehouse_code','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseFrList','SEL','');							//출발물류센터

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

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str != "warehouseCode" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if(kepGetDateDiff("st_to_date" ,"st_from_date" ,'M' ) +3 < 0 ){
				alert('조회는 3개월 이내만 가능 합니다.');
				return ;
			} 		
			if ($("#st_warehouse_code_fr").val() == "") {
				alert("출발물류센터를 선택해주십시요.");
				$("#st_warehouse_code_fr").focus();
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/wmst/getMasterWmStStockMovemntList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
				mySheet.RemoveAll();
			break;
		case "warehouseCode":
			kepAjaxCommonQueryIdSearchTwoCombo('st_warehouse_code_to','master.mpso.getMasterMpSoStockMovemntRequestRegWareHouseToList', $("#st_warehouse_code_fr").val(), '', 'SEL','');		//도착물류센터
			break;	
		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
		    var param = {FileName:"재고이동조회.xlsx",Merge:1,SheetDesign:1,DownCols:"MOVE_NO|MOVE_SEQ|WAREHOUSE_CODE_FR_TEXT|WAREHOUSE_CODE_TO_TEXT|STATUS|STDCATLG_ID|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|REQ_QTY|REQ_DATE|REQ_TIME|REQ_USER_NM|INV_QTY|INV_DATE|INV_TIME|INV_USER_NM|GR_QTY|GR_DATE|INV_TIME|INV_USER_NM|MOVE_REMARK"};
			kepDownExcel(document.searchCondition ,mySheet , "/wmst/excelMasterWmStStockMovemntList.do", param);
			$("#pageflag").val('1');
			break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

function doPop(str, val1, val2, val3, val4) {
	switch (str) {
		case "stdcatlg":
			openSearchPopup('/wmco/showMasterWmCoGoodsCodePop.do','?BUYER_ITEM_NO='+val1+'&BYIT_COMORG_CODE='+val2+'&CONTRACT_NO='+val3+'&CONTRACT_SEQ='+val4, "800,255,no");
			break;
		case "offPrint":
			//var param =  "["+val1+"]["+val2+"]["+val3+"]["+val4+"]";
			//var rpt_url = "RD_08_M_006_69^RD_08_M_006_69_01^RD_08_M_005_06";
			//openTranStatReportOpen(rpt_url, param);
			
			var url ="/coco/showReportViewer.do";
			//window.open( url +""+"?fileName=RD_08_M_006_69&param="+param, "trPrewMRD", "width=770,height=800,resizable=YES,top=0,left=50");
			//window.open( url +""+"?fileName=RD_08_M_006_69_01&param="+param, "trPrewMRD2", "width=770,height=800,resizable=YES,top=100,left=50");
			//window.open( url +""+"?fileName=RD_08_M_005_06&param="+param, "trPrewMRD3", "width=770,height=800,resizable=YES,top=200,left=50");
			
			// 재고이동지시서
			var params = [];
			params.push({ key: "fileName", value: "RD_08_M_006_85" });
			params.push({ key: "param", value: "["+val3+"]" });
			OpenReportPost(url, "POP", params);
			
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

function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'STDCATLG_ID') {
		doPop("stdcatlg", mySheet.GetCellValue(grbRow,"STDCATLG_ID"), mySheet.GetCellValue(grbRow,"WAREHOUSE_CODE_FR"), mySheet.GetCellValue(grbRow,"CONTRACT_NO"), mySheet.GetCellValue(grbRow,"CONTRACT_SEQ"));
	} else if (column == 'STATUS_IMG') {
		if (mySheet.GetCellValue(grbRow,"STATUS") == "2" || mySheet.GetCellValue(grbRow,"STATUS") == "3") {
			doPop("offPrint", mySheet.GetCellValue(grbRow,"WAREHOUSE_CODE_TO"), mySheet.GetCellValue(grbRow,"WAREHOUSE_CODE_FR"), mySheet.GetCellValue(grbRow,"MOVE_NO"), mySheet.GetCellValue(grbRow,"REQ_USER_ID"));
		}
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStStockMovemntList.do?page="+current_page , pagingMode );
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>재고이동 조회</h3>
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
					<caption>재고이동 조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>이동요청일</td>
							<td colspan="5">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
						</tr>
						<tr>
							<td>
								<select id="st_gubun" name="st_gubun" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="F">출발물류센터</option>
									<option value="T">도착물류센터</option>
									
								</select>
							</td>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:80%;height:20px" ></select>
							</td>
							<td>재고이동번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_move_no" name="st_move_no" style="width:80%;" value="" onkeyup="kepToUpper('st_move_no')" onkeydown="kepEnter()" />
							</td>
						</tr>
						<tr> 
							<td>품목코드</td>
							<td>
								<input type="text" class="input_type_text" id="st_stdcatlg_id" name="st_stdcatlg_id" style="width:80%;" value="" onkeyup="kepToUpper('st_stdcatlg_id')" onkeydown="kepEnter()" />
							</td>
							<td>품목명</td>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:80%;" value="" onkeydown="kepEnter()" />
							</td>
							<td>진행상태</td>
							<td>
								<select id="st_status" name="st_status" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="1">이동요청</option>
									<option value="2">이동출고</option>
									<option value="3">이동입고</option>
									<option value="9">요청취소</option>
								</select>
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
  					createIBSheet("mySheet", "100%", "334px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
