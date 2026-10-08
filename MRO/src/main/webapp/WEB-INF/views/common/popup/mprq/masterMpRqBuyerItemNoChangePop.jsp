<%--
**********************************************
* 메뉴 : 견적관리 > 업체선정 및 견적제출 > 고객사 견적제출 > 고객사 품목코드 중복확인 
* 화면 : 고객사 품목코드 중복확인
* 기능 : 고객사 카탈로그 등록여부 조회 팝업
* 프로그램 ID :
* 담당자 : HSJ
* 착수일 : 2024-02-23
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_dup_check = CommonUtil.nvl((String) request.getParameter("st_dup_check"),"N");
%>

<script type="text/javascript">
function kepSearch(){
  $('#masterMpRqBuyerItemNoChangePop').attr("action", "/mprq/getMasterMpRqBuyerItemNoChangePop.do").submit();
}

function kepEnter(){
	if (event.keyCode == 13) {
		kepSearch();
	}else{ // 엔터키 제외 입력되면 다시 N 으로
		$('#st_dup_check').val("N");	
	}
}

function setReturn(){
	if(document.masterMpRqBuyerItemNoChangePop.st_dup_check.value == "N"){
		alert("중복 확인을 먼저 눌러주시기 바랍니다.");
		return;
	}
	opener.setPopupReturn(document.masterMpRqBuyerItemNoChangePop.st_buyer_item_no.value);
	this.close();
}
</script>
<body onload="">
<form name="masterMpRqBuyerItemNoChangePop" id="masterMpRqBuyerItemNoChangePop" method="post">
<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:200px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 품목코드 중복확인</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:150px;">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">중복 확인</a></span>
            	<span class="btn_reset"><a href="javascript:setReturn();">코드 사용</a></span>
            </div>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>카탈로그 등록여부  리스트</caption>
						<colgroup>
							<col width="12%" />
	                        <col width="38%" />
	                        <col width="12%" />
	                        <col width="38%" />
						</colgroup>
						<tbody>
						<tr>
							<th>품목코드</th>
							<td>
								<input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value="<%=st_buyer_item_no%>" onkeydown="kepEnter()">
                            </td>
							<th></th>
							<td></td>
                         </tr>
					</tbody>
				</table>
            </div>

           	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>조회 결과</caption>
                    <colgroup>
                        <col width="100%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">조회 결과</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td align="center" height = "30">
                        	<span class="font1">사용 가능합니다.</span>
                        	<input type="hidden" name="st_dup_check" id="st_dup_check" value="Y">
                        </td>
                    </tr>
<%
}else{
%>
					<tr bgcolor="#FFFFFF">
                        <td align="center" height = "30">
                        	<span class="font1">사용 불가합니다. 다른 코드를 입력하여 중복 확인 해주시기 바랍니다.</span>
                        	<input type="hidden" name="st_dup_check" id="st_dup_check" value="N">
                        </td>
                    </tr>
<%
}
%>
                    </tbody>
                </table>
    </div>
</div>
</form>
</body>
</html>