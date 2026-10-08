<%--
**********************************************
* 메뉴 : 고객사 > HOME > 품목등록증
* 화면 : 품목등록증 
* 기능 : 품목등록증 팝업
* 프로그램 ID : PG_90_B_400_22
* 담당자 : 이수영	 ( 설계 : 이수영 )
* 착수일 : 2014-06-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
<!--
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {

	var initsheet = {};
	initsheet.Cols = [
			 {Align:"Center",	SaveName:"sStatus",				Header:"상태",		Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",				Header:"",				Type:"DummyCheck",	Width:40,		Edit:true,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SEQ",					Header:"순번",		Type:"Text",				Width:90,		Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SUBJECT",				Header:"이름",		Type:"Text",				Width:396,	Edit:false,	EditLen:200,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"파일번호",	Type:"Text",				Width:245,	Edit:true,	EditLen:20,	Hidden:true}
			,{ Align:"Center",	SaveName:"ADD_USER_ID",		Header:"등록자ID",	Type:"Text",				Width:160,	Edit:false,	EditLen:30,	Hidden:true}
			,{ Align:"Center",	SaveName:"ADD_USER_NAME",	Header:"등록자",		Type:"Text",				Width:70,		Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"ADD_DATE",			Header:"등록일",		Type:"Date",				Width:80,		Edit:false,	EditLen:12,	Hidden:false}
			,{ Align:"Center",	SaveName:"IMAGE_KEY_IMG",		Header:"첨부",		Type:"Image",			Width:60,		Edit:false,	EditLen:2,		Hidden:false}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "IMAGE_KEY_IMG");	
	
	//파일첨부이미지설정
	mySheet.SetImageList(0, diskOff);
	mySheet.SetImageList(1, diskOn);
	
	doAction("search");
}

function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "fileUpload":
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+val, "500,430,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "fileUpload") {
		mySheet.SetCellValue(grbRow,"IMAGE_KEY", code);
	}
	grbRow="";	//초기화
}

var st;
var mt;

//기능함수
function doAction(str, flag) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	button_flag = flag;
	
	if (str =="del"  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search":
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/home/getBuyerHomeGoodsRegFormPopList.do" , pagingMode );
			break;
		case "insert":	 // 조회
			var rows = mySheet.DataInsert(-1);

			mySheet.SetCellEditable(rows, "SUBJECT", 1);
			mySheet.SetCellValue(rows, "ADD_DATE", kepGetNowTimeStr("YYYYMMDD","/"));
			mySheet.SetCellValue(rows, "IMAGE_KEY_IMG", diskOn);
			mySheet.SetCellValue(rows, "ADD_USER_NAME", "<%=_sessionInfo.getUserNameLoc()%>");
			break;
		case "save": // 수정
			if (checSubmit()) {
				kepSave(document.searchForm, mySheet, "/home/saveBuyerHomeGoodsRegFormPopList.do", -1 );
			}
			break;
		case "del":					// 고객사별 담당자 삭제
			if (confirm("품목등록증을 삭제하시겠습니까?")) {
				kepSave(document.searchForm, mySheet, "/home/deleteBuyerHomeGoodsRegFormPopList.do", 1);
			}
			break;	
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == "IMAGE_KEY_IMG") {
		doPop("fileUpload", mySheet.GetCellValue(grbRow, "IMAGE_KEY"));
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

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

	if (current_page==-1) {
		makePageIndex2(mySheet, 1, document.searchForm.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchForm.onepagerow.value);	
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchForm ,  mySheet , "/home/getBuyerHomeGoodsRegFormPopList.do?page="+current_page , pagingMode );
}

//변경 여부 체크
function checkRow() {
	var check = true;

	for (var i = 1; i <= mySheet.RowCount(); i++ ) {
		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	if (check) {
		alert("추가된 행이 없습니다.");
		return false;
	}
	return true;
}

function checSubmit() {
	if (!checkRow()) return false;
	
	for (var i = 1; i <= mySheet.RowCount(); i++ ) {

		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
			if (kepTrimStr(mySheet.GetCellValue(i, "SUBJECT")) == "") {
				alert(i + "번째줄 이름을 입력해주세요.");
				mySheet.SelectCell(i, "SUBJECT");
				return false;
			}
			
			if (!fnCheckInputByteStr(mySheet.GetCellValue(i, "SUBJECT"), 200)) {
				alert(i + "번째줄의 이름은 영문 200자, 한글 100자 까지 입력할수 있습니다.");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "IMAGE_KEY")) == "") {
				alert(i + "번째줄 첨부파일을 등록해주세요..");
				mySheet.SelectCell(i, "IMAGE_KEY");
				return false;
			}
		}
	}
	
	var conf = confirm("품목등록증을 저장하시겠습니까?");
	return conf;
}
 //-->
</script> 
<body onload="kep_onload_view();">
<form name="searchForm" id="searchForm" method=post >
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME" />
<input type="hidden" id="pageflag" name="pageflag" value="1" />
<input type="hidden" name="onepagerow" id="onepagerow" value="10" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:400px;">
    	<div id="popHeader">
        	<h1 class="title">품목등록증</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        
        <div id="popContainer">
            <div class="contArea" style="height:340px;" >
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "288px");
					</script>
				</div>
				<p class="paging" id="pageindex"></p>
			</div>
			
			<!--버튼영역-->	
			<div class="btnArea">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('insert');">행추가</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				</span>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
