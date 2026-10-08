<%--
**********************************************
* 메뉴 : 업체선정 및 견적제출 > 일괄 추가라운드 요청
* 화면 : 일괄 추가라운드 요청시 마감 시간
* 기능 : 일괄 추가라운드 요청시 마감 시간
* 프로그램 ID : 
* 담당자 : 최찬규
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
		case "confirm":
			var value1 = $('#st_atos_end_date').val(); 
			var value2 = $('#st_atos_end_time').val();
			var value3 = $('#st_atos_remark').val();
			
			if(value1 == "" || value2 == ""){
				alert("견적마감일을 입력하여 주십시요.");
				return;
			}
			
			opener.setPopupReturn(value1,value2,value3);
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
	case "remarkReturn2Pop"://운영사비고
		popupSel = "remarkReturn2Pop";
		openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+$('#st_atos_remark').val(), "500,230,no");  // 고객사 비고
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
	
	} else if (popupSel == "remarkReturn2Pop"){ // 운영사 비고
		$('#st_atos_remark').val(value1);
		if(value1 ==""){
	 		$("img[id=Image2]").attr("src","/resources/images/icon2.gif");
	 	 }else{
	 		$("img[id=Image2]").attr("src","/resources/images/icon.gif");
	 	 }
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
	<div id="popWrapper" style="height:150px;">
		<div id="popHeader">
			<h1 class="title">추가라운드 요청</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer">
	        <!--버튼영역-->
			<div style="width:100%;position:relative;">
				견적마감일 :
				<input type="hidden" name="st_atos_end_date" id="st_atos_end_date" value="">
				<input type="hidden" name="st_atos_end_time" id="st_atos_end_time" value="">
				<input type="text" name="st_atos_end_date_text" id="st_atos_end_date_text" class="input_type_text" style="width:80px" value="" onclick="javascript:doPop('calendarHour');" readonly>
				<input type="text" name="st_atos_end_time_text" id="st_atos_end_time_text" class="input_type_text" style="width:80px" value="" onclick="javascript:doPop('calendarHour');" readonly>
				<a href="javascript:doPop('calendarHour');"><img src="/resources/images/btn_calendar.gif"></a>
				<br>
				협력사비고 :
				<br>
				<textarea id="st_atos_remark" name="st_atos_remark" rows="4" style="width:100%;" placeholder="일괄 추가라운드 요청은 협력사 비고가 초기화됩니다.&#13;&#10;이전 비고를 활용하시려면 협력사선정 팝업의 건별 추가라운드를 이용하시기 바랍니다." value=""></textarea>
      		</div>
			
			<!--버튼영역-->
	        <div class="btnArea mr05">
				<span class="fr">
					<span class="btn_02"><a href="javascript:doAction('confirm')">확인</a></span>
				</span>
	        </div>
		</div>
    </div>
</form>
</body>
</html>
