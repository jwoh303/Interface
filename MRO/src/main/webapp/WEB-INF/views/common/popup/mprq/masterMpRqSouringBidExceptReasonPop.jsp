<%--
**********************************************
* 메뉴 : 
* 화면 : 최저가 예외 업체 선정 사유
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2021-03-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function initPage() {
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0, ColMove : 0, ColResize : 0};
	initsheet.Cols = [  
	      			{Align : "Center",	SaveName : "sStatus",	Header : "상태|상태",			Type : "Status",	Width : 60,		Hidden:true}, 
	    			{Align : "Center", 	SaveName : "SELECTED",	Header : "|",				Type : "DummyCheck",Width : 60,		EditLen : 50,	Hidden:true}, 
	    			{Align : "Center",	SaveName : "CODE",		Header : "사유코드|사유코드",	Type : "Text",		Width : 120,	EditLen : 110,	Hidden:true},
	    			{Align : "Center",	SaveName : "TEXT1",		Header : "예외사항|예외사항",	Type : "Text",		Width : 180,	EditLen : 110,	Edit : false},
	    			{Align : "Center",	SaveName : "REQ_DEPT",	Header : "고객사|요청부서",		Type : "Text",		Width : 180,	EditLen : 110,	Edit : false},
	    			{Align : "Center",	SaveName : "REQ_USER",	Header : "고객사|요청자",		Type : "Text",		Width : 100,	EditLen : 110,	Edit : false},
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "TEXT1");
	
	kepSearch(document.searchCondition ,  mySheet ,"/mprq/getBidSucessCodePop.do", pagingMode );
}


function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
loader_obj("N");
if(!checkedSession(stCode)){return;}	
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
	
	for(var i=1; i<=totRow;i++){
		if (mySheet.GetCellValue(i, "CODE") == "BS11"){
			mySheet.SetCellEditable(i,"REQ_DEPT", 1);
			mySheet.SetCellEditable(i,"REQ_USER", 1);
			mySheet.SetCellBackColor(i,"REQ_DEPT", "${optColor}");
			mySheet.SetCellBackColor(i,"REQ_USER", "${optColor}");
		}
		if (mySheet.GetCellValue(i, "CODE") == "BS12"){
			var value1 = mySheet.GetCellValue(i, "REQ_DEPT");
			var value2 = mySheet.GetCellValue(i, "REQ_USER");
			mySheet.SetCellBackColor(i,"REQ_DEPT", "${notnullColor}");
			mySheet.SetCellBackColor(i,"REQ_USER", "${notnullColor}");
		}
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	var value = mySheet.GetCellValue(grbRow, "CODE");	
	
	if(column == "TEXT1"){ 
		kepConfirm();
	}
	
	if(value == "BS12"){
		if(column == "REQ_DEPT" || column == "REQ_USER"){
			popupSel = "masterMpRqBuyerDesignAgentPop";
			var st_buyer = "<%=st_buyer%>";
			var st_agent = "<%=st_agent%>";
			openSearchPopup("/mprq/getMasterMpRqBuyerDesignAgentPop.do",'?st_buyer='+st_buyer+'&st_agent='+st_agent,"700,400,no");
		}
	}
	return;
}

//확인
function kepConfirm(){
	var value1 = mySheet.GetCellValue(grbRow, "CODE");
	var value2 = mySheet.GetCellValue(grbRow, "TEXT1");
	var value3 = "";
	var value4 = "";
	var value5 = mySheet.GetCellValue(grbRow, "REQ_DEPT");
	var value6 = mySheet.GetCellValue(grbRow, "REQ_USER");

	if(value1 == "BS11" || value1 == "BS12"){ // 선입고선진행, 고객지정협력사 - 요청부서 요청자 입력 필수
		if(kepIsValueNull(value5)){
			alert("요청부서를 입력해야 합니다.");
			return;
		}
	   	if(kepIsValueNull(value6)){
	   		alert("요청자를 입력해야 합니다.");
			return;
	   	}
	   	value4 = $('#AGENT_CHOICE_SEQ').val(); // 고객사 지정 협력사 경우 순번 전달 QTDT 저장용
	}else{ // 오견적 외 4건 상세 사유 입력 필수
	   	if (kepIsValueNull($('#bid_success_reason').val())){
	   		alert("상세 사유를 입력 해야합니다.");
			return;
	   	}
	
	   	var remark_len = kepGetByteLength('bid_success_reason');
	   	
	   	if(remark_len > 200) {
	   		alert("비고는 200Bytes까지 입력가능합니다.");
	   		return;
	   	}
	   	if(remark_len < 20) {
	   		alert("최소 10자리 이상 필수 등록입니다.");
	   		return;
	   	}
	   	
	   	value3 = $('#bid_success_reason').val();
	}
   opener.setBidSuccessCode(value1,value2,value3,value4,value5,value6);
   this.close();
}

function checkRemarkLength(check_length) {
	var remark_len	= kepGetByteLength('bid_success_reason');

	if(remark_len > check_length) {
		if(event.keyCode != '8') {
			alert(check_length + " 바이트까지 입력이 가능합니다.");

			var remark	= $('#bid_success_reason').val();

			$('#bid_success_reason').val(remark.substring(0, remark.length - 1));
		}
	}

	$('#bytes_chk').val(kepGetByteLength('bid_success_reason'));
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3){
	if (popupSel == "masterMpRqBuyerDesignAgentPop") {	//고객사 정보 설정 
		mySheet.SetCellValue(grbRow, 'REQ_DEPT', value1);
		mySheet.SetCellValue(grbRow, 'REQ_USER', value2);
		$('#AGENT_CHOICE_SEQ').val(value3);
	}
}

</script>
<title>코리아 e 플랫폼</title>
</head>


<body onload="initPage();">

<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="AGENT_CHOICE_SEQ"  name="AGENT_CHOICE_SEQ" value="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">최저가 예외 업체 선정 사유</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>

        <!--팝업내용입니다-->
        <div id="popContainer">

	       	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "200px");
					</script>
			</div>
			<table class="cont_t_list05">
				<tr>
					<th style="width:119px;">상세 사유<br>
						<input type="text" name="bytes_chk" id="bytes_chk" style="width:25px;text-align:right; border: solid 0px #bfd0e4;background-color: #bfd0e4;font-family: 돋움;font-weight: bold" readonly >/200
					</th>
					<br>
					<td>
						<textarea name="bid_success_reason" id="bid_success_reason" style="width:100%; overflow:auto; border-color:white; border-width:0; ime-mode:active;"  rows="5" onKeyUp="checkRemarkLength(200);"></textarea>		
					</td>
				</tr>
			</table>
        </div>
    </div>
    </form>
</body>
</html>
