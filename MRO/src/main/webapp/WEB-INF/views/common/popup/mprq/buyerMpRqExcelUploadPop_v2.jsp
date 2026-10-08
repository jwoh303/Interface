<%--
**********************************************
* 메뉴 : 
* 화면 : 엑셀업로드_v2
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
<%@ include file="../../include/head_v2.jspf" %>
</head>
<%
	@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String _result = CommonUtil.nvl((String) request.getAttribute("result"),""); // 조회된 결과 
String buyer=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String user_id=  CommonUtil.nvl((String) request.getParameter("user_id"), _sessionInfo.getUserId());
String read_only =""; 
//카테고리 필수 특수로직.
boolean p04404201 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4042-01");
//요청단가 필수 특수로직.
boolean p04405301 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4053-01");
//제조사 필수 특수로직.
boolean p04405401 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4054-01");

//안전인증서 표기 여부
boolean p04405701 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4057-01");
//카테고리 선택 팝업 통제 
boolean bqt00003 = CommonUtil.getSpecialCheckReturn(buyer,"BQT00003");
//자동채번 고객사
boolean getCodeCDNO = CommonUtil.getCode3CheckReturn("CDNO", buyer, "KRKORE0001");
//비고 기본문구 특수로직.
String p060000068 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000068", "COL01_DATA");
//고객사 단위 사용 특수로직.
boolean p04405501 = CommonUtil.getSpecialCheckReturn(buyer,"P04-4055-01");
//고객사 단위 사용(코드) 특수로직.
boolean bqt00004 = CommonUtil.getSpecialCheckReturn(buyer,"BQT00004");
//품목 NO_CODE만 가능 특수로직.
boolean p060000132 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000132");
%>

<script type="text/javascript">

//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var popupSel = "";
var btnEvent = "";

