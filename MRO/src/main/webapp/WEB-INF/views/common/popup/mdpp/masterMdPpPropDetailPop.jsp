<%--
**********************************************
* 메뉴 : 개선제안제도 > 개선제안현황 > 개선제안 상세 팝업
* 화면 : 개선제안 상세 팝업
* 기능 : 개선제안 상세 팝업
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 현명환 )
* 착수일 : 2015-12-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = _dataList != null && _dataList.size() > 0 ? _dataList.get(0) : null;

String sessionUserId = _sessionInfo.getUserId();
String sessionComCode = _sessionInfo.getComCode();

String st_req_user_id = CommonUtil.nvl((String) request.getParameter("st_req_user_id"), "");
String st_pp_no = CommonUtil.nvl((String) request.getParameter("st_pp_no"), "");
String st_pp_type = CommonUtil.nvl((String) request.getParameter("st_pp_type"),"");
%>

<script type="text/javascript">
var popupSel = "";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	//콤보데이터 셋팅
	kepAjaxCommonQueryIdSearchTwoCombo('st_pp_type','getSrsysTypeList','M147','4','','');
}

//팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case 	"fileUploadReq": //요청파일 첨부보기
			var st_req_image_key = $("#st_req_image_key").val();
			if(st_req_image_key == ""){
				alert("첨부된 파일이 없습니다.");
			}else{
				var viewType="R";
				openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+st_req_image_key+"&TYPE=SR&viewType="+viewType, "500,430,no");
			}
			break;
	}
}

//기능함수
function doAction(str) {
	switch (str) {
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;
	var alertMsg = "";
	
	if (sMsg == "OK") {
	}else{
		alertMsg = "처리 하던중 오류가 발생하였습니다.";
	}
	
	alert(alertMsg);
	
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod , response) {
	alert("처리 하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("처리 하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
	}
}
</script> 
<body onload="kep_onload_view();">
	 <form name="masterMdPpPropDetailPop" id="masterMdPpPropDetailPop" method="post" >
	 <input type="hidden" id="st_user_id" name="st_user_id"	value="<%=sessionUserId %>">
	 <input type="hidden" id="st_req_user_id" name="st_req_user_id"	value="<%=st_req_user_id %>">
	 <input type="hidden" id="st_pp_no" name="st_pp_no"	value="<%=st_pp_no %>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:704px;">
    	<div id="popHeader">
        	<h1 class="title">개선제안 상세내역 보기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div class="scrollArea" style="height:530px">
<%
if(_dataList == null || _dataList.size() <= 0){
%>
			<table  class="cont_t_list06 mb15" summary="개선제안 상세내역 보기" style="width:100%;">
				<caption>개선제안 상세내역 보기</caption>
				<colgroup>
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="23%" />
					<col width="10%" />
					<col width="24%" />
				</colgroup>
				<tbody>
		    	<tr>
					<td colspan="6" class="center"><font color="blue"><b>조회 된 데이터가 없습니다.</b></font></td>
				</tr>
		        </tbody>
		   </table>
<%	
}else{
%>
			<table  class="cont_t_list06 mb15" summary="개선제안 상세내역 보기" style="width:100%;">
				<caption>개선제안 상세내역 보기</caption>
				<colgroup>
					<col width="11%" />
					<col width="21%" />
					<col width="11%" />
					<col width="21%" />
					<col width="11%" />
					<col width="22%" />
				</colgroup>
				<tbody>
		    	<tr>
		    		<th scope="row">제안번호</th>
					<td>
					<b>
					<%=CommonUtil.nvl(rowData.get("PP_NO"))%>
					</b>
					</td>
					<th scope="row">진행상태</th>
					<td><b><%=CommonUtil.nvl(rowData.get("STATUS"))%></b></td>
					<th scope="row">제안자</th>
					<td><%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%></td>
				</tr>
		    	<tr> 
		    		<th scope="row">제안영역</th>
					<td>
						<select id="st_pp_type" name="st_pp_type" ></select>
					</td>
					<th scope="row">제안일시</th>
					<td><%=CommonUtil.nvl(rowData.get("ADD_DATE"))%></td>
					<th></th>
					<td></td>
				</tr>
				<tr> 
		    		<th scope="row">제목</th>
					<td colspan="5"><%=CommonUtil.nvl(rowData.get("PP_SUBJECT"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">제안내역</th>
					<td colspan="5"  height="250px"><%=CommonUtil.formatHTMLCode(rowData.get("PP_REMARK"))%></td>
				</tr>
				<tr> 
		    		<th scope="row">첨부파일</th>
					<td colspan="5">
					<input type="hidden" id="st_req_image_key" name="st_req_image_key" value="<%=CommonUtil.nvl(rowData.get("PP_REQ_ATTKEY"))%>" />
					<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileUploadReq')">첨부보기</a></span>
					</td>
				</tr>
		        </tbody>
		   </table>
<% } %>
        </div>
        </div>
    </div>         
</form> 
</body>
</html>
