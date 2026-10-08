<%--
**********************************************
* 메뉴 : I/F관리 > I/F진행현황 > 발주오류현황(공)
* 화면 : 발주오류현황(공)
* 기능 : 공급사로 전송할 발주 정보중에서 오류가 발생한 데이터를 조회
* 프로그램 ID : 
* 담당자 : 최진수
* 착수일 : 2019-07-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_user_id = _sessionInfo.getUserId();
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var today = kepGetNowTimeStr("YYYYMMDD","");
var fromDate = kepToDateAdd("7","M","noslash");
var toDate = kepToDateAdd("7","P","noslash");

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};	
	initsheet.Cols = [ 
		 			 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
					,{ Align:"Center",	SaveName:"STATUS_NM",		Header:"진행상태", 		Type:"Text", Width:80,	Edit:false}
					,{ Align:"Left",	SaveName:"IF_MSG", 			Header:"오류내역", 		Type:"Text", Width:130, Edit:false} 
					,{ Align:"Left",	SaveName:"AGENT_NAME", 		Header:"협력사명", 		Type:"Text", Width:130, Edit:false}
					,{ Align:"Left",	SaveName:"BUYER_NAME", 		Header:"고객사명", 		Type:"Text", Width:130, Edit:false}
					,{ Align:"Center",	SaveName:"PO_NO", 			Header:"발주번호", 		Type:"Text", Width:100, Edit:false}
					,{ Align:"Center",	SaveName:"BUYER_ITEM_NO", 	Header:"품목코드", 		Type:"Text", Width:100, Edit:false}
					,{ Align:"Center",	SaveName:"SELLER_ITEM_NO", 	Header:"협력사품목코드",	Type:"Text", Width:100, Edit:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION", 	Header:"품목명", 			Type:"Text", Width:150, Edit:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION", 	Header:"규격", 			Type:"Text", Width:150, Edit:false}
					,{ Align:"Right",	SaveName:"UNIT_PRICE", 		Header:"매출단가", 		Type:"Float",	 Format:"${priceFormat}",	 Width:80, 	Edit:false}
					,{ Align:"Right",	SaveName:"LIST_PRICE", 		Header:"매입단가", 		Type:"Float",	 Format:"${priceFormat}",	 Width:80, 	Edit:false}
					,{ Align:"Right",	SaveName:"ITEM_QTY", 		Header:"발주수량", 		Type:"Float",	 Format:"${priceFormat}",	 Width:80, 	Edit:false}
					,{ Align:"Center",	SaveName:"PO_CREATE_DATE", 	Header:"발주일", 			Type:"Date", Width:80, 	Edit:false}
					,{ Align:"Center",	SaveName:"RD_DATE", 		Header:"납기요청일", 		Type:"Date", Width:80,	Edit:false}
					,{ Align:"Center",	SaveName:"UNIT_MEASURE", 	Header:"단위", 			Type:"Text", Width:60, 	Edit:false}
					,{ Align:"Right",	SaveName:"ITEM_AMT", 		Header:"금액", 			Type:"Float",	 Format:"${priceFormat}",  Width:80, 	Edit:false}
					
					,{ SaveName:"BUYER",		Header:"BUYER",	Hidden:true}
					,{ SaveName:"AGENT",		Header:"AGENT",	Hidden:true}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

}
	
