<%--
**********************************************
* 메뉴 : 
* 화면 : 유한킴벌리(주) 김천공장 
* 기능 : 유한킴벌리  장바구니 관리번호 선택 팝업
* 프로그램 ID : PG_06_B_006_10
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된 결과  getLegacyUserId
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된 결과  getRefHdInfo
 
String req_user_name = (String)request.getAttribute("req_user_name"); // 조회된 결과 
String conf_user_name = (String)request.getAttribute("conf_user_name"); // 조회된 결과 
String req_location_name = (String)request.getAttribute("req_location_name"); // 조회된 결과 
String gainloss_center_name = (String)request.getAttribute("gainloss_center_name"); // 조회된 결과 
String cost_center_name = (String)request.getAttribute("cost_center_name"); // 조회된 결과 




SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");
String st_item_no = CommonUtil.nvl((String) request.getParameter("st_item_no"),"");
String st_order_qty = CommonUtil.nvl((String) request.getParameter("st_order_qty"),"");
String st_contract_no = CommonUtil.nvl((String) request.getParameter("st_contract_no"),"");
String st_contract_seq = CommonUtil.nvl((String) request.getParameter("st_contract_seq"),"");
String st_mg_note = CommonUtil.nvl((String) request.getParameter("st_mg_note"),"");
String st_mg_note_input = CommonUtil.nvl((String) request.getParameter("st_mg_note_input"),"");
String st_yuhan_saperp_flag = CommonUtil.nvl((String) request.getParameter("st_yuhan_saperp_flag"),"");
String open = CommonUtil.nvl((String) request.getParameter("open"),"");

String st_plant_code = CommonUtil.nvl((String) request.getParameter("st_plant_code"),"");
String st_glaccount_code = CommonUtil.nvl((String) request.getParameter("st_glaccount_code"),"");

String userID             = _sessionInfo.getUserId();
String userName           = _sessionInfo.getUserNameLoc();
String com_code           = _sessionInfo.getComCode();



String ref_no = "";
String legacy_user_id = "";
String curDate  = "";
String rd_date  = "";


Map<String,String> rowData  = null;
if (_dataList1 == null || _dataList1.size() == 0){
	 
}else{ 
	rowData = _dataList1.get(0);
	legacy_user_id = rowData.get("LEGACY_USER_ID");
}


Map<String,String> rowData2  = null;
if (_dataList2 == null || _dataList2.size() == 0){
 
 }else{ 
	 rowData2 = _dataList2.get(0);
	ref_no = rowData2.get("REF_PR_FLAG");
	curDate  = rowData2.get("CURDATE");
	rd_date  =  rowData2.get("CURDATEPLUS7");	
 }
 

//String curDate = CommonUtil.formatDateNoDateGubun(new Date(),1); // 오늘날짜
//String rd_date = WisehubDate.addWiseDateDay(curDate,7);  // 7일후 

String readOnly_flag = "";
String disabled_flag = "";
String visible_flag = "";

if("KR07".equals(ref_no)){
	readOnly_flag = "";
	disabled_flag = "";
	visible_flag = "visible";
}else{
	readOnly_flag = "readOnly";
	disabled_flag = "disabled";
	visible_flag = "hidden";
}
 
 

