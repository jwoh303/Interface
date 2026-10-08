<%--
**********************************************
* 메뉴 : 
* 화면 : 장바구니 > 명함 정보 입력 팝업(클린킹/가전에어컨)
* 기능 : 에스와이에스리테일(KRSYSR0001) 지점용 명함 정보입력 팝업
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2018-08-20
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
String st_center = CommonUtil.nvl((String) request.getParameter("param_text"),"");
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");
%>
<script type="text/javascript">
var popupSel = "";

function kep_onload(){
<%	
	if(_dataList != null || _dataList.size() > 0){
%>
		var st_remark = "<%=CommonUtil.nvl(_dataList.get("CART_REMARK"))%>";
		var remark_arr = st_remark.split(";");
		
		if(remark_arr.length == 4 || remark_arr.length == 5){ // 클린킹 4, 가정에어컨 5(물류센터 주소 추가)
			for(var i=0; i<remark_arr.length; i++){
				if(i == 0){ // 협력사명
					document.forms.contentForm.st_agent.value = remark_arr[i];
				}else if(i == 1){ // 성명
					document.forms.contentForm.st_kor_name.value = remark_arr[i];
				}else if(i == 2){ // 물류센터명 - 파라미터로 받음
				}else if(i == 3){ // 휴대폰번호
					document.forms.contentForm.st_mobile_no.value = remark_arr[i];
				}
			}
		}else if(remark_arr.length != 1){ // 최초등록은 1
			alert("<%=CommonLang.msg("MSG435")%>"); // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
			return;
		}
<%
	}
%>
}

function setReturn(){
	var agent = document.forms.contentForm.st_agent.value;
	var kor_name = document.forms.contentForm.st_kor_name.value;
	var center = $("#st_center option:selected").text();
	var mobile_no = document.forms.contentForm.st_mobile_no.value;
	var center_code = document.forms.contentForm.st_center.value;
	var remark = "";
	
	if(isEmpty(agent) || isEmpty(kor_name) || center == "선택" || isEmpty(mobile_no)){
		alert("* 표시된 필수 명함정보를 모두 입력하여 주십시오.");
		return;
	}
	
	remark	=	agent + ";"
			+	kor_name + ";"
			+	center + ";"
			+	mobile_no;
	
	document.forms.searchCondition.st_remark.value = remark;
	document.forms.searchCondition.st_center_code.value = center_code;
	kepAjaxFormCall("/mpso/saveBuyerMpSoCartRemarkNameCard.do","searchCondition","");
}

function setPopupReturn(value1, value2, value3){
	document.forms.contentForm.st_agent.value = value3;
}

function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	var remark = document.forms.searchCondition.st_remark.value;
	
	if (!isEmpty(msg)){
		alert("명함정보가 정상적으로 저장되었습니다.");
		
		<%if("HAAC".equals(st_type)){%>
			opener.setPopupReturn(msg);
		<%}else{%>
			opener.setPopupReturn(remark);
		<%}%>
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
	switch (str){
		case "CLNK": // 클린킹
			popupSel = "get_agent";
			var st_buyer = "<%=st_buyer%>";
			var st_gbn = "협력사리스트";
			var st_type = "CKAG";
			var st_code = "";
			var st_text = "";
		    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
			break;
			
		case "HAAC": // 가전에어컨
			popupSel = "get_agent";
			var st_buyer = "<%=st_buyer%>";
			var st_gbn = "협력사리스트";
			var st_type = "HAAG";
			var st_code = "";
			var st_text = "";
		    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
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
	<input type="hidden" name="st_center_code" id="st_center_code" value="">
	<input type="hidden" name="st_type" id="st_type" value="<%=st_type%>">
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
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tbody>
						<tr>
                         	<th scope="col"><font color="#FF6600">*</font> 협력사명</th>
							<td>
								<input type="text" name="st_agent" id="st_agent" value="" style="width:70%" readOnly>
								<a href="javascript:doPop('<%=st_type%>');"><img src="/resources/images/btn_search03.gif"></a>
							</td>
							<th scope="col"><font color="#FF6600">*</font> 성명</th>
							<td><input type="text" name="st_kor_name" id="st_kor_name" value="" style="width:90%"></td>
                        </tr>
                         
						<tr>
							<th scope="col"><font color="#FF6600">*</font> 물류센터명</th>
							<td>
								<select id="st_center" name="st_center" style="width:90%;height:20px">
									<%= CommonUtil.getTextComboList(st_buyer,"SEL","SYCT","ICOMCOD2","CODE",st_center)%>
								</select>
							</td>
							<th scope="col"><font color="#FF6600">*</font> 휴대폰번호</th>
							<td><input type="text" name="st_mobile_no" id="st_mobile_no" value="" style="width:90%"></td>
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
