<%--
**********************************************
* 메뉴 : 
* 화면 : 반품입력 운영사  팝업
* 기능 : 
* 프로그램 ID : PG_08_M_019_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-8-5
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	String buyer = "";
	String userid = "";
	String userName = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
		userName = CommonUtil.nvl((String)_sessionInfo.getUserNameLoc());  	
	} 
	String whAdmin = _sessionInfo.getWhAdmin();
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	List<Map<String,String>> _dataPoList = (List<Map<String,String>>) request.getAttribute("data_po"); // 조회된 결과
	Map<String,String> _rowData = null;
	Map<String,String> _rowPoData = null;
	String st_wmre_no ="";
	String st_wmre_type2 = "";
	String st_wmre_type3 ="";
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		st_wmre_no =		CommonUtil.nvl(_rowData.get("WMRE_NO"));
		st_wmre_type2 =  CommonUtil.nvl(_rowData.get("WMRE_TYPE2"));
		st_wmre_type3 = CommonUtil.nvl(_rowData.get("WMRE_TYPE3"));
	}
	String st_buyer_name = "";
	String st_buyer_code = "";
	String st_po_no = "";
	String st_po_seq = "";
	String st_legacy_po_no = "";
	String st_legacy_po_seq = "";
	String st_description = "";
	String st_specification = "";
	String st_buyer_item_no= "";
	String st_item_qty = "";
	String st_seller = "";
	String st_process_type = "";
	String st_process_user_name = "";
	String st_process_type_name = "";
	String st_seller_name = "";
	String st_buyer_dept_code = "";
	String st_buyer_dept_name = "";
	String st_buyer_person_name = "";
	String st_buyer_person_tel = "";
	String st_b_req_date = "";
	String st_b_req_user_id = "";
	String st_wmre_no_adv = "";
	String st_wmre_type_adv = "";
	String st_wmre_qty = "";
	String st_b_req_remark = "";
	String st_warehouse_code = "";
	String st_total_wmre_qty = "";
	String st_status_back_code = "";
	String st_unit_measure = "";
	String st_pr_add_user_id = "";
	String st_pr_add_user_name = "";
	String st_pr_add_user_tel = "";
	String st_pr_add_user_dept = "";
	String st_pr_add_user_dept_nm = "";
	
	if (_dataPoList != null && _dataPoList.size() != 0) { 
		_rowPoData = _dataPoList.get(0);
		st_buyer_name = CommonUtil.nvl(_rowPoData.get("BUYER_NAME"));
		st_buyer_code = CommonUtil.nvl(_rowPoData.get("BUYER"));
		st_po_no = CommonUtil.nvl(_rowPoData.get("PO_NO"));
		st_po_seq = CommonUtil.nvl(_rowPoData.get("PO_SEQ"));
		st_buyer_item_no = CommonUtil.nvl(_rowPoData.get("BUYER_ITEM_NO"));
		st_legacy_po_no =CommonUtil.nvl(_rowPoData.get("LEGACY_PO_NO"));
		st_legacy_po_seq =CommonUtil.nvl(_rowPoData.get("LEGACY_PO_SEQ"));
		st_description = CommonUtil.nvl(_rowPoData.get("DESCRIPTION"));
		st_specification = CommonUtil.nvl(_rowPoData.get("SPECIFICATION"));
		st_item_qty = CommonUtil.nvl(_rowPoData.get("ITEM_QTY"));
		st_seller = CommonUtil.nvl(_rowPoData.get("SELLER"));
		st_process_type = CommonUtil.nvl(_rowPoData.get("PROCESS_TYPE"));
		st_process_user_name = CommonUtil.nvl(_rowPoData.get("PROCESS_USER_NAME"));
		st_process_type_name = CommonUtil.nvl(_rowPoData.get("PROCESS_TYPE_NAME"));
		st_seller_name = CommonUtil.nvl(_rowPoData.get("SELLER_NAME"));
		st_buyer_dept_code = CommonUtil.nvl(_rowPoData.get("BUYER_DEPT_CODE"));
		st_buyer_dept_name = CommonUtil.nvl(_rowPoData.get("BUYER_DEPT_NAME"));
		st_buyer_person_name = CommonUtil.nvl(_rowPoData.get("BUYER_PERSON_NAME"));
		st_buyer_person_tel = CommonUtil.nvl(_rowPoData.get("BUYER_PERSON_TEL"));
		st_b_req_date = CommonUtil.nvl(_rowPoData.get("B_REQ_DATE"));
		st_wmre_no_adv = CommonUtil.nvl(_rowPoData.get("WMRE_NO"));               
		st_wmre_type_adv = CommonUtil.nvl(_rowPoData.get("WMRE_TYPE"));             
		st_wmre_qty = CommonUtil.nvl(_rowPoData.get("WMRE_QTY"));              
		st_b_req_remark = CommonUtil.nvl(_rowPoData.get("B_REQ_REMARK"));          
		st_warehouse_code = CommonUtil.nvl(_rowPoData.get("WAREHOUSE_CODE"));        
		st_total_wmre_qty = CommonUtil.nvl(_rowPoData.get("TOTAL_WMRE_QTY"));    
		st_status_back_code = CommonUtil.nvl(_rowPoData.get("STATUS_BACK_CODE"));
		st_unit_measure = CommonUtil.nvl(_rowPoData.get("UNIT_MEASURE"));
		st_pr_add_user_id = CommonUtil.nvl(_rowPoData.get("PR_ADD_USER_ID"));
		st_pr_add_user_name = CommonUtil.nvl(_rowPoData.get("PR_ADD_USER_NAME"));
		st_pr_add_user_tel = CommonUtil.nvl(_rowPoData.get("PR_ADD_USER_TEL"));
		st_pr_add_user_dept = CommonUtil.nvl(_rowPoData.get("PR_ADD_USER_DEPT"));
		st_pr_add_user_dept_nm = CommonUtil.nvl(_rowPoData.get("PR_ADD_USER_DEPT_NM"));

	}	

			
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;


