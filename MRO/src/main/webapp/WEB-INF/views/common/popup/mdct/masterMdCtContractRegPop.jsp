<%--
**********************************************
* 메뉴 : 회원사관리>계약관리>계약대상조회  
* 화면 : 표준계약서 조회 상세 
* 기능 : 계약서 작성위한 표준계약서 상세정보 조회
* 프로그램 ID : PG_02_M_002_02
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-31
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _rowData = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 

String st_cont_no = CommonUtil.nvl((String) request.getParameter("st_cont_no"),"cont_no");  //  (조회조건)
String st_cont_count = CommonUtil.nvl((String) request.getParameter("st_cont_count"),"");  //  (조회조건)
String st_form_no = CommonUtil.nvl((String) request.getParameter("st_form_no"),"");  //  (조회조건)
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
String st_company_type = CommonUtil.nvl((String) request.getParameter("st_company_type"),"");  //  (조회조건)
String st_biz_type = CommonUtil.nvl((String) request.getParameter("st_biz_type"),"");  //  (조회조건)
String st_cont_chg_type = CommonUtil.nvl((String) request.getParameter("st_cont_chg_type"),"C");  //  (조회조건)
%>

<script type="text/javascript">
<!--
var inputData = "";

function kep_onload_view() {
	<% if (_rowData != null) { %>
	$("input[name='dateInput001']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT001"))%>");		//계약시작년
	$("input[name='dateInput002']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT002"))%>");		//계약시작월
	$("input[name='dateInput003']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT003"))%>");		//계약시작일
	$("input[name='dateInput004']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT004"))%>");		//계약종료년
	$("input[name='dateInput005']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT005"))%>");		//계약종료월
	$("input[name='dateInput006']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT006"))%>");		//계약종료일
	$("input[name='dateInput007']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT007"))%>");		//계약년도
	$("input[name='dateInput008']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT008"))%>");		//계약월
	$("input[name='dateInput009']").val("<%=CommonUtil.nvl(_rowData.get("DATAINPUT009"))%>");		//계약일
	$("input[name='textInput101']").val("<%=CommonUtil.nvl(_rowData.get("TEXTINPUT101"))%>");			//업체주소
	$("input[name='textInput102']").eq(0).val("<%=CommonUtil.nvl(_rowData.get("TEXTINPUT102"))%>");	//업체명
	$("input[name='textInput102']").eq(1).val("<%=CommonUtil.nvl(_rowData.get("TEXTINPUT102"))%>");	//업체명
	$("input[name='textInput103']").val("<%=CommonUtil.nvl(_rowData.get("TEXTINPUT103"))%>");			//업체대표명
	<% } %>
}