String plantCode = "";
String rdDate = "";
String reqUserId = "";
String confUserId = "";
String accCateg = "";
String evalPrice = "";
String glAccount = "";
String gainLoss = "";
String profitSegment = "";
String costCenter = "";
 if(!st_mg_note.equals("")){
	//String mg_arr[] = st_mg_note.split("\\+");
	 String mg_arr[] = st_mg_note.split(" ");
	 String mg_arr2[] = st_mg_note_input.split(" ");


	 if(!"".equals(st_ref_no)){	 
	 	
	 	plantCode = mg_arr[0];
	 	rdDate = mg_arr[1];
	 	reqUserId = mg_arr[2];
	 	confUserId = mg_arr[3];
	 	if("KR07".equals(st_ref_no)){
	 		accCateg = mg_arr[4];
	 		evalPrice = mg_arr[5];
	 		glAccount = mg_arr[6];
	 		gainLoss = mg_arr[7];
	 		profitSegment = mg_arr[8];
	 		if(mg_arr.length > 9){
	 			costCenter = mg_arr[9];
	 		}
	 	}
	 }else{
	 	plantCode = mg_arr2[0];
	 	rdDate = mg_arr2[1];
	 	reqUserId = mg_arr2[2];
	 	confUserId = mg_arr2[3];
	 	if("KR07".equals(st_yuhan_saperp_flag)){
	 		accCateg = mg_arr2[4];
	 		evalPrice = mg_arr2[5];
	 		glAccount = mg_arr2[6];
	 		gainLoss = mg_arr2[7];
	 		profitSegment = mg_arr2[8];
	 		if(mg_arr2.length > 9){
	 			costCenter = mg_arr2[9];
	 		}
	 	}
	 	
	 }	 
 }


if ("".equals(st_plant_code)){
	st_plant_code = plantCode;
} 


%>

<script type="text/javascript">
<!--


/*변수*/
//손익센터 or 코스트센터
var center_flag = "";
//요청자 or 승인권자
var user_flag = "";

var c_st_ref_no = "";

var popupSel = "";

var req_user = "";

isDisabled = function (){ 
    for (var i=0; i<this.length; i++){ 
      if(this.item(i).readOnly) this.item(i).style.backgroundColor="#EAEAEA";
      if(this.item(i).disabled) this.item(i).style.background="#EAEAEA";
    }
}

 
function kep_onload(){  
    var input = document.getElementsByTagName("INPUT");
    isDisabled.apply(input);  
    
    var input1 = document.getElementsByTagName("SELECT");
    isDisabled.apply(input1);  
 
}


function kepSearch()
{  
 // $('#buyer_pr_display_pop').attr("action", "/mpso/getBuyerMpSoYuHanKimChonPop.do").submit();    
}




//평가가격
function checkNum(){
	var view_eval_price = kepTrimStr(kepFilterNum(document.forms.buyer_pr_display_pop.st_view_eval_price.value));
	if(kepIsValueNull(view_eval_price) ||  (view_eval_price == 0) ){
		alert("평가가격에 숫자를 입력해 주십시요");
		document.forms.buyer_pr_display_pop.st_view_eval_price.value = 0;
		document.forms.buyer_pr_display_pop.st_view_eval_price.focus();
		document.forms.buyer_pr_display_pop.st_eval_price.value = 0;
		return;
	}else{
		document.forms.buyer_pr_display_pop.st_view_eval_price.value = kepCommaNum(view_eval_price);
		document.forms.buyer_pr_display_pop.st_eval_price.value = view_eval_price;
	}
}

//요청자, 승인권자
function getBuyerUserSelect(flag){
	user_flag = flag;	 
	openSearchPopup('/common/misUserSelectAllPop.do', "?open=O&com_code=<%=st_buyer%>" , "500,500,no"); 
 
	 
}

