<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 장바구니 관리항목 팝업
* 기능 : 와이지원 장바구니 관리항목 팝업
* 프로그램 ID :
* 담당자 : 
* 반영일 : 2024-11-29
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

String cond0_code = (String)request.getAttribute("cond0_code"); // 조회된 결과
String cond1_code = (String)request.getAttribute("cond1_code"); // 조회된 결과

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
%>

<script type="text/javascript">
var popupSel = "";
var st_buyer = "<%=st_buyer%>";
var st_ref_pr_no = "";

function kep_onload(){ 
	
}

function setReturn(){
	if(set_ref_pr_no()){
		
		opener.setPopupReturn("",st_ref_pr_no);
		this.close();	
	}	
}

function set_ref_pr_no(){

	if(kepIsEmpty("st_cond0") || kepIsEmpty("st_cond1")){
		alert("그룹웨어 품의번호 또는 GL계정 미입력 되었습니다.");
		return false;
	}
	
	var cond0 = document.forms.searchForm.st_cond0.value;
	var cond1 = document.forms.searchForm.st_cond1.value;

	st_ref_pr_no = cond0 + "^" + cond1;
	
	return true;
}

</script>
<body onload="kep_onload()">
	<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">MRO 구매품목 관리항목 등록</h1>
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
							<col width="30%" />
							<col width="*" />
						</colgroup>
						<tbody>
						<tr>
							<td><span class="f_red">*</span> 품의번호</td>
							<td>
								<input type="text" name="st_cond0"  id="st_cond0" maxlength="400" style="width:89%; ime-mode:active" value="<%=cond0_code%>" class="input_type_text">
                            </td>
						</tr>
												
						<tr>
							<td><span class="f_red">*</span> G/L ACCOUNT</td>
							<td>
								<select name="st_cond1" id="st_cond1"><%= CommonUtil.getCodeBComboList(st_buyer,"SEL","M014","ICOMCOD2",cond1_code,"TEXT1") %></select>
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