var product_cnt = 0;
var product_amt = 0;
var getCodeCDNO= "<%=getCodeCDNO%>";
//최초 화면 함수
function kep_onload_view(){
	var result = "<%=_result%>";
	if(result == "fail"){
		//업로드 양식과 상이합니다. 파일을 확인해주세요
		var text = "<%=CommonLang.msg("MSG949")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	if(result == "error"){
		//품목명을 입력하여 주십시오.
		var text = "<%=CommonLang.msg("MSG62")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	var tot_cnt      = $("#display_item_cnt").val();
	
	for(var i = 0; i<tot_cnt; i++){
		$("#st_btoa_end_date"+i).val(getWorkingDay());
	}
	
	//자동채번 고객사들은 품목코드 수정 못함 cck --> 활성화 시켜놓고 추후 다시 비활성화 시킬 예정
// 	if(getCodeCDNO == "true"){
// 		$('#contentForm input[name="st_buyer_item_no"]').val("");
// 		$('#contentForm input[name="st_buyer_item_no"]').prop('readonly',true).css('background','#EAEAEA');
// 	}
	
<%-- 	if(<%=searchFlag%> == "Y") --%>
// 		kepSearch();
}	

function getWorkingDay() {	
	var date = new Date();	
	if(date.getDay() == 3 || date.getDay() == 4 || date.getDay() == 5) { // 수목금
		date.setDate(date.getDate() + 5);
	}
	else if(date.getDay() == 6) { // 토
		date.setDate(date.getDate() + 4);
	} else { // 일월화
		date.setDate(date.getDate() + 3);
	}
	
	var year = date.getFullYear();
	var month = date.getMonth();
	month += 1;
	if(month <= 9) {
		month = "0" + month;
	}
	
	var day = date.getDate();
	if(day <= 9) {
		day = "0" + day;
	}
	
	var result = year + '/'+ month + '/'+ day;
	return result;
}
function kepSearch()
{  
  $('#contentForm').attr("action", "/mprq/getBuyerMpRqExcelUploadPop_v2.do").submit();    
}

function setExcelUp() {  		 
	if (isEmpty($("#files").val())==true){
		//업로드 대상이 없습니다. 확인 부탁드립니다.
		var text = "<%=CommonLang.msg("MSG175")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}  	
	 
	$('#UploadForm').attr("action", "/mprq/setMpRqExcelUp_v2.do").submit(); 
}	
function setExcelUpValid() {
	if (IsExt($("#files").val())) { //파일명 체크
	    //해당 형식의 파일은 업로드할 수 없습니다.
	    var text = "<%=CommonLang.msg("MSG176")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
// 	    doAction("search");
	  }
	
	$('#UploadForm').attr("action", "/mprq/setMpRqExcelUp_v2.do").submit();
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
		openSearchPopup("/common/countryCodePop_v2.do", "", "500,500,no"); 
		break;
	case "attach":
	    if(eval(tot_cnt) < 2) {
	        image_key = document.forms.contentForm.st_image_key.value;
	    }else{
	        image_key = document.forms.contentForm.st_image_key[gridIndex].value;
	    }

		var type="RFQ";
		var viewType="VI";
		var src = '/common/fileUploadPop_v2.do?DOC_NO='+image_key+'&viewType='+viewType+'&TYPE='+type;
		openLayerPop(src,"600px","510px");
		
		break;
	case "category": // 카테고리
		var buyer = "<%=buyer%>";
		var user_id = "<%=user_id%>";
		
	 	if (<%=bqt00003%> == true){
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop_v2.do",'?st_buyer='+buyer,"520,725,no");			
		} else {				
			openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop_v2.do",'?st_buyer='+buyer+'&st_user_id='+user_id,"800,750,no");			
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
		 $("input[name=st_image_key]").eq(gridIndex).val(code);
		 var btn = document.getElementById('attach_btn'+gridIndex);
		 if (text > 0) {
		        // 파일이 있을 때
		        btn.classList.remove('FileOutline');
		        btn.classList.add('FileOutline_on');
		        btn.innerText = '<%=CommonLang.get("HTITLE1202")%>'+text+'<%=CommonLang.get("HTITLE1203")%>';
	    } else {
	        // 파일이 없을 때
	        btn.classList.remove('FileOutline_on');
	        btn.classList.add('FileOutline');
	        btn.innerText = '<%=CommonLang.get("HTITLE166")%>'; // 첨부
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
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer+'&nu_tot_price='+product_amt+'&nu_tot_cnt='+product_cnt, "800,860,no");
		} else if (passFlag == "C"){
			btn3Layer();
<%-- 			if (!confirm("<%=CommonLang.msg("MSG356")%>")){	//전자 결재 처리 하시겠습니까? \n\n바로 견적의뢰 하시려면 취소버튼을 눌러 주십시오. --%>
// 				// 바로생성	
// 				btnEvent = "noPassReq";
// 				kepAjaxFormCall("/mprq/saveNoPassReq.do","processForm",btnEvent); 
// 			} else {
// 				// 결재 연결
// 				btnEvent = "passReq";
// 				kepAjaxFormCall("/mprq/savePassReq.do","processForm",btnEvent); 
// 			}
		} else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				//견적번호 + 번호로 견적 정상 생성 되었습니다.
				var text = msg+"<%=CommonLang.msg("MSG548")%>";
				openLayerPopText2(text,but1text,but1funcSearch,but1width);
				return;
			}
		}
	} else if (pMethod == "noPassReq"){
		var msg = response.msg.msg;   
		if (msg != ""){
			//견적번호 + 번호로 견적 정상 생성 되었습니다.
			var text = msg + " " +"<%=CommonLang.msg("MSG548")%>"; 
			openLayerPopText2(text,but1text,but1funcSearch,but1width);
			return;
		}
// 		reload();
	} else if (pMethod == "passReq"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=buyer%>";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer+'&nu_tot_price='+product_amt+'&nu_tot_cnt='+product_cnt, "800,860,no");
	}
};

