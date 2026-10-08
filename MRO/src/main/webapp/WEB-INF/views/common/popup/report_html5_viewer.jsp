<%--
**********************************************
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf" %>
<%
%>
<script type="text/javascript">
 
var popupSel = "";

//최초 화면 함수 
function kep_onload_view(){
}

function ASIS(){
	var rpt =  document.contentForm.st_rpt.value;
	var param =  document.contentForm.st_param.value;
	
	reportOpen(rpt, param);
}

function TOBE(){
	var rpt =  document.contentForm.st_rpt.value;
	var param =  document.contentForm.st_param.value;
	
	param = param.replace(/&/gi, "%26");	//파라메터 값에 & 가 포함되면 파라메터구분자로 인식하여 레포트 데이터가 나오지 않아 치환이 필요하다.
	openSearchPopup("/coco/showReportHtmlViewer.do","?fileName=" + rpt + "&param=" + param,"800,850,no,yes");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	return;
}

</script> 
</head>

<body onload="kep_onload_view()">
<form name = "contentForm" id="contentForm" method = "post">

<!-- HIDDEN -->
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">ActiveX->HTML5</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!-- 거래명세서 작성 상세내용 -->  
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
			    </tr>
			    
			</table>
			
           	<!--grid-->
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list04"  style="width:100%">
                    <caption>HTML5</caption>
                    <colgroup>
                        <col width="50%" /> 
                        <col width="50%" />
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col">리포트파일명</th>
                            <th scope="col">파라미터</th> 
                        </tr>
                        <tr>
                            <td><input type="text"	id="st_rpt"			name="st_rpt"			style="width: 80%;"	value=""></td>
                            <td><input type="text"	id="st_param" 	name="st_param"	style="width: 80%;"	value=""></td>
                        </tr>
                    </thead>
                    <tbody>
  
                    </tbody>
                </table>
				
				<span class="btn_04">
					<a href="javascript:ASIS();">기존RD</a>
				</span> 
				<span class="btn_04">
					<a href="javascript:TOBE();">HTML5</a>
				</span>
                                  
        </div>
        
    </div>        
</div>
</form> 

</body>
</html>
