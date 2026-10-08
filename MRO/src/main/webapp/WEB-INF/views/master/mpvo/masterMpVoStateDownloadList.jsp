<%--
**********************************************
* 메뉴 : VOC Analysis>현황다운로드
* 화면 : 현황다운로드
* 기능 : 
* 프로그램 ID : PG_90_C_800_10
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String st_user_id			= CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String st_user_dept		= CommonUtil.nvl((String) request.getParameter("st_user_dept"),"");
String st_cd_user_id		= CommonUtil.nvl((String) request.getParameter("st_cd_user_id"),"");
String st_ds_user_id		= CommonUtil.nvl((String) request.getParameter("st_ds_user_id"),"");
String st_from_date		= CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
String st_to_date 			= CommonUtil.nvl((String) request.getParameter("st_to_date"),"");
String st_buyer_code		= CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");
String st_buyer_name	= CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");
String st_recv_flag		= CommonUtil.nvl((String) request.getParameter("st_recv_flag"),"");
String st_ds_dept_code	= CommonUtil.nvl((String) request.getParameter("st_ds_dept_code"),"");
String st_sys_type			= CommonUtil.nvl((String) request.getParameter("st_sys_type"),"");
%>

<script src="/resources/js/common.js"></script>
<script>
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_sys_type','getSrsysTypeList','VC04','1','ALL','<%=st_sys_type%>');
	kepAjaxCommonQueryIdCombo("st_cd_user_id","getUserSelectkorea", "ALL", "<%=st_cd_user_id%>");
	kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "ALL", "<%=st_user_id%>");
	kepAjaxCommonQueryIdSearchTwoCombo('st_recv_flag','getSrsysTypeList','VC02','4','ALL','<%=st_recv_flag%>');
	kepAjaxCommonQueryIdCombo('st_ds_dept_code','getDeptSelectkorea2','ALL','<%=st_ds_dept_code%>');
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
// 기능함수
function doAction(str) {
	switch (str) {
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}

			var st_buyer_code = $('#st_buyer_code').val();
			
			if(kepIsValueNull(st_buyer_code)) {
				alert('고객사 정보는 필수 입력사항입니다.');
				return;
			}
			
			document.forms.searchCondition.action = "/mpvo/excelMasterMpVoStateDownloadList.do";
			document.forms.searchCondition.submit();
			break;
			
		case "reload":	// 초기화
			kepReload('searchCondition');
			//콤보데이터 셋팅
			kepAjaxCommonQueryIdSearchTwoCombo('st_sys_type','getSrsysTypeList','VC04','1','ALL','<%=st_sys_type%>');
			kepAjaxCommonQueryIdCombo("st_cd_user_id","getUserSelectkorea", "ALL", "<%=st_cd_user_id%>");
			kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "ALL", "<%=st_user_id%>");
			kepAjaxCommonQueryIdSearchTwoCombo('st_recv_flag','getSrsysTypeList','VC02','4','ALL','<%=st_recv_flag%>');
			kepAjaxCommonQueryIdCombo('st_ds_dept_code','getDeptSelectkorea2','ALL','<%=st_ds_dept_code%>');
			
			// 조회조건 초기화
			$('#st_buyer_code').val('');
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			break;
			
	}
}
	
// 팝업함수호출
function doPop(str, param) {
	popupSel = str;
	
	switch (str) {
		case "masterMpVoVocCompanyPop": // 고객사 M
			var st_sys_type = $("#st_sys_type").val();
			var fromDate = $("#st_sys_type").val();
			var toDate = $("#st_sys_type").val();
			openSearchPopup("/mpvo/getMasterMpVoVocCompanyPop.do", "?st_fromDate="+fromDate.replace("/","")+"&st_toDate="+toDate.replace("/","")+"&st_sys_type=" + st_sys_type, "500,500,no");
			popupSel = "masterMpVoVocCompanyPop";
			break;
			
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMpVoVocCompanyPop") {	// 다중 고객사
		$("#st_buyer_code").val(value2);
		$("#st_buyer_name").val(value3);
		if(value2 != ""){
			document.forms[0].st_sys_type.selectedIndex = 0;
		}
	}
	
}

//담당자 selectbox 생성
function makeUserSel(){
	var dept = $("#st_ds_dept_code").val();
	
	if(isEmpty(dept)){
		kepAjaxCommonQueryIdCombo("st_ds_user_id","getUserSelectkorea", "ALL", "");
	}else{
		kepAjaxCommonQueryIdSearchCombo("st_ds_user_id","getUserOrderedDept", dept, "ALL", "");
	}
}

//구매사 정보 초기화
function clearBuyer(){
	document.forms[0].st_buyer_code.value = "";
	document.forms[0].st_buyer_name.value = "";
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>현황다운로드</h3>
			<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition"  id="searchCondition" method = "post">
			<!-- HIDDEN -->
			<input type="hidden" id="st_user_id" name="st_user_id"		value="<%=st_user_id%>">
			<input type="hidden" id="st_user_dept" name="st_user_dept"	value="<%=st_user_dept%>">
			<!-- HIDDEN -->
			<div>
            	<table class="cont_t_list06" style="width:100%;">
					<caption>현황다운로드</caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th scope="row">접수일자</th>
							<td>
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
							</td>
							<th scope="row"><font color="red"><b>*</b></font>고객사</th>
							<td>
								<select id="st_sys_type" name="st_sys_type" onchange="clearBuyer();"></select>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:33%" value="" readonly onclick="javascript:doPop('masterMpVoVocCompanyPop');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('masterMpVoVocCompanyPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
						</tr>
						<tr> 
							<th scope="row">접수자</th>
							<td>
								<select id="st_cd_user_id" name="st_cd_user_id"></select>
							</td>
							<th scope="row">처리자</th>
							<td>
								<select id="st_ds_user_id" name="st_ds_user_id"></select>
							</td>
						</tr>
						<tr> 
							<th scope="row">진행상태</th>
							<td>
								<select id="st_recv_flag" name="st_recv_flag"></select>
							</td>
							<th scope="row">사업팀</th>
							<td>
								<select id="st_ds_dept_code" name="st_ds_dept_code" onchange="makeUserSel();"></select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
					
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fr">
				<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>
		</div>

<!--내용 종료-->	                 

</body>
</html>
