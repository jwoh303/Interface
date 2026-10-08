<%--
**********************************************
* 메뉴 : 
* 화면 : 주요활동내용등록 
* 기능 : 주요활동내용등록
* 프로그램 ID : PG_01_M_015_03
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String usr_dept = CommonUtil.nvl((String) request.getParameter("usr_dept"),"");  //  (조회조건)
String user_dept_code = CommonUtil.nvl((String) _sessionInfo.getDepartment(), "") ;
String add_date = CommonUtil.nvl((String) request.getParameter("add_date"), "");
String add_time = CommonUtil.nvl((String) request.getParameter("add_time"), "");
String st_mdct_yn = CommonUtil.nvl((String) request.getParameter("st_mdct_yn"), "N");
//  잠재고객 여부. 잠재고객일 경우 등록, 수정이 가능.
String st_potential_customer_yn = CommonUtil.nvl((String) request.getParameter("st_potential_customer_yn"),"N"); 

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
var popupSel = "";
var st;

function kep_onload_view() {
	//조회조건 초기화
	kepSetCalender("st_visit_date");
	<% if (_dataList == null) { %>
		$("#st_visit_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	<% } %>	
}
//기능함수
function doAction(str, tag) {
	actionFlag = tag;
	$("#flag").val(tag);
	switch (str) {
		case "reload":	//초기화
			kepReload("searchForm");
			break;
			
		case "save": // 저장	
			if (checkSubmit()) {
				kepAjaxFormCall("/mdcd/saveMasterMdCdPrimaryActivityDetailRegPop.do", "contentForm", str); 	
			}
			break;
	}
}


//팝업 함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "fileUpload":				//파일업로드
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_image_key").val(), "500,430,no");	
			break;	
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == "OK") {
			if (actionFlag == "insert") {
				msg = "등록";
			} else {
				msg = "수정";
			}
			alert("정상적으로 " + msg + " 완료 되었습니다.");
			setReturn("OK", "");
			return;
		} else {
			alert( msg + " 실패 하였습니다.\n다시 확인하여 주십시요!");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}

function kepSearch()
{  
  $('#masterMdCdPrimaryActivityDetailRegPop').attr("action", "/mdcd/getMasterMdCdPrimaryActivityDetailRegPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setPopupReturn(value1, value2) { 
	$("#st_image_key").val(value1);
}

function setReturn(value1, value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

function checkSubmit() {
	
	if (isEmpty(kepTrimStr($("#st_visit_date").val()))) {
		alert("방문일을 선택하여 주십시오.");
		$("st_visit_date").focus();
		return false;
	}

	if (isEmpty(kepTrimStr($("#st_visit_time").val()))) {
		alert("방문시간을 선택하여 주십시오.");
		$("#st_visit_time").focus();
		return false;

	}
	
	if (isEmpty(kepTrimStr($("#st_visit_to_time").val()))) {
		alert("방문시간을 선택하여 주십시오.");
		$("#st_visit_to_time").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_kep_rspn_text").val()))) {
		alert("KeP 참석자를 입력하여 주십시오.");
		$("#st_kep_rspn_text").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_cstmr_rspn_text").val()))) {
		alert("고객사 참석자를 입력하여 주십시오.");
		$("#st_cstmr_rspn_text").focus();
		return false;
	}
	if (isEmpty(kepTrimStr($("#st_cstmr_remark").val()))) {
		alert("영업활동 결과를 입력하여 주십시오.");
		$("#st_cstmr_remark").focus();
		return false;
	}
	
	 var confir = confirm("주요활동내용을 저장 하시겠습니까?");
	 return confir;
}

</script> 
<body onload="kep_onload_view();">
<form id="contentForm" name="contentForm" method="post" onsubmit="return false;">
<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
<input type="hidden" id="com_code" name="com_code" value="<%=com_code%>" />
<input type="hidden" id="add_date" name="add_date" value="<%=add_date%>" />
<input type="hidden" id="add_time" name="add_time" value="<%=add_time%>" />
<input type="hidden" id="flag" name="flag" value="" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
		<div id="popHeader">
			<h1 class="title">주요활동내용등록 </h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
		
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div id="contArea">
				<table  class="cont_t_list06"  style="width:100%">
					<caption>주요활동내용등록</caption>
					<colgroup>
						<col width="12%" />
						<col width="30%" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="col" class="star">방문일시</th> 
							<td class="left">
								<input type="text" id="st_visit_date" name="st_visit_date" class="input_type_text" title=""  maxlength="40" style="width:40%;" readonly value="<%=_rowData != null ? CommonUtil.formatDate(CommonUtil.nvl(_rowData.get("VISIT_DATE"))) : "" %>" />
								<select id="st_visit_time" name="st_visit_time">
									<script>kepAjaxCommonComboDataValue('st_visit_time', 'K004', 'SEL', '<%=_rowData != null ? CommonUtil.nvl(_rowData.get("VISIT_TIME")) : "" %>');</script>
								</select> ~
								<select id="st_visit_to_time" name="st_visit_to_time">
									<script>kepAjaxCommonComboDataValue('st_visit_to_time', 'K004', 'SEL', '<%=_rowData != null ? CommonUtil.nvl(_rowData.get("TO_VISIT_TIME")) : "" %>');</script>
								</select>
							</td> 
							<th scope="col" class="star">KeP 참석자</th>
							<td class="left"><input type="text" id="st_kep_rspn_text" name="st_kep_rspn_text" class="input_type_text" title=""  maxlength="200" style="width:80%;" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("KEP_CFRC_NM")) : "" %>" /></td> 
						</tr>
						<tr>
							<th scope="col" class="padding">방문유형</th> 
							<td class="left">
								<select id="st_visit_type" name="st_visit_type">
									<%if(st_mdct_yn.equals("Y")){%>
										<script>kepAjaxCommonComboDataValue('st_visit_type', 'CP15', '', '<%=_rowData != null ? CommonUtil.nvl(_rowData.get("VISIT_TYPE")) : "" %>');</script>
									<%}else{%>
										<script>kepAjaxCommonComboDataValue('st_visit_type', 'K003', '', '<%=_rowData != null ? CommonUtil.nvl(_rowData.get("VISIT_TYPE")) : "" %>');</script>
									<%}%>	
								</select>
							</td> 
							<th scope="col" class="star">고객사 참석자</th>
							<td class="left"><input type="text" id="st_cstmr_rspn_text" name="st_cstmr_rspn_text" class="input_type_text" title=""  maxlength="200" style="width:80%;" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("BUYER_CFRC_RM")) : "" %>" /></td> 
						</tr>
						<tr>
							<th scope="col" class="padding">첨부파일</th> 
							<td class="left">
								<input type="hidden" id="st_image_key" name="st_image_key"  value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("IMAGE_KEY")) : "" %>" />
								<span class="btn_gray_03"  title="파일첨부" ><a href="javascript:doPop('fileUpload');">파일첨부</a></span>
							</td> 
							<th scope="col" class="padding">회의장소</th>
							<td class="left"><input type="text" id="st_palce_text" name="st_palce_text" class="input_type_text" title=""  maxlength="200" style="width:80%;" onkeyup="fnCheckInputByte(this, 200);" onchange="fnCheckInputByte(this, 200);" value="<%=_rowData != null ? CommonUtil.nvl(_rowData.get("CFRC_PALCE")) : "" %>" /></td> 
						</tr>
						<tr>
							<th scope="col" colspan="4" class="center star">영업상 주요 활동결과 / 정보/ 특이사항</th> 
						</tr>
						<tr>
							<td class="left" colspan="4" style="margin:0 0 0 0; padding: 0 0 0 0;">
								<textarea id="st_cstmr_remark" name="st_cstmr_remark" style="padding-left:5px;text-align:left;width:100%;height:240px;line-height:20px" maxlength="4000" onkeyup="fnCheckInputByte(this, 4000);" onchange="fnCheckInputByte(this, 4000);">