function setPopupReturn(code, text, value3, value4, value5, value6, value7, value8, value9, value10, value11){
	 
	if(user_flag == "R"){
		document.forms.buyer_pr_display_pop.st_req_user_id.value = value8;
		document.forms.buyer_pr_display_pop.st_req_user_name.value = text;
		document.forms.buyer_pr_display_pop.st_location_name.value = value10 + ' ' + value11;
	    document.forms.buyer_pr_display_pop.st_zip_change.value = "Y";
	}else if(user_flag == "C"){
		document.forms.buyer_pr_display_pop.st_confirm_user_id.value = code;
		document.forms.buyer_pr_display_pop.st_confirm_user_name.value = text;
	}else 	if(user_flag == "GL"){
		document.forms.buyer_pr_display_pop.st_gainloss_center.value = text;
		document.forms.buyer_pr_display_pop.st_gainloss_center_code.value = code;
	}else if(user_flag == "CC"){
		document.forms.buyer_pr_display_pop.st_cost_center.value = text;
		document.forms.buyer_pr_display_pop.st_cost_center_code.value = code;
	}else if(user_flag == "M014"){
		document.forms.buyer_pr_display_pop.st_profit_segment.value = text;
		document.forms.buyer_pr_display_pop.st_profit_segment_code.value = code;
	}else if(user_flag == "location"){
	    document.forms.buyer_pr_display_pop.st_location_name.value = text;
	    document.forms.buyer_pr_display_pop.st_location_code.value = code; 
	    document.forms.buyer_pr_display_pop.st_zip_change.value = "Y";
	}
}

//손익센터, 코스트센터
function getCostCenterPop(flag){
	user_flag = flag;
	if (flag == "M014"){ 
		openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&st_type="+flag+"&com_code=<%=st_buyer%>", "500,500,no"); 
	}else{ 
		openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code=<%=st_buyer%>", "500,500,no"); 
	} 
}
 
function zipCheck(){
	kepAjaxFormCall("/mpso/checkZipCode.do","buyer_pr_display_pop","CHECKZIP");
}


