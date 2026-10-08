<%--
**********************************************
* 메뉴 : 
* 화면 : 사용자 상세조회 
* 기능 : 사용자상세조회 팝업-권한,발주권한,소싱권한 일부 수정가능
* 프로그램 ID : PG_01_M_008_01
* 담당자 : 이수영	 ( 설계 : 권우재 )
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
String st_job_user_id= CommonUtil.nvl((String)_sessionInfo.getUserId());
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String _comType = (String)_sessionInfo.getBusinessCond();

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

String st_user_com_code = CommonUtil.nvl((String) _rowData.get("COM_CODE"),  _sessionInfo.getComCode());

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

String p01_1010_05 = CommonUtil.getSpecialCheckReturn(CommonUtil.nvl(_rowData.get("COM_CODE")),"P01-1010-05","COL01_DATA", request); // 고객사별 사번 라벨명
if(p01_1010_05 == null){
	p01_1010_05 = "사번";
}else if("".equals(p01_1010_05)){
	p01_1010_05 = "사번";
}

String user_type = CommonUtil.nvl((String)_sessionInfo.getUserType());


%>

<script type="text/javascript">
<!--

//최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList.size() == 0) { %>
		alert("사용자 정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% } %>
}

function kepSearch() {  
  $('#masterMdCpUserDetailViewPop').attr("action", "/mdcp/getMasterMdCpUserDetailViewPop.do").submit();    
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
				kepAjaxFormCall("/mdcp/updateMasterMdCpUserDetailViewPop.do","masterMdCpUserDetailViewPop",str);
			}
			break;
	}
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;
	var comCode = "<%=st_user_com_code%>";	
	switch (str) {
		case "role":
			openSearchPopup("/coco/showCommonCoCoAuthorityRegPop.do","?st_role_code=" + $("#st_role").val().replace("+", "@") + "&st_user_type=" + val+ "&st_ori_role_code=" +  $("#st_ori_role").val().replace("+", "@"), "400, 240,no");
			break;
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code="+comCode+"&open=Y", "500,500,no");			
			break;
		case "purdept":
			openSearchPopup("/coco/showCommonCoCoOrderDepartmentSearchPop.do", "?com_code="+val, "680,500,no");			
			break;
		case "location":
			openSearchPopup("/common/delLocationPop.do", "?com_code=" + comCode + "&del_code="+val, "500,500,no");					
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "role":
			$("#st_role").val(code);
			$("#st_role_text").text(text);
			break;
		case "dept":
			$("#st_department").val(code);
			$("#st_department_text").text(text);
			break;
		case "purdept":
			$("#st_pur_department").val(code);
			$("#st_pur_department_text").text(text);
			break;
		case "location":
			$("#st_dely_to_location").val(code);
			$("#st_dely_text").text(text);
			break;
	}
}

function setReturn(value1, value2) { 
  	opener.setPopupReturn(value1,value2);
	this.close();
}

