<%--
**********************************************
* 메뉴 : 
* 화면 : 납품지연현황화면 내 납품지연 사유
* 기능 : 납품지연사유를 입력하는 화면
* 프로그램 ID : 
* 담당자 : 개발1 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
 

<script language="javascript">

function init(){
	
	var reason = opener.getReason();
	
	$("#st_delay_reason_txt").val(reason);
}

//지연사유 저장
function setSave(flag){		// flag ==> 해당품목(one) 또는 모든품목(all)
	 
	var value = $.trim($("#st_delay_reason_txt").val());
	
	var maxBytes = 400;
	
	if(kepGetByteLength("st_delay_reason_txt") > maxBytes){	
		alert("영문 "+ maxBytes+"자, 한글 " + parseInt(maxBytes/2) + "자 까지 입력할수 있습니다.");
		return;
	}
	
	if(isEmpty(value)) {
		alert("납품지연 사유를 입력하여 주시길 바랍니다.");
		$("#st_delay_reason_txt").focus();
		return;
	}

	if(!confirm("지연사유를 저장 하시겠습니까?")){
		return;
	}
	
	opener.setReason(value, flag);	
	window.close();
}

</script> 
</head>
<body onLoad="javascript:init();">
<form name="contentForm" id="contentForm" method=post >

<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div id="popWrapper" style="height:404px;">
   	<div id="popHeader">
		<h1 class="title">납품지연 사유</h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
	</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
            <!--조회영역-->
            <div>
            	<table style="width:100%;margin-top:10px;">
					<tr>
						<td>
							<textarea id="st_delay_reason_txt" cols="85" rows="16"></textarea>
						</td>
					</tr>
					<tr height="40px">
						<td></td>
					</tr>
					<tr>
						<td style="text-align:center;" colspan="3">
			            	<span class="btn_10"><a href="javascript:setSave('one');">해당품목만 적용</a></span>
			            	<span class="btn_10"><a href="javascript:setSave('all');">해당 납품예정일 적용</a></span>
	            		</td>
	            	</tr>
				</table>
            </div>
        </div>
    </div>        
</div>
</form> 
</body>
</html>
