<%--
**********************************************
* 메뉴 : 개선제안제도 > 개선제안현황 > 제안 평가 팝업
* 화면 : 제안 평가
* 기능 : 제안 평가
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

String st_arps_id = CommonUtil.nvl((String) request.getParameter("st_arps_id"), "");
String st_pp_no = CommonUtil.nvl((String) request.getParameter("st_pp_no"), "");
String st_pp_seq = CommonUtil.nvl((String) request.getParameter("st_pp_seq"), "");
String modify_yn = CommonUtil.nvl((String) request.getParameter("modify_yn"), "");
String grad_open_flag = CommonUtil.nvl((String) request.getParameter("grad_open_flag"), "");
String aply_posb_flag = "Y";
%>

<script type="text/javascript">
var popupSel = "";

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {

	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','getKepDeptList','','<%=CommonUtil.nvl(rowData.get("PP_EXC_DEPT"))%>');
}

//기능함수
function doAction(str) {
	switch (str) {
		case "save": // 평가
		if (checkRadioBtn(str)) {
			arpsSave();
		}
		break;
		
		case "reject": // 불채택
			alert("불채택 사유를 입력해 주십시오.");
            openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=Y&returnGbn='+"R", "500,250,no"); 
		break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var alertMsg = "";
	
	if(pMethod == "save"){
		alertMsg = "정상적으로 평가처리 되었습니다.";
	}else if(pMethod == "reject"){
		alertMsg = "정상적으로 불채택 처리 되었습니다.";
	}else{
		alertMsg = "처리 하던중 오류가 발생하였습니다.";
	}
	alert(alertMsg);
	parent.opener.doAction("search");
	this.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod , response) {
	alert("처리 하던중 오류가 발생하였습니다.");
	parent.opener.doAction("search");
	this.close();
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	switch (popupSel) {
	}
}

function checkRadioBtn(selecedType) {
	if ((($("#arps_group1_A").is(":checked") == true) || ($("#arps_group1_B").is(":checked") == true) || ($("#arps_group1_C").is(":checked") == true) || ($("#arps_group1_D").is(":checked") == true)) &&
			(($("#arps_group2_A").is(":checked") == true) || ($("#arps_group2_B").is(":checked") == true) || ($("#arps_group2_C").is(":checked") == true) || ($("#arps_group2_D").is(":checked") == true)) &&
			(($("#arps_group3_A").is(":checked") == true) || ($("#arps_group3_B").is(":checked") == true) || ($("#arps_group3_C").is(":checked") == true) || ($("#arps_group3_D").is(":checked") == true))){
		return true;
	}else{
		alert("각 평가항목의 평가여부를 확인하여 주십시오.");
		return false;
	}
}

function setReason(value){
	document.forms.searchForm.st_reject_reason.value = value;               // RETURN_REASON
	aprsReject();
}

//평가 처리
function arpsSave(){
	var query				= "";
	var pp_no				= "";
	var pp_seq				= "";
	var pp_attb1			= "";
	var pp_attb_p1		= "0";
	var pp_attb2			= "";
	var pp_attb_p2		= "0";
	var pp_attb3			= "";
	var pp_attb_p3		= "0";
	var exec_team			= "";
	var user_id				= "";

	pp_no		= document.searchForm.st_pp_no.value;
	pp_seq		= document.searchForm.st_pp_seq.value;
	user_id		= document.searchForm.st_user_id.value;
	
	if("<%=grad_open_flag%>" == "Y"){
		exec_team	= document.searchForm.st_dept.value;	
	}
	
	if($("#arps_group1_A").is(":checked") == true){
		pp_attb1 = "A";
		pp_attb_p1 = "30";
	}else if($("#arps_group1_B").is(":checked") == true){
		pp_attb1 = "B";
		pp_attb_p1 = "25";
	}else if($("#arps_group1_C").is(":checked") == true){
		pp_attb1 = "C";
		pp_attb_p1 = "20";
	}else if($("#arps_group1_D").is(":checked") == true){
		pp_attb1 = "D";
		pp_attb_p1 = "15";
	}
	
	if($("#arps_group2_A").is(":checked") == true){
		pp_attb2 = "A";
		pp_attb_p2 = "30";
	}else if($("#arps_group2_B").is(":checked") == true){
		pp_attb2 = "B";
		pp_attb_p2 = "25";
	}else if($("#arps_group2_C").is(":checked") == true){
		pp_attb2 = "C";
		pp_attb_p2 = "20";
	}else if($("#arps_group2_D").is(":checked") == true){
		pp_attb2 = "D";
		pp_attb_p2 = "15";
	}
	
	if($("#arps_group3_A").is(":checked") == true){
		pp_attb3 = "A";
		pp_attb_p3 = "40";
	}else if($("#arps_group3_B").is(":checked") == true){
		pp_attb3 = "B";
		pp_attb_p3 = "30";
	}else if($("#arps_group3_C").is(":checked") == true){
		pp_attb3 = "C";
		pp_attb_p3 = "20";
	}else if($("#arps_group3_D").is(":checked") == true){
		pp_attb3 = "D";
		pp_attb_p3 = "10";
	}

	query +=  pp_no			+ "@@";
	query +=  pp_seq			+ "@@";
	query +=  pp_attb1		+ "@@";
	query +=  pp_attb_p1	+ "@@";
	query +=  pp_attb2		+ "@@";
	query +=  pp_attb_p2	+ "@@";
	query +=  pp_attb3		+ "@@";
	query +=  pp_attb_p3	+ "@@";
	query +=  exec_team	+ "@@";
	query +=  user_id;
	query +=  "^||^";
	
	if(!confirm("평가 하시겠습니까?")) return;
	document.searchForm.st_query.value  = query;
	
	kepAjaxPopFormCall("/mdpp/saveMasterMdPpPropArps.do","searchForm","save");
}

// 불채택 처리
function aprsReject(){
	var query	= "";
	var pp_no	= "";
	var pp_seq	= "";
	var user_id	= "";
	var reason	= "";

	pp_no	= document.searchForm.st_pp_no.value;
	pp_seq	= document.searchForm.st_pp_seq.value;
	user_id	= document.searchForm.st_user_id.value;
	reason	= document.forms.searchForm.st_reject_reason.value;
	
	query +=  pp_no	+ "@@";
	query +=  pp_seq	+ "@@";
	query +=  reason	+ "@@";
	query +=  user_id;
	query +=  "^||^";
	
	document.searchForm.st_query.value  = query;
	
	kepAjaxPopFormCall("/mdpp/rejectMasterMdPpPropArps.do","searchForm","reject");
}

</script> 
<body onload="kep_onload_view();">
	 <form name="searchForm" id="searchForm" method="post" >
	 <input type="hidden" id="st_user_id" name="st_user_id"	value="<%=sessionUserId %>">
	 <input type="hidden" id="st_arps_id" name="st_arps_id"	value="<%=st_arps_id %>">
	 <input type="hidden" id="st_pp_no" name="st_pp_no"	value="<%=st_pp_no %>">
	 <input type="hidden" id="st_pp_seq" name="st_pp_seq"	value="<%=st_pp_seq %>">
	 <input type="hidden" id="aply_posb_flag" name="aply_posb_flag"	value="<%=aply_posb_flag %>">
	 <input type="hidden" name="st_query" value ="">
	 <input type="hidden" name="st_reject_reason" value ="">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:704px;">
    	<div id="popHeader">
        	<h1 class="title">제안 평가</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div class="scrollArea" style="height:530px">
			<table class="cont_t_list06 mb15" summary="평가자 정보" style="width:100%;">
				<caption>평가자 정보</caption>
				<colgroup>
					<col width="11%"/>
					<col width="21%"/>
					<col width="11%"/>
					<col width="21%"/>
					<col width="11%"/>
					<col width="22%"/>
				</colgroup>
				<tbody>
		    	<tr>
		    		<th scope="row">평가부서</th>
					<td><%=CommonUtil.nvl(rowData.get("PP_ARPS_DEPT"))%></td>
					<th scope="row">평가자</th>
					<td><%=CommonUtil.nvl(rowData.get("PP_ARPS_NAME"))%></td>
					<th scope="row">평가일</th>
					<td><%=CommonUtil.nvl(rowData.get("CHANGE_DATE"))%></td>
				</tr>
				</tbody>
		   </table>
		   <br>
		   <table class="cont_t_list06 mb15" summary="제안 평가" style="width:100%;">
			   <caption>제안 평가</caption>
					<colgroup>
						<col width="10%"/>
						<col width="10%"/>
						<col width="10%"/>
						<col width="3%"/>
						<col width="3%"/>
					</colgroup>
					<tbody>
				    	<tr>
				    		<th scope="row" style="text-align: center">구 분</th>
							<th scope="row" style="text-align: center">평가항목</th>
							<th scope="row" style="text-align: center">평가기준</th>
							<th scope="row" style="text-align: center">점수</th>
							<th scope="row" style="text-align: center">평가</th>
						</tr>
						<tr>
				    		<th scope="row" rowspan="8" style="text-align: center">무형효과</th>
				    		<th scope="row" rowspan="4" style="text-align: center">파급성<br>(30점)</th>
				    		<th scope="row" style="text-align: center">전직원</th>
				    		<td style="text-align: center">30</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group1" id="arps_group1_A" <%if(CommonUtil.nvl(rowData.get("PP_ATTB1")).equals("A")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">해당사업부</th>
							<td style="text-align: center">25</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group1" id="arps_group1_B" <%if(CommonUtil.nvl(rowData.get("PP_ATTB1")).equals("B")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">해당팀</th>
							<td style="text-align: center">20</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group1" id="arps_group1_C" <%if(CommonUtil.nvl(rowData.get("PP_ATTB1")).equals("C")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">개인</th>
							<td style="text-align: center">15</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group1" id="arps_group1_D" <%if(CommonUtil.nvl(rowData.get("PP_ATTB1")).equals("D")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" rowspan="4" style="text-align: center">지속성<br>(30점)</th>
							<th scope="row" style="text-align: center">영구지속가능</th>
							<td style="text-align: center">30</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group2" id="arps_group2_A" <%if(CommonUtil.nvl(rowData.get("PP_ATTB2")).equals("A")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">5년 미만 지속가능</th>
							<td style="text-align: center">25</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group2" id="arps_group2_B" <%if(CommonUtil.nvl(rowData.get("PP_ATTB2")).equals("B")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">3년 미만 지속가능</th>
							<td style="text-align: center">20</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group2" id="arps_group2_C" <%if(CommonUtil.nvl(rowData.get("PP_ATTB2")).equals("C")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">1년 미만 지속가능</th>
							<td style="text-align: center">15</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group2" id="arps_group2_D" <%if(CommonUtil.nvl(rowData.get("PP_ATTB2")).equals("D")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
				    		<th scope="row" rowspan="4" style="text-align: center">유형효과</th>
							<th scope="row" rowspan="4" style="text-align: center">년간<br>비용절감 효과<br>(40점)</th>
							<th scope="row" style="text-align: center">3,000만원 이상</th>
							<td style="text-align: center">40</td>
							<td style="text-align: center"><input type="radio" name="arps_group3" id="arps_group3_A" <%if(CommonUtil.nvl(rowData.get("PP_ATTB3")).equals("A")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">2,000만원 이상</th>
							<td style="text-align: center">30</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group3" id="arps_group3_B" <%if(CommonUtil.nvl(rowData.get("PP_ATTB3")).equals("B")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">1,000만원 이상</th>
							<td style="text-align: center">20</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group3" id="arps_group3_C" <%if(CommonUtil.nvl(rowData.get("PP_ATTB3")).equals("C")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<tr>
							<th scope="row" style="text-align: center">1,000만원 미만</th>
							<td style="text-align: center">10</td>
				    		<td style="text-align: center"><input type="radio" name="arps_group3" id="arps_group3_D" <%if(CommonUtil.nvl(rowData.get("PP_ATTB3")).equals("D")){%>checked="checked"<%}%><%if(modify_yn.equals("N")){%>disabled<%}%>/></td>
						</tr>
						<%if(grad_open_flag.equals("Y")){%>
							<tr>
								<th scope="row" style="text-align: center">실행부서</th>
								<td>
									<select id="st_dept" name="st_dept" style="width:180px; height:20px" <%if(modify_yn.equals("N")){%>disabled<%}%>></select>
								</td>
							</tr>
						<%} %>
		        	</tbody>
		   </table>
		   <div class="btnArea">
		    	<span class="fr">
		    	<%if(modify_yn.equals("Y")){%>
		    		<span class="btn_02"><a href="javascript:doAction('save');">평가</a></span>
		    		<span class="btn_02"><a href="javascript:doAction('reject');">불채택</a></span>
	    		<%} %>
				</span>
			</div>
        </div>
		</div>   
    </div>      
</form> 
</body>
</html>
