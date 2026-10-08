<%--
**********************************************
* 메뉴 : 
* 화면 : 보낸문자함
* 기능 : 그룹웨어 SMS보내기 본인 전송건 1개월까지 조회 가능
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 :
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); 		// 조회된 결과 
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){
	var initsheet = {};
	
	initsheet.Cols = [  
	      			{Align : "Center",	SaveName : "sStatus",	Header : "상태",		Type : "Status",		Width : 60,		Hidden : true}, 
	    			{Align : "Center",	SaveName : "SELECTED",	Header : "",		Type : "DummyCheck",	Width : 60,		Hidden : true},
	    			{Align : "Center",	SaveName : "SENTTIME",	Header : "전송일시",	Type : "Text",			Width : 150,	Hidden : false,	Edit : false},
	    			{Align : "Center",	SaveName : "CALLPHONE",	Header : "수신전화번호",	Type : "Text",			Width : 120,	Hidden : false,	Edit : false},
	    			{Align : "Center",	SaveName : "RESULT",	Header : "전송여부",	Type : "Text",			Width : 100,	Hidden : false,	Edit : false},
	    			{Align : "Left",	SaveName : "MSG",		Header : "내용",		Type : "Text",			Width : 490,	Hidden : false,	Edit : false},
	    			{Align : "Center",	SaveName : "KIND",		Header : "종류",		Type : "Text",			Width : 100,	Hidden : false,	Edit : false},
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M") );
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
	
	mySheet.SetCountPosition(4);
}

function mySheet_OnLoadData(DATA){
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
}

function doAction(str) {
	
	switch (str) {
		case "search":
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
				alert("조회기간은 최대 1개월 설정 가능합니다.");
				return;
			}
			
			current_page = -1;
			kepSearch(document.CommonNoNeSentSmsPop,  mySheet , "/none/getNoneSentSmsList.do" , pagingMode ); 
			
			break;
		case "reload":	// 초기화
			kepReload('CommonNoNeSentSmsPop');
			mySheet.RemoveAll();
			
			//조회조건 초기값 설정
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
			break;
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction('search');
	}
}

</script> 
<body onload="kep_onload_view()">
<form name="CommonNoNeSentSmsPop" id="CommonNoNeSentSmsPop" method=post >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">보낸문자함</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
            	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>  
			</div>
			
       		<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
					<caption>보낸문자함</caption>
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
					<tbody>
						<tr>
							<td>전송기간</td>
							<td>  
								<input type="text"  class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:90px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								~
								<input type="text"  class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:90px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
							</td>
							<td>수신전화번호</td>
							<td>
								<input type="text" class="input_type_text" name="st_recv_phone" id="st_recv_phone" value="" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" onkeydown="kepEnter()" style="ime-mode:active; width:150px;" maxlength="11">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
            
            <br>
            
            <!--grid-->
			<div>
				<script type="text/javascript">
					createIBSheet("mySheet", "", "320px");
				</script>
			</div>
			
			<div id="pageindex"></div>
        </div>
    </div>
</form>
</body>
</html>
