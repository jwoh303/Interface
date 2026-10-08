<%--
**********************************************
* 메뉴 : 벌크소싱 품목 관리 > SG 수정(엑셀업로드)
* 화면 : 벌크소싱 품목 별 엑셀업로드를 통한 SG 수정
* 기능 : 1000px
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
	String burq_no = CommonUtil.nvl((String) request.getParameter("st_burq_no"), "");
	String project_name = CommonUtil.nvl((String) request.getParameter("st_project_name"), "");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"%>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js"
	type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js"
	type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js"
	type="text/javascript"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var maxAllowRow = 1000;	// 추천을 허용할 데이터 Row수
var checkFlag = "N"; // 업로드 결과 확인 FLAG

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		{Align:"Center",	Width:30,	Edit:false,	EditLen:0,		Hidden:false,	Type:"Seq",		Header:"NO|NO",		SaveName:"SEQ"},
		{Align:"Center",	Width:300,	Edit:false,	EditLen:0,		Hidden:false,	Type:"Text",	Header:"키값|키값",	SaveName:"ITEM_KEY_ID"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"기존|SG ID",	SaveName:"SG_ID"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"기존|SG명",	SaveName:"SG_NAME"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"기존|SG담당자명",	SaveName:"SM_USER_NAME"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정(엑셀 업로드 정보)|SG ID",	SaveName:"CH_SG_ID"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정(엑셀 업로드 정보)|SG명",	SaveName:"CH_SG_NAME"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"수정(엑셀 업로드 정보)|SG담당자명",	SaveName:"CH_SM_USER_NAME"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Hidden:true,	Type:"Text",	Header:"수정(엑셀 업로드 정보)|SG담당자명",	SaveName:"CH_SM_USER_ID"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"결과|결과",	SaveName:"RESULT"}
		
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	mySheet.SetCountPosition(4);
	
	if(!isEmpty("<%=burq_no%>")){
		$("#st_burq_no").val("<%=burq_no%>");
		$("#st_project_name").val("<%=project_name%>");
	}
}

//기능함수
function doAction(str) {

	var project = $("#st_burq_no").val();
	if(isEmpty(project)){
		alert("프로젝트를 선택하시기 바랍니다.");
		return;
	}
	
	switch (str) {
		case "loadExcel": // 파일 업로드
			var params = "";
			mySheet.RemoveAll();
			params = { Mode : "NoHeader ", StartRow: "3", ColumnMapping:"|1||||2|||||"};
			mySheet.LoadExcel(params);
			checkFlag= "N";
			break;
		case "downForm" : // 양식 다운로드
			location.href = "/resources/excel/work/NEWSOURCING/masterMpRqBulkQuotationSgChangeExcel.xlsx";
			break;
		case "downExcel": // 조회결과 다운로드
			var param = {FileName:"SG수정.xls"};
			mySheet.Down2Excel(param);
			break;
		case "checkExcel": // 업로드 결과 확인
			kepSearch(document.searchCondition, mySheet, "/mprq/checkMasterMpRqBulkQuotationSgChangePop.do", pagingMode);
			checkFlag= "Y";
			break;			
		case "save": // 등록
			if(checkFlag != "Y"){
				alert("업로드 결과 확인 후 진행하시기 바랍니다.");
				return;
			}
			var maxRow = mySheet.RowCount() + 1; 
		    for(var i = 3; i <= maxRow; i++){
		    	var result = mySheet.GetCellValue(i,"RESULT");
		    	if(result != "정상"){
		    		alert("결과가 정상이 아닌 정보가 있습니다. 다시 엑셀 업로드 후 하시기 바랍니다.");
		    		return;
		    	}
		    }
			    
			if(!confirm("입력하신 정보를 등록하시겠습니까?")){
				return;
			}
		    kepAjaxFormCall("/mprq/saveMasterMpRqBulkQuotationSgChangePop.do","searchCondition","save");
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod=="save"){
		alert("<%=CommonLang.msg("MSG236")%>");
		mySheet.RemoveAll();
		setReturn('1');
		return;
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	if (msg != "") {
		alert(msg);
	}
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}
	var err_cnt = 0;
	var maxRow = mySheet.RowCount() + 1; 
    for(var i = 2; i <= maxRow; i++){
    	var result = mySheet.GetCellValue(i,"RESULT");
    	if(result != "정상"){
    		mySheet.SetRowBackColor(i,"#FFD966");
    		err_cnt++;
    	}
    }
    document.getElementById("cnt2").innerHTML = maxRow - 1 - err_cnt;
    document.getElementById("cnt3").innerHTML = err_cnt;
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	if(mySheet.RowCount() == 0){
		//일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.
		alert("<%=CommonLang.msg("MSG467")%>");
		} else {
			document.getElementById("cnt").innerHTML = mySheet.RowCount();
			kepSaveAll(document.searchCondition, mySheet,"/mprq/batchMasterMpRqBulkQuotationSgChangePop.do");
		}
	}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if (!checkedSession(stCode)) {
		return;
	}

	if (msg != "") {
		alert(msg);
	}
}

