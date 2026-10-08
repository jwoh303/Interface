<%--
**********************************************
* 메뉴 : 개선제안제도 > 개선제안등록
* 화면 : 개선제안등록
* 기능 : 개선제안등록
* 프로그램 ID : 
* 담당자 :  한승준( 설계 : 현명환 )
* 착수일 : 2015-12-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String user_id = _sessionInfo.getUserId();
String user_dept = _sessionInfo.getDepartment();
String com_code = _sessionInfo.getComCode();

String check_date = DateTimeUtil.getFormatString("yyyyMMddHHmm");
String year = check_date.substring(0,4);
String month = check_date.substring(4,6);
String day = check_date.substring(6,8);

String check_time = check_date.substring(8,12);
String hour = check_time.substring(0,2);
String minutes = check_time.substring(2,4);
String st_pp_type = CommonUtil.nvl((String) request.getParameter("st_pp_type"),"");
String st_subject = CommonUtil.nvl((String) request.getParameter("st_subject"),"");
%>

<script src="/resources/js/common.js"></script>
<script type="text/javascript">
var popupSel = "";
var clrImg_flag = "Y";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_pp_type','getSrsysTypeList','M147','4','','');
}

function doReload(){
	kepReload("contentForm");
	
	$("#st_image_key").val("");
	$("#st_image_key_text").val("");
	$("#PP_NO").val("");
	$("#st_pp_remark").val("* 제안내역은 450자 이내로 작성하여야 합니다.");
	clrImg_flag = "Y";
}

//기능함수
function doAction(str) {
	switch (str) {
		case "reload":	// 초기화
			doReload();
			break;
			
		case "save": // 저장
			if (checkSubmit(str)) {
				kepAjaxFormCall("/mdpp/saveMasterMdPpPropRegList.do","contentForm","save");
			}
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg.msg;
	
	if (pMethod == "save") { //요청
		if (sMsg == "OK") {
			alert("정상적으로 제안요청 작성되었습니다.");
			doAction("reload");
			return;
		} else {
			alert("제안요청 처리하던중 오류가 발생하였습니다");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("제안요청 처리하던중 오류가 발생하였습니다.");
} 

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case 	"fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=SR", "500,430,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "fileUpload") {
		$("#st_image_key").val(code);
		$("#st_image_key_text").val(text);
	}
}

//textarea 백그라운드 
function clrImg(obj){
	if(clrImg_flag == "Y"){
		$("#st_pp_remark").val("");
		clrImg_flag = "N";
	}
}

function checkSubmit(str) {
	if(isEmpty($("#st_subject").val())){
       alert("제목을 입력하여 주십시요.");
       $("#st_subject").focus();
       return false;
    }
	
    if(isEmpty($("#st_pp_remark").val())){
       alert("요청내역을 입력하여 주십시요.");
       $("#st_pp_remark").focus();
       return false;
    }
    
    var msg;
    msg = "상기 내용으로 제안하시겠습니까?";
    
    return confirm(msg);
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>개선제안등록</h3>
   		</div>        	
        <!--조회영역-->
       	<form id="contentForm" name="contentForm" method = "post">
       		<!-- HIDDEN -->
			<input type="hidden"	id="st_user_id" name="st_user_id" value="<%=user_id%>">
			<input type="hidden"	id="st_com_code" name="st_com_code" value="<%=com_code%>">
			<input type="hidden"	id="PP_NO" name="PP_NO">
			<!-- HIDDEN -->
			<div>
            	<table class="cont_t_list06" style="width:100%;">
					<caption>개선제안등록</caption>
					<colgroup>
						<col width="120px" />
						<col width="32%" />
						<col width="120px" />
						<col width="32%" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제안자</th>
							<td class="left" >
								&nbsp;&nbsp;<%=_sessionInfo.getDepartmentName()%> <%=_sessionInfo.getUserNameLoc()%>
							</td>
							<th scope="row">제안일</th>
							<td class="left" >
								&nbsp;&nbsp;<%=year%>년 <%=month%>월 <%=day%>일 <%=hour%>시 <%=minutes%>분
							</td>
						</tr>
						<tr>
							<th scope="row">제안분류</th>
							<td colspan="3">
								<select id="st_pp_type" name="st_pp_type" ></select>
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td  colspan="3">
								<input type="text" id="st_subject"  name="st_subject"  class="input_type_text" style="width:90%;ime-mode:active" maxlength="100">
							</td>
						</tr>
						<tr>
							<th scope="row">제안내역</th>
							<td colspan="3" >
								<textarea name="st_pp_remark" class="input_type_text" rows=17 style="padding:3px;width:90%;ime-mode:active" maxlength="450" id="st_pp_remark" onkeydown="clrImg(this)" onmousedown="clrImg(this)">
* 제안내역은 450자 이내로 작성하여야 합니다.
								</textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">첨부파일</th>
							<td colspan="3" >
								<input type="hidden" id="st_image_key" name="st_image_key" value="" />
								<input type="hidden" id="st_image_key_Text" 	name="st_image_key_Text" class="input_type_text" title="" style="width: 250px;" value="" />
								<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileUpload')">첨부등록</a></span>
							</td>
						</tr>
					</tbody>
				</table>	
            </div>
		</form>
<!--버튼영역-->
		<div class="btnArea">
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('save');">제안</a></span>
			</span>
		</div>
		<div class="btnArea">
			<span class="fl">
			</span>
		</div>
		
<!--내용 종료-->	                 
</body>
</html>