//장바구니 화면에 반영
function setRefList(){
 

	var st_ref_no = document.forms.buyer_pr_display_pop.st_ref_no.value;
	var st_plant_code = document.forms.buyer_pr_display_pop.st_plant_code.value;
	var st_rd_date = document.forms.buyer_pr_display_pop.st_rd_date.value;
	var st_req_user_id = document.forms.buyer_pr_display_pop.st_req_user_id.value;
	var st_req_user_name = document.forms.buyer_pr_display_pop.st_req_user_name.value;
	var st_confirm_user_id = document.forms.buyer_pr_display_pop.st_confirm_user_id.value;
	var st_confirm_user_name = document.forms.buyer_pr_display_pop.st_confirm_user_name.value;
	var st_account_categ = document.forms.buyer_pr_display_pop.st_account_categ.value;
	var st_eval_price = document.forms.buyer_pr_display_pop.st_eval_price.value;
	var st_glaccount_code = document.forms.buyer_pr_display_pop.st_glaccount_code.value;
	var st_gainloss_center_code = document.forms.buyer_pr_display_pop.st_gainloss_center_code.value;
	var st_gainloss_center = document.forms.buyer_pr_display_pop.st_gainloss_center.value;
	var st_profit_segment_code = document.forms.buyer_pr_display_pop.st_profit_segment_code.value;
	var st_profit_segment = document.forms.buyer_pr_display_pop.st_profit_segment.value;
	var st_cost_center_code = document.forms.buyer_pr_display_pop.st_cost_center_code.value;
	var st_cost_center = document.forms.buyer_pr_display_pop.st_cost_center.value;

	if(st_plant_code == ""){
		alert("플랜트를 입력하십시오.");
		document.forms.buyer_pr_display_pop.st_plant_code.focus();
		return;
	}
	//수기로 코드입력한 부분은 명으로 validation 체크
	if(st_req_user_id == ""){
		alert("요청자를 입력 바랍니다.");
		document.forms.buyer_pr_display_pop.st_req_user_id.focus();
		return;
	}
	if(st_req_user_name == ""){
		alert("요청자 재확인 바랍니다.");
		document.forms.buyer_pr_display_pop.st_req_user_id.focus();
		return;
	}
	if(st_confirm_user_id == ""){
		alert("승인권자를 입력 바랍니다.");
		document.forms.buyer_pr_display_pop.st_confirm_user_id.focus();
		return;
	}
	if(st_confirm_user_name == ""){
		alert("승인권자 재확인 바랍니다.");
		document.forms.buyer_pr_display_pop.st_confirm_user_id.focus();
		return;
	}
	if(st_ref_no == "KR07"){
		if(st_account_categ == ""){
			alert("계정범주를 선택하십시오.");
			document.forms.buyer_pr_display_pop.st_account_categ.focus();
			return;
		}
		if(st_glaccount_code == ""){
			alert("G/L계정을 선택하십시오.");
			document.forms.buyer_pr_display_pop.st_glaccount_code.focus();
			return;
		}
		if(st_account_categ == "S"){
			if(st_gainloss_center_code == ""){
				alert("손익센터를 입력하십시오.");
				document.forms.buyer_pr_display_pop.st_gainloss_center_code.focus();
				return;
			}
			if(st_gainloss_center_code != ""){
				if(st_gainloss_center == ""){
					alert("손익센터를 재확인 바랍니다.");
					document.forms.buyer_pr_display_pop.st_gainloss_center_code.focus();
					return;
				}
			}
			if(st_profit_segment_code == ""){
				alert("수익성세그먼트(고객)를 입력하십시오.");
				document.forms.buyer_pr_display_pop.st_profit_segment_code.focus();
				return;
			}
			if(st_profit_segment_code != ""){
				if(st_profit_segment == ""){
					alert("수익성세그먼트(고객)를 재확인 바랍니다.");
					document.forms.buyer_pr_display_pop.st_profit_segment_code.focus();
					return;
				}
			}
		}
		if(st_account_categ == "K"){
			if(st_cost_center_code == ""){
				alert("코스트센터를 입력하십시오.");
				document.forms.buyer_pr_display_pop.st_cost_center_code.focus();
				return;
			}
			if(st_cost_center_code != ""){
				if(st_cost_center == ""){
					alert("코스트센터를 재확인 바랍니다.");
					document.forms.buyer_pr_display_pop.st_cost_center_code.focus();
					return;
				}
			}
		}
	}

	var mg_note = st_plant_code+"+"+st_rd_date+"+"+st_req_user_id+"+"+st_confirm_user_id+"+"+st_account_categ+"+"+st_eval_price+"+"+st_glaccount_code+"+"+st_gainloss_center_code+"+"+st_profit_segment_code+"+"+st_cost_center_code;

	c_st_ref_no = st_ref_no;
	c_mg_note = mg_note;
	
	if(!confirm("저장하시겠습니까?")){
		return;
	}

	document.forms.buyer_pr_display_pop.st_mg_note.value = mg_note;	
	kepAjaxFormCall("/mpso/saveBuyerYuhanRetUpdate.do","buyer_pr_display_pop","SAVE"); 
	 
	//document.forms.buyer_pr_display_pop.action = "/kr/customer/shopping_cart/buyer_yuhan_ref_update.jsp"; 
}


function setYuhanRefInfo(){
	alert("정상적으로 저장되었습니다.");
	opener.setRefInfo('<%=st_row%>', c_st_ref_no, c_mg_note);
	self.close();
}



//프로모션 : S => 코스트센터 입력불가
//일반소모품 : K => 손익센터, 수익성세그먼트(고객) 입력불가
function inputDel(flag){
	if(flag == "S"){
		document.getElementById("Schk").style.width = "0px";
		document.getElementById("Kchk1").style.width = "19px";
		document.getElementById("Kchk2").style.width = "19px";
		document.forms.buyer_pr_display_pop.st_cost_center_code.value = "";
		document.forms.buyer_pr_display_pop.st_cost_center.value = "";
		document.getElementById("Schk_ip").readOnly = true;
		document.getElementById("Kchk1_ip").readOnly = false;
		document.getElementById("Kchk2_ip").readOnly = false;
	}else if(flag == "K"){
		document.getElementById("Kchk1").style.width = "0px";
		document.getElementById("Kchk2").style.width = "0px";
		document.getElementById("Schk").style.width = "19px";
		document.forms.buyer_pr_display_pop.st_gainloss_center_code.value = "";
		document.forms.buyer_pr_display_pop.st_gainloss_center.value = "";
		document.forms.buyer_pr_display_pop.st_profit_segment_code.value = "";
		document.forms.buyer_pr_display_pop.st_profit_segment.value = "";
		document.getElementById("Kchk1_ip").readOnly = true;
		document.getElementById("Kchk2_ip").readOnly = true;
		document.getElementById("Schk_ip").readOnly = false;
	}
}