//팝업함수호출
function doPop(str, value1) {
	switch (str) {
	case "selProject":
		popupSel = "selProject";
		openSearchPopup('/mprq/showMasterMpRqBulkQuotationSelProjectPop.do', '','630,450,no');

		break;
	}
}
//팝업리턴
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9) {
	if (popupSel == "selProject") {
		$("#st_burq_no").val(value1);
		$("#st_project_name").val(value2);
	}
}
function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9){ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}
</script>
</head>
<body onload="kep_onload_view()">
	<!-- 메뉴 S -->
	<div id="wrapper">

		<!--내용 시작-->
		<div id="popWrapper">
			<div id="popHeader">
				<h1 class="title">SG 수정(엑셀업로드)</h1>
				<p class="popClose">
					<a href="javascript:self.close()"> 
						<img src="/resources/images/<%=_closeImgSrc%>" alt="닫기버튼" />
					</a>
				</p>
			</div>
			<div id="popContainer" style="background-color: #f5f5f5">
				<br>
				<table class="cont_t_list06 mb15" summary="SG 수정(엑셀업로드)"
					style="width: 100%;">
					<caption>일괄 담당자 등록(엑셀업로드)</caption>
					<colgroup>
						<col width="10%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<form name="searchCondition" id="searchCondition" method="post">
							<input type="hidden" name="s_SAVENAME"> <input
								type="hidden" name="st_burq_no" id="st_burq_no" value="">
						</form>
						<tr>
							<th scope="row" class="center" style="height: 40px">프로젝트</th>
							<td>
								<input type="text" id="st_project_name" name="st_project_name" class="input_type_text" style="width: 70%;" readonly>
								<a href="javascript:doPop('selProject');"> <img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_burq_no','st_project_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th scope="row" class="center" style="height: 40px">파일 업로드</th>
							<td>
								<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">엑셀 업로드</a></span> 
								<span class="btn_05 mr04"><a href="javascript:doAction('downForm');">양식 다운로드</a></span>
							</td>
						</tr>
					</tbody>
				</table>
				<!--버튼영역-->
				<div class="btnArea" style="text-align: center;">
					<span class="btn_08 mr04">
						<a href="javascript:doAction('checkExcel');">업로드 결과 확인</a>
					</span>
				</div>
				<div class="btnArea">
					<span class="fl">
						<span class="btn_08 mr04"><a href="javascript:doAction('downExcel');">조회결과 다운로드</a></span>
						<span style="font-size: 14px;">총 <b><span id="cnt">00</span></b>건&nbsp;&nbsp;&nbsp;(정상 <span id="cnt2" style="font-weight: bold;">00</span>건 / 오류 <span id="cnt3"  style="color:red;font-weight: bold;">00</span>건)</span>
					</span>
					<span class="fr">
						<span class="btn_05 mr04">
							<a href="javascript:doAction('save');">등록</a>
						</span>
					</span>
				</div>
				<!--grid-->
				<div class="ib_product" style="border-top: 2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "490px");
					</script>
				</div>
				<br>
				<!--내용 종료-->
			</div>
		</div>

	</div>

</body>
</html>
