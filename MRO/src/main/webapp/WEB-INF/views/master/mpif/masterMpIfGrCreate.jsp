<%--
**********************************************

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
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",		Header:"상태",			SaveName:"IF_FLAG", Sort:0}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"오류메세지",		SaveName:"ERROR_MSG", Sort:0}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"고객사명",			SaveName:"BUYER_NAME", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사입고번호",	SaveName:"LEGACY_GR_NO", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사입고항번",	SaveName:"LEGACY_GR_SEQ", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사발주번호",	SaveName:"LEGACY_PO_NO", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사발주항번",	SaveName:"LEGACY_PO_SEQ", Sort:0}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"품목코드",			SaveName:"BUYER_ITEM_NO", Sort:0}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"입고수량",			SaveName:"GR_QTY", Sort:0}
		,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"입고일",			SaveName:"GR_DATE",BackColor:"${optColor}", Sort:0}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"단가",			SaveName:"UNIT_PRICE", Sort:0}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"금액",			SaveName:"GR_AMT", Sort:0}
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
	
	// 하이퍼링크 설정
	//setLinkCol(mySheet, "BUYER_ITEM_NO");		//품목코드
		
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
			if ( !ValidationCheck() )
				return;
			current_page = -1;
			$("#job_kind").val("search");
			kepSearch(document.searchCondition,  mySheet , "/mpif/getMasterMpIfGrCreateList.do" , pagingMode );
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

		case "execute": // 실행
			if (!validationChange())
				return;
			if (!ValidationCheck())
				return;
			if (!confirm('전체 실행 하시겠습니까?'))
				return;
			$("#job_kind").val("execute");
			kepSaveAll(document.searchCondition, mySheet, "/mpif/excuteMasterMpIfGrCreateList.do");
			break;

		case "save": // 저장
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			$("#job_kind").val("save");
			kepSave(document.searchCondition, mySheet, "/mpif/updateMasterMpIfGrCreateList.do", "SELECTED");
			break;

		case "delete": // 발주 삭제
			if (!validationChange())
				return;
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			$("#job_kind").val("delete");
			kepSave(document.searchCondition ,  mySheet , "/mpif/delMasterMpIfGrCreateList.do" , "SELECTED" );
			break;

		case "excelDown": // 양식다운로드
			location.href = "/resources/excel/work/MPIF/masterMpIfGrCreateListExcel.xlsx";
			break;
		
		case "excelUpload": // 엑셀업로드
			if(!ValidationCheck())
				retrun;
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
	kepSave(document.searchCondition ,  mySheet , "/mpif/saveMasterMpIfGrCreateListExcelCheck.do" , "SELECTED" );
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

// Valitation - 변경 여부
function validationChange() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
        if ( mySheet.GetCellValue(i, "sStatus") != 'R' ) {
			alert(i + "번째 데이터에 변경된 내역이 존재합니다.\n\n수정내역을 저장해 주십시오.");
			return false;
		}
	}

	return true;
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	// 조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfOrderCreateList.do?page="+current_page , pagingMode);
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if ( column == 'BUYER_ITEM_NO' ) { // 품목코드
		
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var buyerItemNo = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var purchaserUserDept = mySheet.GetCellValue(Row, "PURCHASER_USER_DEPT");
		var byitComorgCode = mySheet.GetCellValue(Row, "COMORG_CODE");
		var params = '?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo+'&PURCHASER_USER_DEPT='+purchaserUserDept+'&BYIT_COMORG_CODE='+byitComorgCode;
		doPop("masterMpIfOrderStatusPop", params);
	}

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

// 팝업함수호출
function doPop(str, params) {
	popupSel = str;

	switch (str) {
		case "buyer_single":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no"); 
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=000000dsc&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
		
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9){
// 	alert(value1 + ":" + value2 + ":" + value3 + ":" + value4 + ":" + value5);

	// 팝업 조회후 해당 항목에 값을 셋팅
	if( popupSel == "buyer_single"){
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	
	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>인터페이스 입고 생성</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	    <!-- <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span> -->
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

           	<table  class="cont_t_list01">
				<caption>인터페이스 입고 생성</caption>
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
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" readonly>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('buyer_single','');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>상태</th>
						<td>
							<select id="st_status" name="st_status" style="width:80%;height:20px">
								<option value="ALL" selected>전체</option>
								<option value="Y">정상</option>
								<option value="E">오류</option>
							</select>
						</td>
						<th>
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
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;입고생성중&nbsp;&nbsp;
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
	
		<table style="width:100%;">
			<tr>
				<td colspan="2" height="25" align="left">
					&nbsp;* <font color="red">선택(체크)여부와 상관없이 화면에 조회된 고객사의 모든 데이터가 인터페이스 입고 생성됩니다.</font>
		        </td>
			</tr>
		    <tr>
		        <td height="25" align="left">
  					<span class="btn_05 mr04" ><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
  					<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">양식다운로드</a></span>
		        </td>
		        <td height="25" align="right" valign="middle">
		  			<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
		  			<span class="btn_02 mr04"><a href="javascript:doAction('delete');">삭제</a></span>
		  			<span class="btn_02 mr04"><a href="javascript:doAction('execute');">실행</a></span>
		        </td>
		    </tr>
		</table>
	</div>

<!--내용 종료-->

</body>
</html>
