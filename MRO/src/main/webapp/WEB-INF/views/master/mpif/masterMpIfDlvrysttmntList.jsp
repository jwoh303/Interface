<%--
**********************************************
* 메뉴 : I/F 관리>오류현황>오류현황 납품
* 화면 : 오류현황 납품
* 기능 :
* 프로그램 ID : PG_11_M_005_00
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var imagePrifC="/resources/images/icon_prif_c.gif";
var imagePrifR="/resources/images/icon_prif_r.gif";
var imagePrifCancel="/resources/images/icon_prif_cancel.gif";
var imagePrifDelete="/resources/images/icon_prif_delete.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
   		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
   		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
   		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",			Header:"I/F상태",			SaveName:"IF_PROGRESS_IVDT"}
   		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"I/F상태",			SaveName:"IF_FLAG_PROGRESS"}
   		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사명",			SaveName:"BUYER_NAME"}
   		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER"}
   		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"납품번호",			SaveName:"LEGACY_IV_NO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"납품항번",			SaveName:"LEGACY_IV_SEQ"}
   		,{ Align:"Center",	Width:65,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",			Header:"상태(납품)",			SaveName:"IV_STATUS",			FontColor:"#1e90ff"}
   		,{ Align:"Center",	Width:65,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",			Header:"상태(발주)",			SaveName:"PO_STATUS",			FontColor:"#1e90ff"}
   		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"상태(납품)",			SaveName:"IV_EXCEL"}
   		,{ Align:"Center",	Width:55,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"상태(발주)",			SaveName:"PO_EXCEL"}
   		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"오류내역",			SaveName:"ERROR_MSG"}
   		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목코드",			SaveName:"BUYER_ITEM_NO"}
   		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"품목명",				SaveName:"DESCRIPTION"}
   		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"규격",				SaveName:"SPECIFICATION"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"발주수량",			SaveName:"ITEM_QTY"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"납품수량",			SaveName:"INV_QTY"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"기납품수량",		SaveName:"IV_QTY_IF"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",				Header:"입고수량",			SaveName:"GR_QTY"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"납품일",				SaveName:"INVOICE_DATE"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",				Header:"발주일",				SaveName:"PO_CREATE_DATE"}
   		,{ Align:"Left",	Width:80,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"거래유형",			SaveName:"PROCESS_TYPE_NM"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"주문번호",			SaveName:"LEGACY_PO_NO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"주문항번",			SaveName:"LEGACY_PO_SEQ"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"PR번호",			SaveName:"PR_NO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"PR항번",			SaveName:"PR_SEQ"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"PO번호",			SaveName:"PO_NO"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"PO항번",			SaveName:"PO_SEQ"}
   		,{ Align:"Left",	Width:120,	Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"협력사명",			SaveName:"AGENT_NAME"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"생성일자",			SaveName:"CREATE_DATE"}
   		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"생성시간",			SaveName:"CREATE_TIME",		Format:"Hms"}
   		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"작업일자",			SaveName:"LOAD_DATE"}
   		,{ Align:"Center",	Width:70,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",				Header:"작업시간",			SaveName:"LOAD_TIME",			Format:"Hms"}
   	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);

	mySheet.SetImageList(3, imagePrifC);
	mySheet.SetImageList(4, imagePrifR);
	mySheet.SetImageList(5, imagePrifCancel);
	mySheet.SetImageList(6, imagePrifDelete);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "IV_STATUS");	//상태(납품)
	setLinkCol(mySheet, "PO_STATUS");	//상태(발주)

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	// 초기화 설정
	resetValue();
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	var st_user_check = "<%=st_user_check%>";
	if(st_user_check== "Y"){
		$('#st_user_check').prop('checked',true);
	}
	
	if(processYN == "Y"){
		kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','','<%=st_user_dept%>');
		doAction("search");
	}
}

// 초기화 설정
function resetValue() {
	// 조회일자 설정
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','','${sessionInfo.department}');	
	
	// checkbox 설정
	$("input:checkbox[id='st_user_check']").attr("checked",false);
	$("input:checkbox[id='st_date_flag']").attr("checked",false);
	$("input:checkbox[id='st_if_flag']").attr("checked",true);

	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
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
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	if ( str == "search" ) {
		// 담당자 무시 checkbox
		var isCheckUser = $("#st_date_flag").is(":checked");

		if ( isCheckUser ) {
			$("#st_user_check_value").val("Y");
		} else {
			$("#st_user_check_value").val("N");
		}

		// 기간 무시 checkbox
		var isCheckDate = $("#st_date_flag").is(":checked");

		if ( isCheckDate ) {
			$("#st_date_flag").val("Y");
			$("#st_date_flag_value").val("Y");
		} else {
			$("#st_date_flag").val("N");
			$("#st_date_flag_value").val("N");
		}

		// 오류만 조회 checkbox
		var isCheckIF = $("#st_if_flag").is(":checked");

		if ( isCheckIF ) {
			$("#st_if_flag").val("Y");
			$("#st_if_flag_value").val("Y");
		} else {
			$("#st_if_flag").val("N");
			$("#st_if_flag_value").val("N");
		}
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfDlvrysttmntList.do", pagingMode);
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

		case "execute": // 실행
			if (!confirm('선택한 항목을 실행 하시겠습니까?'))
				return;
			kepSave(document.searchCondition, mySheet, "/mpif/saveMasterMpIfDlvrysttmntList.do", "SELECTED" );
			break;

		case "delete": // 납품 삭제(종결)
			if (!confirm('선택한 항목을 종결 하시겠습니까?'))
				return;
			$("#job_kind").val("delete");
			kepSave(document.searchCondition, mySheet, "/mpif/delMasterMpIfDlvrysttmntList.do", "SELECTED");
			break;

		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
		    var param = {FileName:"오류현황_납품.xlsx",Merge:1,SheetDesign:1,DownCols:"IF_FLAG_PROGRESS|BUYER_NAME|LEGACY_IV_NO|LEGACY_IV_SEQ|IV_EXCEL|PO_EXCEL|ERROR_MSG|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|INV_QTY|IV_QTY_IF|GR_QTY|INVOICE_DATE|PO_CREATE_DATE|PROCESS_TYPE_NM|LEGACY_PO_NO|LEGACY_PO_SEQ|PR_NO|PR_SEQ|PO_NO|PO_SEQ|AGENT_NAME|CREATE_DATE|CREATE_TIME|LOAD_DATE|LOAD_TIME"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpif/excelMasterMpIfDlvrysttmntList.do", param);
			$("#pageflag").val('1');
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
		alert("입고 종료일은 시작일보다 작을 수 없습니다");
		return false;
	}
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
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

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}

	if ( code >= 0 ) {
		if ( $("#job_kind").val() == "delete" ) {
			$("#st_cancel_remark").val("");
		}
		// 저장 성공시 재조회
		doAction('search');
	}
}

