<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 정보 
* 기능 : 협력사 상세정보 조회
* 프로그램 ID : PG_01_M_015_01
* 담당자 : 최철규
* 착수일 : 2017-02-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_id = CommonUtil.nvl((String) _sessionInfo.getUserId(), "") ;

String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "8");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

Map<String,String> _rowData = null;
Map<String,String> _acountData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",		Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",												SaveName:"sStatus"}
					,{ Align:"Center",		Width:45,		Edit:false,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",														SaveName:"SELECTED"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"협력사코드",										SaveName:"AGENT"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"고객사",											SaveName:"BUYER_NAME_LOC"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"방문일시",											SaveName:"CSTMR_VISIT_DATE"}
					,{ Align:"Center",		Width:95,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"방문유형",											SaveName:"VISIT_TYPE"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"방문자",												SaveName:"USER_NAME_LOC"}
					,{ Align:"Left",		Width:440,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"영업상 주요 활동결과/ 정보/ 특이사항",		SaveName:"VISIT_NOTE"}
					,{ Align:"Center",		Width:58,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",			Header:"첨부",												SaveName:"IMAGE_FLAG"}
					,{ Align:"Left",		Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"첨부파일",											SaveName:"IMAGE_KEY"}
					,{ Align:"Center",		Width:58,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"등록일자",											SaveName:"ADD_DATE"}
					,{ Align:"Left",		Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"등록시간",											SaveName:"ADD_TIME"}
					,{ Align:"Left",		Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"방문자사번",											SaveName:"ADD_USER_ID"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetImageList(1, diskOn);
	mySheet.SetImageList(0, diskOff);
	
	setLinkCol(mySheet, "VISIT_NOTE");				//활동내용
	setLinkCol(mySheet, "IMAGE_FLAG");				//파일첨부
	
	doAction('search');
}

var st;
var mt;

//기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	if (str == "delete" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.visitForm,  mySheet , "/mdcd/getMasterMdCdAgentCardInfoPopVisit.do" , pagingMode );
			break;
			
		case "delete":	 // 삭제
			if (confirm("선택한 건을 삭제하겠습니까?")) {
				kepSave(document.visitForm,  mySheet , "/mdcd/deleteMasterMdCdAgentCardInfoPop.do" , "SELECTED" );
			}
			break;
	}
}

//팝업함수호출
function doPop(str, val1, val2, val3) {
	popupSel = str;
	
	switch (str) {
		case "remark":			// 활동내용 수정
			openSearchPopup("/mdcd/showMasterMdCdAgentPrimaryActivityDetailRegPop.do", "?com_code=" + val1 + "&add_date=" + val2 + "&add_time=" + val3, "1000, 500,no");
			break;
			
		case "add":				// 활동내용등록
			openSearchPopup("/mdcd/showMasterMdCdAgentPrimaryActivityDetailRegPop.do", "?com_code=" + val1, "1000, 500,no");
			break;
			
		case "fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+val1+"&viewType=R", "500,430,no");
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod, response) {
}

function  kepAjaxError(pMethod , response) {
	Company_Create_flag = "N";
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function kepEnter() {
	if (event.keyCode == 13) {
		doAction('search');
	}
}

function setReturn(value1, value2) {
	opener.setPopupReturn(value1, value2);
	this.close();
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	if (popupSel == "remark" && code == "OK") {
		doAction("search");
	}else if(popupSel == "add" && code == "OK"){
		doAction("search");
	}else if (popupSel == "fileUpload") {
		mySheet.SetCellValue(grbRow, "IMAGE_KEY", code);
	}

	grbRow="";	//초기화
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'IMAGE_FLAG') { // 첨부파일
		doPop('fileUpload', 	mySheet.GetCellValue(Row, "IMAGE_KEY"));
	} else if (column == 'VISIT_NOTE') {				// 활동내용
		doPop("remark", mySheet.GetCellValue(Row, "AGENT"), mySheet.GetCellValue(Row, "ADD_DATE"), mySheet.GetCellValue(Row, "ADD_TIME") );
		return;
	}
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
		makePageIndex2(mySheet, 1, document.visitForm.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.visitForm.onepagerow.value);
	}

	for(var j=1; j<=mySheet.LastRow(); j++){
		var st_user_id = mySheet.GetCellValue(j, "ADD_USER_ID");
		var user_id = "<%=user_id%>";

		if( st_user_id == user_id ){
			mySheet.SetCellEditable(j, "SELECTED", 1);
		}
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
	kepSearch(document.visitForm ,  mySheet , "/mdcd/getMasterMdCdAgentCardInfoPopVisit.do?page="+current_page , pagingMode );
}

</script>
<body onload="kep_onload_view();">

<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<form name="visitForm" id="visitForm" method="post" >
<div id="popWrapper" style="height:520px;">
	<div id="popHeader">
		<h1 class="title">협력사 관리정보 </h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	</div>

	<!--팝업내용입니다-->
	<div id="popContainer">
	
<%if(com_code.equals("KRKEPS0002")){%>	
		<div id="cont_searchA">
			<table class="cont_t_list01" style="width:100%">
				<caption>미등록협력사명</caption>
				<colgroup>
					<col width="15%"/> 
					<col width="85%"/>
				</colgroup>
				
				<tbody>
					<tr>
						<td>미등록협력사명</td>
						<td>
							<input type="text" id="st_agent_name" name="st_agent_name" style="width:20%; vertical-align:top;" value="" class="input_type_text" onkeydown="kepEnter()"/>
							&emsp;
							<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
						</td>
					</tr> 
				</tbody>
			</table>
		</div>
<%}%>		
		<div class="contArea">
<% if (_rowData != null) { %>
			<b>[협력사 관리정보]</b>
			<table class="cont_t_list02" style="width:100%">
				<caption>협력사 정보  리스트</caption>
				<colgroup>
					<col width="10%" />
					<col width="30%" />
					<col width="10%" />
					<col width="20%" />
					<col width="10%" />
					<col width="20%" />
				</colgroup>
				
				<tbody>
					<tr>
						<th scope="col">협력사명</th>
						<td class="left"><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC")) %></td>
						
						<th scope="col">업태</th>
						<td class="left"><%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE")) %></td>
						
						<th scope="col">종목</th>
						<td class="left"><%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS")) %></td>
					</tr>
					<tr>
						<th scope="col">주소</th>
						<td colspan="3" class="left"><%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC")) %></td>
						
						<th scope="col">전화번호</th>
						<td class="left"><%=CommonUtil.nvl(_rowData.get("TEL_NO")) %></td>
					</tr>
				</tbody>
			</table>
			
			<!--grid-->
			<b>[주요 활동내용]</b>
			
			<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<input type="hidden" id="com_code" name="com_code" value="<%=com_code%>" />
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" />
		
			<div class="ib_product" style="border-top:2px solid #3c639c">
 					<script type="text/javascript">
 						createIBSheet("mySheet", "100%", "250px");
 					</script>
 				</div>
 				
 				<p class="paging" id="pageindex"></p>
			
			<div class="btnArea mt10 mb05">
				<span class="fr">
					<span class="btn_02 mr05"><a href="javascript:doPop('add', '<%=com_code%>');">추가</a></span>
					<span class="btn_02"><a href="javascript:doAction('delete');">삭제</a></span>
				</span>
			</div>
		</div>
<% } %>
	</div>
</div>
</form>
</body>
</html>
