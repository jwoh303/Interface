<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%> 
<!doctype html>
<html>
<head>
<%@include file="../common/include/head.jspf" %>
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>  
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 

</head>
<body>
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!--내용 시작-->		
<!--내용 시작-->	
<!--내용 시작-->	
<div id="ContArea">
        	<h3>유효성검증 화면</h3>
				<table border="1">
					<tr>
						<td>null 여부 : <input type="text" class="input_type_text" name="valid1" id="valid1"  style="width:50px"><a href="#" onclick="alert(kepIsNull('valid1'))">KepIsNull</a></td>
						<td>빈칸포함 null 여부 : <input type="text" class="input_type_text" name="valid2" id="valid2"  style="width:50px"><a href="#" onclick="alert(kepIsEmpty('valid2'))">KepIsEmpty</a></td>
						<td>알파벳 여부 : <input type="text" class="input_type_text" name="valid3" id="valid3"  style="width:50px"><a href="#" onclick="alert(kepIsAlphabet('valid3'))">KepIsAlphabet</a></td>
						<td>알파벳 대문자 여부 : <input type="text" class="input_type_text" name="valid4" id="valid4"  style="width:50px"><a href="#" onclick="alert(kepIsUpperCase('valid4'))">KepIsUpperCase</a></td>
						<td>한글만 여부 : <input type="text" class="input_type_text" name="valid40" id="valid40"  style="width:50px"><a href="#" onclick="alert(kepIsHangu('valid40'))">KepIsHangu</a></td>
					</tr>
					<tr>
						<td>대문자로 변경 : <input type="text" class="input_type_text" name="valid41" id="valid41"  style="width:50px"><a href="#" onclick="alert(kepToUpper('valid41'))">KepToUpper</a></td>
						<td>소문자로 변경 : <input type="text" class="input_type_text" name="valid42" id="valid42"  style="width:50px"><a href="#" onclick="alert(kepToLower('valid42'))">KepToLower</a></td> 
						<td>공백제거 : <input type="text" class="input_type_text" name="valid43" id="valid43"  style="width:50px"><a href="#" onclick="alert(kepTrim('valid43'))">kepTrim</a></td>
						<td>문자교체 : <input type="text" class="input_type_text" name="valid44" id="valid44"  style="width:50px"><a href="#" onclick="alert(kepReplaceAll('valid44','\\/',''))">KepReplaceAll</a></td>
						<td></td>
					</tr>					
					<tr>
						<td>알파벳 소문자 여부 : <input type="text" class="input_type_text" name="valid5" id="valid5"  style="width:50px"><a href="#" onclick="alert(kepIsLowerCase('valid5'))">KepIsLowerCase</a></td>
						<td>숫자만 여부 : <input type="text" class="input_type_text" name="valid6" id="valid6"  style="width:50px"><a href="#" onclick="alert(kepIsNumber('valid6'))">KepIsNumber</a></td>
						<td>알파벳,숫자 여부 : <input type="text" class="input_type_text" name="valid7" id="valid7"  style="width:50px"><a href="#" onclick="alert(kepIsAlphaNum('valid7'))">KepIsAlphaNum</a></td>
						<td>숫자,대시(-) 여부 : <input type="text" class="input_type_text" name="valid8" id="valid8"  style="width:50px"><a href="#" onclick="alert(kepIsNumDash('valid8'))">KepIsNumDash</a></td>
						<td>특수문자 여부 :<input type="text" class="input_type_text" name="valid80" id="valid80"  style="width:50px"><a href="#" onclick="alert(kepIsSpecialChar('valid80'))">KepIsSpecialChar</a></td>
					</tr>					
					<tr>
						<td>숫자,콤마(,) 여부 : <input type="text" class="input_type_text" name="valid9" id="valid9"  style="width:50px"><a href="#" onclick="alert(kepIsNumChk('valid9',1))">KepIsNumChk</a></td>
						<td>숫자,점(.) 여부 : <input type="text" class="input_type_text" name="valid90" id="valid90"  style="width:50px"><a href="#" onclick="alert(kepIsNumChk('valid90',2))">KepIsNumChk</a></td>
						<td>숫자,콤마(,),점(.) 여부 : <input type="text" class="input_type_text" name="valid900" id="valid900"  style="width:50px"><a href="#" onclick="alert(kepIsNumChk('valid900',3))">KepIsNumChk</a></td>
						<td>소수점(음수포함) : <input type="text" class="input_type_text" name="valid91" id="valid91"  style="width:50px"><a href="#" onclick="alert(kepIsDouble('valid91'))">KepIsDouble</a></td>
						<td>소수점(음수비포함) : <input type="text" class="input_type_text" name="valid92" id="valid92"  style="width:50px"><a href="#" onclick="alert(kepIsDoublePlus('valid92'))">KepIsDoublePlus</a></td> 
					</tr>			
					<tr>
						<td>소수점 자리수 2자리 : <input type="text" class="input_type_text" name="valid93" id="valid93"  style="width:50px"><a href="#" onclick="alert(kepCheckDecimals('valid93',2))">KepCheckDecimals</a></td>
						<td>소수점 자리수 3자리 : <input type="text" class="input_type_text" name="valid94" id="valid94"  style="width:50px"><a href="#" onclick="alert(kepCheckDecimals('valid94',3))">KepCheckDecimals</a></td>
						<td>소수점 자리수 4자리 : <input type="text" class="input_type_text" name="valid95" id="valid95"  style="width:50px"><a href="#" onclick="alert(kepCheckDecimals('valid95',4))">KepCheckDecimals</a></td>
						<td>문자열 자르고 대체하기 : <input type="text" class="input_type_text" name="valid96" id="valid96"  style="width:50px"><a href="#" onclick="alert(kepCutStr('valid96',3,'.'))">KepCutStr</a></td>
						<td></td>
					</tr>		
					<tr> 
						<td>이메일 : <input type="text" class="input_type_text" name="valid10" id="valid10"  style="width:50px"><a href="#" onclick="alert(kepIsValidEmail('valid10'))">KepIsValidEmail</a></td>
						<td>URL : ex) http: <input type="text" class="input_type_text" name="valid101" id="valid101"  style="width:50px"><a href="#" onclick="alert(kepIsValidUrl('valid101'))">KepIsValidUrl</a></td>
						<td>전화번호 여부 ex) 000-000-000 : <input type="text" class="input_type_text" name="valid11" id="valid11"  style="width:100px"><a href="#" onclick="alert(kepIisValidPhone('valid11'))">KepIisValidPhone</a></td> 						
						<td>숫자 1000단위 콤마 <input type="text" class="input_type_text" name="valid111" id="valid111"  style="width:50px"><a href="#" onclick="alert(kepNumComma('valid111'))">KepNumComma</a></td>
						<td>날짜 여부 ex)2011-01-01 : <input type="text" class="input_type_text" name="valid112" id="valid112"  style="width:100px"><a href="#" onclick="alert(KepIsDate('valid112'))">KepIsDate</a></td> 
					</tr>			
					<tr>
						<td>입력값의 바이트 길이 : <input type="text" class="input_type_text" name="valid12" id="valid12"  style="width:50px"><a href="#" onclick="alert(kepGetByteLength('valid12'))">KepGetByteLength</a></td>
						<td>콤마 제거 : <input type="text" class="input_type_text" name="valid13" id="valid13"  style="width:50px"><a href="#" onclick="kepRemoveUnNum('valid13',1)">KepRemoveUnNum</a></td>
						<td>점 제거 : <input type="text" class="input_type_text" name="valid14" id="valid14"  style="width:50px"><a href="#" onclick="kepRemoveUnNum('valid14',2)">KepRemoveUnNum</a></td>
						<td>콤마+점 제거 : <input type="text" class="input_type_text" name="valid15" id="valid15"  style="width:50px"><a href="#" onclick="kepRemoveUnNum('valid15',3)">KepRemoveUnNum</a></td>
						<td>script 제거 : <input type="text" class="input_type_text" name="valid16" id="valid16"  style="width:50px"><a href="#" onclick="kepRemoveTag('valid16')">KepRemoveTag</a></td>
					</tr>		
					<tr>
						<td colspan="5">날짜 차이 : <input type="text" class="input_type_text" name="valid20" id="valid20"  style="width:100px" value="2014/01/01">
						<a href="javascript:kepCalendar('valid20')">달력테스트</a>
						-
						<input type="text" class="input_type_text" name="valid21" id="valid21"  style="width:100px" value="2014/02/01">
						<a href="javascript:kepCalendar('valid21')">달력테스트</a>
						
						<a href="#" onclick="alert(kepGetDateDiff('valid20','valid21','D'))">날짜kepGetDateDiff</a>
						&nbsp;<a href="#" onclick="alert(kepGetDateDiff('valid20','valid21','M'))">개월kepGetDateDiff</a>
						</td>
					</tr>		
					<tr>
						<td colspan="5">날짜 계산 : <input type="text" class="input_type_text" name="valid22" id="valid22"  style="width:100px" value="2014/01/01"> 
						<a href="javascript:kepCalendar('valid22')">달력테스트</a>
						
						&nbsp;	<a href="#" onclick="alert(kepDateAdd('valid22','1','M'))">날짜 하루 기kepDateAdd</a>
						&nbsp;	<a href="#" onclick="alert(kepDateAdd('valid22','1','P'))">날짜 하루 더하기kepDateAdd</a> 
						</td>
					</tr>	
					<tr>
						<td colspan="5"><a href="#" onclick="alert(kepGetNowTimeStr('YYYYMMDD','/'))">오늘 날짜kepGetNowTimeStr</a> 
						&nbsp;	<a href="#" onclick="alert(kepToDateAdd('1','M'))">날짜 하루기kepToDateAdd</a>
						&nbsp;	<a href="#" onclick="alert(kepToDateAdd('1','P'))">날짜 하루 더하기kepToDateAdd</a> 
						</td>
					</tr>			
					<tr>
						<td colspan="5"><a href="#" onclick="alert(kepGetNowTimeStr('YYYYMMDD','/'))">오늘 날짜kepGetNowTimeStr</a> 
						&nbsp;	<a href="#" onclick="alert(kepToMonthAdd('1','M'))">날짜 한달기kepToMonthAdd</a>
						&nbsp;	<a href="#" onclick="alert(kepToMonthAdd('1','P'))">날짜 한달 더하기kepToMonthAdd</a> 
						</td>
					</tr>														
					<tr>
						<td colspan="5">라디오필수 : <input type="radio" name="rtest"  id="rtest" value="1">1<input type="radio" name="rtest" id="rtest" value="2">2
						<input type="radio" name="rtest" id="rtest" value="3">3<input type="radio" name="rtest" id="rtest"  value="4">4
						&nbsp;<a href="#" onclick="alert(kepRadioValid('rtest'))">KepRadioValid</a>
						&nbsp;<a href="#" onclick="alert(kepRadioSelectVal('rtest'))">KepRadioSelectVal</a>
						</td>
					</tr>		
					<tr>
						<td colspan="5">select 필수 : 
						<select name="rselect" id="rselect">
						<option value=""> </option>
						<option value="1">1테스트</option>
						<option value="2">2테스트</option>
						<option value="3">3테스트</option>
						<option value="4">4테스트</option>
						</select>
						&nbsp;<a href="#" onclick="alert(kepSelectValid('rselect'))">KepSelectValid</a>
						&nbsp;<a href="#" onclick="alert(kepSelectOptionVal('rselect'))">KepSelectOptionVal</a>
						&nbsp;<a href="#" onclick="alert(kepSelectOptionText('rselect'))">KepSelectOptionText</a></td>
					</tr>					
					<tr>
						<td colspan="5">checkbox :
						<input type="checkbox" name="ctest" id="ctest"  value="1">&nbsp;
						<input type="checkbox" name="ctest" id="ctest"  value="2">&nbsp;
						<input type="checkbox" name="ctest" id="ctest"  value="3">&nbsp;
						&nbsp;<a href="#" onclick="alert(kepCheckedCnt('ctest'))">KepCheckedCnt</a> 
						&nbsp;<a href="#" onclick="alert(kepCheckedVal('ctest'))">KepCheckedVal</a>
					</tr>							
					<tr>
						<td colspan="5">주민번호 ex) XXXXXX-XXXXXXX : <input type="text" class="input_type_text" name="jumin1" id="jumin1"  style="width:70px">-<input type="text" class="input_type_text" name="jumin2" id="jumin2"  style="width:70px">
						&nbsp;	<a href="#" onclick="alert(kepJuminCheck('jumin1','jumin2'))">KepJuminCheck</a> 
						</td>
					</tr>	
					<tr>
						<td colspan="5">사업자번호 ex)XXX-XX-XXXXX  : <input type="text" class="input_type_text" name="bizno" id="bizno"  style="width:100px">
						&nbsp;	<a href="#" onclick="alert(KepBizNoCheck('bizno'))">KepBizNoCheck</a> 
						</td>
					</tr>	
					<tr>
						<td colspan="5">메시지 :  <input type="text" class="input_type_text" name="msg1" id="msg1"  style="width:100px" value="메시지"> <a href="#" onclick="alert(KepAlert('msg1'))">KepAlert</a> 
						&nbsp;<a href="#" onclick="alert(KepConfirm('msg1'))">KepConfirm</a> 
						</td>
					</tr>	
				</table> 
</div>	
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<script type="text/javascript">

	var viewid = "";
 
	$(function() {
		kepSetCalender("valid20"); // 초기 시작하자마 해당 ID에 달력세팅
		kepSetCalender("valid21"); // 초기 시작하자마 해당 ID에 달력세팅
		kepSetCalender("valid22"); // 초기 시작하자마 해당 ID에 달력세팅
	});

	// 달력 팝업을 호출
	function kepCalendar(id){
		viewid = id;
		openSearchPopup('/common/calendarPop.do');
	}
	
	// 해당 호출된 달력에 값 세팅 178줄 참조
	function setPopupCalendar(value){
		$("#"+viewid).val(value);
	}
 
</script>
</html>