function setPopupCalendar(year,month,day){
	document.forms.buyer_pr_display_pop.st_rd_date_text.value=year+"/"+month+"/"+day+"";
	document.forms.buyer_pr_display_pop.st_rd_date.value=year+""+month+""+day+"";
}


function getUserNameLocChk(userId, objName){
	
	user_flag = objName;	
	req_user = userId;
	
	/**
	* kepAjaxCall 공통 ajax
	*/	
	var data = {  value1:"<%=com_code%>",value2:userId };
	kepAjaxCall("/mpso/getBuyerMpSoYuHanKimChonPo_getUserNameLoc.do",data,"getUserNameLocChk"); 
}

function getUserAddressLocChk(userId, objName){
	user_flag = objName;	
	
	/**
	* kepAjaxCall 공통 ajax
	*/	
	var data = {  value1:"<%=com_code%>",value2:userId };
	kepAjaxCall("/mpso/getBuyerMpSoYuHanKimChonPo_getUserAddressLoc.do",data,"getUserAddressLocChk"); 
}
 
 
function getCenterCodeChk(centerCode, objName){
	
	
	user_flag = objName;	

	/**
	* kepAjaxCall 공통 ajax
	*/	
	var data = {  value1:"<%=com_code%>",value2:centerCode,objName:objName };
	kepAjaxCall("/mpso/getBuyerMpSoYuHanKimChonPo_getCenterCode.do",data,"getCenterCodeChk"); 
}