function thisPopClose(){
	closePopText2();
	self.close();
}
function executeReg1(){ // 전자결재
	closePopText3();
	// 결재 연결
	btnEvent = "passReq";
	kepAjaxFormCall("/mprq/savePassReq_v2.do","processForm",btnEvent); 
}
function executeReg2(){ // 견적요청
	closePopText3();
	// 바로생성
	btnEvent = "noPassReq";
	kepAjaxFormCall("/mprq/saveNoPassReq_v2.do","processForm",btnEvent);
} 
function btn3Layer(){
	//견적요청 방식에 따라 전자결재 진행 여부를 선택해주세요. 
	var text = "<%=CommonLang.msg("MSG738")%>";
	var content = "<%=CommonLang.msg("MSG737")%>";
	var but1textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but2textC = "<%=CommonLang.get("HTITLE1201")%>"; //  전자결재
	var but3textC = "<%=CommonLang.get("HTITLE1010")%>"; // 견적요청
	var but1funcC = "javascript:closePopText3(); return false;";
	var but2funcC = "javascript:executeReg1(); return false";
	var but3funcC = "javascript:executeReg2(); return false";
	var but1widthC = "120px";
	var but2widthC = "120px";
	var but3widthC = "120px";
	openLayerPopText3(text,content, but1textC, but2textC,but3textC, but1funcC, but2funcC,but3funcC, but1widthC, but2widthC, but3widthC);
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.
	var text = "<%=CommonLang.msg("MSG60")%>";
	openLayerPopText2(text,but1text,but1func,but1width);
	
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
        //견적의뢰할 품목을 선택하여 주십시요.
        var text = "<%=CommonLang.msg("MSG43")%>";
    	openLayerPopText2(text,but1text,but1func,but1width);
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
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(buyer_item_no == '' || buyer_item_no == null) {
				buyer_item_no  = 'NO_CODE';
			}
			// NO_CODE로만 진행하도록 통제
			<%if (p060000132 == true) {%>
					if(buyer_item_no != 'NO_CODE') {
						//견적 시 품목코드 NO_CODE로만 진행 가능합니다.
						var text = "<%=CommonLang.msg("MSG592")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
			<%}%>
			var item_qty								= document.forms.contentForm.st_item_qty.value;              // 수량
			var item_qty_text					= kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty_text.value));              // 수량
			var description							= document.forms.contentForm.st_description.value;           // 품목명
			var buyer_target_price			= document.forms.contentForm.st_buyer_target_price.value;    // 실적단가
			var buyer_target_price_text	= kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));    // 실적단가
			var btoa_end_date					= document.forms.contentForm.st_btoa_end_date.value.replaceAll('/','');;         // 회신요처일
			var specification						= document.forms.contentForm.st_specification.value;         // 규격
			var category_code      = document.forms.contentForm.st_category_code.value;       // 카테고리

			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				//회신요청일은 현재일 이후여야 합니다.
				var text = "<%=CommonLang.msg("MSG40")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
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
				//수량을 정수형으로 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG555")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty_text.focus();
				return;
			}
			
			if(item_qty_text == '0') {
				//수량에 1 이상의 숫자를 입력해 주십시요
				var text = "<%=CommonLang.msg("MSG192")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty_text.focus();
				return;
			}

			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				//품목명을 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG62")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				document.forms.contentForm.st_description.focus();
				return;
			}

			if(!kepIsValueNull(kepTrimStr(buyer_target_price_text))) {
				if(!kepIsNumChkStr(buyer_target_price_text, 3)) {
					//실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					var text = "<%=CommonLang.msg("MSG49")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_buyer_target_price.value   = "";
					document.forms.contentForm.st_buyer_target_price_text.focus();
					return;
				}
			}else {
				buyer_target_price = 0;
			}

			// 단위 체크
			if(kepIsValueNull(unit_measure)) {
				//단위를 입력하여 주십시오..
				var text = "<%=CommonLang.msg("MSG491")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				//규격을 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG50")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				document.forms.contentForm.st_specification.focus();
				return;
			}

			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				//회신요청일을 입력하여 주십시오..
				var text = "<%=CommonLang.msg("MSG51")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			if(make_goods == "Y"){
				document.forms.contentForm.st_btoa_remark.value = "제작품, " +btoa_remark;
			}
			
			// 요청단가 필수값 체크
			<%if((p04405301 == true)) {%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					// 요청단가를 입력하여 주십시오.
					var text = "<%=CommonLang.msg("MSG495")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_buyer_target_price_text.focus();
					return;
				}
				//요청단가 필드 한번더 입력
				document.forms.contentForm.st_buyer_target_price.value = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));
			<%}
			// 제조사 필수값 체크
			if((p04405401 == true)) {%>
				if(kepIsValueNull(kepTrimStr(maker_name))) {
					// 제조사를 입력하여 주십시오.
					var text = "<%=CommonLang.msg("MSG496")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_maker_name.focus();
					return;
				}
			<%}	
			// 카테고리 필수값 체크
			if((p04404201 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(category_code))) {
					//카테고리 필수값 체크
					var text = "<%=CommonLang.msg("MSG489")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_category_name.focus();
					return;
				}
			<%
			}
			%>
			
			product_cnt = 1;
		}
	} else {
		product_cnt = 0;
		for(var i =0; i < tot_cnt; i++) {
			if(document.forms.contentForm.checkbox[i].checked==true) {
				product_cnt ++;
				var buyer_item_no					= document.forms.contentForm.st_buyer_item_no[i].value;                          // 품목코드
				var itemCodeEl = document.forms.contentForm.st_buyer_item_no[i];
				itemCodeEl.value = kepNormalizeItemCode(itemCodeEl.value);
				buyer_item_no = itemCodeEl.value;
				if(kepHasHangul(buyer_item_no)) {
					itemCodeEl.focus();
					var text = (i+1)+"번째 행의 품목코드에는 한글을 사용할 수 없습니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				if(buyer_item_no == '' || buyer_item_no == null) {
					buyer_item_no  = 'NO_CODE';
				}
				// NO_CODE로만 진행하도록 통제
				<%if (p060000132 == true) {%>
						if(buyer_item_no != 'NO_CODE') {
							//견적 시 품목코드 NO_CODE로만 진행 가능합니다.
							var text = "<%=CommonLang.msg("MSG592")%>";
							openLayerPopText2(text,but1text,but1func,but1width);
							return;
						}
				<%}%>
				for(var j = i+1; j < tot_cnt; j++) { // 품목코드 중복 체크
					if(document.forms.contentForm.checkbox[j].checked==true) {
						var tmp_buyer_item_no = document.forms.contentForm.st_buyer_item_no[j].value;
						if(tmp_buyer_item_no.toUpperCase() != "NO_CODE") {	
							if(buyer_item_no != "" && tmp_buyer_item_no != "") {
								if(buyer_item_no == tmp_buyer_item_no) {
									//동일 품목코드로 견적의뢰할 수 없습니다. 품목코드 중복 확인 바랍니다.
									var text = "<%=CommonLang.msg("MSG781")%>";
									openLayerPopText2(text,but1text,but1func,but1width);
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
				var btoa_end_date					= document.forms.contentForm.st_btoa_end_date[i].value.replaceAll('/','');                          // 회신요처일
				var specification						= document.forms.contentForm.st_specification[i].value;                          // 규격
				var category_code      = document.forms.contentForm.st_category_code[i].value;       // 카테고리

				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//회신요청일은 현재일 이후여야 합니다.
					var text = "<%=CommonLang.msg("MSG40")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
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
					//번째 행의 수량을 정수형으로 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG556")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_item_qty[i].value="";
					document.forms.contentForm.st_item_qty_text[i].focus();
					return;
				}
				
				if(item_qty_text == '0') {
					//수량에 1 이상의 숫자를 입력해 주십시요
					var text = "<%=CommonLang.msg("MSG192")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_item_qty[i].value ="";
					document.forms.contentForm.st_item_qty_text[i].focus();
					return;
				}

				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					//번째 행의 품목명을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG492")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_description[i].focus();
					return;
				}

				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						//번째 행의 실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						var text = (i+1)+"<%=CommonLang.msg("MSG55")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						document.forms.contentForm.st_buyer_target_price[i].value    = "";
						document.forms.contentForm.st_buyer_target_price_text[i].focus();
						return;
					}
				}else {
					buyer_target_price = 0;
				}

				// 단위 체크
				if(kepIsValueNull(unit_measure)) {
					//번째 행의 단위를 입력하여 주십시오..
					var text = (i+1)+"<%=CommonLang.msg("MSG493")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					//번째 행의 규격을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG56")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					document.forms.contentForm.st_specification[i].focus();
					return;
				}

				// 등록요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오..
					var text = (i+1)+"<%=CommonLang.msg("MSG57")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				if(make_goods == "Y"){
					document.forms.contentForm.st_btoa_remark[i].value = "제작품, " +btoa_remark;
				}
				
				// 요청단가 필수값 체크
			<%if((p04405301 == true)) {%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price_text))) {
						// 요청단가를 입력하여 주십시오.
						var text = "<%=CommonLang.msg("MSG495")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						document.forms.contentForm.st_buyer_target_price_text[i].focus();
						return;
					}
					document.forms.contentForm.st_buyer_target_price[i].value = kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text[i].value));
			<%}
				// 제조사 필수값 체크
				if((p04405401 == true)) {%>
					if(kepIsValueNull(kepTrimStr(maker_name))) {
						// 제조사를 입력하여 주십시오.
						var text = "<%=CommonLang.msg("MSG496")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						document.forms.contentForm.st_maker_name[i].focus();
						return;
					}
			<%}	
				// 카테고리 필수값 체크
				if((p04404201 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(category_code))) {
						//카테고리 필수값 체크
						var text = "<%=CommonLang.msg("MSG489")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						document.forms.contentForm.st_category_name[i].focus();
						return;
					}
				<%
				}
				%>
			}
		}
	}
	
	var chkFlag = false;
	var chkGridValue = {};
	var formArr = getFormToArr_v3("document.forms.contentForm",chkFlag,chkGridValue);
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
			//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
			var text = "<%=CommonLang.msg("MSG13")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
		kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationStnd_v2.do", "processForm", btnEvent);

	}
	function kepApprovalReturn(flag, docu_no) {
		// 	reload();
		self.close();
	}
	
	function validNumCheck(input){
		const value = input.value;
		// 숫자가 아닌 문자 포함 여부 체크
		if (!/^\d*$/.test(value)) {
		  input.value = '';
//	 	  alert('숫자만 입력 가능합니다.');
		  var text = "<%=CommonLang.msg("MSG951")%>";
		  openLayerPopText2(text,but1text,but1func,but1width);
		  return;
		}
		if (/^0/.test(value)) {
		    input.value = '';
//	 	    alert('0으로 시작할 수 없습니다.');
		    var text = "<%=CommonLang.msg("MSG952")%>";
			  openLayerPopText2(text,but1text,but1func,but1width);
		    return;
		  }
		
		// 값이 있고 1 미만인 경우 체크
		if (value !== '' && Number(value) < 1) {
		  input.value = '';
//	 	  alert('1 이상의 숫자를 입력해주세요.');
		  var text = "<%=CommonLang.msg("MSG953")%>";
		  openLayerPopText2(text,but1text,but1func,but1width);
		}
	}
	
	function radioChange(index,id,arg){
		$("#"+id+index).val(arg.value);
	}
	
