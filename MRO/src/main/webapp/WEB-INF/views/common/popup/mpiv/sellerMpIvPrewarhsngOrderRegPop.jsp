<%--
**********************************************
* 메뉴 : 협력사 > 납품관리 > 선입고 납품 관리 > 선입고 요청 등록 
* 화면 : 선입고 요청 등록 팝업
* 기능 : 협력사에서 선입고 요청을 등록한다.
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 현명환 )
* 착수일 : 2017-01-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<%
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	List<Map<String,String>> _dataPoList = (List<Map<String,String>>) request.getAttribute("data_po"); // 조회된 결과
%>
<script type="text/javascript"> 
var popupSel = "";

function popupOnload(){
	kepSetCalender("st_b_req_date");
	$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}

//Valitation - 저장
function validationSave() {
	if($('#st_buyer_code').val() == ""){
		alert("고객사를 입력하세요");
		return false;
	}
	
	if($('#st_buyer_dept_name').val() == ""){
		alert("요청자부서를 입력하세요");
		return false;
	}
	
	if($('#st_req_user_name').val() == "" || $('#st_req_user_tel').val() == ""){
		alert("요청자/연락처를 입력하세요");
		return false;
	}
	
	if($('#st_dely_location_code').val() == ""){
		alert("도착지정보를 입력하세요");
		return false;
	}
	
	if($('#st_item_qty').val() == "" || $('#st_item_qty').val() == "0"){
		alert("선입고수량을 입력하세요");
		return false;
	}
	
	if(!kepIsNumChk('st_item_qty', 2)){
		alert("선입고수량(숫자형식)을 입력하여 주십시요.");
		return false;
	}
	
	if($('#st_description').val() == ""){
		alert("품목명을 입력하세요");
		return false;
	}
	
	if($('#st_specification').val() == ""){
		alert("규격을 입력하세요");
		return false;
	}
	
	if($('#st_maker_name').val() == ""){
		alert("제조사를 입력하세요");
		return false;
	}
    
	if($('#st_origin_name').val() == ""){
		alert("원산지를 입력하세요");
		return false;
	}
	
	if($('#st_unit_measure').val() == ""){
		alert("단위를 선택하세요");
		return false;
	}
	
	if(!kepIsNumChk('st_unit_price', 2)){
		alert("매출단가(숫자형식)를 입력하여 주십시요.");
		return false;
	}
	
	if($('#st_agent_price').val() == "" || $('#st_agent_price').val() == "0"){
		alert("매입단가를 입력하세요");
		return false;
	}
	
	if(!kepIsNumChk('st_agent_price', 2)){
		alert("매입단가(숫자형식)를 입력하여 주십시요.");
		return false;
	}
	
	if($('#st_process_type').val() != "0"){
		if($('#st_warehouse_code').val() == ""){
			alert("물류센터를 선택하세요");
			return false;
		}
	}
		
	return true;
}

