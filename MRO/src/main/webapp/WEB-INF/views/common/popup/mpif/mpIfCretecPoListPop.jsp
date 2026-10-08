<%--
**********************************************
* 메뉴 : 인터페이스 관리
* 화면 : 협력사 크레텍 인터페이스 관리
* 기능 : 
* 프로그램 ID :
* 담당자 : 
* 착수일 : 2026-08-27
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
@SuppressWarnings(value="unchecked")
List<Map<String,String>> _dataList=(List<Map<String,String>>)request.getAttribute("data");
String st_user_id=CommonUtil.nvl((String)request.getAttribute("st_user_id"),"");
Map<String,String> rowData=_dataList!=null&&_dataList.size()>0?_dataList.get(0):new java.util.HashMap<String,String>();

String ifFlag=CommonUtil.nvl(rowData.get("IF_FLAG"));
String ifFlagName="";
if("S".equals(ifFlag)){
	ifFlagName="전송 성공";
}else if("F".equals(ifFlag)){
	ifFlagName="전송 실패";
}else if("N".equals(ifFlag)){
	ifFlagName="전송 대기";
}else if("D".equals(ifFlag)){
	ifFlagName="재전송 처리";
}
%>
<script type="text/javascript">
var btnMode="";

function doAction(str){
	switch(str){
		case "cancel":
			window.close();
			break;
		case "proc":
			if($("#seller_item_exists_yn").val()!="Y"){
				alert("현재 공급사 품목코드가 없어 재전송할 수 없습니다.");
				return;
			}
			var resendReason=$.trim($("#resendReason").val());
			if(resendReason==""){
				alert("재전송 사유를 입력해 주세요.");
				$("#resendReason").focus();
				return;
			}
			if(!$("#confirmResend").is(":checked")){
				alert("기존 협력사 발주 상태와 필요한 후속 조치를 확인하고 체크 후 진행해 주세요.");
				$("#confirmResend").focus();
				return;
			}
			// 재전송 처리 로직
			if(confirm("해당 발주를 재전송하시겠습니까?")){
				btnMode="proc";
				$("#st_recv_flag").val("proc");
				kepAjaxPopFormCall("/mpif/submitMpIfCretecPoListPop.do","MpifNewErrMngPopForm","proc");
			}
			break;
	}
}
function kepAjaxPopSuccess(pMethod,response){
	var sMsg=response.msg;
	if(sMsg=="OK"){
		if(pMethod=="proc"){
			alert("재전송 요청이 정상적으로 등록되었습니다.");
		}
		if(window.opener&&!window.opener.closed){
			window.opener.doAction("search");
		}
		window.close();
	}else{
		alert(sMsg);
	}
}

function kepAjaxPopError(pMethod,response){
	alert("처리 중 오류가 발생하였습니다.");
}

