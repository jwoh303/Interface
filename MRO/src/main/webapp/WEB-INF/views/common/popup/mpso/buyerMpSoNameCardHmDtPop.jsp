<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업(홈닥터)
* 기능 : 에스와이에스리테일(KRSYSR0001) 홈닥터 명함 정보입력 팝업
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2019-07-22
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode());
String st_user_id =  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String st_seq = CommonUtil.nvl((String) request.getParameter("st_seq"),"");
String st_position = CommonUtil.nvl((String) request.getParameter("param_text"),"");
%>
<script type="text/javascript">
var popupSel = "";

function kep_onload(){
<%	
	if(_dataList != null || _dataList.size() > 0){
%>
		var st_remark = "<%=CommonUtil.nvl(_dataList.get("CART_REMARK"))%>";
		var remark_arr = st_remark.split(";");
		if(remark_arr.length == 10){
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 소속 : 고정 (주)SYS Retail
				}else if(i == 1){ // 성명
					document.forms.contentForm.st_kor_name.value = remark_arr[i];
				}else if(i == 2){ // 영문명
					document.forms.contentForm.st_eng_name.value = remark_arr[i];
				}else if(i == 3){ // 센터명
					document.forms.contentForm.st_branch_name.value = remark_arr[i];
				}else if(i == 4){ // 직위  : 고정 홈닥터 Home Doctor
				}else if(i == 5){ // 센터주소
					document.forms.contentForm.st_kor_addr.value = remark_arr[i];
				}else if(i == 6){ // 내선번호
					document.forms.contentForm.st_phone_no.value = remark_arr[i];
				}else if(i == 7){ // 팩스번호
					document.forms.contentForm.st_fax_no.value = remark_arr[i];
				}else if(i == 8){ // 휴대폰번호
					document.forms.contentForm.st_mobile_no.value = remark_arr[i];
				}else if(i == 9){ // 이메일주소
					document.forms.contentForm.st_email.value = remark_arr[i];
				}
			}
		}else if(remark_arr.length != 1){
			alert("<%=CommonLang.msg("MSG435")%>"); // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			return;
		}
<%
	}
%>
}

