<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 장바구니 관리항목 팝업
* 기능 : 한샘 장바구니 관리항목 팝업
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

String st_cond1_id			= CommonUtil.nvl((String)request.getAttribute("st_cond1_id"));		// 사용자ID
String st_cond1_empno		= CommonUtil.nvl((String)request.getAttribute("st_cond1_empno"));	// 사용자사번
String st_cond2_id			= CommonUtil.nvl((String)request.getAttribute("st_cond2_id"));		// 관리자ID
String st_cond2_empno		= CommonUtil.nvl((String)request.getAttribute("st_cond2_empno"));	// 관리자사번
String st_cond3_number		= CommonUtil.nvl((String)request.getAttribute("st_cond3_number"));	// 품의번호
String st_cond4_reason		= CommonUtil.nvl((String)request.getAttribute("st_cond4_reason"));	// 구매사유

String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
%>

<body>
	<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">장바구니 정보 입력</h1>
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
					<tbody>
						<input type="hidden" name="st_com_code" id="st_com_code" value="<%=st_buyer%>" readonly disabled="disabled">	
						<tr>
							<td>
								<input type="text" name="st_cond1_id" id="st_cond1_id" style="width:20%" value="<%=st_cond1_id%>" placeholder="실사용자" readonly>
								<a href="javascript:getCond1Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
								<span style="width:5px; display: inline-block;"></span>
								<input type="text" name="st_cond2_id" id="st_cond2_id" style="width:20%" value="<%=st_cond2_id%>" placeholder="관리자" readonly>
								<a href="javascript:getCond2Pop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
								<span style="width:5px; display: inline-block;"></span>
								<input type="text" name="st_cond3_number" id="st_cond3_number" style="width:25%;" value="<%=st_cond3_number%>" placeholder="품의번호">
							</td>
							
						</tr>
						<tr>
							<td>
								<input type="text" name="st_cond1_empno" id="st_cond1_empno" style="width:26%" value="<%=st_cond1_empno%>" placeholder="사번" readonly>
								<span style="width:6px; display: inline-block;"></span>
								<input type="text" name="st_cond2_empno" id="st_cond2_empno" style="width:26%" value="<%=st_cond2_empno%>" placeholder="사번" readonly>
							</td>
						</tr>
						<tr>
							<td>
								<span style="margin-right: 10px;">구매사유</span>
								<input type="text" name="st_cond4_reason" id="st_cond4_reason" style="width:72%" value="<%=st_cond4_reason%>">
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

<script type="text/javascript">
	var st_ref_pr_no = "";
	// 사용자 조회 팝업
	function getCond1Pop(){
		var st_buyer = $("#st_com_code").val();
		var st_gbn = "실사용자";
		var st_type = "USER";
		var st_code = "";
		var st_text = "";
		
		openSearchPopup("/common/getUserInfoSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
	
	}
		
	// 관리자 조회 팝업
	function getCond2Pop(){
		var st_buyer = $("#st_com_code").val();
		var st_gbn = "관리자";
		var st_type = "ADMIN";
		var st_code = "";
		var st_text = "";
		
		openSearchPopup("/common/getUserInfoSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");
	
	}
	
	function setReturn(){
		if(set_ref_pr_no()){		
			opener.setPopupReturn("Hans",st_ref_pr_no);
			this.close();	
		}else{
			alert('실사용자, 관리자, 품의번호 항목은 비워둘 수 없습니다.');
		}
	}
	
	function set_ref_pr_no(){
		
		var cond1 = "";
		var cond2 = "";
		var cond3 = "";	
		var cond4 = "";
		var cond5 = "";
		var cond6 = "";	
			
		cond1 = document.forms.searchForm.st_cond1_id.value;
		cond2 = document.forms.searchForm.st_cond1_empno.value;
		cond3 = document.forms.searchForm.st_cond2_id.value;
		cond4 = document.forms.searchForm.st_cond2_empno.value;
		cond5 = document.forms.searchForm.st_cond3_number.value;
		cond6 = document.forms.searchForm.st_cond4_reason.value;
		
		// 필수 항목 중 1개라도 비어있다면
		if(isEmpty(cond1) || isEmpty(cond2) || isEmpty(cond3) || isEmpty(cond4) || isEmpty(cond5)){
			return false;
		}
		

		st_ref_pr_no = cond1 + "^" + cond2 + "^" + cond3 + "^" + cond4 + "^" + cond5 + "^" + cond6;
		return true;
	}
	
	function setPopupReturn(value1,value2,value3){
		
		if(value1 == "USER"){
			document.forms.searchForm.st_cond1_id.value = value2;
			document.forms.searchForm.st_cond1_empno.value = value3;
		}else if(value1 == "ADMIN"){
			document.forms.searchForm.st_cond2_id.value = value2;
			document.forms.searchForm.st_cond2_empno.value = value3;
		}
	}
</script>
</html>
