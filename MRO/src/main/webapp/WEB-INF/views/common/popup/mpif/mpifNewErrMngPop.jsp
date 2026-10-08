<%--
**********************************************
* 메뉴 : 인터페이스 모니터링 관리 팝업
* 화면 : 요청번호 팝업
* 기능 : 
* 프로그램 ID :
* 담당자 : 
* 착수일 : 2024-04-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String st_user_id = CommonUtil.nvl((String)request.getAttribute("st_user_id"),""); // 
Map<String,String> rowData = _dataList != null && _dataList.size() > 0 ? _dataList.get(0) : null;
%>

<script type="text/javascript">
//기능함수
var btnMode ="";

function doAction(str) {
	switch (str) {
		
		case "approval":	 // 승인
			btnMode ='2';
			if ( !searchValidate() )
				return;
			if(confirm("접수 처리하시겠습니까? 접수 전에 처리 내용을 저장해주세요!")){
				$("#st_recv_flag").val("A");
				kepAjaxPopFormCall("/mpif/saveMpifNewErrMngPop.do","MpifNewErrMngPopForm","approval");
			}
			break;
		case "proc":	 // 완료
			btnMode ='3';
			if ( !searchValidate() )
				return;
			if(confirm("완료 처리 하시겠습니까?  접수 전에 처리 내용을 저장해주세요!")){
				$("#st_recv_flag").val("P");
				kepAjaxPopFormCall("/mpif/saveMpifNewErrMngPop.do","MpifNewErrMngPopForm","proc");
			}
			break;
		case "save":	//저장
			if(confirm("이전 내용을 삭제 됩니다! 처리내용을 저장 하시겠습니까? ")){
				$("#st_recv_flag").val("S");
				kepAjaxPopFormCall("/mpif/saveMpifNewErrMngPop.do","MpifNewErrMngPopForm","save");
			}
			break;
	}
}
//조회조건 체크
function searchValidate() {
	if ( "3" == $("#PGMSTATUS").val()) {
		alert("처리 완료된 오류 입니다.");
		return false;
	}else if ( btnMode == "3" && $("#PGMSTATUS").val() =="0") {
		alert("접수되지 않은 오류 입니다.");
		return false;
	}
	else if ( btnMode == $("#PGMSTATUS").val()) {
		alert("접수되어 처리중인 오류 입니다.");
		return false;
	}
	return true;
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;
	var alertMsg = "";
	
	if (sMsg == "OK") {
		if(pMethod == "save"){
			alertMsg = "정상적으로 처리내용이 저장되었습니다.";
		}else if(pMethod == "approval"){
			alertMsg = "정상적으로 승인처리 되었습니다.";
		}else if(pMethod == "proc"){
			alertMsg = "정상적으로 처리 되었습니다.";
		}
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

</script> 

<body>
	<form name="MpifNewErrMngPopForm" id="MpifNewErrMngPopForm" method="post" >
	<input type="hidden" id="err_seq" name="err_seq" value="<%=CommonUtil.nvl(rowData.get("SEQ"))%>">
	<input type="hidden" id="st_user_id"  name="st_user_id"  value="${st_user_id}">
	<input type="hidden" id="PGM_ID"  name="PGM_ID"  value="<%=CommonUtil.nvl(rowData.get("PGM_ID"))%>">
	<input type="hidden" id="PGMSTATUS"  name="PGMSTATUS"  value="<%=CommonUtil.nvl(rowData.get("STATUSIMG"))%>">
	<input type="hidden" id="st_recv_flag" name="st_recv_flag"	value=""> 
	 	<div id="popWrapper" style="height:500px;">
	 		<div id="popHeader">
	        	<h1 class="title">인터페이스 오류 접수 및 처리</h1>
	            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
	        </div>
	         <!--팝업내용입니다-->
	         <div id="popContainer">
	         	<table  class="cont_t_list06 mb15" summary="인터페이스 오류 상세보기" style="width:100%;">
	         		<colgroup>
						<col width="12%" />
						<col width="13%" />
						<col width="12%" />
						<col width="13%" />
						<col width="12%" />
						<col width="13%" />
						<col width="12%" />
						<col width="13%" />
					</colgroup>
	         		<tbody>
	         			<tr>
							<th scope="row">프로그램</th>
							<td colspan="3"><b><%=CommonUtil.nvl(rowData.get("PGM_ID"))%></b></td>
							<th scope="row">프로그램명</th>
							<td colspan="3"><b><%=CommonUtil.nvl(rowData.get("PGM_NAME"))%></b></td>
	         			</tr>
	         			<tr>
							<th scope="row">발생일</th>
							<td><b><%=CommonUtil.nvl(rowData.get("CREATE_DATE"))%></b></td>
							<th scope="row">발생시간</th>
							<td><b><%=CommonUtil.nvl(rowData.get("CREATE_TIME"))%></b></td>
							<th scope="row">유형</th>
							<td><b><%=CommonUtil.nvl(rowData.get("ERR_TYPE"))%></b></td>
							<th scope="row">상태</th>
							<td><b><%=CommonUtil.nvl(rowData.get("STATUS"))%></b></td>
	         			</tr>
	         			<tr>
							<th scope="row">접수자</th>
							<td><b><%=CommonUtil.nvl(rowData.get("RECEIPT_USER_ID"))%></b></td>
							<th scope="row">접수일시</th>
							<td><b><%=CommonUtil.nvl(rowData.get("RECEIPT_DATE"))%></b></td>
							<th scope="row">완료자</th>
							<td><b><%=CommonUtil.nvl(rowData.get("COMPLETE_USER_ID"))%></b></td>
							<th scope="row">완료일자</th>
							<td><b><%=CommonUtil.nvl(rowData.get("COMPLETE_DATE"))%></b></td>
	         			</tr>
	         				<tr>
							<th>오류제목</th>
							<td colspan="7"><b><%=CommonUtil.nvl(rowData.get("ERR_TITLE"))%></b></td>
	         			</tr>
	         			<tr>
							<th>오류내용</th>
							<td colspan="7"><b><%=CommonUtil.nvl(rowData.get("ERR_NOTE"))%></b></td>
	         			</tr>
	         			<tr>
							<th>처리</th>
							<td colspan="7">
								<textarea id="st_df_remark"  name="st_df_remark" rows=40 style="padding:3px;width:99%;ime-mode:active" id="remark"><%=CommonUtil.formatHTMLCode(rowData.get("JOB_NOTE")).replaceAll("<br>","\n")%></textarea>
	         				</td>
	         			</tr>
	         		</tbody>
	         	</table>
	         </div>
	        <!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('approval');">접수</a></span>
					<span class="btn_02 mr04"><a href="javascript:doAction('proc');">완료</a></span>
				</span>
	       </div>
	 	</div>
 	</form>
</body>
</html>