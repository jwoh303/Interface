<%--
**********************************************
* 메뉴 : 
* 화면 : 물류 공지사항 등록 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 이수영 ( 설계 : 이수영 )
* 착수일 : 2014-10-07
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
<%
@SuppressWarnings (value="unchecked")
Map<String,String> rowData = (Map<String,String>) request.getAttribute("data"); // 조회된결과
Map<String,String> warehouseData = (Map<String,String>) request.getAttribute("warehouseCode"); // 조회된결과
String st_bid = CommonUtil.nvl((String) request.getParameter("st_bid"),"");

String _warehouseCode = "";
String whAdmin = _sessionInfo.getWhAdmin();
String _subject = "";
String _regUserName = _sessionInfo.getUserNameLoc();
String _regDate = "";
String _company = "";
String _fromDate = "";
String _toDate = "";
String _context = "";
String _imageKey = "";

if (warehouseData != null) {
	_warehouseCode = warehouseData.get("WAREHOUSE_CODE");
}

if (rowData != null) {
	_subject = rowData.get("SUBJECT");
	_regUserName = rowData.get("REG_USER_NAME");
	_regDate = CommonUtil.formatDate(String.valueOf(rowData.get("REG_DATE")));
	_company = rowData.get("COMPANY");
	_fromDate = CommonUtil.formatDate(String.valueOf(rowData.get("FROM_DATE")));
	_toDate = CommonUtil.formatDate(String.valueOf(rowData.get("TO_DATE")));
	_context = rowData.get("SUBJECT");
	_imageKey = rowData.get("IMAGE_KEY");
}
%>
<script type="text/javascript">
<!--
var popupSel = "";
function kep_onload_view() {
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<% if (rowData == null) { %>
	$("#reg_date").text(kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_from_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_to_date").val(kepToMonthAdd("1","P"));
	<% } %>
}

//기능함수
function doAction(str) {
	st = new Date();

	switch (str) {
		case "save":			// 반려
			kepAjaxFormCall("/wmst/saveMasterWmstNoticeWritePop.do","masterWmstNoticeWritePop", str);
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("공지사항 저장이 정상적으로 완료되었습니다.");
			setReturn("OK");
		} else if (sMsg == "ERR") {
			alert("공지사항 저장에 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function doPop(str, val) {
	popupSel = str;

	switch (str) {
		case "detailView":		// 물류 공지사항 수정보기
			openSearchPopup("/wmst/showMasterWmstNoticeWritePop.do", "?st_bid="+val, "800,600,no");
			break;
		case "fileUpload":		//파일업로드
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO=" + val, "500,430,no");
			break;	
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
		case "fileUpload": //파일업로드
			$("#st_image_key").val(code);
			break;
	}
	grbRow = ""; //초기화
}

function setReturn(value1, value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}
 //-->
</script> 
<body onload="kep_onload_view()">
<div id="popWrapper" style="height:604px;">
	<div id="popHeader">
		<h1 class="title">공지사항</h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	</div>
	
	<!--팝업내용입니다-->
	<div id="popContainer" style="height:517px;">
		<div class="contArea" style="height:440px">
			<form id="masterWmstNoticeWritePop" name="masterWmstNoticeWritePop" method="post" >
				<input type="hidden" id="st_bid" name="st_bid" value="<%=st_bid%>"/>

				<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
				<input type="hidden" id="st_image_key" name="st_image_key" value="<%=_imageKey %>"/>
				<input type="hidden" id="st_password" name="st_password" value=""/>
				<input type="hidden" id="st_open_flag" name="st_open_flag" value="Y"/>
				
				<table  class="board_write" >
					<caption>게시글 작성</caption>
					<colgroup>
						<col width="18%" />
						<col width="25%" />
						<col width="18%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
				    		<th scope="row"><label for="u_SUBJECT">제목</label></th>
				    		<td colspan="3"><input type="text" id="st_subject" name="st_subject" title="" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="<%=_subject %>"  style="width:98%"/></td>
				    	</tr>
				    	<tr>
				    		<th scope="row"><label for="u_REG_USER_NAME">작성자</label></th>
				    		<td><%=_regUserName %></td>
				    		<th scope="row"><label for="u_REG_DATE">작성일</label></th>
				    		<td><span id="reg_date"><%=_regDate %></span></td>
				    	</tr>
				    	<tr>
				    		<th scope="row"><label for="u_ACL">게시범위</label></th>
				    		<td>
				    			<select id="st_company" name="st_company" style="width:80%;height:20px" <%=whAdmin.equals("Y") ? "" : "disabled"%>></select>
				    			<script type="text/javascript">kepAjaxCommonQueryIdCombo('st_company','common.wmst.getMasterWmstNoticeWritePopWareHouseList','','<%=_warehouseCode%>');</script>
				    		</td>
				    		<th scope="row"><label for="u_FROM_DATE">게시기간</label></th>
				    		<td><input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:80px; text-align:center;" value="<%=_fromDate %>" /> - <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:80px; text-align:center;" value="<%=_toDate %>" /></td>
				    	</tr>
				    	<tr>
				    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
				    		<td colspan="3"><textarea id="st_context" name="st_context" style="width:100%; height:300px;"><%=_context %></textarea></td>
				    	</tr>
				    	</tbody>
				    </table>
                    
				</form>
			</div>
			<div class="btnArea">
				<div class="fr">
					<span class="btn_02 mt10" >	<a href="javascript:doAction('save', '<%=st_bid%>');">저장</a></span>
	            </div>
        	</div>
        </div>
    </div>         
 </body>
</html>
