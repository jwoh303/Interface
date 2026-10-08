<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 장바구니 관리번호 팝업
* 기능 : 윈체(KRWINC0002, KRWINC0003) 장바구니 관리번호 팝업
* 프로그램 ID :
* 담당자 : HSJ ( 설계 : 최진수 )
* 착수일 : 2016-12-22
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
String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)

String st_cond1_text = CommonUtil.nvl((String) request.getParameter("cond1"),"");  //  (조회조건)
String st_cond2_text = CommonUtil.nvl((String) request.getParameter("cond2"),"");  //  (조회조건)
String st_cond3_text = CommonUtil.nvl((String) request.getParameter("cond3"),"");  //  (조회조건)
String st_cond4_text = CommonUtil.nvl((String) request.getParameter("cond4"),"");  //  (조회조건)
%>
<script type="text/javascript">
var st_ref_pr_no = "";

function kep_onload(){
	var arr_ref_no = "<%=st_ref_no%>";
	
	var cond1_code = "";
	var cond1_text = "";
	var cond3_code = "";
	var cond3_text = "";
	var cond4_code = "";
	var cond4_text = "";
	
	if(arr_ref_no != ""){
		var ref_no = arr_ref_no.split("^");

		cond1_code = ref_no[0];
		cond1_text = ref_no[1];
		
		// 원래 값 비재고(XX)이면 업체구분만 셋팅
		if(cond1_code != "XX"){
			cond3_code = ref_no[2];
			cond3_text = ref_no[3];
			cond4_code = ref_no[4];
			cond4_text = ref_no[5];	
		}
		
		document.forms.searchForm.st_cond1.value = cond1_code;
		
		if(cond1_code != "XX"){
			document.forms.searchForm.st_cond3_code.value = cond3_code;
			document.forms.searchForm.st_cond3_name.value = cond3_text;
			document.forms.searchForm.st_cond4_code.value = cond4_code;
			document.forms.searchForm.st_cond4_name.value = cond4_text;	
		}
	}
}

function kepEnter(str){
	if (event.keyCode == 13){
		if(str == "COND2"){
			getCond2Pop();	
		}
		else if(str == "COND3"){
			getCond3Pop();
		}
	}
}

function chk_before_confirm(){
	var cond1_code = "";
	var cond1_text = "";
	var cond3_code = "";
	var cond3_text = "";
	var cond4_code = "";
	var cond4_text = "";
	
	cond1_code = document.forms.searchForm.st_cond1.value;
	cond1_text = document.getElementById("st_cond1")[document.getElementById("st_cond1").selectedIndex].text;
	cond3_code = document.forms.searchForm.st_cond3_code.value;
	cond3_text = document.forms.searchForm.st_cond3_name.value;
	cond4_code = document.forms.searchForm.st_cond4_code.value;
	cond4_text = document.forms.searchForm.st_cond4_name.value;
	
	if(cond1_code == "XX"){ // 비재고 선택 시
		st_ref_pr_no = cond1_code + "^" + cond1_text;
	}else{ // 이외는 모든 값 선택 필수
		if(cond1_code == ""){
			alert("<%=st_cond1_text%>을 선택하여 주시기 바랍니다.");
			return false;
		}else if(cond3_code == "" || cond3_text == "" || cond4_code == "" || cond4_text == ""){
			alert("<%=st_cond3_text%> / <%=st_cond4_text%>을 선택하여 주시기 바랍니다.");
			return false;
		}

		st_ref_pr_no = cond1_code + "^" + cond1_text + "^" + cond3_code + "^" + cond3_text + "^" + cond4_code + "^" + cond4_text;
	}
	
	return true;
}

//ICOMCOD3 팝업
function getCond3Pop(){
	var st_buyer = "<%=st_buyer%>";
	var st_gbn = "<%=st_cond3_text%> / <%=st_cond4_text%>";
	var st_type = "SPOT";
	var st_code1 = "";
	var st_code2 = "";
	var st_text1 = document.forms.searchForm.st_cond3_name.value;
	var st_text2 = document.forms.searchForm.st_cond4_name.value;
	var comboVal = document.forms.searchForm.st_cond1.value;
	
	if(comboVal == "XX"){
		document.forms.searchForm.st_cond3_code.value = "";
		document.forms.searchForm.st_cond3_name.value = "";
		document.forms.searchForm.st_cond4_code.value = "";
		document.forms.searchForm.st_cond4_name.value = "";
		alert("업무구분 비재고는 선택 불가합니다.");
		return;
	}else{
		document.forms.searchForm.st_cond3_code.value = "";
		document.forms.searchForm.st_cond4_code.value = "";
		
	    openSearchPopup("/common/getCode3PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code1="+st_code1+"&st_code2="+st_code2+"&st_text1="+st_text1+"&st_text2="+st_text2, "600,500,no");
	}
}

function comboSet(){
	var comboVal = document.forms.searchForm.st_cond1.value;
	
	if(comboVal == "XX"){ // 비재고이면 모든 조건 초기화
		document.forms.searchForm.st_cond3_code.value = "";
		document.forms.searchForm.st_cond3_name.value = "";
		document.forms.searchForm.st_cond4_code.value = "";
		document.forms.searchForm.st_cond4_name.value = "";
	}
}

function setReturn(){
	if(chk_before_confirm()){
		opener.setPopupReturn("",st_ref_pr_no, "", "");
		this.close();	
	}
}

function setPopupReturn(type,value1,value2,value3,value4){
	if(type == "SPOT"){ // 발주사, 현장
		document.forms.searchForm.st_cond3_code.value = value1;
		document.forms.searchForm.st_cond3_name.value = value2;
		document.forms.searchForm.st_cond4_code.value = value3;
		document.forms.searchForm.st_cond4_name.value = value4;
	}
}

</script>
<body onload="kep_onload()">
	<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="codeGubun" id="codeGubun" value="buyerMpSoRefPrNoInfoPop4cond">
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">추가정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            </div>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption> 리스트</caption>
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
                            <col width="30%" />
						</colgroup>
						<tbody>
						<tr>
							<td><%=st_cond1_text%></td>
							<td>
								<select name="st_cond1" id="st_cond1" style="width:80%" onChange="comboSet()"><%= CommonUtil.getCodeBComboList(st_buyer,"SEL","C020","ICOMCOD2","CODE","TEXT1") %></select>
                            </td>
						</tr>
						<tr>
							<td><%=st_cond3_text%> / <%=st_cond4_text%></td>
							<td>
								<input type="text" name="st_cond3_name"  id="st_cond3_name" style="ime-mode:active" value="" onkeydown="kepEnter('COND3')" class="input_type_text">
								<input type="hidden" name="st_cond3_code" id="st_cond3_code" value="">/
								<input type="text" name="st_cond4_name" id="st_cond4_name" style="ime-mode:active" value="" onkeydown="kepEnter('COND3')" class="input_type_text">
								<input type="hidden" name="st_cond4_code" id="st_cond4_code" value="">
								<a href="javascript:getCond3Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
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