function checkSubmit() {
	var com_type = "B";
	if (com_type  == "B") {
		$("#st_person_author").val($("input[name=person_author]:checked").val());
	}
	
    var confir = confirm(" 사용자 정보를 수정 하시겠습니까?   ");

    if (confir == false) {
       return false;
    }
    
	return true;
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var msg = response.msg;
	
	if (pMethod == "save") {
		if (msg == 'OK') {
			alert("사용자 정보 수정이 완료되었습니다.");
            setReturn("OK");
		} else {
			alert("사용자 정보 수정이 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		}
	}
}
 //-->
</script> 
<body onload="kep_onload_view();">
<form name="masterMdCpUserDetailViewPop" id="masterMdCpUserDetailViewPop" method="post">
<input type="hidden" id="st_user_id"  name="st_user_id"  value="<%=st_user_id%>" />
<input type="hidden" id="st_job_user_id"  name="st_job_user_id"  value="<%=st_job_user_id%>" />
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>" />
<input type="hidden" name="st_old_role" id="st_old_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE"))%>" />
<input type="hidden" name="st_old_user_group" id="st_old_user_group"  value="<%=CommonUtil.nvl(_rowData.get("USER_GROUP"))%>" />
<input type="hidden" name="st_old_department" id="st_old_department"  value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT"))%>" />
<input type="hidden" name="st_old_pur_department" id="st_old_pur_department"  value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT"))%>" />
<input type="hidden" name="st_user_com_code" id="st_user_com_code"  value="<%=st_user_com_code%>" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">사용자 상세조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div class="scrollArea" style="height:480px;" >
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
	                      	<td><%=CommonUtil.nvl(_rowData.get("LANG")).equals("KR") ? "Korean" : CommonUtil.nvl(_rowData.get("LANG")).equals("US") ? "English":CommonUtil.nvl(_rowData.get("LANG")).equals("CP") ? "Chinese" : "Japanese"%>
	                      	<%=CommonUtil.nvl(_rowData.get("LANG_TEXT"))%></td>
	                      	<th scope="row"><%=p01_1010_05%></th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("LEGACY_USER_ID"))%></td>
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
	                      	<td><%=CommonUtil.nvl3(_rowData.get("EMAIL"),"")%></td>
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
	                        <th scope="row">핸드폰</th>
	                        <td colspan="3"><%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">전화번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER")) %></td>
	                      	<th scope="row">FAX</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("FAX_NUMBER")) %></td>
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
	                      	<td><%=CommonUtil.nvl(_rowData.get("ROW_CNT"))%></td>
	                      	<th scope="row">이미지조회</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("IMG_VIEW_FLAG")).equals("Y") ? "이미지 보기" : "텍스트 보기"%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">SMS수신여부</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y") ? "받겠습니다." : "받지않습니다."%></td>
	                      	<th scope="row">메일수신여부</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y") ? "받겠습니다." : "받지않습니다."%></td>
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
	                        <th scope="row">회사명</th>
	                      	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC")) %></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">법인그룹</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
	                      	<th scope="row">사업자번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">부서(명/코드)</th>
	                      	<td>	                      		
	                      		<input type="hidden" id="st_department" name="st_department"  value="<%=CommonUtil.nvl(_rowData.get("DEPARTMENT")) %>" />
	                      		<p id="st_department_text" style="float:left;"><%=CommonUtil.nvl(_rowData.get("DEPARTMENT_TEXT")) %> / <%=CommonUtil.nvl(_rowData.get("DEPARTMENT"))%></p>
	                      	<%if("A".equals(user_type) && "B".equals(_comType)){%>
	                      		<p style="text-align:right;padding-right:16px;">
	                      			<a href="javascript:doPop('dept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
                      			</p>
	                      	<% } %>	                      	
	                      	</td>
	                      	<th scope="row" >직급</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("POSITION_TEXT")) %></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">메뉴접근 권한</th>
	                      	<td>
	                      		<input type="hidden" id="st_ori_role" name="st_ori_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE")) %>" />
	                      		<input type="hidden" id="st_role" name="st_role"  value="<%=CommonUtil.nvl(_rowData.get("ROLE")) %>" />
	                      		<p id="st_role_text" style="float:left;"><%=CommonUtil.nvl(_rowData.get("ROLE_NAME")) %></p>
								<% if ("M".equals(_comType)) {  %>
								<p style="text-align:right;padding-right:16px;">
	                      		<!-- a href="javascript:doPop('role', '<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>');"><img src="/resources/images/btn_search03.gif"></a -->
								</p>
								<%
								} else {
									if (!"A+".equals(CommonUtil.nvl(_rowData.get("ROLE")))) { %>
								<p style="text-align:right;padding-right:16px;">
	                      		<a href="javascript:doPop('role', '<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>');"><img src="/resources/images/btn_search03.gif"></a>
								</p>
								<%	}
								 } %>
	                      	</td>
	                      	<th scope="row">발주부서</th>	                      	
	                      	<td>
	                      		<input type="hidden" id="st_pur_department" name="st_pur_department"  value="<%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT")) %>" />
	                      		<p id="st_pur_department_text" style="float:left;"><%=CommonUtil.nvl(_rowData.get("PURCHASE_DEPT_TEXT")) %></p>
	                      	<%if("A".equals(user_type) && "B".equals(_comType)){%>
	                      		<p style="text-align:right;padding-right:16px;">
	                      			<a href="javascript:doPop('purdept', '<%=CommonUtil.nvl(_rowData.get("COM_CODE")) %>');"><img src="/resources/images/btn_search03.gif"></a>
                      			</p>
	                      	<% } %>	                      	
	                      	<td>
	                    </tr>
	                    <tr>
	                        <th scope="row">직발주 권한</th>
	                      	<td>
	                      		<input type="radio" id="person_author1" name="person_author" value="PR" <% if (CommonUtil.nvl(_rowData.get("PERSON_AUTHOR")).equals("PR")) { %>checked="checked"<% } %> disabled />&nbsp;구매요청자&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="person_author2" name="person_author" value="PO" <% if (CommonUtil.nvl(_rowData.get("PERSON_AUTHOR")).equals("PO")) { %>checked="checked"<% } %> disabled />&nbsp;구매발주자(직발주)
                        		<input type="hidden" id="st_person_author" name="st_person_author" value="<%=CommonUtil.nvl(_rowData.get("PERSON_AUTHOR"))%>" />
	                      	</td>
	                      	<th scope="row">신규소싱권한</th>
	                      	<td>
								<select id="st_user_group" name="st_user_group">
									<option value = "Q" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("Q")?"selected":""%>> 본인 의뢰 건 조회</option>
									<option value = "C" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("C")?"selected":""%>> 본인 의뢰 건 조회 및 단가확정</option>
									<option value = "X" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("X")?"selected":""%>> 전체 의뢰 건 조회</option>
									<option value = "A" <%=CommonUtil.nvl(_rowData.get("USER_GROUP")).equals("A")?"selected":""%>> 전체 의뢰 건 조회 및 단가확정</option>
								</select>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" >도착지</th>
	                      	<td colspan="3">
	                      	<input type="hidden" id="st_dely_to_location" name="st_dely_to_location"  value="<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>" />
	                      		<p id="st_dely_text" style="float:left;"><%=CommonUtil.nvl(_rowData.get("DELY_TEXT")) %></p>
	                      	<%if("A".equals(user_type) && "B".equals(_comType)){%>
		                      	<p style="text-align:right;padding-right:16px;">
		                      		<a href="javascript:doPop('location', '<%=CommonUtil.nvl(_rowData.get("DELY_TO_LOCATION")) %>');"><img src="/resources/images/btn_search03.gif"></a>
	                      		</p>
	                      	<% } %>
	                      	</td>
	                      	
	                    </tr>
	                    <tr>
	                        <th scope="row">결재선등록</th>
	                      	<td colspan="3">
	                      		 결재 : <%=_approved %><br />
	                      		 참조 : <%=_refer %>
							</td>
					</tbody>
				</table>
				</div>
				
				<!--버튼영역-->
				<p class="btnArea mt10 mb05"> 
					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				</p>
				<% } %>
			</div>
		</div>
</form> 
</body>
</html>
