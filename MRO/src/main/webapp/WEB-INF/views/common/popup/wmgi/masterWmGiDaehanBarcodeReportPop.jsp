<%--
**********************************************
* 메뉴 : wms>거래명세서
* 화면 : 거래명세서 중 STX
* 기능 : STX관련사의 거래명세서에서 사용됨
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 2014-10-22
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
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script>
function doAction(str) {
	switch (str) {
		case "print":
			  var legacy_iv_serial = $('#st_legacy_iv_serial').val();
			if($('#st_buyer').val() == "KRSTX-0002" ||$('#st_buyer').val() =="KRSTX-0003" || $('#st_buyer').val() =="KRSTX-0005" ||$('#st_buyer').val() == "KRSTX-0006" ||  $('#st_buyer').val() == "KRSTX-0007"){
				
				if( $(":radio[name='radioBtn']:checked").val() =='0' ){
					window.open("http://kor.enginem.com/servlet/kor.prc.comm.OZPrintServletSingle4MRO?count=2&xml_nm=PRC002M_newM&company_id=KEP&deliv_no="+legacy_iv_serial,"sheetWin1","width=700,height=700,resizable=YES,top=0,left=0");
				}else{
					window.open("http://kor.enginem.com/servlet/kor.prc.comm.OZPrintServletSingle4MRO?count=2&xml_nm=PRC003&company_id=KEP&deliv_no="+legacy_iv_serial,"sheetWin2","width=700,height=700,resizable=YES,top=0,left=0");
				}
			}
			break;
	}
}
</script>
</head>

<body onload="" >
    <input type="hidden" id="st_buyer"  name="st_buyer" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer"),"") %>">
    <input type="hidden" id="st_legacy_iv_serial"  name="st_legacy_iv_serial" value="<%=CommonUtil.nvl((String) request.getParameter("st_legacy_iv_serial"),"") %>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title">거래명세서</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

			<table class="cont_t_list06" >
                <tr> 
					<td><input type="radio" name="radioBtn" value="0" style="border=0px;" checked>발주서</td>
                </tr>
                 <tr> 
					<td><input type="radio" name="radioBtn" value="1" style="border=0px;">납품서</td>
                </tr>
            </table>
                    <!--버튼영역-->
        <div class="btnArea mr25">
        <span class="fl">
        		<span class="btn_02 mr04"><a href="javascript:doAction('print' )">출력</a></span>
        </span>			
			</span>
       </div>	
        </div>
    </div>
</body>
</html>
