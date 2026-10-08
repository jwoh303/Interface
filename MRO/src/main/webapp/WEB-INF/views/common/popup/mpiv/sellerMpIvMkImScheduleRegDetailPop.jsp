<%--
**********************************************
* 메뉴 : 
* 화면 : 포장지 도안관리 상세(작물보호)
* 기능 : 선택한 도안의 상세정보와 확인현황을 조회하고, 권한이 있는경우 각 해당단계에 확인 처리 한다.
* 프로그램 ID : PG_07_A_013_02
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cu" uri="/WEB-INF/tld/commonUtil.tld"%>
<!doctype html>
<html>
<%@ include file="/WEB-INF/views/common/include/head.jspf"%>
	<head>
	<meta charset="utf-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>코리아 e 플랫폼</title>
	<head>
		<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
		<link rel="stylesheet" href="/resources/styles/seller_layout.css" type="text/css" />
		<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
		<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
		<script src="/resources/js/kep_common.js"></script>
	</head>
<script type="text/javascript">

function kep_onload_view(){
	var total_cnt = $('#total_cnt').val();
	for(var j = 1; j <= total_cnt; j++){
		if($('#st_mk_date'+j).val() == ''){
			kepSetCalender('st_mk_date'+j);
		}
	}
// 	setCheckBox();
}

function setCheckBox(){
// 	1. checked 여부 확인 
// 	$("input:checkbox[id='ID']").is(":checked") == true : false  /* by ID */
// 	$("input:checkbox[name='NAME']").is(":checked") == true : false /* by NAME */ 
// 	2. checked/unchecked 처리 
// 	$("input:checkbox[id='ID']").attr("checked", true); /* by ID */
// 	$("input:checkbox[name='NAME']").attr("checked", false); /* by NAME */ 
	var total_cnt = $('#total_cnt').val();
	for(var j = 1; j <= total_cnt; j++){
		if($('#st_admin_remark'+j).val() != ''){
			$("#st_admin_check"+j).attr("checked", true);
		}
		if($('#st_agent_remark'+j).val() != ''){
			$("#st_agent_remark"+j).attr('readonly','readonly');
			$("#st_agent_check"+j).attr("checked", true);
		}
	}
}

