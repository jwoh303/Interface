<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) 견적 마감시간 연장
* 기능 : 목록·매입가제출 상세의 [마감시간연장]에서 연다. 고른 마감일시를 opener 로 넘긴다.
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script>
var popupSel = "";

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
	case "calendarHour":
		popupSel = "calendarHour";
		openSearchPopup("/common/calendarAndHourPop.do",'',"300,300,no");
		break;
		
	}
}
function setPopupReturn(value1,value2,value3){
	if(popupSel == "calendarHour"){
		$('#st_atos_end_date').val(value1);
		$('#st_atos_end_date_text').val(value1.substr(0,4) + "/" + value1.substr(4,2) + "/" + value1.substr(6,2));
		$('#st_atos_end_time').val(value2);
		$('#st_atos_end_time_text').val(value2.substr(0,2) + ":" + value2.substr(2,2) + ":" + value2.substr(4,2));
	
	}
}
</script>
</head>

<body>
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<div id="popWrapper" style="height:402px;">
    	<div id="popHeader">
        	<h1 class="title">견적 마감시간 연장 </h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>

        <div id="popContainer" style="height:323px;">
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