function setReturn(){
	var division = document.forms.contentForm.st_division.value;
	var kor_name = document.forms.contentForm.st_kor_name.value;
	var eng_name = document.forms.contentForm.st_eng_name.value;
	var branch_name = document.forms.contentForm.st_branch_name.value;
	var position = document.forms.contentForm.st_position.value;
	var kor_addr = document.forms.contentForm.st_kor_addr.value;
	var phone_no = document.forms.contentForm.st_phone_no.value;
	var fax_no = document.forms.contentForm.st_fax_no.value;
	var mobile_no = document.forms.contentForm.st_mobile_no.value;
	var email = document.forms.contentForm.st_email.value;
	var remark = "";

	if(isEmpty(division) || isEmpty(kor_name) || isEmpty(eng_name) || isEmpty(branch_name) || isEmpty(position) || isEmpty(kor_addr) || isEmpty(phone_no) || isEmpty(fax_no) || isEmpty(mobile_no) || isEmpty(email)){
		alert("* 표시된 필수 명함정보를 모두 입력하여 주십시오.");
		return;
	}
	
	remark	=	division + ";"
			+	kor_name + ";"
			+	eng_name + ";"
			+	branch_name + ";"
			+	position + ";"
			+	kor_addr + ";"
			+	phone_no + ";"
			+	fax_no + ";"
			+	mobile_no + ";"
			+	email;
	
	document.forms.searchCondition.st_remark.value = remark;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function setPopupReturn(value1,value2,value3,value4){
	document.forms.contentForm.st_branch_name.value = value1;
	document.forms.contentForm.st_phone_no.value = value2;
	document.forms.contentForm.st_fax_no.value = value3;
	document.forms.contentForm.st_kor_addr.value = value4;
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	var remark = document.forms.searchCondition.st_remark.value;
	
	if (!isEmpty(msg)){
		alert("명함정보가 정상적으로 저장되었습니다.");
		opener.setPopupReturn(remark);
		this.close();	
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

//팝업함수호출
function doPop(str){
	popupSel = str;
	
	switch (str){
		case "get_branch": // 지점센터명
			popupSel = "get_branch";
			var st_buyer = "<%=st_buyer%>";
			var st_type = "NCIF";
			var st_gbn = "센터 리스트";
			var st_code1 = "HMDT";
			openSearchPopup("/common/getCode4PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code1="+st_code1, "1000,450,no");
			break;
	}
}
</script>
<body onload="kep_onload()">
<form id ="searchCondition" name="searchCondition" method = "post" onsubmit="return false">
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>"/>
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=st_user_id%>">
	<input type="hidden" name="st_seq" id="st_seq" value="<%=st_seq%>">
	<input type="hidden" name="st_remark" id="st_remark" value="">
</form>
<form name="contentForm" id="contentForm" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
   		<div id="popHeader">
       		<h1 class="title">명함 정보 입력</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">
			<div id="searchBtnA02">
			</div>
				
			<!--조회영역-->
            <div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
					<caption> 리스트</caption>
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="30%" />
					</colgroup>
					<tbody>
						<tr>
                         	<th scope="col"><font color="#FF6600">*</font> 소속</th>
							<td><input type="text" name="st_division" id="st_division" value="(주)SYS Retail" style="width:90%" readOnly></td>
							<th scope="col"></th>
							<td></td>
                        </tr>
                         
						<tr>
							<th scope="col"><font color="#FF6600">*</font> 성명</th>
							<td><input type="text" name="st_kor_name" id="st_kor_name" value="" style="width:90%"></td>
							<th scope="col"><font color="#FF6600">*</font> 영문명</th>
							<td><input type="text" name="st_eng_name" id="st_eng_name" value="" style="width:100%"></td>
						</tr>
                         
                        <tr>
							<th scope="col"><font color="#FF6600">*</font> 지점/센터명</th>
							<td>
								<input type="text" name="st_branch_name" id="st_branch_name" value="" style="width:70%" readOnly>
								<a href="javascript:doPop('get_branch');"><img src="/resources/images/btn_search03.gif"></a>
							</td>
							<th scope="col"><font color="#FF6600">*</font> 직위</th>
							<td><input type="text" name="st_position" id="st_position" value="홈닥터 Home Doctor" style="width:100%" readOnly></td>
						</tr>
						
						<tr>
							<th scope="col"><font color="#FF6600">*</font> 지점주소</th>
							<td colspan="3"><input type="text" name="st_kor_addr" id="st_kor_addr" value="" style="width:100%" readOnly></td>
						</tr>
                         
                        <tr>
							<th scope="col"><font color="#FF6600">*</font> 내선번호</th>
							<td><input type="text" name="st_phone_no" id="st_phone_no" value="" style="width:90%" readOnly></td>
							<th scope="col"><font color="#FF6600">*</font> 팩스번호</th>
							<td><input type="text" name="st_fax_no" id="st_fax_no" value="" style="width:100%" readOnly></td>
						</tr>
						
						<tr>
                         	<th scope="col"><font color="#FF6600">*</font> 휴대폰번호</th>
							<td><input type="text" name="st_mobile_no" id="st_mobile_no" value="" style="width:90%"></td>
							<th scope="col"><font color="#FF6600">*</font> 이메일주소</th>
							<td><input type="text" name="st_email" id="st_email" value="" style="width:100%"></td>
                        </tr>
					</tbody>
				</table>
			</div>
        
       		<!--버튼영역-->
			<div class="btnArea">
				<span class="fl" style="text-align: left">
					<b>* 사진 유의사항: 뒷배경 단색, 유니폼 착용, 3x5 이미지 파일.</b><br>
					<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(장바구니 내"파일추가" 버튼 이용하여 사진 첨부)</b><br>
					<b>* 영문 성명 기입 유의사항: 각 이름 첫영문자 대문자로 표기 (Hong Suk Su)</b><br>
				</span>
				<span class="fr">
					<span class="btn_02 mr02"  title="확인"> <a href="javascript:setReturn();">확인</a></span>
				</span>
			</div>
   		</div>
	</div>
</form>
</body>
</html>
