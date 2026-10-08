<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 커뮤니티 댓글 상세 조회 팝업
* 기능 : 협력사 커뮤니티 댓글 상세 조회 팝업
* 프로그램 ID : 
* 담당자 : 김영훈
* 착수일 : 2019-11-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	SessionInfo __sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  조회조건
	String SEQ = CommonUtil.nvl((String) request.getParameter("SEQ"),"");  //  조회조건
	String st_comment_revision = CommonUtil.nvl((String) request.getParameter("st_comment_revision"),"");
	String edit_flag = CommonUtil.nvl((String) request.getParameter("st_edit_yn"),"");
	String st_comment_count = CommonUtil.nvl((String) request.getParameter("st_comment_count"),"");
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>

<script type="text/javascript">
// <!--
var popupSel = "";
var cnt = 0;

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
}

//기능함수
function doAction(str) {
	
	switch (str) {
		case "delete":	// 댓글 삭제
			if(!confirm("댓글을 삭제 하시겠습니까?")) return;
			kepAjaxFormCall("/mdcp/deleteMasterMdCpAgentCommunityPopList.do","searchCondition","COMMENT_DELETE");
			break;
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "COMMENT_DELETE"){
		if(opener.name == "searchMasterMdCpAgentCommunityDetailList"){
			var st_agent = TrimCommon($("#com_code").val());
			var st_seq = TrimCommon($("#SEQ").val());
			var st_comment_count = TrimCommon($("#st_comment_count").val());
			var st_edit_yn = "";
			if(st_comment_count == 1){	// 댓글 삭제 전 값이 1일때만 수정 가능상태
				st_edit_yn = "Y";
			}else{
				st_edit_yn = "N";
			}
			opener.location.href = "/mdcp/searchMasterMdCpAgentCommunityDetailList.do?com_code="+st_agent+"&SEQ="+st_seq+"&st_comment_flag=Y"+"&st_edit_yn="+st_edit_yn;
			opener.opener.location.href = opener.opener.location.href;
		}else{
			opener.location.href = opener.location.href;
		}
    	window.close();
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if(pMethod == "COMMENT_DELETE"){
    	alert("시스템 오류입니다. 관리자에게 문의하시기 바랍니다."); 
	}
} 

 //-->
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:530px;">
    	<div id="popHeader">
        	<h1 class="title">협력회사 커뮤니티(댓글)</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" name="com_code" id="com_code" value="<%=com_code%>">
				<input type="hidden" id="SEQ" name="SEQ"  value="<%=SEQ%>">
				<input type="hidden" name="st_comment_revision" id="st_comment_revision" value="<%=st_comment_revision%>">
				<input type="hidden" name="st_comment_count" id="st_comment_count" value="<%=st_comment_count%>">
				
				
	            <!--조회영역-->
	            
				<div id="cont_searchA">
					<%
						Map<String,String> rowData = null;
						for (int j=0; j<_gridList.size(); j++) {
							rowData = _gridList.get(j);
					%> 
					<table class="cont_t_list01" style="width:100%">
			    		<th scope="row" align="center">내용&nbsp;</th>
			    		<td colspan="4"> 
			    		<textarea name="CONTEXT" id="CONTEXT"  rows="15" cols="91" READONLY><%=CommonUtil.nvl(rowData.get("CONTENTS"))%></textarea>
			            </td>
			        </table>
			        <% } %>
		    	</div>
		    	<!--버튼영역-->
		    	<div id="btnArea02">
	            	<%
						if(edit_flag.equals("Y")){
					%>
					<span class="fr">
	            		<span class="btn_02"><a href="javascript:doAction('delete')">삭제</a></span>
	            	</span>
				    <%	} %>
				</div>
		    </form>
		 </div>
	</div>
</body>
</html>
