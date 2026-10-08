<%--
**********************************************
* 메뉴 : 회원사관리> 고객사 리포트 현황 > 총평
* 화면 : 회원사관리> 고객사 리포트 현황 > 총평
* 기능 : 
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
 
<script>
var popupSel = "";
var mySheet = new ibsheetObject();
var grbRow = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function popupOnload(){
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "save":
			if (checkSaveSubmit()) {
			    if(!confirm("저장 하시겠습니까?")) {
			        return;
			    }else{
			    	kepAjaxFormCall("/mdct/saveMasterMdCtReportSalesEvaluationPop.do","searchCondition","ReportSalesEvaluationPop");
			    }
			}
			break;
	}
}

function checkSaveSubmit(){

	//입력 필수값 체크
	if (isEmpty($("#st_eval_title1").val())) {
		alert("총평 제목 입력이 필요합니다.");
		$("#st_eval_title1").focus();
		return false;
	}
	if (isEmpty($("#st_eval_title2").val())) {
		alert("총평 제목 입력이 필요합니다.");
		$("#st_eval_title2").focus();
		return false;
	}
	if (isEmpty($("#st_eval_cont1").val())) {
		alert("총평 내용 입력이 필요합니다.");
		$("#st_eval_cont1").focus();
		return false;
	}
	if (isEmpty($("#st_eval_cont2").val())) {
		alert("총평 내용 입력이 필요합니다.");
		$("#st_eval_cont2").focus();
		return false;
	}
	//총평 상태 Y 업데이트
	$("#st_status_yn").val("Y");
	return true;
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert(response.Message);
	this.close();
	opener.doAction("search");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if( pMethod =="ReportSalesEvaluationPop"){
		alert("정상적으로 저장 되었습니다.");
		this.close();
		opener.doAction("search");
	}	
}

function text_length_cnt(id, text_id, length){
	var content = $("#" + id).val();
	$("#" + text_id).val("(" + content.length + "/ " + length + "자)"); //실시간 글자수 카운팅
}
</script> 
</head>
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post">
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	<input type="hidden" id="st_status_yn"  name="st_status_yn" value="">
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
			<h1 class="title">총 평</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:518px;">
            <!--조회영역-->
            <h4><b>총평 등록 1</b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				<col width="20%"/>
                <col width="80%" />
				</colgroup>
				<tbody>
					<tr>	
						<th>제  목<br>
							<input type="text" placeholder="(0/20자)" id="st_eval_title_length1" style="width:80px;border:none;outline:none;background:transparent;" readOnly>
						</th>
						<td>
							<input type="hidden" id="st_report_no"  name="st_report_no" value="<%=CommonUtil.nvl(_rowData.get("REPORT_NO"))%>">
							<input type="text" name="st_eval_title1" id="st_eval_title1" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("EVALUATION_TITLE_1"))%>" maxlength="20" onkeyup="text_length_cnt(this.id, 'st_eval_title_length1', 20);"/>
						</td>
					 </tr>
					 <tr>	
					  	<th>내  용<br>
							<input type="text" placeholder="(0/500자)" id="st_eval_cont_length1" style="width:80px;border:none;outline:none;background:transparent;" readOnly></th>  		
						<td>
							<textarea name="st_eval_cont1" id="st_eval_cont1"  style="width:90%;overflow:auto; border-color:white; border-width:0;" rows="11" maxlength="500" onkeyup="text_length_cnt(this.id, 'st_eval_cont_length1', 500);"><%=CommonUtil.nvl(_rowData.get("EVALUATION_CONTENTS_1"))%></textarea>
						</td>
					</tr>
				</tbody>
			</table>	
            <h4><b>총평 등록 2 </b></h4>
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
				<col width="20%"/>
                <col width="80%" />
				</colgroup>
				<tbody>
					<tr>	
						<th>제  목<br>
							<input type="text" placeholder="(0/20자)" id="st_eval_title_length2" style="width:80px;border:none;outline:none;background:transparent;" readOnly></th>  		
						<td>
							<input type="text" name="st_eval_title2" id="st_eval_title2" class="input_type_text" title=""  style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("EVALUATION_TITLE_2"))%>" maxlength="20" onkeyup="text_length_cnt(this.id, 'st_eval_title_length2', 20);"/>
						</td>
					 </tr>
					 <tr>	
					  	<th>내  용<br>
							<input type="text" placeholder="(0/500자)" id="st_eval_cont_length2" style="width:80px;border:none;outline:none;background:transparent;" readOnly></th>  		
						<td>
							<textarea name="st_eval_cont2" id="st_eval_cont2"  style="width:90%;overflow:auto; border-color:white; border-width:0;" rows="11" maxlength="500" onkeyup="text_length_cnt(this.id, 'st_eval_cont_length2', 500);"><%=CommonUtil.nvl(_rowData.get("EVALUATION_CONTENTS_2"))%></textarea>
						</td>
					</tr>
				</tbody>
			</table>				
		<!--버튼영역-->
		<p class="btnArea mt10 mb05">
			<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
		</p>
		</div>
	</div>
</form> 
</body>
</html>
