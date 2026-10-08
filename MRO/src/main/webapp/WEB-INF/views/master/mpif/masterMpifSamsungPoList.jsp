<%--
**********************************************
* 메뉴 : IF관리 > IF진행핸황
* 화면 : 삼성전자 발주현황
* 기능 : 삼성전자 발주 IF 목록 기준으로 조회한다.
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_user_dept = ""; //사용자 부서
if (_sessionInfo != null){
	st_user_dept = _sessionInfo.getDepartment();
}
%> 
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
		     {Align : "Center", SaveName : "SELECTED",          Header : " ",				Type : "DummyCheck",     Width 	: 50,      Edit : true}
		    ,{Align : "Center", SaveName : "PROGRESS_TEXT",		Header : "진행상태",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "LEGACY_PO_NO",		Header : "IF발주정보",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "LEGACY_PO_SEQ",		Header : "IF발주항번",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "PO_REQ_NO",			Header : "IF차수",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "PO_GB_TEXT",		Header : "발주구분",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "KEP_PO_NO",			Header : "발주정보",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "KEP_PO_SEQ",		Header : "발주항번",			Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "PO_DATE",			Header : "발주일",			Type : "Date",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Right", 	SaveName : "KEP_PO_QTY",		Header : "발주수량",			Type : "Float",		EditLen : 100,             Width : 60,		Edit : false,	Format:"Float"}
			,{Align : "Right", 	SaveName : "IF_PO_QTY",			Header : "IF발주수량",			Type : "Float",		EditLen : 100,             Width : 60,		Edit : false,	Format:"Float"}
			,{Align : "Right", 	SaveName : "GR_QTY",			Header : "입고수량",			Type : "Float",		EditLen : 100,             Width : 60,		Edit : false,	Format:"Float"}
			,{Align : "Center", SaveName : "KEP_RD_DATE",		Header : "납기요청일",			Type : "Date",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "IF_RD_DATE",		Header : "IF납기요청일",		Type : "Date",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "STD_RD_DATE",		Header : "표준납기일수",		Type : "Text",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Right", 	SaveName : "UNIT_PRICE",        Header : "매출단가",			Type : "Float",		EditLen : 100,             Width : 70,		Edit : false,	Format:"${priceFormat}"}
			,{Align : "Right", 	SaveName : "ITEM_AMT",			Header : "매출금액",			Type : "Float",		EditLen : 100,             Width : 80,		Edit : false,	Format:"${priceFormat}"}
			,{Align : "Right", 	SaveName : "AGENT_PRICE",       Header : "매입단가",			Type : "Float",		EditLen : 100,             Width : 70,		Edit : false,	Format:"${priceFormat}"}
			,{Align : "Right", 	SaveName : "AGENT_ITEM_AMT",    Header : "매입금액",			Type : "Float",		EditLen : 100,             Width : 80,		Edit : false,	Format:"${priceFormat}"}
			,{Align : "Right", 	SaveName : "IF_PRICE",          Header : "IF단가",			Type : "Float",		EditLen : 100,             Width : 70,		Edit : false,	Format:"${priceFormat}"}
			,{Align : "Center", SaveName : "IF_CURRENCY_CODE",	Header : "IF화폐",			Type : "Text",		EditLen : 100,             Width : 55,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "BUYER_ITEM_NO",		Header : "품목코드",			Type : "Text",		EditLen : 100,             Width : 130,		Edit : false, ToolTip:true}
			,{Align : "Left", 	SaveName : "DESCRIPTION",		Header : "품목명",			Type : "Text",		EditLen : 250,             Width : 130,		Edit : false, ToolTip:true}
			,{Align : "Left", 	SaveName : "SPECIFICATION",		Header : "규격",				Type : "Text",		EditLen : 250,             Width : 200,		Edit : false, ToolTip:true}
			,{Align : "Left", 	SaveName : "MAKER_NAME",		Header : "제조사",			Type : "Text",		EditLen : 100,             Width : 100,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "UNIT_MEASURE",		Header : "단위",				Type : "Text",		EditLen : 100,             Width : 55,		Edit : false, ToolTip:true}
			,{Align : "Left", 	SaveName : "AGENT_NAME",		Header : "협력사명",			Type : "Text",		EditLen : 100,             Width : 110,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "PROCESS_TEXT",		Header : "거래유형",			Type : "Text",		EditLen : 100,             Width : 60,      Edit : false}  
			,{Align : "Left", 	SaveName : "PLANT_NAME",		Header : "플랜트",			Type : "Text",		EditLen : 200,             Width : 200,		Edit : false, ToolTip:true}
			,{Align : "Center", SaveName : "PO_USER_NAME",      Header : "발주자",			Type : "Text",		EditLen : 100,             Width : 60,		Edit : false}
			,{Align : "Left", 	SaveName : "BUDGET_DEPT_NAME",  Header : "발주부서",			Type : "Text",		EditLen : 200,             Width : 200,		Edit : false}
			,{Align : "Center", SaveName : "PR_USER_NAME",      Header : "요청자",			Type : "Text",		EditLen : 100,             Width : 60,		Edit : false}
			,{Align : "Center", SaveName : "PLANT_USER_NM",     Header : "플랜트담당자",		Type : "Text",		EditLen : 100,             Width : 60,		Edit : false}
			,{Align : "Center", SaveName : "BUDGET_DEPT_CODE",  Header : "발주부서코드",		Type : "Text",		EditLen : 100,             Width : 60,		Edit : false, Hidden:true}
			,{Align : "Center", SaveName : "PLANT",  			Header : "플랜트코드",			Type : "Text",		EditLen : 100,             Width : 60,		Edit : false, Hidden:true}
			,{Align : "Center", SaveName : "PROGRESS_STATUS",  	Header : "진행상태코드",		Type : "Text",		EditLen : 100,             Width : 60,		Edit : false, Hidden:true}
			,{Align : "Center", SaveName : "PO_GB",				Header : "발주구분코드",		Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, Hidden:true}
			,{Align : "Center", SaveName : "SYS_CODE",			Header : "SYS_CODE",		Type : "Text",		EditLen : 100,             Width : 80,		Edit : false, Hidden:true}
			,{Align : "Center", SaveName : "IF_DATE",			Header : "IF전송일시",		Type : "Text",		EditLen : 100,             Width : 80,		Edit : false}
			,{Align : "Center", SaveName : "IF_CREATE_DATE",    Header : "IF수신일시",		Type : "Text",		EditLen : 100,             Width : 115,		Edit : false}
			,{Align : "Center", SaveName : "CANCEL_DATE",    Header : "취소 일시",		Type : "Text",		EditLen : 100,             Width : 115,		Edit : false}
			,{Align : "Center", SaveName : "CANCEL_RSON",    Header : "취소 사유",		Type : "Text",		EditLen : 100,             Width : 115,		Edit : false}
			,{Align : "Center", SaveName : "CANCEL_ID",    Header : "취소자",		Type : "Text",		EditLen : 100,             Width : 115,		Edit : false}
			
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));//PLANT담당자 콤보데이터 셋팅. 로그인  부서 기준 사용자 리스트
	var st_user_dept = "<%=st_user_dept%>";
	kepAjaxCommonQueryIdSearchTwoCombo('st_plant_user_id','common.masterDepartmentUserList','',st_user_dept,'ALL','');
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

		if(!validCheck('true')){
			return;
		}
		$("#re_current_page").val(1);
		current_page = -1;
		
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpifSamsungPoList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		$("#re_current_page").val(1);
		$( '#searchCondition' )[0].reset();

		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.RemoveAll();
		$("#st_agent_code").val("");
		document.getElementById("st_checkbox").checked = false;
		
		break;
	case "accept":	 // 확인
		var arrRow = selectedGrid.split("|");
		for(var i = 0 ; i <arrRow.length; i++){
			if (mySheet.GetCellValue(arrRow[i],'PROGRESS_STATUS') != "00") {
				alert("진행상태 대기인 대상만 처리할 수 있습니다.");
				return;
			}
		}
		if (!confirm('선택한 항목을 확인처리 하시겠습니까?'))
			return;
		$("#job_kind").val("accept");
		$("#st_if_progress_status").val("02");
		kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpifSamsungPoReturn.do", "SELECTED");
	    break;
	case "reject":	 // 불가
		var arrRow = selectedGrid.split("|");
		for(var i = 0 ; i <arrRow.length; i++){
			if (mySheet.GetCellValue(arrRow[i],'PROGRESS_STATUS') != "00") {
				alert("진행상태 대기인 대상만 처리할 수 있습니다.");
				return;
			}
		}
		if (!confirm('선택한 항목을 불가처리 하시겠습니까?'))
			return;
		$("#job_kind").val("reject");
		$("#st_if_progress_status").val("03");
		kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpifSamsungPoReturn.do", "SELECTED");
	    break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"삼성전자_발주현황.xlsx",DownCols:"PROGRESS_TEXT|LEGACY_PO_NO|LEGACY_PO_SEQ|PO_REQ_NO|PO_GB_TEXT|KEP_PO_NO|KEP_PO_SEQ|PO_DATE|KEP_PO_QTY|IF_PO_QTY|GR_QTY|KEP_RD_DATE|IF_RD_DATE|STD_RD_DATE|UNIT_PRICE|ITEM_AMT|AGENT_PRICE|AGENT_ITEM_AMT|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|AGENT_NAME|PROCESS_TEXT|PLANT_NAME|PO_USER_NAME|BUDGET_DEPT_NAME|PR_USER_NAME|PLANT_USER_NM|BUDGET_DEPT_CODE|PLANT"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpif/excelMasterMpifSamsungPoList.do", param);
		$("#pageflag").val('1');
		break;
	}
}