function setRemark(){
	var total_cnt = $('#total_cnt').val();
	for(var j = 1; j <= total_cnt; j++){
		if($("#st_agent_check"+j).is(":checked") && $("#st_agent_remark"+j).val() == ''){
			$("#st_agent_remark"+j).val('확인되었습니다.');
		}
	}
}
function kepSearch()
{ 
	  $('#contentForm').attr("action", "/mpiv/getSellerMpIvMkImScheduleRegDetailPop.do").submit();
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

//기능함수
function doAction(str, value1, value2, value3) {
	st = new Date();
	switch (str) {
	case "search":
		kepSearch($("#curPage").val());
		break;
	case "saveSellerMkImScheduleReg":
		saveSellerMkImScheduleReg(str, value1);
		break;
	case "SaveEsFi":
		setBuyerDongBuOrderPackingSaveEsFi(str, value1);
		break;
	case "SaveMM":
		setBuyerDongBuOrderPackingSaveMM(str, value1);
		break;
	case "SaveDD":
		setBuyerDongBuOrderPackingSaveDD(str, value1);
		break;
	case "SaveEE":
		setBuyerDongBuOrderPackingSaveEE(str, value1);
		break;
	case "SaveEsMk":
		setBuyerDongBuOrderPackingSaveEsMk(str, value1);
		break;
	case "SaveEsPd":
		setBuyerDongBuOrderPackingSaveEsPd(str, value1);
		break;
	case "SaveEsQa":
		setBuyerDongBuOrderPackingSaveEsQa(str, value1);
		break;
	case "fileUpload"://파일 첨부
		var imageKey =  value2;
		var type="DONGBU";
		var viewType=value3;
		openSearchPopup('/common/fileUploadPop.do','?DATE_DIR=Y&DOC_NO='+imageKey+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	case "close":
		break;
	}
}

//팝업 함수호출
function doPop(str,value1, value2) {

	switch (str) {
		case "masterMpDsPckpaprDesignRejectStatePop": // 반려현황
			var plant			  = document.forms.contentForm.st_plant.value;
			var byca_comorg_code  = document.forms.contentForm.st_byca_comorg_code.value;
			var buyer			  = document.forms.contentForm.st_buyer.value;
			var opkg_seq		  = document.forms.contentForm.st_opkg_seq.value;
			var rd_date			  = document.forms.contentForm.st_rd_date.value;
			var buyer_item_no	  = document.forms.contentForm.st_buyer_item_no.value;
			openSearchPopup('/mpds/showMasterMpDsPckpaprDesignRejectStatePop.do','?st_dept='+value1+'&st_plant='+plant+'&st_byca_comorg_code='+byca_comorg_code+'&st_buyer='+buyer+'&st_opkg_seq='+opkg_seq+'&st_rd_date='+rd_date+'&st_buyer_item_no='+buyer_item_no,'500,350,no');
			break;
		case "attach"://파일 첨부
			popupSel = "fileUpload";
			gridIndex = value2;
			var type="PO";
			var viewType="C";
			if(value2.indexOf("st_agent_image_key") > -1)
				viewType="C";
			else 
				viewType="R";
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			break;
	}
}

/*
 * 저장처리
 */
 function saveSellerMkImScheduleReg(str, recv_flag){
	btnEvent = str;
	var preMkDate = $('#check_date').val();
	var total_cnt = $('#total_cnt').val();
	for(var j = 1; j <= total_cnt; j++){
		var mk_date = $('#st_mk_date'+j).val().replace('/', '').replace('/', '');
		if(preMkDate >= mk_date && mk_date != '' && $('#st_cal_img'+j).attr('src') != '/resources/images/btn_calendar.gif'){
			alert($('#st_mk_type_name'+j).val()+'의 진행기한은 '+preMkDate+' 이후 로 입력하시기 바랍니다.');
			return;
		}
		preMkDate = mk_date; 
		if($('#st_mk_date'+j).val() == ''){
			alert($('#st_agent_remark'+j).val())
			alert($('#st_agent_image_key'+j).val())
			alert($('#st_agent_check'+j).val())
			if(false
					|| $('#st_agent_remark'+j).val() != ''
					|| $('#st_agent_image_key'+j).val() != ''
					|| $('#st_agent_check'+j).val() != ''
					){
				alert($('#st_mk_type_name'+j).val()+'의 진행기한은 입력하시기 바랍니다.');
				return;
			}
		}
	}
	kepAjaxFormCall("/mpiv/saveSellerMkImScheduleReg.do","contentForm",btnEvent); 
}

 function  attach_popup(IMAGE_KEY){	
		var type = "PO";
		var viewType = "C";
		var img_key = IMAGE_KEY; 
		kepFileUploadOpenPopup(img_key,type,viewType); 
	}
 
function setResult(result){

	if(result == "UPDATE_OK"){
		alert("정상적으로 수정이 이루어 졌습니다.");
		opener.setQuery();
		window.close();
	}else if(result == "UPDATE_FAIL"){
		alert("수정이 실패하였습니다. 다시 확인하여 주십시요. ");
		return;
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
//팝업호출
var gridIndex = 0;
var popupSel = "";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
//콜백함수
function setPopupReturn(value1, value2){
	if(popupSel == "fileUpload") {	//파일 첨부
		$("input[name="+gridIndex+"]").val(value1);
		if(value1 ==""){
			$("img[id="+gridIndex+"_disk]").attr("src",diskOff);
		} else {
			$("img[id="+gridIndex+"_disk]").attr("src",diskOn);
		}
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "saveSellerMkImScheduleReg"){
		alert("일정등록이  정상적으로 완료 되었습니다.");
		doAction("search");
		//setQuery();   
	} else if(pMethod == "btnParcel"){
		alert("택배사 정보가 정상적으로 등록되었습니다.");
		doAction("search");
		//setQuery();   
	}
	
	return;
}
//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

function confirmBoxCheck(obj){
	$('#'+obj.name).val('checked')
	obj.checked = 'checked';
	if(obj.checked)
		obj.value = 'checked';
// 	else
// 		obj.value = '';
}
</script> 
<body onload="kep_onload_view()">
	<form name="contentForm" id="contentForm" method=post >
		<input type="hidden" name="st_com_code" id="st_com_code"  value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<c:choose>
			<c:when test="${data == null || fn:length(data) == 0}"/>
			<c:when test="${fn:length(data) > 0}">
				<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
				<div id="popWrapper" style="height:700px;">
					<div id="popHeader">
						<h1 class="title">제작품/수입품 일정 등록 상세</h1>
						<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
					</div>
					<!--팝업내용입니다-->
					<span class="fl">
						<img src="/resources/images/rd_pin.gif" style="padding-left:20px;"> <font  style="color:#444444; font-weight:bold;">발주상세정보</font>
					</span>
					<div id="popContainer">
						<table class="cont_t_list06">
							<caption>리스트</caption>
							<colgroup>
								<col width="20%" />
								<col width="30%" />
								<col width="16%" />
								<col width="34%" />
							</colgroup>
							<tbody>
							<c:set var="check_date" value="<%=CommonUtil.formatDateNoDateGubun(new Date(),1)%>" />
							<c:set var="total_cnt" value="${fn:length(data)}" />
							<c:forEach items="${data}" var="_gridList" begin="1" end="1">
								<c:set var="step" value="${_gridList.STEP }" />
								<tr>
									<th  valign="bottom">고객사</th>
									<td>${_gridList.BUYER_NAME }</td>
									<th >품목코드</th>
									<td><span style="color:blue"><b>${_gridList.BUYER_ITEM_NO }</b></span></td>
								</tr>
								<tr>
									<th height="22">발주번호</th>
									<td>${_gridList.PO_NO }</td>
									<th >발주순번</th>
									<td>${_gridList.PO_SEQ }</td>
								</tr>
								<tr>
									<th height="22">품목명</th>
									<td>${_gridList.DESCRIPTION }</td>
									<th height="22">규격</th>
									<td>${_gridList.SPECIFICATION }</td>
								</tr>
								<tr>
									<th height="22">제품구분</th>
									<td>
										<B>${_gridList.ITEM_MAKE_TYPE_NAME }</B>
									</td>
									<th height="22">진행상태</th>
									<td>${_gridList.STEP_NAME }</td>
								</tr>
								<tr>
									<th height="22">진행상태</th>
									<td>제작시작일</td>
									<th height="22" >발주일</th>
									<td>${cu:formatStrinigDate(_gridList.PO_CREATE_DATE) }</td>
								</tr>
								<tr>
									<th >납기요청일</th>
									<td>
										<c:choose>
											<c:when test="${_gridList.RD_DATE == check_date }">
												<span style='color:red'>
													<b>${cu:formatStrinigDate(_gridList.RD_DATE) }</b>
												</span>
											</c:when>
											<c:otherwise>
													<b>${cu:formatStrinigDate(_gridList.RD_DATE) }</b>
											</c:otherwise>
										</c:choose>
									</td>
									<th height="22">납기예정일</th>
									<td>
										<c:choose>
											<c:when test="${_gridList.DS_DATE == check_date }">
												<span style="color:red">
													<b>${cu:formatStrinigDate(_gridList.DS_DATE) }</b>
												</span>
											</c:when>
											<c:otherwise>
													<b>${cu:formatStrinigDate(_gridList.DS_DATE) }</b>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<input type="hidden" name="st_buyer" value="${_gridList.BUYER }">
								<input type="hidden" name="st_po_no" value="${_gridList.PO_NO }">
								<input type="hidden" name="st_po_seq" value="${_gridList.PO_SEQ }">
								<input type="hidden" name="st_buyer_item_no" value="${_gridList.BUYER_ITEM_NO }">
								<input type="hidden" name="st_item_make_type" value="${_gridList.ITEM_MAKE_TYPE }">
							</c:forEach>
							</tbody>
						</table>
	
						<span class="fl">
							<img src="/resources/images/rd_pin.gif" > <font style="color:#444444; font-weight:bold;">진행상태</font>
						</span>
			 			
						<table class="cont_t_list03">
							<caption>리스트</caption>
							<colgroup>
								<col width="14%" />
								<col width="16%" />
								<col width="10%" />
								<col width="12%" />
								<col width="*" />
								<col width="12%" />
							</colgroup>
							<thead>
								<tr>
									<th rowspan="2">진행형태</th>
									<th rowspan="2">진행기한</th>
									<th>운영사<br/>협력사</th>
									<th>확인여부</th>
									<th>비고</th>
									<th>첨부파일</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${data}" var="_gridList">
									<tr>
										<td rowspan="2" title="진행형태" >
											<b>${_gridList.MK_TYPE_NAME }</b>
											<input type="hidden" name="mk_type_name" id="st_mk_type_name${_gridList.MK_SEQ }" value="${_gridList.MK_TYPE_NAME }" >
											<input type="hidden" name="st_mk_type${_gridList.MK_SEQ }" id="st_mk_type${_gridList.MK_SEQ }" value="${_gridList.MK_TYPE }">
											<input type="hidden" name="st_mk_seq${_gridList.MK_SEQ }" id="st_mk_seq${_gridList.MK_SEQ }" value="${_gridList.MK_SEQ }">
										</td>
										<td rowspan="2" title="진행기한">
											<input type="text" size="10" name="st_mk_date${_gridList.MK_SEQ }" id="st_mk_date${_gridList.MK_SEQ }" class="input_type_text"  value="${cu:formatStrinigDate(_gridList.MK_DATE) }" readonly="readonly">
											<c:choose>
												<c:when test="${_gridList.MK_DATE != ''}">
													<img src="/resources/images/btn_calendar.gif" id="st_cal_img${_gridList.MK_SEQ }" width="23" height="23" border="0">
												</c:when>
											</c:choose>
										</td>
										<td title="운영사/협력사"align="center">
											<b>운영사</b>
										</td>
										<td title="확인여부" align="center">
											완료
											<br/>
											<input type="hidden" name="st_admin_check${_gridList.MK_SEQ }" id="st_admin_check${_gridList.MK_SEQ }" value="${_gridList.ADMIN_CHECK }" >
											<input type="checkbox" name="st_admin_check${_gridList.MK_SEQ }" onclick="javascript:confirmBoxCheck(this)" ${_gridList.ADMIN_CHECK }  disabled="disabled">
										</td>
										<td title="비고" colspan="1" align="center">
											<textarea rows="2" name="st_admin_remark${_gridList.MK_SEQ }" id="st_admin_remark${_gridList.MK_SEQ }" style="padding:3px;width:100%;ime-mode:active" readonly="readonly">${_gridList.ADMIN_REMARK }</textarea>
										</td>
										<td title="첨부파일">
											<input type="hidden" name="st_admin_image_key${_gridList.MK_SEQ }" id="st_admin_image_key${_gridList.MK_SEQ }" value='${_gridList.ADMIN_IMAGE_KEY }'>
											<c:choose>
												<c:when test="${_gridList.ADMIN_IMAGE_KEY == '' }">
													<a href="javascript:doPop('attach', '${_gridList.ADMIN_IMAGE_KEY }', 'st_admin_image_key${_gridList.MK_SEQ }');">
														<img src="/resources/images/disk_off.gif" id="st_admin_image_key${_gridList.MK_SEQ }_disk" width="14" height="14" border="0">
													</a> 
												</c:when>
												<c:otherwise>
													<a class="hyperLink" href="javascript:doPop('attach', '${_gridList.ADMIN_IMAGE_KEY }', 'st_admin_image_key${_gridList.MK_SEQ }')">
														<img name = "st_admin_image_key_disk${_gridList.MK_SEQ }" src="/resources/images/disk_on.gif" border="0">
													</a>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<td title="운영사/협력사"align="center">
											<b>협력사</b>
										</td>
										<td title="확인여부" align="center">
											완료
											<br/>
											<input type="hidden" name="st_agent_check${_gridList.MK_SEQ }" id="st_agent_check${_gridList.MK_SEQ }" value="${_gridList.AGENT_CHECK }" >
											<input type="checkbox" name="st_agent_check${_gridList.MK_SEQ }" ${_gridList.AGENT_CHECK } onclick="javascript:confirmBoxCheck(this)">
										</td>
										<td title="비고" colspan="1" align="center">
											<textarea rows="2" name="st_agent_remark${_gridList.MK_SEQ }" id="st_agent_remark${_gridList.MK_SEQ }" style="padding:3px;width:100%;ime-mode:active" >${_gridList.AGENT_REMARK }</textarea>
										</td>
										<td title="첨부파일">
											<input type="hidden" name="st_agent_image_key${_gridList.MK_SEQ }" id="st_agent_image_key${_gridList.MK_SEQ }" value='${_gridList.AGENT_IMAGE_KEY }'>
											<c:choose>
												<c:when test="${_gridList.AGENT_IMAGE_KEY == '' }">
													<a href="javascript:doPop('attach', '${_gridList.AGENT_IMAGE_KEY }', 'st_agent_image_key${_gridList.MK_SEQ }');">
														<img src="/resources/images/disk_off.gif" id="st_agent_image_key${_gridList.MK_SEQ }_disk" width="14" height="14" border="0">
													</a> 
												</c:when>
												<c:otherwise>
													<a class="hyperLink" href="javascript:doPop('attach', '${AGENT_IMAGE_KEY }', 'st_agent_image_key${_gridList.MK_SEQ }')">
														<img name = "st_agent_image_key_disk${_gridList.MK_SEQ }" src="/resources/images/disk_on.gif" border="0">
													</a>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
			
						<div class="btnArea">
							<span class="fr">
								<span class="btn_02 mr04"><a href="javaScript:doAction('saveSellerMkImScheduleReg');">저장</a></span>
							</span>
						</div>
					</div>
				</div>
			</c:when>
		</c:choose>
		<input type="hidden" name="total_cnt" id="total_cnt" value='${total_cnt}'>
		<input type="hidden" name="check_date" id="check_date" value='${check_date}'>
		<input type="hidden" name="business_cond" id="business_cond" value='${sessionInfo.businessCond}'>
		<input type="hidden" name="step" id="step" value='${step}'>
		<input type="hidden" id="step_name" value='${step}'>
		<input type="hidden" name="st_mk_seq" id="st_mk_seq" value=''>
		<input type="hidden" name="st_mk_type" id="st_mk_type" value=''>
		<input type="hidden" name="st_mk_date" id="st_mk_date" value=''>
		<input type="hidden" name="st_agent_remark" id="st_agent_remark" value=''>
		<input type="hidden" name="st_agent_image_key" id="st_agent_image_key" value=''>
		<input type="hidden" name="st_admin_remark" id="st_admin_remark" value=''>
		<input type="hidden" name="st_admin_image_key" id="st_admin_image_key" value=''>
	</form>
	<form name="processForm" id="processForm" method="post">
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" >
		<input type="hidden" name="buyer" id="buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="gubun" id="gubun" value="" />
		<div id="process">
		</div>
	</form>
</body>
</html>
