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
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;
	String st_wmre_no ="";
	String st_wmre_type2 = "";
	String st_wmre_type3 ="";
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		st_wmre_no =		CommonUtil.nvl(_rowData.get("WMRE_NO"));
		st_wmre_type2 =  CommonUtil.nvl(_rowData.get("WMRE_TYPE2"));
		st_wmre_type3 = CommonUtil.nvl(_rowData.get("WMRE_TYPE3"));
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

	kepSetCalender("st_m_rec_date");
	kepSetCalender("st_s_rec_date");
	if( $('#st_wmre_no').val()  == ""){
		   kepSetCalender("st_b_req_date");
		$("#st_s_rec_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	}
	
	if($("#st_s_rec_date").val() == ""){
		$("#st_s_rec_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	}
	
	if($('#st_FLAG').val() == "01"){
		$("#st_s_rec_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	}		
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
			if($('#st_buyer_dept_code').val()==""){
				alert("고객요청부서를 입력하세요");
				document.searchCondition.st_buyer_dept_name.focus();
				return;
			}
			if( $('#st_buyer_person_name').val()==""){
				alert("고객요청자를 입력하세요");
				document.searchCondition.st_buyer_person_name.focus();
				return;
			}
		
			if("" == $('#st_buyer_person_tel').val()){
				alert("고객연락처를 입력하세요");
				document.searchCondition.st_buyer_person_tel.focus();
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
			
			if(document.searchCondition.st_wmre_type.value =="01" || document.searchCondition.st_wmre_type.value =="02"){
				
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
				
			}

			checkQty();  //발주수량과 비교 
	
			
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

			var st_warehouse_code = "<%=CommonUtil.nvl((String) request.getParameter("st_warehouse_code"),"") %>";	
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
			openSearchPopup("/wmre/showMasterWmReReturnPop.do", "?st_buyer_code="+$("#st_buyer_code").val()+"&st_com_code="+$('#st_com_code').val(),"850,485,no");
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

function  attach_popup(){	

	var type = "WR";
	var viewType = "C";
	var img_key = $("#st_wmre_file").val(); 
	kepFileUploadOpenPopup(img_key,type,viewType); 
   popupSel = "attach_popup";
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
			$("#st_b_req_date").val(strVar2[4]);
			$("#st_b_req_user_id").val(strVar2[5]);
			$("#st_wmre_no").val(strVar2[6]);
			$("#st_wmre_type").val(strVar2[7]);
			$("#st_wmre_qty").val(strVar2[8]);
			$("#st_b_req_remark").val(strVar2[9]);
			
		}
		if("1" ==strVar2[10] ){
			$('#st_wmre_type').html("<option value='09'>주문취소</option>");
		}else{
			$('#st_wmre_type').html("<option value='01'>반품</option><option value='02'>교환</option>");
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
	var search = kepSelectOptionVal('st_warehouse_code');
   //반품인 경우 
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

/**
* 천자리 콤마 추가
* return
*/
function addComma(num){

  if(num<1000){

   return num;

  }

    var len, point, str;  

 

    num = num + "";  

    point = num.length % 3;

    len = num.length;  

 

    str = num.substring(0, point);  

    while (point < len) {  

        if (str != "") str += ",";  

        str += num.substring(point, point + 3);  

        point += 3;  

    }  

    return str;  

}


//발주수량 체크 
function checkQty(){
	if('' ==$("#st_item_qty").val() ){
		alert('발주수량 값을 먼저 선택 해 주세요.');
		$('#st_po_no').focus();
		return;
	}
	if(eval($('#st_item_qty').val().replace(/,/gi,"")) < eval($('#st_wmre_qty').val().replace(/,/gi,"")  )){
		alert('반품/교환 수량이 발주수량 보다 클 수 없습니다. ');
		$('#st_wmre_qty').val('');
		$('#st_wmre_qty').focus();
		return;
	}
}

/**
* 입력값 숫자인지 체크 후 콤마를 붙임
* return
*/
function checkNumAddComma(obj){
	
	if(obj.value != null && obj.value !=''){	
		obj.value = obj.value.replace(/[^0-9]/g, '') ;
		//발주수량 체크 
		checkQty();
		obj.value =  addComma(obj.value);
	}
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
}
</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="st_b_req_flag"  name="st_b_req_flag" value="">	
	<input type="hidden" id="st_wmre_no"  name="st_wmre_no" value="<%=st_wmre_no%>">
     <input type="hidden" id="st_seller_flag"  name="st_seller_flag" value="Y">
	<input type="hidden" id="st_insert_yn"  name="st_insert_yn" value="<%=CommonUtil.nvl((String) request.getParameter("st_insert_yn"),"") %>">		
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
						<col width="13%"/>
                        <col width="20%" />
                        <col width="15%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                               
						</colgroup>
						<tbody>
						  <tr>		
						  	<th>고객사</th>  		
							<td><input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  readonly onclick="javascript:doPop('buyer_single');"  value ="<%=CommonUtil.nvl(_rowData.get("BUYER_NAME")) %>"  oncahange="EraserPoNo();" />
								  <input type="hidden" name="st_buyer_code" id="st_buyer_code"   value ="<%=CommonUtil.nvl(_rowData.get("BUYER")) %>"  style="width:80%" value="">
					
							</td>
							<th>발주번호</th>			
							<td><input type="text" name="st_po_no" id="st_po_no" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" value ="<%=CommonUtil.nvl(_rowData.get("PO_NO")) %>"   readonly onclick="javascript:doPop('get_po_no');"/>
		                    
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
						<col width="13%" />
                        <col width="20%" />
                        <col width="15%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                   
						</colgroup>
						<tbody>	
						  <tr >
							<th>고객요청부서</th>			
							<td><input type="text" name="st_buyer_dept_name" id="st_buyer_dept_name" class="input_type_text" title=""   value ="<%=CommonUtil.nvl(_rowData.get("BUYER_DEPT_NAME")) %>" style="width:90%;background:#EAEAEA;" readonly onclick="javascript:doPop('get_dept');"/>
								<input type="hidden" name="st_buyer_dept_code" id="st_buyer_dept_code" style="width:80%" value ="<%=CommonUtil.nvl(_rowData.get("BUYER_DEPT_CODE")) %>" >
		                      						
							</td>
							<th>고객요청자</th>			
							<td><input type="text" name="st_buyer_person_name" id="st_buyer_person_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" value ="<%=CommonUtil.nvl(_rowData.get("BUYER_PERSON_NAME")) %>"  readonly onkeyup="fnCheckInputByte(this, 20);"/>
							<!--  input type="hidden" name="st_b_req_user_id" id="st_b_req_user_id" class="input_type_text" title=""  style="width:90%;" />-->
							</td>
							<th>고객연락처</th>			
							<td><input type="text" name="st_buyer_person_tel" id="st_buyer_person_tel" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("BUYER_PERSON_TEL")) %>"  style="width:90%;background:#EAEAEA;" onkeyup="fnCheckInputByte(this, 20);" readonly/></td>
						 </tr>
						 <tr>	
							<th>요청일자</th>			
							<td><input type="text" class="input_type_text" name="st_b_req_date" id="st_b_req_date" value ="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("B_REQ_DATE"))) %>" style="width:90%;background:#EAEAEA;"   readOnly />
							</td>	
							<th>요청사유</th>			
							<td colspan="3"><input type="text" name="st_b_req_remark" id="st_b_req_remark" class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("B_REQ_REMARK")) %>"  style="width:97%;background:#EAEAEA;" onkeyup="fnCheckInputByte(this, 500);" readOnly/></td>																								  	
						  </tr>
						 <tr>	
							<th>요청수량</th>			
							<td><input type="text" name="st_wmre_qty" id="st_wmre_qty" class="input_type_text" title="" value ="<%=CommonUtil.formatNumber(String.valueOf(_rowData.get("WMRE_QTY")),true,0,0)%>"  style="width:90%;background:#EAEAEA;" readOnly maxlength="15"  onkeyup="checkNumAddComma(this);"/></td>
							<th>요청구분</th>			
							<td colspan="3"><input type="text" name="st_wmre_type_name" id="st_wmre_type_name" class="input_type_text" title="" value ="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_NAME")) %>"  style="width:34%;background:#EAEAEA;" readonly/>
							<input type="hidden" name="st_wmre_type"  id="st_wmre_type" value ="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE")) %>"/>
							</select>
							</td>																														  	
						  </tr>						  
					</tbody>
				</table>	
				<h4><b>협력사 접수정보 </b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="13%" />
                        <col width="20%" />
                        <col width="15%"/>
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                             
						</colgroup>
						<tbody>
						  <tr>
							<th>접수자</th>			
							<td><input type="text" name="st_add_user_name" id="st_add_user_name" class="input_type_text" title=""   value="<%="".equals(CommonUtil.nvl(_rowData.get("S_REC_USER_NAME")))?userName:_rowData.get("S_REC_USER_NAME") %>"  style="width:90%;background:#EAEAEA;"onkeyup="fnCheckInputByte(this, 30);" readOnly/>
							<input type="hidden" name="st_add_user_id" id="st_add_user_id" class="al" title=""   value="${sessionInfo.userId}" /></td>
							<th>진행관리자</th>			
							<td ><input type="text" name="st_process_user_name" id="st_process_user_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  value ="<%=CommonUtil.nvl(_rowData.get("PROCESS_USER_NAME")) %>"  readonly/></td>
							<th>물품수령여부</th>
						<% if(  "02".equals(CommonUtil.nvl(_rowData.get("FLAG")) )   ||"19".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ||  "13".equals(CommonUtil.nvl(_rowData.get("FLAG")) )    ) {%>
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
						 <% if(  "02".equals(CommonUtil.nvl(_rowData.get("FLAG")) )   ||"19".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ||  "13".equals(CommonUtil.nvl(_rowData.get("FLAG")) )    ) {%>	
						 <tr>		
							<th>접수일자</th>			
							<td><input type="text" class="input_type_text" name="st_s_rec_date_s" id="st_s_rec_date_s"   value ="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("S_REC_DATE"))) %>" style="background:#EAEAEA;" readonly />
							<th>접수비고</th>			
							<td colspan="3"><input type="text" name="st_m_rec_remark" id="st_m_rec_remark" class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("M_REC_REMARK")) %>" style="background:#EAEAEA;width:97%;" readonly /></td>																								  	
						  </tr>
						<%}else{ %>	 
						 <tr>		
							<th>접수일자</th>			
							<td><input type="text" class="input_type_text" name="st_s_rec_date" id="st_s_rec_date"   value ="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("S_REC_DATE"))) %>" readOnly  />
							<a href="javascript:kepCalendar('st_s_rec_date')"></a>		
							<th>접수비고</th>			
							<td colspan="3"><input type="text" name="st_m_rec_remark" id="st_m_rec_remark" class="input_type_text" title=""  value ="<%=CommonUtil.nvl(_rowData.get("M_REC_REMARK")) %>" style="width:97%;" onkeyup="fnCheckInputByte(this, 500);"/></td>																								  	
						  </tr>						
						<%} %> 
					</tbody>
				</table>	
				
				<h4><b>귀책 정보</b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="13%" />
                        <col width="20%" />
                        <col width="15%"/>
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                     
						</colgroup>
						<tbody>
						<% if(  "02".equals(CommonUtil.nvl(_rowData.get("FLAG")) ) ||"19".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ||  "13".equals(CommonUtil.nvl(_rowData.get("FLAG")) )  ) {%>	
						  <tr>
							<th>귀책 대상</th>			
							<td>
							<input type="text" id="st_wmre_type2"  name="st_wmre_type2" style="width:90%;background:#EAEAEA;" readOnly   value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE2_NAME")) %>" />
							</td>
							<th>귀책 사유</th>			
							<td ><input type="text"  id="st_wmre_type3"  name="st_wmre_type3" style="width:90%;background:#EAEAEA;"  readOnly  value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE3_NAME")) %>" /></td>
							<td></td>
							<td></td>				
						 </tr>
						 <tr>																										  	
							<th>귀책 상세사유</th>			
							<td><input type="text" name="st_wmre_type_detail" id="st_wmre_type_detail" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  readOnly value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_DETAIL")) %>"  /></td>
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
						<%}else{ %>	 
						  <tr>
							<th>귀책 대상</th>			
							<td>
							<select id="st_wmre_type2"  name="st_wmre_type2" style="width:95%;height:20px" onChange="getWmreTypeDetail();">
							</td>
							<th>귀책 사유</th>			
							<td ><select id="st_wmre_type3"  name="st_wmre_type3" style="width:95%;height:20px"></td>
							<td></td>
							<td></td>
						 </tr>
						 <tr>																										  	
							<th>귀책 상세사유</th>			
							<td><input type="text" name="st_wmre_type_detail" id="st_wmre_type_detail" class="input_type_text" title="" style="width:90%;"  value="<%=CommonUtil.nvl(_rowData.get("WMRE_TYPE_DETAIL")) %>"  onkeyup="fnCheckInputByte(this, 100);" /></td>
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
						<%} %> 			
					</tbody>
				</table>	
				
<%}else{ %>
	<input type="hidden" id="st_FLAG"  name="st_FLAG" value=""  >		 
		<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="13%"/>
                        <col width="20%" />
                        <col width="15%" />
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
						<col width="13%" />
                        <col width="20%" />
                        <col width="15%" />
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
							<td><input type="text" class="input_type_text" name="st_b_req_date" id="st_b_req_date" readOnly />
							<a href="javascript:kepCalendar('st_b_req_date')"></a>
							</td>	
							<th>요청사유</th>			
							<td colspan="3"><input type="text" name="st_b_req_remark" id="st_b_req_remark" class="input_type_text" title="" style="width:97%;" onkeyup="fnCheckInputByte(this, 500);"/></td>																								  	
						  </tr>
						 <tr>	
							<th>요청수량</th>			
							<td><input type="text" name="st_wmre_qty" id="st_wmre_qty" class="input_type_text" title="" style="width:90%;" maxlength="15"  onkeyup="checkNumAddComma(this);"/></td>
							<th>요청구분</th>			
							<td colspan="3">
							 <select  name="st_wmre_type" id= "st_wmre_type" style="width:35%;height:20px"  onChange="getWmreType();">
							 
							</select>
							</td>																														  	
						  </tr>						  
					</tbody>
				</table>	
				<h4><b>협력사 접수정보 </b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="13%" />
                        <col width="20%" />
                        <col width="15%" />
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
							<td><input type="text" name="st_process_user_name" id="st_process_user_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  readonly/></td>
							<th>물품수령여부</th>
							<td>
								<select id="st_delivery_flag" name="st_delivery_flag" style="width:95%;height:20px">
									<option value='' selected>선택</option>
									<option value='Y'>Y</option>
									<option value='N'>N</option>
								</select>
							</td>
						 </tr>
						 <tr>		
							<th>접수일자</th>			
							<td><input type="text" class="input_type_text" name="st_s_rec_date" id="st_s_rec_date" readOnly  />
							<a href="javascript:kepCalendar('st_s_rec_date')"></a>		
							<th>접수비고</th>			
							<td colspan="3"><input type="text" name="st_m_rec_remark" id="st_m_rec_remark" class="input_type_text" title="" style="width:97%;" onkeyup="fnCheckInputByte(this, 500);"/></td>
						  </tr>
					</tbody>
				</table>	
							
				<h4><b>귀책 정보</b></h4>					 						  
            	<table class="cont_t_list07" style="width:100%">
						<caption>조회</caption>
						<colgroup>
						<col width="13%" />
                        <col width="20%" />
                        <col width="15%" />
                        <col width="20%" />
                        <col width="13%"/>
                        <col width="*" />                                                     
						</colgroup>
						<tbody>
						  <tr>
							<th>귀책 대상</th>			
							<td>
							<select id="st_wmre_type2"  name="st_wmre_type2" style="width:95%;height:20px" onChange="getWmreTypeDetail();">
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
			<% if(!"Y".equals(  CommonUtil.nvl((String) request.getParameter("st_end_cancel"),"") )  ) { %>
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
			<% }%>	
			</span>
			<br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