function popupOnload(){
	
	getWmreType();
	
	// 조회조건 초기화
	if( $('#st_wmre_no').val()  == ""){
		kepSetCalender("st_b_req_date");
		$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		$("#st_m_rec_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		
		

	}
	
	if($('#st_FLAG').val() == "01"){
		
		$("#st_m_rec_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	}

	//po정보기준으로 셋팅.
	<%if(_dataPoList != null){%>
		setPoInfo();
	<%}%>
	kepSetCalender("st_m_rec_date");
	
}

function  attach_popup(){	

	var type = "WR";
	var viewType = "C";
	var img_key = $("#st_wmre_file").val(); 
	kepFileUploadOpenPopup(img_key,type,viewType); 
   popupSel = "attach_popup";
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
	

		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/wmre/getMasterWmReReturnEntryPop.do" , pagingMode );
			break;
		case "reload":
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save":
			if(document.searchCondition.st_buyer_code.value == ""){
				alert("고객사를 선택하세요.");
				document.searchCondition.st_buyer_name.focus();
				return;
			}
			if(document.searchCondition.st_po_no.value == ""){
				alert("발주번호를 입력하세요");
				document.searchCondition.st_po_no.focus();
				return;
			}
			/* 코웨이 요청부서 많은 필수값 제거.
			if($('#st_buyer_dept_code').val()==""){
				alert("고객요청부서를 입력하세요");
				document.searchCondition.st_buyer_dept_name.focus();
				return;
			}*/

			if( $('#st_buyer_person_name').val()==""){
				alert("고객요청자를 입력하세요");
				document.searchCondition.st_buyer_person_name.focus();
				return;
			}

			if(document.searchCondition.st_wmre_type.value == ""){
				alert("요청 구분을 선택 하세요");
				document.searchCondition.st_wmre_type.focus();
				return;
			}

			if(document.searchCondition.st_delivery_flag.value == ""){
				alert("물품수령여부를 선택하세요");
				document.searchCondition.st_delivery_flag.focus();
				return;
			}
			
			if(document.searchCondition.st_wmre_type.value =="01" || document.searchCondition.st_wmre_type.value =="02"){ // 01: 반품, 02: 교환
				
				if(document.searchCondition.st_wmre_qty.value == ""){
					alert("요청 수량을 입력하세요");
					document.searchCondition.st_wmre_qty.focus();
					return;
				}
				
				if(document.searchCondition.st_wmre_type2.value == ""){
					alert("귀책 대상을 선택하세요");
					document.searchCondition.st_wmre_type2.focus();
					return;
				}
				
				if(document.searchCondition.st_wmre_type3.value == ""){
					alert("귀책 사유 선택하세요");
					document.searchCondition.st_wmre_type3.focus();
					return;
				}
				
				if(document.searchCondition.st_wmre_type_detail.value == ""){
					alert("귀책 상세사유를 입력하세요");
					document.searchCondition.st_wmre_type_detail.focus();
					return;
				}
			//불량일 경우 수량 체크 추가.	
			}else if( document.searchCondition.st_wmre_type.value =="03"){
				if(document.searchCondition.st_wmre_qty.value == ""){
					alert("요청 수량을 입력하세요");
					document.searchCondition.st_wmre_qty.focus();
					return;
				}
			}

			var check = checkQty();  //발주수량과 비교
			if(check =="N"){
				return;
			}
		    if(!confirm("반품 등록을 하시겠습니까?  ")) {
		        return;
		    }else{
		       kepAjaxFormCall("/wmre/saveMasterWmReReturnEntryPop.do","searchCondition","save"); 	   
		    }


			break;
	}

}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	
	if (pMethod == "save"){ 
		 alert("반품 등록에 실패 하였습니다. 다시 시도 하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
 	
	
	var result = response.msg.MSG;  
	
	if(result=="Ok"){
		alert("정상적으로 저장 되었습니다.");
		opener.doAction('search');
		this.close();

	}else{
		alert(result);
		return;
	}
}


//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 

			//var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>";	
			//openSearchPopup("/wmdl/showMasterDlCommpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
			
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
	        popupSel = "buyer_single";
	        break;	
		case "get_po_no": // 발주번호
		   if($('#st_buyer_code').val() == ''){
			  
			   alert('고객사를 먼저 선택하세요');
			  $('#st_buyer_code').focus();
			  return;
		   }
			openSearchPopup("/wmre/showMasterWmReReturnPop.do", "?st_buyer_code="+$("#st_buyer_code").val(),"850,485,no");
	        popupSel = "get_po_no";
	        break;	    
		case "get_dept": //부서코드 
			   if($('#st_buyer_code').val() == ''){
					  
				   alert('고객사를 먼저 선택하세요');
				  $('#st_buyer_code').focus();
				  return;
			   }
			   if($("#st_po_no").val() ==''){
				  	 alert(' 발주번호를 먼저 입력 하세요');
					  $('#st_po_no').focus();
					  return;
			   }
			openSearchPopup("/wmco/showMasterWmDeptPop.do", "?st_buyer_code="+$("#st_buyer_code").val(),"680,470,no");
	        popupSel = "get_dept";
			break;

	}
}
//발주정보 셋팅
function setPoInfo(value1, value2){
	$("#st_buyer_name").val("<%=st_buyer_name%>");
	$("#st_buyer_code").val("<%=st_buyer_code%>");
	$("#st_po_no").val("<%=st_po_no%>");
	$("#st_po_seq").val("<%=st_po_seq%>");
	$("#st_legacy_po_no").val("<%=st_legacy_po_no%>");
	$("#st_legacy_po_seq").val("<%=st_legacy_po_seq%>");
	$("#st_buyer_item_no").val("<%=st_buyer_item_no%>");
	$("#st_description").val("<%=st_description%>");
	$("#st_specification").val("<%=st_specification%>");
	$("#st_item_qty").val("<%=st_item_qty%>");
	$("#st_unit_measure").val("<%=st_unit_measure%>");
	$("#st_seller").val("<%=st_seller%>");
	$("#st_process_type").val("<%=st_process_type%>");
	$("#st_process_user_name").val("<%=st_process_user_name%>");
	$("#st_process_type_name").val("<%=st_process_type_name%>");
	$("#st_seller_name").val("<%=st_seller_name%>");
	if("<%=st_b_req_user_id%>" !=""){
		$("#st_wmre_no").val("<%=st_wmre_no_adv%>");
		$("#st_wmre_type").val("<%=st_wmre_type_adv%>");
		$("#st_wmre_qty").val("<%=st_wmre_qty%>");
		$("#st_b_req_remark").val("<%=st_b_req_remark%>");
	}
	if("<%=st_b_req_date%>" =="" ){
		$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	}else{
		$("#st_b_req_date").val("<%=st_b_req_date%>");
	}
	$("#st_warehouse_code").val("<%=st_warehouse_code%>");
	$("#st_b_req_user_id").val("<%=st_pr_add_user_id%>");
	$("#st_buyer_person_name").val("<%=st_pr_add_user_name%>");
	$("#st_buyer_dept_name").val("<%=st_pr_add_user_dept_nm%>");
	$("#st_buyer_dept_code").val("<%=st_pr_add_user_dept%>");
	$("#st_buyer_person_tel").val("<%=st_pr_add_user_tel%>");
	
	if("0" =="<%=st_status_back_code%>" ){
		$('#st_wmre_type').html("<option value='09'>주문취소</option>");
	}else{
		$('#st_wmre_type').html("<option value='01'>반품</option><option value='02'>교환</option><option value='03'>불량</option>");
	}
	getWmreType();
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
			$("#st_buyer_code").val(value1);
			$("#st_buyer_name").val(value2);
			EraserPoNo();
	
	}else if(popupSel == "get_po_no"){
		
		var strVar1 = value1.split('@@');
		var strVar2 = value2.split('@@');
		
		$("#st_po_no").val(strVar1[0]);
		$("#st_po_seq").val(strVar1[1]);
		$("#st_legacy_po_no").val(strVar1[2]);
		$("#st_legacy_po_seq").val(strVar1[3]);
		$("#st_buyer_item_no").val(strVar1[4]);
		$("#st_description").val(strVar1[5]);
		$("#st_specification").val(strVar1[6]);
		$("#st_item_qty").val(strVar1[7]);
		$("#st_unit_measure").val(strVar1[8]);
		$("#st_seller").val(strVar1[9]);
		$("#st_process_type").val(strVar1[10]);
		$("#st_process_user_name").val(strVar1[11]);
		$("#st_process_type_name").val(strVar1[12]);
		$("#st_seller_name").val(strVar1[13]);
		
		if(strVar2[5] !=""){
			
			$("#st_buyer_dept_code").val(strVar2[0]);
			$("#st_buyer_dept_name").val(strVar2[1]);
			$("#st_buyer_person_name").val(strVar2[2]);
			$("#st_buyer_person_tel").val(strVar2[3]);
			if(strVar2[4] =="" ){
				$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			}else{
				$("#st_b_req_date").val(strVar2[4]);
			}

			$("#st_b_req_user_id").val(strVar2[5]);
			$("#st_wmre_no").val(strVar2[6]);
			$("#st_wmre_type").val(strVar2[7]);
			$("#st_wmre_qty").val(strVar2[8]);
			$("#st_b_req_remark").val(strVar2[9]);
			
			
		}
		$("#st_warehouse_code").val(strVar2[11]);
		$("#st_total_wmre_qty").val(strVar2[12]);
		$("#st_b_req_user_id").val(strVar2[13]);
		$("#st_buyer_person_name").val(strVar2[14]);
		$("#st_buyer_person_tel").val(strVar2[15]);
		$("#st_buyer_dept_name").val(strVar2[17]);
		$("#st_buyer_dept_code").val(strVar2[16]);
		
			
		if("0" ==strVar2[10] ){
			$('#st_wmre_type').html("<option value='09'>주문취소</option>");
		}else{
			$('#st_wmre_type').html("<option value='01'>반품</option><option value='02'>교환</option><option value='03'>불량</option>");
		}
		getWmreType();
		
	}else if(popupSel == "get_dept"){
		$("#st_buyer_dept_code").val(value1);		
		$("#st_buyer_dept_name").val(value2);
	
	}else if(popupSel=="attach_popup"){
		//alert(value1);
	   	$("#st_wmre_file").val(value1); 	  
	   	if(value1 != ""){
	   		document.searchCondition.diskimg.src ="/resources/images/disk_on.gif";
	   	}else{
	   		document.searchCondition.diskimg.src ="/resources/images/disk_off.gif";
	   	}
	}
	
	
	grbRow="";	//초기화
}