function getProfitSegmentCodeChk(segmentCode, objName){
	
	
	user_flag = objName;	

	/**
	* kepAjaxCall 공통 ajax
	*/	
	var data = {  value1:"<%=com_code%>",value2:segmentCode };
	kepAjaxCall("/mpso/getBuyerMpSoYuHanKimChonPo_getprofitSegmentCode.do",data,"getProfitSegmentCodeChk"); 
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){

	 var MSG = response.msg.MSG;
	 if (MSG == "null" || MSG == null){
		 MSG = "";
	 }
	
	if (pMethod == "getUserNameLocChk"){
		if (user_flag == "st_req_user_name"){
			document.forms.buyer_pr_display_pop.st_req_user_name.value = MSG;
			getUserAddressLocChk(req_user, 'st_location_name');
		}else if (user_flag == "st_confirm_user_name"){
			document.forms.buyer_pr_display_pop.st_confirm_user_name.value = MSG;
		}
	}else if (pMethod == "getUserAddressLocChk"){
		document.forms.buyer_pr_display_pop.st_location_name.value = MSG;
		document.forms.buyer_pr_display_pop.st_zip_change.value = "Y";
	}else if (pMethod == "getCenterCodeChk"){
		if (user_flag == "st_gainloss_center"){ 
			document.forms.buyer_pr_display_pop.st_gainloss_center.value = MSG;
		}else if (user_flag == "st_cost_center"){
			document.forms.buyer_pr_display_pop.st_cost_center.value = MSG;
		}
	}else if (pMethod == "getProfitSegmentCodeChk"){
		document.forms.buyer_pr_display_pop.st_profit_segment.value = MSG;
	}else if (pMethod == "SAVE"){
		if (MSG == "UPDATE_OK"){ 			
			
			if (c_st_ref_no == ""){
				alert("자재유형이 없습니다. 확인 부탁드립니다.");
				return;
			}
			alert("정상적으로 저장되었습니다.");
			opener.setRefInfo('<%=st_row%>', c_st_ref_no, c_mg_note);
			self.close();
		}
	}else if (pMethod == "CHECKZIP"){
		setRefList();
	}

	user_flag = "";
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	if (pMethod == "getUserNameLocChk"){
		if (user_flag == "st_req_user_name"){
			alert("요청자 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		}else if (user_flag == "st_confirm_user_name"){
			alert("승인권자 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		}
	}else if (pMethod == "getCenterCodeChk"){
		alert("센터 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "getProfitSegmentCodeChk"){
		alert("세그먼트 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "SAVE"){
		alert("저장 오류 발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}	 
	user_flag = "";
}
/* 
// ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function getzipCode(){
	popupSel = "zipcode";
	openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");		
}
 */

function getnewzipCode(){
	popupSel = "newzipcode";
	openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");		
}

function getDeliveryToLocation(com_code){
	popupSel = "location";
	user_flag =  "location";
	openSearchPopup('/common/delLocationPop.do', '?com_code='+com_code+'&open=Y', '500,500,no');
}
/* 
// ICOMPOST 테이블 이용하여 우편번호 검색 김영훈
function setZipPopupReturn(str_zipcode, str_zip_key, str_si, str_gu, str_do, str_bd, str_bdnm, str_dong)
{ 
    document.forms.buyer_pr_display_pop.st_location_name.value = str_zipcode+" " +str_si+" "+str_gu+" "+str_do+" "+str_bd;
    document.forms.buyer_pr_display_pop.st_zip_change.value = "Y";
    document.forms.buyer_pr_display_pop.st_location_name.focus();
}
 */

function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){ 
    document.forms.buyer_pr_display_pop.st_location_name.value = zipNo.replace(/[^0-9]/gi, '') + " " + roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail;
    document.forms.buyer_pr_display_pop.st_zip_change.value = "Y";
    document.forms.buyer_pr_display_pop.st_location_name.focus();
}

//주소 변경 시 icomlusr 테이블에 주소 update
function getAddChange(){
	document.forms[0].st_zip_change.value = "Y";
}




 //-->
</script> 
<body onload="kep_onload()">
<form name="buyer_pr_display_pop" id="buyer_pr_display_pop" method=post >
 <input type="hidden" name="st_mg_note" value="">
 <input type="hidden" name="st_zip_change" value="">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">MRO 구매품목 관리항목 등록 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 
 
 
 <table  class="board_write"  style="width:100%">
      <colgroup>
      <col width="15%" />
      <col width="35%" />
      <col width="15%" />
      <col width="35%" />
      </colgroup>
      <tr>
        <th scope="row">자재유형</th>
        <td><b><%=ref_no%></b> / <%=rowData2.get("REF_PR_TEXT")%>
			<input type="hidden" name="st_ref_no" size="12" value="<%=ref_no%>">
		</td>
        <th scope="row">자재코드</th>
        <td><%=rowData2.get("BUYER_ITEM_NO")%>
			<input type="hidden" name="st_item_no" size="12" value="<%=rowData2.get("BUYER_ITEM_NO")%>">
		</td>
      </tr>
      <tr>
        <th scope="row">품목명/규격</th>
        <td colspan="3"> <%=rowData2.get("DESCRIPTION")%> / <%=rowData2.get("SPECIFICATION")%></td>
      </tr>
      <tr>
        <th scope="row">플랜트</th>
        <td>
			<select name="st_plant_code" style="width:80%"> 
			<% 
			
			Map<String, String> _map = new HashMap<String, String>();
_map.put("st_buyer",st_buyer); 
_map.put("plantCode",!"".equals(plantCode)?plantCode:""); 
%>
<%= CommonUtil.getCodeComboQueryIdList("common.mpso.yuhan_getCod2C002DDLB","SEL",_map,st_plant_code) %>

			
			
			 
			</select>
		</td>
        <th scope="row">수량</th>
        <td><%=CommonUtil.formatNumber(st_order_qty,true,0,3)%></td>
      </tr>
      <tr>
        <th scope="row">납품일</th>
        <td>
			<input type="text" name="st_rd_date_text" id="st_rd_date_text" size="10" maxlength="10" value = "<%=!"".equals(rdDate)? CommonUtil.formatStrinigDate(rdDate):CommonUtil.formatStrinigDate(rd_date)%>"  class="input_type_text" readonly>
			<a href="javascript:kepCalendarOpenPopup();"><img src="/resources/images/btn_calendar.gif" width="19"  border="0" height="19" ></a>
			<input type="hidden" name="st_rd_date" size="12" value="<%=!"".equals(rdDate)?rdDate:rd_date%>">
		</td>
        <th scope="row">단가</th>
        <td><%=CommonUtil.formatNumber(rowData2.get("UNIT_PRICE"),true,0,3)%></td>
      </tr>
      <tr>
        <th scope="row">요청자</th>
        <td>
			<input type="text" name="st_req_user_id" class="input_type_text" style="width:40%" value="<%=!"".equals(reqUserId)?reqUserId:legacy_user_id%>" onBlur="javascript:getUserNameLocChk(this.value, 'st_req_user_name');">
			<a href="javascript:getBuyerUserSelect('R');"><img src="/resources/images/btn_search03.gif" width="19" height="19" border="0"></a> 
			<input type="text" name="st_req_user_name" style="width:40%" value="<%=!"".equals(req_user_name)?req_user_name:userName%>" class="input_type_text" readonly>
		</td>
        <th scope="row">승인권자</th>
        <td>
			<input type="text" name="st_confirm_user_id" class="input_type_text" style="width:40%" value="<%=!"".equals(confUserId)?confUserId:""%>" onBlur="javascript:getUserNameLocChk(this.value, 'st_confirm_user_name');">
			<a href="javascript:getBuyerUserSelect('C');"><img src="/resources/images/btn_search03.gif" width="19" height="19" border="0"></a> 
			<input type="text" name="st_confirm_user_name" style="width:40%" value="<%=!"".equals(conf_user_name)?conf_user_name:""%>" class="input_type_text" readonly>
		</td>
      </tr>
		<tr>
		    <th scope="row">배송처</th>
		    <td colspan="3">
		    	<input type="text" name="st_location_name" id="st_location_name" class="input_type_text" title="" style="width:70%;" value="<%=!"".equals(req_location_name)?req_location_name:""%>"  onChange="javascript:getAddChange();"/>
				<input type="hidden" name="st_location_code" id="st_location_code" size="113" value="">
		    	(ex. 우편번호+상세주소)
		    </td>
		</tr>
		<tr>
		    <th scope="row"></th>
		  	<td colspan="3">
		  		<!-- <span class="btn_gray_05"  title="우편번호" ><a href="javascript:getzipCode();">우편번호 검색</a></span>	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
		  		<span class="btn_gray_05"  title="우편번호" ><a href="javascript:getnewzipCode();">우편번호 검색</a></span>
		  		(ex. 지정되지 않은 도착지일 경우 사용)&nbsp;
		  		<span class="btn_gray_04"  title="도착지" ><a href="javascript:getDeliveryToLocation('<%=st_buyer%>')">도착지 선택</a></span>
		  		(ex. 지정된 도착지를 선택)
		  	</td>
		</tr>
      <tr>
        <th scope="row">계정범주</th>
        <td>
			<select name="st_account_categ" onChange="inputDel(this.value)" <%=disabled_flag%> style="width:80%"> 
			<option value="">-- 선택안함 --</option>
			<option value="S" <%=!"".equals(accCateg)?"S".equals(accCateg)?"selected":"":""%>>S(프로모션)</option>
			<option value="K" <%=!"".equals(accCateg)?"K".equals(accCateg)?"selected":"":""%>>K(일반소모품)</option>
			</select>
		</td>
        <th scope="row">평가가격</th>
        <td>
			<input type="text" name="st_view_eval_price" class="input_type_text" style="width:80%;" id="text" value="<%=!"".equals(evalPrice)?evalPrice:""%>" onChange="checkNum()" <%=readOnly_flag%>>
			<input type="hidden" name="st_eval_price" value="<%=!"".equals(evalPrice)?evalPrice:""%>" <%=readOnly_flag%>>
		</td>
      </tr>
      <tr>
        <th scope="row">G/L계정</th>
        <td>
			<select name="st_glaccount_code" <%=disabled_flag%> style="width:80%">  
					<% 
			 
_map.put("st_buyer",st_buyer); 
_map.put("glAccount", !"".equals(glAccount)?glAccount:""); 
%>
<%= CommonUtil.getCodeComboQueryIdList("common.mpso.yuhan_getCod2Z014DDLB","SEL",_map,glAccount) %>
			 
			</select>
		</td>
        <th scope="row">손익센터</th>
        <td>
			<input type="text" name="st_gainloss_center_code" class="input_type_text" style="width:40%;ime-mode:active" value="<%=!"".equals(gainLoss)?gainLoss:""%>" <%=readOnly_flag%> id="Kchk1_ip" onkeyup="kepToUpper('Kchk1_ip')"  onBlur="javascript:getCenterCodeChk(this.value, 'st_gainloss_center');">
<%
if("KR07".equals(ref_no)){
%>
			<a href="javascript:getCostCenterPop('GL')"><img src="/resources/images/btn_search03.gif" alt="검색" id="Kchk1"> </a>
<%
}
%>
			<input type="text" name="st_gainloss_center" class="input_type_text" style="width:40%" value="<%=!"".equals(gainloss_center_name)?gainloss_center_name:""%>" READONLY>
		</td>
      </tr>
      <tr>
        <th scope="row">수익성세그먼트<br>(고객)</th>
        <td>
			<input type="text" name="st_profit_segment_code"  class="input_type_text" style="width:40%;ime-mode:active" value="<%=!"".equals(profitSegment)?profitSegment:""%>" <%=readOnly_flag%> id="Kchk2_ip" onkeyup="kepToUpper('Kchk2_ip')" onBlur="javascript:getProfitSegmentCodeChk(this.value, 'st_profit_segment');">
<%
if("KR07".equals(ref_no)){
%>
			<a href="javascript:getCostCenterPop('M014')"><img src="/resources/images/btn_search03.gif" alt="검색" id="Kchk2"> </a>
<%
}
%>
			<input type="text" name="st_profit_segment" class="input_type_text" style="width:40%" value="" READONLY>
		</td>
        <th scope="row">코스트센터</th>
        <td>
			<input type="text" name="st_cost_center_code"   class="input_type_text" style="width:40%;ime-mode:active" value="<%=!"".equals(costCenter)?costCenter:""%>" <%=readOnly_flag%> id="Schk_ip" onkeyup="kepToUpper('Schk_ip')" onBlur="javascript:getCenterCodeChk(this.value, 'st_cost_center');">
<%
if("KR07".equals(ref_no)){
%>
			<a href="javascript:getCostCenterPop('CC')"><img src="/resources/images/btn_search03.gif" alt="검색" id="Schk"> </a>
<%
}
%>
			<input type="text" name="st_cost_center" class="input_type_text" style="width:40%" value="<%=!"".equals(cost_center_name)?cost_center_name:""%>" READONLY>
		</td>
      </tr>
	</table>
	 
         
    <div class="btnArea">
		<div class="fr">
			<span class="btn_03 mr04"><a href="javascript:zipCheck();">확인</a>
			</span>
		</div>
	</div>
    </div>        
    



</div>
</form> 
</body>
</html>
