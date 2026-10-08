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
	
	var minOrderQty = $("#MIN_ORDER_QTY").val();
	var purUnitQty = $("#PUR_UNIT_QTY").val();
	var itemMakeType = $("#ITEM_MAKE_TYPE").val();
	var leadTime = $("#LEAD_TIME").val();
	var preGrFlag = $("#PRE_GR_FLAG").val();
	var taxType = $("#TAX_TYPE").val();
	var stoaRemark = $("#STOA_REMARK").val();
	
	setReturn(minOrderQty,purUnitQty,itemMakeType,leadTime,preGrFlag,taxType,stoaRemark);
}


function setReturn(value1,value2,value3,value4,value5,value6,value7){
	parent.setPopupReturn(value1,value2,value3,value4,value5,value6,value7);
	parent.closePop();
//   this.close();
}

function addComma(el,id){
	$("#"+id).val(el.value); //콤마 붙이기전 값은 실제 보낼 데이터에 저장
	var value = kepCommaNum(el.value);
	el.value = value;
}
function changeLeadTime(){
	var st_item_make_type = $("#ITEM_MAKE_TYPE").val();
	var st_lead_time = $("#LEAD_TIME").val();
	var new_lead_time = 0;
	
	if( st_item_make_type == "ST"){
		new_lead_time = 3;
	}else if( st_item_make_type == "MK"){
		new_lead_time = 7;
	}else if( st_item_make_type == "SI" || st_item_make_type == "MI"){
		new_lead_time = 30;
	}
	
	if(st_lead_time != ""){
		alert("기본 조달일수로 설정되었습니다. 조달일수를 확인하시기 바랍니다.");
	}
	
	$("#LEAD_TIME").val(new_lead_time);
	$("#LEAD_TIME_TEXT").val(kepCommaNum($("#LEAD_TIME").val()));
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
      <td>최소주문수량</td>
      <td><input class="input30" style="width:180px" id="MIN_ORDER_QTY_TEXT" name="MIN_ORDER_QTY_TEXT" maxlength="4" type="text" onblur="addComma(this,'MIN_ORDER_QTY');"/>
      	<input class="input30" style="width:180px" id="MIN_ORDER_QTY" name="MIN_ORDER_QTY" type="hidden" />
      </td>
    </tr>
  	<tr>
      <td>주문배수수량</td>
      <td><input class="input30" style="width:180px" id="PUR_UNIT_QTY_TEXT" name="PUR_UNIT_QTY_TEXT" maxlength="4" type="text" onblur="addComma(this,'PUR_UNIT_QTY');"/>
      	<input class="input30" style="width:180px" id="PUR_UNIT_QTY" name="PUR_UNIT_QTY" type="hidden" />
      </td>
    </tr>
    <tr>
      <td>품목구분</td>
      <td>
      <select name="ITEM_MAKE_TYPE" id="ITEM_MAKE_TYPE" class="Select" style="width:202px" onchange="javascript:changeLeadTime();">
           <%= CommonUtil.getCode3ComboList("", "SEL", "M132","", "ICOMCOD1", "", "") %>
      </select>
      </td>
    </tr>
    <tr>
      <td>배송일수</td>
      <td><input class="input30" style="width:180px" id="LEAD_TIME_TEXT" name="LEAD_TIME_TEXT" maxlength="4" type="text" onblur="addComma(this,'LEAD_TIME');"/>
      	<input class="input30" style="width:180px" id="LEAD_TIME" name="LEAD_TIME" type="hidden" />
      </td>
    </tr>
    <tr>
      <td>선입고</td>
      <td><select id="PRE_GR_FLAG" name="PRE_GR_FLAG" class="Select" style="width:202px">
           <option value="" >선택</option>
           <option value="Y" >Y</option>
           <option value="N" selected>N</option>
          </select></td>
    </tr>
    <tr>
      <td>과세</td>
      <td><select id="TAX_TYPE" name="TAX_TYPE" class="Select" style="width:202px">
           <option value="" >선택</option>
           <option value="11" selected>과세</option>
           <option value="12" >면세</option>
          </select></td>
    </tr>
    <tr>
    	<td>협력사비고</td>
    	<td><textarea id="STOA_REMARK" name="STOA_REMARK" style="width:180px; border:1px solid #DEDEDE" maxlength="100" placeholder="" ></textarea></td>
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