function validCheck() {

 	var buyer_code      = $("#st_buyer_code").val();
	var agent_code      = $("#st_agent_code").val();
	
	if(buyer_code == "" && agent_code == "") {
		alert("고객사 또는 협력사를 선택해 주십시요.");
		return false;
	}

	var buyer_item_no	= $("#st_buyer_item_no").val();//f.st_buyer_item_no.value;
	var if_po_no        = $("#st_if_po_no").val();//f.st_if_po_no.value;
	var po_no           = $("#st_po_no").val();
	var ref_no          = $("#st_ref_no").val();
	var po_req_no       = $("#st_po_req_no").val();
	
	var checkAll = 'N';

    if(document.getElementById("st_checkbox").checked == true){
		if( buyer_item_no =="" &&  if_po_no =="" && po_no =="" ){
			alert("기간을 무시하고 조회시\n\n품목코드, I/F발주번호, 발주번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 조회가 됩니다.");	
			return false;
		}
		checkAll ="Y";
		$("#st_all_po").val('Y');
	}else{
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
			alert("조회기간을 1개월 단위로 조회가 가능합니다.\n\n1개월 이상의 데이타는 S/R 요청 바랍니다.");
			return false;
		}
		checkAll = 'N';
		$("#st_all_po").val('N');
	}
	return true;
}

