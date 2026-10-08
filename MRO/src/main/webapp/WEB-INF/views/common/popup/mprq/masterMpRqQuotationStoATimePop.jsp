<%--
**********************************************
* 메뉴 : 
* 화면 : 견적마감시간연장.
* 기능 : 견적마감시간연장.
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 :
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
String st_gubun = CommonUtil.nvl((String) request.getParameter("st_gubun"),"");  //  (조회조건)
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
	
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
}
//기능함수
function doAction(str) {
	switch (str) {
		case "stoa":
			var value1 = $('#st_atos_end_date').val(); 
			var value2 = $('#st_atos_end_time').val();
			opener.setPopupReturn(value1,value2);
			this.close();
			break;

	}
}


function doPop(str) {
	switch (str){
	case "calendarHour": // 견적마감일 선택
		popupSel = "calendarHour";
		openSearchPopup("/common/calendarAndHourPop.do",'',"300,300,no");
		break;
		
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3){
	if(popupSel == "calendarHour"){ // 견적마감일
		$('#st_atos_end_date').val(value1);
		$('#st_atos_end_date_text').val(value1.substr(0,4) + "/" + value1.substr(4,2) + "/" + value1.substr(6,2));
		$('#st_atos_end_time').val(value2);
		$('#st_atos_end_time_text').val(value2.substr(0,2) + ":" + value2.substr(2,2) + ":" + value2.substr(4,2));
	
	} 
	grbRow="";	//초기화
}
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="kep_onload_view();">
<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<!-- 500*350 -->
	<div id="popWrapper" style="height:402px;">
    	<div id="popHeader">
        	<h1 class="title">견적 마감시간 연장 </h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:323px;">
	        <!--버튼영역-->
	        <div class="ml20 mt05"  style="position:relative;width:830px;height:25px;"> 
				<div style="width:690px;position:absolute; left:0;">
				견적마감일 : 
				<input type="hidden" name="st_atos_end_date" id="st_atos_end_date" value="">
				<input type="hidden" name="st_atos_end_time" id="st_atos_end_time" value="">
				<input type="text" name="st_atos_end_date_text" id="st_atos_end_date_text" class="input_type_text"  value="" onclick="javascript:doPop('calendarHour');" readonly>
				<input type="text" name="st_atos_end_time_text" id="st_atos_end_time_text" class="input_type_text"  value=""onclick="javascript:doPop('calendarHour');" readonly>
					<a href="javascript:doPop('calendarHour');"><img src="/resources/images/btn_calendar.gif"></a>
	      		</div>
  			</div>
			<!--버튼영역-->
	        <div class="btnArea mr25 mt10">
				<span class="fr">
					<span class="btn_02"><a href="javascript:doAction('stoa')">확인</a></span>
				</span>
	        </div>
		</div>
    </div>
					
	</form>
		
</body>
</html>
