<%--
**********************************************
* 메뉴 : 신규영업관리 > 잠재고객 정보 입찰등록
* 화면 : 잠재고객 정보 입찰
* 기능 : 
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = null;
	_dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;	
	String userid = "";
	String userName = "";
	if (_sessionInfo != null){ 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
		userName = CommonUtil.nvl((String)_sessionInfo.getUserNameLoc());  	
	}
	String sbuyer = "";
	String st_process_type = "";
	String st_close_flag = "";
	String st_b_revision = "";
	String search_yn = CommonUtil.nvl((String) request.getParameter("st_search_yn"), "N");

	
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
		sbuyer = CommonUtil.nvl(_rowData.get("BUYER"));
		if(st_b_revision.equals("")){
			st_b_revision =CommonUtil.nvl(_rowData.get("REVISION"));
		}
		
		st_process_type = CommonUtil.nvl(_rowData.get("PROCESS_TYPE"),"");
		st_close_flag = CommonUtil.nvl(_rowData.get("BUYER_CLOSE_FLAG"),"");
		
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
var popupSel = "";
var grbRow = "";
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
function popupOnload(){
	//달력셋팅
	kepSetCalender("st_rfq_r_date");
	kepSetCalender("st_rfq_c_date");
	kepSetCalender("st_mro_open_date");
}

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search":
			kepAjaxFormCall("/mdct/getMasterMdCtNewCustomerBidList.do","searchCondition","search");
			break;
		case "searchDetail":
			if (isEmpty($("#st_s_revision").val())) {
				alert("입찰차수 정보가 입력되지 않았습니다. ");
				$("#st_s_revision").focus();
				return;
			}
			$('#searchCondition').attr("action", "/mdct/getMasterMdCtNewCustomerBidList.do").submit();
			break;
		case "save":
			if (checkSaveSubmit()) {
			    if(!confirm("저장 하시겠습니까?  ")) {
			        return;
			    }else{
			    	document.forms.searchCondition.st_data_gbn.value = "save";
			       kepAjaxFormCall("/mdct/saveMasterMdCtNewCustomerBidList.do","searchCondition","save"); 	   
			    }
			}
			break;
		case "reg":
			if (checkSaveSubmit()) {
				if (isEmpty($("#st_bid_company").val())) {
					alert("낙찰사가 입력되지 않았습니다. ");
					$("#st_bid_company").focus();
					return;
				}
				if (isEmpty($("#st_bid_note").val())) {
					alert("입찰결과 특이사항이 입력되지 않았습니다. ");
					$("#st_bid_company").focus();
					return;
				}
				if (isEmpty($("#st_image_key").val())) {
					alert("입찰결과 첨부파일 등록이 필요합니다. ");
					return;
				}
			    if(!confirm("입찰등록 처리 하시겠습니까?  ")) {
			        return;
			    }else{
			       document.forms.searchCondition.st_data_gbn.value = "reg";
			       document.forms.searchCondition.st_process_type.value = "ST";
			       kepAjaxFormCall("/mdct/saveMasterMdCtNewCustomerBidList.do","searchCondition","reg"); 	   
			    }
			}
			break;
		case "update":
			if (checkSaveSubmit()) {
				if (isEmpty($("#st_bid_company").val())) {
					alert("낙찰사가 입력되지 않았습니다. ");
					$("#st_bid_company").focus();
					return;
				}
				if (isEmpty($("#st_bid_note").val())) {
					alert("입찰결과 특이사항이 입력되지 않았습니다. ");
					$("#st_bid_company").focus();
					return;
				}
				if (isEmpty($("#st_image_key").val())) {
					alert("입찰결과 첨부파일 등록이 필요합니다. ");
					return;
				}
			    if(!confirm("잠재고객 정보 수정 하시겠습니까?  ")) {
			        return;
			    }else{
			    	document.forms.searchCondition.st_data_gbn.value = "update";
			       kepAjaxFormCall("/mdct/saveMasterMdCtNewCustomerBidList.do","searchCondition","update"); 	   
			    }
			}
			break;
		case "cancle":
		    if(!confirm("입찰취소 처리 하시겠습니까?  ")) {
		        return;
		    }else{
		       kepAjaxFormCall("/mdct/cancleMasterMdCtNewCustomerBidList.do","searchCondition","cancle"); 	   
		    }
			break;
		case "end"://종결처리
			// 사유입력
			if(confirm("잠재고객 정보 종결 하시겠습니까?  ")) {
				popupSel = "reasonPop";
				openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=O',"500,280,no");				
			}
			break;
		case "reStart"://재개
			if(confirm("잠재고객 정보 재개하시겠습니까?  ")) {
			    $("#st_end_remark").val("");
			    $("#st_buyer_close_flag_in").val("N");
				kepAjaxFormCall("/mdct/endMasterMdCtNewCustomer.do","searchCondition","restart");				
			}
			break;						
	}

}