// Valitation - 발주 삭제(종결)
function validationDelete() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "IF_FLAG_PROGRESS") == 'D' ) {
			alert("이미 종결된 건이 존재합니다.");
			return false;
		}
	}

	return true;
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfDlvrysttmntList.do?page="+current_page, pagingMode);
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if ( column == 'IV_STATUS' || column == 'PO_STATUS' ) { // 상태(납품, 발주)
		window.open("/resources/html/common/popup/mpif/masterMpIfDlvrysttmntStatusPop.html", "mpIfDlvrysttmntStatus", "width=400,height=250,toolbar=no,location=no,resizable=yes,menubar=no,status=no,scrollbars=no");
	}

	return;
}

// 팝업함수호출
function doPop(str, params) {
	popupSel = str;

	switch (str) {
		case "masterWmCoTranBuyerPop": // 다중 거래고객사
			var st_user_dept = $("#st_user_dept").val();
			var ischecked = $("#st_user_check").is(":checked");
			var check_yn = '';
			if ( ischecked ) {
				check_yn = "Y";
			} else {
				check_yn = "N";
			}
			openSearchPopup('/wmco/showMasterWmCoTranBuyerPop.do', '?st_user_dept='+st_user_dept+'&st_user_check='+check_yn+'&Gubun=IV','500,500,no');
			break;

		case "buyerMulti": // 다중 고객사
// 	        openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=Y", "500,466,no"); // 1Grid
	        openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no'); // 2Grid
			break;

		case "cancelRemark": // I/F 종결 사유
			if ( !validationDelete() )
				return;
			var cancel_remark = $("#st_cancel_remark").val();
			openSearchPopup('/common/remarkCancelPop.do', '?viewType=interfaceCancel&cancel_remark='+cancel_remark,'500,230,no');
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=00000083s&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4){
// 	alert(value1 + ":" + value2 + ":" + value3 + ":" + value4);

	// 팝업 조회후 해당 항목에 값을 셋팅
	if ( popupSel == "masterWmCoTranBuyerPop" ) { // 다중 거래고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	else if ( popupSel == "buyerMulti" ) { // 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}
	else if ( popupSel == "cancelRemark" ) { // I/F 종결 사유
		$("#st_cancel_remark").val(value1);
		doAction('delete');
	}

	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>납품오류현황</h3>
        <span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		<span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
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
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="st_cancel_remark" name="st_cancel_remark" value="">

           	<table  class="cont_t_list01">
				<caption>오류현황 납품</caption>
				<colgroup>
					<col width="8%" />
					<col width="30%" />
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="10%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" readonly onclick="javascript:doPop('buyerMulti','');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('masterWmCoTranBuyerPop','');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>KeP팀명</th>
						<td>
							<select id="st_user_dept" name="st_user_dept" style="width:80%;height:20px"></select>
						</td>
						<th>&nbsp;&nbsp;
							<input type="checkbox" class="Noborder" id="st_user_check" name="st_user_check" value="N"> 담당자 무시
							<input type="hidden" id="st_user_check_value" name="st_user_check_value" value="N">
						</th>
						<td></td>
					</tr>
					<tr>
						<th>납품번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_legacy_iv_no" name="st_legacy_iv_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>납품일자</th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="">
							&nbsp;~&nbsp;
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="">
						</td>
						<th>&nbsp;&nbsp;
							<input type="checkbox" class="Noborder" id="st_date_flag" name="st_date_flag" value="N"> 기간 무시
							<input type="hidden" id="st_date_flag_value" name="st_date_flag_value" value="N">
						</th>
						<td></td>
					</tr>
					<tr>
						<th>주문번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_legacy_po_no" name="st_legacy_po_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>&nbsp;&nbsp;
							<input type="checkbox" class="Noborder" id="st_if_flag" name="st_if_flag" value="N"> 오류만 조회
							<input type="hidden" id="st_if_flag_value" name="st_if_flag_value" value="N">
						</th>
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
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;정상&nbsp;&nbsp;
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;오류건&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;납품생성중&nbsp;&nbsp;
		</span>
		<br>
	</form>

	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "333px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea">
		<span class="fl">
  			<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  		</span>

  		<span class="fr">
			<span class="btn_02 mr04"><a href="javascript:doAction('execute');">실행</a></span>
			<span class="btn_02"><a href="javascript:doPop('cancelRemark','');">삭제</a></span>
		</span>
	</div>

<!--내용 종료-->

</body>
</html>
