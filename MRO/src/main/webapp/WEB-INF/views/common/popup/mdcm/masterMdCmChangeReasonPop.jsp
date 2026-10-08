<%--
**********************************************
* 메뉴 : 
* 화면 : 복사건수 입력 
* 기능 : 복사건수 입력 팝업
* 프로그램 ID : 
* 담당자 : 홍석규
* 착수일 : 2014-06-12
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
	$("#st_change_reason").focus();
    return;
}

function setSave()
{ 	
	var value = $("#st_change_reason").val();
    if(TrimCommon(value)=="" || TrimCommon(value)==null) {
        alert("변경사유를 입력해 주십시요");
        $("#st_change_reason").focus();
        return;
    }

    var specLen	= kepGetByteLength('st_change_reason');
	if ( specLen > 400 )
	{
		alert("현재 입력된 변경사유는 "+specLen+"바이트 입니다.\n변경사유는 400바이트 이상 입력할 수 없습니다.");
		return ;
	}
    
    if(value != ""){
    	opener.focus();
        opener.setPopupReturn(value);
    }
    this.close();
	return;
}

 //-->
</script> 
<body onload="popupOnload();">
<form name="masterMdCmCopyCountPop" id="masterMdCmCopyCountPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:400px;">
    	<div id="popHeader">
        	<h1 class="title">변경사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>변경사유</caption>
						<colgroup>
							<col width="100%" />
						</colgroup>						
						<tbody>
						<tr>
							<td>
								<textarea id="st_change_reason" name="st_change_reason" cols="73" rows="10"></textarea>
							</td>					 
						</tr>
						<tr>
							<td  class="right">
								<span class="btn_search"><a href="javascript:setSave();">확인</a></span> 
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
