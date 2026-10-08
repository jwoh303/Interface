<%--
**********************************************
* 메뉴 : 
* 화면 : 물류 공지사항 상세 팝업
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
String st_bid = CommonUtil.nvl((String) request.getParameter("st_bid"),"");
String st_user_id = _sessionInfo.getUserId();
String _regUserId = "";

%>
<script type="text/javascript">
<!--
var popupSel = "";

//기능함수
function doAction(str) {
	st = new Date();

	switch (str) {
		case "del":			// 반려
			if (confirm("공지사항을 삭제 하시겠습니까?")) {
				kepAjaxFormCall("/wmst/deleteMasterWmstNoticeDetailPop.do","masterWmstNoticeDetailPop", str);
			}
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "del") {
		if (sMsg == 'OK') {
			alert("공지사항 삭제가 정상적으로 완료되었습니다.");
			setReturn("OK");
		} else if (sMsg == "NO") {
			alert("공지사항 게시자만 삭제할수 있습니다.\n다시 확인하여 주십시요!");
            return;
		} else if (sMsg == "ERR") {
			alert("공지사항 삭제에 실패 하였습니다.\n다시 확인하여 주십시요!");
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
		case "detailView":		// 물류 공지사항 상세보기
			openSearchPopup("/wmst/showMasterWmstNoticeDetailPop.do", "?st_bid="+val, "800,600,no");
			break;
		case "write":				// 물류 공지사항 글쓰기
			setReturn(str, val);
			//openSearchPopup("/wmst/showMasterWmstNoticeWritePop.do", "?st_bid="+val, "800,600,no");
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
<body onload="">
<div id="popWrapper" style="height:604px;">
	<div id="popHeader">
		<h1 class="title">공지사항</h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	</div>
	
	<!--팝업내용입니다-->
	<div id="popContainer" style="height:517px;">
		<div class="scrollArea" style="height:440px">
			<form name=masterWmstNoticeDetailPop id=masterWmstNoticeDetailPop method=post >
				<input type="hidden" id="st_bid" name="st_bid" value="<%=st_bid%>"/>
				<input type="hidden" id="st_user_id" name="st_user_id" value="<%=st_user_id%>"/>
				
				<% if (rowData != null) { %>
				<% _regUserId = String.valueOf(rowData.get("REG_USER_ID")); %>	 
				<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
				<input type="hidden" id="st_image_key" name="st_image_key" value="<%=rowData.get("IMAGE_KEY") %>"/>
				
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
				    		<td colspan="3"><%=rowData.get("SUBJECT") %></td>
				    	</tr>
				    	<tr>
				    		<th scope="row"><label for="u_REG_USER_NAME">작성자</label></th>
				    		<td><%=rowData.get("REG_USER_NAME") %></td>
				    		<th scope="row"><label for="u_REG_DATE">작성일</label></th>
				    		<td><%=CommonUtil.formatDate(String.valueOf(rowData.get("REG_DATE"))) %></td>
				    	</tr>
				    	<tr>
				    		<th scope="row"><label for="u_ACL">게시범위</label></th>
				    		<td><%=rowData.get("ACL_DIS") %></td>
				    		<th scope="row"><label for="u_FROM_DATE">게시기간</label></th>
				    		<td><%=CommonUtil.formatDate(String.valueOf(rowData.get("FROM_DATE"))) %> - <%=CommonUtil.formatDate(String.valueOf(rowData.get("TO_DATE"))) %></td>
				    	</tr>
				    	<tr>
				    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
				    		<td colspan="3" style="vertical-align:top; height:300px;"><%=rowData.get("CONTEXT").replaceAll("\n\r", "<br />") %></td>
				    	</tr>
						<% if (rowData.get("IMAGE_KEY") != null && !"".equals(rowData.get("IMAGE_KEY")) ){ %>
				    	<tr>
				    		<th scope="row"><label for="u_FILE">첨부파일</label></th>
				    		<td colspan="3"> 
				    		<a href="javascript:doPop('fileUpload', '<%=rowData.get("IMAGE_KEY")%>');"> <img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
				            </td>
				    	</tr>
						<% } %>
				    	</tbody>
				    </table>
			    <%}%>                     
				</form>
			</div>
			<div class="btnArea">
				<% if (_regUserId.equals(st_user_id)) { %>
				<div class="fr mt10">
					<span class="btn_02" ><a href="javascript:doPop('write', '<%=st_bid%>');">수정</a></span>
					<span class="btn_02" ><a href="javascript:doAction('del');">삭제</a></span>
	            </div>
	            <% } %>
        	</div>
        </div>
    </div>         
 </body>
</html>
