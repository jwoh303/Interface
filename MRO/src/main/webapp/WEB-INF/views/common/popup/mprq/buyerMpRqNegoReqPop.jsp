<%--
**********************************************
* 메뉴 : 
* 화면 : 네고요청 
* 기능 : 네고요청 등록 팝업
* 프로그램 ID : PG_04_B_004_01
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-08-14
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
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_btoa_nego_price = CommonUtil.nvl((String) request.getParameter("st_btoa_nego_price"),"");  //  (조회조건)
String st_btoa_end_date = CommonUtil.nvl((String) request.getParameter("st_btoa_end_date"),"");  //  (조회조건)
String st_reject_remark = CommonUtil.nvl((String) request.getParameter("st_reject_remark"),"");  //  (조회조건)
st_reject_remark = st_reject_remark.replaceAll("&lt;br&gt;","\n");
%>

<script type="text/javascript">
function kep_onload_view(){
	kepSetCalender("st_btoa_end_date");
	
<%-- 	if ("<%=st_btoa_nego_price%>" != null || "<%=st_btoa_nego_price%>" != ""){ --%>
		$('#st_btoa_nego_price_text').val(kepCommaNum("<%=st_btoa_nego_price%>"));
		$('#st_btoa_end_date').val(kepDateSlashAdd2("<%=st_btoa_end_date%>"));
// 	}
}
function setReturn()
{ 
	var today = kepGetNowTimeStr('YYYYMMDD','');
	var st_btoa_end_date = $.datepicker.formatDate('yymmdd', $("#st_btoa_end_date").datepicker("getDate"));

	if(kepIsValueNull($('#st_btoa_nego_price_text').val())) {
		alert("<%=CommonLang.msg("MSG524")%>");	//Nego 단가(숫자형식)를 입력하여 주십시요.
		$('#st_btoa_nego_price_text').focus();
		return;
	}

	if(!kepIsNumChk('st_btoa_nego_price',2)) {
		
		alert("<%=CommonLang.msg("MSG524")%>");	//Nego 단가(숫자형식)를 입력하여 주십시요.
		$('#st_btoa_nego_price_text').focus();
		return;
	}	
	
	if($('#st_btoa_nego_price').val() <= 0) {
		alert("<%=CommonLang.msg("MSG525")%>");	//Nego 단가를 입력하여 주십시요.
		$('#st_btoa_nego_price_text').focus();
		return;
	}
	
	if(kepIsValueNull($('#st_btoa_end_date').val())) {
		alert("<%=CommonLang.msg("MSG526")%>");	//Nego 회신 요청일을 입력하여 주십시요.
		$('#st_btoa_end_date').focus();
		return;
	}
	
	if (st_btoa_end_date < today){
		alert("<%=CommonLang.msg("MSG527")%>");	//오늘 이후의 날짜를 선택하세요.
		$('#st_btoa_end_date').focus();
		return;
	}
	
	var value1 = $('#st_btoa_nego_price').val();
	var value2 = $.datepicker.formatDate('yymmdd', $("#st_btoa_end_date").datepicker("getDate"));
	var value3 = $('#st_reject_remark').val();
	value3 = value3.replace(/\r?\n/g, '<br>');
	opener.setPopupReturn(value1,value2,value3);
	this.close();
}
function displayNumbering(){
	var btoa_nego_price				= kepFilterNum(kepTrimStr($('#st_btoa_nego_price_text').val()));			// 수량 - 고정
	if(btoa_nego_price!="") {
		$('#st_btoa_nego_price').val(kepTrimStr(btoa_nego_price));
		$('#st_btoa_nego_price_text').val(kepCommaNum(kepTrimStr(btoa_nego_price)));
		
	}
}
</script> 
<body onload="kep_onload_view();">
<form name="buyerMpRqNegoReqPop" id="buyerMpRqNegoReqPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:252px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE905")%><!-- 네고요청 --> </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:177px;">
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>네고요청  리스트</caption>
						<colgroup>
							<col width="40%" />
							<col width="60%" />
						</colgroup>						
						<tbody>
						<tr>
							<th><%=CommonLang.get("HTITLE902")%><!-- Nego 단가 --></th>
							<td> 
								<input type="hidden" name="st_btoa_nego_price" id="st_btoa_nego_price" value="<%=st_btoa_nego_price%>">
								<input type=text name=st_btoa_nego_price_text id="st_btoa_nego_price_text"  style="width:80%" class="input_type_text" value="<%=st_btoa_nego_price%>" onblur="displayNumbering();">
								원 
                            </td>
						</tr>					 
						<tr>
							<th><%=CommonLang.get("HTITLE903")%><!-- Nego회신요청일 --></th>
							<td>
								<input type="text" name="st_btoa_end_date" id="st_btoa_end_date" readOnly style="width:70%; text-align:center;" value="<%=st_btoa_end_date%>">
								<a href="javascript:kepCalendar('st_btoa_end_date')"></a>
                            </td>
						</tr>					 
						<tr>
							<th><%=CommonLang.get("HTITLE904")%><!-- 요청사항 --></th>
							<td> 
								<textarea name="st_reject_remark" id="st_reject_remark" style="width:90%" rows="4"><%=st_reject_remark%></textarea>
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>    
            <div class="btnArea mt10">
            	<span class="btn_04"><a href="javascript:setReturn();"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></a></span>	
            </div>        
    </div>        
</div>
</form> 
</body>
</html>
