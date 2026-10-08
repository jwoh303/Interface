<%--
**********************************************
* 메뉴 : 
* 화면 : 신용평가 면제업체 
* 기능 : 협력사의 신용평가 면제사유 등록
* 프로그램 ID : PG_01_M_005_03
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
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된 결과
String com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_id =  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());

String st_buyer_code = "";
String st_buyer_remark = "";
String st_appoint_remark = "";

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) {
	for (int i=0; i < _dataList.size(); i++) {
		_rowData = _dataList.get(i);
		
		st_buyer_code += i != 0 ? "@" + _rowData.get("CODE1") : _rowData.get("CODE1");
		st_buyer_remark += i != 0 ? ", " + _rowData.get("TEXT1") : _rowData.get("TEXT1");
	}
}

if (_dataList2 != null && _dataList2.size() != 0) {
	for (int i=0; i < _dataList2.size(); i++) {
		_rowData = _dataList2.get(i);
		st_appoint_remark = CommonUtil.nvl(_rowData.get("CREDIT_FREE_REASON"));
	}
}
%>

<script type="text/javascript">
<!--

function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
	doAction('search');
	<% } %>
}


function kepSearch()
{  
	$('#contentForm').attr("action", "/mdcp/getMasterMdCpCreditEvaluationExemptionCompanyPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search": // 조회	
			kepSearch();
			break;
		case "save": // 저장	
			if (setConfirm()) {
				kepAjaxFormCall("/mdcp/saveMasterMdCpCreditEvaluationExemptionCompanyPop.do", "contentForm", str);
			}
			break;
	}
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "buyerCompany":				// 고객사선택
			openSearchPopup("/common/safetyCompanyCodePop.do", "?COM_TYPE=B&multi_flag=M", "880,450,no");	
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerCompany") {
		$("#st_buyer_code").val(code);
		$("#st_buyer_remark").val(text.replace(/@/gi,", ") );
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
			alert("신용평가 면제 대상 업체 저장 중  오류가 발생 했습니다 \n\n 관리자에게 문의 하세요. ");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("신용평가 면제 대상 업체 저장 중  오류가 발생 했습니다 \n\n 관리자에게 문의 하세요. ");
}

function setConfirm() {
	if ($("#st_buyer_code").val() == "" && $("#old_buyer_code").val() == "" ) {
		alert(" 고객사 미 선택시 전체 고객사 대상입니다..!! ");
		$("#st_buyer_code").val("ALL");
	} else if ($("#st_buyer_code").val() == "" && $("#old_buyer_code").val() != "") {
		alert(" 고객사 미 선택시 기 등록된 고객사가 그대로 적용됩니다...!! ");
		$("#st_buyer_code").val($("#old_buyer_code").val());
	}
	
	var confir = confirm(  "해당 고객사의 신용평가 면제 대상 협력사로 수정 하시겠습니까? ");
	return confir;
}

function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}
 //-->
</script> 
<body onload="">
<form name="contentForm" id="contentForm" method="post" >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>" />
<input type="hidden" name="user_id" id="user_id"  value="<%=user_id%>" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:294px;">
    	<div id="popHeader">
        	<h1 class="title">신용평가 면제업체 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div class="contentArea" style="height:188px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>신용평가 면제업체</caption>
					<colgroup>
						<col width="20%" /> 
						<col width="*" /> 
					</colgroup>
					<tbody>
						<tr>
							<th>면제사유</th>
							<td><textarea id="st_appoint_remark" name="st_appoint_remark" rows="4" style="width:98%" maxlength="50" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"><%=st_appoint_remark %></textarea></td>
						</tr>
						<tr>	
							<th>고객사 선택</th>
							<td class="pl10" style="text-align:left"><span class="btn_02 mr04"><a href="javascript:doPop('buyerCompany');">조회</a></span></td>
						<tr>
							<th>고객사 리스트</th>
							<td>
								<input type="hidden" id="old_buyer_code" name="old_buyer_code" style="width:80%" value="<%=st_buyer_code %>" />
								<input type="hidden" id="st_buyer_code" name="st_buyer_code" style="width:80%" value="" />
								<textarea id="st_buyer_remark" name="st_buyer_remark" rows="4" style="width:98%" readonly><%=st_buyer_remark %></textarea>
							</td>
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