/* function kepAjaxPopSuccess(pMethod,response){
	var sMsg=response.msg;
	var alertMsg="";
	if(sMsg=="OK"){
		if(pMethod=="proc"){
			alertMsg="정상적으로 처리내용이 저장되었습니다.";
		}
	}else{
		alertMsg="처리 하던중 오류가 발생하였습니다.";
	}
	alert(alertMsg);
	parent.opener.doAction("search");
	parent.close();
}

function kepAjaxPopError(pMethod,response){
	alert("처리 하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	parent.close();
} */
</script>
<body>
<form name="MpifNewErrMngPopForm" id="MpifNewErrMngPopForm" method="post">
	<input type="hidden" id="st_user_id" name="st_user_id" value="<%=st_user_id%>" />
	<input type="hidden" id="st_agent" name="st_agent" value="<%=CommonUtil.nvl(rowData.get("OLD_AGENT"))%>" />
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>" />
	<input type="hidden" id="st_po_no" name="st_po_no" value="<%=CommonUtil.nvl(rowData.get("OLD_PO_NO"))%>" />
	<input type="hidden" id="st_po_seq" name="st_po_seq" value="<%=CommonUtil.nvl(rowData.get("OLD_PO_SEQ"))%>" />
	<input type="hidden" id="st_pr_no" name="st_pr_no" value="<%=CommonUtil.nvl(rowData.get("PR_NO"))%>" />
	<input type="hidden" id="st_pr_seq" name="st_pr_seq" value="<%=CommonUtil.nvl(rowData.get("PR_SEQ"))%>" />
	<input type="hidden" id="st_revision" name="st_revision" value="<%=CommonUtil.nvl(rowData.get("REVISION"))%>" />
	<input type="hidden" id="st_recv_flag" name="st_recv_flag" value="" />
	<input type="hidden" id="seller_item_exists_yn" name="seller_item_exists_yn" value="<%=CommonUtil.nvl(rowData.get("SELLER_ITEM_EXISTS_YN"))%>" />
	<div id="popWrapper" style="height:500px;">
		<div id="popHeader">
			<h1 class="title">협력사 크레텍 인터페이스 상세 조회</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<div id="popContainer">
			<h3>1. 기본 정보</h3>
			<table class="cont_t_list06 mb15" style="width:100%;">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">고객사</th>
						<td><b><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%> (<%=CommonUtil.nvl(rowData.get("BUYER"))%>)</b></td>
						<th scope="row">요청번호</th>
						<td><b><%=CommonUtil.nvl(rowData.get("PR_NO"))%></b></td>
					</tr>
					<tr>
						<th scope="row">요청항번</th>
						<td><b><%=CommonUtil.nvl(rowData.get("PR_SEQ"))%></b></td>
						<th scope="row">재전송 차수</th>
						<td><b><%=CommonUtil.nvl(rowData.get("REVISION"))%></b></td>
					</tr>
					<tr>
						<th scope="row">전송상태</th>
						<td><b><%=ifFlagName%></b></td>
						<th scope="row">협력사 발주번호</th>
						<td><b><%=CommonUtil.nvl(rowData.get("AGENT_PO_NO"))%></b></td>
					</tr>
					<tr>
						<th scope="row">전송결과</th>
						<td colspan="3"><b><%=CommonUtil.nvl(rowData.get("IF_MSG"))%></b></td>
					</tr>
				</tbody>
			</table>
			<h3>2. 기존 전송 정보 / 현재 주문·발주 정보 비교</h3>
			<table class="cont_t_list06 mb15" style="width:100%;">
				<colgroup>
					<col width="20%" />
					<col width="40%" />
					<col width="40%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">항목</th>
						<th scope="col">기존 전송 정보</th>
						<th scope="col">현재 주문·발주 정보</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="row">공급사코드</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_AGENT"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_AGENT"))%></td>
					</tr>
					<tr>
						<th scope="row">발주번호</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_PO_NO"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_PO_NO"))%></td>
					</tr>
					<tr>
						<th scope="row">발주항번</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_PO_SEQ"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_PO_SEQ"))%></td>
					</tr>
					<tr>
						<th scope="row">공급사 품목코드</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_SELLER_ITEM_NO"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_SELLER_ITEM_NO"))%></td>
					</tr>
					<tr>
						<th scope="row">품명</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_DESCRIPTION"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_DESCRIPTION"))%></td>
					</tr>
					<tr>
						<th scope="row">규격</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_SPECIFICATION"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_SPECIFICATION"))%></td>
					</tr>
					<tr>
						<th scope="row">단위</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_UNIT_MEASURE"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_UNIT_MEASURE"))%></td>
					</tr>
					<tr>
						<th scope="row">발주수량</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_ITEM_QTY"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_ITEM_QTY"))%></td>
					</tr>
					<tr>
						<th scope="row">매입단가</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_AGENT_PRICE"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_AGENT_PRICE"))%></td>
					</tr>
					<tr>
						<th scope="row">매입금액</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_AGENT_ITEM_AMT"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_AGENT_ITEM_AMT"))%></td>
					</tr>
					<tr>
						<th scope="row">물류센터코드</th>
						<td><%=CommonUtil.nvl(rowData.get("OLD_WAREHOUSE_CODE"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("CURRENT_WAREHOUSE_CODE"))%></td>
					</tr>
				</tbody>
			</table>
			<h3>3. 재전송 사유</h3>
			<table class="cont_t_list06 mb15" summary="협력사 발주 재전송 사유" style="width:100%;">
				<colgroup>
					<col width="15%" />
					<col width="85%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><span style="color:red;">*</span> 재전송 사유</th>
						<td>
							<br/>
							<textarea id="resendReason" name="resendReason" rows="5" maxlength="4000" style="padding:3px;width:99%;ime-mode:active;"></textarea>
							<p style="margin-top:5px;color:red;">재전송 사유를 구체적으로 입력해 주세요.</p>
						</td>
					</tr>
					<tr>
						<th scope="row">확인 사항</th>
						<td>
							<label for="confirmResend">
								<input type="checkbox" id="confirmResend" name="confirmResend" value="Y" />
								기존 협력사 발주 상태와 필요한 후속 조치를 확인했습니다.
							</label>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('cancel');">취소</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('proc');">재전송</a></span>
			</span>
		</div>
	</div>
</form>
</body>
</html>