function getWmreType(){

	if($("#st_wmre_no").val() == ""){
		   //반품인 경우 
		   if("01" ==kepSelectOptionVal('st_wmre_type')){
			   
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type2','getTypeWM02','','SEL');

		   }else if("02" == kepSelectOptionVal('st_wmre_type')){ //교환인 경우 
			
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type2','getTypeWM03','','SEL');
		   
		   }
		
	}else{
		
		   //반품인 경우 
		   if("01" ==$('#st_wmre_type').val()){
			   
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type2','getTypeWM02','','SEL', '<%=st_wmre_type2%>');

		   }else if("02" == $('#st_wmre_type').val()){ //교환인 경우 
			
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type2','getTypeWM03','','SEL','<%=st_wmre_type2%>');
		   
		   }
		   getWmreTypeDetail();
	}

	
}


function getWmreTypeDetail(){
	
	
	if($("st_wmre_no").val() == ""){
		
		   if("01" ==kepSelectOptionVal('st_wmre_type')){
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type3','getTypeWM04',kepSelectOptionVal('st_wmre_type2'),'SEL');
		   }else if("02" == kepSelectOptionVal('st_wmre_type')){ //교환인 경우 
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type3','getTypeWM05',kepSelectOptionVal('st_wmre_type2'),'SEL');
		   }
		   
	}else{
		
		   if("01" ==$('#st_wmre_type').val()){
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type3','getTypeWM04',kepSelectOptionVal('st_wmre_type2'),'SEL','<%=st_wmre_type3%>');
		   }else if("02" == $('#st_wmre_type').val()){ //교환인 경우 
			   kepAjaxCommonQueryIdSearchCombo('st_wmre_type3','getTypeWM05',kepSelectOptionVal('st_wmre_type2'),'SEL','<%=st_wmre_type3%>');
		   }
		
		
	}

}

