<%--
**********************************************
* 메뉴 : 
* 화면 :       포장지 도안관리 상세(작물보호)
* 기능 : 선택한 도안의 상세정보와 확인현황을 조회하고, 권한이 있는경우 각 해당단계에 확인 처리 한다.운영사 담당자의 경우 종결처리 한다.
* 프로그램 ID : PG_07_M_002_04
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-01
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
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
@SuppressWarnings (value="unchecked")
Map<String,String> userRole = (Map<String,String>) request.getAttribute("userRole"); // 권한
Map<String,String> formData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	formData = _dataList.get(0);
}

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String Session_user_id        = (String) _sessionInfo.getUserId();
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)

String st_plant             = CommonUtil.nvl((String) request.getParameter("st_plant"),"");
String st_byca_comorg_code  = CommonUtil.nvl((String) request.getParameter("st_byca_comorg_code"),"");
String st_buyer             = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_ch_buyer             = CommonUtil.nvl((String) request.getParameter("st_ch_buyer"),"");
String st_opkg_seq          = CommonUtil.nvl((String) request.getParameter("st_opkg_seq"),"");
String st_rd_date           = CommonUtil.nvl((String) request.getParameter("st_rd_date"),"");
String st_buyer_item_no     = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");
String st_openType          = CommonUtil.nvl((String) request.getParameter("st_open_type"),""); 

long productkey = System.currentTimeMillis();
// String CheckDate = WisehubDate.addWiseDateDay(curDate,+1);
	String CheckDate = CommonUtil.formatDateNoDateGubun(new Date(),1);
%>

<script type="text/javascript">
var btnEvent;
var linkPram;

function kep_onload_view(){
	kepSetCalender("ch_rd_date");
	<%
		if (_dataList==null || _dataList.size()==0){
	%>
	kepSearch();
	<%	
		}
	%>
}

function kepSearch(){
	  $('#contentForm').attr("action", "/mpds/getMasterMpDsPckpaprDesignCropProtectManagePop.do").submit(); 
}

