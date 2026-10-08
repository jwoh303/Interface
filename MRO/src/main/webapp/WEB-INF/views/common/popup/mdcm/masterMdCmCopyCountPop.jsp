<%--
**********************************************
* 메뉴 : 
* 화면 : 변경사유 입력 
* 기능 : 변경사유 입력 팝업
* 프로그램 ID : 
* 담당자 : 홍석규
* 착수일 : 2014-06-19
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
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>

<script type="text/javascript">
<!--
function popupOnload(){
	document.forms[0].st_copy_cnt.focus();
    return;
}

function setReturn()
{ 
	var copy_cnt = TrimCommon(document.forms[0].st_copy_cnt.value);
	if(copy_cnt == "" || copy_cnt == "0"){
		alert("복사할 건수를 입력하여 주십시요");
		document.forms[0].st_copy_cnt.value = "";
		document.forms[0].st_copy_cnt.focus();
		return;
	}
	
	var check = IsNumber1(TrimCommon(copy_cnt));
    if(check == false){
		alert("입력값이 문자이거나 또는 공백입니다.");
		document.forms[0].st_copy_cnt.value = "";
		document.forms[0].st_copy_cnt.focus();
		return;
	}else if(check == true){
		opener.setPopupReturn(copy_cnt);
		this.close();
		return;
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setReturn();
	}
}
 //-->
</script> 
<body onload="popupOnload();">
<form name="masterMdCmCopyCountPop" id="masterMdCmCopyCountPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">복사건수 입력 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>복사건수 입력</caption>
						<colgroup>
							<col width="65%" />
							<col width="25%" />
							<col width="15%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<th>복사할 수량을 입력하세요</th>
							<td> 
								<input type=text id="st_copy_cnt" name ="st_copy_cnt" size = "15" maxlength = "10" value = "" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td></td>						 
							<td  class="right">
								<span class="btn_search"><a href="javascript:setReturn();">확인</a></span> 
							</td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
    	</div>        
	</div>
</form> 
</body>
</html>
