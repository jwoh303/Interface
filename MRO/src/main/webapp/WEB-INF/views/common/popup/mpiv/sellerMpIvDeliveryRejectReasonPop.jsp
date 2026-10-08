<%--
**********************************************
* 메뉴 : 
* 화면 : 수주거부 요청 팝업
* 기능 :
* 프로그램 ID :
* 담당자 : HSJ ( 설계 :  )
* 착수일 : 2023-10-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>

<script language="javascript">
// 거부사유 저장
function deliveryRejectReq(){
	var form = document.sellerMpIvDeliveryRejectReasonPop;
	var value_reason = "";
	var value_reason_text = "";
	var image_key = "";
	
	for( var i = 0; i < form.rdo_reject_reason_cd.length; i++){
		if(form.rdo_reject_reason_cd[i].checked == true){
			value_reason = form.rdo_reject_reason_cd[i].value;
		}
	}
	
	if(isEmpty(value_reason)) {
		alert("거부사유를 선택하세요.");
		return;
	}
	
	value_reason_text = $("#st_reject_reason_text").val();
	image_key = $("#st_image_key").val();
	
	if(isEmpty(value_reason_text)) {
		alert("거부 상세사유를 입력하세요.");
		return;
	}
	
	opener.setRejectReasonText(value_reason, value_reason_text, image_key);	
	parent.window.close();
}

function init(){
	var form = document.sellerMpIvDeliveryRejectReasonPop;
	var reason_full = opener.getRejectReason();
	var reason_arr = reason_full.split("/");

	// 거부사유
	var reason = reason_arr[0];
	for( var i = 0; i < form.rdo_reject_reason_cd.length; i++){
		if(form.rdo_reject_reason_cd[i].value == reason){
			form.rdo_reject_reason_cd[i].checked = true;
		}
	}
	
	// 상세사유
	var reason_text = reason_arr[1];
	$("#st_reject_reason_text").val(reason_text);
	
	// 첨부파일
	var image_key = reason_arr[2];
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	
	if(image_key != ''){
    	form.st_image_key.value = image_key;
    	form.st_image_key_img.src = diskOn;
    }else{
    	form.st_image_key.value = "";
    	form.st_image_key_img.src = diskOff;
    }
}

function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "attach"://파일 첨부
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="VI";
			var form = document.sellerMpIvDeliveryRejectReasonPop;
			value1 = form.st_image_key.value;
			openSearchPopup("/common/fileUploadPop.do", '?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType, "500,430,no");
			break;
	}
}

function setPopupReturn(code, text, value){
	if (popupSel == "fileUpload") {	//파일 첨부
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		
		var form = document.sellerMpIvDeliveryRejectReasonPop;
		form.st_image_key.value = code;
		
	    if(code != ''){
	    	form.st_image_key.value = code;
	    	form.st_image_key_img.src = diskOn;
	    }else{
	    	form.st_image_key.value = "";
	    	form.st_image_key_img.src = diskOff;
	    }
	}
}
</script> 
</head>
<body onLoad="javascript:init();">
<form name="sellerMpIvDeliveryRejectReasonPop" id="sellerMpIvDeliveryRejectReasonPop" method=post >

<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div id="popWrapper" style="height:404px;">
   	<div id="popHeader">
		<h1 class="title">수주거부 요청</h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
	</div>
	
		<!--팝업내용입니다-->
		<div id="popContainer">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		            <td valign="bottom">
		                <table width="100%" class="cont_t_list05">
			                <colgroup>
					            <col width="30%" />
					            <col width="15%" />
					            <col width="5%"/>
					            <col width="*" />
					        </colgroup>
					        
					        <tr style="padding-left:5px"> 
		                        <th rowSpan="5">거부사유<br>(중복선택 불가)</th>
		                        <td>단가이슈</td>
		                        <td style="padding-left:5px"><input type="radio" name="rdo_reject_reason_cd" id="rdo_reject_reason_cd1" style="vertical-align:middle;" value="단가이슈"/></td>
		                        <td style="padding-left:5px">납품 가능 단가 기재 후 제출</td>
		                    </tr>
		                    <tr> 
		                        <td>규격이슈</td>
		                        <td style="padding-left:5px"><input type="radio" name="rdo_reject_reason_cd" id="rdo_reject_reason_cd2" style="vertical-align:middle;" value="규격이슈"/></td>
		                        <td style="padding-left:5px">필요정보(제조사/사양/기타) 기재 후 제출</td>
		                    </tr>
		                    <tr> 
		                        <td>단종상품</td>
		                        <td style="padding-left:5px"><input type="radio" name="rdo_reject_reason_cd" id="rdo_reject_reason_cd3" style="vertical-align:middle;" value="단종상품"/></td>
		                        <td style="padding-left:5px">대체품목 기재 후 제출</td>
		                    </tr>
		                    <tr> 
		                        <td>수급불가</td>
		                        <td style="padding-left:5px"><input type="radio" name="rdo_reject_reason_cd" id="rdo_reject_reason_cd4" style="vertical-align:middle;" value="수급불가"/></td>
		                        <td style="padding-left:5px">수급불가 사유 기재 후 제출</td>
		                    </tr>
		                    <tr> 
		                        <td>기타사유</td>
		                        <td style="padding-left:5px"><input type="radio" name="rdo_reject_reason_cd" id="rdo_reject_reason_cd5" style="vertical-align:middle;" value="기타사유"/></td>
		                        <td style="padding-left:5px">상기 외 사유 기재 후 제출</td>
		                    </tr>
		                    <tr> 
		                        <th><font color="red">*</font> 거부 상세사유</th>
		                        <td colSpan="3">
		                        	<input type="text" name="st_reject_reason_text" id="st_reject_reason_text" style="width:90%"; value=""/>
		                        	<input type="text" style="display:none"/>
		                        	<input type="hidden" name="st_image_key" id="st_image_key" value=""/>
		                        	<a class="hyperLink" href="javascript:doPop('attach', '')">
										<img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0">
									</a>
								</td>
		                    </tr>
		                </table>
		                
		                <span style="text-align:left;">
		                	<font color="red">해당 발주번호 내 모든 품목이 수주거부 신청되며, KeP 확인 전까지 수주접수 내역에서 제외됩니다.</font><br>
		                	<font color="red">수주거부 신청 후 진행 상황은 <b>[납품관리>납품현황>요청사항 진행현황]</b>에서 확인 가능합니다.</font><br>
		                </span>
		                
		                <br><br>
		                
		                <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
		                    <tr>
		                        <td align="center">
		                        	<span class="btn_04"><a href="javascript:deliveryRejectReq();">제출</a></span>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		</div>
    </div>        
</div>
</form> 
</body>
</html>
