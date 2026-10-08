<%@page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@page import="com.samsung.bqms.common.util.CCrypt"%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<link rel="stylesheet" href="/resources/styles/externVoc.css">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>

<!DOCTYPE html>

<html>
<head>
<meta charset="utf-8">
<title>고객센터 문의하기</title>
</head>
<script src="/resources/js/common.js"></script>
<%
String buyer	= CommonUtil.nvl(request.getParameter("st_buyer"),"KRSAMS0123");
String user_name	= CommonUtil.nvl(request.getParameter("st_user_name"),"");
String user_email	= CommonUtil.nvl(request.getParameter("st_user_email"),"");
String user_telno	= CommonUtil.nvl(request.getParameter("st_user_telno"),"");
String legacy_po_no	= CommonUtil.nvl(request.getParameter("st_legacy_po_no"),"");
String buyer_item_no	= CommonUtil.nvl(request.getParameter("st_buyer_item_no"),"");

String decEmail	= user_email;
if (user_email.indexOf("@") < 0) {
	try {
		String desStr	= CCrypt.decrypt(user_email);
		decEmail = desStr;
	} catch (Exception e) {
		e.printStackTrace();
	}
}

%>

<script type="text/javascript">

function changeSelect() {
	var obj	= document.getElementById("st_voc_type");
	
	for( i = 0 ; i < obj.options.length ; i++ ) {
		
		if(obj.options[i].selected == true) {
			var idx = obj.options[i].value;
			changeMandatory(idx);
		}
	}
}

function changeMandatory(type) {

	var buyer_item_no	= document.getElementById("ft_buyer_item_no");
	var legacy_po_no	= document.getElementById("ft_legacy_po_no");
	
	if (type == "ZO") {
		buyer_item_no.color	= "red";
		legacy_po_no.color	= "red";
	} else if (type == "ZA" || type == "ZP") {
		buyer_item_no.color	= "red";
		legacy_po_no.color	= "black";
	} else {
		buyer_item_no.color	= "black";
		legacy_po_no.color	= "black";
	}
}

function doAction(str) {
	
	switch (str) {
		case "save":	// 등록
			saveVoc();
			break;
			
		case "cancel":	// 취소
			window.close();
	}
}

function saveVoc() {

	var query   = "";
	
	/**
	 * Check List
	 * 1. Name
	 * 2. Voc Type
	 * 3. E-mail
	 * 4. Case 주문 - 코드/발주번호
	 * 5. Case 품목, 가격 - 코드
	 * 6. Content 입력 확인.
	 */
	 
	var user_name	= document.forms[0].st_user_name.value.trim();
	var voc_type	= document.forms[0].st_voc_type.value;
	var user_email	= document.forms[0].st_user_email.value;
	var user_telno	= document.forms[0].st_user_telno.value;
	var buyer_item_no	= document.forms[0].st_buyer_item_no.value;
	var legacy_po_no	= document.forms[0].st_legacy_po_no.value;
	var req_remark	= document.forms[0].st_req_remark.value;
	
	if (user_name == "") {
		alert("이름은 필수 입력항목입니다.");
		document.forms[0].st_user_name.focus();
		return;
	}
	
	if (voc_type == 0) {
		alert("VOC유형을 선택바랍니다.");
		document.forms[0].st_voc_type.focus();
		return;
	}
	
	if (voc_type == 1) {
		if (buyer_item_no == "") {
			alert("BQMS코드를 입력바랍니다.");
			document.forms[0].st_buyer_item_no.focus();
			return;
		}
		if (legacy_po_no == "") {
			alert("발주번호를 입력바랍니다.");
			document.forms[0].st_legacy_po_no.focus();
			return;
		}
		
	} else if (voc_type == 2 || voc_type == 3) {
		if (buyer_item_no == "") {
			alert("BQMS코드를 입력바랍니다.");
			document.forms[0].st_buyer_item_no.focus();
			return;
		}
	}
	
	var len_remark	= kepGetByteLength("st_req_remark");
	if ( len_remark > 1000 || len_remark <= 0 ) {
		alert("내용에 입력한 길이를 확인 바랍니다.");
		document.forms[0].st_req_remark.focus();
		return;
	}
	
	if (confirm("등록하시겠습니까?")) {
		kepAjaxFormCall("/extern/saveExternVocWrite.do","processForm","save");
	}
}

function checkRemarkLength() {
	document.getElementById("st_req_remark_len").value	= kepGetByteLength("st_req_remark");
}