//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}

//발주수량 체크 
function checkQty(){
	if('' ==$("#st_item_qty").val() ){
		alert('발주수량 값을 먼저 선택 해 주세요.');
		$('#st_po_no').focus();
		return "N";
	}
	<%if(_rowData == null ){ %>
		if(eval($('#st_item_qty').val().replace(/,/gi,"")) < eval($('#st_wmre_qty').val().replace(/,/gi,"")  )){
			alert('반품/교환 수량이 발주수량 보다 클 수 없습니다. ');
			$('#st_wmre_qty').val('');
			$('#st_wmre_qty').focus();
			return "N";
		}
	<%}%>
}

function EraserBuyerCode(){
	$("#st_buyer_code").val('');
	$("#st_buyer_name").val('');

	EraserPoNo();
}

function EraserPoNo(){
	
	$("#st_po_no").val('');
	$("#st_po_seq").val('');
	$("#st_legacy_po_no").val('');
	$("#st_legacy_po_seq").val('');
	$("#st_process_type").val('');
	$("#st_process_type_name").val('');
	$("#st_buyer_item_no").val('');
	$("#st_description").val('');
	$("#st_specification").val('');
	$("#st_item_qty").val('');
	$("#st_unit_measure").val('');
	$("#st_seller").val('');
	$("#st_seller_name").val('');
	$("#st_process_user_name").val('');
	$('#st_wmre_qty').val('');
	$("#st_buyer_dept_code").val('');
	$("#st_buyer_dept_name").val('');
	$("#st_warehouse_code").val('');
	
	
	$("#st_buyer_dept_code").val('');
	$("#st_buyer_dept_name").val('');
	$("#st_buyer_person_name").val('');
	$("#st_buyer_person_tel").val('');
	$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_b_req_user_id").val('');
	$("#st_wmre_no").val('');
	$("#st_wmre_type").val('01');
	$("#st_wmre_qty").val('');
	$("#st_b_req_remark").val('');
}
</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="st_b_req_flag"  name="st_b_req_flag" value="">	
	<input type="hidden" id="st_wmre_no"  name="st_wmre_no" value="<%=st_wmre_no %>" >		
	<input type="hidden" id="st_insert_yn"  name="st_insert_yn" value="<%=CommonUtil.nvl((String) request.getParameter("st_insert_yn"),"") %>">	
    <input type="hidden" id="st_req_flag"  name="st_req_flag" value="<%=CommonUtil.nvl((String) request.getParameter("st_req_flag"),"") %>">	
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
        	<h1 class="title">반품접수등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:518px;">
        	<!--버튼영역-->
            <!--조회영역-->
				<h4><b>발주정보 </b></h4>
