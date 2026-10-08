<%--
**********************************************
* 메뉴 : 
* 화면 : 엑셀업로드 
* 기능 : 신규상품 견적의뢰 일괄등록
* 프로그램 ID : PG_04_B_003_01
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-09-03
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
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
</head>
<%
	@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String buyer=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_id=  CommonUtil.nvl((String) request.getParameter("user_id"), _sessionInfo.getUserId());
String read_only =""; 
//카테고리 필수 특수로직.
boolean p04404201 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4042-01");
//요청단가 필수 특수로직.
boolean p04405301 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4053-01");
//제조사 필수 특수로직.
boolean p04405401 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4054-01");
if(buyer.equals("KRDOOS0020")){ 
	read_only = "readonly='readonly'";
}
//안전인증서 표기 여부
boolean p04405701 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4057-01");
%>

<script type="text/javascript">
var popupSel = "";
var btnEvent = "";
//최초 화면 함수
function kep_onload_view(){

}	

function kepSearch()
{  
  $('#contentForm').attr("action", "/mprq/getBuyerMpRqExcelUploadPop.do").submit();    
}

function setExcelUp() {  		 
	if (isEmpty($("#files").val())==true){
		alert("<%=CommonLang.msg("MSG175")%>");	//업로드 대상이 없습니다. 확인 부탁드립니다.
		return;
	}  	
	 
	$('#UploadForm').attr("action", "/mprq/setMpRqExcelUp.do").submit(); 
}	
function setExcelUpValid() {
	if (IsExt($("#files").val())) { //파일명 체크
	    alert("<%=CommonLang.msg("MSG176")%>");	//해당 형식의 파일은 업로드할 수 없습니다.
		return;
// 	    doAction("search");
	  }
}
function IsExt(str) {
    var urltext = str.toLowerCase(); //받아온 파일명을 소문자로 변경한다.

    if (/xls$/.test(urltext)||/xlsx$/.test(urltext)){
       return false; //해당 파일명에 xls라는 단어가 있음.
    } else {
      return true; //해당 파일명에 xls라는 단어가 없음.
    }
 }