//기능함수
function doAction(str) {
	switch (str) {
		case "save": // 등록
			if(!validationSave())
				return;
			if(!confirm('등록하시겠습니까?'))
				return;
			kepAjaxFormCall("/mpiv/saveSellerMpIvPrewarhsngOrderRegPop.do","searchCondition","save");
			break;
			
		case "contract_yn": //조회
			var st_contract_check = $("input[name=contract_group]:checked").val();
			if(st_contract_check == "N"){ // 미계약 클릭 시
				document.forms.searchCondition.st_description.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_specification.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_maker_name.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_origin_name.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_unit_measure.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_unit_price.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_agent_price.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_process_type.style.backgroundColor = "#ffffff";
				document.forms.searchCondition.st_warehouse_code.style.backgroundColor = "#ffffff";
				
				document.forms.searchCondition.st_description.readOnly = false;
				document.forms.searchCondition.st_specification.readOnly = false;
				document.forms.searchCondition.st_maker_name.readOnly = false;
				document.forms.searchCondition.st_origin_name.readOnly = false;
				document.forms.searchCondition.st_unit_measure.readOnly = false;
				document.forms.searchCondition.st_unit_price.readOnly = false;
				document.forms.searchCondition.st_agent_price.readOnly = false;
				document.forms.searchCondition.st_process_type.readOnly = false;
				document.forms.searchCondition.st_warehouse_code.readOnly = false;
				
				// 콤보박스 비활성화
				document.getElementById("st_unit_measure").disabled = false;
				document.getElementById("st_process_type").disabled = false;
				document.getElementById("st_warehouse_code").disabled = false;
				
				// 품목코드 팝업 비활성화
				$('#btnGetCatlg').attr('href', '#');
				
			}else{ // 계약 클릭 시
				document.forms.searchCondition.st_description.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_specification.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_maker_name.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_origin_name.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_unit_measure.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_unit_price.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_agent_price.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_process_type.style.backgroundColor = "#EAEAEA";
				document.forms.searchCondition.st_warehouse_code.style.backgroundColor = "#EAEAEA";
				
				document.forms.searchCondition.st_description.readOnly = true;
				document.forms.searchCondition.st_specification.readOnly = true;
				document.forms.searchCondition.st_maker_name.readOnly = true;
				document.forms.searchCondition.st_origin_name.readOnly = true;
				document.forms.searchCondition.st_unit_measure.readOnly = true;
				document.forms.searchCondition.st_unit_price.readOnly = true;
				document.forms.searchCondition.st_agent_price.readOnly = true;
				document.forms.searchCondition.st_process_type.readOnly = true;
				document.forms.searchCondition.st_warehouse_code.readOnly = true;
				
				// 콤보박스 활성화
				document.getElementById("st_unit_measure").disabled = true;
				document.getElementById("st_process_type").disabled = true;
				document.getElementById("st_warehouse_code").disabled = true;
				
				// 품목코드 팝업 활성화
				$("#btnGetCatlg").attr('href', "javascript:doPop('get_catlg')");
			}
			
			reset_contract();
			break;
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	if(pMethod == "save"){ 
		alert("선입고 요청 등록에 실패 하였습니다. 관리자에게 문의하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	alert("정상적으로 등록 되었습니다.");
	opener.doAction('search');
	this.close();
}

//팝업함수호출
function doPop(str) {
	switch (str) {
		case "buyer_single": // 고객사 팝업
			popupSel = "buyer_single";
			openSearchPopup("/common/icomcmpyBsalPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
	        break;	
	        
		case "get_dept": //부서코드 
			if($('#st_buyer_code').val() == ''){
				alert('고객사를 먼저 선택하세요');
				$('#st_buyer_code').focus();
				return;
			}
			popupSel = "get_dept";	
			openSearchPopup("/wmco/showMasterWmDeptPop.do", "?st_buyer_code="+$("#st_buyer_code").val(),"680,470,no");
			break;
			
		case "get_catlg": //기존카탈로그 조회 
			if($('#st_buyer_code').val() == ''){
				alert('고객사를 먼저 선택하세요');
				$('#st_buyer_code').focus();
				return;
			}
			popupSel = "commonCoCoExistingCatalogPop";
			openSearchPopup("/coco/showCommonCoCoExistingCatalogPop.do", "?st_buyer="+ $("#st_buyer_code").val() +"&st_buyer_name="+ $("#st_buyer_name").val(), "800,600,no");
			break;
			
		case "location": //도착지코드
			if($('#st_buyer_code').val() == ''){
				alert('고객사를 먼저 선택하세요');
				$('#st_buyer_code').focus();
				return;
			}	
			popupSel = "location";
			openSearchPopup("/common/delLocationPop.do", "?com_code=" + $("#st_buyer_code").val() + "&open=Y", "500,500,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7, value8, value9, value10, value11, value12, value13, value14,value15,value16){
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel == "buyer_single") {	// 다중 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);
			reset_buyer();
	}else if(popupSel == "get_dept"){
		$("#st_buyer_dept_code").val(value1);
		$("#st_buyer_dept_name").val(value2);
	}else if (popupSel == "commonCoCoExistingCatalogPop") {	// 품목코드
		$("#st_buyer_item_no").val(value1);
		$("#st_description").val(value2);
		$("#st_specification").val(value3);
		$("#st_maker_name").val(value4);
		$("#st_maker_code").val(value5);
		$("#st_origin_name").val(value6);
		$("#st_origin_code").val(value7);
		$("#st_unit_measure").val(value8);
		$("#st_unit_measure_value").val(value8);
		$("#st_unit_price").val(value9);
		$("#st_agent_price").val(value10);
		$("#CONTRACT_NO").val(value13);
		$("#CONTRACT_SEQ").val(value14);
		$("#st_process_type").val(value15);
		$("#st_process_type_value").val(value15);
		$("#st_warehouse_code").val(value16);
		$("#st_warehouse_value").val(value16);
	}else if (popupSel == "location"){
		$("#st_dely_location_code").val(value1);
		$("#st_dely_location_name").val(value2);
	}
}

function EraserBuyerCode(){
	$("#st_buyer_code").val('');
	$("#st_buyer_name").val('');
}

function fnNumberCheck(id) {
	if (!kepIsNumDash(id)) {
		alert("숫자와 - 만 입력할수 있습니다.");
		$("#"+id).val("");
	}
}

function reset_buyer(){
	$("#st_buyer_dept_code").val('');
	$("#st_buyer_dept_name").val('');
	$("#st_req_user_name").val('');
	$("#st_req_user_tel").val('');
	$("#st_dely_location_code").val('');
	$("#st_dely_location_name").val('');
	$("input:radio[name='contract_group']:radio[value='Y']").prop("checked", true);
	
	doAction('contract_yn');
}

function reset_contract(){
	$("#st_item_qty").val('');
	$("#st_buyer_item_no").val('');
	$("#st_description").val('');
	$("#st_specification").val('');
	$("#st_maker_code").val('');
	$("#st_maker_name").val('');
	$("#st_origin_code").val('');
	$("#st_origin_name").val('');
	$("#st_unit_measure").val('EA');
	$("#st_unit_measure_value").val('EA');
	$("#st_unit_price").val('');
	$("#st_agent_price").val('');
	$("#CONTRACT_NO").val('');
	$("#CONTRACT_SEQ").val('');
	$("#st_process_type").val('0');
	$("#st_process_type_value").val('0');
	$("#st_warehouse_code").val('');
	$("#st_warehouse_value").val('');
	
	set_warehouse();
}

function set_warehouse(){
	if($("#st_process_type").val() == "0"){
		$("#st_warehouse_code").val('');
		document.getElementById("st_warehouse_code").disabled = true;
	}else{
		document.getElementById("st_warehouse_code").disabled = false;
	}
	
	set_process_type_value();
}

function set_unit_measure_value(){
	var unit_measure = $("#st_unit_measure").val();
	$("#st_unit_measure_value").val(unit_measure);
}

function set_process_type_value(){
	var process_type = $("#st_process_type").val();
	$("#st_process_type_value").val(process_type);
}

function set_warehouse_value(){
	var warehouse = $("#st_warehouse_code").val();
	$("#st_warehouse_value").val(warehouse);
}

</script> 
<body onload="popupOnload();">
<form name="searchCondition" id="searchCondition" method="post" onsubmit="return false">
	<input type="hidden" id="pageflag" name="pageflag" value="1">
	<input type="hidden" id="onepagerow" name="onepagerow" value="10">
	<input type="hidden" id="AGENT_USER_ID" name="AGENT_USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="AGENT_USER_NAME" name="AGENT_USER_NAME" value="${sessionInfo.userNameLoc}">
	<input type="hidden" id="AGENT_TEL_NO" name="AGENT_TEL_NO" value="${sessionInfo.tel}">
	<input type="hidden" id="AGENT_CODE" name="AGENT_CODE" value="${sessionInfo.comCode}">
	<input type="hidden" id="AGENT_NAME" name="AGENT_NAME" value="${sessionInfo.comNameLoc}">
	<input type="hidden" name="CONTRACT_NO" id="CONTRACT_NO" value="">
	<input type="hidden" name="CONTRACT_SEQ" id="CONTRACT_SEQ" value="">
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
			<h1 class="title">선입고 요청 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:518px;">
            <!--조회영역-->
			<table class="cont_t_list07" style="width:100%">
				<colgroup>
					<col width="15%"/>
					<col width="35%"/>
					<col width="15%"/>
					<col width="35%"/>
				</colgroup>
				
				<tbody>
					<tr>
						<th>고객사</th>
						<td>
							<input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" title="" style="width:70%;" readonly oncahange="reset_buyer();" />
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:70%" value="">
							<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:EraserBuyerCode();"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>

						<th>요청일</th>
						<td>
							<input type="text" class="al" name="st_b_req_date" id="st_b_req_date" style="width:30%;" readOnly/>
							<a href="javascript:kepCalendar('st_b_req_date')"></a>
						</td>
					</tr>

					<tr>
						<th>요청자부서</th>
						<td>
							<input type="text" name="st_buyer_dept_name" id="st_buyer_dept_name" class="input_type_text" title="" style="width:70%;" readonly/>
							<input type="hidden" name="st_buyer_dept_code" id="st_buyer_dept_code" style="width:70%" value="">
							<a href="javascript:doPop('get_dept');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_dept_code','st_buyer_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						
						<th>요청자/연락처</th>
						<td>
							<input type="text" name="st_req_user_name" id="st_req_user_name" class="input_type_text" title="" style="width:30%;"/>
							<input type="text" name="st_req_user_tel" id="st_req_user_tel" class="input_type_text" title="" style="width:60%;" onkeyup="fnNumberCheck('st_req_user_tel')"/>
						</td>
					</tr>
					
					<tr>
						<th>도착지정보</th>
						<td colspan="3">
							<input type="text" name="st_dely_location_name" id="st_dely_location_name" class="input_type_text" title="" style="width:85%;" readonly/>
							<input type="hidden" name="st_dely_location_code" id="st_dely_location_code" style="width:80%" value="">
							<a href="javascript:doPop('location')"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_dely_location_code','st_dely_location_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
					</tr>
					
					<tr>
						<th>계약품목여부</th>
						<td>
							<input type="radio" name="contract_group" id="contract_group1" value="Y"  onChange="doAction('contract_yn');" checked/>&nbsp;계약&nbsp;
							<input type="radio" name="contract_group" id="contract_group2" value="N"  onChange="doAction('contract_yn');"/>&nbsp;미계약
						</td>
						
						<th>선입고 수량</th>
						<td>
							<input type="text" name="st_item_qty" id="st_item_qty" class="input_type_text" title="" style="width:30%; text-align:right;"/>
						</td>
					</tr>
					
					<tr>
						<th>품목코드</th>
						<td>
							<input type="text" name="st_buyer_item_no" id="st_buyer_item_no" class="input_type_text" title="" style="width:70%;" readonly />
							<a href="javascript:doPop('get_catlg');" id="btnGetCatlg"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_item_no');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>

						<th>품목명</th>
						<td>
							<input type="text" name="st_description" id="st_description" class="input_type_text" title="" style="width:90%; background:#EAEAEA;"readonly />
						</td>
					</tr>
					
					<tr>
						<th>규격</th>
						<td>
							<input type="text" name="st_specification" id="st_specification" class="input_type_text" title="" style="width:90%; background:#EAEAEA;" readonly />
						</td>
						
						<th>제조사</th>
						<td>
							<input type="text" name="st_maker_name" id="st_maker_name" class="input_type_text" title="" style="width:90%; background:#EAEAEA;" readonly/>
							<input type="hidden" name="st_maker_code" id="st_maker_code" style="width:80%" value="">
						</td>
					</tr>

					<tr>
						<th>원산지</th>
						<td>
							<input type="text" name="st_origin_name" id="st_origin_name" class="input_type_text" title="" style="width:90%; background:#EAEAEA;" readonly />
							<input type="hidden" name="st_origin_code" id="st_origin_code" style="width:80%" value="">
						</td>
						
						<th>단위</th>
						<td>
							<select name="st_unit_measure" id="st_unit_measure" style="width:30%; background:#EAEAEA;" disabled onChange="set_unit_measure_value();"><%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo","")%></select>
							<input type="hidden" name="st_unit_measure_value" id="st_unit_measure_value" style="width:80%" value="">
						</td>
					</tr>
					
					<tr>
						<th>매출단가</th>
						<td>
							<input type="text" name="st_unit_price" id="st_unit_price" class="input_type_text" title="" style="width:30%; background:#EAEAEA; text-align:right;" readonly/>
						</td>
						
						<th>매입단가</th>
						<td>
							<input type="text" name="st_agent_price" id="st_agent_price" class="input_type_text" title="" style="width:30%; background:#EAEAEA; text-align:right;" readonly/>
						</td>
					</tr>
					
					<tr>
						<th>거래유형</th>
						<td>
							<select name="st_process_type" id="st_process_type" style="width:30%; background:#EAEAEA;" disabled onChange="set_warehouse();">
								<option value = "0" >직납</option>
								<option value = "1" >재고</option>
								<option value = "2" >TR</option>
								<option value = "3" >VMI</option>
							</select>
							<input type="hidden" name="st_process_type_value" id="st_process_type_value" style="width:80%" value="">
						</td>
						
						<th>물류센터</th>
						<td>
							<select id="st_warehouse_code" name="st_warehouse_code" style="background:#EAEAEA;" disabled onChange="set_warehouse_value();"><%=CommonUtil.getCodeComboQueryIdList("common.agentWareHouse", "NOSEL", "")%></select>
							<input type="hidden" name="st_warehouse_value" id="st_warehouse_value" style="width:80%" value="">
						</td>
					</tr>
				</tbody>
			</table>

			<!--버튼영역-->
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">등록</a></span>
			</span>
			<br/>
		</div>
    </div>
</form> 
</body>
</html>
