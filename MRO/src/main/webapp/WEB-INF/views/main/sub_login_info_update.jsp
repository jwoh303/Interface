<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<head>
<title>정보제공 동의서</title>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script type="text/javascript" src="/resources/js/kep_common.js"></script>
<% 
	String sslurl2 = CommonUtil.getSslURL(request, "https");
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data");
	
	String user_type = "U";
	
	Map<String,String> _rowData = null;
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		user_type = CommonUtil.nvl(_rowData.get("USER_TYPE"));
	}
%>
<script type="text/javascript">
var popupSel = "";
var popupItem = "";

function doAction(){
	if (checkSubmit()) {
		if (!confirm("회원사 및 사용자 정보를 입력과 같이 업데이트합니다.")) {
			return;
		}else{
			$("#infoUpdateYn").val("Y");
			$('#loginForm').attr("method", "post");
		    $('#loginForm').attr("action", "<%=sslurl2%>/login/logincertificate.do");
		    $('#loginForm').submit();	
		}
	}
}

function doPop(str, item, val1, val2, val3, val4, val5) {
	popupSel = str;
	popupItem = item;
	switch (str) {
/* 	 	case "zipcode":					//ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */ 
		case "newzipcode":					//우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
	}
}

/*	//콜백함수(파일명은 모두 동일)	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	if (popupItem == "COM") {
		$("#st_zip_code").val(str_zipcode);
		$("#st_zip_key").val(str_zip_key);
		$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
		$("#st_address_dt").val(str_buildingName);
	}
}
 */ 
 
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	if (popupItem == "COM") {
		$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
		$("#st_zip_key").val(bdMgtSn);
		$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#st_address_dt").val(addrDetail);
	}
}

function checkSubmit() {
<%
if("A".equals(user_type)){
%>
	if (!checkPhoneNumber("st_tel_no")) { return; }
	if (!checkPhoneNumber("st_fax_no")) { return; }

	if(isEmpty(kepTrimStr($("#st_zip_code").val()))){
		alert("우편번호를 선택하여 주십시오");
		$("#st_zip_code").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_zip_key").val()))){
		alert("주소를 도로명 주소로 변경 바랍니다.");
		$("#st_zip_code").focus();
		return;
	}

	if (isEmpty(kepTrimStr($("#st_address").val()))){
		alert("우편번호를 선택하여 주십시오");
		$("#st_address").focus();
		return;
	}
	
	if (isEmpty(kepTrimStr($("#st_gr_emp_nm").val()))){
		alert("영업담당자 이름을 입력 해주십시오");
		$("#st_gr_emp_nm").focus();
		return;
	}
	
	if (isEmpty(kepTrimStr($("#st_gr_emp_email").val()))){
		alert("영업담당자 이메일을 입력 해주십시오");
		$("#st_gr_emp_email").focus();
		return;
	}

	if (!checkemail("st_gr_emp_email")) { return; }
	if (!checkPhoneNumber("st_gr_emp_tel_no")) { return; }
	if (!checkPhoneNumber("st_gr_emp_mobile")) { return; }
	
	if (isEmpty(kepTrimStr($("#st_ac_emp_nm").val()))){
		alert("경리담당자 이름을 입력 해주십시오");
		$("#st_ac_emp_nm").focus();
		return;
	}
	
	if (isEmpty(kepTrimStr($("#st_ac_emp_email").val()))){
		alert("경리담당자 이메일을 입력 해주십시오");
		$("#st_ac_emp_email").focus();
		return;
	}

	if (!checkemail("st_ac_emp_email")) { return; }
	if (!checkPhoneNumber("st_ac_emp_tel_no")) { return; }
	if (!checkPhoneNumber("st_ac_emp_mobile")) { return; }
	
	if (isEmpty(kepTrimStr($("#st_cont_emp_nm").val()))){
		alert("계약담당자 이름을 입력 해주십시오");
		$("#st_cont_emp_nm").focus();
		return;
	}
	
	if (isEmpty(kepTrimStr($("#st_cont_emp_email").val()))){
		alert("계약담당자 이메일을 입력 해주십시오");
		$("#st_cont_emp_email").focus();
		return;
	}

	if (!checkemail("st_cont_emp_email")) { return; }
	if (!checkPhoneNumber("st_cont_emp_tel_no")) { return; }
	if (!checkPhoneNumber("st_cont_emp_mobile")) { return; }
<%
}
%>
	if (isEmpty(kepTrimStr($("#st_user_nm").val()))){
		alert("사용자 이름을 입력 해주십시오");
		$("#st_user_nm").focus();
		return;
	}
	
	if (!checkPhoneNumber("st_user_phone")) { return; }
	if (!checkPhoneNumber("st_user_mobile")) { return; }
	
	if (isEmpty(kepTrimStr($("#st_user_email").val()))){
		alert("사용자 이메일을 입력 해주십시오");
		$("#st_user_email").focus();
		return;
	}

	if (!checkemail("st_user_email")) { return; }
	
	return true;
}