//팝업함수호출
var gridIndex = "";
function doPop(str,value1, value2, value3) {
	popupSel = str;
	gridIndex = value1;
	var tot_cnt      = $("#display_item_cnt").val();
	
	switch (str) {
	case "calendar": // 달력
		openSearchPopup('/common/calendarPop.do','','230,245,no');
		break;
	case "buyerMpRqUserRemarkPop": // 기초데이터입력
		var remark		= "";

	    if(eval(tot_cnt)<=1) { 
	        remark = document.forms.contentForm.st_btoa_remark.value; 
	    }else {  
	        remark = document.forms.contentForm.st_btoa_remark[gridIndex].value; 
	    } 
		openSearchPopup("/mprq/showBuyerMpRqUserRemarkPop.do", '?st_remark='+remark, "400,280,no");
		break;
	case "country": // 원산지
		openSearchPopup("/common/countryCodePop.do", "", "500,500,no"); 
		break;
	case "attach":
	    if(eval(tot_cnt) < 2) {
	        image_key = document.forms.contentForm.st_image_key.value;
	    }else{
	        image_key = document.forms.contentForm.st_image_key[gridIndex].value;
	    }

		var type="RFQ";
		var viewType="VI";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	case "category": // 카테고리
		var buyer = "<%=buyer%>";
		var user_id = "<%=user_id%>"
	    if (buyer=='KRDDDD0001' || buyer=='KRHYUN0026' || buyer=='KRHYUN0033' || buyer=='KRKYUN0002' ||						
				buyer=='KRISUC0002' || buyer=='KRISUC0007' ){
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do",'?st_buyer='+buyer,"400,500,no");			
		} else if (buyer=='KRDOOS0004' || buyer=='KRILJI0003' || buyer=='KRILJI0015' || buyer=='KRILJI0026' || 				
				buyer=='KRILJI0043' || buyer=='KRHSDE0003' ){	
			openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do",'?st_buyer='+buyer,'728,710,no');			
		} else if (buyer == 'KRDOOD0001'){ // 두산중공업 전용						
			openSearchPopup("/coco/showCommonCoCoBuyerCategoryChoiceDooPop.do",'?st_buyer='+buyer,"728,510,no");			
		} else {				
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop.do",'?st_buyer='+buyer+'&st_user_id='+user_id,"728,510,no");			
		}				
		break;
	}
}
function setPopupReturn(code, text, value, value1, value2){
    var tot_cnt = $("#display_item_cnt").val();
	if (popupSel == "country") {

	    if(eval(tot_cnt) < 2){
	        document.forms.contentForm.st_origin_name.value   = value;
	        document.forms.contentForm.st_origin_code.value   = code;
	    }else {
	        document.forms.contentForm.st_origin_name[gridIndex].value = value ;
	        document.forms.contentForm.st_origin_code[gridIndex].value = code ;
	    }
	} else if (popupSel == "buyerMpRqUserRemarkPop"){
	    if(eval(tot_cnt)<=1) { 
	        document.forms.contentForm.st_btoa_remark.value  = code; 
	    }else { 
	        document.forms.contentForm.st_btoa_remark[gridIndex].value = code; 
	    } 
	    
	}else if (popupSel == "attach") {	//파일 첨부
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		 $("input[name=st_image_key]").eq(gridIndex).val(code);
	 	 if(code ==""){
			 $("img[id=Image2]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=Image2]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}else if (popupSel == "category") {
	    if(eval(tot_cnt) < 2){
	        document.forms.contentForm.st_category_name.value   = text;
	        document.forms.contentForm.st_category_code.value   = code;
	    }else {
	        document.forms.contentForm.st_category_name[gridIndex].value = text;
	        document.forms.contentForm.st_category_code[gridIndex].value = code;
	    }
	}
	gridIndex = "";
}
function setPopupCalendar(year,month,day){
	var dt = year.toString()+month.toString()+day.toString();
    var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
    
    if(parseInt(dt) < parseInt(nowDate)) {
        alert("<%=CommonLang.msg("MSG40")%>");	//회신요청일은 현재일 이후여야 합니다.
        return;
    }
    
	$("input[name=st_btoa_end_date_text]").eq(gridIndex).val(year+'/'+month+'/'+day);
	$("input[name=st_btoa_end_date]").eq(gridIndex).val(dt);
	
} 
function displayNumbering(type, row) {
    var tot_cnt      = $("#display_item_cnt").val();
	var imsi_target_qty = "";
	var imsi_buyer_target_price = "";
     if(eval(tot_cnt) < 2){
        imsi_target_qty             = kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty_text.value));          // 수량 - 고정
        imsi_buyer_target_price     = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));  // 시장단가
        if(type=="BUYER_TARGET_PRICE") {
            if(imsi_buyer_target_price!="") {
                document.forms.contentForm.st_buyer_target_price.value           = kepTrimStr(imsi_buyer_target_price);
                document.forms.contentForm.st_buyer_target_price_text.value      = kepCommaNum(kepTrimStr(imsi_buyer_target_price));
            }
        }else {
            if(imsi_target_qty!="") {
                document.forms.contentForm.st_item_qty.value             = kepTrimStr(imsi_target_qty);
                document.forms.contentForm.st_item_qty_text.value        = kepCommaNum(kepTrimStr(imsi_target_qty));
            }
        }
    }else{
        imsi_target_qty             = kepTrimStr(kepFilterNum(document.forms.contentForm.st_item_qty_text[row].value));            // 수량 - 고정
        imsi_buyer_target_price     = kepTrimStr(kepFilterNum(document.forms.contentForm.st_buyer_target_price_text[row].value));  // 시장단가
        if(type=="BUYER_TARGET_PRICE") {
            if(imsi_buyer_target_price!="") {
                document.forms.contentForm.st_buyer_target_price[row].value         = kepTrimStr(imsi_buyer_target_price);
                document.forms.contentForm.st_buyer_target_price_text[row].value        = kepCommaNum(kepTrimStr(imsi_buyer_target_price));
            }
        }else {
            if(imsi_target_qty!="") {
                document.forms.contentForm.st_item_qty[row].value           = kepTrimStr(imsi_target_qty);
                document.forms.contentForm.st_item_qty_text[row].value      = kepCommaNum(kepTrimStr(imsi_target_qty));
            }
        }
    }
}
//등록요청일 복사
function btoaDateCopy() {
	var tot_cnt = $("#display_item_cnt").val(); 
	var btoa_end_date_text  = "";
	var btoa_end_date       = "";
	var checked_count       = 0;

	if(tot_cnt>1) {
		for(var j = 0; j < tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				checked_count++;
				btoa_end_date   =  document.forms.contentForm.st_btoa_end_date[j].value;
				btoa_end_date_text   =  document.forms.contentForm.st_btoa_end_date_text[j].value;
				break;
			}
		}
	}else {
		alert("<%=CommonLang.msg("MSG37")%>");	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
		return;
	}

	if(checked_count==0) {
		alert("<%=CommonLang.msg("MSG36")%>");	//회신요청일을 복사할 품목을 선택하여 주십시요.
		return;
	}

	if(tot_cnt>=2) {
		for(var j=0; j<tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				document.forms.contentForm.st_btoa_end_date[j].value         = btoa_end_date;
				document.forms.contentForm.st_btoa_end_date_text[j].value         = btoa_end_date_text;
			}else {
				document.forms.contentForm.st_btoa_end_date[j].value         = "";
				document.forms.contentForm.st_btoa_end_date_text[j].value         = "";
			}
		}
	}
}
//원산지 복사
function originCopy() {
	var tot_cnt = $("#display_item_cnt").val(); 
	var origin_code = "";
	var origin_name = "";
	var checked_count       = 0;

	if(tot_cnt>1) {
		for(var j = 0; j < tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				checked_count++;
				origin_code   =  document.forms.contentForm.st_origin_code[j].value;
				origin_name   =  document.forms.contentForm.st_origin_name[j].value;
				break;
			}
		}
	}else {
		alert("<%=CommonLang.msg("MSG37")%>");	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
		return;
	}

	if(checked_count==0) {
		alert("<%=CommonLang.msg("MSG490")%>");	//원산지를 복사할 품목을 선택하여 주십시요.
		return;
	}

	if(tot_cnt>=2) {
		for(var j=0; j<tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				document.forms.contentForm.st_origin_code[j].value         = origin_code;
				document.forms.contentForm.st_origin_name[j].value         = origin_name;
			}else {
				document.forms.contentForm.st_origin_code[j].value         = "";
				document.forms.contentForm.st_origin_name[j].value         = "";
			}
		}
	}
}
//비고 복사.
function remarkCopy() {
	var tot_cnt = $("#display_item_cnt").val(); 
	var btoa_remark         = "";
	var checked_count       = 0;

	if(tot_cnt>1) {
		for(var j = 0; j < tot_cnt; j++) { 
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				checked_count++;
				btoa_remark =  document.forms.contentForm.st_btoa_remark[j].value;
				break;
			}
		}
	}else {
		alert("<%=CommonLang.msg("MSG37")%>");	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
		return;
	}
	if(checked_count==0) {
		alert("<%=CommonLang.msg("MSG38")%>");	//복사할 비고를 선택하여 주십시요.
		return;
	}

	if(tot_cnt>=2) {
		
		for(var j=0; j<tot_cnt; j++) {
			var box = eval("document.forms.contentForm.checkbox" + j);
			if(box.checked == true){
				document.forms.contentForm.st_btoa_remark[j].value = btoa_remark;
			}else {
				document.forms.contentForm.st_btoa_remark[j].value = "";
			}
		}

	}
}
function kepCheckAll2(){
	//전체선택/해제
	var tot_cnt      = $("#display_item_cnt").val();
	
	var box = eval("document.forms.contentForm.check_status");
    
	if(box.checked == true) {
		if (tot_cnt < 2) {
			var box = eval("document.contentForm.checkbox0");
			if(box.checked == false) box.checked = true;
		} else {
		   for(var j = 0; j < tot_cnt; j++){
		       var box = eval("document.contentForm.checkbox" + j);
		       if(box.checked == false) box.checked = true;
		   }
		}
	}else{
		if (tot_cnt < 2) {
			  var box = eval("document.contentForm.checkbox0");
		       if(box.checked == true) box.checked = false;
		} else {
		   for(var j = 0; j < tot_cnt; j++){
		       var box = eval("document.contentForm.checkbox" + j);
		       if(box.checked == true) box.checked = false;
		   }
		}
	}
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	if (pMethod == "reg"){
		var passFlag = response.msg.passflag;
		
		if (passFlag == "Y"){
			var type = "NG"; // 견적의뢰
			var buyer = "<%=buyer%>";
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
		} else if (passFlag == "C"){
			if (!confirm("<%=CommonLang.msg("MSG356")%>")){	//전자 결재 처리 하시겠습니까? \n\n바로 견적의뢰 하시려면 취소버튼을 눌러 주십시오.
				// 바로생성	
				btnEvent = "noPassReq";
				kepAjaxFormCall("/mprq/saveNoPassReq.do","processForm",btnEvent); 
			} else {
				// 결재 연결
				btnEvent = "passReq";
				kepAjaxFormCall("/mprq/savePassReq.do","processForm",btnEvent); 
			}
		} else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				alert(msg+"<%=CommonLang.msg("MSG548")%>");
			}
			self.close();
		}
	} else if (pMethod == "noPassReq"){
		var msg = response.msg.msg;   
		if (msg != ""){
			alert(msg);
		}
// 		reload();
		self.close();
	} else if (pMethod == "passReq"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=buyer%>";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
	}
};
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("<%=CommonLang.msg("MSG60")%>");	//견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.
	
} 
//견적의뢰
function checkForm() {
	btnEvent = "reg";
	var tot_cnt      = $("#display_item_cnt").val();
    var nowDate             = kepGetNowTimeStr('YYYYMMDD','');
	var checked_count = 0;
    
    if(tot_cnt==1) {
        if(document.forms.contentForm.checkbox.checked==true) checked_count = 1;
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.checkbox[j].checked==true) {
                checked_count++;
            }
        }
    }
    if(checked_count==0) {
        alert("<%=CommonLang.msg("MSG43")%>");	//견적의뢰할 품목을 선택하여 주십시요.
        return;
    }
    
	if(tot_cnt <= 1) {
		if(eval("document.forms.contentForm.checkbox").checked==true) {
			var buyer_item_no					= document.forms.contentForm.st_buyer_item_no.value;         // 품목코드
			var itemCodeEl = document.forms.contentForm.st_buyer_item_no;
			itemCodeEl.value = kepNormalizeItemCode(itemCodeEl.value);
			buyer_item_no = itemCodeEl.value;
			if(kepHasHangul(buyer_item_no)) {
				itemCodeEl.focus();
				var text = "품목코드에는 한글을 사용할 수 없습니다.";
				alert(text);
				return;
			}
			if(buyer_item_no == '' || buyer_item_no == null) {
				buyer_item_no  = 'NO_CODE';	
			}
			var item_qty								= document.forms.contentForm.st_item_qty.value;              // 수량
			var item_qty_text					= kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty_text.value));              // 수량
			var description							= document.forms.contentForm.st_description.value;           // 품목명
			var buyer_target_price			= document.forms.contentForm.st_buyer_target_price.value;    // 실적단가
			var buyer_target_price_text	= kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));    // 실적단가
			var btoa_end_date					= document.forms.contentForm.st_btoa_end_date.value;         // 회신요처일
			var specification						= document.forms.contentForm.st_specification.value;         // 규격
			var category_code      = document.forms.contentForm.st_category_code.value;       // 카테고리

			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				alert("<%=CommonLang.msg("MSG40")%>");	//회신요청일은 현재일 이후여야 합니다.
				return;
			}

			var unit_measure					= document.forms.contentForm.st_unit_measure.value;          // 단위
			var image_key						= document.forms.contentForm.st_image_key.value;              // 첨부파일 이미지 키
			var maker_name					= document.forms.contentForm.st_maker_name.value;            // 제조사
			var origin_code					= document.forms.contentForm.st_origin_code.value;           // 원산지
			var agent_name					= document.forms.contentForm.st_agent_name.value;            // 기존협력사
			var btoa_remark					= document.forms.contentForm.st_btoa_remark.value;           // 비고
			var make_goods					= document.forms.contentForm.st_make_goods_flag.value; // 제작품

			if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
				alert("<%=CommonLang.msg("MSG555")%>");	//수량을 정수형으로 입력하여 주십시오.
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty_text.focus();
				return;
			}
			
			if(item_qty_text == '0') {
				//수량에 1 이상의 숫자를 입력해 주십시요
				alert("<%=CommonLang.msg("MSG192")%>");
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty_text.focus();
				return;
			}

			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				alert("<%=CommonLang.msg("MSG62")%>");	//품목명을 입력하여 주십시오.
				document.forms.contentForm.st_description.focus();
				return;
			}

			if(!kepIsValueNull(kepTrimStr(buyer_target_price_text))) {
				if(!kepIsNumChkStr(buyer_target_price_text, 3)) {
					alert("<%=CommonLang.msg("MSG49")%>");	//실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					document.forms.contentForm.st_buyer_target_price.value   = "";
					document.forms.contentForm.st_buyer_target_price_text.focus();
					return;
				}
			}else {
				buyer_target_price = 0;
			}

			// 단위 체크
			if(kepIsValueNull(unit_measure)) {
				alert("<%=CommonLang.msg("MSG491")%>");	//단위를 입력하여 주십시오..
				return;
			}
			
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				alert("<%=CommonLang.msg("MSG50")%>");	//규격을 입력하여 주십시오.
				document.forms.contentForm.st_specification.focus();
				return;
			}

			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				alert("<%=CommonLang.msg("MSG51")%>");	//회신요청일을 입력하여 주십시오..
				return;
			}
			
			if(make_goods == "Y"){
				document.forms.contentForm.st_btoa_remark.value = "제작품, " +btoa_remark;
			}
			
			// 요청단가 필수값 체크
			<%if((p04405301 == true)) {%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					alert("<%=CommonLang.msg("MSG495")%>");// 요청단가를 입력하여 주십시오.
					document.forms.contentForm.st_buyer_target_price_text.focus();
					return;
				}
				//요청단가 필드 한번더 입력
				document.forms.contentForm.st_buyer_target_price.value = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));
			<%}
			// 제조사 필수값 체크
			if((p04405401 == true)) {%>
				if(kepIsValueNull(kepTrimStr(maker_name))) {
					alert("<%=CommonLang.msg("MSG496")%>");// 제조사를 입력하여 주십시오.
					document.forms.contentForm.st_maker_name.focus();
					return;
				}
			<%}	
			// 카테고리 필수값 체크
			if((p04404201 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(category_code))) {
					//카테고리 필수값 체크
					alert("<%=CommonLang.msg("MSG489")%>");
					document.forms.contentForm.st_category_name.focus();
					return;
				}
			<%
			}
			%>
			<%
			//MSDS, 안전인증서 선택여부 셋팅
			if((p04405701 == true)) {
			%>
				//안전인증서 셋팅.
				if(document.forms.contentForm.st_safety_yn.checked == true){
					document.forms.contentForm.st_safety_flag.value = "Y";
				}else{
					document.forms.contentForm.st_safety_flag.value = "N";
				}

			<%
			}else{
			%>
				//안전인증서 체크로직이 없으므로 무조건 N처리
				document.forms.contentForm.st_safety_flag.value = "N";

			<%
			}
			%>
		}
	} else {
		for(var i =0; i < tot_cnt; i++) {

			if(document.forms.contentForm.checkbox[i].checked==true) {
				var buyer_item_no					= document.forms.contentForm.st_buyer_item_no[i].value;                          // 품목코드
				var itemCodeEl = document.forms.contentForm.st_buyer_item_no[i];
				itemCodeEl.value = kepNormalizeItemCode(itemCodeEl.value);
				buyer_item_no = itemCodeEl.value;
				if(kepHasHangul(buyer_item_no)) {
					itemCodeEl.focus();
					var text = (i+1)+"번째 행의 품목코드에는 한글을 사용할 수 없습니다.";
					alert(text);
					return;
				}
				if(buyer_item_no == '' || buyer_item_no == null) {
					buyer_item_no  = 'NO_CODE';	
				}
				for(var j = i+1; j < tot_cnt; j++) { // 품목코드 중복 체크
					if(document.forms.contentForm.checkbox[j].checked==true) {
						var tmp_buyer_item_no = document.forms.contentForm.st_buyer_item_no[j].value;
						if(tmp_buyer_item_no.toUpperCase() != "NO_CODE") {	
							if(buyer_item_no != "" && tmp_buyer_item_no != "") {
								if(buyer_item_no == tmp_buyer_item_no) {
									alert("동일 품목코드로 견적의뢰할 수 없습니다. 품목코드 중복 확인 바랍니다.")
									return;
								}
							}
						}
						
					}
				}
				var item_qty								= document.forms.contentForm.st_item_qty[i].value;                               // 수량
				var item_qty_text					= kepFilterNum(document.forms.contentForm.st_item_qty_text[i].value);               // 수량
				var description							= document.forms.contentForm.st_description[i].value;                            // 품목명
				var buyer_target_price			= document.forms.contentForm.st_buyer_target_price[i].value;                     // 실적단가
				var buyer_target_price_text	= kepFilterNum(document.forms.contentForm.st_buyer_target_price_text[i].value);     // 실적단가
				var btoa_end_date					= document.forms.contentForm.st_btoa_end_date[i].value;                          // 회신요처일
				var specification						= document.forms.contentForm.st_specification[i].value;                          // 규격
				var category_code      = document.forms.contentForm.st_category_code[i].value;       // 카테고리

				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					alert("<%=CommonLang.msg("MSG40")%>");	//회신요청일은 현재일 이후여야 합니다.
					return;
				}
				var unit_measure						= document.forms.contentForm.st_unit_measure[i].value;           // 단위
				var image_key							= document.forms.contentForm.st_image_key[i].value;           // 첨부파일 이미지 키
				var maker_name						= document.forms.contentForm.st_maker_name[i].value;         // 제조사
				var origin_code						= document.forms.contentForm.st_origin_code[i].value;        // 원산지
				var agent_name						= document.forms.contentForm.st_agent_name[i].value;         // 기존협력사
				var btoa_remark						= document.forms.contentForm.st_btoa_remark[i].value;        // 비고
				var make_goods					= document.forms.contentForm.st_make_goods_flag[i].value; // 제작품

				if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
					alert((i+1)+"<%=CommonLang.msg("MSG556")%>");	//번째 행의 수량을 정수형으로 입력하여 주십시오.
					document.forms.contentForm.st_item_qty[i].value="";
					document.forms.contentForm.st_item_qty_text[i].focus();
					return;
				}
				
				if(item_qty_text == '0') {
					//수량에 1 이상의 숫자를 입력해 주십시요
					alert("<%=CommonLang.msg("MSG192")%>");
					document.forms.contentForm.st_item_qty[i].value ="";
					document.forms.contentForm.st_item_qty_text[i].focus();
					return;
				}

				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					alert((i+1)+"<%=CommonLang.msg("MSG492")%>");	//번째 행의 품목명을 입력하여 주십시오.
					document.forms.contentForm.st_description[i].focus();
					return;
				}

				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						alert((i+1)+"<%=CommonLang.msg("MSG55")%>");	//번째 행의 실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						document.forms.contentForm.st_buyer_target_price[i].value    = "";
						document.forms.contentForm.st_buyer_target_price_text[i].focus();
						return;
					}
				}else {
					buyer_target_price = 0;
				}

				// 단위 체크
				if(kepIsValueNull(unit_measure)) {
					alert((i+1)+"<%=CommonLang.msg("MSG493")%>");	//번째 행의 단위를 입력하여 주십시오..
					return;
				}
				
				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					alert((i+1)+"<%=CommonLang.msg("MSG56")%>");	//번째 행의 규격을 입력하여 주십시오.
					document.forms.contentForm.st_specification[i].focus();
					return;
				}

				// 등록요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					alert((i+1)+"<%=CommonLang.msg("MSG57")%>");	//번째 행의 회신요청일을 입력하여 주십시오..
					return;
				}
				
				if(make_goods == "Y"){
					document.forms.contentForm.st_btoa_remark[i].value = "제작품, " +btoa_remark;
				}
				
				// 요청단가 필수값 체크
			<%if((p04405301 == true)) {%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price_text))) {
						alert("<%=CommonLang.msg("MSG495")%>");// 요청단가를 입력하여 주십시오.
						document.forms.contentForm.st_buyer_target_price_text[i].focus();
						return;
					}
					document.forms.contentForm.st_buyer_target_price[i].value = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text[i].value));
			<%}
				// 제조사 필수값 체크
				if((p04405401 == true)) {%>
					if(kepIsValueNull(kepTrimStr(maker_name))) {
						alert("<%=CommonLang.msg("MSG496")%>");// 제조사를 입력하여 주십시오.
						document.forms.contentForm.st_maker_name[i].focus();
						return;
					}
			<%}	
				// 카테고리 필수값 체크
				if((p04404201 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(category_code))) {
						//카테고리 필수값 체크
						alert("<%=CommonLang.msg("MSG489")%>");
						document.forms.contentForm.st_category_name[i].focus();
						return;
					}
				<%
				}
				%>
				<%
				//MSDS, 안전인증서 선택여부 셋팅
				if((p04405701 == true)) {
				%>
					//안전인증서 셋팅.
					if(document.forms.contentForm.st_safety_yn[i].checked == true){
						document.forms.contentForm.st_safety_flag[i].value = "Y";
					}else{
						document.forms.contentForm.st_safety_flag[i].value = "N";
					}
				<%
				}else{
				%>
					//안전인증서 체크로직이 없으므로 무조건 N처리
					document.forms.contentForm.st_safety_flag[i].value = "N";
				<%
				}
				%>
			}
		}
	}
	var chkFlag = false;
	var chkGridValue = {};
	var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
			alert("<%=CommonLang.msg("MSG13")%>"); //그리드 데이터 변환에 실패하였습니다.[getFormToArr]
			return;
		}
		kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationStnd.do", "processForm", btnEvent);

	}
	function kepApprovalReturn(flag, docu_no) {
		// 	reload();
		self.close();
	}
