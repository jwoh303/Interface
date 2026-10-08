<%--
**********************************************
* 메뉴 : 
* 화면 : 개인정보 수정 
* 기능 : 협력사 사용자 상세정보 조회 및 수정
* 프로그램 ID : PG_01_A_005_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-25
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

String st_user_id=  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
//String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());

String com_code=  CommonUtil.nvl((String)_sessionInfo.getComCode());


String user_type = _sessionInfo.getUserType();

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
<!--

function kep_onload_view() {
	<% if (_dataList.size() == 0) { %>
		alert("개인정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% } %>
}

function kepSearch()
{  
  $('#sellerMdCtPrivateInfoAlterPop').attr("action", "/mdct/getSellerMdCtPrivateInfoAlterPop.do").submit();    
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
		case "save": // 저장 ssl 적용

			if (checkSubmit()) {
				kepAjaxFormCall("/mdct/saveSellerMdCtPrivateInfoAlterPop.do","sellerMdCtPrivateInfoAlterPop", str);
			}
			break;
	}
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
/* 		case "zipcode": //우편번호 검색	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode":	//우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
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
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	
	switch (popupSel) {
		case "zipcode": //우편번호 검색
			$("#st_zip_code").val(code);
			$("#st_address").val(text);
			break;
		case "country":
			$("#st_country").val(code);
			$("#st_country_name").val(text);
			break;
		case "city":
			$("#st_city").val(code);
			$("#st_city_name").val(text);
			break;
		case "dept":
			$("#st_department").val(code);
			$("#st_department_text").val(text);
			break;
		case "position":
			$("#st_position").val(code);
			$("#st_position_text").val(text);
			break;
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var msg = response.msg;
	
	if (pMethod == "save") {
		if (msg == 'OK') {
			alert("사용자 정보 수정이 완료되었습니다.");
            opener.setPopupReturn("user");
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
/* 
// ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	$("#st_zip_code").val(str_zipcode);
	$("#st_zip_key").val(str_zip_key);
	$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
	$("#st_address_dt").val(str_buildingName);
}
 */

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
	$("#st_zip_key").val(bdMgtSn);
	$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
	$("#st_address_dt").val(addrDetail);
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
  
}

function checkSubmit() {
    
    if (isEmpty($("#st_user_name_loc").val())) {
		alert(" 사용자 이름이 입력되지 않았습니다. ");
		$("#st_user_name_loc").focus();
		return false;
	}

	if (isEmpty($("#st_email").val())) {
		alert(" Email 주소가 입력되지 않았습니다.");
		$("#st_email").focus();
		return false;
    }

	if (!checkemail("st_email")) {
		return false;
	}
	
	if ($("#st_user_type").val() !=  $("#change_user_type").val()) {
        alert(" 사용자 구분 변경시에는 운영자의 승인 후에 반영됩니다.   ");
	}

	if (isEmpty($("#st_zip_code").val())) {
		alert(" 우편 번호가 입력되지 않았습니다.");
		$("#st_zip_code").focus();
		return false;
	}

	 if (isEmpty($("#st_zip_key").val())) {
		alert("도로명 주소로 변경 바랍니다.");
		$("#st_zip_code").focus();
		return false;
    }

	if (isEmpty($("#st_country").val())) {
		alert(" 국가가 선택되지 않았습니다.");
		$("#st_country_name").focus();
		return false;
	}
	
	if (isEmpty($("#st_city").val())) {
		alert(" 지역이 선택되지 않았습니다.");
		$("#st_city_name").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone1").val())) {
		alert(" 핸드폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone1").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone2").val())) {
		alert(" 핸드폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone2").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone3").val())) {
		alert(" 핸드폰 번호가 입력되지 않았습니다.");
		$("#st_mobile_phone3").focus();
		return false;
	}
	
	if ($("#st_mobile_phone1").val().length != 3  || $("#st_mobile_phone2").val().length<3 || $("#st_mobile_phone3").val().length !=4) { 
		alert( "핸드폰 번호를 정확히 입력하세요." );
		$("#st_mobile_phone1").focus();
	}

	$("#st_mobile_phone").val($("#st_mobile_phone1").val() +"-" + $("#st_mobile_phone2").val() + "-" + $("#st_mobile_phone3").val());  
	
	if (isEmpty($("#st_address").val())) {
        alert(" 사용자 주소가 입력되지 않았습니다.");
		$("#st_address").focus();
		return false;
	}

    if (isEmpty($("#st_phone_number").val())) {
		alert(" 전화번호가 입력되지 않았습니다.");
		$("#st_phone_number").focus();
		return false;
	}

	if(isEmpty($("#st_department_text").val())) {
		alert(" 부서가 입력되지 않았습니다.");
		return false;
    }

    if(isEmpty($("#st_position_text").val())) {
		alert( "직급이 입력되지 않았습니다. ");
		return false;
	}
    
    if ($("#mail_recv_flag1").attr("checked")) { $("#st_mail_recv_flag").val("Y"); } else { $("#st_mail_recv_flag").val("N"); }
     
     return confirm(" 사용자 정보를 수정 하시겠습니까?");
}

 //-->
</script> 
<body onload="">
<form name="sellerMdCtPrivateInfoAlterPop" id="sellerMdCtPrivateInfoAlterPop" method="post">
<input type=hidden name="st_user_id" id="st_user_id"  value="<%=st_user_id%>" />
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>" />

	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:574px;">
    	<div id="popHeader">
        	<h1 class="title">개인정보 수정 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div id="ContArea" style="width:770px;margin-left:0;" >
                <% if (_rowData != null) {  %>
            	<b>[LOG IN 정보]</b>
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
	                        </td>
						</tr>
	                    <tr>
	                        <th scope="row" class="star">이름(국문)</th>
	                      	<td><input type="text" id="st_user_name_loc" name="st_user_name_loc" class="input_type_text" title=""  maxlength="40" style="width:80%;" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%>" /></td>
	                        <th scope="row">이름(영문)</th>
	                      	<td><input type="text" id="st_user_name_eng" name="st_user_name_eng" class="input_type_text" title="" style="width:80%; ime-mode:disabled;" maxlength="40"  value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_ENG"))%>" /></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">사용언어</th>
	                      	<td>
	                      		<select id="st_lang" name="st_lang">
						              <option value="KR" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("KR")?"selected":""%>>Korean</option>
						              <option value="US" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("US")?"selected":""%>>English</option>
						              <option value="CP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("CP")?"selected":""%>>Chinese</option>
						              <option value="JP" <%=CommonUtil.nvl(_rowData.get("LANG")).equals("JP")?"selected":""%>>Japanese</option>
						            </select>
	                      	</td>
	                        <th scope="row">메일수신여부</th>
	                      	<td>
	                      		<input type="radio" id="mail_recv_flag1" name="mail_recv_flag" <% if (CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받겠습니다.&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="mail_recv_flag2" name="mail_recv_flag" <% if (!CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;받지않습니다.
                        		<input type="hidden" id="st_mail_recv_flag" name="st_mail_recv_flag"  value="<%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG"))%>" />
                        	</td>
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
	                        <th scope="row" class="star">E-mail</th>
	                      	<td><input type="text" id="st_email" name="st_email"class="input_type_text" title="" style="width:80%;" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" value="<%=CommonUtil.nvl(_rowData.get("EMAIL"))%>" /> </td>
	                        <th scope="row" class="star">사용자구분</th>
	                      	<td>
	                      		<%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U") ? "일반사용자" : (CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A") ? "Admin사용자" : "운영자")%>&nbsp; ⇒ &nbsp;
	                      		<input type="hidden" id="st_user_type" name="st_user_type" value="<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>" />
	                      		<select id="change_user_type"  name="change_user_type" >
									<% if(CommonUtil.nvl(_rowData.get("CHANGE_USER_TYPE")).equals("M")) { %>
									<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("M")?"selected":""%> value="M">운영자</option>
									<% } %>
									<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("A")?"selected":""%> value="A">Admin사용자</option>
									<option <%=CommonUtil.nvl(_rowData.get("USER_TYPE")).equals("U")?"selected":""%> value="U">일반사용자</option>
								</select>
	                      	</td>
	                    </tr>
						
						<tr>
	                        <th scope="row" class="star">핸드폰</th>
	                      	<td>
	                      	<% 
	                      	String _mobilePhone1 = "";
                  			String _mobilePhone2 = "";
                  			String _mobilePhone3 = "";	
	                      	if (!CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).equals("")) {
	                      		_mobilePhone1 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[0];
	                      		_mobilePhone2 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[1];
	                      		_mobilePhone3 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[2];
	                      	}
	                      	%>
	                      		<input type="hidden" id="st_mobile_phone" name="st_mobile_phone"  value="<%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%>" />
	                      		<input type="text" id="st_mobile_phone1" name="st_mobile_phone1" class="input_type_text" title="" style="width:40px;" maxlength="3" value="<%=_mobilePhone1%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
	                      		<input type="text" id="st_mobile_phone2" name="st_mobile_phone2" class="input_type_text" title="" style="width:50px;" maxlength="4" value="<%=_mobilePhone2%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" /> -
	                      		<input type="text" id="st_mobile_phone3" name="st_mobile_phone3" class="input_type_text" title="" style="width:50px;" maxlength="4" value="<%=_mobilePhone3%>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" />
                        	</td>
	                        <th scope="row" class="star">국가</th>
	                      	<td>
	                      		<input type="hidden" id="st_country" name="st_country" value="<%=CommonUtil.nvl(_rowData.get("COUNTRY"))%>" />
	                      		<input type="text" id="st_country_name" name="st_country_name"class="input_type_text" title="" style="width:80%;" value="<%=CommonUtil.nvl(_rowData.get("COUNTRY_TEXT"))%>"  readonly />
	                      		<a href="javascript:doPop('country');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">우편번호</th>
	                      	<td>
	                      		<input type="text" id="st_zip_code" name="st_zip_code" class="input_type_text" title="" style="width:80px;" maxlength="10"  readonly  value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%>" />
	                      		<input type="hidden" id="st_zip_key" name="st_zip_key" value="<%=CommonUtil.nvl(_rowData.get("ZIP_KEY"))%>"/>
	                      		<!-- <span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('zipcode');">우편번호 검색</a></span>	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
	                      		<span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('newzipcode');">우편번호 검색</a></span>
	                      	</td>
	                        <th scope="row" class="star">지역</th>
	                      	<td>
	                      		<input type="hidden" id="st_city" name="st_city" value="<%=CommonUtil.nvl(_rowData.get("CITY"))%>" />
	                      		<input type="text" id="st_city_name" name="st_city_name"class="input_type_text" title="" style="width:80%;"  value="<%=CommonUtil.nvl(_rowData.get("CITY_TEXT"))%>" readonly  />
	                      		<a href="javascript:doPop('city');"><img src="/resources/images/btn_search03.gif"></a>
	                      	</td>
	                    </tr>
	                    <tr>
	                    	<th scope="row" class="star">주소</th>
	                      	<td colspan="3">
	                      		<input type="text" id="st_address" name="st_address" class="input_type_text" title="" style="width:92%;" maxlength="100" readonly value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1"))%>" />
	                      		<input type="hidden" id="st_address_eng" name="st_address_eng"class="input_type_text" title="" style="width:92%;" maxlength="100" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_ENG"))%>" />
	                      	</td>
						</tr>
						<tr>
	                    	<th scope="row" class="star">상세주소</th>
	                      	<td colspan="3">
	                      		<input type="text" id="st_address_dt" name="st_address_dt" class="input_type_text" title="" style="width:92%;" maxlength="100"  onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2"))%>" />
	                      	</td>
						</tr>
	                    <tr>
	                        <th scope="row" class="star">전화번호</th>
	                      	<td><input type="text" id="st_phone_number" name="st_phone_number" class="input_type_text" title="" style="width:80%;" maxlength="30" onkeyup="fnPhoneNumberCheck('st_phone_number');" onchange="fnPhoneNumberCheck('st_phone_number');" value="<%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER")) %>" /></td>
	                      	<th scope="row">FAX</th>
	                      	<td><input type="text" id="st_fax_number" name="st_fax_number" class="input_type_text" title="" style="width:80%;" maxlength="30" onkeyup="fnPhoneNumberCheck('st_fax_number');" onchange="fnPhoneNumberCheck('st_fax_number');" value="<%=CommonUtil.nvl(_rowData.get("FAX_NUMBER")) %>" /></td>
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
	                      	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
	                      	<th scope="row">사업자번호</th>
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
					</tbody>
				</table>	  
				<% } %>
	        </div>
	        
	        <!--버튼영역-->
	        <div class="btnArea">
	        	<% if ("A".equals(user_type)) {  %>
	        	<span class="fr">
					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
				</span>
				<% } %>
			</div>	
		</div>        
	</div>
</form> 
</body>
</html>
