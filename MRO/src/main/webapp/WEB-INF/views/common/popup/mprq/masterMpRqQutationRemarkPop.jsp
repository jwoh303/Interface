<%--
**********************************************
* 메뉴 : 
* 화면 : 특이사항 입력 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<%
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)  
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)  
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)  
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = _sessionInfo.getUserId();
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	
	initsheet.Cols = [  
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 50,	Hidden : 1}
		      			,{ Align:"Center",	SaveName:"SELECTED", Header:"", Type:"DummyCheck",	Width:30,		Edit:true,	EditLen:100,	Hidden:false, Sort:0}
						,{ Align:"Left",	Width:560,	Edit:true,	EditLen:2000,	Hidden:false,	Type:"Text",	Header:"특이사항",	SaveName:"ADD_NOTE", BackColor:"${optColor}", Sort:0}
						,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부",	SaveName:"IMAGE_KEY_IMG", Sort:0}
		    			,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부",	SaveName:"IMAGE_KEY", Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정자",	SaveName:"CHANGE_USER_NM", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수정일시",	SaveName:"CHANGE_DATE", Sort:0}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BUYER",	SaveName:"BUYER", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"QUOTATION_NO",	SaveName:"QUOTATION_NO", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"QUOTATION_SEQ",	SaveName:"QUOTATION_SEQ", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"REVISION",	SaveName:"REVISION", Sort:0}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEQ",	SaveName:"SEQ", Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NM", Sort:0}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_ID", Sort:0}
						
		];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationRemarkPop.do" , pagingMode );
	
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	setLinkCol(mySheet, "IMAGE_KEY_IMG"); //첨부
}


var st;
var mt;
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationRemarkPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save": // 저장
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");

			for(var i=0; i<arrRow.length; i++){
				var st_add_note = mySheet.GetCellValue(arrRow[i], "ADD_NOTE");
				
				if(mySheet.GetCellValue(arrRow[i], "sStatus") == "R" && (st_add_note.indexOf("정비요청]") >=0)){
					alert(arrRow[i]+"번째 정비요청의 내용은 저장할 수 없습니다.");
			        return;			
				}
			}
			
			kepSave(document.searchCondition, mySheet, "/mprq/saveMasterMpRqQuotationRemarkPop.do", "SELECTED");
			break;
		case "del": // 삭제
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");

			for(var i=0; i<arrRow.length; i++){
				var st_add_note = mySheet.GetCellValue(arrRow[i], "ADD_NOTE");
				
				if(mySheet.GetCellValue(arrRow[i], "sStatus") == "R" && (st_add_note.indexOf("정비요청]") >=0 || st_add_note.indexOf("정비제출]") >=0)){
					alert(arrRow[i]+"번째 정비요청/제출의 내용은 삭제할 수 없습니다.");
			        return;			
				}
			}
		
			kepSave(document.searchCondition, mySheet, "/mprq/delMasterMpRqQuotationRemarkPop.do", "SELECTED");
			break;
	}

}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}

	var totRow = mySheet.RowCount();
	for(var i=1; i<=totRow; i++){
		var st_add_note = mySheet.GetCellValue(i, "ADD_NOTE");
		
		if(mySheet.GetCellValue(i, "sStatus") == "R" && (st_add_note.indexOf("정비요청]") >=0 || st_add_note.indexOf("정비제출]") >=0)){
			mySheet.SetCellEditable(i, "ADD_NOTE", false);
		}
	}
}
function mySheet_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
		doAction("search");
	}
}
//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mprq/getMasterMpRqQuotationRemarkPop.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;

	if(column == "IMAGE_KEY_IMG"){
		popupSel = "remarkFileUpload";
		var type="RFQ";
		var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
		var viewType="VI";
		
		if(mySheet.GetCellValue(Row, "sStatus") == "R" && mySheet.GetCellValue(Row, "ADD_NOTE").indexOf("정비요청]") >=0){
			viewType="R";
		}else if(mySheet.GetCellValue(Row, "sStatus") == "R" && mySheet.GetCellValue(Row, "ADD_NOTE").indexOf("정비제출]") >=0){
			viewType="R";
			if(mySheet.GetCellValue(Row, "ADD_USER_ID") == "<%=st_user_id%>"){
				viewType="VI";
			}
		}
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}
	
	return;
}

function addrows() {
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows,"SELECTED","1" );
	mySheet.SetCellValue(rows, 'IMAGE_KEY_IMG', diskOff);
}

function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30
		,value31,value32,value33){

	if(popupSel == "remarkFileUpload") {	//첨부
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY', value1);
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
	}
}
//특이사항 메일발송
function kepMailSend(){
	var totRow = mySheet.RowCount();
	if( totRow <= 0){
		alert("메일발송 가능한 특이사항이 없습니다.");		
		return;
	} 
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	if (selectedGrid.length == 0){
		alert("메일 발송할 특이사항를 선택하여 주십시요.");
        return;
	}
	for(var i=0; i<arrRow.length; i++){
		if(mySheet.GetCellValue(arrRow[i], "sStatus")=="I"){
			alert(arrRow[i]+"번째 저장 후 운영 메일발송 처리 바랍니다.");
	        return;			
		}
	}
	kepSave(document.searchCondition ,  mySheet , "/mprq/insertMasterMpRqAddNoteSendMail.do" , "SELECTED");	
}
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">	
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer%>">
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">	
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">
	<!-- 500*350 -->
	<div id="popWrapper" style="height:348px;">
    	<div id="popHeader">
        	<h1 class="title">운영 특이사항</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
		<!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "220px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>
		<!--버튼영역-->
       	<div class="mr25 mt10" style="height:24px">
			<span class="fr">
				<span class="btn_06"><a href="javascript:kepMailSend()">운영 메일발송</a></span>
				<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
			</span>
       	</div>
    </div>
					
	</form>
		
</body>
</html>
