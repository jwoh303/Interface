<%--
**********************************************
* 메뉴 : 
* 화면 : 프로젝트 견적 일괄 등록 팝업 
* 기능 : 프로젝트 견적의 조달일수 / 거래유형 / 배송유형 을 선텍된 항목들에 일괄 적용한다.
* 프로그램 ID : 
* 담당자 :  
* 착수일 : 
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
<%@ include file="../../include/head_v2.jspf"  %>

<script type="text/javascript">
var select_all_yn = "N"; // 전체선택_전체해제_flag

function kep_onload_view(){
}

function saveData(){  
	
	var process_type = $("#PROCESS_TYPE").val();
	var parcel_yn = $("#PARCEL_YN").val();
	var delivery_lt = $("#DELIVERY_LT").val();
	
	setReturn(process_type,parcel_yn,delivery_lt);
}

function changeLeadTime(){
	var st_lead_time = $("#DELIVERY_LT").val();
	var new_lead_time = 0;
}	

function setReturn(value1,value2,value3,value4,value5,value6,value7){
	parent.setPopupReturn(value1,value2,value3,value4,value5,value6,value7);
	parent.closePop();
//   this.close();
}

</script>
</head>

<body onload="kep_onload_view();">
	 <form name="deliAreaPop" id="deliAreaPop" method="post" >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deliAreaPop"> 
<div class="wrapPopup">
  <div class="PopupTit">일괄등록<span><a href="#" onclick="parent.closePop(); return false;"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup"><img src="/resources/imgs/Icon_Importance.png" /> 일괄 등록할 값을 입력해주세요. 값이 입력된 항목만 일괄 등록됩니다.</div>
  <div class="h15"></div>
  <table class="PopupTableTH">
    <colgroup>
      <col width="210px" />
      <col width="210px" /> 
  	<tr>
      <th>일괄등록 컬럼</th>
      <th>일괄등록 입력값</th>
    </tr>
  	<tr>
      <td>거래유형</td>
      <td>
      	<select name="PROCESS_TYPE" id="PROCESS_TYPE" class="Select" style="width:202px">
           <%= CommonUtil.getCodeComboList("BURQ09","SEL","") %>
     	 </select>
      </td>
    </tr>
    <tr>
      <td>배송유형</td>
      <td>
      <select name="PARCEL_YN" id="PARCEL_YN" class="Select" style="width:202px">
           <%= CommonUtil.getCodeComboList("BURQ10","SEL","") %>
      </select>
      </td>
    </tr>
  	<tr>
      <td>조달일수</td>
      <td><input class="input30" style="width:180px" id="DELIVERY_LT" name="DELIVERY_LT" type="number" min="1" oninput="this.value = this.value.replace(/[^0-9]/g, ''); if (this.value === '') this.value = 1;" /> </td>
    </tr>
  </table>
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center">
    <button class="ButQuaternary_large" onclick="parent.closePop(); return false;">취소</button>
    <button class="ButPrimary_large" onclick="javascript:saveData(); return false;">저장</button>
  </div>  
</div><!-- warp 끝-->

	 
</form> 
</body>
</html>
