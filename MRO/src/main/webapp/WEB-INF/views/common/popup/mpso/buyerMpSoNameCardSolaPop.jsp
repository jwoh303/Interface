<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업
* 기능 : 솔라엣지 사무용품 (KRSOLA0011) 명함 정보 입력 팝업
* 프로그램 ID :
* 담당자 : 2229033
* 착수일 : 2024-02-16
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
String st_address = CommonUtil.nvl((String) request.getParameter("param_text"),"");
%>
<script type="text/javascript">
var popupSel = "";

function kep_onload(){
<%	
	if(_dataList != null || _dataList.size() > 0){
%>
		var st_remark = "<%=CommonUtil.nvl(_dataList.get("CART_REMARK"))%>";
		var remark_arr = st_remark.split(";");
		if(remark_arr.length == 9){
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 국문 성함
					document.forms.contentForm.st_kor_name.value = remark_arr[i];
				}else if(i == 1){ // 영문 성함
					document.forms.contentForm.st_eng_name.value = remark_arr[i];
				}else if(i == 2){ // 국문 직급
					document.forms.contentForm.st_kor_position.value = remark_arr[i];
				}else if(i == 3){ // 영문 직급
					document.forms.contentForm.st_eng_position.value = remark_arr[i];
				}else if(i == 4){ // 그룹 직위
					document.forms.contentForm.st_group.value = remark_arr[i];
				}else if(i == 5){ // 부서
					document.forms.contentForm.st_department.value = remark_arr[i];
				}else if(i == 6){ // 모바일
					document.forms.contentForm.st_mobile_no.value = remark_arr[i];
				}else if(i == 7){ // 이메일주소
					document.forms.contentForm.st_email.value = remark_arr[i];
				}else if(i == 8){ // 주소 코드
				}
			}
		}else if(remark_arr.length != 1){
			alert("<%=CommonLang.msg("MSG435")%>"); // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			this.close();
			return;
		}
<%
	}
%>
}

function setReturn(){
	var kor_name = document.forms.contentForm.st_kor_name.value;
	var eng_name = document.forms.contentForm.st_eng_name.value;
	var kor_position = document.forms.contentForm.st_kor_position.value;
	var eng_position = document.forms.contentForm.st_eng_position.value;
	var group = document.forms.contentForm.st_group.value;
	var department = document.forms.contentForm.st_department.value;
	var mobile_no = document.forms.contentForm.st_mobile_no.value;
	var email = document.forms.contentForm.st_email.value;
	var addr = $("#st_address option:selected").val();

	if(isEmpty(kor_name) || isEmpty(eng_name)  || isEmpty(group) || isEmpty(mobile_no) || isEmpty(email) || isEmpty(addr)){
		alert("* 표시된 필수 명함정보를 모두 입력하여 주십시오.");
		return;
	}
	
	alert
	remark	=	kor_name + ";"
			+	eng_name + ";"
			+	kor_position + ";"
			+	eng_position + ";"
			+	group + ";"
			+	department + ";"
			+	mobile_no + ";"
			+	email + ";"
			+	addr	;
			
	document.forms.searchCondition.st_remark.value = remark;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
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
						<tr>
                         	<th scope="col" width="100px"><font color="#FF6600">*</font> 국문 성함</th>
                         	<td width="180px"><input type="text" name="st_kor_name" id="st_kor_name" value="" style="width:90%"></td>
							<th scope="col" width="100px"><font color="#FF6600">*</font> 영문 성함</th>
                         	<td ><input type="text" name="st_eng_name" id="st_eng_name" value="" style="width:90%"></td>
                        </tr>
                         
						<tr>
							<th scope="col" width="100px">&nbsp;&nbsp;&nbsp;국문 직급</th>
                         	<td  width="180px"><input type="text" name="st_kor_position" id="st_kor_position" value="" style="width:90%"></td>
							<th scope="col" width="100px">&nbsp;&nbsp;&nbsp; 영문 직급</th>
                         	<td><input type="text" name="st_eng_position" id="st_eng_position" value="" style="width:90%"></td>
						</tr>
						<tr>
                         	<th scope="col "width="100px"><font color="#FF6600">*</font> 모바일</th>
							<td  width="180px">	
								<input type="text" name="st_mobile_no" id="st_mobile_no" value="" style="width:90%" placeholder="010-0000-0000 형식으로 입력">
							</td>
							<th scope="col" width="100px"><font color="#FF6600">*</font> 이메일</th>
							<td><input type="text" name="st_email" id="st_email" value="" style="width:90%"></td>
                        </tr>
                        
                        <tr>
                         	<th scope="col" width="100px"><font color="#FF6600">*</font> 주소</th>
							<td  width="180px">
								<select id="st_address" name="st_address" style="width:35.5%;height:23px">
									<%= CommonUtil.getCodeBComboList(st_buyer,"SEL","SLKR","ICOMCOD2",st_address,"TEXT1")%>
								</select>
							</td>
							<th scope="col" width="100px"><font color="#FF6600">*</font> 그룹</th>
							<td><input type="text" name="st_group" id="st_group" value="" style="width:90%"></td>
                        </tr>
                         
                        <tr>
							<th scope="col" width="100px"></th>
							<td></td>
							<th scope="col" width="100px">&nbsp;&nbsp;&nbsp;부서</th>
							<td colspan="3"><input type="text" name="st_department" id="st_department" value="" style="width:90%"></td>
						</tr>
						
							
					</tbody>
				</table>
			</div>
        
       		<!--버튼영역-->
			<div class="btnArea">
				<span class="fr">
					<span class="btn_02 mr02"  title="확인"> <a href="javascript:setReturn();">확인</a></span>
				</span>
			</div>
   		</div>
	</div>
</form>
</body>
</html>
