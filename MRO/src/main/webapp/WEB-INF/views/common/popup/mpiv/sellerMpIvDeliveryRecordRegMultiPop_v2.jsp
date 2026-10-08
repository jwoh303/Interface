<%--
**********************************************
* 메뉴 : 
* 화면 : 납품실적등록 일괄등록
* 기능 :
* 프로그램 ID : SU0504002
* 담당자 : 최찬규
* 착수일 : 2025-10-29
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
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />

<script type="text/javascript">
window.calendarPositionOffset = {
		top:-150,
		left:-150
	};
	
var select_all_yn = "N"; // 전체선택_전체해제_flag

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view(){
	kepAjaxCommonComboDataValue("st_parcel_com_code", "C019", "SEL", "");
}

function saveData(){
	var flag = false;
	var value1 = "";
	var value2 = "";
	var value3 = "";
	
	if($("#st_parcel_yn_check").is(":checked")){//배송유형
		var st_parcel_yn = $("input[name='st_parcel_yn']:checked").val();
		if(isEmpty(st_parcel_yn)){
// 			alert("배송유형을 선택해주시기 바랍니다.");
			var text = "배송유형을 선택해주시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		flag = true;
		value1 = st_parcel_yn;
	}
	if($("#st_parcel_com_code_check").is(":checked")){ //택배사
		var st_parcel_com_code = $("#st_parcel_com_code").val();
		if(isEmpty(st_parcel_com_code)){
// 			alert("택배사를 선택해주시기 바랍니다.");
			var text = "택배사를 선택해주시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		flag = true;
		value2 = st_parcel_com_code;
	}
	if($("#st_customer_invoice_date_check").is(":checked")){ //고객수령일
		var st_customer_invoice_date = $("#st_customer_invoice_date").val();
		if(isEmpty(st_customer_invoice_date)){
// 			alert("고객수령일을 선택해주시기 바랍니다.");
			var text = "고객수령일을 선택해주시기 바랍니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		flag = true;
		value3 = st_customer_invoice_date;
	}
	
	if(!flag){
// 		alert("선택된 값이 없습니다.");
		var text = "선택된 값이 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	parent.setPopupReturn(value1,value2,value3);
	parent.closePop();
}
function parcelChange(flag){
	if(flag == "1"){
		$("#st_parcel_yn_check").prop("checked",true);
		var st_parcel_yn = $("input[name='st_parcel_yn']:checked").val();
		if(st_parcel_yn == "Y"){//택배면 택배사만 선택가능
			$(".date-input").css("pointer-events","none");
			$(".calendar-btn").css("pointer-events","none");
			$(".date-input").css("background-color","#f5f7fa");
			$(".date-input input[type=text]").css("background-color","#f5f7fa");
			
			$("#st_customer_invoice_date_check").attr("disabled",true);
			$("#st_parcel_com_code_check").attr("disabled",false);
			$("#st_parcel_com_code").attr("disabled",false);
			$("#st_customer_invoice_date_check").prop("checked",false);
			$("#st_customer_invoice_date").val("");
		}else{ //자차면 고객수령일만 선택가능
			$(".date-input").css("pointer-events","auto");
			$(".calendar-btn").css("pointer-events","auto");
			$(".date-input").css("background-color","");
			$(".date-input input[type=text]").css("background-color","");
			
			$("#st_customer_invoice_date_check").attr("disabled",false);
			$("#st_customer_invoice_date").attr("disabled",false);
			$("#st_parcel_com_code_check").attr("disabled",true);
			$("#st_parcel_com_code").attr("disabled",true);
			$("#st_parcel_com_code_check").prop("checked",false);
			$("#st_parcel_com_code").val("");
		}
	}else if(flag =="2"){
		$("#st_parcel_com_code_check").prop("checked",true);
	}else{
		$("#st_customer_invoice_date_check").prop("checked",true);
	}
	
}
function checkedAllBox(){  
	var check = $("#checkedAll").is(":checked");
	$("#st_parcel_yn_check").prop("checked",check);
	if(!$("#st_parcel_com_code_check").is(":disabled")){
		$("#st_parcel_com_code_check").prop("checked",check);
	}
	if(!$("#st_customer_invoice_date_check").is(":disabled")){
		$("#st_customer_invoice_date_check").prop("checked",check);
	}
}

</script>
</head>

<body onload="kep_onload_view();">
	 <form name="deliAreaPop" id="deliAreaPop" method="post" >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deliAreaPop"> 
<div class="wrapPopup">
  <div class="PopupTit">일괄등록<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:420px"><img src="/resources/imgs/Icon_Importance01.png" /> 일괄 등록할 값을 입력해주세요. 값이 입력된 항목만 일괄 등록됩니다.</div>
  <div class="h15"></div>
   <table class="PopTableThTd"  width="440px">
    <colgroup>
      <col width="50px" />
      <col width="130px" />
      <col width="260px" /> 
   	</colgroup>
    <tr>
      <th height="35"><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="checkedAll" name="checkedAll" onclick="javascript:checkedAllBox();"><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></th>
      <th>일괄등록 컬럼</th>
      <th  align="center">일괄등록 입력값</th>
    </tr>
    <tr>      
      <td><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="st_parcel_yn_check"><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></td>
      <td>배송유형</td>
      <td ><label class="RadioMediumLabel" style="vertical-align:middle; margin-left:0"><input type="radio" name="st_parcel_yn" value="Y" onchange="javascript:parcelChange('1');"><span class="RadioMediumTxt"></span> 택배</label> &nbsp; &nbsp;
          <label class="RadioMediumLabel"  style="vertical-align:middle"><input type="radio" name="st_parcel_yn" value="N" onchange="javascript:parcelChange('1');"><span class="RadioMediumTxt"></span> 자차</label></td>
    </tr>
    <tr>      
      <td><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="st_parcel_com_code_check"><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></td>
      <td>택배사</td>
      <td><select id="st_parcel_com_code" name="st_parcel_com_code" class="Select" style="width:222px;" onchange="javascript:parcelChange('2');">
        </select> </td>  
    </tr> 
    <tr>      
      <td><label class="CheckMediumLabel" style="margin:5px 0px;"><input type="checkbox" id="st_customer_invoice_date_check"><span class="CheckMediumCustom"  style="margin-right:0px;"></span></label></td>
      <td>고객수령일</td>
      <td><div class="datepicker-wrap" style=" width:222px">
             <div class="date-input" data-datepicker style=" width:222px"><input type="text" placeholder="" id="st_customer_invoice_date" name="st_customer_invoice_date" onchange="javascript:parcelChange('3');" style=" width:160px" readonly /><span> </span></div>
           </div>
      </td>
    </tr>    
          
  </table>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:440px;">
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop();" >취소</button>
    <button class="ButPrimary_large" onclick="javascript:saveData(); return false;" >일괄등록</button>
  </div>  
</div><!-- warp 끝-->
</form> 
</body>
</html>