function doAction(str) {
	switch (str) {
		case "save":	 // 조회
			if (checkSubmit()) {
				kepAjaxFormCall("/mdct/saveMasterMdCtContractRegPop.do","masterMdCtContractRegPop", str);
			}
			break;
	}		
}
function kepSearch()
{  
  $('#masterMdCtContractRegPop').attr("action", "/mdct/getMasterMdCtContractRegPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("계약서가 정상적으로 작성되었습니다..");
            opener.setPopupReturn();
        	this.close();
		} else if (msg == "ERR") {
			alert("계약서 작성에 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		} else {
			alert(msg);
			return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

function setReturn(value1,value2) { 
	opener.setPopupReturn(value1,value2);
	this.close();
}

function checkSubmit() {
  	var oriContent = document.getElementById("formContent").innerHTML;
  	$("#st_oriContent").val(oriContent);
  	
	if (kepTrimStr($("#st_contract_name").val()) == "") {
  		alert("계약명을 입력하십시오.");
  		return false;
  	}
	
	
	
	if ($("input[name='dateInput001']").val() != "undefined") {
		if (isNaN($("input[name='dateInput001']").val())) {
  			alert("계약 시작년도는 숫자만 입력 가능합니다.");
  			$("input[name='dateInput001']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput002']").val() != "undefined") {
		if (isNaN($("input[name='dateInput002']").val())) {
  			alert("계약 시작월은 숫자만 입력 가능합니다.");
  			$("input[name='dateInput002']").focus();
  			return false;
  		}
		
		if ($("input[name='dateInput002']").val().length < 2) {
  			alert("계약 시작월 숫자 2자리를 입력하여 주세요.\n(예) 01,02,12");
  			$("input[name='dateInput002']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput003']").val() != "undefined") {
		if (isNaN($("input[name='dateInput003']").val())) {
  			alert("계약 시작일은 숫자만 입력 가능합니다.");
  			$("input[name='dateInput003']").focus();
  			return false;
  		}
		
		if ($("input[name='dateInput003']").val().length < 2) {
  			alert("계약 시작일 숫자 2자리를 입력하여 주세요.\n(예) 01,02,12");
  			$("input[name='dateInput003']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput001']").val() != "undefined" && $("input[name='dateInput002']").val() != "undefined" && $("input[name='dateInput003']").val() != "undefined") {
		var startDate = $("input[name='dateInput001']").val()+$("input[name='dateInput002']").val()+$("input[name='dateInput003']").val();
		if (!checkDate(startDate)) {
			alert("계약 시작날짜가 유효하지 않습니다.");
			$("input[name='dateInput003']").focus();
  			return false;
		}
		
		$("#st_start_date").val(startDate);
	}
	
	if ($("input[name='dateInput004']").val() != "undefined") {
		if (isNaN($("input[name='dateInput004']").val())) {
  			alert("계약 종료년도는 숫자만 입력 가능합니다.");
  			$("input[name='dateInput004']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput005']").val() != "undefined") {
		if (isNaN($("input[name='dateInput005']").val())) {
  			alert("계약 종료월은 숫자만 입력 가능합니다.");
  			$("input[name='dateInput005']").focus();
  			return false;
  		}
		
		if ($("input[name='dateInput005']").val().length < 2) {
  			alert("계약 종료월 숫자 2자리를 입력하여 주세요.\n(예) 01,02,12");
  			$("input[name='dateInput005']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput006']").val() != "undefined") {
		if (isNaN($("input[name='dateInput006']").val())) {
  			alert("계약 종료일은 숫자만 입력 가능합니다.");
  			$("input[name='dateInput006']").focus();
  			return false;
  		}
		
		if ($("input[name='dateInput006']").val().length < 2) {
  			alert("계약 종료일 숫자 2자리를 입력하여 주세요.\n(예) 01,02,12");
  			$("input[name='dateInput006']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput004']").val() != "undefined" && $("input[name='dateInput005']").val() != "undefined" && $("input[name='dateInput006']").val() != "undefined") {
		var endDate = $("input[name='dateInput004']").val()+$("input[name='dateInput005']").val()+$("input[name='dateInput006']").val();
		if (!checkDate(endDate)) {
			alert("계약 종료날짜가 유효하지 않습니다.");
			$("input[name='dateInput006']").focus();
  			return false;
		}
		
		$("#st_end_date").val(endDate);
	}
	
	if ($("input[name='dateInput007']").val() != "undefined") {
		if (isNaN($("input[name='dateInput004']").val())) {
  			alert("계약년도는 숫자만 입력 가능합니다.");
  			$("input[name='dateInput007']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput008']").val() != "undefined") {
		if (isNaN($("input[name='dateInput008']").val())) {
  			alert("계약월은 숫자만 입력 가능합니다.");
  			$("input[name='dateInput008']").focus();
  			return false;
  		}
		
		if ($("input[name='dateInput008']").val().length < 2) {
  			alert("계약월 숫자 2자리를 입력하여 주세요.\n(예) 01,02,12");
  			$("input[name='dateInput008']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput009']").val() != "undefined") {
		if (isNaN($("input[name='dateInput009']").val())) {
  			alert("계약일은 숫자만 입력 가능합니다.");
  			$("input[name='dateInput009']").focus();
  			return false;
  		}
		
		if ($("input[name='dateInput009']").val().length < 2) {
  			alert("계약일 숫자 2자리를 입력하여 주세요.\n(예) 01,02,12");
  			$("input[name='dateInput009']").focus();
  			return false;
  		}
  	}
	
	if ($("input[name='dateInput007']").val() != "undefined" && $("input[name='dateInput008']").val() != "undefined" && $("input[name='dateInput009']").val() != "undefined") {
		var contDate = $("input[name='dateInput007']").val()+$("input[name='dateInput008']").val()+$("input[name='dateInput009']").val();
		if (!checkDate(contDate)) {
			alert("계약날짜가 유효하지 않습니다.");
			$("input[name='dateInput009']").focus();
  			return false;
		}
		
		$("#st_cont_date").val(contDate);
	}
	
	if (!formValidate(document.forms.masterMdCtContractRegPop)) {
  		return false;
	}
	
	$("#st_inputData").val(inputData);
	
	return confirm("계약서를 저장하시겠습니까?");
}

function formValidate(form) {
  	var obj;
  	inputData = "";
  	
  	for (var i = 0; i < form.elements.length; i++) {
  		obj = form.elements(i);
  		if(null == obj.value || obj.title == obj.value || obj.value == "") {

  			alert("입력되지 않은 항목이 있습니다.");
			alert(obj.name);
  			obj.focus();
  			return false;
  		} else {
  			inputData += obj.name + "^" + obj.value;
  			if(i != form.elements.length-1) {
  				inputData += "|";	
  			}
  		} 
  	}
  	return true;
  }
  
 //-->
</script> 
<body onload="kep_onload_view();">
<form name="masterMdCtContractRegPop" id="masterMdCtContractRegPop" method=post >
<input type="hidden" id="st_cont_no" name="st_cont_no" value="<%=st_cont_no %>" />
<input type="hidden" id="st_form_no" name="st_form_no" value="<%=st_form_no %>" />
<input type="hidden" id="st_com_code" name="st_com_code" value="<%=st_com_code %>" />
<input type="hidden" id="st_company_type" name="st_company_type" value="<%=st_company_type%>" />
<input type="hidden" id="st_biz_type" name="st_biz_type" value="<%=st_biz_type%>" />
<input type="hidden" id="st_cont_chg_type" name="st_cont_chg_type" value="<%=st_cont_chg_type%>" />
<input type="hidden" id="st_start_date" name="st_start_date" value="" />
<input type="hidden" id="st_end_date" name="st_end_date" value="" />
<input type="hidden" id="st_cont_date" name="st_cont_date" value="" />
<input type='hidden' id='st_inputData' name='st_inputData' value='inputData' />
<input type='hidden' id='st_oriContent' name='st_oriContent' value='' />


	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
    	<div id="popHeader">
        	<h1 class="title">계약서 작성 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="contArea" style="height:624px">
                <% if (_rowData != null) {  %>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>표준계약서 조회 상세</caption>
	                <colgroup>
	                    <col width="20%" />
	                    <col width="*" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">계약명</th>
	                        <td>
	                        	<input type="hidden" id="st_com_name" name="st_com_name" value="<%=CommonUtil.nvl(_rowData.get("TEXTINPUT102"))%>" />
	                        	<input type="hidden" id="st_cont_type" name="st_cont_type" value="<%=CommonUtil.nvl(_rowData.get("CONT_TYPE"))%>" />
	                        	<input type="text" class="input_type_text" name="st_contract_name" id="st_contract_name" style="width:71%" value="물품공급 계약서 (<%=CommonUtil.nvl(_rowData.get("TEXTINPUT102"))%>)"  />
	                        </td>
						</tr>
					</tbody>
				</table>
				<div id="formContent" class="scrollArea" style="text-align:left; height:525px; padding:6px;"><%=CommonUtil.nvl(_rowData.get("FORM_CONTENT"))%></div>
				<% } %>	
				<!--버튼영역-->
				<div class="btnArea mt10 mb05">
					<span class="fl">
						<span class="btn_04 mr04"><a href="javascript:doAction('save'); ">계약서 저장</a></span>
					</span>	
				</div>	                
        </div>
    </div>        
</div>
</form> 
</body>
</html>