function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "save") {
		if (sMsg == "OK") {
			alert("정상적으로 VOC가 등록 되었습니다.");
			opener.rtnCall();
			return;
		} else {
			alert("VOC 등록 처리하던중 오류가 발생하였습니다.");
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("VOC 등록 처리하던중 오류가 발생하였습니다.");
} 

</script>

<body>

<!--개인정보동의 팝업 추가-->
<div id="InfoAgree">
	<h1>개인정보 수집 및 활용 동의서 <img src="/resources/images/voc/info.png" /></h1>
	<div>
        코리아이플랫폼은 귀하의 개인정보를 중요시 하며, '개인정보보호법'을 준수하고 있습니다.<br />
        * 개인정보의 수집 및 이용 목적 : VOC 요청자 정보 입력<br />
        * 수집하는 개인정보 항목 : 사번 / 이름 / 연락처 / 이메일<br />
        * 개인정보의 보유 및 이용기간 : 2019년 12월 31일까지<br /> 
        * 개인정보 제공 동의 거부 권리 및 동의 거부에 따른 불이익 또는 제한 : 개인정보 제공 동의를 거부할 권리가 있으며, 동의를 거부할 경우 VOC 지원 신청을 할 수 없음.<br />
        * 미동의 선택 시 신청한 개인정보는 즉시 폐기함. 
    </div>
    <div>
		<h2>개인정보 수집 동의 여부 *</h2> <br /><br />
        동의 <input name="st_checkY" type="checkbox" value="Y" onchange="javascript:checkY(this);">  &nbsp; &nbsp; &nbsp; &nbsp; 미동의  <input name="st_checkN" type="checkbox" value="N" onchange="javascript:checkN(this);">
    </div>
	<a href="javascript:closeWin();"><div>확 인</div></a>
</div>

<script language="Javascript"> 
function closeWin() {
	
	var bCheckY	= document.all['st_checkY'].checked;
	var bCheckN	= document.all['st_checkN'].checked;
	
	if( false == bCheckY && false == bCheckN ) {
		alert("개인정보 동의여부를 선택해 주시기 바랍니다.");
		return;
	}
	else {
		if (false == bCheckY && true == bCheckN) {
			window.close();
		} else if (true == bCheckY && false == bCheckN) {
			document.all['InfoAgree'].style.visibility = "hidden";
		}
	}
} 
cookiedata = document.cookie;    
if ( cookiedata.indexOf("maindiv=done") < 0 ){document.all['InfoAgree'].style.visibility = "visible"; } 
else { document.all['InfoAgree'].style.visibility = "hidden"; }
</script>
<script language="Javascript">
function checkY(obj) {
	var bCheck = obj.checked;
	
	if (true == bCheck) {
		document.all['st_checkN'].checked = false;
	}
}
function checkN(obj) {
	var bCheck = obj.checked;
	
	if (true == bCheck) {
		document.all['st_checkY'].checked = false;
	}
}
</script>

<!--개인정보동의 팝업 추가 끝-->

<form name="processForm" id="processForm" method="post">

	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=buyer%>"/>
	<input type="hidden" name="st_user_email" id="st_user_email" value="<%=user_email %>" >
	
<div class="wrap" >
	<div class="voc_wirt">
        <div class="voc_wirt_tit">고객센터 문의하기</div>
        <table class="voc_wirt_table">
            <colgroup>
                <col width="15%" />
                <col width="35%" />
                <col width="15%" />
                <col width="35%" />
            </colgroup>
            <tr>
                <th><font color="red">이름</font></th>
                <td><input name="st_user_name" id="st_user_name" type="text"  title="이름" value="<%=user_name %>" ></td>
                <th><font color="red">VOC유형</font></th>
                <td><select name="st_voc_type" id="st_voc_type" onchange="javascript:changeSelect()">
                    <option value="" selected>선택</option>
                    <option value="ZO">주문</option>
                    <option value="ZA">품목</option>
                    <option value="ZP">가격</option>
                    <option value="ZE">기타의견</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th><font color="red">이메일</font></th>
                <td><%=decEmail%></td>
                <th>연락처</th>
                <td>
                	<input name="st_user_telno" id="st_user_telno" type="text"  title="연락처" value="<%=user_telno %>">
                </td>
            </tr>
            <tr>
                <th><font id="ft_buyer_item_no" color="">BQMS코드</font></th>
                <td><input name="st_buyer_item_no" id="st_buyer_item_no" type="text"  title="BQMS코드" value="<%=buyer_item_no%>" ></td>
                <th><font id="ft_legacy_po_no" color="">발주번호</font></th>
                <td><input name="st_legacy_po_no" id="st_legacy_po_no" type="text"  title="발주번호" value="<%=legacy_po_no%>" ></td>
            </tr>
            <tr>
                <th>내용<br>
                <input type="text" id="st_req_remark_len" value="0" style="width:50px;text-align:center;border:0px;background-color:#eee;" tabindex="-1" readonly onclick="javascript:document.getElementById('st_req_remark').focus();" /> <br>/1000
                </th>
                <td colspan="3"><textarea id="st_req_remark" name="st_req_remark" rows="12" onkeyup="javascript:checkRemarkLength();" style="width:97%"></textarea></td>
            </tr>
        </table>
        <div class="voc_wirt_btn" >
            <div>※ 문의하신 내용의 답변은 메일로 전송됩니다.</div>
            <div onclick="javascript:doAction('save');">등록</div>
            <div onclick="javascript:doAction('cancel');">취소</div>
        </div>
	</div>
</div>
</form>
</body>
</html>