</script>
<body onload="kep_onload_view();">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height: 702px;">
		<div id="popHeader">
			<h1 class="title"><%=CommonLang.get("HTITLE34")%><!-- 엑셀업로드 -->
			</h1>
			<p class="popClose">
				<a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a>
			</p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer" style="height: 628px">
			<div id="searchBtnA02">
				<form method="post" action="/mpso/setExcelUp.do" name="UploadForm" id="UploadForm" modelAttribute="uploadForm" enctype="multipart/form-data">
					<table class="board_write" summary="파일업로드" id="fileTable">
						<caption>엑셀업로드 올리기</caption>
						<colgroup>
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<td scope="row"><input name="files" id="files" type="file" class="input_type_text" onchange="setExcelUpValid()" /> <a
									href="javascript:setExcelUp()"><img src="/resources/images/but_reg.gif" alt="등록" /></a></td>
							</tr>
					</table>

				</form>
			</div>
			<!--조회영역-->
			<!--grid-->
			<form name="contentForm" id="contentForm" method=post>
				<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer%>"> <input type=hidden name="st_user_id" id="st_user_id"
					value="<%=user_id%>"> <input type=hidden name="cellCount" id="cellCount" value="10">
				<div class="scrollArea" style="height: 550px">
					<table class="cont_t_list02" style="width: 100%">
						<caption>엑셀업로드 리스트</caption>
						<colgroup>
							<col width="3%" />
							<col width="4%" />
							<col width="10%" />
							<col width="20%" />
							<col width="8%" />
							<col width="8%" />
							<col width="6%" />
							<col width="10%" />
							<col width="10%" />
							<col width="6.5%" />
							<col width="6.5%" />
							<col width="12%" />
						</colgroup>
						<thead>
							<tr>
								<th rowspan="2"><input type="checkbox" name="check_status" id="check_status" value="선택" style="cursor: hand;" onclick="kepCheckAll2();">
								</th>
								<th rowspan="2"><%=CommonLang.get("HTITLE44")%><!-- 번호 --></th>
								<th><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
								<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
								<th><%=CommonLang.get("HTITLE46")%><!-- 단가구분 --></th>
								<th>
									<%
										if ((p04405301 == true)) {
									%><font color="#FF6600">*</font>
									<%
										}
									%><%=CommonLang.get("HTITLE50")%><!-- 요청단가 -->
								</th>
								<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE52")%><!-- 단위 --></th>
								<th>
									<%
										if ((p04405401 == true)) {
									%><font color="#FF6600">*</font>
									<%
										}
									%><%=CommonLang.get("HTITLE15")%><!-- 제조사 -->
								</th>
								<th style="text-decoration: underline;"><a href="javascript:originCopy();"><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></a></th>
								<th><%=CommonLang.get("HTITLE842")%></th>	<!-- 선입고 -->
								<th><%=CommonLang.get("HTITLE968")%></th>	<!-- 제작품 -->
								<th><%=CommonLang.get("HTITLE967")%>&nbsp;<img src="/resources/images/but_query.png" title="기재하신 협력사로 선정됩니다."><!-- 지정협력사 --></th>
							</tr>
							<tr>
								<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
								<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
								<th><font color="#FF6600">*</font><a href="javascript:btoaDateCopy();"><font style="text-decoration: underline;"><%=CommonLang.get("HTITLE51")%><!-- 회신요청일 --></font></a></th>
								<th><%if ((p04404201 == true)) {%><font color="#FF6600">*</font><%}%><%=CommonLang.get("HTITLE510")%><!-- 카테고리 -->
								</th>
								</th>
								<th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></th>
								<th colspan="2" style="text-decoration: underline;"><a href="javascript:remarkCopy();"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></a></th>
								<th colspan="2"><%=CommonLang.get("HTITLE913")%></th>	<!-- 품목자료 -->
								<th><%=CommonLang.get("HTITLE121")%>&nbsp;<img src="/resources/images/but_query.png" title="기재하신 협력사가 미선정될 수 있습니다.&#10;필수 지정을 희망하시는 경우 지정협력사 란에 기재 부탁드립니다."></th>	<!-- 기존협력사 -->
							</tr>
						</thead>
						<tbody>
							<%
								if (_dataList == null || _dataList.size() == 0) {
							%>
							<tr bgcolor="#FFFFFF">
								<td colspan="12" align="center" height="280"><span class="font1"><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span></td>
							</tr>
							<%
								} else {
									for (int j = 0; j < _dataList.size(); j++) {
										Map<String, String> rowData = _dataList.get(j);
							%>
							<tr>
								<td rowspan="2" title=""><input type="checkbox" name="checkbox" id="checkbox<%=j%>"> <input type="hidden" name="display_item_cnt"
									id="display_item_cnt" value="<%=_dataList.size()%>"> <input type="hidden" name="excel_up" id="excel_up" value="Y">
								<td rowspan="2" title="번호"><%=j + 1%></td>
								<td title="품목코드"><input type="text" name='st_buyer_item_no' id='st_buyer_item_no' class="bbb" style="width: 95%;"
									value="<%=rowData.get("BUYER_ITEM_NO")%>"></td>
								<td title="품목명"><input type="text" name='st_description' id='st_description' class="bbb" maxlength="50" style="width: 90%;"
									value="<%=rowData.get("DESCRIPTION")%>"></td>
								<td title="단가구분"><select id="st_req_price_type" name="st_req_price_type"><%=CommonUtil.getCodeComboQueryIdList("getReqPriceTypeInfo", "", rowData.get("REQ_PRICE_TYPE"))%></select>
								</td>
								<td title="요청단가"><input type="hidden" name='st_buyer_target_price' id='st_buyer_target_price'
									value="<%=rowData.get("BUYER_TARGET_PRICE")%>"> <input type="text" name='st_buyer_target_price_text' id='st_buyer_target_price_text'
									<%=read_only%> style="width: 92%; text-align: right;" onblur="displayNumbering('BUYER_TARGET_PRICE', '<%=j%>');"
									value="<%=CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"), true, 0, 3)%>"></td>
								<td title="단위"><select id="st_unit_measure" name="st_unit_measure"><%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo", "", rowData.get("UNIT_MEASURE"))%></select>
								</td>
								<td title="제조사"><input type="text" name='st_maker_name' id='st_maker_name' value="<%=rowData.get("MAKER_NAME")%>" maxlength="40"
									class="bbb" style="width: 95%;"></td>
								<td title="원산지"><input type="hidden" name="st_origin_code" id="st_origin_code" style="width: 85%;"
									value="<%=rowData.get("ORIGIN_CODE")%>"> <input type="text" name="st_origin_name" id="st_origin_name"
									value="<%=rowData.get("ORIGIN_NAME")%>" maxlength="20" style="width: 85%; cursor: hand;" readonly onclick="doPop('country','<%=j%>');">
								</td>
								<td title="선입고">
									<select id="st_pre_gr_flag" name="st_pre_gr_flag"><%=CommonUtil.getCodeComboList("CA03", "", "R", "", "", "")%></select> 선입고
								</td>
								<td title="제작품">
									<select id="st_make_goods_flag" name="st_make_goods_flag"><%=CommonUtil.getCodeComboList("CA03", "", "R", "", "", "")%></select> 제작품
								</td>
								<td title="지정협력사"><input type="text" name='st_buyer_assign_agent_code' id='st_buyer_assign_agent_code' style="width: 95%;" class="bbb"
									value="<%=rowData.get("BUYER_ASSIGN_AGENT_CODE")%>"></td>
							</tr>
							<tr>
								<td title="수량"><input type="hidden" name='st_item_qty' id='st_item_qty' value="<%=rowData.get("ITEM_QTY")%>" style="width: 95%;">
									<input type="text" name='st_item_qty_text' id='st_item_qty_text' value="<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"), true, 0, 3)%>"
									style="width: 95%; text-align: right;" onblur="displayNumbering('ITEM_QTY', '<%=j%>');"></td>
								<td title="규격"><input type="text" name='st_specification' id='st_specification' value="<%=rowData.get("SPECIFICATION")%>" maxlength="250"
									class="bbb" style="width: 90%;"></td>
								<td title="회신요청일"><input type="hidden" name='st_btoa_end_date' id='st_btoa_end_date' value=""> <input type="text"
									name='st_btoa_end_date_text' id='st_btoa_end_date_text' value="" style="width: 95%; cursor: hand; text-align: center;"
									onclick="doPop('calendar','<%=j%>');" readonly></td>
								<td title="카테고리"><input type="hidden" name='st_category_code' id='st_category_code' style="width: 95%;"> <input type="text"
									name='st_category_name' id='st_category_name' style="width: 55%;" readonly><a href="javascript:doPop('category','<%=j%>');"><img
										src="/resources/images/btn_search03.gif" alt="검색" /></a></td>
								<td title="첨부파일"><input type='hidden' name='st_image_key' id='st_image_key' value=""> <a
									href="javascript:doPop('attach','<%=j%>')"><img src="/resources/images/disk_off.gif" name="Image2" id="Image2" width="14" height="14"
										border="0"></a>
								</td>
								<td title="비고" colspan="2">									 
 									<input type="text" name='st_btoa_remark' id='st_btoa_remark' value="<%=rowData.get("TMP_REMARK")%>" maxlength="400" class="bbb"
									style="width: 93%;"> 
								</td>
								<td colspan="2" title="품목자료" >
									<select id="st_msds_flag" name="st_msds_flag"><%=CommonUtil.getCodeComboList("CA03", "", "R", "", "", "")%></select> MSDS									
									<input type="hidden" name="st_safety_flag" value="">
							        <%        //안전인증서 표기 여부
							        if((p04405701 == true)) {
							        %>
							        	<input type="checkbox" name="st_safety_yn"  id="st_safety_yn"> 안전인증서    
							        <%
							        }
							        %>  
								</td>
								<td title="기존협력사"><input type="text" name='st_agent_name' id='st_agent_name' style="width: 95%;" class="bbb"
									value="<%=rowData.get("AGENT")%>"></td>
							</tr>
							<%
								}
								}
							%>
						</tbody>
					</table>
				</div>
			</form>
			<form name="processForm" id="processForm" method="post">
				<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" /> <input type="hidden" name="buyer" id="buyer" value="" /> <input type="hidden"
					name="gubun" id="gubun" value="" />
				<div id="process"></div>
			</form>
			<!-- 버튼영역 -->
			<div class="btnArea">
				<div class="fr">
					<span class="btn_03 mt05"> <a href="javascript:checkForm();"><%=CommonLang.get("HTITLE39")%><!-- 견적의뢰 --></a>
					</span>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