</script>
<body onload="kep_onload_view();">
<div class="wrapPopup" style="height: 700px;">
	<div class="PopupTit"><%=CommonLang.get("HTITLE34")%><!-- 엑셀업로드 --><span><a href="javascript:self.close()" class="closePopup"><img src="/resources/imgs/Icon_close.png" alt="닫기버튼" /></a></span></div>
	
	<div class="PopupTableExcelBox mt20">
		<div class="PopupTitSubTxtCenter">엑셀양식을 다운받아 작성 후, 업로드 해주세요.</div>
		
		<!-- 상단 파일 업로드 폼 영역 -->
		<div class="PopupListBtnBox_Center mt10">
			<form method="post" action="/mpso/setExcelUp_v2.do" name="UploadForm" id="UploadForm" enctype="multipart/form-data" style="display:inline-block;">
				<button type="button" class="But_ExcelDown40" style="width: 150px;" onclick=""><a href="/resources/excel/work/NEWSOURCING/BuyerMpRqExcelUploadPop_v2.xls"> 양식 다운로드</a></button>
				<!-- 실제 파일 input은 숨기고 엑셀업로드 버튼 클릭 시 파일 창이 뜨도록 연결 -->
				<input name="files" id="files" type="file" onchange="setExcelUpValid()" style="display:none;" />
