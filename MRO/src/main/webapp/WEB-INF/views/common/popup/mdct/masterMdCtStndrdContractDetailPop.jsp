<%--
**********************************************
* 메뉴 : 
* 화면 : 표준계약서 조회 상세 
* 기능 : 계약서 작성위한 표준계약서 상세정보 조회
* 프로그램 ID : PG_02_M_001_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-31
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _rowData = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 

String st_form_no = CommonUtil.nvl((String) request.getParameter("st_form_no"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function kepSearch() {  
	$('#masterMdCtStndrdContractDetailPop').attr("action", "/mdct/showMasterMdCtStndrdContractDetailPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search":	 // 조회
			$('#masterMdCtStndrdContractDetailPop').attr("action", "/mdct/showMasterMdCtStndrdContractDetailPop.do").submit();
			break;
		case "delete":		// 삭제
			if (confirm("표준계약서를 삭제 하시겠습니까?")) {
				kepAjaxFormCall("/mdct/deleteMasterMdCtStndrdContractDetailPop.do","masterMdCtStndrdContractDetailPop", str);
			}
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "delete") {
		if (sMsg == 'OK') {
			alert("표준계약서가 정상적으로 삭제되었습니다..");
			setReturn("OK");
		} else if (msg == "ERR") {
			alert("표준계약서 삭제에 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		} else {
			alert(msg);
			return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "modify") {
		kepSearch();
	}
	grbRow="";	//초기화
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;

	switch (str) {
		case "modify": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtStndrdContractWritePop.do", "?st_form_no=" + $("#st_form_no").val(), "820, 700,no");
			break;
	}
}
 //-->
</script> 
<body onload="">
<form name="masterMdCtStndrdContractDetailPop" id="masterMdCtStndrdContractDetailPop" method=post >
<input type="hidden" id="st_form_no" name="st_form_no" value="<%=st_form_no %>" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
    	<div id="popHeader">
        	<h1 class="title">표준계약서 조회 상세 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="contArea" style="height:624px">
                <% if (_rowData != null) {  %>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>표준계약서 조회 상세</caption>
	                <colgroup>
	                    <col width="12%" />
	                    <col width="30%" />
	                    <col width="12%" />
	                    <col width="20%" />
	                    <col width="12%" />
	                    <col width="*" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">서식이름</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("FORM_NAME"))%></td>
	                        <th scope="row">사업구분</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("BIZ_TYPE"))%></td>
	                        <th scope="row">회원사유형</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("COMPANY_TYPE"))%></td>
						</tr>
						<tr>
							<th scope="row">설명</th>
	                        <td colspan="5"><%=CommonUtil.nvl(_rowData.get("DESCRIPTION"))%></td>
						</tr>
					</tbody>
				</table>
				<div class="scrollArea" style="text-align:left; height:445px; padding:5px;;"><%=CommonUtil.nvl(_rowData.get("FORM_CONTENT"))%></div>
				<table  class="cont_t_list06 mt05" style="width:100%;">
	                <caption>표준계약서 조회 상세</caption>
	                <colgroup>
	                    <col width="12%" />
	                    <col width="*" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">작성자</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("WRITER_NAME"))%></td>
						</tr>
						<tr>
							<th scope="row">작성일</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("WRITE_DATE"))%></td>
						</tr>
					</tbody>
				</table>
				<% } %>	
				<!--버튼영역-->
				<div class="btnArea mt10 mb05">
					<span class="fl">
						<span class="btn_02 mr04"><a href="javascript:doPop('modify'); ">서식수정</a></span>
						<span class="btn_02"><a href="javascript:doAction('delete');">서식삭제</a></span>
					</span>	
				</div>	                
        </div>
    </div>        
</div>
</form> 
</body>
</html>
