<%--
**********************************************
* 메뉴(운영사) : 납품관리 > 납품일변경현황
* 화면 : 납품일변경현황
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2015-12-23일
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
	         		{ Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
	        		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
	               	,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,		Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
	               	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,		Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
	               	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"발주항번",	SaveName:"PO_SEQ"}
	               	,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Type:"Text",	Header:"확인자명",	SaveName:"CONFIRM_USER_NM"}
	               	,{ Align:"Left",	Width:120,	Edit:false,	EditLen:140,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
	               	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
	               	,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"품명",	SaveName:"DESCRIPTION"}
	               	,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
	               	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"I/F발주번호",	SaveName:"LEGACY_PO_NO"}
	               	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"I/F발주항번",	SaveName:"LEGACY_PO_SEQ"}
	               	,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"발주수량",	SaveName:"ITEM_QTY"}
	               	,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"납품수량",	SaveName:"IV_QTY"}
	               	,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"확정수량",	SaveName:"DI_QTY"}
	               	,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"입고수량",	SaveName:"GR_QTY"}
	               	,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"변경전",SaveName:"BEFORE_DATA"}
	               	,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"변경후",SaveName:"AFTER_DATA"}
	               	,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"변경일",SaveName:"ADD_DATE"}
	               	,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"확인일",SaveName:"CONFIRM_DATE"}
	               	,{ Align:"Center",	Width:10,	Edit:false,	Hidden:true,  EditLen:100,	Type:"Text",	Header:"차수",	SaveName:"REVISION"}
	               	,{ Align:"Center",	Width:10,	Edit:false,	Hidden:true,  EditLen:100,	Type:"Text",	Header:"BYCA_COMORG_CODE",	SaveName:"BYCA_COMORG_CODE"}
	               	,{ Align:"Center",	Width:10,	Edit:false,	Hidden:true,  EditLen:100,	Type:"Text",	Header:"BUYER",	SaveName:"BUYER"}
	               	,{ Align:"Center",	Width:10,	Edit:false,	Hidden:true,  EditLen:100,	Type:"Text",	Header:"CONTRACT_NO",	SaveName:"CONTRACT_NO"}
	               	,{ Align:"Center",	Width:10,	Edit:false,	Hidden:true,  EditLen:100,	Type:"Text",	Header:"CONTRACT_SEQ",	SaveName:"CONTRACT_SEQ"}
	               	,{ Align:"Center",	Width:10,	Edit:false,	Hidden:true,  EditLen:100,	Type:"Text",	Header:"AGENT",	SaveName:"AGENT"}
	               	,{ Align:"Center",	Width:10,	Edit:false,	Hidden:true,  EditLen:100,	Type:"Text",	Header:"CONFIRM_ID",	SaveName:"CONFIRM_ID"}

	];

	IBS_InitSheet(mySheet, initsheet,pagingMode,"XLS");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "AGENT_NAME");
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	setLinkCol(mySheet, "CONFIRM_USER_NM");


	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M") );
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
	
	if(kepIsValueNull($("#st_gr_flag").val())||$("#st_gr_flag").val()== "GR"){
		$("#st_gr_flag").val("GR");
		$("#st_gr_flag_check").attr("checked", "checked");
	} else {
		$("#st_gr_flag").val("ALL");
		$("#st_gr_flag_check").removeAttr("checked");
	}
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
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str != "search" && str != "excelDown" && str != "reload" && str != "add" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if(!validCheck('true')){
				return;
			}
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvDeliveryDateList.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_agent_code").val("");
			$("#st_from_date").val(kepToMonthAdd("1","M","noslash"));
			$("#st_to_date").val(kepGetNowTimeStr("YYYYMMDD",""));
			$("#st_gr_flag").val("GR");
			$("#st_gr_flag_check").attr("checked", "checked");
			mySheet.RemoveAll();
			break;
	
		case "confirm": // 저장
			if ( !confirm('선택한 항목을 확인 하시겠습니까?') )
				return;
			var flag = "Y";
			var f_po_no = "";
			var f_po_seq = "";
			for ( var i = 0; i <= mySheet.RowCount(); i++ ) {											 
				if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
					 if(mySheet.GetCellValue(i, "CONFIRM_ID") != ""){
						 flag = "N";
						 f_po_no =mySheet.GetCellValue(i, "PO_NO");
						 f_po_seq =mySheet.GetCellValue(i, "PO_SEQ");
					 }
				}
			}
			if(flag == "N"){
				alert("PO번호: "+f_po_no+", PO항번: "+f_po_seq+" 이미 확인된 건입니다.");
				return;
			}
			kepSave(document.searchCondition ,  mySheet , "/mpiv/saveMasterMpIvDeliveryDateList.do" , "SELECTED" );
			break;
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
				return;
			}
		
			if (kepIsValueNull($('#st_buyer_code').val())){
				alert("고객사는 필수입니다.");
				return;
			}
		
		    $("#pageflag").val('0');
			var fromTo =  $("#st_from_date").val().replace(/\//gi, "") + "_" + $("#st_to_date").val().replace(/\//gi, "");
		    var param = {FileName:"납기일변경현황_"+fromTo+".xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NAME|PO_NO|PO_SEQ|CONFIRM_USER_NM|AGENT_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|LEGACY_PO_NO|LEGACY_PO_SEQ|ITEM_QTY|IV_QTY|DI_QTY|GR_QTY|BEFORE_DATA|AFTER_DATA|ADD_DATECONFIRM_DATE|"};
		    kepDownExcel(document.searchCondition ,mySheet , "/mpiv/excelMasterMpIvDeliveryDateList.do", param);
			$("#pageflag").val('1');
			break;
	}
}
//조회조건 체크
function validCheck() {
 	var buyer_code      = $("#st_buyer_code").val();
	
	if(buyer_code == "") {
		alert("고객사를 선택해 주십시요.");
		return false;
	}

	return true;
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
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
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
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvDeliveryDateList.do?page="+current_page , pagingMode );
}


