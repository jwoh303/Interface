<%--
**********************************************
* 메뉴 : 
* 화면 : 반품 요청 (고객사)_반품요청 등록 (주문취소일 경우) 
* 기능 : 반품요청 등록 (주문취소일 경우) 
* 프로그램 ID : PG_08_M_019_01
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-9-16
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	String buyer = "";
	String userid = "";
	
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	Map<String,String> _dataMap = null;
	if (_dataList != null || _dataList.size() != 0){
		_dataMap = _dataList.get(0);
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

var st;
var mt;
function popupOnload(){
	

	// 조회조건 초기화
	kepSetCalender("st_b_req_date");
	$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
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
			if($('#st_buyer').val() == ""){
				//고객사를 선택하세요.
				alert("<%=CommonLang.msg("MSG473") %>");
				document.searchCondition.st_buyer_name.focus();
				return;
			}
			if($('#st_po_no') == ""){
				//발주번호를 입력하세요
				alert("<%=CommonLang.msg("MSG474") %>");
				document.searchCondition.st_po_no.focus();
				return;
			}
			if(document.searchCondition.st_wmre_type.value == ""){
				//요청 구분을 선택 하세요
				alert("<%=CommonLang.msg("MSG475") %>");
				document.searchCondition.st_wmre_type.focus();
				return;
			}
			//주문취소 요청 등록을 하시겠습니까?
		    if(!confirm("<%=CommonLang.msg("MSG476") %>  ")) {
		        return;
		    }else{
		       kepAjaxFormCall("/wmre/saveMasterWmReReturnEntryForBuyerCancelPop.do","searchCondition","save"); 	   
		    }
			break;
	}

}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "save"){ 
		//주문취소 요청 등록에 실패 하였습니다. 다시 시도 하여 주십시오
		 alert("<%=CommonLang.msg("MSG477") %>"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){

	var result = response.msg.MSG;  
	
	if(result=="Ok"){
		//정상적으로 저장 되었습니다.
		alert("<%=CommonLang.msg("MSG478") %>");
		opener.kepSearch(1);
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

		
		case "get_dept": //부서코드 
			  
			openSearchPopup("/wmco/showMasterWmDeptPop.do", "?st_buyer_code="+$("#st_com_code").val(),"680,470,no" );
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
	 if(popupSel == "get_dept"){
		 
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
   if("01" ==kepSelectOptionVal('st_wmre_type')){
	   
	   kepAjaxCommonQueryIdSearchCombo('st_wmre_type2','getTypeWM02','','SEL');

   }else if("02" == kepSelectOptionVal('st_wmre_type')){ //교환인 경우 
	
	   kepAjaxCommonQueryIdSearchCombo('st_wmre_type2','getTypeWM03','','SEL');
   
   }
	
}


function getWmreTypeDetail(){
	
	   if("01" ==kepSelectOptionVal('st_wmre_type')){
		   kepAjaxCommonQueryIdSearchCombo('st_wmre_type3','getTypeWM04',kepSelectOptionVal('st_wmre_type2'),'SEL');
	   }else if("02" == kepSelectOptionVal('st_wmre_type')){ //교환인 경우 
		   kepAjaxCommonQueryIdSearchCombo('st_wmre_type3','getTypeWM05',kepSelectOptionVal('st_wmre_type2'),'SEL');
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
		//발주수량 값을 먼저 선택 해 주세요.
		alert('<%=CommonLang.msg("MSG479") %>');
		$('#st_po_no').focus();
		return;
	}
	if(eval($('#st_item_qty').val().replace(/,/gi,"")) < eval($('#st_wmre_qty').val().replace(/,/gi,"")  )){
		//반품/교환 수량이 발주수량 보다 클 수 없습니다.
		alert('<%=CommonLang.msg("MSG480") %> ');
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


</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_com_code"  name="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="st_cancel_flag"  name="st_cancel_flag" value="Y">	
    <input type="hidden" id="st_process_type"  name="st_process_type" value="<%=CommonUtil.nvl(_dataMap.get("PROCESS_TYPE"),"") %>">	
    <input type="hidden" id="st_WAREHOUSE_CODE"  name="st_WAREHOUSE_CODE" value="<%=CommonUtil.nvl(_dataMap.get("WAREHOUSE_CODE"),"") %>">	    
	 <input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"") %>" >
     <input type="hidden" id="st_po_no"  name="st_po_no" value="<%=CommonUtil.nvl((String) request.getParameter("st_po_no"),"") %>">	
     <input type="hidden" id="st_po_seq"  name="st_po_seq" value="<%=CommonUtil.nvl((String) request.getParameter("st_po_seq"),"") %>">	
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE851") %><!-- 주문취소 요청 등록 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:308px;">
        	<!--버튼영역-->
            <!--조회영역-->
				<h4><b><%=CommonLang.get("HTITLE852") %><!-- 발주정보 --> </b></h4>
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
							<th><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>			
							<td><input type="text" name="st_po_no" id="st_po_no" class="input_type_text" title=""   value="<%=CommonUtil.nvl(_dataMap.get("PO_NO"),"") %>"    style="width:60%;background:#EAEAEA;" " readonly />
							</td>
							<th><%=CommonLang.get("HTITLE648") %><!-- 발주순번 --></th>
							<td colspan="3"><input type="text" name="st_po_seq" id="st_po_seq" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("PO_SEQ"),"") %>"     style="width:20%;background:#EAEAEA;" readonly /></td>
						 	
						 </tr>
						  <tr>
							<th><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>			
							<td><input type="text" name="st_buyer_item_no" id="st_buyer_item_no" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"),"") %>"   style="width:90%;background:#EAEAEA;" readonly /></td>
							<th><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>			
							<td><input type="text" name="st_description" id="st_description" class="input_type_text" title="" value="<%=CommonUtil.nvl(_dataMap.get("DESCRIPTION"),"") %>"     style="width:90%;background:#EAEAEA;"readonly /></td>
							<th><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>			
							<td ><input type="text" name="st_specification" id="st_specification" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("SPECIFICATION"),"") %>"   style="width:90%;background:#EAEAEA;"readonly /></td>	
						  </tr>
						  <tr>
							<th><%=CommonLang.get("HTITLE217") %><!-- 발주수량 --></th>			
							<td><input type="text" name="st_item_qty" id="st_item_qty" class="ar" title=""  value="<%=CommonUtil.nvl(_dataMap.get("ITEM_QTY"),"") %>"    style="width:90%;background:#EAEAEA;" readonly /></td>
							<th><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th>			
							<td><input type="text" name="st_unit_measure" id="st_unit_measure" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("UNIT_MEASURE"),"") %>"   style="width:90%;background:#EAEAEA;" readonly/></td>
							<th><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>			
							<td><input type="text" name="st_seller_name" id="st_seller_name" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("AGENT_NAME"),"") %>"   style="width:90%;background:#EAEAEA;"readonly />
							<input type="hidden" name="st_seller" id="st_seller" class="input_type_text" title=""   value="<%=CommonUtil.nvl(_dataMap.get("AGENT"),"") %>"  style="width:90%;background:#EAEAEA;"readonly /></td>																		  	
						  </tr>	
					</tbody>
				</table>	
				<h4><b><%=CommonLang.get("HTITLE853") %><!-- 주문취소 요청정보 --> </b></h4>					 						  
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
							<th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>			
							<td><input type="text" name="st_buyer_dept_name" id="st_buyer_dept_name" class="input_type_text" title=""   value="${sessionInfo.departmentName}"  style="width:60%;" readonly onclick="javascript:doPop('get_dept');"/>
								<input type="hidden" name="st_buyer_dept_code" id="st_buyer_dept_code"  value="${sessionInfo.department}"   style="width:80%" value="">
		                        <a href="javascript:doPop('get_dept');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_dept_code','st_buyer_dept_name');"><img src="/resources/images/btn_eraser2.gif"></a> 							
							</td>
							<th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></th>			
							<td><input type="text" name="st_buyer_person_name"  id="st_buyer_person_name"  class="al" title=""   value="${sessionInfo.userNameLoc}"  style="width:90%;" onkeyup="fnCheckInputByte(this, 20);"/>
							<input type="hidden" name="st_b_req_user_id" id="st_b_req_user_id"   value="${sessionInfo.userId}"  class="input_type_text" title="" style="width:90%;" />
							</td>
							<th><%=CommonLang.get("HTITLE133") %><!-- 요청자 --> <%=CommonLang.get("HTITLE42") %><!-- 연락처 --></th>			
							<td><input type="text" name="st_buyer_person_tel" id="st_buyer_person_tel"   value="${sessionInfo.tel}"  class="al" title="" style="width:90%;" onkeyup="fnCheckInputByte(this, 20);"/></td>
						 </tr>
						 <tr>	
							<th><%=CommonLang.get("HTITLE650") %><!-- 요청일자 --></th>			
							<td><input type="text" class="al" name="st_b_req_date" id="st_b_req_date" readOnly onclick="javascript:kepCalendar('st_b_req_date')" style="width:70%;height:20px" />
							<a href="javascript:kepCalendar('st_b_req_date')"></a>
							</td>	
							<th><%=CommonLang.get("HTITLE653") %><!-- 요청사유 --></th>			
							<td colspan="3"><input type="text" name="st_b_req_remark" id="st_b_req_remark" class="al" title="" style="width:90%;" onkeyup="fnCheckInputByte(this, 500);"/></td>																								  	
						  </tr>
						 <tr>	
							<th><%=CommonLang.get("HTITLE652") %><!-- 요청구분 --></th>			
							<td>
							 <select  name="st_wmre_type" id= "st_wmre_type" style="width:90%;height:20px"  onChange="getWmreType();">
							 <option value="09" selected ><%=CommonLang.get("HTITLE225") %><!-- 주문취소 --></option>
							</select>
							</td>
							<th><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --></th>			
							<td colspan="3"><input type="hidden" name="st_wmre_file" id="st_wmre_file" class="al" title="" style="width:20%;"   value=""/>
							<a href="javascript:attach_popup();"><img id="diskimg" src="/resources/images/disk_off.gif" name="MasterImage" width="14" height="14" border="0"  > </a></td>		
																																  	
						  </tr>						  
					</tbody>
				</table>	
	
			
            <!--grid-->

			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('save')"><%=CommonLang.get("HTITLE124") %><!-- 저장 --></a></span>
			</span>
			<br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
