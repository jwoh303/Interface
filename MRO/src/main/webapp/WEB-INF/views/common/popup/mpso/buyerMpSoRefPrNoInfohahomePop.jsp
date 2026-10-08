<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 장바구니 관리항목 팝업
* 기능 : (주)한솔홈데코 장바구니 관리항목 팝업(계정과목/코스트센터/계정지정범주)
* 프로그램 ID :
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String cond1_code = (String)request.getAttribute("cond1_code"); // 조회된 결과
String cond1_name = (String)request.getAttribute("cond1_name"); // 조회된 결과
String cond2_code = (String)request.getAttribute("cond2_code"); // 조회된 결과
String cond2_name = (String)request.getAttribute("cond2_name"); // 조회된 결과
String cond3_code = (String)request.getAttribute("cond3_code"); // 조회된 결과



String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
%>
<script type="text/javascript">
	var st_ref_pr_no = "";
	var st_ref_pr_no_text = "";
	var popupSel = "";
	
	window.onload = function () {
		var cond3Code = "<%=cond3_code%>";		
	    document.getElementById("st_cond3_code").value = cond3Code;
	};	
// 계정 팝업
function getCond1Pop(){
	popupSel = "COND1";
	var st_buyer = $("#st_com_code").val();
	var st_gbn = "계정과목";
	var st_type = "M014";
	var st_code = "";
	var st_text = "";
	
	openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "500,500,no");
}

//코스트센터 팝업
function getCond2Pop(){
	popupSel = "COND2";
	var st_buyer = $("#st_com_code").val();
	var st_gbn = "코스트센터";
	var st_type = "C020";
	var st_code = "";
	var st_text = "";
	
    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");		
}

function setReturn(){
	if(set_ref_pr_no()){		
		opener.setPopupReturn("hahome",st_ref_pr_no,st_ref_pr_no_text);
		this.close();	
	}
}

function set_ref_pr_no(){
	var cond1 = "";
	var cond2 = "";
	var cond3 = "";
	var cond1_name = "";
	var cond2_name = "";
	var cond3_name = "";
	
	
	cond1 = document.forms.searchForm.st_cond1_code.value;
	cond2 = document.forms.searchForm.st_cond2_code.value;
	cond3 = document.forms.searchForm.st_cond3_code.value;
	cond1_name = document.forms.searchForm.st_cond1_name.value;
	cond2_name = document.forms.searchForm.st_cond2_name.value;
	if(cond3 == "K") {
		cond3_name = "K";
	} else if(cond3 == "Z") {
		cond3_name = "저장품";
	} else {
		cond3_name = "K+포장비";
	}
	
	
	if(cond1 == "" || cond2 == "" || cond3 == "" || cond1_name == "" || cond2_name == ""){
		alert("계정과목, 코스트센터, 계정지정범주를 모두 입력하여 주세요.");
		return false;	
	}
	// 계정과목 : 99999999 와 계정지정범주 Z(저장품)는 동시에 선택불가 -> 선택 가능하도록 수정
	/* if(cond1 == "99999999" && cond3 == "Z") {
		alert("저장품 미입력(계정)과 저장품(계정지정범주)은 동시에 선택 불가합니다.");
		return false;
	} */
	st_ref_pr_no = cond1 + "^" + cond2 + "^" + cond3;
	st_ref_pr_no_text = cond1_name + "^" + cond2_name + "^" + cond3_name;
	
	return true;
}

function setPopupReturn(value1,value2,value3){
	if(popupSel == "COND1"){
		document.forms.searchForm.st_cond1_code.value = value2;
		document.forms.searchForm.st_cond1_name.value = value3;
	}else if(popupSel == "COND2"){
		document.forms.searchForm.st_cond2_code.value = value2;
		document.forms.searchForm.st_cond2_name.value = value3;
	}
}
</script>
<body>
	<form name="searchForm" id="searchForm" method=post >
		<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">
		
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div id="popWrapper">
			<div id="popHeader">
				<h1 class="title">계정/코스트센터/계정지정범주 선택</h1>
				<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
			</div>
			
			<!--팝업내용입니다-->
			<div id="popContainer">
				<div id="searchBtnA02"></div>
				
				<!--조회영역-->
				<div id="cont_searchA">
					<table class="cont_t_list01"  style="width:100%">
						<caption>리스트</caption>
						<colgroup>
							<col width="20%" />
							<col width="*" />
						</colgroup>
						
						<tbody>
							<input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_buyer%>" readonly disabled="disabled">

							<tr>
								<td><font color="RED">*</font> 계정</td>
								<td>
									<input type="text" name="st_cond1_code" id="st_cond1_code" style="width:20%" value="<%=cond1_code%>" readonly>
									<a href="javascript:getCond1Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
									<input type="text" name="st_cond1_name" id="st_cond1_name" style="width:62%" value="<%=cond1_name%>" class="input_type_text" readonly>
								</td>
							</tr>
							
							<tr>
								<td><font color="RED">*</font> 코스트센터</td>
								<td>
									<input type="text" name="st_cond2_code" id="st_cond2_code" style="width:20%" value="<%=cond2_code%>" readonly>
									<a href="javascript:getCond2Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
									<input type="text" name="st_cond2_name" id="st_cond2_name" style="width:62%" value="<%=cond2_name%>" class="input_type_text" readonly>
								</td>
							</tr>
							<tr>
								<td><font color="RED">*</font> 계정지정범주</td>
								<td>
									<select name="st_cond3_code" id="st_cond3_code" style="width: 15%">
										  <option value="">선택</option>
										  <option value="K">K</option>
										  <option value="Z">저장품</option>
										  <option value="X">K+포장비</option>
									</select>
									<input type="hidden" name="st_cond3_name" id="st_cond3_name">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				
				<!--버튼영역-->
				<div class="btnArea" >
					<span class="fr">
						<span class="btn_02 mr02"  title="확인"> <a href="javascript:setReturn();">확인</a></span>
					</span>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