//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer";
			break;
		case "seller": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller";
			break;
	}
}
//확인완료 제외 이벤트
function setCheckBox(){
	
	if($("#st_gr_flag_check").is(":checked")){
		$("#st_gr_flag").val("GR");
		
	} else {
		$("#st_gr_flag").val("ALL");
		
	}
}	
// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer") {	// 구매회원사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);	
	} else if (popupSel == "seller") {	// 협력회원사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

	if ( Row  < 1) return;  
	
	var column = mySheet.ColSaveName(Col);
	if (column == 'PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO,'900,550,no');
	}else if (column == 'BUYER_NAME') { // 고객사
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+BUYER, '800,550,no');
	} else if (column == 'AGENT_NAME') { // 협력사
		var AGENT = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+AGENT,'800,550,no');
	} else if (column == 'CONFIRM_USER_NM') { // 확장자
		var ID = mySheet.GetCellValue(Row,"CONFIRM_ID");
		openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(Row,"BYCA_COMORG_CODE");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		openSearchPopup('/common/catalogDetailPop.do','?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo+'&CONTRACT_NO='+contractNo+'&CONTRACT_SEQ='+contractSeq,'800,290,no');
	} 
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
       			<h3>납기일 변경현황</h3>
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
				<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
   		</div>             				
		<form name="searchCondition" id="searchCondition" method = "post" onsubmit="return false">
			<!-- HIDDEN -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<div id="cont_searchA">
				<table  class="cont_t_list01" >
					<caption>납기일지연현황</caption>
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
							<th>변경일</th>
							<td colspan="3">
								<input type="text"   name="st_from_date" size="10" id="st_from_date" class="input_type_text"  value="" readonly>
								&nbsp;~&nbsp;
								<input type="text"   name="st_to_date" size="10" id="st_to_date" class="input_type_text"  value="" readonly>
								
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>	
							</td>
							<td colspan="2">
								<input type="checkbox" class="Noborder" id="st_gr_flag_check" name="st_gr_flag_check"  value="" onChange="setCheckBox();" <%--=(pGrFlag.equals("GR") ? "checked" : "")--%>>
								<input type="hidden"   id="st_gr_flag" name="st_gr_flag" value="" />
								<b><font color="#333333">확인건제외</font></b>
							</td>
						</tr>
						<tr>
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "" READONLY>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
								<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
							<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
								<a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>I/F발주번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_legacy_po_no" id="st_legacy_po_no" style="width:90%;" value =""  onKeyDown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value =""  onKeyDown="kepEnter()">
							</td>
							<th></th>
							<td></td>
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
			<div class="ib_product" style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "100%", "354px");
				</script>
			</div>
	  			<p class="paging" id="pageindex"></p>
  			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('confirm');">확인</a></span>
  					<span class="btn_06"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  			 </div>
	
<!--내용 종료-->	       
	
</body>
</html>			
