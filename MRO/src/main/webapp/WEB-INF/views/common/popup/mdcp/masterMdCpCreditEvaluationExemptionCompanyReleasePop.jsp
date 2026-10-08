<%--
**********************************************
* 메뉴 : 
* 화면 : 신용평가면제 지정 
* 기능 : 협력사의 신용평가면제 해제 등록
* 프로그램 ID : PG_01_M_005_06
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-08
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("dataMdm"); // 조회된 결과
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_id=  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());

Map<String,String> _rowData = null;
Map<String,String> _rowData2 = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
if (_dataList2 != null && _dataList2.size() != 0) { 
	_rowData2 = _dataList2.get(0);
}
%>

<script type="text/javascript">
<!--
function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search": // 저장	
			kepSearch();
			break;
		case "save": // 저장	
			if (getSelectItem()) {
				kepAjaxFormCall("/mdcp/saveMasterMdCpCreditEvaluationExemptionCompanyReleasePop.do", "contentForm", str);
			}
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("정상 처리 되었습니다. ");
			opener.setPopupReturn("OK");
			window.close();
			return;
		} else {
			alert("신용평가 면제업체 해제 중  오류가 발생 했습니다 \n\n 관리자에게 문의 하세요.  ");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("신용평가 면제업체 해제 중  오류가 발생 했습니다 \n\n 관리자에게 문의 하세요. ");
}

function getSelectItem() {

	var buyer_code = "";
	var chkCnt = 0;
	
	$("input[name=chkCom]").each(function() {
		if (this.checked) {
			chkCnt += 1;
			buyer_code += this.value + "@@";
		}
	});
	
	if (chkCnt < 1) {
		alert("고객사를 선택하여 주십시요. ");
		return false;
	}
	
	$("#st_buyer_code").val(buyer_code);

	 var confir = confirm( "선택하신 고객사대상  신용평가 면제 협력사를 해지 하시겠습니까? ");

	return confir;
}
 //-->
</script> 
<body onload="">
<form name="searchForm" id="searchForm" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type="hidden" name="st_user_id" id="st_user_id"  value="<%=user_id%>">
</form>
<form name="contentForm" id="contentForm" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type="hidden" name="st_user_id" id="st_user_id"  value="<%=user_id%>">
<input type="hidden" name="st_buyer_code" id="st_buyer_code"  value="<%=user_id%>" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:394px;">
		<div id="popHeader">
			<h1 class="title">신용평가 면제업체 </h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
        <!--팝업내용입니다-->
		<div id="popContainer">
			<!--grid-->
			<div class="scrollArea" style="height:285px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>신용평가 면제업체</caption>
					<colgroup>
						<col width="15%" /> 
						<col width="*" /> 
					</colgroup>
					<thead>
						<th>선택</th>
						<th>고객사명</th>
					</thead>	
					<tbody>
					<%
					if (_dataList != null && _dataList.size() > 0) {
						for (int j=0; j< _dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
						%>
						<tr>
							<td><input type="checkbox" id="chkCom<%=j+1%>" name="chkCom" value="<%=CommonUtil.nvl(_tmp.get("CODE1")) %>" /> </td>
							<td class="left"><%=CommonUtil.nvl(_tmp.get("TEXT1")) %></td>
						</tr>
					<%
						}
					}	
					%>
						<tr>
							<th colspan="2">면제사유</th>
						</tr>
						<tr>
							<td colspan="2" class="left"><%=_rowData2 != null ? CommonUtil.nvl(_rowData2.get("CREDIT_FREE_REASON")) : "" %></td>
						</tr>	
					</tbody>
				</table>
			</div>
			<!--버튼영역-->
			<div class="btnArea mt10 mb05">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('save');">확인</a></span>
				</span>
			</div>
		</div>        
	</div>
</form> 
</body>
</html>