//그리드 표시후 처리	 
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
	
	var totRow = mySheet.RowCount();
 
	if(current_page==-1){
		$("#re_current_page").val(1);
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		$("#re_current_page").val(current_page);
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
/*
	if ( msg != "" ) {
		alert(msg);
	}
*/
	if ( code >= 0 ) {
		if ( $("#job_kind").val() == "reject" ) {
			alert("불가처리 완료했습니다.");
		}
		
		if ( $("#job_kind").val() == "accept" ) {
			alert("확인처리 완료했습니다.");
		}
		doAction("search");
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
// 	alert(downloadType + ' 다운이 완료되었습니다. \n 다운로드 결과 : ' + ((result==true)?'성공':'실패'));
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    pagingMode = "P";
	current_page = param.page;
	$("#re_current_page").val(current_page);
	kepSearch(document.searchCondition ,  mySheet , "/mpif/getMasterMpifSamsungPoList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	var st_buyer = kepReplaceAll("st_buyer_code","@","");
	
	switch (str) {
		case "seller": // 협력사
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', "500,466,no");
			break;
		case "podept": // 발주부서
			if(st_buyer == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			var comCodeArr = st_buyer.split("@");
			openSearchPopup('/common/deptCodeAdminPop.do','?open=N&com_code='+comCodeArr[0], '500,500,no');
			popupSel = "podept";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "podept") {	
		$("#st_po_dept_code").val(value1);
		$("#st_po_dept_name").val(value2);
	}else if(popupSel == "seller") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>삼성전자 발주현황</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			<input type="hidden" name="st_doc_type"  id="st_doc_type" value ="">
			<input type="hidden" name="st_multi_buyer_code" id="st_multi_buyer_code" style="width:100px;" value ="">
			<input type="hidden" name="st_multi_buyer_name" id="st_multi_buyer_name" style="width:100px;" value ="">
			<input type="hidden" name="st_com_code" id="st_com_code" style="width:100px;" value ="">
			<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value ="KRSAMS0123">
			<input type="hidden" name="job_kind" id="job_kind" value="">
			<input type="hidden" name="st_if_progress_status" id="st_if_progress_status" value="">

			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="re_current_page" name="re_current_page"  value="">

		  <table  class="cont_t_list01">
		    <caption></caption>
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
					<th>발주일</th>
					<td colspan="3">
						<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" > - 
						<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" >
						<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>
						<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" >&nbsp;기간무시
					</td>
				    <th>처리구분</th>
				    <td>
         				<select id="st_po_gb" name="st_po_gb" style="width:200px;">
         					<option value="" >전체</option>
         					<option value="01">주문</option>
         					<option value="02">주문변경</option>
         					<option value="03">주문취소</option>
         					<option value="99">Close-PO</option>
         					<option value="98">Reopen-PO</option>
         				</select>
	             	</td> 
             	</tr>
				<tr>
					<th><font color="red"><b>*</b></font>협력사</th>
						<td>
	                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
	                        <input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                        </td>
					<th>품목코드</th>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;ime-mode:disabled; " value =""  maxlength="50"  onblur="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
					</td>
                    <td>PLANT 담당자</td>
                    <td class ="font1_table_font" >
                    	<select id="st_plant_user_id" name="st_plant_user_id" style="width:90%;height:20px"></select>
                    </td>
				</tr>
				<tr>
					<th>발주부서</th>
                    <td class ="font1_table_font">
                        <input type="text" class="input_type_text" name="st_po_dept_name" id="st_po_dept_name" style="width:70%;" value ="" READONLY>
                        <input type="hidden" name="st_po_dept_code" id="st_po_dept_code" style="width:100px;" value ="">
                        <a href="javascript:doPop('podept');"><img src="/resources/images/btn_search03.gif"></a>
                        <a href="javascript:kepEraser('st_po_dept_code','st_po_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                    </td>
                    <th>I/F 발주번호</th>
                    <td class ="font1_table_font">
                    	<input type="text" class="input_type_text" name="st_if_po_no" id="st_if_po_no" size="25" style="width:80%;ime-mode:disabled;" value ="" maxlength="30"  onblur="kepToUpper('st_if_po_no')" onKeyDown="kepEnter()">
                    </td>
					<th>발주번호</th>
                    <td class ="font1_table_font">
                    	<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;ime-mode:disabled;" value ="" maxlength="20"  onblur="kepToUpper('st_po_no')" onKeyDown="kepEnter()">
                    </td>
				</tr>
				<tr>
					<th>진행상태</th>
                    <td>
                    	<select id="st_progress_status" name="st_progress_status">
                    		<option value="">전체</option>
                    		<option value="00">대기</option>
                    		<option value="02">확인</option>
                    		<option value="03">불가</option>
                    	</select>
                    </td>
					<th>I/F 차수</th>
                    <td class ="font1_table_font">
                    	<input type="text" class="input_type_text" name="st_po_req_no" id="st_po_req_no" style="width:90%;ime-mode:disabled;" value ="" maxlength="20" onblur="kepToUpper('st_po_req_no')" onKeyDown="kepEnter()">
                    </td>
					<th></th>
                    <td >
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
		<table style="width:100%;">
		    <tr>
		        <td height="25" align = "left" valign="middle">
			            <span class="btn_06"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		        </td>
		        <td height="25" align = "right" valign="middle">
			            <span class="btn_06"><a href="javascript:doAction('accept');">확인</a></span>
			            <span class="btn_06"><a href="javascript:doAction('reject');">불가</a></span>
		        </td>
		    </tr>
		</table>
<!--내용 종료-->	                 
</body>
</html>