// 기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var buyer_code      = $("#st_buyer_code").val();
			var agent_code      = $("#st_agent_code").val();
			
			if(buyer_code == "" && agent_code == "") {
				alert("고객사 또는 협력사를 선택해 주십시요.");
				return;
			}

			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>92){
				alert("3개월내 조회만 가능합니다.");
				return;
			}

			current_page = -1;
			pagingMode = "N";
			kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfSellerPoErrList.do" , pagingMode );
			
			break;
		case "excelDown":	 // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var buyer_code      = $("#st_buyer_code").val();
			var agent_code      = $("#st_agent_code").val();
			
			if(buyer_code == "" && agent_code == "") {
				alert("고객사 또는 협력사를 선택해 주십시요.");
				return;
			}
			
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>92){
				alert("3개월내 조회만 가능합니다.");
				return;
			}
		    $("#pageflag").val('0');
			var fromTo =  $("#st_from_date").val().replace(/\//gi, "") + "_" + $("#st_to_date").val().replace(/\//gi, "");
		    var param = {FileName:"발주오류현황(공)_"+fromTo+".xlsx",Merge:1,SheetDesign:1,DownCols:"PO_STATUS_NM|BUYER_NAME|BUYER_ITEM_NO|DESCRIPTION|PO_NO|UNIT_PRICE|ITEM_QTY|REMAIN_QTY|PO_DATE|DS_DATE|INVOICE_NO|AGENT_NAME|UNIT_MEASURE|SPECIFICATION|LEGACY_PO_NO|UNIT_SUM|INV_QTY|RD_DATE|DELIVERY_QTY|DELIVERY_DATE|PARCEL_COM_NM|PARCEL_INV_NO"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpif/excelMasterMpIfSellerPoErrList.do", param);
			$("#pageflag").val('1');
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition'); 
			$("#st_buyer_code").val("");
			$("#st_agent_code").val("");
			 
			mySheet.RemoveAll();
	
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
			
			break;

		case "resend": // 재전송
			if (!confirm('선택한 대상을 삭제 후 이벤트 등록을 진행합니다.\n작업은 고객사,발주번호 기준으로 일괄 진행됩니다.\n재전송 하시겠습니까?'))
				return;
			$("#job_kind").val("resend");
			kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpIfSellerPoErrReSend.do", "SELECTED");
			break;
	}
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
	
	var rowCnt = mySheet.RowCount();
	for(var i=1; i<=rowCnt;i++){
		var status = mySheet.GetCellValue(i, 'PO_STATUS_CD'); 
		
		if(status == "PO30" || status == "PO60") { 
			mySheet.SetCellFontColor(i,"DS_DATE","blue");
		}
	}
	
	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		// 저장 성공시 재조회
		doAction("search");
	}
}

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	
	pagingMode = "P";
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfSellerPoErrList.do?page="+current_page, pagingMode );
}

// 팝업함수호출
function doPop(str) {
	var st_buyer = kepReplaceAll("st_buyer_code","@","");
	
	switch (str) {
		case "buyerMulti": // 고객사 M
			openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B", "880,450,no");
			popupSel = "buyerMulti";
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
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var colVal = mySheet.GetCellValue(Row, Col);
	
	if(isEmpty(colVal)){
		return;				
	}
	
	if (column == 'PO_NO') { // 발주번호 - 수주접수 팝업
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var po_no = mySheet.GetCellValue(Row, "PO_NO");
		
		var param = "";
		param = "?st_buyer="+buyer+"&st_po_no="+po_no;
		
		alert(param);
		
		// 주문진행화면에서 사용하는 팝업 - 내용이 동일한거같은데...
		openSearchPopup("/common/mpso/poDetailPop.do", param, "900,550,no");
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	
	if (popupSel == "buyerMulti") {	
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(kepMultiName(text,"@"));
	} else if (popupSel == "seller") {	
		$("#st_agent_code").val(code);
		$("#st_agent_name").val(text);
	}		
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>발주오류현황(공)</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<!--HIDDEN-->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- input type="hidden" id="page" name="page" value="1"  -->
			
			<input type="hidden" id="st_rd_date" name="st_rd_date" value="" />
			
			<div id="cont_searchA">
			<!-- 화면 내 정의 -->
			<table  class="cont_t_list01" style="width:1024px;">
				<caption>발주오류현황(공)</caption>
				<colgroup>
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="23%" />
				</colgroup>
				<tbody>
					<tr>
						<th>발주일</th>
						<td colspan="3">
							<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" > - 
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" >
								&nbsp;&nbsp;
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						</td>
						<th>발주번호</th>
	                    <td class ="font1_table_font">
	                    	<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
	                    </td>
					</tr>
					<tr>
						<th><font color="red"><b>*</b></font>고객사</th>
						<td>
	                        <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "">
	                        <input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th><font color="red"><b>*</b></font>협력사</th>
							<td>
		                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
		                        <input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
		                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                            </td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value =""  onKeyDown="kepEnter()">
						</td>
					</tr>
				</tbody>
			</table>
			</div>
			<span class="fl"  style="padding-top:8px;">
				<img src="/resources/images/txt_no.gif" alt="정렬개수" />
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>&nbsp;
			</span>
		</form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			<!--버튼영역-->
<%  
		if(st_user_id.indexOf("KEPC") < 0){ %>
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_04 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>

		  		<span class="fr">
		  			<span class="btn_02"><a href="javascript:doAction('resend');">재전송</a></span>
		  		</span>
  			 </div>
<%	}%>
<!--내용 종료-->	                 

</body>
</html>