//팝업리턴
function setReason(value){
    
	//사유저장
	if (popupSel == "reasonPop"){
	    $("#st_end_remark").val(value);
	    $("#st_buyer_close_flag_in").val("Y");
	    kepAjaxFormCall("/mdct/endMasterMdCtNewCustomer.do","searchCondition","end");
	}
	
}
function checkSaveSubmit(){

	if (isEmpty($("#st_rfq_type").val())) {
		alert("입찰형태가 입력되지 않았습니다. ");
		$("#st_rfq_type").focus();
		return false;
	}

	if (isEmpty($("#st_rfq_r_date").val())) {
		alert("RFQ접수일이 입력되지 않았습니다. ");
		$("#st_rfq_r_date").focus();
		return false;
	}
	if (isEmpty($("#st_rfq_amount").val())) {
		alert("대상모수가 입력되지 않았습니다. ");
		$("#st_rfq_amount").focus();
		return false;
	}
	if (isEmpty($("#st_rfq_c_date").val())) {
		alert("입찰기한이 입력되지 않았습니다. ");
		$("#st_rfq_c_date").focus();
		return false;
	}
	if (isEmpty($("#st_mro_open_date").val())) {
		alert("거래 개시일이 입력되지 않았습니다. ");
		$("#st_mro_open_date").focus();
		return false;
	}
	if (isEmpty($("#st_mro_cmpy").val())) {
		alert("기존 구매대행사가 입력되지 않았습니다. ");
		$("#st_mro_cmpy").focus();
		return false;
	}
	if (isEmpty($("#st_rfq_cmpy").val())) {
		alert("입찰 참여사가 입력되지 않았습니다. ");
		$("#st_rfq_cmpy").focus();
		return false;
	}
	if (isEmpty($("#st_eval_note").val())) {
		alert("평가항목이 입력되지 않았습니다. ");
		$("#st_eval_note").focus();
		return false;
	}
	if (isEmpty($("#st_rfq_dept_name").val())) {
		alert("서비스 담당팀이 입력되지 않았습니다. ");
		$("#st_rfq_dept_name").focus();
		return false;
	}
	if (isEmpty($("#st_kep_s_user_nm").val())) {
		alert("소싱팀PM이 입력되지 않았습니다. ");
		$("#st_kep_s_user_nm").focus();
		return false;
	}
	if (isEmpty($("#st_kep_b_user_nm").val())) {
		alert("사업팀PM이 입력되지 않았습니다. ");
		$("#st_kep_b_user_nm").focus();
		return false;
	}
	if (isEmpty($("#st_price_yn").val())) {
		alert("소싱정보 기존단가 여부가 입력되지 않았습니다. ");
		$("#st_price_yn").focus();
		return false;
	}
	if (isEmpty($("#st_sc_qty_yn").val())) {
		alert("소싱정보 수량여부가 입력되지 않았습니다. ");
		$("#st_sc_qty_yn").focus();
		return false;
	}
	if (isEmpty($("#st_sc_order_yn").val())) {
		alert("소싱정보 발주빈도가 여부가 입력되지 않았습니다. ");
		$("#st_sc_order_yn").focus();
		return false;
	}
	if (isEmpty($("#st_sc_seller_yn").val())) {
		alert("소싱정보 기존 협력사 여부가 입력되지 않았습니다. ");
		$("#st_sc_seller_yn").focus();
		return false;
	}
	if (isEmpty($("#st_desc_yn").val())) {
		alert("소싱정보 품명 여부가 입력되지 않았습니다. ");
		$("#st_desc_yn").focus();
		return false;
	}
	if (isEmpty($("#st_spec_yn").val())) {
		alert("소싱정보 규격 여부가 입력되지 않았습니다. ");
		$("#st_spec_yn").focus();
		return false;
	}
	if (isEmpty($("#st_maker_yn").val())) {
		alert("소싱정보 제조사 여부가 입력되지 않았습니다. ");
		$("#st_maker_yn").focus();
		return false;
	}
	if (isEmpty($("#st_orgin_yn").val())) {
		alert("소싱정보 원산지 여부가 입력되지 않았습니다. ");
		$("#st_orgin_yn").focus();
		return false;
	}
	if (isEmpty($("#st_measure_yn").val())) {
		alert("소싱정보 단위 여부가 입력되지 않았습니다. ");
		$("#st_measure_yn").focus();
		return false;
	}
	if (isEmpty($("#st_delivery_yn").val())) {
		alert("소싱정보 배송방법 여부가 입력되지 않았습니다. ");
		$("#st_delivery_yn").focus();
		return false;
	}
	if (isEmpty($("#st_seller_rfq_yn").val())) {
		alert("기존 협력사 소싱가능 여부가 입력되지 않았습니다. ");
		$("#st_seller_rfq_yn").focus();
		return false;
	}
	if (isEmpty($("#st_buyer_open_yn").val())) {
		alert("고객사 공개 가능여부가 입력되지 않았습니다. ");
		$("#st_buyer_open_yn").focus();
		return false;
	}
	if (isEmpty($("#st_proposal_yn").val())) {
		alert("대체제품 제안 가능여부가 입력되지 않았습니다. ");
		$("#st_proposal_yn").focus();
		return false;
	}
	if (isEmpty($("#st_sample_yn").val())) {
		alert("샘플제공 가능여부가 입력되지 않았습니다. ");
		$("#st_sample_yn").focus();
		return false;
	}
	if (isEmpty($("#st_cond_yn").val())) {
		alert("시황적용 가능여부가 입력되지 않았습니다. ");
		$("#st_cond_yn").focus();
		return false;
	}
	if (isEmpty($("#st_period_yn").val())) {
		alert("단가계약 기간여부가 입력되지 않았습니다. ");
		$("#st_period_yn").focus();
		return false;
	}
	if (isEmpty($("#st_new_rate").val())) {
		alert("신규발생 비율이 입력되지 않았습니다. ");
		$("#st_new_rate").focus();
		return false;
	}
	if (isEmpty($("#st_bill_type").val())) {
		alert("결제조건이 입력되지 않았습니다. ");
		$("#st_bill_type").focus();
		return false;
	}
	if (isEmpty($("#st_sc_note").val())) {
		alert("입찰정보 특이사항이 입력되지 않았습니다. ");
		$("#st_sc_note").focus();
		return false;
	}
	return true;
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	
	if (pMethod == "reg"||pMethod == "update"||pMethod == "cancle"||pMethod == "save"||pMethod == "end"||pMethod == "restart"){ 
		 alert("처리 실패 하였습니다. 다시 시도 하여 주십시오"); 
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var result = response.msg.MSG;  
	if(pMethod=="reg"){
		if(result=="Ok"){
			alert("입찰등록 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}
	}else if(pMethod=="save"){
		if(result=="Ok"){
			alert("저장 되었습니다.");
			doAction("search")
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="update"){
		if(result=="Ok"){
			alert("수정 되었습니다.");
			doAction("search")
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="cancle"){
		if(result=="Ok"){
			alert("취소 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="end"){
		if(result=="Ok"){
			alert("잠재고객사 종결 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}else if(pMethod=="restart"){
		if(result=="Ok"){
			alert("잠재고객사 재개 처리 되었습니다.");
			opener.doAction('search');
			this.close();
		}else{
			alert(result);
			return;
		}		
	}
}


//팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	switch (str) {
		case "remark":
			popupSel = "activityRegPop";
			openSearchPopup("/mdcd/showMasterMdCdPrimaryActivityDetailRegPop.do", "?com_code=" + val1 + "&add_date=" + val2 + "&add_time=" + val3 + "&st_potential_customer_yn=Y", "1000, 500,no");
			break;
		case "rfqDept":
			popupSel = "rfqDept";
			openSearchPopup('/common/deptCodeAdminPop.do','?open=N&com_code=KRKORE0001', '500,500,no');
			break;
		case "kepSUser": 
			popupSel = "kepSUser";
			openSearchPopup("/common/kepUserSelectAllPop.do", '', "500,485,no");
	        break;
		case "kepBUser": 
			popupSel = "kepBUser";
			openSearchPopup("/common/kepUserSelectAllPop.do", '', "500,485,no");
	        break;	
		case 	"fileUpload": //파일업로드
			popupSel = "fileUpload";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=CSTM", "500,430,no");
			break;	
		case 	"fileSetupUpload": //셋업 파일첨부.
			popupSel = "fileSetupUpload";
			var viewType="R";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_set_image_key").val()+"&TYPE=CSTM&viewType="+viewType, "500,430,no");
			break;
		case 	"fileContUpload": //계약 파일첨부.
			popupSel = "fileContUpload";
			var viewType="R";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_cont_image_key").val()+"&TYPE=CSTM&viewType="+viewType, "500,430,no");
			break;	
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
									,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
									,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30
									,value31,value32){
	 if(popupSel == "rfqDept"){//서비스 담당팀
			$("#st_rfq_dept_code").val(value1);
			$("#st_rfq_dept_name").val(value2);
	}else if(popupSel == "kepSUser"){//소싱팀 pm
		$("#st_kep_s_user_id").val(value1);
		$("#st_kep_s_user_nm").val(value2);		
	}else if(popupSel == "kepBUser"){//사업팀 pm
		$("#st_kep_b_user_id").val(value1);
		$("#st_kep_b_user_nm").val(value2);
	}else if(popupSel == "fileUpload"){//첨부파일
		$("#st_image_key").val(value1);
		$("#st_image_key_text").val(value2);
	}
}



</script> 
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post"  >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<input type="hidden" id="com_code"  name="com_code"  value="<%=sbuyer%>">
	<input type="hidden" id="st_com_code"  name="st_com_code"  value="<%=sbuyer%>">
	<input type="hidden" id="st_end_remark"  name="st_end_remark"  value="">
	<input type="hidden" id="st_buyer_close_flag_in"  name="st_buyer_close_flag_in"  value="">
	<input type="hidden" id="st_revision"  name="st_revision"  value="<%=CommonUtil.nvl(_rowData.get("REVISION")) %>">
	<input type="hidden" id="st_data_gbn"  name="st_data_gbn"  value="">
	<input type="hidden" id="st_process_type"  name="st_process_type"  value="">
	<input type="hidden" id="st_search_yn"  name="st_search_yn"  value="<%=search_yn%>">

	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
        	<h1 class="title">잠재고객 입찰정보 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
		<%
		if(search_yn.equals("Y")){
		%>
             <div id="searchBtnA02">
		          입찰차수: <select name="st_s_revision" id="st_s_revision" style="width:5%">
					<%= CommonUtil.getDynamicComboList("SEL", CommonUtil.nvl(_rowData.get("T_REVISION")), st_b_revision) %>           
				</select>
             	<span class="btn_search"><a href="javascript:doAction('searchDetail')">조회</a></span> 
            </div>
		<%
		}else{
		%>
			<input type="hidden" id="st_s_revision"  name="st_s_revision"  value="">	
		<%
		}
		%>
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:518px;">
        	<!--버튼영역-->
            <!--조회영역-->
            <h4><b>잠재고객 정보</b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="11%"/>
                        <col width="14%" />
                        <col width="11%" />
                        <col width="14%" />
                        <col width="11%"/>
                        <col width="14%"/>
                        <col width="11%"/>
                        <col width="14%"/>                                          
						</colgroup>
						<tbody>
						  <tr>		
							<th>고객사명</th>			
							<td><input type="text" name="st_buyer_name" id="st_buyer_name" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("BUYER_NAME")) %>"/></td>	
							<th>그룹사</th>			
							<td><input type="text" name="st_group" id="st_group" class="input_type_text" title="" style="width:90%;background:#EAEAEA;"  readonly value="<%=CommonUtil.nvl(_rowData.get("GROUP_NAME")) %>"/></td>		
							<th>사업자번호</th>			
							<td><input type="text" name="st_irs_no" id="st_irs_no" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("IRS_NO")) %>"/></td>
							<th>입찰차수</th>			
							<td><input type="text" name="st_b_revision" id="st_b_revision" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("REVISION")) %>"/></td>
						 </tr>
					</tbody>
				</table>	
            <h4><b>입찰정보</b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="11%"/>
                        <col width="14%" />
                        <col width="11%" />
                        <col width="14%" />
                        <col width="11%"/>
                        <col width="14%"/>
                        <col width="11%"/>
                        <col width="14%"/>                                            
						</colgroup>
						<tbody>
						  <tr>		
						  	<th>* 입찰형태</th>  		
							<td>
								<select name="st_rfq_type" id="st_rfq_type" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP08","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("RFQ_TYPE")), "") %>           
						         </select>
							</td>
							<th>* RFQ접수일</th>			
							<td>
								<input type="text" class="input_type_text" name="st_rfq_r_date" id="st_rfq_r_date" style="width:65%;" readOnly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("RFQ_RECEIPT_DATE"))) %>"/></td>
								<a href="javascript:kepCalendar('st_rfq_r_date')"></a>
							</td>
							<th>* 대상모수</th>
							<td><input type="text" name="st_rfq_amount" id="st_rfq_amount" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("RFQ_AMOUNT_NOTE")) %>"/></td>
							<th>* 입찰기한</th>
							<td>
								<input type="text" class="input_type_text" name="st_rfq_c_date"  id="st_rfq_c_date" style="width:65%;" readOnly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("RFQ_CLOSE_DATE"))) %>"/></td>
								<a href="javascript:kepCalendar('st_rfq_c_date')"></a>
							</td>
						 </tr>
						  <tr>		
						  	<th>* 거래개시</th>  		
							<td>
								<input type="text" class="input_type_text" name="st_mro_open_date" id="st_mro_open_date" style="width:65%;" readOnly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("MRO_OPEN_DATE"))) %>"/></td>
								<a href="javascript:kepCalendar('st_mro_open_date')"></a>
							</td>
							<th>*기존<br>구매대행사</th>			
							<td>
								<select name="st_mro_cmpy" id="st_mro_cmpy" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP04","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("MRO_COMPANY")), "") %>           
						         </select>
							</td>
							<th>* 입찰참여사</th>
							<td colspan="3"><input type="text" name="st_rfq_cmpy" id="st_rfq_cmpy" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("RFQ_COMPANY")) %>"/></td>
						 </tr>
						  <tr>		
						  	<th>* 평가항목</th>  		
							<td><input type="text" name="st_eval_note" id="st_eval_note" class="input_type_text" title="" style="width:90%;" value="<%=sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("EVALUATION_NOTE")) %>"/></td>
							<th>*서비스<br>담당팀</th>			
							<td>
		                        <input type="text" class="input_type_text" name="st_rfq_dept_name"  id="st_rfq_dept_name" style="width:60%;" value="<%=CommonUtil.nvl(_rowData.get("RFQ_KEP_DEPT_NM")) %>" READONLY>
		                        <input type="hidden" name="st_rfq_dept_code" id="st_rfq_dept_code" style="width:100px;" value="<%=CommonUtil.nvl(_rowData.get("RFQ_KEP_DEPT")) %>">
		                        <a href="javascript:doPop('rfqDept');"><img src="/resources/images/btn_search03.gif"></a>
							</td>
							<th>* 소싱팀PM</th>			
							<td><input type="text" name="st_kep_s_user_nm" id="st_kep_s_user_nm" class="input_type_text" title="" style="width:60%;"  readonly onclick="javascript:doPop('kepUser');" value="<%=CommonUtil.nvl(_rowData.get("RFQ_KEP_S_USER_NM")) %>"/>
								  <input type="hidden" name="st_kep_s_user_id" id="st_kep_s_user_id" style="width:80%" value="<%=CommonUtil.nvl(_rowData.get("RFQ_KEP_S_USER_ID")) %>"/>
								<a href="javascript:doPop('kepSUser');"><img src="/resources/images/btn_search03.gif"></a>
							</td>
							<th>* 사업팀PM</th>			
							<td><input type="text" name="st_kep_b_user_nm" id="st_kep_b_user_nm" class="input_type_text" title="" style="width:60%;"  readonly onclick="javascript:doPop('kepUser');" value="<%=CommonUtil.nvl(_rowData.get("RFQ_KEP_B_USER_NM")) %>"/>
								  <input type="hidden" name="st_kep_b_user_id" id="st_kep_b_user_id" style="width:80%" value="<%=CommonUtil.nvl(_rowData.get("RFQ_KEP_B_USER_ID")) %>"/>
								<a href="javascript:doPop('kepBUser');"><img src="/resources/images/btn_search03.gif"></a>
							</td>  
						 </tr>
						 <tr>
							<th>*특이사항</th>			
							<td colspan="7"><input type="text" name="st_sc_note" id="st_sc_note" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("SC_NOTE")) %>"/></td>
						 </tr>
					</tbody>
				</table>	
            <h4><b>소싱정보 </b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="11%"/>
                        <col width="14%" />
                        <col width="11%" />
                        <col width="14%" />
                        <col width="11%"/>
                        <col width="14%"/>
                        <col width="11%"/>
                        <col width="14%"/>                                            
						</colgroup>
						<tbody>
						 <tr>				
							<th>*기존단가</th>			
							<td>
								<select name="st_price_yn" id="st_price_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_BASICS_PRICE_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_BASICS_PRICE_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>	
							<th>*수량</th>			
							<td>
								<select name="st_sc_qty_yn" id="st_sc_qty_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_QTY_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_QTY_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>		
							<th>*발주빈도</th>			
							<td>
								<select name="st_sc_order_yn" id="st_sc_order_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_ORDER_FREQUENCY_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_ORDER_FREQUENCY_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>
							<th>*기존협력사</th>			
							<td>
								<select name="st_sc_seller_yn" id="st_sc_seller_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_EXISTING_SELLER_FLAG")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_EXISTING_SELLER_FLAG")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>																														  	
						  </tr>
						 <tr>				
							<th>*품명</th>			
							<td>
								<select name="st_desc_yn" id="st_desc_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_DESCRIPTION_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_DESCRIPTION_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>	
							<th>*규격</th>			
							<td>
								<select name="st_spec_yn" id="st_spec_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_SPECIFICATION_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_SPECIFICATION_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>		
							<th>*제조사</th>			
							<td>
								<select name="st_maker_yn" id="st_maker_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_MAKER_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_MAKER_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>
							<th>*원산지</th>			
							<td>
								<select name="st_orgin_yn" id="st_orgin_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_ORIGIN_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_ORIGIN_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>																														  	
						  </tr>
						 <tr>				
							<th>*단위</th>			
							<td>
								<select name="st_measure_yn" id="st_measure_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_MEASURE_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_MEASURE_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>	
							<th>*배송방법</th>			
							<td>
								<select name="st_delivery_yn" id="st_delivery_yn" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP10","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("SC_DELIVERY_TYPE")), "") %>           
						         </select>
							</td>		
							<th>*기존협력사<br>소싱가능여부</th>			
							<td>
								<select name="st_seller_rfq_yn" id="st_seller_rfq_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_EXISTING_SELLER_RFQ_FLAG")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_EXISTING_SELLER_RFQ_FLAG")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>
							<th>*고객사공개<br>가능여부</th>			
							<td>
								<select name="st_buyer_open_yn" id="st_buyer_open_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_BUYER_OPEN_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_BUYER_OPEN_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>																														  	
						  </tr>
						 <tr>				
							<th>*대체제품<br>제안가능여부</th>			
							<td>
								<select name="st_proposal_yn" id="st_proposal_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_LOANER_PROPOSAL_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_LOANER_PROPOSAL_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>	
							<th>*샘플제공<br>가능여부</th>			
							<td>
								<select name="st_sample_yn" id="st_sample_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_SAMPLE_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_SAMPLE_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>		
							<th>*시황적용<br>가능여부</th>			
							<td>
								<select name="st_cond_yn" id="st_cond_yn"  style="height:20px; width: 60px;" >
									<option value="">선택</option>
									<option value="Y" <% if (CommonUtil.nvl(_rowData.get("SC_MARKET_CONDITIONS_YN")).equals("Y")) { %> selected <%} %>>Y</option>
									<option value="N" <% if (CommonUtil.nvl(_rowData.get("SC_MARKET_CONDITIONS_YN")).equals("N")) { %> selected <%} %>>N</option>
			                	</select>
							</td>
							<th>*단가계약<br>기간</th>			
							<td>
								<select name="st_period_yn" id="st_period_yn" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP11","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("SC_DELIVERY_TYPE")), "") %>           
						         </select>
							</td>																														  	
						  </tr>
						 <tr>				
							<th>*신규발생<br>비율</th>			
							<td>
								<select name="st_new_rate" id="st_new_rate" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "CP09","", "ICOMCOD1", CommonUtil.nvl(_rowData.get("SC_NEW_ITEM_RATE_TYPE")), "") %>           
						         </select>
							</td>	
							<th>*결제조건</th>			
							<td>
								<select name="st_bill_type" id="st_bill_type" style="width:80%">
								  	<%= CommonUtil.getCode3ComboList("", "SEL", "SA15","", "ICOMCOD1", sbuyer.equals("")?"":CommonUtil.nvl(_rowData.get("SC_BILL_TYPE")), "") %>           
						         </select>
							</td>		
							<th>등록일</th>			
							<td><input type="text" name="st_add_date" id="st_add_date" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("ADD_DATE"))) %>"/></td>
							<th>등록자</th>			
							<td><input type="text" name="st_add_user_nm" id="st_add_user_nm" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("ADD_USER_NAME")) %>"/></td>																														  	
						  </tr>	
					</tbody>
				</table>	
            <h4><b>입찰결과</b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="11%"/>
                        <col width="14%" />
                        <col width="11%" />
                        <col width="14%" />
                        <col width="11%"/>
                        <col width="14%"/>
                        <col width="11%"/>
                        <col width="14%"/>                                          
						</colgroup>
						<tbody>
						  <tr>		
							<th>*낙찰사</th>			
							<td><input type="text" name="st_bid_company" id="st_bid_company" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("BID_COMPANY")) %>"/></td>
							<th>*특이사항</th>			
							<td colspan="5"><input type="text" name="st_bid_note" id="st_bid_note" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("BID_NOTE")) %>"/></td>		
						 </tr>
						  <tr>		
							<th>*첨부파일<br></th>			
							<td colspan="3">								
								<input type="hidden" id="st_image_key" name="st_image_key" value="<%=CommonUtil.nvl(_rowData.get("BID_IMAGE_KEY")) %>" />
								<input type="hidden" id="st_image_key_Text" 	name="st_image_key_Text" class="input_type_text" title="" style="width: 250px;" value="" />
								<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileUpload')">첨부등록</a></span> Ex) 제안결과/제안서 등
							</td>			
							<th>등록일</th>			
							<td><input type="text" name="st_add_date" id="st_add_date" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("BID_ADD_DATE"))) %>"/></td>
							<th>등록자</th>			
							<td><input type="text" name="st_add_user_nm" id="st_add_user_nm" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("BID_ADD_USER_NAME")) %>"/></td>
						 </tr>
					</tbody>
				</table>	
			<%
			if(search_yn.equals("Y")){
			%>
            <h4><b>셋업결과</b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="*" />                                         
						</colgroup>
						<tbody>
						  <tr>		
							<th>*특이사항</th>			
							<td colspan="5"><input type="text" name="st_setup_note" id="st_setup_note" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("SETUP_NOTE")) %>"/></td>		
						 </tr>
						  <tr>		
							<th>*첨부파일</th>			
							<td>								
								<input type="hidden" id="st_set_image_key" name="st_set_image_key" value="<%=CommonUtil.nvl(_rowData.get("SETUP_IMAGE_KEY")) %>" />
								<input type="hidden" id="st_set_image_key_Text" 	name="st_set_image_key_Text" class="input_type_text" title="" style="width: 250px;" value="" />
								<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileSetupUpload')">첨부등록</a></span> <br>Ex) 제안결과/메뉴얼 등
							</td>			
							<th>등록일</th>			
							<td><input type="text" name="st_set_add_date" id="st_set_add_date" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("SETUP_ADD_DATE"))) %>"/></td>
							<th>등록자</th>			
							<td><input type="text" name="st_set_add_user_nm" id="st_set_add_user_nm" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("SETUP_ADD_USER_NM")) %>"/></td>
						 </tr>
					</tbody>
				</table>	
            <h4><b>계약</b></h4>
			<table class="cont_t_list07" style="width:100%">
						<colgroup>
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="19%" />
						<col width="14%"/>
                        <col width="*" />                                         
						</colgroup>
						<tbody>
						  <tr>		
							<th>*특이사항</th>			
							<td colspan="5"><input type="text" name="st_con_note" id="st_con_note" class="input_type_text" title="" style="width:90%;" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_NOTE")) %>"/></td>		
						 </tr>
						  <tr>		
							<th>*첨부파일</th>			
							<td>								
								<input type="hidden" id="st_cont_image_key" name="st_cont_image_key" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_IMAGE_KEY")) %>" />
								<input type="hidden" id="st_cont_image_key_Text" 	name="st_cont_image_key_Text" class="input_type_text" title="" style="width: 250px;" value="" />
								<span class="btn_gray_03" title="파일첨부"><a href="javascript:doPop('fileContUpload')">첨부등록</a></span> <br>Ex) 계약서 등
							</td>			
							<th>등록일</th>			
							<td><input type="text" name="st_cont_add_date" id="st_cont_add_date" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(_rowData.get("CONTRACT_ADD_DATE"))) %>"/></td>
							<th>등록자</th>			
							<td><input type="text" name="st_cont_add_user_nm" id="st_cont_add_user_nm" class="input_type_text" title="" style="width:90%;background:#EAEAEA;" readonly value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_ADD_USER_NM")) %>"/></td>
						 </tr>
					</tbody>
				</table>	
			<%
			}
			%>
            <!--grid-->
			<span class="fr">
			<%
			if(search_yn.equals("N")){
				if(st_close_flag.equals("Y")){
				%>
					<span class="btn_02 mr04"><a href="javascript:doAction('reStart')">재개</a></span>
				<%
				}else{
					//BD 입찰 진행 중일때 입찰등록 가능.
					if(st_process_type.equals("BD")){
				%>
					<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
					<span class="btn_04 mr04"><a href="javascript:doAction('reg')">낙찰완료</a></span>				
				<%
					//셋업진행 중일때 일때만 수정 가능.
					}else if(st_process_type.equals("ST")){
				%>
					<span class="btn_02 mr04"><a href="javascript:doAction('cancle')">취소</a></span>
				<%
					}
					if(!st_process_type.equals("BD")){
				%>
						<span class="btn_02 mr04"><a href="javascript:doAction('update')">수정</a></span>
				<%												
					}
					if(!st_process_type.equals("CP")){
				%>
						<span class="btn_02 mr04"><a href="javascript:doAction('end')">종결</a></span>
				<%
					}
				}
			}
			%>					
			</span>
			<br/>
		</div>	
        <!--버튼영역-->

        
    </div>
</form> 
</body>
</html>