<%if(_rowData != null ){ %>				
	<input type="hidden" id="st_FLAG"  name="st_FLAG" value="<%=CommonUtil.nvl(_rowData.get("FLAG"))  %>"  >	
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%"/>
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                               
						</colgroup>
						<tbody>
						  <tr>		
						  	<th>고객사</th>  		
							<td><input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  readonly  value ="<%=CommonUtil.nvl(_rowData.get("BUYER_NAME")) %>"  oncahange="EraserPoNo();" />
								  <input type="hidden" name="st_buyer_code" id="st_buyer_code"   value ="<%=CommonUtil.nvl(_rowData.get("BUYER")) %>"  style="width:80%" value="">
						
							</td>
							<th>발주번호</th>			
							<td><input type="text" name="st_po_no" id="st_po_no" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" value ="<%=CommonUtil.nvl(_rowData.get("PO_NO")) %>"   readonly/>
		                   
							</td>
							<th>발주순번</th>
							<td><input type="text" name="st_po_seq" id="st_po_seq" class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("PO_SEQ")) %>"  style="width:90%;background:#EAEAEA;" readonly /></td>
						 </tr>
						 <tr>				
							
							<th>IF발주번호</th>			
							<td><input type="text" name="st_legacy_po_no" id="st_legacy_po_no" class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("LEGACY_PO_NO")) %>" style="width:90%;background:#EAEAEA;" readonly/></td>	
							<th>IF발주순번</th>			
							<td><input type="text" name="st_legacy_po_seq" id="st_legacy_po_seq" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("LEGACY_PO_SEQ")) %>"  style="width:90%;background:#EAEAEA;" readonly/></td>		
							<th>출고구분</th>			
							<td ><input type="text" name="st_process_type_name" id="st_process_type_name" class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("PROCESS_TEXT")) %>"   style="width:90%;background:#EAEAEA;" readonly/>
							<input type="hidden" name="st_process_type" id="st_process_type"  value ="<%=CommonUtil.nvl(_rowData.get("PROCESS_TYPE")) %>"   class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly/></td>																														  	
						  </tr>
						  <tr>
							<th>품목코드</th>			
							<td><input type="text" name="st_buyer_item_no" id="st_buyer_item_no" class="input_type_text" value ="<%=CommonUtil.nvl(_rowData.get("BUYER_ITEM_NO")) %>"  title="" style="width:90%;background:#EAEAEA;" readonly /></td>
							<th>품목명</th>			
							<td><input type="text" name="st_description" id="st_description" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("DESCRIPTION")) %>"   style="width:90%;background:#EAEAEA;"readonly /></td>
							<th>규격</th>			
							<td ><input type="text" name="st_specification" id="st_specification" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("SPECIFICATION")) %>"   style="width:90%;background:#EAEAEA;"readonly /></td>	
						  </tr>
						  <tr>
							<th>발주수량</th>			
							<td><input type="text" name="st_item_qty" id="st_item_qty" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("ITEM_QTY")) %>"  style="width:90%;background:#EAEAEA;" readonly /></td>
							<th>단위</th>			
							<td><input type="text" name="st_unit_measure" id="st_unit_measure" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("UNIT_MEASURE")) %>" style="width:90%;background:#EAEAEA;" readonly/></td>
							<th>협력사</th>			
							<td><input type="text" name="st_seller_name" id="st_seller_name" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("SELLER_NAME")) %>"  style="width:90%;background:#EAEAEA;"readonly />
							<input type="hidden" name="st_seller" id="st_seller" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("SELLER")) %>"  style="width:90%;background:#EAEAEA;"readonly /></td>																		  	
						  </tr>	
					</tbody>
				</table>	
				<h4><b>고객사 요청정보 </b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                   
						</colgroup>
						<tbody>	
						  <tr >
							<th>고객요청부서</th>			
							<td><input type="text" name="st_buyer_dept_name" id="st_buyer_dept_name" class="input_type_text" title=""   value ="<%=CommonUtil.nvl(_rowData.get("BUYER_DEPT_NAME")) %>" style="width:90%;background:#EAEAEA;" readonly />					
							</td>
							<th>고객요청자</th>			
							<td><input type="text" name="st_buyer_person_name" id="st_buyer_person_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" value ="<%=CommonUtil.nvl(_rowData.get("BUYER_PERSON_NAME")) %>"  readonly/>
							</td>
							<th>고객연락처</th>			
							<td><input type="text" name="st_buyer_person_tel" id="st_buyer_person_tel" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("BUYER_PERSON_TEL")) %>"  style="width:90%;background:#EAEAEA;" readonly/></td>
						 </tr>
						 <tr>	
							<th>요청일자</th>			
							<td><input type="text" class="input_type_text" name="st_b_req_date" id="st_b_req_date" value ="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("B_REQ_DATE"))) %>"   style="width:90%;background:#EAEAEA;"readonly />
							</td>	
							<th>요청사유</th>			
							<td colspan="3"><input type="text" name="st_b_req_remark" id="st_b_req_remark" class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("B_REQ_REMARK")) %>"  style="width:97%;background:#EAEAEA;" onkeyup="fnCheckInputByte(this, 500);"  readonly/></td>																								  	
						  </tr>
						 <tr>	
							<th>기반품수량</th>			
							<td><input type="text" name="st_total_wmre_qty" id="st_total_wmre_qty" class="input_type_text" title="" value ="<%=CommonUtil.formatNumber(String.valueOf(_rowData.get("TOTAL_WMRE_QTY")),true,0,0)%>"  readonly style="width:90%;background:#EAEAEA;" maxlength="15"  /></td>
							<th>요청수량(반품/불량)</th>			
							<td><input type="text" name="st_wmre_qty" id="st_wmre_qty" class="input_type_text" title="" value ="<%=CommonUtil.formatNumber(String.valueOf(_rowData.get("WMRE_QTY")),true,0,0)%>"  readonly style="width:90%;background:#EAEAEA;" maxlength="15" onkeyup="checkQty();"/></td>
							<th>요청구분</th>			
							<td><input type="text" name="st_wmre_type_name" id="st_wmre_type_name" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_NAME")) %>"  style="width:90%;background:#EAEAEA;" readonly/>
							<input type="hidden" name="st_wmre_type"  id="st_wmre_type" value ="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE")) %>"/>
							</td>																													  	
						  </tr>						  
					</tbody>
				</table>	
				<h4><b>운영사 접수정보 </b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                              
						</colgroup>
						<tbody>
						<tr>
							<th>접수자</th>			
							<td><input type="text" name="st_add_user_name" id="st_add_user_name" class="input_type_text" title=""   value="<%="".equals(CommonUtil.nvl(_rowData.get("M_REC_USER_NAME")))?userName:_rowData.get("M_REC_USER_NAME") %>" style="width:90%;background:#EAEAEA;" readOnly/>
								<input type="hidden" name="st_add_user_id" id="st_add_user_id" class="input_type_text" title=""   value="${sessionInfo.userId}" />
							</td>
							<td></td>
							<td><input type="hidden" name="st_process_user_name" id="st_process_user_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"   value ="" readonly/>
								<input type= "hidden" name= "st_warehouse_code"  id="st_warehouse_code">
							</td>
							<th>물품수령여부</th>
					<% if(  ("19".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ||  "13".equals(CommonUtil.nvl(_rowData.get("FLAG")) ) ) ) {%>
							<td><input type="text" name="st_delivery_flag" id="st_delivery_flag" class="input_type_text" title=""   value="<%=CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")) %>" style="width:90%;background:#EAEAEA;" readOnly/>
							</td>
					<%}else{ %>
							<td>
								<select id="st_delivery_flag" name="st_delivery_flag" style="width:95%;height:20px">
									<option value=""  <%if ("".equals(CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")))){%>selected<%}%>>선택</option>
									<option value="Y" <%if ("Y".equals(CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")))){%>selected<%}%>>Y</option>
									<option value="N" <%if ("N".equals(CommonUtil.nvl(_rowData.get("DELIVERY_FLAG")))){%>selected<%}%>>N</option>
								</select>
							</td>
					<%} %>		
						</tr>
					<% if(  ("19".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ||  "13".equals(CommonUtil.nvl(_rowData.get("FLAG")) ) ) ) {%>				 
						<tr height="50">
							<th>접수일자</th>			
							<td><input type="text" class="input_type_text" name="st_m_rec_date_r" id="st_m_rec_date_r"   value ="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("M_REC_DATE"))) %>"style="width:90%;background:#EAEAEA;" readOnly    />
						
							<th>접수비고</th>
							<td colspan="3"><input type="text" name="st_m_rec_remark" id="st_m_rec_remark"   class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("M_REC_REMARK")) %>" style="width:97%;background:#EAEAEA;" readOnly   /><br>※ 특이사항 및 반출증 관련 정보 입력 (예시. 10/07 반출증 준비)</td>
						</tr>
					<%}else{ %>	  
						<tr height="50">		
							<th>접수일자</th>			
							<td><input type="text" class="input_type_text" name="st_m_rec_date" id="st_m_rec_date"   value ="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("M_REC_DATE"))) %>" style="width:75%" readOnly  />
							<a href="javascript:kepCalendar('st_m_rec_date')"></a>		
							<th>접수비고</th>
							<td colspan="3"><input type="text" name="st_m_rec_remark" id="st_m_rec_remark"  class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("M_REC_REMARK")) %>" style="width:97%;" onkeyup="fnCheckInputByte(this, 500);"/><br>※ 특이사항 및 반출증 관련 정보 입력 (예시. 10/07 반출증 준비)</td>
						</tr>
					<%} %>
					</tbody>
				</table>		
					<% if(  ("19".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ||  "13".equals(CommonUtil.nvl(_rowData.get("FLAG")) ) ) ) {%>			
				<h4><b>귀책 정보</b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%"/>
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                     
						</colgroup>
						<tbody>
						  <tr>
							<th>귀책 대상</th>			
							<td>
							<input type="text"id="st_wmre_type2"  name="st_wmre_type2" class="input_type_text" style="width:90%;background:#EAEAEA;" readOnly   value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE2_NAME")) %>"/>
							</td>
							<th>귀책 사유</th>			
							<td ><input type="text" id="st_wmre_type3"  name="st_wmre_type3" class="input_type_text" style="width:90%;background:#EAEAEA;"  readOnly  value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE3_NAME")) %>" /></td>				
							<td></td>
							<td></td>
						 </tr>
						 <tr>																										  	
							<th>귀책 상세사유</th>			
							<td><input type="text" name="st_wmre_type_detail" id="st_wmre_type_detail" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  readOnly    value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_DETAIL")) %>" /></td>
							<th>파일첨부</th>			
							<td ><input type="hidden" name="st_wmre_file" id="st_wmre_file" class="al" title="" style="width:20%;"   value="<%=CommonUtil.nvl(_rowData.get("WMRE_FILE")) %>"/>
							<% if("".equals(CommonUtil.nvl(_rowData.get("WMRE_FILE")) )) {%>
							<a href="javascript:attach_popup();"><img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"  > </a>
							<%}else{ %>
							<a href="javascript:attach_popup();"><img id="diskimg" src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"  > </a>
							<%} %>
							</td>
							<td></td>
							<td></td>
						  </tr>			
					</tbody>
				</table>
				
			<%}else{ %>	
				<h4><b>귀책 정보</b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%"/>
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                     
						</colgroup>
						<tbody>
						  <tr>
							<th>귀책 대상</th>			
							<td>
							<select id="st_wmre_type2"  name="st_wmre_type2" style="width:95%;height:20px" onChange="getWmreTypeDetail();"   >
							</td>
							<th>귀책 사유</th>			
							<td ><select id="st_wmre_type3"  name="st_wmre_type3" style="width:95%;height:20px"  ></td>
							<td></td>
							<td></td>				
						 </tr>
						 <tr>																										  	
							<th>귀책 상세사유</th>			
							<td><input type="text" name="st_wmre_type_detail" id="st_wmre_type_detail" class="input_type_text" title="" style="width:90%;"  value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_DETAIL")) %>" onkeyup="fnCheckInputByte(this, 100);" /></td>
							<th>파일첨부</th>			
							<td ><input type="hidden" name="st_wmre_file" id="st_wmre_file" class="al" title="" style="width:20%;"   value="<%=CommonUtil.nvl(_rowData.get("WMRE_FILE")) %>"/>
							<% if("".equals(CommonUtil.nvl(_rowData.get("WMRE_FILE")) )) {%>
							<a href="javascript:attach_popup();"><img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"  > </a>
							<%}else{ %>
							<a href="javascript:attach_popup();"><img id="diskimg" src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"  > </a>
							<%} %>
							</td>
							<td></td>
							<td></td>
						  </tr>			
					</tbody>
				</table>			
			<%} %>
			
<%}else{ %>
	<input type="hidden" id="st_FLAG"  name="st_FLAG" value=""  >	
		<table class="cont_t_list07" style="width:100%">
						
						<colgroup>
						<col width="12%"/>
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                              
						</colgroup>
						<tbody>
						  <tr>		
						  	<th>고객사</th>  		
							<td><input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" title="" style="width:60%;"  readonly onclick="javascript:doPop('buyer_single');"  oncahange="EraserPoNo();" />
								  <input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:EraserBuyerCode();"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>발주번호</th>			
							<td><input type="text" name="st_po_no" id="st_po_no" class="input_type_text" title="" style="width:60%;" readonly onclick="javascript:doPop('get_po_no');"/>
		                        <a href="javascript:doPop('get_po_no');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:EraserPoNo();"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>발주순번</th>
							<td><input type="text" name="st_po_seq" id="st_po_seq" class="input_type_text" title=""  style="width:90%;background:#EAEAEA;" readonly /></td>
						 </tr>
						 <tr>				
							
							<th>IF발주번호</th>			
							<td><input type="text" name="st_legacy_po_no" id="st_legacy_po_no" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly/></td>	
							<th>IF발주순번</th>			
							<td><input type="text" name="st_legacy_po_seq" id="st_legacy_po_seq" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly/></td>		
							<th>출고구분</th>			
							<td ><input type="text" name="st_process_type_name" id="st_process_type_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly/>
							<input type="hidden" name="st_process_type" id="st_process_type" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly/></td>																														  	
						  </tr>
						  <tr>
							<th>품목코드</th>			
							<td><input type="text" name="st_buyer_item_no" id="st_buyer_item_no" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly /></td>
							<th>품목명</th>			
							<td><input type="text" name="st_description" id="st_description" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"readonly /></td>
							<th>규격</th>			
							<td ><input type="text" name="st_specification" id="st_specification" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"readonly /></td>	
						  </tr>
						  <tr>
							<th>발주수량</th>			
							<td><input type="text" name="st_item_qty" id="st_item_qty" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly /></td>
							<th>단위</th>			
							<td><input type="text" name="st_unit_measure" id="st_unit_measure" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly/></td>
							<th>협력사</th>			
							<td><input type="text" name="st_seller_name" id="st_seller_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"readonly />
							<input type="hidden" name="st_seller" id="st_seller" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"readonly /></td>																		  	
						  </tr>	
					</tbody>
				</table>	
				<h4><b>고객사 요청정보 </b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                   
						</colgroup>
						<tbody>	
						  <tr >
							<th>고객요청부서</th>			
							<td><input type="text" name="st_buyer_dept_name" id="st_buyer_dept_name" class="input_type_text" title="" style="width:60%;" readonly onclick="javascript:doPop('get_dept');"/>
								<input type="hidden" name="st_buyer_dept_code" id="st_buyer_dept_code" style="width:80%" value="">
		                        <a href="javascript:doPop('get_dept');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_dept_code','st_buyer_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a> 							
							</td>
							<th>고객요청자</th>			
							<td><input type="text" name="st_buyer_person_name" id="st_buyer_person_name" class="input_type_text" title="" style="width:90%;" onkeyup="fnCheckInputByte(this, 20);"/>
							<input type="hidden" name="st_b_req_user_id" id="st_b_req_user_id" class="input_type_text" title="" style="width:90%;" />
							</td>
							<th>고객연락처</th>			
							<td><input type="text" name="st_buyer_person_tel" id="st_buyer_person_tel" class="input_type_text" title="" style="width:90%;" onkeyup="fnCheckInputByte(this, 20);"/></td>
						 </tr>
						 <tr>	
							<th>요청일자</th>			
							<td><input type="text" class="input_type_text" name="st_b_req_date" id="st_b_req_date" style="width:75%;" readOnly />
							<a href="javascript:kepCalendar('st_b_req_date')"></a>
							</td>	
							<th>요청사유</th>			
							<td colspan="3"><input type="text" name="st_b_req_remark" id="st_b_req_remark" class="input_type_text" title="" style="width:97%;" onkeyup="fnCheckInputByte(this, 500);" /></td>																								  	
						  </tr>
						 <tr>	
							<th>기반품수량</th>			
							<td><input type="text" name="st_total_wmre_qty" id="st_total_wmre_qty" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" maxlength="15"   readonly/></td>
							<th>요청수량(반품/불량)</th>			
							<td><input type="text" name="st_wmre_qty" id="st_wmre_qty" class="input_type_text" title="" style="width:90%;" maxlength="15"  onkeyup="checkQty();" /></td>
							<th>요청구분</th>			
							<td>
							 <select  name="st_wmre_type" id= "st_wmre_type" style="width:95%;height:20px"  onChange="getWmreType();">
							 </select>
							</td>																														  	
						  </tr>						  
					</tbody>
				</table>	
				<h4><b>운영사 접수정보 </b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                 
						</colgroup>
						<tbody>
						  <tr>
							<th>접수자</th>			
							<td><input type="text" name="st_add_user_name" id="st_add_user_name" class="input_type_text" title=""   value="${sessionInfo.userNameLoc}"  style="width:90%;"onkeyup="fnCheckInputByte(this, 30);" readOnly/>
							<input type="hidden" name="st_add_user_id" id="st_add_user_id" class="input_type_text" title=""   value="${sessionInfo.userId}" /></td>
							<th>진행관리자</th>			
							<td><input type="text" name="st_process_user_name" id="st_process_user_name" class="input_type_text" title="" style="width:90%; background:#EAEAEA;" readonly/>
								<input type= "hidden" name= "st_warehouse_code"  id="st_warehouse_code"></td>
							<th>물품수령여부</th>
							<td>
								<select id="st_delivery_flag" name="st_delivery_flag" style="width:95%;height:20px">
									<option value='' selected>선택</option>
									<option value='Y'>Y</option>
									<option value='N'>N</option>
								</select>
							</td>
						 </tr>
						 <tr height="50">		
							<th>접수일자</th>			
							<td><input type="text" class="input_type_text" name="st_m_rec_date" id="st_m_rec_date" style="width:75%;" readOnly  />
							<a href="javascript:kepCalendar('st_m_rec_date')"></a>		
							<th>접수비고</th>			
							<td colspan="3"><input type="text" name="st_m_rec_remark" id="st_m_rec_remark" class="input_type_text" title="" style="width:97%;onkeyup="fnCheckInputByte(this, 500);"/><br>※ 특이사항 및 반출증 관련 정보 입력 (예시. 10/07 반출증 준비)</td>																								  	
						  </tr>
					</tbody>
				</table>	
	
		
						<h4><b>귀책 정보</b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="12%" />
                        <col width="20%" />
                        <col width="16%"/>
                        <col width="20%" />
                        <col width="13%"/>  
                        <col width="*" />                                                     
						</colgroup>
						<tbody>
						  <tr>
							<th>귀책 대상</th>			
							<td>
							<select id="st_wmre_type2"  name="st_wmre_type2" style="width:95%;height:20px" onChange="getWmreTypeDetail();"  >
							</td>
							<th>귀책 사유</th>			
							<td ><select id="st_wmre_type3"  name="st_wmre_type3" style="width:95%;height:20px"></td>
							<td></td>
							<td></td>
						 </tr>
						 <tr>																										  	
							<th>귀책 상세사유</th>			
							<td><input type="text" name="st_wmre_type_detail" id="st_wmre_type_detail" class="input_type_text" title="" style="width:90%;"  onkeyup="fnCheckInputByte(this, 100);" /></td>
							<th>파일첨부</th>			
							<td ><input type="hidden" name="st_wmre_file" id="st_wmre_file" class="al" title="" style="width:20%;"   value=""/>
							<a href="javascript:attach_popup();"><img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"  > </a>
							</td>
							<td></td>
							<td></td>
						  </tr>			
					</tbody>
				</table>
<%} %>				
            <!--grid-->

			<span class="fr">
			<% if(  !("Y".equals(CommonUtil.nvl((String) request.getParameter("st_req_flag"),"")  )  )) {%>
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
			<%} %>	
			</span>
			<br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