function checkPhoneNumber(str) {
	for(var i=2; i <= 3 ; i++){
		if (isEmpty($("#"+str+i).val())) {
			alert("전화번호를 입력하여 주십시오");
			$("#"+str+i).focus();
			return false;
		}

		if (i == 2 && $("#"+str+i).val().length < 3 ) {
			alert("국번을 정확히 입력 해주세요");
			$("#"+str+i).focus();
			return false;

		} else if (i == 3 && $("#"+str+i).val().length != 4 ) {
			alert("전화번호를 정확히 입력 해주세요");
			$("#"+str+i).focus();
			return false;
		}
	}
	return true;
}
</script>
</head>
<style>
.wrap{font-family:"맑은 고딕";  }
.seller_info_txt{position:relative; margin:0 auto; margin-top:30px; width:800px;  padding:30px 200px 0 40px; background-color:#fff; font-size:14px;  text-align:left; line-height:18px; word-spacing:-3px;border-top:5px solid #e8340c;  }
.seller_info_txt p{ padding:0; margin:0; margin-top:10px; height:20px;  }
.seller_info_txt img{position:absolute; top:30px; right:40px}
.seller_info_box{ margin:0 auto; width:960px; padding:20px 40px 30px 40px; background-color:#fff;  font-size:14px; }
.seller_info_tit{font-size:18px; font-weight:bold; margin-bottom:5px; word-spacing:-4px;}
table{border-collapse:collapse; width:100%; border-top:2px solid #4b4948;  }
table th{ padding:2px;  border:1px solid #d3d3d3;  color:#fff; background-color:#aaaaaa;}
table td{ padding:2px;  border:1px solid #d3d3d3;}
input{border:1px solid #CCC; padding:4px; font-size:100%}
select{ border:1px solid #CCC; padding:4px; font-size:100%}
a{text-decoration:none}
.ok{margin:0 auto; width:300px; height:40px; line-height:40px; background-color:#4b4948; color:#fff;  margin-top:15px; text-align:center; font-size:18px }
.post{cursor:pointer; width:18%; font-weight:bold; word-spacing:-2px; background:#4b4948; color:#fff}
.blue{ color:#e8340c; font-weight:bold}
</style>
<body style="background-color:#eee">
<div class="wrap">
	<form id="loginForm" id="loginForm"  name="loginForm" method="post">
		<input type = "hidden" id="userId" name = "userId" value="${userId}"/>
		<input type = "hidden" id="password" name = "password"  value="${password}"/>
		<input type = "hidden" id="pageFlag" name = "pageFlag"  value="imsi"/>
		<input type = "hidden" id="infoUpdateYn" name = "infoUpdateYn"  value=""/>
		<input type = "hidden" id="userType" name = "userType"  value="<%=CommonUtil.nvl(_rowData.get("USER_TYPE"))%>"/>
		<input type = "hidden" id="comCode" name = "comCode"  value="<%=CommonUtil.nvl(_rowData.get("COM_CODE"))%>"/>
	
		<div class="seller_info_txt">
			코리아이플랫폼 회원사님.<br/>
			koreab2b site의 <span class="blue">회원사 정보 업데이트를 진행</span>합니다.<br/>
			회원사 정보 및 사용자 정보에 대해 수정사항을 확인하시어 반영 부탁 드립니다.<br/>
			단, 회사명/대표자/결제계좌 정보 변경이 필요할 시에는 관련 서류 확인 후 수정되오니 송부 바랍니다.<br/>
			원활한 업무 진행 및 전문 품목에 대해 거래 활성화 기회를 드리기 위함이오니 적극적인 협조 부탁 드립니다.
			<p>※ 담당자 : 구매기획팀 박지수 선임 / 02-3016-7251 / Fax 02-569-6724 / musenh@koreab2b.com</p>
			<img src="/resources/images/main/seller_info_txt.gif" />
	    </div>
	    
    	<div class="seller_info_box">
    		<div class="seller_info_tit">1. 회원사 정보</div>
   			<table>
   				<colgroup>
	           		<col width="12%" />
	            	<col width="14%" />
	            	<col width="30%" />
	            	<col width="14%" />
	            	<col width="30%" />
            	</colgroup>
            
            	<tr>
	            	<th>회사명</th>
                	<td colspan="2"><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
                	<th>회사코드</th>
                	<td><%=CommonUtil.nvl(_rowData.get("COM_CODE"))%></td>
            	</tr>
            
            	<tr>
	            	<th>사업자번호</th>
                	<td colspan="2"><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
                	<th>대표자명</th>
                	<td><%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%></td>
            	</tr>
            
            	<tr>
	            	<th>대표전화</th>
                	<td colspan="2">
                	<%
                		String _telNo = CommonUtil.nvl(_rowData.get("TEL_NO"));	
						String _telNo1 = "";
						String _telNo2 = "";
						String _telNo3 = "";
						
						if (!CommonUtil.nvl(_rowData.get("TEL_NO")).equals("")){
							int i = CommonUtil.getCharCount(_telNo, '-');
							
							if(i == 0){
								_telNo1 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[0];
							}else if(i == 1){
								_telNo1 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[0];
								_telNo2 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[1];
							}else if(i == 2){
								_telNo1 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[0];
								_telNo2 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[1];
								_telNo3 = CommonUtil.nvl(_rowData.get("TEL_NO")).split("\\-")[2];
							}
                    	}
                  	%>
                		<select name="st_tel_no1" id="st_tel_no1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
		                    <option value="02"  <%=_telNo1.equals("02") ?"selected":""%>>02</option>
							<option value="031" <%=_telNo1.equals("031")?"selected":""%>>031</option>
							<option value="032" <%=_telNo1.equals("032")?"selected":""%>>032</option>
							<option value="033" <%=_telNo1.equals("033")?"selected":""%>>033</option>
							<option value="041" <%=_telNo1.equals("041")?"selected":""%>>041</option>
							<option value="042" <%=_telNo1.equals("042")?"selected":""%>>042</option>
							<option value="043" <%=_telNo1.equals("043")?"selected":""%>>043</option>
							<option value="044" <%=_telNo1.equals("044")?"selected":""%>>044</option>
							<option value="051" <%=_telNo1.equals("051")?"selected":""%>>051</option>
							<option value="052" <%=_telNo1.equals("052")?"selected":""%>>052</option>
							<option value="053" <%=_telNo1.equals("053")?"selected":""%>>053</option>
							<option value="054" <%=_telNo1.equals("054")?"selected":""%>>054</option>
							<option value="055" <%=_telNo1.equals("055")?"selected":""%>>055</option>
							<option value="061" <%=_telNo1.equals("061")?"selected":""%>>061</option>
							<option value="062" <%=_telNo1.equals("062")?"selected":""%>>062</option>
							<option value="063" <%=_telNo1.equals("063")?"selected":""%>>063</option>
							<option value="064" <%=_telNo1.equals("064")?"selected":""%>>064</option>
							<option value="070" <%=_telNo1.equals("070")?"selected":""%>>070</option>
							<option value="0303" <%=_telNo1.equals("0303")?"selected":""%>>0303</option>
							<option value="0502" <%=_telNo1.equals("0502")?"selected":""%>>0502</option>
							<option value="0504" <%=_telNo1.equals("0504")?"selected":""%>>0504</option>
							<option value="0505" <%=_telNo1.equals("0505")?"selected":""%>>0505</option>
							<option value="0506" <%=_telNo1.equals("0506")?"selected":""%>>0506</option>
							<option value="0507" <%=_telNo1.equals("0507")?"selected":""%>>0507</option>
                		</select>
                		-
                		<input type="text" id="st_tel_no2" name="st_tel_no2" title="" style="width:25%" value="<%=_telNo2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                		-
                		<input type="text" id="st_tel_no3" name="st_tel_no3" title="" style="width:25%" value="<%=_telNo3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
                	<th>대표FAX</th>
                	<td>
                	<%
                		String _faxNo = CommonUtil.nvl(_rowData.get("FAX_NO"));
						String _faxNo1 = "";
						String _faxNo2 = "";
						String _faxNo3 = "";
						
						if (!CommonUtil.nvl(_rowData.get("FAX_NO")).equals("")){
							int i = CommonUtil.getCharCount(_faxNo, '-');
							
							if(i == 0){
								_faxNo1 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[0];
							}else if(i == 1){
								_faxNo1 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[0];
								_faxNo2 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[1];
							}else if(i == 2){
								_faxNo1 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[0];
								_faxNo2 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[1];
								_faxNo3 = CommonUtil.nvl(_rowData.get("FAX_NO")).split("\\-")[2];
							}
                    	}
                  	%>
                		<select name="st_fax_no1" id="st_fax_no1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
		                    <option value="02"  <%=_faxNo1.equals("02") ?"selected":""%>>02</option>
							<option value="031" <%=_faxNo1.equals("031")?"selected":""%>>031</option>
							<option value="032" <%=_faxNo1.equals("032")?"selected":""%>>032</option>
							<option value="033" <%=_faxNo1.equals("033")?"selected":""%>>033</option>
							<option value="041" <%=_faxNo1.equals("041")?"selected":""%>>041</option>
							<option value="042" <%=_faxNo1.equals("042")?"selected":""%>>042</option>
							<option value="043" <%=_faxNo1.equals("043")?"selected":""%>>043</option>
							<option value="044" <%=_faxNo1.equals("044")?"selected":""%>>044</option>
							<option value="051" <%=_faxNo1.equals("051")?"selected":""%>>051</option>
							<option value="052" <%=_faxNo1.equals("052")?"selected":""%>>052</option>
							<option value="053" <%=_faxNo1.equals("053")?"selected":""%>>053</option>
							<option value="054" <%=_faxNo1.equals("054")?"selected":""%>>054</option>
							<option value="055" <%=_faxNo1.equals("055")?"selected":""%>>055</option>
							<option value="061" <%=_faxNo1.equals("061")?"selected":""%>>061</option>
							<option value="062" <%=_faxNo1.equals("062")?"selected":""%>>062</option>
							<option value="063" <%=_faxNo1.equals("063")?"selected":""%>>063</option>
							<option value="064" <%=_faxNo1.equals("064")?"selected":""%>>064</option>
							<option value="070" <%=_faxNo1.equals("070")?"selected":""%>>070</option>
							<option value="0303" <%=_faxNo1.equals("0303")?"selected":""%>>0303</option>
							<option value="0502" <%=_faxNo1.equals("0502")?"selected":""%>>0502</option>
							<option value="0504" <%=_faxNo1.equals("0504")?"selected":""%>>0504</option>
							<option value="0505" <%=_faxNo1.equals("0505")?"selected":""%>>0505</option>
							<option value="0506" <%=_faxNo1.equals("0506")?"selected":""%>>0506</option>
							<option value="0507" <%=_faxNo1.equals("0507")?"selected":""%>>0507</option>
                		</select>
                		-
                		<input type="text" id="st_fax_no2" name="st_fax_no2" title="" style="width:25%" value="<%=_faxNo2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                		-
                		<input type="text" id="st_fax_no3" name="st_fax_no3" title="" style="width:25%" value="<%=_faxNo3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>

            	<tr>
	            	<th rowspan="3">주소</th>
                	<th>우편번호</th>
                	<td colspan="3">
	                	<%-- <input type="text" id="st_zip_code" name="st_zip_code" title="" style="width:20%; background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%>" <%=user_type.equals("U")?"disabled":""%> onclick="doPop('zipcode','COM');"/>	<!-- ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 --> --%>
	                	<input type="text" id="st_zip_code" name="st_zip_code" title="" style="width:20%; background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%>" <%=user_type.equals("U")?"disabled":""%> onclick="doPop('newzipcode','COM');"/>
                		<input type="hidden" id="st_zip_key" name="st_zip_key" value="<%=CommonUtil.nvl(_rowData.get("ZIP_KEY"))%>"/>
                		<span>
                			<%if("A".equals(user_type)){%>
                			<!-- <input type="button" value="우편번호검색" onclick="doPop('zipcode','COM');" class="post"/>	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
                			<input type="button" value="우편번호검색" onclick="doPop('newzipcode','COM');" class="post"/>
                			<%}%>
                		</span>
                	</td>
            	</tr>
	            
            	<tr>
	                <th>주소</th>
                	<td colspan="3">
	                	<%-- <input type="text" id="st_address" name="st_address" title="" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1"))%>" style="width:99%; background:#EAEAEA;" readonly <%=user_type.equals("U")?"disabled":""%> onclick="doPop('zipcode','COM');"/>	<!-- ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 --> --%>
	                	<input type="text" id="st_address" name="st_address" title="" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1"))%>" style="width:99%; background:#EAEAEA;" readonly <%=user_type.equals("U")?"disabled":""%> onclick="doPop('newzipcode','COM');"/>
                	</td>
            	</tr>
	            
            	<tr>
	                <th>상세주소</th>
                	<td colspan="3">
	                	<input type="text" id="st_address_dt" name="st_address_dt" title="" style="width:99%" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2")) %>" maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>
	            
            	<tr>
	            	<th rowspan="2">회원사<br>영업담당자</th>
                	<th>이름</th>
                	<td>
	                	<input type="text" id="st_gr_emp_nm" name="st_gr_emp_nm" title="" style="width:97%" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_NM"))%>" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
                	<th>이메일</th>
                	<td>
	                	<input type="text" id="st_gr_emp_email" name="st_gr_emp_email" title="" style="width:97%" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_EMAIL"))%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>
	            
            	<tr>
	                <th>전화번호</th>
                	<td>
	              	<%
                		String _grTelNo = CommonUtil.nvl(_rowData.get("GR_EMP_TEL"));	
                		String _grTelNo1 = "";
						String _grTelNo2 = "";
						String _grTelNo3 = "";
						
						if (!CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).equals("")){
							int i = CommonUtil.getCharCount(_grTelNo, '-');
							
							if(i == 0){
								_grTelNo1 = CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).split("\\-")[0];
							}else if(i == 1){
								_grTelNo1 = CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).split("\\-")[0];
								_grTelNo2 = CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).split("\\-")[1];
							}else if(i == 2){
								_grTelNo1 = CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).split("\\-")[0];
								_grTelNo2 = CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).split("\\-")[1];
								_grTelNo3 = CommonUtil.nvl(_rowData.get("GR_EMP_TEL")).split("\\-")[2];
							}
                    	}
                  	%>
	                	<select name="st_gr_emp_tel_no1" id="st_gr_emp_tel_no1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
		                    <option value="02"  <%=_grTelNo1.equals("02") ?"selected":""%>>02</option>
							<option value="031" <%=_grTelNo1.equals("031")?"selected":""%>>031</option>
							<option value="032" <%=_grTelNo1.equals("032")?"selected":""%>>032</option>
							<option value="033" <%=_grTelNo1.equals("033")?"selected":""%>>033</option>
							<option value="041" <%=_grTelNo1.equals("041")?"selected":""%>>041</option>
							<option value="042" <%=_grTelNo1.equals("042")?"selected":""%>>042</option>
							<option value="043" <%=_grTelNo1.equals("043")?"selected":""%>>043</option>
							<option value="044" <%=_grTelNo1.equals("044")?"selected":""%>>044</option>
							<option value="051" <%=_grTelNo1.equals("051")?"selected":""%>>051</option>
							<option value="052" <%=_grTelNo1.equals("052")?"selected":""%>>052</option>
							<option value="053" <%=_grTelNo1.equals("053")?"selected":""%>>053</option>
							<option value="054" <%=_grTelNo1.equals("054")?"selected":""%>>054</option>
							<option value="055" <%=_grTelNo1.equals("055")?"selected":""%>>055</option>
							<option value="061" <%=_grTelNo1.equals("061")?"selected":""%>>061</option>
							<option value="062" <%=_grTelNo1.equals("062")?"selected":""%>>062</option>
							<option value="063" <%=_grTelNo1.equals("063")?"selected":""%>>063</option>
							<option value="064" <%=_grTelNo1.equals("064")?"selected":""%>>064</option>
							<option value="070" <%=_grTelNo1.equals("070")?"selected":""%>>070</option>
							<option value="0303" <%=_grTelNo1.equals("0303")?"selected":""%>>0303</option>
							<option value="0502" <%=_grTelNo1.equals("0502")?"selected":""%>>0502</option>
							<option value="0504" <%=_grTelNo1.equals("0504")?"selected":""%>>0504</option>
							<option value="0505" <%=_grTelNo1.equals("0505")?"selected":""%>>0505</option>
							<option value="0506" <%=_grTelNo1.equals("0506")?"selected":""%>>0506</option>
							<option value="0507" <%=_grTelNo1.equals("0507")?"selected":""%>>0507</option>
                		</select>
                		-
                		<input type="text" id="st_gr_emp_tel_no2" name="st_gr_emp_tel_no2" title="" style="width:25%" value="<%=_grTelNo2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                		-
                		<input type="text" id="st_gr_emp_tel_no3" name="st_gr_emp_tel_no3" title="" style="width:25%" value="<%=_grTelNo3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
                	<th>휴대폰번호</th>
                	<td>
               		<% 
               				String _gr_emp_mobile = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE"));
                     		String _gr_emp_mobile1 = "";
              				String _gr_emp_mobile2 = "";
              				String _gr_emp_mobile3 = "";
              				
              				if (!CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).equals("")){
    							int i = CommonUtil.getCharCount(_gr_emp_mobile, '-');
    							
    							if(i == 0){
    								_gr_emp_mobile1 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[0];
    							}else if(i == 1){
    								_gr_emp_mobile1 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[0];
    								_gr_emp_mobile2 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[1];
    							}else if(i == 2){
    								_gr_emp_mobile1 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[0];
    								_gr_emp_mobile2 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[1];
    								_gr_emp_mobile3 = CommonUtil.nvl(_rowData.get("GR_EMP_MOBILE")).split("\\-")[2];
    							}
                        	}
                    %>
						<select id="st_gr_emp_mobile1" name="st_gr_emp_mobile1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
							<option value="010" <%=_gr_emp_mobile1.equals("010")?"selected":""%>>010</option>
							<option value="011" <%=_gr_emp_mobile1.equals("011")?"selected":""%>>011</option>
							<option value="016" <%=_gr_emp_mobile1.equals("016")?"selected":""%>>016</option>
							<option value="017" <%=_gr_emp_mobile1.equals("017")?"selected":""%>>017</option>
							<option value="018" <%=_gr_emp_mobile1.equals("018")?"selected":""%>>018</option>
							<option value="019" <%=_gr_emp_mobile1.equals("019")?"selected":""%>>019</option>
						</select>
						- 
						<input type="text" id="st_gr_emp_mobile2" name="st_gr_emp_mobile2" title="" style="width:25%" value="<%=_gr_emp_mobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
						- 
						<input type="text" id="st_gr_emp_mobile3" name="st_gr_emp_mobile3" title="" style="width:25%" value="<%=_gr_emp_mobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>
	            
            	<tr>
	            	<th rowspan="2">회원사<br>경리담당자</th>
                	<th>이름</th>
                	<td>
	                	<input type="text" id="st_ac_emp_nm" name="st_ac_emp_nm" title="" style="width:97%" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_NM"))%>" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
                	<th>이메일</th>
                	<td>
	                	<input type="text" id="st_ac_emp_email" name="st_ac_emp_email" title="" style="width:97%" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_EMAIL"))%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>
	            
            	<tr>
	                <th>전화번호</th>
                	<td>
	              	<%
                		String _acTelNo = CommonUtil.nvl(_rowData.get("AC_EMP_TEL"));	
	                	String _acTelNo1 = "";
						String _acTelNo2 = "";
						String _acTelNo3 = "";
						
						if (!CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).equals("")){
							int i = CommonUtil.getCharCount(_acTelNo, '-');
							
							if(i == 0){
								_acTelNo1 = CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).split("\\-")[0];
							}else if(i == 1){
								_acTelNo1 = CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).split("\\-")[0];
								_acTelNo2 = CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).split("\\-")[1];
							}else if(i == 2){
								_acTelNo1 = CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).split("\\-")[0];
								_acTelNo2 = CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).split("\\-")[1];
								_acTelNo3 = CommonUtil.nvl(_rowData.get("AC_EMP_TEL")).split("\\-")[2];
							}
                    	}
                  	%>
	                	<select name="st_ac_emp_tel_no1" id="st_ac_emp_tel_no1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
	                    	<option value="02"  <%=_acTelNo1.equals("02") ?"selected":""%>>02</option>
							<option value="031" <%=_acTelNo1.equals("031")?"selected":""%>>031</option>
							<option value="032" <%=_acTelNo1.equals("032")?"selected":""%>>032</option>
							<option value="033" <%=_acTelNo1.equals("033")?"selected":""%>>033</option>
							<option value="041" <%=_acTelNo1.equals("041")?"selected":""%>>041</option>
							<option value="042" <%=_acTelNo1.equals("042")?"selected":""%>>042</option>
							<option value="043" <%=_acTelNo1.equals("043")?"selected":""%>>043</option>
							<option value="044" <%=_acTelNo1.equals("044")?"selected":""%>>044</option>
							<option value="051" <%=_acTelNo1.equals("051")?"selected":""%>>051</option>
							<option value="052" <%=_acTelNo1.equals("052")?"selected":""%>>052</option>
							<option value="053" <%=_acTelNo1.equals("053")?"selected":""%>>053</option>
							<option value="054" <%=_acTelNo1.equals("054")?"selected":""%>>054</option>
							<option value="055" <%=_acTelNo1.equals("055")?"selected":""%>>055</option>
							<option value="061" <%=_acTelNo1.equals("061")?"selected":""%>>061</option>
							<option value="062" <%=_acTelNo1.equals("062")?"selected":""%>>062</option>
							<option value="063" <%=_acTelNo1.equals("063")?"selected":""%>>063</option>
							<option value="064" <%=_acTelNo1.equals("064")?"selected":""%>>064</option>
							<option value="070" <%=_acTelNo1.equals("070")?"selected":""%>>070</option>
							<option value="0303" <%=_acTelNo1.equals("0303")?"selected":""%>>0303</option>
							<option value="0502" <%=_acTelNo1.equals("0502")?"selected":""%>>0502</option>
							<option value="0504" <%=_acTelNo1.equals("0504")?"selected":""%>>0504</option>
							<option value="0505" <%=_acTelNo1.equals("0505")?"selected":""%>>0505</option>
							<option value="0506" <%=_acTelNo1.equals("0506")?"selected":""%>>0506</option>
							<option value="0507" <%=_acTelNo1.equals("0507")?"selected":""%>>0507</option>
                		</select>
                		-
                		<input type="text" id="st_ac_emp_tel_no2" name="st_ac_emp_tel_no2" title="" style="width:25%" value="<%=_acTelNo2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                		-
                		<input type="text" id="st_ac_emp_tel_no3" name="st_ac_emp_tel_no3" title="" style="width:25%" value="<%=_acTelNo3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
                	<th>휴대폰번호</th>
                	<td>
               		<% 
               			String _ac_emp_mobile = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE"));
                     	String _ac_emp_mobile1 = "";
              			String _ac_emp_mobile2 = "";
              			String _ac_emp_mobile3 = "";
              			
              			if (!CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).equals("")){
							int i = CommonUtil.getCharCount(_ac_emp_mobile, '-');
							
							if(i == 0){
								_ac_emp_mobile1 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[0];
							}else if(i == 1){
								_ac_emp_mobile1 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[0];
								_ac_emp_mobile2 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[1];
							}else if(i == 2){
								_ac_emp_mobile1 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[0];
								_ac_emp_mobile2 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[1];
								_ac_emp_mobile3 = CommonUtil.nvl(_rowData.get("AC_EMP_MOBILE")).split("\\-")[2];
							}
                    	}
                    %>
						<select id="st_ac_emp_mobile1" name="st_ac_emp_mobile1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
							<option value="010" <%=_ac_emp_mobile1.equals("010")?"selected":""%>>010</option>
							<option value="011" <%=_ac_emp_mobile1.equals("011")?"selected":""%>>011</option>
							<option value="016" <%=_ac_emp_mobile1.equals("016")?"selected":""%>>016</option>
							<option value="017" <%=_ac_emp_mobile1.equals("017")?"selected":""%>>017</option>
							<option value="018" <%=_ac_emp_mobile1.equals("018")?"selected":""%>>018</option>
							<option value="019" <%=_ac_emp_mobile1.equals("019")?"selected":""%>>019</option>
						</select>
						- 
						<input type="text" id="st_ac_emp_mobile2" name="st_ac_emp_mobile2" title="" style="width:25%" value="<%=_ac_emp_mobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
						- 
						<input type="text" id="st_ac_emp_mobile3" name="st_ac_emp_mobile3" title="" style="width:25%" value="<%=_ac_emp_mobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>
	            
	            <tr>
	            	<th rowspan="2">전자계약<br>메일수신자</th>
                	<th>이름</th>
                	<td>
	                	<input type="text" id="st_cont_emp_nm" name="st_cont_emp_nm" title="" style="width:97%" value="<%=CommonUtil.nvl(_rowData.get("CONT_EMP_NM"))%>" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
                	<th>이메일</th>
                	<td>
	                	<input type="text" id="st_cont_emp_email" name="st_cont_emp_email" title="" style="width:97%" value="<%=CommonUtil.nvl(_rowData.get("CONT_EMP_EMAIL"))%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>
	            
            	<tr>
	                <th>전화번호</th>
                	<td>
	              	<%
                		String _contTelNo = CommonUtil.nvl(_rowData.get("CONT_EMP_TEL"));	
                		String _contTelNo1 = "";
						String _contTelNo2 = "";
						String _contTelNo3 = "";
						
						if (!CommonUtil.nvl(_rowData.get("CONT_EMP_TEL")).equals("")){
							int i = CommonUtil.getCharCount(_contTelNo, '-');
							
							if(i == 0){
								_contTelNo1 = CommonUtil.nvl(_rowData.get("CONT_EMP_TEL")).split("\\-")[0];
							}else if(i == 1){
								_contTelNo1 = CommonUtil.nvl(_rowData.get("CONT_EMP_TEL")).split("\\-")[0];
								_contTelNo2 = CommonUtil.nvl(_rowData.get("CON_EMP_TEL")).split("\\-")[1];
							}else if(i == 2){
								_contTelNo1 = CommonUtil.nvl(_rowData.get("CONT_EMP_TEL")).split("\\-")[0];
								_contTelNo2 = CommonUtil.nvl(_rowData.get("CONT_EMP_TEL")).split("\\-")[1];
								_contTelNo3 = CommonUtil.nvl(_rowData.get("CONT_EMP_TEL")).split("\\-")[2];
							}
                    	}
                  	%>
	                	<select name="st_cont_emp_tel_no1" id="st_cont_emp_tel_no1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
		                    <option value="02"  <%=_contTelNo1.equals("02") ?"selected":""%>>02</option>
							<option value="031" <%=_contTelNo1.equals("031")?"selected":""%>>031</option>
							<option value="032" <%=_contTelNo1.equals("032")?"selected":""%>>032</option>
							<option value="033" <%=_contTelNo1.equals("033")?"selected":""%>>033</option>
							<option value="041" <%=_contTelNo1.equals("041")?"selected":""%>>041</option>
							<option value="042" <%=_contTelNo1.equals("042")?"selected":""%>>042</option>
							<option value="043" <%=_contTelNo1.equals("043")?"selected":""%>>043</option>
							<option value="044" <%=_contTelNo1.equals("044")?"selected":""%>>044</option>
							<option value="051" <%=_contTelNo1.equals("051")?"selected":""%>>051</option>
							<option value="052" <%=_contTelNo1.equals("052")?"selected":""%>>052</option>
							<option value="053" <%=_contTelNo1.equals("053")?"selected":""%>>053</option>
							<option value="054" <%=_contTelNo1.equals("054")?"selected":""%>>054</option>
							<option value="055" <%=_contTelNo1.equals("055")?"selected":""%>>055</option>
							<option value="061" <%=_contTelNo1.equals("061")?"selected":""%>>061</option>
							<option value="062" <%=_contTelNo1.equals("062")?"selected":""%>>062</option>
							<option value="063" <%=_contTelNo1.equals("063")?"selected":""%>>063</option>
							<option value="064" <%=_contTelNo1.equals("064")?"selected":""%>>064</option>
							<option value="070" <%=_contTelNo1.equals("070")?"selected":""%>>070</option>
							<option value="0303" <%=_contTelNo1.equals("0303")?"selected":""%>>0303</option>
							<option value="0502" <%=_contTelNo1.equals("0502")?"selected":""%>>0502</option>
							<option value="0504" <%=_contTelNo1.equals("0504")?"selected":""%>>0504</option>
							<option value="0505" <%=_contTelNo1.equals("0505")?"selected":""%>>0505</option>
							<option value="0506" <%=_contTelNo1.equals("0506")?"selected":""%>>0506</option>
							<option value="0507" <%=_contTelNo1.equals("0507")?"selected":""%>>0507</option>
                		</select>
                		-
                		<input type="text" id="st_cont_emp_tel_no2" name="st_cont_emp_tel_no2" title="" style="width:25%" value="<%=_contTelNo2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                		-
                		<input type="text" id="st_cont_emp_tel_no3" name="st_cont_emp_tel_no3" title="" style="width:25%" value="<%=_contTelNo3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
                	<th>휴대폰번호</th>
                	<td>
               		<% 
               				String _cont_emp_mobile = CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE"));
                     		String _cont_emp_mobile1 = "";
              				String _cont_emp_mobile2 = "";
              				String _cont_emp_mobile3 = "";
              				
              				if (!CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE")).equals("")){
    							int i = CommonUtil.getCharCount(_cont_emp_mobile, '-');
    							
    							if(i == 0){
    								_cont_emp_mobile1 = CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE")).split("\\-")[0];
    							}else if(i == 1){
    								_cont_emp_mobile1 = CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE")).split("\\-")[0];
    								_cont_emp_mobile2 = CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE")).split("\\-")[1];
    							}else if(i == 2){
    								_cont_emp_mobile1 = CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE")).split("\\-")[0];
    								_cont_emp_mobile2 = CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE")).split("\\-")[1];
    								_cont_emp_mobile3 = CommonUtil.nvl(_rowData.get("CONT_EMP_MOBILE")).split("\\-")[2];
    							}
                        	}
                    %>
						<select id="st_cont_emp_mobile1" name="st_cont_emp_mobile1" style="width:30%" <%=user_type.equals("U")?"disabled":""%>>
							<option value="010" <%=_cont_emp_mobile1.equals("010")?"selected":""%>>010</option>
							<option value="011" <%=_cont_emp_mobile1.equals("011")?"selected":""%>>011</option>
							<option value="016" <%=_cont_emp_mobile1.equals("016")?"selected":""%>>016</option>
							<option value="017" <%=_cont_emp_mobile1.equals("017")?"selected":""%>>017</option>
							<option value="018" <%=_cont_emp_mobile1.equals("018")?"selected":""%>>018</option>
							<option value="019" <%=_cont_emp_mobile1.equals("019")?"selected":""%>>019</option>
						</select>
						- 
						<input type="text" id="st_cont_emp_mobile2" name="st_cont_emp_mobile2" title="" style="width:25%" value="<%=_cont_emp_mobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
						- 
						<input type="text" id="st_cont_emp_mobile3" name="st_cont_emp_mobile3" title="" style="width:25%" value="<%=_cont_emp_mobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);" <%=user_type.equals("U")?"disabled":""%>/>
                	</td>
            	</tr>
            	
            	<tr>
	            	<th rowspan="2">계좌정보</th>
                	<th>은행명</th>
                	<td>
	                	<%=CommonUtil.nvl(_rowData.get("BANK_NAME"))%>
                	</td>
                	<th>계좌번호</th>
                	<td>
	                	<%=CommonUtil.nvl(_rowData.get("BANK_ACCOUNT_NO"))%>
                	</td>
            	</tr>
	            
            	<tr>
	                <th>예금주</th>
                	<td colspan="3" ><%=CommonUtil.nvl(_rowData.get("DEPOSITOR"))%></td>
            	</tr>
   			</table>
			※ 회원사 정보는 Admin 사용자만 수정 가능합니다. <br/><br/>
	   		
   			<div class="seller_info_tit">2. 사용자 정보</div>
			<table>
				<tr>
					<th width="15%">ID</th>
              		<td width="35%">
		              	<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>
    	          	</td>
              		<th width="15%">이름</th>
              		<td width="35%">
		              	<input type="text" id="st_user_nm" name="st_user_nm" title="" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%>" style="width:98%"/>
              		</td>
          		</tr>
	            
            	<tr>
	            	<th >전화번호</th>
                	<td>
	              	<%
                		String _userPhone = CommonUtil.nvl(_rowData.get("PHONE_NUMBER"));	
                		String _userPhone1 = "";
						String _userPhone2 = "";
						String _userPhone3 = "";
					
						if (!CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).equals("")){
							int i = CommonUtil.getCharCount(_userPhone, '-');
							
							if(i == 0){
								_userPhone1 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[0];
							}else if(i == 1){
								_userPhone1 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[0];
								_userPhone2 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[1];
							}else if(i == 2){
								_userPhone1 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[0];
								_userPhone2 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[1];
								_userPhone3 = CommonUtil.nvl(_rowData.get("PHONE_NUMBER")).split("\\-")[2];
							}
                    	}
                  	%>
                		<select name="st_user_phone1" id="st_user_phone1" style="width:30%">
		                    <option value="02"  <%=_userPhone1.equals("02") ?"selected":""%>>02</option>
							<option value="031" <%=_userPhone1.equals("031")?"selected":""%>>031</option>
							<option value="032" <%=_userPhone1.equals("032")?"selected":""%>>032</option>
							<option value="033" <%=_userPhone1.equals("033")?"selected":""%>>033</option>
							<option value="041" <%=_userPhone1.equals("041")?"selected":""%>>041</option>
							<option value="042" <%=_userPhone1.equals("042")?"selected":""%>>042</option>
							<option value="043" <%=_userPhone1.equals("043")?"selected":""%>>043</option>
							<option value="044" <%=_userPhone1.equals("044")?"selected":""%>>044</option>
							<option value="051" <%=_userPhone1.equals("051")?"selected":""%>>051</option>
							<option value="052" <%=_userPhone1.equals("052")?"selected":""%>>052</option>
							<option value="053" <%=_userPhone1.equals("053")?"selected":""%>>053</option>
							<option value="054" <%=_userPhone1.equals("054")?"selected":""%>>054</option>
							<option value="055" <%=_userPhone1.equals("055")?"selected":""%>>055</option>
							<option value="061" <%=_userPhone1.equals("061")?"selected":""%>>061</option>
							<option value="062" <%=_userPhone1.equals("062")?"selected":""%>>062</option>
							<option value="063" <%=_userPhone1.equals("063")?"selected":""%>>063</option>
							<option value="064" <%=_userPhone1.equals("064")?"selected":""%>>064</option>
							<option value="070" <%=_userPhone1.equals("070")?"selected":""%>>070</option>
							<option value="0303" <%=_userPhone1.equals("0303")?"selected":""%>>0303</option>
							<option value="0502" <%=_userPhone1.equals("0502")?"selected":""%>>0502</option>
							<option value="0504" <%=_userPhone1.equals("0504")?"selected":""%>>0504</option>
							<option value="0505" <%=_userPhone1.equals("0505")?"selected":""%>>0505</option>
							<option value="0506" <%=_userPhone1.equals("0506")?"selected":""%>>0506</option>
							<option value="0507" <%=_userPhone1.equals("0507")?"selected":""%>>0507</option>
                		</select>
                		-
                		<input type="text" id="st_user_phone2" name="st_user_phone2" title="" style="width:25%" value="<%=_userPhone2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
                		-
                		<input type="text" id="st_user_phone3" name="st_user_phone3" title="" style="width:25%" value="<%=_userPhone3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
                	</td>
                	<th>휴대폰번호</th>
                	<td>
               		<% 
               			String _userMobile = CommonUtil.nvl(_rowData.get("MOBILE_PHONE"));
                     	String _userMobile1 = "";
              			String _userMobile2 = "";
              			String _userMobile3 = "";
                   		
              			if (!CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).equals("")){
							int i = CommonUtil.getCharCount(_userMobile, '-');
							
							if(i == 0){
								_userMobile1 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[0];
							}else if(i == 1){
								_userMobile1 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[0];
								_userMobile2 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[1];
							}else if(i == 2){
								_userMobile1 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[0];
								_userMobile2 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[1];
								_userMobile3 = CommonUtil.nvl(_rowData.get("MOBILE_PHONE")).split("\\-")[2];
							}
                    	}
                    %>
						<select id="st_user_mobile1" name="st_user_mobile1" style="width:30%">
							<option value="010" <%=_userMobile1.equals("010")?"selected":""%>>010</option>
							<option value="011" <%=_userMobile1.equals("011")?"selected":""%>>011</option>
							<option value="016" <%=_userMobile1.equals("016")?"selected":""%>>016</option>
							<option value="017" <%=_userMobile1.equals("017")?"selected":""%>>017</option>
							<option value="018" <%=_userMobile1.equals("018")?"selected":""%>>018</option>
							<option value="019" <%=_userMobile1.equals("019")?"selected":""%>>019</option>
						</select>
						- 
						<input type="text" id="st_user_mobile2" name="st_user_mobile2" title="" style="width:25%" value="<%=_userMobile2%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
						- 
						<input type="text" id="st_user_mobile3" name="st_user_mobile3" title="" style="width:25%" value="<%=_userMobile3%>" maxlength="4" onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/>
                	</td>
            	</tr>
	            
            	<tr>
	                <th>이메일</th>
                	<td colspan="3">
	                	<input type="text" id="st_user_email" name="st_user_email" title="" style="width:99%" value="<%=CommonUtil.nvl(_rowData.get("USR_EMAIL"))%>"  maxlength="100" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"/>
                	</td>
            	</tr>
        	</table>

      		<a href="javascript:doAction();"><div class="ok">확  인</div></a>
		</div>
	</form>
</div>
</body>
</html>
