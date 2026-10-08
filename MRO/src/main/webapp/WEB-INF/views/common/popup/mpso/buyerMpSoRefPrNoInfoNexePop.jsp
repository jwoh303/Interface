<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 장바구니 관리항목 팝업
* 기능 : 넥센타이어 장바구니 관리항목 팝업
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
Map<String,String> _data = (Map<String,String>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");


String st_buyer =  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode());
String st_account_type =  CommonUtil.nvl((String) request.getParameter("st_account_type"), "");
String ref_pr_no =  CommonUtil.nvl((String) request.getParameter("ref_pr_no"), "");
String ref_pr_no_text =  CommonUtil.nvl((String) request.getParameter("ref_pr_no_text"), "");
String code = CommonUtil.nvl( _data.get("CODE"), "");
String text1 = CommonUtil.nvl( _data.get("TEXT1"), "");
%>

<body>
	<form name="searchForm" id="searchForm" method=post >
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">고정자산번호 입력</h1>
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
					<tr>
						<td>
						<h3 style="margin-bottom: 0px;">■ 투자</h3>
						</td>
					</tr>
					
						<input type="hidden" name="st_com_code" id="st_com_code" value="" readonly disabled="disabled">	
						<tr>							
							<td>- 투자 번호 : <%=code %></td>							
						</tr>
						<tr>
							<td>- 투자 명 : <%=text1 %></td>
						</tr>										
						<tr>
						<td>
						<h3 style="margin-bottom: 0px;">■ 고정자산</h3>	
						</td>
						</tr>
						<tr>
							<td>
								<span style="margin-right: 10px;">- 고정자산번호</span>
								<input type="text" name="st_ref_pr_no_text" id="st_ref_pr_no_text" style="width:40%" value="<%=ref_pr_no_text%>">
								<input type="hidden" name="st_ref_pr_no" id="st_ref_pr_no" style="width:40%" value="">
								<a href="javascript:account_list();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
        <!--버튼영역-->
		 <div class="btnArea" >
		 <span class="fr">
				<span class="btn_02 mr02"  title="확인"> <a href="javascript:setReturn();">저장</a></span>
				<span class="btn_02 mr02"  title="확인"> <a href="javascript:deleteRefNo();">삭제</a></span>
				<span class="btn_02 mr02"  title="확인"> <a href="javascript:self.close();">닫기</a></span>
		  </span>
		</div>
    </div>
</div>
</form>
</body>

<script type="text/javascript">
	var st_ref_pr_no = "";
	// 사용자 조회 팝업
	function account_list(){
		var st_buyer = '<%=st_buyer%>';
		var st_account_type = '<%=st_account_type%>';
		
		
		openSearchPopup("/mpso/getBuyerMpSoRefPrNoListNexePop.do","?st_account_type="+st_account_type+"&st_buyer="+st_buyer, "500,500,no");
	
	}
		
	
	function setReturn(){
			var st_ref_pr_no = document.forms.searchForm.st_ref_pr_no.value;
			var st_ref_pr_no_text = document.forms.searchForm.st_ref_pr_no_text.value;
			if(st_ref_pr_no == "") {
				alert("고정자산번호를 선택하세요.")
				return;
			}
			opener.setPopupReturn("NexeRefNo",st_ref_pr_no, st_ref_pr_no_text);
			this.close();	
		
	}
	
	function deleteRefNo() {
		document.forms.searchForm.st_ref_pr_no_text.value = "";
		document.forms.searchForm.st_ref_pr_no.value = "";
	}
	
	
	
	function setPopupReturn(value1,value2,value3){		
		if(value1 == "selectRefNo"){
			document.forms.searchForm.st_ref_pr_no_text.value = value2 + "(" + value3 + ")";
			document.forms.searchForm.st_ref_pr_no.value = value2;
		}
	}
</script>
</html>