<!-- 				<button type="button" class="ButOutline_Medium" style="width: 150px;" onclick="document.getElementById('files').click();">파일선택</button> -->
				<button type="button" class="ButDarkGray_Medium" style="width: 150px;" onclick="document.getElementById('files').click();">엑셀업로드</button>
			</form>
		</div>

		<div class="Popup_GrayBox mt25">
			<p class="tit14">엑셀업로드 방법</p>
			<p class="txt400_14" style="display: flex;"><img src="/resources/imgs/Icon_Download_04.png" /><span class="txt600_14 ml10" style="width:46px;">STEP 1</span><span class="txt500_14 ml10 mr10" style="width:110px;">엑셀 양식 다운로드</span>엑셀 양식을 다운로드한 후, 상품정보를 작성하세요.</p>
			<p class="txt400_14" style="display: flex;"><img src="/resources/imgs/Icon_Download_05.png" /><span class="txt600_14 ml10" style="width:46px;">STEP 2</span><span class="txt500_14 ml10 mr10" style="width:110px;">엑셀업로드</span>[엑셀업로드]버튼을 선택하여 엑셀파일을 등록하세요.</p>
			<p class="txt400_14" style="display: flex;"><img src="/resources/imgs/Icon_Download_06.png" /><span class="txt600_14 ml10" style="width:46px;">STEP 3</span><span class="txt500_14 ml10 mr10" style="width:110px;">견적의뢰</span>엑셀업로드한 정보를 목록에서 확인하신 후, [견적의뢰]버튼을 선택하세요.</p>
		</div>
	</div>

	<!-- 메인 데이터 폼 영역 -->
	<form name="contentForm" id="contentForm" method="post">
		<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer%>">
		<input type="hidden" name="st_user_id" id="st_user_id" value="<%=user_id%>">
		<input type="hidden" name="cellCount" id="cellCount" value="10">
		
		
			<table class="PDEstimate" style="width:100%">
				<thead>
					<tr>
						<th><label class="CheckMediumLabel"><input type="checkbox" name="check_status" id="check_status" onclick="kepCheckAll2();"><span class="CheckMediumCustom"></span></label></th>
						<th width="420px"><%=CommonLang.get("HTITLE1074")%><!-- 기본정보 --> </th>
			            <th width="350px"><%=CommonLang.get("HTITLE1194")%><!-- 수량 및 금액 --> </th>
			            <th width="360px"><%=CommonLang.get("HTITLE1453")%><!-- 협력사 및 추가정보 --> </th>
					</tr>
				</thead>
				<tbody>
				<%
					if (_dataList == null || _dataList.size() == 0) {
				%>
					<tr>
						<td colspan="4" align="center" style="height:150px;">
							<span><%=CommonLang.msg("MSG347")%></span><!-- 조회된 데이타가 없습니다. -->
						</td>
					</tr>
				<%
					} else {
						for (int j = 0; j < _dataList.size(); j++) {
							Map<String, String> rowData = _dataList.get(j);
				%>
					<tr>
						<td align="center" rowspan="2">
							<label class="CheckMediumLabel">
								<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
								<span class="CheckMediumCustom"></span>
							</label>
							<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size()%>">
							<input type="hidden" name="excel_up" value="Y">
						</td>
						<td align="center" style="vertical-align:top;border-bottom:none">
							<table class="PDEstimateNoLine" style="width:360px;">
								<tr>
									<th width="80px"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
									<td width="250px"><input class="input40" style="width:260px" name="st_buyer_item_no" id="st_buyer_item_no<%=j%>" type="text" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" /></td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --><span>*</span></th>
									<td><input class="input40" style="width:260px" name="st_description" id="st_description<%=j%>" type="text" maxlength="50" value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>" /></td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE1454")%><!-- 모델번호 --> </th>
									<td><input class="input40" style="width:260px" name="st_maker_part_no" id="st_maker_part_no<%=j%>" type="text" maxlength="250" value="<%=CommonUtil.nvl(rowData.get("MAKER_PART_NO"))%>" /></td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE14")%><!-- 규격 --> <span>*</span></th>
									<td><input class="input40" style="width:260px" name="st_specification" id="st_specification<%=j%>" type="text" maxlength="250" value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>" /></td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE15")%><!-- 제조사 --> <%if(p04405401){%><span>*</span><%}%></th>
									<td><input class="input40" style="width:260px" name="st_maker_name" id="st_maker_name<%=j%>" type="text" maxlength="40" value="<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>" /></td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></th>
									<td>
									<div class="SearchInput"
										style="width: 280px; display: flex; align-items: center; gap: 2px;">
										<input type="text" id="st_origin_name<%=j %>"
											name="st_origin_name" readonly
											style="flex: 1; width: 0; height: 30px;" value="<%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%>"  onclick="doPop('country','<%=j%>');"> 
											<input type="hidden" id="st_origin_code<%=j %>" name="st_origin_code"
											value="<%=CommonUtil.nvl(rowData.get("ORIGIN_CODE"))%>">
										<button type="button" onclick="doPop('country','<%=j%>'); return false;"
											style="width: 40px; height: 30px; white-space: nowrap;"><%=CommonLang.get("HTITLE120")%></button>
									</div>
									</td>
								</tr>
							</table>
						</td>

						<!-- 2. 수량 및 금액 -->
						<td align="center" style="vertical-align:top;border-bottom:none">
							<table class="PDEstimateNoLine" style="width:330px">
								<tr>
									<th width="85px"><%=CommonLang.get("HTITLE52")%><!-- 단위 --> <span>*</span></th>
									<td width="235px">
										<select class="Select" style="width:242px" name="st_unit_measure" id="st_unit_measure<%=j%>">
											<%
												if (p04405501) {//고객사 단위 사용
											%>
											<%=CommonUtil.getCodeBComboList(buyer, "SEL", "UNIT", "ICOMCOD2", CommonUtil.nvl(rowData.get("UNIT_MEASURE")), "TEXT1")%>
											<%
												} else if (bqt00004) {
											%>
											<%=CommonUtil.getCodeBComboListCode(buyer, "SEL", "UNIT", "ICOMCOD2", CommonUtil.nvl(rowData.get("UNIT_MEASURE")), "TEXT1")%>
											<%
												} else {
											%>
											<%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo", "SEL", CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%>
											<%
												}
											%>
										</select>
									</td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE45")%><!-- 수량 --> <span>*</span></th>
									<td>
										<input class="input40" style="width:220px; text-align:right" name="st_item_qty_text" id="st_item_qty_text<%=j%>" type="text" onkeyup="validNumCheck(this);" onblur="displayNumbering('ITEM_QTY', '<%=j%>');" value="<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"), true, 0, 3)%>" />
										<input type="hidden" name="st_item_qty" id="st_item_qty<%=j%>" value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>" />
									</td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE46")%><!-- 단가구분 --></th>
									<td>
										<select class="Select40" style="width:242px" name="st_req_price_type" id="st_req_price_type<%=j%>">
											<%=CommonUtil.getCodeComboQueryIdList("getReqPriceTypeInfo", "", CommonUtil.nvl(rowData.get("REQ_PRICE_TYPE")))%>
										</select>
									</td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE50")%><!-- 요청단가 --> <%if(p04405301){%><span>*</span><%}%></th>
									<td>
										<input class="input40" style="width:220px; text-align:right" name="st_buyer_target_price_text" id="st_buyer_target_price_text<%=j%>" type="text" onkeyup="validNumCheck(this);" <%=read_only%> onblur="displayNumbering('BUYER_TARGET_PRICE', '<%=j%>');" value="<%=CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"), true, 0, 3)%>" />
										<input type="hidden" name="st_buyer_target_price" id="st_buyer_target_price<%=j%>" value="<%=CommonUtil.nvl(rowData.get("BUYER_TARGET_PRICE"))%>" />
									</td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --> <%if (p04404201) {%><span>*</span><%}%></th>
									<td>
									<div class="SearchInput" style="width: 240px; display: flex; display:inline-block;">
                  					<input type="text" name="st_category_name" id="st_category_name<%=j%>" value="" readonly style=" width:85%; " onclick="doPop('category','<%=j%>');">
									<input type="hidden" name="st_category_code" id="st_category_code<%=j%>" value="" />
                  					<button type="button" onclick="doPop('category','<%=j%>'); return false;"></button>
                					</div>
									</td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></th>
									<td>
										<button type="button" class="FileOutline" style="width: 242px" id="attach_btn<%=j %>" onclick="doPop('attach','<%=j%>');"><%=CommonLang.get("HTITLE440")%><!-- 등록 --></button>
										<input type="hidden" name="st_image_key" id="st_image_key<%=j%>" value="" />
									</td>
								</tr>
							</table>
						</td>
						<td align="center" style="vertical-align:top;border-bottom:none">
							<table class="PDEstimateNoLine" style="width:320px">
								<tr>
									<th width="105px"><%=CommonLang.get("HTITLE967")%><!-- 지정협력사 --></th>
									<td width="215px"><input class="input40" style="width:181px" name="st_buyer_assign_agent_code" id="st_buyer_assign_agent_code<%=j%>" type="text" value="<%=CommonUtil.nvl(rowData.get("BUYER_ASSIGN_AGENT_CODE"))%>" /></td>
								</tr>
								<tr>
									<th><%=CommonLang.get("HTITLE121")%><!-- 기존협력사 --></th>
									<td><input class="input40" style="width:181px" name="st_agent_name" id="st_agent_name<%=j%>" type="text" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>" /></td>
								</tr>
								<tr>
										<th height="28px"><%=CommonLang.get("HTITLE582")%><!-- 선입고여부 --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_pre_gr_flag__<%=j %>" value="Y" onchange="javascript:radioChange(<%=j%>,'st_pre_gr_flag_text',this)"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_pre_gr_flag__<%=j %>" value="N" checked="checked" onchange="javascript:radioChange(<%=j%>,'st_pre_gr_flag_text',this)"><span
												class="RadioLargeTxt"></span>N</label></td>
										<input id="st_pre_gr_flag_text<%=j %>" name="st_pre_gr_flag"
											type="hidden" value="N" />
									</tr>
									<tr>
										<th height="28px"><%=CommonLang.get("HTITLE968")%><!-- 제작품 --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_make_goods_flag__<%=j %>" value="Y" onchange="javascript:radioChange(<%=j%>,'st_make_goods_flag_text',this)"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_make_goods_flag__<%=j %>" value="N" checked="checked" onchange="javascript:radioChange(<%=j%>,'st_make_goods_flag_text',this)"><span
												class="RadioLargeTxt"></span>N</label> <input
											id="st_make_goods_flag_text<%=j %>" name="st_make_goods_flag"
											type="hidden" value="N" /></td>
									</tr>
									<tr style="display: none;">
										<th height="28px"><%=CommonLang.get("HTITLE914")%><!-- MSDS --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_msds_flag__<%=j %>" value="Y" onchange="javascript:radioChange(<%=j%>,'st_msds_flag_text',this)"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_msds_flag__<%=j %>" value="N" checked="checked" onchange="javascript:radioChange(<%=j%>,'st_msds_flag_text',this)"><span
												class="RadioLargeTxt"></span>N</label> <input
											id="st_msds_flag_text<%=j %>" name="st_msds_flag" type="hidden"
											value="N" /></td>
									</tr>
									<tr style="display: none;">
										<th height="28px"><%=CommonLang.get("HTITLE1200")%><!-- 안전인증품 --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_safety_flag__<%=j %>" value="Y" onchange="javascript:radioChange(<%=j%>,'st_safety_flag_text',this)"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_safety_flag__<%=j %>" value="N" checked="checked" onchange="javascript:radioChange(<%=j%>,'st_safety_flag_text',this)"><span
												class="RadioLargeTxt"></span>N</label></td>
									</tr>
									<input id="st_safety_flag_text<%=j %>" name="st_safety_flag"
										type="hidden" value="N" />
								<tr>
									<th><%=CommonLang.get("HTITLE51")%><!-- 회신요청일 --> <span>*</span></th>
									<td>
										<div class="Buyer-datepicker-wrap" style="width:201px;">
						               		<div class="Buyer-date-input" data-datepicker style="width:200px;">
						               			<input type="text" id="st_btoa_end_date<%=j%>" name="st_btoa_end_date" readonly style="width:180px;" value=""><span></span>
							               	</div>
					               		</div>
									</td>
								</tr>
							</table>
						</td>
						
					</tr>
					<tr>
						<td colspan="3" align="center"  style="border-top:none; padding:1px 0px 5px 0px;">
							<table class="PDEstimateNoLine" style="width:1080px;">
								<tr>
									<th width="78px"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
									<td><input class="input40" style="width:980px;" name="st_btoa_remark" id="st_btoa_remark<%=j%>" type="text" maxlength="400" value="<%=CommonUtil.nvl(rowData.get("TMP_REMARK"), p060000068)%>" /></td>
								</tr>
							</table>
						</td>
					</tr>
				<%
						}
					}
				%>
				</tbody>
			</table>
	</form>
	<!-- 폼 프로세스용 히든 폼 -->
	<form name="processForm" id="processForm" method="post">
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="buyer" id="buyer" value="" />
		<input type="hidden" name="gubun" id="gubun" value="" />
		<div id="process"></div>
	</form>

	<div class="PopupListBtnBox_Center mt30 mb20">
		<button type="button" class="ButQuaternary_large" onclick="javascript:self.close();">취소</button>
		<button type="button" class="ButPrimary_large" onclick="javascript:checkForm();"><%=CommonLang.get("HTITLE39")%><!-- 견적의뢰 --></button>
	</div>
</div><!-- wrapPopup 끝-->
</body>
</html>