<%=_rowData != null ? CommonUtil.nvl(_rowData.get("VISIT_NOTE")) :
"1. 방문 목적 : \n2. 고객사 현황 : \n3. 주요 미팅 내용 : \n4. 향후 대응 : "%></textarea>
							</td> 
						</tr>
					</tbody>
				</table>
				<%if(st_potential_customer_yn.equals("Y")){%>
					<% if (_rowData != null) { %>
						<div class="btnArea mt10 mb05">
							<span class="fr">
								<span class="btn_02 mr05"><a href="javascript:doAction('save', 'update');">수정</a></span>
							</span>
						</div>
					<% }else{%>
						<div class="btnArea mt20">
							<span class="fr">
								<span class="btn_02 mr05"><a href="javascript:doAction('save', 'insert');">등록</a></span>
							</span>
						</div>
					<% }%>
				<%}else{%>
				<% if (_rowData != null) { %>
				<% if (usr_dept.equals(user_dept_code)) { %>
				<div class="btnArea mt10 mb05">
					<span class="fr">
						<span class="btn_02 mr05"><a href="javascript:doAction('save', 'update');">수정</a></span>
					</span>
				</div>
				<% } %>
				<% } else { %>
				<div class="btnArea mt20">
					<span class="fr">
						<span class="btn_02 mr05"><a href="javascript:doAction('save', 'insert');">등록</a></span>
					</span>
				</div>
				<% } %>				
				<%}%>

			</div>
		</div>
	</div>
</form> 
</body>
</html>