//기능함수
function doAction(str, value1, value2) {
	st = new Date();
	btnEvent = str;
	switch (str) {
	case "search":
		kepSearch($("#curPage").val());
		break;
	case "fileUpload"://파일 첨부
		var type="DONGBU";
		var imageKey =  value1;
		var viewType=value2;
		openSearchPopup('/common/fileUploadPop.do','?DATE_DIR=Y&DOC_NO='+imageKey+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	case "Save":
		setSysopDongBuOrderPackingSave(str, value1);
		break;
	case "SaveMM":
		setBuyerDongBuOrderPackingSaveMM(str, value1);
		break;
	case "Save01":
		var agent = document.forms.contentForm.st_agent.value;
	    if(value1 == "ED" && agent == "")
	    {
	       alert("협력사를 선택해 주십시요.");
	       return;
	    }
	    if(!confirm("선택한 상품을 수정 하시겠습니까?")) return;

	    document.contentForm.st_recv_flag.value = value1;
	    
	    kepAjaxFormCall("/mpds/masterUpdateReg01.do","contentForm",str); 
		break;
	case "getBarcodeGrant":
		
	    var product_flag       = document.getElementById("st_product_flag").value;  
		if(product_flag == ""){
			alert("제품구분을 선택하여 주시기 바랍니다.");
			return;
		}else{
			var product_text = ""
			if (product_flag == "HN") {
				product_text = "한농"; 
			}else if (product_flag == "AG") {
				product_text = "아그로텍";
			}   
			if(confirm(product_text+" 바코드를 부여 하시겠습니까?")){      
				kepAjaxFormCall("/mpds/barCodeGrant.do","contentForm",btnEvent); 	
			}
		}   
		break;
	case "close":
		break;
	}
}

//팝업 함수호출
function doPop(str,value1, value2, value3) {
	btnEvent = str;
	switch (str) {
		case "getDongCatalogChangeNewPop": //품목코드
			linkPram = value3;
			openSearchPopup('/mdcm/showMasterMdCmBuyerCatalogAlterPop.do','?st_buyer_code='+value1+'&st_catalog_com_code='+value1+'&st_buyer_item_no='+value2+'&st_open_flag='+value3,'988,768,no');
			break;
			
		case "masterMpDsPckpaprDesignRejectStatePop": // 반려현황
			var plant			  = document.forms.contentForm.st_plant.value;
			var byca_comorg_code  = document.forms.contentForm.st_byca_comorg_code.value;
			var buyer			  = document.forms.contentForm.st_buyer.value;
			var opkg_seq		  = document.forms.contentForm.st_opkg_seq.value;
			var rd_date			  = document.forms.contentForm.st_rd_date.value;
			var buyer_item_no	  = document.forms.contentForm.st_buyer_item_no.value;
			openSearchPopup('/mpds/showMasterMpDsPckpaprDesignRejectStatePop.do','?st_dept='+value1+'&st_plant='+plant+'&st_byca_comorg_code='+byca_comorg_code+'&st_buyer='+buyer+'&st_opkg_seq='+opkg_seq+'&st_rd_date='+rd_date+'&st_buyer_item_no='+buyer_item_no,'500,350,no');
			break;

		case "remarkReqChange": // kep비고 수정 사유 입력 팝업
			var req_user = document.forms.contentForm.st_req_user.value;
			var req_user_remark = document.forms.contentForm.st_req_user_remark.value;
			openSearchPopup('/common/remarkReqChangePop.do','?st_req_user='+req_user+'&st_req_user_remark='+req_user_remark,'500,230,no');
			break;
// 			    var loc = "/kr/buyer/dong_bu/order_packing/sysop_dongbu_req_change_pop.jsp?st_req_user="+req_user+"&st_req_user_remark="+req_user_remark;

		case "masterMpDsPckpaprDesignRemarkHistoryPop": // 포장지 도안 수정 현황
			var plant			  = document.forms.contentForm.st_plant.value;
			var byca_comorg_code  = document.forms.contentForm.st_byca_comorg_code.value;
			var buyer			  = document.forms.contentForm.st_buyer.value;
			var opkg_seq		  = document.forms.contentForm.st_opkg_seq.value;
			var rd_date			  = document.forms.contentForm.st_rd_date.value;
			var buyer_item_no	  = document.forms.contentForm.st_buyer_item_no.value;

			openSearchPopup('/mpds/showMasterMpDsPckpaprDesignRemarkHistoryPop.do',"?st_plant="+plant+"&st_byca_comorg_code="+byca_comorg_code+"&st_buyer="+buyer+"&st_opkg_seq="+opkg_seq+"&st_rd_date="+rd_date+"&st_buyer_item_no="+buyer_item_no,'600,210,no');
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "getDongCatalogChangeNewPop" && linkPram == "DONGBU_IG") {	// 품목코드
		document.forms.contentForm.st_description.value = value1;
		document.forms.contentForm.st_specification.value = value2;	

	}
	grbRow="";	//초기화
}


// function viewGbHistory(dept){  
// 	var plant			  = document.forms.contentForm.st_plant.value;
// 	var byca_comorg_code  = document.forms.contentForm.st_byca_comorg_code.value;
// 	var buyer			  = document.forms.contentForm.st_buyer.value;
// 	var opkg_seq		  = document.forms.contentForm.st_opkg_seq.value;
// 	var rd_date			  = document.forms.contentForm.st_rd_date.value;
// 	var buyer_item_no	  = document.forms.contentForm.st_buyer_item_no.value;
//     viewGbHistoryList(dept,plant,byca_comorg_code,buyer,opkg_seq,rd_date,buyer_item_no); 
// }



/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if (msg != ""){
		alert(msg);
	}
	
	
	//처리후 화면 닫기
	if(btnEvent == "Save" || btnEvent == "SaveMM" || btnEvent == "Save01"){
		setReturn();
	}else{
		// 처리후 재조회
	 	kepSearch($("#curPage").val());
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
}

function setSysopDongBuOrderPackingSave(str, recv_flag) {
	var recv_flag =$("#st_recv_flag").val();   
	var oldR = document.forms.contentForm.st_old_mm_remark.value;
	var newR = document.forms.contentForm.st_mm_remark.value;
	
	if(recv_flag =="GB"){
		if (oldR != newR){
			var flag = document.forms.contentForm.st_chRemark_flag.value;
			if(flag == "REG"){
				alert("내역이 변경 되었습니다.\n\n등록버튼을 눌러 사유를 입력 바랍니다.");
				return;
			}
			
		}else{
			document.forms.contentForm.st_chRemark_flag.value ="REG";
		}	
	} 

	//alert(recv_flag+"::"+document.forms.contentForm.st_chRemark_flag.value);return;

    if(!confirm("선택한 상품을 수정 하시겠습니까?")) return;

    kepAjaxFormCall("/mpds/setSysopDongBuOrderPackingSave.do","contentForm",btnEvent); 

}

function setBuyerDongBuOrderPackingSaveMM(str, recv_flag)
{
  var mm_status = document.forms.contentForm.st_mm_status.checked;
      if(mm_status == true){
		  if(mm_status == true)
		  {
			 document.forms.contentForm.db_mm_status.value = "ED";
		  }else {
			 document.forms.contentForm.db_mm_status.value = "N";
		  }

		 if(document.forms.contentForm.db_mm_status.value == "ED")
		 {
			document.forms.contentForm.db_recv_flag.value = recv_flag;
		 }else {
			document.forms.contentForm.db_recv_flag.value = "NW";
		 } 
		 
		var item_type = document.forms.contentForm.st_item_type.value;
		if(item_type == null || item_type == ""){
			alert("품목군을 선택하여 주시기 바랍니다.");
			return;
		}

		if(!confirm("입력한 내용을 수정 하시겠습니까?")) return;

		kepAjaxFormCall("/mpds/setBuyerDongBuOrderPackingSaveMM.do","contentForm",btnEvent); 
		
// 		document.forms.contentForm.target = "pop_work";
// 		document.forms.contentForm.method = "post";
// 		document.forms.contentForm.action = "/kr/buyer/dong_bu/order_packing/buyer_dongbu_order_packing_update_reg.jsp";
// 		document.forms.contentForm.submit();
	  }else{
		setSysopDongBuOrderPackingSave();
	  }
}

function setSysopDongBuOrderPackingSave01(str, recv_flag)
{
    var agent = document.forms.contentForm.st_agent.value;

    if(recv_flag == "ED" && agent == "")
    {
       alert("협력사를 선택해 주십시요.");
       return;
    }
    if(!confirm("선택한 상품을 수정 하시겠습니까?")) return;

    document.forms.contentForm.st_recv_flag.value = recv_flag;

    kepAjaxFormCall("/mpds/masterUpdateReg01.do","contentForm",btnEvent); 
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

function setDesSpe(des, spe){ 
	if((document.forms.contentForm.st_description.value != des) || (document.forms.contentForm.st_specification.value != spe)){
		if(confirm("품명/규격을 변경하시겠습니까?")){
			document.forms.contentForm.st_description.value = des;
			document.forms.contentForm.st_specification.value = spe;
		}	
	}
}

/* function getChRemarkHistory(){  
	var plant			  = document.forms.contentForm.st_plant.value;
	var byca_comorg_code  = document.forms.contentForm.st_byca_comorg_code.value;
	var buyer			  = document.forms.contentForm.st_buyer.value;
	var opkg_seq		  = document.forms.contentForm.st_opkg_seq.value;
	var rd_date			  = document.forms.contentForm.st_rd_date.value;
	var buyer_item_no	  = document.forms.contentForm.st_buyer_item_no.value;

	var width = 720;
	var height = 210;
	var left = 0;
	var top = 0;
	var toolbar = 'no';
	var menubar = 'no';
	var status = 'no';
	var scrollbars = '1';
	var resizable = 'no';
    var url="/kr/buyer/dong_bu/order_packing/sysop_dongbu_ch_remark_history_pop.jsp?st_plant="+plant+"&st_byca_comorg_code="+byca_comorg_code+"&st_buyer="+buyer+"&st_opkg_seq="+opkg_seq+"&st_rd_date="+rd_date+"&st_buyer_item_no="+buyer_item_no;
	window.open( url, 'dongbu_ch_remark_history_pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

} */

// kep비고 수정 사유 입력 팝업
function getChangeRemark() {  
    var left = 0;
    var top = 0;
    var width = 400;
    var height = 240;
    var toolbar = 'NO';
    var menubar = 'NO';
    var status = 'NO';
    var scrollbars = 'NO';
    var resizable = 'NO';
	
	var req_user = document.forms.contentForm.st_req_user.value;
	var req_user_remark = document.forms.contentForm.st_req_user_remark.value;

    var loc = "/kr/buyer/dong_bu/order_packing/sysop_dongbu_req_change_pop.jsp?st_req_user="+req_user+"&st_req_user_remark="+req_user_remark;
    window.open(loc,'change_pop', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);

} 
// kep비고 수정 사유 입력.
function setChangeRemark(remark) {     
	var remarkArr = remark.split("^||^");   
	document.forms.contentForm.st_req_user.value = remarkArr[0];
	document.forms.contentForm.st_req_user_remark.value = remarkArr[1];
	document.forms.contentForm.st_chRemark_flag.value = "MOD"; 
	document.forms.contentForm.img_remark.src="/kr/buyer/dong_bu/order_packing/images/but_edit.gif"
}

<%-- 
function setAgentRemarkResult() { 
	if(httpRequest.readyState == 4){ 
		if(httpRequest.status == 200){ 
			var resultText = httpRequest.responseText ;   
			var result = resultText.split('^');   
			var jFlag = "실패";
			if(result[2] == "OK"){
				jFlag = "성공";
			} 
			alert("바코드 부여가 "+jFlag+" 하였습니다." );  
			setReload();
		}
	}
}      

function rd_seledVal(target){
	var form = target;
	var chkval = "";

	if( form.length == null ){
		if(form.checked){
		   chkval = form.value;
			}else{
			 chkval ="";
		 } 
	}else{ 
		 for(i =0 ;i < form.length;i++){
			 if(form[i].checked == true){
				 chkval = form[i].value;
			 }
		 }
	}
	if(chkval !=""){ 
		return chkval;
	}else{
		return "N";
	}
}  --%>

//콜백함수
function setPopupReturn(value1, value2){

	if(btnEvent == "remarkReqChange") {	// kep비고 수정 사유 입력 팝업
			document.forms.contentForm.st_req_user.value = value1;
			document.forms.contentForm.st_req_user_remark.value = value2;
			document.forms.contentForm.st_chRemark_flag.value = "MOD";
			document.forms.contentForm.img_remark.src="/resources/images/but_edit.gif"
	
	} else if(btnEvent == "fileUpload") {	//파일 첨부
		document.forms.contentForm.st_image_key.value = value1;
// 		document.forms.contentForm.st_req_user_remark.value = value2;
// 		document.forms.contentForm.img_remark.src="/resources/images/but_edit.gif"
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

</script> 
<body onload="kep_onload_view()">
<form name="contentForm" id="contentForm" method=post >

	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	<!-- HIDDEN -->
	<input type="hidden" name="st_plant"     id="st_plant"         value="<%=st_plant%>">
	<input type="hidden" name="st_byca_comorg_code"  id="st_byca_comorg_code"  value="<%=st_byca_comorg_code%>">
	<input type="hidden" name="st_buyer"     id="st_buyer"         value="<%= st_buyer %>">
	<input type="hidden" name="st_opkg_seq"    id="st_opkg_seq"       value="<%=st_opkg_seq%>">
	<input type="hidden" name="st_rd_date"   id="st_rd_date"  value="<%=st_rd_date%>">
	<input type="hidden" name="st_buyer_item_no"   id="st_buyer_item_no"  value="<%=st_buyer_item_no%>">
	<input type="hidden" name="st_pkg_code"   id="st_pkg_code"  value="PKG1">

	<input type="hidden" name="st_buyer_code"	id="st_buyer_code"		value="">
	<input type="hidden" name="db_mm_status"	id="db_mm_status"			value="">
	<input type="hidden" name="db_recv_flag"		id="db_recv_flag"		value="">
<%
if (formData==null || formData.size()==0){
%>
<%}else{ %>	 	

	<input type="hidden" name="st_recv_flag"		id="st_recv_flag" 		value="<%=formData.get("RECV_FLAG")%>">
	<input type="hidden" name="st_image_key"	id="st_image_key"		value="<%=formData.get("IMAGE_KEY")%>">
	<input type="hidden" name="st_barcode"		id="st_barcode"		value="<%=formData.get("MM_BARCODE_NO")%>">
	<input type="hidden" name="st_chRemark_flag"	id="st_chRemark_flag"	value="REG">
	<input type="hidden" name="st_job_flag"  id="st_job_flag"  value=BARCODE />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:814px;">
    	<div id="popHeader">
        	<h1 class="title">포장지 도안관리 상세(작물보호)</h1>
            <p class="popClose"><a href="javascript:setReturn()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
		<span class="fl">
			<img src="/resources/images/rd_pin.gif" style="padding-left:20px;"> <font  style="color:#444444; font-weight:bold;">도안상세정보</font>
		</span>		                
        <div id="popContainer">
		        	<table class="cont_t_list06">
		            	<caption>리스트</caption>
		                <colgroup>
		                    <col width="20%" />
		                    <col width="30%" />
		                    <col width="15%" />
		                    <col width="35%" />
		                </colgroup>
		                <tbody>
					        <tr>
					          <th >품목코드</th>
					          <td ><span style="color:blue"><a class="hyperLink"  href="javascript:doPop('getDongCatalogChangeNewPop','<%=formData.get("BYCA_COMORG_CODE")%>','<%=formData.get("BUYER_ITEM_NO")%>','DONGBU_IG');"><b><%=formData.get("BUYER_ITEM_NO")%></b></a></span></td>
					          <th >진행상태</th>
					          <td >
							  <span style="color:blue"><a class="hyperLink"  href="javascript:doPop('masterMpDsPckpaprDesignRejectStatePop','ALL');"><b><%=formData.get("RECV_TEXT")%></b></a></span>&nbsp;&nbsp;
							<%
								String product_flag ="";
								if(!formData.get("MM_BARCODE_NO").equals("")) { 
									product_flag ="disabled";
									out.println("<span style='color:blue'><b>"+formData.get("MM_BARCODE_NO")+"</b></span>" );	
								}
							%>
							 
							<%="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:red'>(아그로텍:"+formData.get("AG")+",한농:"+formData.get("HN")+")</span>"%>
							  </td>
					        </tr>
					        <tr>
					          <th height="32">품목명</th>
					          <td ><input type="text" name="st_description" readonly="readonly" style="border-color:white; border-width:0; width:90%;" value = "<%=formData.get("DESCRIPTION")%>"></td>
					          <th >제품구분</th>
					          <td >
					          		<input type="hidden" id="st_product_flag"  name="st_product_flag"  value="<%=(formData.get("PRODUCT_FLAG").equals("") ? "HN" : formData.get("PRODUCT_FLAG") )%>">
									<input class="Noborder" type="radio" name="pf" id="pf"  value="HN" <%=product_flag%> <%=(formData.get("PRODUCT_FLAG").equals("HN") ) ? "checked" : ""%> onclick="kepRadioSet('st_product_flag', this)">한농
									<input class="Noborder" type="radio" name="pf" id="pf"  value="AG" <%=product_flag%> <%=(formData.get("PRODUCT_FLAG").equals("AG") ) ? "checked" : ""%> onclick="kepRadioSet('st_product_flag', this)">아그로텍&nbsp;&nbsp;
									<%
										if(formData.get("MM_BARCODE_NO").equals("")) {
									%>
										<span class="btn_imghide"><a href="javascript:doAction('getBarcodeGrant');">바코드부여</a></span>		
									<% } %>
								</td>
					        </tr>
					        <tr>
					          <th height="32">규격</th>
					          <td ><input type="text" name="st_specification" readonly="readonly" style="border-color:white; border-width:0; width:90%;" value="<%=formData.get("SPECIFICATION")%>"></td>
							  <th height="32">안전마개</th>
					          <td >
					          		<input type="hidden" id="st_safety_open"  name="st_safety_open"  value="<%=(formData.get("SAFETY_OPEN_FLAG"))%>">
									<input class="Noborder" type="radio" name="so" id="so" value="Y" <%=(formData.get("SAFETY_OPEN_FLAG").equals("Y") ? "checked" : "")%> onclick="kepRadioSet('st_safety_open', this)"><%=(formData.get("SAFETY_OPEN_FLAG").equals("Y") ? "<span style=color:red;font:13><b>적용</b></span>" : "적용")%>
									<input class="Noborder" type="radio" name="so" id="so"  value="N" <%=(formData.get("SAFETY_OPEN_FLAG").equals("N") ? "checked" : "")%> onclick="kepRadioSet('st_safety_open', this)">미적용   
							  </td>
					        </tr>
					        <tr>
					          <th height="32">제조사</th>
					          <td ><%=formData.get("MAKER_NAME")%></td>
					          <th >지정협력사</th>
					          <td >
								<select name="st_agent" id="st_agent">   
									<%=CommonUtil.getCodeComboQueryIdList("common.getSellerListCombo","SEL",formData,formData.get("AGENT"))%>
								</select>
					          </td>
					        </tr>
					        <tr>
					          <th height="32">요청공장</th>
					          <td >
						          <select name="st_ch_buyer">
									<option <%=(formData.get("BUYER").equals("KRDONG0110") ? "selected" : "")%> value="KRDONG0110">동부한농(주)인천공장</option>
									<option <%=(formData.get("BUYER").equals("KRDONG0107") ? "selected" : "")%> value="KRDONG0107">동부한농(주)구미공장</option>
									<option <%=(formData.get("BUYER").equals("KRDONG0128") ? "selected" : "")%> value="KRDONG0128">(주)동부아그로텍 전주공장</option>
									<option <%=(formData.get("BUYER").equals("KRDONG0099") ? "selected" : "")%> value="KRDONG0099">동부한농(주)비료공장</option>
									<option <%=(formData.get("BUYER").equals("KRDONG0153") ? "selected" : "")%> value="KRDONG0153">동부한농(주)제주공장</option>
								</select>
					          </td>
					          <th >첨부파일</th>
					          <td >&nbsp;
							<% if(formData.get("IMAGE_KEY").equals("N")) { %>
								첨부없음
							<% }else { %>
<%-- 					          <% if("1".equals(userRole.get("P001")) || "1".equals(userRole.get("P002")) || "1".equals(userRole.get("P003"))) { %> --%>
<%-- 									<span class="btn_imghide"><a href="javascript:doAction('fileUpload', '<%=formData.get("IMAGE_KEY")%>', 'W');">첨부 등록</a></span> --%>
<%-- 					          <% }else { %> --%>
									<span class="btn_imghide"><a href="javascript:doAction('fileUpload', '<%=formData.get("IMAGE_KEY")%>', 'W');">첨부 등록</a></span>
<%-- 					          <% } %> --%>
							
							<% } %>
							</td>
					        </tr>
					        <tr>
					          <th height="32">구분</th>
					          <td >
								<select name="st_use_flag">
									<option <%=(formData.get("USE_FLAG").equals("N") ? "selected" : "")%> value="N">일반</option>
									<option <%=(formData.get("USE_FLAG").equals("S") ? "selected" : "")%> value="S">긴급</option>
								</select>&nbsp;//&nbsp;
								<select name="st_gubun_flag">
									<option <%=(formData.get("GUBUN_FLAG").equals("NW") ? "selected" : "")%> value="NW">신규</option>
									<option <%=(formData.get("GUBUN_FLAG").equals("OD") ? "selected" : "")%> value="OD">기존</option>
								</select>
							 </td>
					          <th >시작일</th>
					          <td >
									<input type="text" name="ch_rd_date" id="ch_rd_date" style="width:60%" value="<%=CommonUtil.formatStrinigDate(formData.get("RD_DATE"))%>"  readonly>
							        <a href="javascript:kepCalendar('ch_rd_date')"></a>
							</td>
					        </tr>
					        <tr>
					          <th height="32">마케팅 완료일</th>
					          <td ><%=(formData.get("MM_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(formData.get("MM_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(formData.get("MM_DATE")))%></td>
					          <th >디자인 완료일</th>
					          <td ><%=(formData.get("EE_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(formData.get("EE_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(formData.get("EE_DATE")))%></td>
					        </tr>
					        <tr>
					          <th height="32">문안 완료일</th>
					          <td ><%=(formData.get("DD_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(formData.get("DD_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(formData.get("DD_DATE")))%></td>
					          <th >최종 확정일</th>
					          <td ><%=(formData.get("ES_DATE").equals(CheckDate) ? "<span style=color:red><b>"+CommonUtil.formatStrinigDate(formData.get("ES_DATE"))+"</b><span>" : CommonUtil.formatStrinigDate(formData.get("ES_DATE")))%></td>
					        </tr>
					        <tr>
					        	<th height="32"> 품목 군</th>
								<td colspan="3">
									<input type="hidden" id="st_item_type"  name="st_item_type"  value="<%=(formData.get("ITEM_TYPE"))%>">
									<input class="Noborder" type="radio" name="so" id="so"  value="D01"   <%=(formData.get("ITEM_TYPE").equals("D01") ? "checked" : "")%> onclick="kepRadioSet('st_item_type', this)">살균제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input class="Noborder" type="radio" name="so" id="so"  value="D02""  <%=(formData.get("ITEM_TYPE").equals("D02") ? "checked" : "")%> onclick="kepRadioSet('st_item_type', this)">살충제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input class="Noborder" type="radio" name="so" id="so"  value="D03"   <%=(formData.get("ITEM_TYPE").equals("D03") ? "checked" : "")%> onclick="kepRadioSet('st_item_type', this)">제초제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input class="Noborder" type="radio" name="so" id="so"  value="D04"   <%=(formData.get("ITEM_TYPE").equals("D04") ? "checked" : "")%> onclick="kepRadioSet('st_item_type', this)">생장조정제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input class="Noborder" type="radio" name="so" id="so"  value="D05"   <%=(formData.get("ITEM_TYPE").equals("D05") ? "checked" : "")%> onclick="kepRadioSet('st_item_type', this)">전착제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input class="Noborder" type="radio" name="so" id="so"  value="D06"   <%=(formData.get("ITEM_TYPE").equals("D06") ? "checked" : "")%> onclick="kepRadioSet('st_item_type', this)">기타
									   
								</td>
					        </tr>
		                </tbody>
		            </table>
            			    

		<span class="fl">
			<img src="/resources/images/rd_pin.gif" > <font  style="color:#444444; font-weight:bold;">도안확인정보</font>
		</span>		                
			      
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="15%" />
                    <col width="6%" />
                    <col width="*" />
                </colgroup>
                <tbody>
					<tr>
						<%
							String kep = "<b>KEP</b>";
							if(formData.get("CH_REMARK_CNT").equals("CH")) {
								kep = "<a class='hyperLink'  href=\"javascript:doPop('masterMpDsPckpaprDesignRemarkHistoryPop')\">"+kep+"</a>"; 
							}  
						%> 
						<th align="center"  width="15%"><%=kep%></th>
						<td width="6%"  align="center">완료<br> 
							<input type ="hidden" name ="st_old_mm_remark" value="<%=formData.get("MM_REMARK")%>">
							<input type ="hidden" name ="st_req_user" value="">
							<input type ="hidden" name ="st_req_user_remark" value="">
							<% if("1".equals(userRole.get("P001"))&& formData.get("RECV_FLAG").equals("NW")) { %>
								<input id="st_mm_status" type="checkbox" name="st_mm_status" value="ED" <%=(formData.get("MM_STATUS").equals("ED") ? "checked" : "")%> <%=(formData.get("MM_STATUS").equals("ED") ? "disabled" : "")%>>
							<% }else { %>
								<input id="st_mm_status" type="checkbox" name="st_mm_status" value="ED" <%=(formData.get("MM_STATUS").equals("ED") ? "checked" : "")%> disabled>
							<% } %> 
						</td>
						<td  colspan="2" align="center">
			<% if("1".equals(userRole.get("P001"))&& formData.get("RECV_FLAG").equals("NW")) { %>
<%-- 								<textarea rows="3" name="st_mm_remark" style="padding:3px;width:100%;ime-mode:active"><%=WisehubString.TextToHTML(formData.get("MM_REMARK")%></textarea> --%>
								<textarea rows="3" name="st_mm_remark" style="padding:3px;width:100%;ime-mode:active" maxlength="200"><%=formData.get("MM_REMARK")%></textarea>
			<% }else if("1".equals(userRole.get("P001"))&& formData.get("RECV_FLAG").equals("GB")) { %>
<%-- 								<textarea rows="3" name="st_mm_remark" style="padding:3px;width:87%;ime-mode:active"><%=WisehubString.TextToHTML(formData.get("MM_REMARK")%></textarea> --%>
								<textarea rows="3" name="st_mm_remark" style="padding:3px;width:86%;ime-mode:active" maxlength="200"><%=formData.get("MM_REMARK")%></textarea>
								<a href="javascript:doPop('remarkReqChange');"><img src="/resources/images/but_reg.gif" width="58" height="22" align="absmiddle" border="0" name ="img_remark"></a>
<!-- 								<span class="btn_imghide"><a id="img_remark" href="javascript:doPop('remarkReqChange');">등록</a></span> -->
							<% }else { %>  			
<%-- 								<textarea rows="3" name="st_mm_remark" style="padding:3px;width:100%;ime-mode:active" READONLY><%=WisehubString.TextToHTML(formData.get("MM_REMARK")%></textarea> --%>
								<textarea rows="3" name="st_mm_remark" style="padding:3px;width:100%;ime-mode:active" READONLY><%=formData.get("MM_REMARK")%></textarea>
							<% } %>
						</td>
						</tr>
					<tr>
						<th align="center"  width="14%"><b>문안</b></th>
						<td width="6%"  align="center">완료<br>
							<input id="st_dd_status" type="checkbox" name="st_dd_status"  id="st_dd_status"  value="ED" <%=(formData.get("DD_STATUS").equals("ED") ? "checked" : "")%> disabled>
						</td>
						<td  colspan="2" align="center">
<%-- 							<textarea rows="3" name="st_dd_remark" style="padding:3px;width:100%;ime-mode:active" <%=(formData.get("DD_STATUS").equals("ED") ? "READONLY" : "")%> READONLY><%=WisehubString.TextToHTML(formData.get("DD_REMARK")%></textarea> --%>
							<textarea rows="3" name="st_dd_remark"  id="st_dd_remark"  style="padding:3px;width:100%;ime-mode:active" <%=(formData.get("DD_STATUS").equals("ED") ? "READONLY" : "")%> READONLY><%=formData.get("DD_REMARK")%></textarea>
						</td>
					</tr>
					<tr>
						<th  align="center" width="14%"><b>디자인</b></th>
						<td width="6%"  align="center">완료<br>
							<input id="st_ee_status" type="checkbox" name="st_ee_status" id="st_ee_status"  value="ED" <%=(formData.get("EE_STATUS").equals("ED") ? "checked" : "")%> disabled>
						</td>
						<td  colspan="2" align="center">
<%-- 							<textarea rows="3" name="st_ee_remark" style="padding:3px;width:100%;ime-mode:active" <%=(formData.get("EE_STATUS").equals("ED") ? "READONLY" : "")%> READONLY><%=WisehubString.TextToHTML(formData.get("EE_REMARK")%></textarea> --%>
							<textarea rows="3" name="st_ee_remark"  id="st_ee_remark"  style="padding:3px;width:100%;ime-mode:active" <%=(formData.get("EE_STATUS").equals("ED") ? "READONLY" : "")%> READONLY><%=formData.get("EE_REMARK")%></textarea>
						</td>
					</tr>
                </tbody>
            </table>
			      
			      
			      
			      
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="3%" />
                    <col width="18%" />
                    <col width="15%" />
                    <col width="*" />
                </colgroup>
                <tbody>
			        <tr>
			          <th rowspan="3" style="text-align:center">
						1<br>
						차<br>
						확<br>
						인
						</th>
			          <th  align="right">마케팅 팀(MK)</th>
<!-- 			          <td  colspan="2"> -->
<!-- 			            <table> -->
<!-- 			              <tr> -->
			                <td width="25%" style="padding-left:4px">
							<input type="checkbox" name="st_es_mk1_status" id="st_es_mk1_status" value="Y" <%=(formData.get("ES_MK1_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
							&nbsp;&nbsp;
							<input type="checkbox" name="st_es_mk1_status"  id="st_es_mk1_status"  value="B" <%=(formData.get("ES_MK1_STATUS").equals("B") ? "checked" : "")%> disabled>반려
							</td>
							<td>&nbsp;
<%-- 							<textarea rows="3" name="st_es_mk1_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=WisehubString.TextToHTML(formData.get("ES_MK1_REMARK")%></textarea> --%>
							<textarea rows="3" name="st_es_mk1_remark"  id="st_es_mk1_remark"  style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_MK1_REMARK")%></textarea>
							</td>
<!-- 			               </tr> -->
<!-- 			               </table>  -->
<!-- 			          </td> -->
			        </tr>
			        <tr>
			          <th  align="right">PM팀 (PM)</th>
<!-- 			          <td  colspan="2"> -->
<!-- 			            <table> -->
<!-- 			              <tr> -->
			                <td width="25%" style="padding-left:4px">
									<input  type="checkbox" name="st_es_pd1_status"  id="st_es_pd1_status"  value="Y" <%=(formData.get("ES_PD1_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
									&nbsp;&nbsp;
									<input  type="checkbox" name="st_es_pd1_status" id="st_es_pd1_status"  value="B" <%=(formData.get("ES_PD1_STATUS").equals("B") ? "checked" : "")%> disabled>반려
								</td>
								<td>&nbsp;
<%-- 									<textarea rows="3" name="st_es_pd_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=WisehubString.TextToHTML(formData.get("ES_PD1_REMARK")%></textarea> --%>
									<textarea rows="3" name="st_es_pd_remark" id="st_es_pd_remark"  style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_PD1_REMARK")%></textarea>
								</td> 
<!-- 			               </tr> -->
<!-- 			               </table> -->
<!-- 			          </td> -->
			        </tr>
			        <tr>
			          <th  align="right">품질보증 팀(QA)</th>
<!-- 			          <td  colspan="2"> -->
<!-- 			            <table> -->
<!-- 			              <tr> -->
			                <td width="25%" style="padding-left:4px">
									<input  type="checkbox" name="st_es_qa1_status"  id="st_es_qa1_status"  value="Y" <%=(formData.get("ES_QA1_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
									&nbsp;&nbsp;
									<input  type="checkbox" name="st_es_qa1_status"  id="st_es_qa1_status"  value="B" <%=(formData.get("ES_QA1_STATUS").equals("B") ? "checked" : "")%> disabled>반려
								</td>
								<td>&nbsp;
<%-- 									<textarea rows="3" name="st_es_qa1_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=WisehubString.TextToHTML(formData.get("ES_QA1_REMARK")%></textarea> --%>
									<textarea rows="3" name="st_es_qa1_remark"  id="st_es_qa1_remark"  style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_QA1_REMARK")%></textarea>
								</td> 
<!-- 		               </tr> -->
<!-- 		               </table> -->
<!-- 			          </td> -->
			        </tr>
			        <tr>
			          <th colspan="2" align="right">등록팀 (REG)&nbsp;</th>
<!-- 			          <td  colspan="2"> -->
<!-- 			            <table> -->
<!-- 			              <tr> -->
			                <td width="25%" style="padding-left:4px">
								<input  type="checkbox" name="st_es_mk1_status"  id="st_es_mk1_status"  value="Y" <%=(formData.get("ES_FI_STATUS").equals("Y") ? "checked" : "")%> disabled>확인
								&nbsp;&nbsp;
								<input  type="checkbox" name="st_es_mk1_status"  id="st_es_mk1_status"  value="B" <%=(formData.get("ES_FI_STATUS").equals("B") ? "checked" : "")%> disabled>반려
							</td>
							<td>&nbsp;
<%-- 								<textarea rows="3" name="st_es_mk1_remark" style="padding:3px;width:97%;ime-mode:active" READONLY><%=WisehubString.TextToHTML(formData.get("ES_FI_REMARK")%></textarea> --%>
								<textarea rows="3" name="st_es_mk1_remark"  id="st_es_mk1_remark"  style="padding:3px;width:97%;ime-mode:active" READONLY><%=formData.get("ES_FI_REMARK")%></textarea>
							</td> 
<!-- 		               </tr> -->
<!-- 		               </table> -->
<!-- 			          </td> -->
			        </tr>
                </tbody>
            </table>


 			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fr">
			<% 
			System.out.println(userRole.get("P010"));
			System.out.println(formData.get("RECV_FLAG"));
			if("1".equals(userRole.get("P010")) && "NW".equals(formData.get("RECV_FLAG")))	 {%>
			                 <span class="btn_02 mr04"><a href="javascript:doAction('SaveMM','IG');">저장</a></span>   
			                 
			 <%}else if(formData.get("RECV_FLAG").equals("NW")||formData.get("RECV_FLAG").equals("IG")||formData.get("RECV_FLAG").equals("GB")) { %>
			 				<span class="btn_02 mr04"><a href="javascript:doAction('Save','');">저장</a></span>   
			 <% }  %>				
			<% if(formData.get("RECV_FLAG").equals("IG") && formData.get("ES_MK1_STATUS").equals("Y") && formData.get("ES_PD1_STATUS").equals("Y") && formData.get("ES_QA1_STATUS").equals("Y") && formData.get("ES_FI_STATUS").equals("Y")) { %>
			                  <span class="btn_02 mr04"><a href="javascript:doAction('Save01','ED');">종료</a></span>
			<% } %>
					<span class="btn_02 mr04"><a href="javascript:doAction('Save01','FY');">종결</a></span>   
					<!-- <span class="btn_02"><a href="javascript:setReturn()">닫기</a></span> -->
  				</span>
  			 </div>
			      
    </div>        
</div>
<%}%>

<div id="optionTags" ></div> 
</form>

	<form name="processForm" id="processForm"  method="post">	
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="buyer" id="buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="gubun" id="gubun" value="" />
		<div id="process">
		</div>
	</form>
	

				
	
 
</body>
</html>


