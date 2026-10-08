<%--
**********************************************
오비맥주 발주 수정
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script src="/resources/js/kep_common.js"></script>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
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
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태값",			SaveName:"sStatus", Sort:0}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED", Sort:0}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER", Sort:0}
		,{ Align:"Left",	Width:150,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"발주번호",			SaveName:"LEGACY_PO_NO", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"전화번호",	SaveName:"MOBILE_NUMBER", Sort:0}
		,{ Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"주소",	SaveName:"DELY_TO_LOCATION_TEXT", Sort:0}
		,{ Align:"Center",	Width:200,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"비고",			SaveName:"REMARK",	 Sort:0}
	];

// 	initsheet.HeaderMode = { Sort : 0, ColMove : 1, ColResize : 1 };
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);

	mySheet.SetImageList(3, imagePrifC);
	mySheet.SetImageList(4, imagePrifR);
	mySheet.SetImageList(5, imagePrifCancel);
	mySheet.SetImageList(6, imagePrifDelete);
	
	// 초기화 설정
	resetValue();
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	var st_user_check = "<%=st_user_check%>";
	if(st_user_check== "Y"){
		$('#st_user_check').prop('checked',true);
	}
	if(searchYn == "Y"|| processYN == "Y"){
		doAction("search");
	}
}

// 초기화 설정
function resetValue() {
	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
	$("#st_status").val("ALL");
	$("#job_kind").val("");
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
	if ( str != "execute" && str !="search" && str !="excelDown" && str !="reload" && str !="excelUpload" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			current_page = -1;
			$("#job_kind").val("search");
			kepSearch(document.searchCondition,  mySheet , "/mpif/getmasterMpIfObPoAlterList.do" , pagingMode );
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

		case "execute": // 실행
			if (!confirm('전체 실행 하시겠습니까?'))
				return;
			$("#job_kind").val("execute");
			kepSaveAll(document.searchCondition, mySheet, "/mpif/excuteMasterMpIfObPoAltereList.do");
			break;

		case "excelDown": // 양식다운로드
			location.href = "/resources/excel/work/MPIF/masterMpIfObPoAlterExcel.xlsx";
			break;
		case "delete": // 발주 삭제
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			$("#job_kind").val("delete");
			kepSave(document.searchCondition ,  mySheet , "/mpif/delMasterMpIfObPoAltereList.do" , "SELECTED" );
			break;
		case "excelUpload": // 엑셀업로드
		/* 	if(!ValidationCheck())
				retrun; */
			if ( $("#job_kind").val() != "search" ){
				alert("조회 후 업로드 가능합니다.")
				return;	
			}
			
			mySheet.RemoveAll();
			$("#job_kind").val("upload");
			var params = {
				Mode : "HeaderMatch"
			};
			mySheet.LoadExcel(params);
			break;	
		
	}
}

function mySheet_OnLoadExcel() {
 
	if (1000 < mySheet.RowCount() + 1) {
		alert("1000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	} 
	setSaveGridtoDB();
}


function setSaveGridtoDB(){	  
	var maxRow = mySheet.RowCount() + 1;     
    for(var i = 1; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    }  
	kepSave(document.searchCondition ,  mySheet , "/mpif/saveMasterMpIfObPoAlterListExcelCheck.do" , "SELECTED" );
}

function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}

//실행조건 체크
function ValidationCheck() {

	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}

	return true;
}	

// 조회조건 체크
function searchValidate() {

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

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		if ( $("#job_kind").val() == "delete" ) {
			$("#st_cancel_remark").val("");
		}
		if ( $("#job_kind").val() == "upload" && code == 0 ) {
			mySheet.RemoveAll();
			return;
		}
		// 저장 성공시 재조회
		doAction("search");
	} 
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	// 조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getmasterMpIfObPoAlterList.do?page="+current_page , pagingMode);
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	return;
}

function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(Col);
	//grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	
}

// 헤더 더블클릭 이벤트
function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {   
	if ( Row > 0 ) return;
	
	var checkRows = mySheet.FindCheckedRow("SELECTED");
	
	if ( checkRows.length == 0 ) {
 		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	
	var arrRow = checkRows.split("|");
	
}


</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>오비맥주 발주 수정</h3>
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
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="st_cancel_remark" name="st_cancel_remark" value="">
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
	
		<table style="width:100%;">
			<tr>
				<td colspan="2" height="25" align="left">
					&nbsp;&nbsp; <font color="red">*  빈 값으로 넣으면 수정 없이 인터페이스 받은 데이터로 발주 생성 됩니다.</font>
		        </td>
		  	</tr>
		  	<tr>
		  	 	<td colspan="2" height="25" align="left">
		        	&nbsp;&nbsp; <font color="red">*  실행 후 오류 발생 시 표에 남게 됩니다. 김시원 프로에게 문의 바랍니다. </font>
		        </td>
		  	</tr>
		    <tr>
		        <td height="25" align="left">
  					<span class="btn_05 mr04" ><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
  					<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">양식다운로드</a></span>
		        </td>
		        <td height="25" align="right" valign="middle">
		  			<!-- <span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span> -->
		  			<span class="btn_02 mr04"><a href="javascript:doAction('delete');">삭제</a></span>
		  			<span class="btn_02 mr04"><a href="javascript:doAction('execute');">실행</a></span>
		        </td>
		    </tr>
		</table>
	</div>

<!--내용 종료-->

</body>
</html>
