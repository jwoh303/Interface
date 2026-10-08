<%--
**********************************************
* 메뉴 : 
* 화면 : 개인정보 수정 
* 기능 : 개인정보 상세 조회 및 수정 팝업
* 프로그램 ID : PG_01_B_003_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-13
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("userData"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("approvedData"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList3 = (List<Map<String,String>>) request.getAttribute("referData"); // 조회된 결과

String st_user_id=  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_type = _sessionInfo.getUserType();

String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)


Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

String _approved = "";
String _db_name = "";
String _to_str_id = "";

if (_dataList2 != null && _dataList2.size() != 0) { 
	for (int i=0; i < _dataList2.size(); i++) {
		Map<String,String> _rowData2 = null;
		_rowData2 = _dataList2.get(i);
		if (i+1 == _dataList2.size()) {
			_approved += _rowData2.get("APPR_NAME") +"";
		} else {
			_approved += _rowData2.get("APPR_NAME")+" >> ";
		}
		
		_db_name+= _rowData2.get("APPR_ID")+"@@"+_rowData2.get("APPR_NAME")+"@@"+_rowData2.get("APPR_SEQ")+"@@"+_rowData2.get("GUBUN")+"^||^";
		_to_str_id += _rowData2.get("APPR_ID") + ",";
	}
 }
	
String _refer = "";
String _cc_str_id = "";

if (_dataList3 != null && _dataList3.size() != 0) { 
	for (int i=0; i < _dataList3.size(); i++) {
		Map<String,String> _rowData3 = null;
		_rowData3 = _dataList3.get(i);
		if (i+1 == _dataList3.size()) {
			_refer += _rowData3.get("APPR_NAME") +"";
		} else {
			_refer += _rowData3.get("APPR_NAME")+" >> ";
		}
		
		_db_name+= _rowData3.get("APPR_ID")+"@@"+_rowData3.get("APPR_NAME")+"@@"+_rowData3.get("APPR_SEQ")+"@@"+_rowData3.get("GUBUN")+"^||^";
		_cc_str_id += _rowData3.get("APPR_ID") + ",";
	}
 }	

String p01_1010_05 = CommonUtil.getSpecialCheckReturn(com_code,"P01-1010-05","COL01_DATA", request); // 고객사별 사번 라벨명
if(p01_1010_05 == null){
	p01_1010_05 = "사번";
}else if("".equals(p01_1010_05)){
	p01_1010_05 = "사번";
}
%>

<script type="text/javascript">
<!--
var popupSel = "";

//최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList.size()==0) { %>
		alert("개인정보가 없습니다.\n\n관리자에게 문의 바랍니다.");
		self.close();
	<% } %>
}

function kepSearch()
{  
	$('#searchFrom').attr("action", "/mdam/getBuyerMdAmPrivateInfoAlterPop.do").submit();    
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
		case "search":	 //조회
			kepSearch();
			break;
		case "save": // 저장
			if (checkSubmit()) {
				kepAjaxFormCall("/mdam/updateBuyerMdAmPrivateInfoAlterPop.do","buyerMdAmPrivateInfoAlterPop", str);
			}
			break;
	}
}

function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

//팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	
	switch (str) {
/* 		case "zipcode": //ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "country":
			openSearchPopup("/coco/getCommonCoCoNationCodePop.do", "?1=1", "500,500,no");			
			break;
		case "city":
			openSearchPopup("/common/cityCodePop.do", "?1=1", "500,500,no");			
			break;
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code=" + val + "&open=Y", "500,500,no");			
			break;
		case "position":
			openSearchPopup("/common/getPositionCodePop.do", "?com_code="+val+"&type=C003", "500,420,no");
			break;
		case "purchase_dept":
			openSearchPopup("/coco/showCommonCoCoOrderDepartmentSearchPop.do", "?com_code="+val, "680,500,no");			
			break;
		case "role":
			openSearchPopup("/coco/showCommonCoCoAuthorityRegPop.do", "?st_role_code=" + $("#st_role").val().replace("+", "@") + "&st_user_type=" + val + "&st_ori_role_code=" + $("#st_ori_role").val().replace("+", "@"), "200,240,no");			
			break;
		case "location":
			openSearchPopup("/common/delLocationPop.do", "?com_code=" + val + "&del_code="+val2, "500,500,no");			
			break;
		case "approved":
			var st_user_id =$("#st_user_id").val();
			openSearchPopup("/coco/showCommonCoCoApprovalAppointPop.do", "?to=" + $("#to").val() + "&cc=" + $("#cc").val() + "&cur_order_no=1&type=APSE&st_user_id="+st_user_id, "1000,660,no");			
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, val) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "dept":
			if ( "<%=com_code%>" == "KRKEPB0004" || "<%=com_code%>" == "KRDHIM0002" ) {
				if ( Number(val) >= 2) {
					alert(text +" 부서는 현재 " + val + "명 입니다.");
				}
			}
			
			$("#st_department").val(code);
			$("#st_department_text").val(text);
			break;
		case "position":
			$("#st_position").val(code);
			$("#st_position_text").val(text);
			break;
		case "purchase_dept":
			$("#st_purchase_dept").val(code);
			$("#st_purchase_dept_text").val(text);
			break;
		case "role":
			$("#st_role").val(code);
			break;
		case "location":
			$("#st_dely_to_location").val(code);
			$("#st_dely_text").val(text);
			break;
		case "approved":
			$("#kto").val(text);
			break;
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("사용자 정보 수정이 완료되었습니다.");
            opener.setPopupReturn();
        	this.close();
		} else if (msg == "ERR") {
			alert("사용자 정보 수정이 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		} else {
			alert(msg);
			return;
		}
	}
}

function checkSubmit() {
	if(isEmpty($("#st_department_text").val())) {
		alert(" 부서가 입력되지 않았습니다.");
		return false;
    }

    if(isEmpty($("#st_position_text").val())) {
		alert( "직급이 입력되지 않았습니다. ");
		return false;
	}
    
    $("#st_mail_recv_flag").val($("input[name=mail_recv_flag]:checked").val());
    $("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
    $("#st_img_view_flag").val($("input[name=img_view_flag]:checked").val());
    $("#st_person_author").val($("input[name=person_author]:checked").val());

     return confirm(" 사용자 정보를 수정 하시겠습니까?");
}

 //-->
</script> 
<body onload="kep_onload_view()">
<form name="searchFrom" id="searchFrom" method=post >
<input type="hidden" name="st_user_id" id="st_user_id"  value="<%=st_user_id%>">
<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
</form>
<form name="buyerMdAmPrivateInfoAlterPop" id="buyerMdAmPrivateInfoAlterPop" method="post" onsubmit="return false;" >	
<input type="hidden" name="st_user_id" id="st_user_id"  value="<%=st_user_id%>">
<input type="hidden" name="st_com_code" id="st_com_code"  value="<%=com_code%>">
<input type="hidden" name="st_old_role" id="st_old_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE"))%>" />
<input type="hidden" name="st_old_user_group" id="st_old_user_group"  value="<%=CommonUtil.nvl(_rowData.get("USER_GROUP"))%>" />
<input type="hidden" name="st_old_person_author" id="st_old_person_author"  value="<%=CommonUtil.nvl(_rowData.get("PERSON_AUTHOR"))%>" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
    	<div id="popHeader">
        	<h1 class="title">개인정보 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div class="scrollArea" style="height:560px;" >
				<b>[LOG IN 정보]</b>
	        	<% if (_rowData != null) {  %>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>LOG IN 정보</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">ID</th>
	                        <td colspan="3">
	                        	<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>
	                        	<input type="hidden" name="st_status" id="st_status"  value="<%=CommonUtil.nvl(_rowData.get("STATUS"))%>">
	                        </td>
						</tr>
	                    <tr>
	                        <th scope="row">이름(국문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%></td>
	                        <th scope="row">이름(영문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("USER_NAME_ENG"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">사용언어</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("LANG")).equals("KR") ? "Korean" : (CommonUtil.nvl(_rowData.get("LANG")).equals("EN") ? "English" : (CommonUtil.nvl(_rowData.get("LANG")).equals("CP") ? "Chinese" : (CommonUtil.nvl(_rowData.get("LANG")).equals("JP") ? "Japanese" : "")))%></td>
	                      	<th scope="row"><%=p01_1010_05%></th>
	                      	<td><input type="text" id="st_legacy_user_id" name="st_legacy_user_id" class="input_type_text" title="" style="width:80%; ime-mode:disabled;" maxlength="40" value="<%=CommonUtil.nvl(_rowData.get("LEGACY_USER_ID"))%>" /></td>
	                    </tr>
					</tbody>
				</table>	
				<br />
				<b>[USER 정보]</b>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>USER 정보</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row">E-mail</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("EMAIL"))%></td>
	                        <th scope="row">사용자구분</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U") ? "일반사용자" : (CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A") ? "Admin사용자" : "운영자")%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">국가</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("COUNTRY_NAME"))%></td>
	                        <th scope="row">지역</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("CITY_NAME"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">우편번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%></td>
	                        <th scope="row">핸드폰</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">주소</th>
	                      	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">상세주소</th>
	                      	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">전화번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER"))%></td>
	                      	<th scope="row">FAX</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("FAX_NUMBER"))%></td>
	                    </tr>
					</tbody>
				</table>	
				<br />
				<b>[환경설정]</b>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>환경설정</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row">조회개수</th>
	                      	<td>
	                      		<select id="st_row_cnt" name="st_row_cnt" >
									<option value="10" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("10")?"selected":""%>> 10 </option>
									<option value="20" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("20")?"selected":""%>> 20 </option>
									<option value="30" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("30")?"selected":""%>> 30 </option>
									<option value="40" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("40")?"selected":""%>> 40 </option>
									<option value="50" <%=CommonUtil.nvl(_rowData.get("ROW_CNT")).equals("50")?"selected":""%>> 50 </option>
								</select>
	                      	</td>
	                      	<th scope="row">이미지조회</th>
	                      	<td>
	                      		<input type="radio" id="img_view_flag1" name="img_view_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("IMG_VIEW_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;이미지 보기&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="img_view_flag2" name="img_view_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("IMG_VIEW_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;텍스트 보기
                        		<input type="hidden" id="st_img_view_flag" name="st_img_view_flag" value="<%=CommonUtil.nvl(_rowData.get("IMG_VIEW_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">SMS수신여부</th>
	                      	<td>
	                      		<input type="radio" id="sms_recv_flag1" name="sms_recv_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받겠습니다.&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받지않습니다.
                        		<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="<%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG"))%>" />
	                      	</td>
	                      	<th scope="row">메일수신여부</th>
	                      	<td>
	                      		<input type="radio" id="mail_recv_flag1" name="mail_recv_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받겠습니다.&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="mail_recv_flag2" name="mail_recv_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받지않습니다.
                        		<input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag"  value="<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG"))%>" />
                        	</td>
	                    </tr>
					</tbody>
				</table>	
				<br />
				<b>[회사정보]</b>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>회사정보</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
	                    <tr>
	                        <th scope="row" class="star">회사명</th>
	                      	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC")) %></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">법인그룹</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
	                      	<th scope="row" class="star">사업자번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">부서</th>
	                      	<td>
	                      		<input type="text" id="st_department_text" name="st_department_text" class="input_type_text" title=""  maxlength="50" style="width:80%;"  value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT_TEXT")) %>"  readonly/>
	                      		<input type="hidden" id="st_department" name="st_department" value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT")) %>" />
	                      		<a href="javascript:doPop('dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                      	<th scope="row"  class="star">직급</th>
	                      	<td>
	                      		<input type="text" id="st_position_text" name="st_position_text" class="input_type_text" title="" maxlength="50"  style="width:80%;"  value="<%=CommonUtil.nvl(_rowData.get("POSITION_TEXT")) %>"  readonly/>
	                      		<input type="hidden" id="st_position" name="st_position" value="<%=CommonUtil.nvl(_rowData.get("POSITION")) %>" />
	                      		<a href="javascript:doPop('position', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">메뉴접근 권한</th>
	                      	<td>
	                      		<p style="float:left;"><%=CommonUtil.nvl(_rowData.get("ROLE_NAME")) %></p>
	                      		<input type="hidden" id="st_role" name="st_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE")) %>" />
	                      		<input type="hidden" id="st_ori_role" name="st_ori_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE")) %>" />
								<p style="text-align:right;padding-right:16px;">
	                      		<a href="javascript:doPop('role', '<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>');"><img src="/resources/images/btn_search03.gif"></a>
								</p>
	                      	</td>
	                      	<th scope="row">발주부서</th>
	                      	<td>
	                      		<input type="text" id="st_purchase_dept_text" name="st_purchase_dept_text" class="input_type_text" title=""  maxlength="50"  style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT_TEXT")) %>"  readonly/>
	                      		<input type="hidden" id="st_purchase_dept" name="st_purchase_dept" value="<%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT")) %>" />
	                      		<a href="javascript:doPop('purchase_dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
                        	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">직발주 권한</th>
	                      	<td>
	                      		<input type="radio" id="person_author1" name="person_author" value="PR" <% if (CommonUtil.nvl(_rowData.get("PERSON_AUTHOR")).equals("PR")) { %>checked="checked"<% } %> />&nbsp;구매요청자&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="person_author2" name="person_author" value="PO" <% if (CommonUtil.nvl(_rowData.get("PERSON_AUTHOR")).equals("PO")) { %>checked="checked"<% } %> />&nbsp;구매발주자(직발주)
                        		<input type="hidden" id="st_person_author" name="st_person_author" value="<%=CommonUtil.nvl(_rowData.get("PERSON_AUTHOR"))%>" />
	                      	</td>
	                      	<th scope="row">신규소싱권한</th>
	                      	<td>
								<select id="st_user_group" name="st_user_group">
									<option value = "Q" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("Q")?"selected":""%>> 본인 의뢰 건 조회</option>
									<option value = "C" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("C")?"selected":""%>> 본인 의뢰 건 조회 및 단가확정</option>
									<option value = "A" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("A")?"selected":""%>> 전체 의뢰 건 조회 및 단가확정</option>
								</select>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">도착지</th>
	                      	<td colspan="3">
	                      		<input type="hidden" id="st_dely_to_location" name="st_dely_to_location" value="<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>" />
	                      		<input type="text" id="st_dely_text" name="st_dely_text" class="input_type_text" title="" style="width:89%;" maxlength="300"  readonly value="<%=CommonUtil.nvl(_rowData.get("DELY_TEXT")) %>" />
	                      		<a href="javascript:doPop('location', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>', '<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">결재선등록</th>
	                      	<td colspan="3" class="left">
	                      		 <textarea rows="3" cols="70" name="kto" style="text-align:left;width:90%;" readonly >
	                      		 결재 : <%=_approved %>
	                      		 참조 : <%=_refer %>
	                      		 </textarea>
	                      		 <input type="hidden" id="db_name" name="db_name" value="<%=_db_name%>" />
	                      		 <input type="hidden" id="to" name="to" value="<%=_to_str_id%>" />
	                      		 <input type="hidden" id="cc" name="cc" value="<%=_cc_str_id%>" />
	                      		 <a href="javascript:doPop('approved');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
					</tbody>
				</table>
				</div>
				<% } %>
				<!--버튼영역-->
				<div class="btnArea" style="padding-top: 15px;">
					<% if ("A".equals(user_type)) {  %>
					<span class="fr">
						<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
					</span>	
					<% } %>	
				</p>
				
			</div>
		</div>
	</div>     
 </form>
</body>
</html>
