<%--
**********************************************
* 메뉴 : 
* 화면 : VOC 진행현황 상세정보 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_800_14
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-16
**********************************************
--%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
 
</head>
<%
		
String user_id		= CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String user_name    = _sessionInfo.getUserNameLoc();
String user_dept	= CommonUtil.nvl((String) request.getParameter("st_user_dept"),_sessionInfo.getDepartment());

@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = _dataList != null && _dataList.size() > 0 ? _dataList.get(0) : new HashMap<String, String>();

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"), "");
String st_vc_no = CommonUtil.nvl((String) request.getParameter("st_vc_no"), "");
String st_claim_master = CommonUtil.nvl((String) request.getParameter("st_claim_master"), "");
String st_req_date = rowData.get("REQ_DATE");
String curDate   = DateTimeUtil.getFormatString("yyyyMMdd");
String st_ds_date = rowData.get("DS_DATE");

//진행내역 textarea 생성번호 초기화
int remark_cnt = 1;

if(rowData != null){
	if(CommonUtil.nvl(rowData.get("DS_REMARK_A")).equals("") && CommonUtil.nvl(rowData.get("DS_REMARK_B")).equals("") && CommonUtil.nvl(rowData.get("DS_REMARK_C")).equals("")){
			remark_cnt = 1;
	}else if(!CommonUtil.nvl(rowData.get("DS_REMARK_A")).equals("") && CommonUtil.nvl(rowData.get("DS_REMARK_B")).equals("") && CommonUtil.nvl(rowData.get("DS_REMARK_C")).equals("")){ 
			remark_cnt = 2;
	}else if(!CommonUtil.nvl(rowData.get("DS_REMARK_A")).equals("") && !CommonUtil.nvl(rowData.get("DS_REMARK_B")).equals("") && CommonUtil.nvl(rowData.get("DS_REMARK_C")).equals("")){              			
			remark_cnt = 3;
	}else if(!CommonUtil.nvl(rowData.get("DS_REMARK_A")).equals("") && !CommonUtil.nvl(rowData.get("DS_REMARK_B")).equals("") && !CommonUtil.nvl(rowData.get("DS_REMARK_C")).equals("")){  	
			remark_cnt = 4;
	}
}

%>

<script type="text/javascript">
var count = <%=remark_cnt%>; // textarea 의 name 에 사용할 카운터를 설정합니다

//진행내역 입력박스 추가
function addBox(){ 

	var nowdate = "<%=curDate%>";
	if($("#st_remark_cnt").val() > 3){
		alert("진행내역은 3회까지 생성 및 입력 가능합니다.");
	    return;
	}
	
	var Commentext = '<textarea rows="2" cols="70" id="st_ds_remark_' + count + '" name="st_ds_remark_' + count++ + '" style="text-align:left;width:100%;" >'+nowdate+'</textarea>';
	$("#td_df_remark").append(Commentext);
	$("#st_remark_cnt").val(count);
}

//팝업함수호출
function doPop(str, value1) {
	popupSel = str;
	
	switch (str) {
		case "masterCmCoBuyerAgntcmpyPop": // 고객사, 협력사 팝업
			openSearchPopup("/cmco/showMasterCmCoBuyerAgntcmpyPop.do", "?st_com_type=S&st_sys_change_flag=N&st_sys_type=KA", "500,500,no");
			popupSel = "masterCmCoBuyerAgntcmpyPop";
			break;
			
		case "masterpoDetailPop": // 발주팝업
			var st_buyer =$("#st_buyer").val();
			var st_po_no =$("#st_po_no").val();	
			if(st_po_no == ""){
				alert("발주 정보가 없습니다.");
				return;
			}else{
				openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+st_buyer+'&st_po_no='+st_po_no,'900,550,no');
				popupSel = "masterpoDetailPop";				
			}
			break;
			
		case "masterMdCmBuyerCatalogAlterPop": // 카탈로그상세세 팝업
			var st_buyer =$("#st_buyer").val();
			var st_catalog_com_code =$("#st_catalog_com_code").val();	
			var st_buyer_item_no = $("#st_buyer_item_no").val(); 
			openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+st_buyer+"&st_catalog_com_code="+st_catalog_com_code+"&st_buyer_item_no="+st_buyer_item_no,"988,710,no");
			popupSel = "masterMdCmBuyerCatalogAlterPop";
			break;
			
		case "req_attach"://파일 첨부
			popupSel = "fileUpload";
			var viewType = value1;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+$("#st_image_key1").val()+'&viewType='+viewType+'&TYPE=VOC','500,430,no');// 파일첨부
			break;
		
		case "ds_attach"://파일 첨부
			popupSel = "fileUpload1";
			var viewType = value1;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+$("#st_image_key2").val()+'&viewType='+viewType+'&TYPE=VOC','500,430,no');// 파일첨부 
			break;
			
		case "feedback_attach"://파일 첨부
			popupSel = "fileUpload2";
			var viewType = value1;
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+$("#st_image_key3").val()+'&viewType='+viewType+'&TYPE=VOC','500,430,no');// 파일첨부 
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterCmCoBuyerAgntcmpyPop") {	// 고객사, 협력사 팝업
		// value1			, value2		, value3			, value4		, value5				, value6
		// db_com_code	, com_code	, com_name	, com_info	, com_sys_type	, com_type
		
		$("#st_agent_code").val(value2);
		$("#st_agent_name").val(value3);
		$("#tmp_company").val("");
	}else if (popupSel == "fileUpload1") {
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";

		if(value1 != ''){
			document.forms.masterMpVoVocProgressStatePop.st_image_key2.value = value1;
			document.forms.masterMpVoVocProgressStatePop.st_ds_image_key_img.src = diskOn;
	    }else{
			document.forms.masterMpVoVocProgressStatePop.st_image_key2.value = "";
			document.forms.masterMpVoVocProgressStatePop.st_ds_image_key_img.src = diskOff;
	    }
	}else if (popupSel == "fileUpload2") {
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";

		if(value1 != ''){
			document.forms.masterMpVoVocProgressStatePop.st_image_key3.value = value1;
			document.forms.masterMpVoVocProgressStatePop.st_feedback_image_key_img.src = diskOn;
	    }else{
			document.forms.masterMpVoVocProgressStatePop.st_image_key3.value = "";
			document.forms.masterMpVoVocProgressStatePop.st_feedback_image_key_img.src = diskOff;
	    }
	}
	
	grbRow="";	//초기화
}

//기능함수
function doAction(str, gbn) {
	var nowDate = "<%=curDate%>";
	var impute_flag = $("input:radio[name=st_impute_flag]:checked").val();
	var claim_type  = $("#st_claim_type").val();
	
	if(str == "setFinishSave" || str == "saveVocProgressStatePop"){

		if(claim_type == ""){
	        alert("VOC Type의 하위분류를 선택해 주십시오.");
	        $("#st_claim_type_info").focus();
	        return;
	    }
	    var agent_code  = $("#st_agent_code").val();
	    
	    var claim_grade = $("#st_claim_grade").val();
	    var claim_kind = $("#st_claim_kind").val();

	    if(claim_kind == "C" && claim_grade == ""){
	         alert("클레임 등급을 선택해 주시기 바랍니다.");
	         $("#st_claim_grade").focus();
	         return;
	    }
	    var ds_user_id_1 = $("#st_ds_user_id_1").val();
	    var ds_dept_id_1 = $("#st_ds_dept_id_1").val();
	          
	    var process_info = $("#st_ds_user_id_2").val();
	    var process_info2 = process_info.split("@@", -1);
	     
	    var ds_user_id_3 = process_info2[0];
	    var ds_dept_id_3 = process_info2[2];
	     
		if(ds_user_id_1 != ds_user_id_3){
			$("#st_ds_change_flag").val("Y");
			$("#st_ds_user_id").val(ds_user_id_3);
			$("#st_ds_dept_id").val(ds_dept_id_3);
		}else{
			$("#st_ds_change_flag").val("N");
			$("#st_ds_user_id").val(ds_user_id_1);
			$("#st_ds_dept_id").val(ds_dept_id_1);
		}
	}
	
	switch (str) {
		case "setDSUserChange":	 // 처리담당자 변경
			var ds_user_id_1 = $("#st_ds_user_id_1").val();     
			var ds_user_nm_1 = $("#st_ds_user_nm_1").val();
		          
			var process_info = $("#st_ds_user_id_2").val();
			var process_info2 = process_info.split("@@", -1);
		     
		    var ds_user_id_3 = process_info2[0];
			var ds_user_nm_3 = process_info2[1];
			var ds_dept_id_3 = process_info2[2];
		     
			if(ds_user_id_1 != ds_user_id_3){
				if(confirm("처리담당자를 " +ds_user_nm_1+ " 에서 "+ds_user_nm_3+ " 로 변경하시겠습니까?")){
					$("#st_ds_user_id").val(ds_user_id_3);
					$("#st_ds_dept_id").val(ds_dept_id_3);
					$("#st_asis_ds_user_id").val(ds_user_id_1);
					kepAjaxPopFormCall("/mpvo/saveMasterMpVoVocDsUserInfo.do","masterMpVoVocProgressStatePop","saveDsUserInfo");
				}
			}else{
		         if(confirm("처리담당자를 기존대로 유지하시겠습니까?")){
		              return;
		         }else{
					$("#st_ds_user_id_2").focus();
		         }     
		    }
			break;
		
		case "setFinishSave":	//Feedback 처리 
			if(isEmpty($("#st_df_remark").val())){
		          alert("처리내용이 입력되지 않았습니다.\n\n입력 후 FeedBack 버튼을 클릭해 주시기 바랍니다.");
		          $("#st_df_remark").focus();
		          return;
		     }else{
		    	 if(impute_flag == "" || impute_flag == undefined){
			         alert("협력사 귀책 여부에 체크사항을 확인해 주시기 바랍니다.");
			         return;
			    }else{
			    	$("#st_impute_type").val(impute_flag);
			    }
			    
			    if(impute_flag == "SS" || impute_flag == "MS"){
			        if(agent_code == ""){
			             alert("협력사 귀책여부에 협력사가 선택된 경우에는\n\n 반드시 협력사를 지정해 주시기 바랍니다.");   
			             return;
			        }
			    }
		    	 
				if(confirm("기재하신 사항으로 고객사에게  Feed Back 하시겠습니까?")){
					// 공급사 귀책이 아닐 경우 초기화
					if(impute_flag != "SS" && impute_flag != "MS"){
						$("#st_agent_code").val("");
						$("#st_agent_name").val("");
					}
					
					if($("#mail_send_flag").is(":checked") == false){
						$("#st_mail_send_flag").val("N");
					}
					
					$("#st_recv_flag").val("FB");		// F/B완료
					kepAjaxPopFormCall("/mpvo/saveMasterMpVoVocProgressStatePop.do","masterMpVoVocProgressStatePop","saveFeedback");
				}
		     }
			break;
			
		case "saveVocProgressStatePop":	// 접수 A, 저장 B
			var st_msg = "";
			if(gbn == "A"){
				st_msg ="기재하신 사항으로 접수하시겠습니까?";
				$("#st_recv_flag").val("PS"); // 접수완료
			}else if(gbn == "B"){
				st_msg ="저장 하시겠습니까?";
				$("#st_recv_flag").val("DC"); // 저장
			}
			if(confirm(st_msg)){
				$("#st_impute_type").val(impute_flag);
				// 공급사 귀책이 아닐 경우 초기화
				if(impute_flag != "SS" && impute_flag != "MS"){
					$("#st_agent_code").val("");
					$("#st_agent_name").val("");
				}
				
			    var process_info = $("#st_ds_user_id_2").val();
			    var process_info2 = process_info.split("@@", -1);
			     
			    var ds_user_id_3 = process_info2[0];
			    var ds_dept_id_3 = process_info2[2];
			     
				$("#st_ds_user_id").val(ds_user_id_3);
				$("#st_ds_dept_id").val(ds_dept_id_3);
				
				kepAjaxPopFormCall("/mpvo/saveMasterMpVoVocProgressStatePop.do","masterMpVoVocProgressStatePop","saveVocProgressStatePop");
			}
		
			break;
		case "saveVocProgressStatePop2":	// 제출
			var ds_remark = $("#st_ds_remark_1").val();
		    var ds_user_id_1 = $("#st_ds_user_id_1").val();
		    var ds_dept_id_1 = $("#st_ds_dept_id_1").val();
		          
		    var process_info = $("#st_ds_user_id_2").val();
		    var process_info2 = process_info.split("@@", -1);
		     
		    var ds_user_id_3 = process_info2[0];
		    var ds_dept_id_3 = process_info2[2];
		     
			if(ds_user_id_1 != ds_user_id_3){
				$("#st_ds_change_flag").val("Y");
				$("#st_ds_user_id").val(ds_user_id_3);
				$("#st_ds_dept_id").val(ds_dept_id_3);
			}else{
				$("#st_ds_change_flag").val("N");
				$("#st_ds_user_id").val(ds_user_id_1);
				$("#st_ds_dept_id").val(ds_dept_id_1);
			}
			if(isEmpty(ds_remark)){
				alert("처리자 진행내용이 입력되지 않았습니다.");
				$("#st_ds_remark_1").focus();
		        return;
			}
			
			var user_id = "<%=user_id%>";
			var selected =  $("#st_ds_user_id_2").val().split('@@')[0];
			
			if(user_id != selected){
				alert("처리담당자와 현재 입력자가 불일치합니다!");
				 $("#st_ds_user_id_2").focus();
				 return;
			}
			var st_msg = "";
			var st_url = "";
			if(gbn == "A"){
				st_msg ="기재하신 사항으로 제출하시겠습니까?";
				$("#st_recv_flag").val("PA"); // 처리완료
				st_url = "/mpvo/saveMasterMpVoVocProgressStatePop.do";
			}else if(gbn == "B"){
				st_msg ="저장 하시겠습니까?";
				st_url = "/mpvo/saveMasterMpVoVocProgressPCPop.do";
			}			
			if(confirm(st_msg)){
				$("#st_impute_type").val(impute_flag);
				// 공급사 귀책이 아닐 경우 초기화
				if(impute_flag != "SS" && impute_flag != "MS"){
					$("#st_agent_code").val("");
					$("#st_agent_name").val("");
				}
				$("#st_ds_user_id").val($("#st_ds_user_id_2").val().split('@@')[0]);
				$("#st_ds_dept_id").val($("#st_ds_user_id_2").val().split('@@')[2]);
				kepAjaxPopFormCall(st_url,"masterMpVoVocProgressStatePop","saveVocProgressStatePop");
			}
		
			break;
			
		case "saveVocReReq" : // 재요청
			if(isEmpty($("#st_re_req_note").val())){
				alert("재요청사유가 입력되지 않았습니다.\n\n입력 후 재요청 버튼을 클릭해 주시기 바랍니다.");
		          $("#st_re_req_note").focus();
		          return;
			}
		    var ds_user_id_1 = $("#st_ds_user_id_1").val();
		    var ds_dept_id_1 = $("#st_ds_dept_id_1").val();
		          
		    var process_info = $("#st_ds_user_id_2").val();
		    var process_info2 = process_info.split("@@", -1);
		     
		    var ds_user_id_3 = process_info2[0];
		    var ds_dept_id_3 = process_info2[2];
		     
			if(ds_user_id_1 != ds_user_id_3){
				$("#st_ds_change_flag").val("Y");
				$("#st_ds_user_id").val(ds_user_id_3);
				$("#st_ds_dept_id").val(ds_dept_id_3);
			}else{
				$("#st_ds_change_flag").val("N");
				$("#st_ds_user_id").val(ds_user_id_1);
				$("#st_ds_dept_id").val(ds_dept_id_1);
			}
			kepAjaxPopFormCall("/mpvo/saveVocRevisionPop.do","masterMpVoVocProgressStatePop","saveVocReReq");
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "saveDsUserInfo") {
		if (sMsg == "OK") {
			alert("처리담당자가 변경되었습니다.");
			document.location.href = "/mpvo/getMasterMpVoVocProgressStatePop.do?st_buyer=<%=st_buyer%>&st_vc_no=<%=st_vc_no%>&st_claim_master=<%=st_claim_master%>";
			return;
		} else {
			alert("처리 담당자 변경 처리하던중 오류가 발생하였습니다.");
			parent.opener.doAction("search");
			parent.close();
			return;
		}
	} else if (pMethod == "saveFeedback") {
		if (sMsg == "OK") {
			alert("정상적으로 F/B 처리 완료되었습니다.");
			parent.opener.doAction("search");
			parent.close();
			return;
		} else {
			alert("Feedback 처리하던중 오류가 발생하였습니다.");
			parent.opener.doAction("search");
			parent.close();
			return;
		}
	} else if (pMethod == "saveVocProgressStatePop") {
		if (sMsg == "OK") {
			alert("정상적으로 저장 완료되었습니다.");
			document.location.href = "/mpvo/getMasterMpVoVocProgressStatePop.do?st_buyer=<%=st_buyer%>&st_vc_no=<%=st_vc_no%>&st_claim_master=<%=st_claim_master%>";
			return;
		} else {
			alert("Feedback 처리하던중 오류가 발생하였습니다.");
			parent.opener.doAction("search");
			parent.close();
			return;
		}
	} else if (pMethod == "saveVocProgressStatePop2") {
		if (sMsg == "OK") {
			alert("정상적으로 제출 완료되었습니다.");
			document.location.href = "/mpvo/getMasterMpVoVocProgressStatePop.do?st_buyer=<%=st_buyer%>&st_vc_no=<%=st_vc_no%>&st_claim_master=<%=st_claim_master%>";
			return;
		} else {
			alert("VOC 제출 처리하던중 오류가 발생하였습니다.");
			parent.opener.doAction("search");
			parent.close();
			return;
		}
	} else if (pMethod == "saveVocReReq") {
		if (sMsg == "OK") {
			alert("정상적으로 재요청 완료되었습니다.");
			document.location.href = "/mpvo/getMasterMpVoVocProgressStatePop.do?st_buyer=<%=st_buyer%>&st_vc_no=<%=st_vc_no%>&st_claim_master=<%=st_claim_master%>";
			return;
		} else {
			alert("재요청 처리하던중 오류가 발생하였습니다.");
			parent.opener.doAction("search");
			parent.close();
			return;
		}
	} 
}
function kepAjaxSuccess(pMethod, response){
	var voc_user_id = "<%=user_id%>";
	
	if (pMethod == "select"){
		if(response.USER_ID != '0'){
			voc_user_id = response.USER_ID;
		}else{ // 담당자가 없을 시 다시 자신의 id로
			voc_user_id = "<%=user_id%>";
		}
		// 담당자로 selectbox 선택된 값 변경
		$("#st_ds_user_id_2 option[value*="+voc_user_id+"]").prop("selected", true);
	}
}
/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxPopError(pMethod , response) {
	var sMsg = response.msg;
	alert(sMsg);
	parent.opener.doAction("search");
	parent.close();
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var sMsg = response.msg;
	alert(sMsg);
	parent.opener.doAction("search");
	parent.close();
}

//인쇄
function setReportPrint(){
     window.focus();
     window.print();
}

//클레임 구분값 변경
function changeClaimKindVal(){
	var st_claim_type_info = $("#st_claim_type_info").val();
	var st_claim_type_info2 = st_claim_type_info.split("@@", -1);
    
    var claim_type = st_claim_type_info2[0];
    var claim_kind = st_claim_type_info2[1];

    $("#st_claim_type").val(claim_type);
    $("#st_claim_kind").val(claim_kind);

	initClaimGrade(claim_kind);
	
	var data = { st_type : $("#st_claim_type").val(), st_buyer_code : $("#st_buyer").val(), st_buyer_item_no :'<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")," ")%>'};
	//voc 유형 소분류
	kepAjaxCallNoBar("/common/getVOCUser.do", data, "select");

}

// 클레임 등급 disabled 세팅
function initClaimGrade(claim_kind){
	if(claim_kind == "S"){
		$("#st_claim_grade").attr("disabled",true);
	}else{
		$("#st_claim_grade").attr("disabled",false);
	}
}

// 초기화 및 상태 확인
function checkRecvFlag(){
	kepAjaxCommonQueryIdCombo('st_ds_user_id_2','getDeptSelectkorea','','<%=CommonUtil.nvl(rowData.get("DS_USER_ID"), user_id) + "@@" + CommonUtil.nvl(rowData.get("DS_USER_NAME"), user_name) + "@@" + CommonUtil.nvl(rowData.get("DS_DEPT"), user_dept)%>');

<%
	// 클레임 하위 분류가 선택되지 않은 경우 클레임 상위, 하위 분류 수정 가능
	if("".equals(rowData.get("CLAIM_TYPE"))){ 
%>
	// 콤보 생성 ( VOC Master )
	kepAjaxCommonComboDataValue("st_claim_master","VC03","SEL","<%=CommonUtil.nvl(rowData.get("CLAIM_MASTER"))%>");
	kepAjaxCommonQueryIdSearchTwoCombo("st_claim_type_info","commonVocClaimTypeList", "VC01", "<%=CommonUtil.nvl(rowData.get("CLAIM_MASTER"))%>", "SEL", "");
	
	// VOC Type 선택 시 이벤트 발생
	$("#st_claim_master").change(function(){
		// 콤보 생성 ( VOC Type )
		kepAjaxCommonQueryIdSearchTwoCombo("st_claim_type_info","commonVocClaimTypeList", "VC01", $(this).val(), "SEL", "");
	});
	
<%
	}
%>
	
	var recv_flag = "<%=rowData.get("RECV_FLAG")%>";

	if(recv_flag == "FB"){
		alert("이미 F/B 처리되어 수정이 불가능 합니다.\n\n다시 조회하여 확인하시기 바랍니다.");
		parent.opener.doAction("search");
		parent.close();
	}
	
	initClaimGrade("<%=CommonUtil.nvl(rowData.get("CLAIM_KIND"))%>");
}

//업체지정값 제거
function clearAgent(obj){
	if(obj.checked){
		document.forms[0].st_agent_name.value = "";
		document.forms[0].st_agent_code.value = "";
	}
}
 //-->
</script> 
<body onload="checkRecvFlag();">
	<form name="masterMpVoVocProgressStatePop" id="masterMpVoVocProgressStatePop" method="post" >
		<input type="hidden" id="tmp_company" name="tmp_company" value="">
		<input type="hidden" id="st_remark_cnt" name="st_remark_cnt"	value="<%=remark_cnt %>">
		<input type="hidden" id="st_recv_flag" name="st_recv_flag"	value="">
		<input type="hidden" id="st_buyer" name="st_buyer"		value="<%=st_buyer%>">
		<input type="hidden" id="st_vc_no" name="st_vc_no"		value="<%=st_vc_no%>">
		<input type="hidden" id="st_req_date" name="st_req_date"		value="<%=st_req_date%>">
		<input type="hidden" id="st_user_id" name="st_user_id"		value="<%=user_id%>">
		<input type="hidden" id="st_user_dept" name="st_user_dept"		value="<%=user_dept%>">
		<input type="hidden" id="st_ds_date" name="st_ds_date"		value="<%=st_ds_date%>">
	
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div id="popWrapper" style="height:600px;">
			<div id="popHeader">
				<h1 class="title">VOC 진행현황</h1>
				<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
			</div>
			
			<!--팝업내용입니다-->
			<div id="popContainer">
<%
	if(_dataList == null || _dataList.size() <= 0){
%>
				<table class="cont_t_list06 mb15" summary="VOC 진행현황" style="width:100%;">
					<caption>VOC 진행현황</caption>
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="30%" />
					</colgroup>
					
					<tbody>
						<tr>
							<td colspan="4" class="center"><font color="blue"><b>조회 된 데이터가 없습니다.</b></font></td>
						</tr>
					</tbody>
				</table>
<%
	}else{
%>
				<table  class="cont_t_list06 mb15" summary="VOC 진행현황" style="width:100%;">
					<caption>VOC 진행현황</caption>
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="30%" />
					</colgroup>
					
					<tbody>
						<tr>
							<th scope="row">접수번호</th>
							<td colspan="3">
								<font color="blue"><b><%=CommonUtil.nvl(rowData.get("VC_NO"))%></b></font>
							</td>
						</tr>
						<tr>
							<th scope="row">고객사</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>&nbsp;<%=CommonUtil.nvl(rowData.get("MRO_AREA_TEXT"))%>
							</td>
							<th scope="row">요청자</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("REQ_USER_NAME"))%>&nbsp;(<%=CommonUtil.nvl(rowData.get("REQ_USER_TEL"))%>)
							</td>
						</tr>
						<tr>
							<th scope="row">접수자</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("CD_USER_NAME"))%>
							</td>
							<th scope="row">처리자</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("DS_USER_NAME"))%>&nbsp;=>
								<select id="st_ds_user_id_2" name="st_ds_user_id_2"></select>
								<input type="hidden" id="st_ds_user_id_1" name="st_ds_user_id_1"   value="<%=rowData.get("DS_USER_ID")%>">
								<input type="hidden" id="st_ds_user_nm_1" name="st_ds_user_nm_1"   value="<%=rowData.get("DS_USER_NAME")%>">
								<input type="hidden" id="st_ds_user_nm_2" name="st_ds_user_nm_2"   value="">
								<input type="hidden" id="st_req_user_id" name="st_req_user_id"    value="<%=rowData.get("REQ_USER_ID")%>">
								<input type="hidden" id="st_ds_change_flag" name="st_ds_change_flag" value="">
								<input type="hidden" id="st_ds_change_date" name="st_ds_change_date" value="">
								<input type="hidden" id="st_ds_user_id" name="st_ds_user_id"     value="<%=rowData.get("DS_USER_ID")%>">
								<input type="hidden" id="st_ds_dept_id" name="st_ds_dept_id"     value="<%=rowData.get("DS_DEPT")%>">
								<input type="hidden" id="st_impute_type" name="st_impute_type"    value="">
								<input type="hidden" id="st_ds_dept_id_1" name="st_ds_dept_id_1"   value="<%=rowData.get("DS_DEPT")%>">
								<input type="hidden" id="st_catalog_com_code" name="st_catalog_com_code"   value="<%=rowData.get("BYCA_COMORG_CODE")%>">
								<input type="hidden" id="st_revision" name="st_revision"   value="<%=rowData.get("REVISION")%>">
								<input type="hidden" id="st_po_no" name="st_po_no"   value="<%=rowData.get("PO_NO")%>">
			            		<input type="hidden" id="st_buyer_item_no" name="st_buyer_item_no"   value="<%=rowData.get("BUYER_ITEM_NO")%>">
					            <input type="hidden" id="st_asis_ds_user_id" name="st_asis_ds_user_id"   value="">
								<input type="hidden" id="st_cd_user_id" name="st_cd_user_id"     value="<%=rowData.get("CD_USER_ID")%>">
							</td>
						</tr>
				<% if("DC".equals(CommonUtil.nvl(rowData.get("RECV_FLAG")))){ %>
						<tr>
							<th scope="row">발주번호</th>
							<td>
								<a class="hyperLink" href="javascript:doPop('masterpoDetailPop')"><%=CommonUtil.nvl(rowData.get("PO_NO"))%></a>
							</td>
							<th scope="row">발주번호 변경</th>
							<td>
								<input type="text" class="input_type_text" name="st_target_po_no" id="st_target_po_no" value="<%=rowData.get("PO_NO")%>" style="width:50%">
							</td>
						</tr>
						<tr>
							<th scope="row">품목코드</th>
							<td>
								<a class="hyperLink" href="javascript:doPop('masterMdCmBuyerCatalogAlterPop')"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></a>
							</td>
							<th scope="row">품목코드 변경</th>
							<td>
								<input type="text" class="input_type_text" name="st_target_buyer_item_no" id="st_target_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>" style="width:50%">
							</td>
						</tr>
						<tr>
							<th scope="row">요청일자</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("REQ_DATE"))%> <%=CommonUtil.nvl(rowData.get("REQ_TIME"))%>
							</td>
							<th scope="row">접수일자</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("CD_DATE"))%> <%=CommonUtil.nvl(rowData.get("CD_TIME"))%>
							</td>
						</tr>
				<% } else { %>
						<tr>
							<th scope="row">발주번호</th>
							<td>
								<input type="hidden" name="st_target_po_no" id="st_target_po_no" value="<%=rowData.get("PO_NO")%>">
								<a class="hyperLink" href="javascript:doPop('masterpoDetailPop')"><%=CommonUtil.nvl(rowData.get("PO_NO"))%></a>
							</td>
							<th scope="row">접수일자</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("CD_DATE"))%> <%=CommonUtil.nvl(rowData.get("CD_TIME"))%>
							</td>
						</tr>
						<tr>
							<th scope="row">품목코드</th>
							<td>
								<input type="hidden" name="st_target_buyer_item_no" id="st_target_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>">
								<a class="hyperLink" href="javascript:doPop('masterMdCmBuyerCatalogAlterPop')"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></a>
							</td>
							<th scope="row">요청일자</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("REQ_DATE"))%> <%=CommonUtil.nvl(rowData.get("REQ_TIME"))%>
							</td>
						</tr>
				<% } %>
						<tr>
							<th scope="row">회신요청일시</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("PH_DATE"))%>
							</td>
							<th scope="row">상태</th>
							<td>
								<%=CommonUtil.nvl(rowData.get("RECV_FLAG_TEXT"))%>
							</td>
						</tr>
						<tr>
							<th scope="row">VOC Type</th>
							<td scope="row" colspan="3">
					<%
						// 클레임 하위 분류가 선택되지 않은 경우 클레임 상위, 하위 분류 수정 가능
						if(rowData.get("CLAIM_TYPE").equals("")){
					%>
							<select id="st_claim_master" name="st_claim_master"></select>&nbsp;>&nbsp;
							<select id="st_claim_type_info" name="st_claim_type_info" onchange="changeClaimKindVal();">
								<option value="" >선택</option>
							</select>
							<input type="hidden" id="st_claim_type" name="st_claim_type"  value="">
							<input type="hidden" id="st_claim_kind" name="st_claim_kind"  value="">
					<%
						} else {
					%>
							<%=CommonUtil.nvl(rowData.get("CLAIM_MASTER_TEXT"))%>&nbsp;>&nbsp;<%=CommonUtil.nvl(rowData.get("CLAIM_TEXT"))%>
							<input type="hidden" id="st_claim_master" name="st_claim_master"  value="<%=rowData.get("CLAIM_MASTER")%>">
							<input type="hidden" id="st_claim_type" name="st_claim_type"  value="<%=rowData.get("CLAIM_TYPE")%>">
							<input type="hidden" id="st_claim_kind" name="st_claim_kind"  value="<%=rowData.get("CLAIM_KIND")%>">
					<%
						}
					%>
							</td>
						</tr>
					</tbody>
				</table>
				
				<div class="btnArea" style="margin-top: 5px;">
					<span class="fr">
						<!--span class="btn_02"><a href="javascript:;setReportPrint()" >인쇄</a></span-->
						<span class="btn_02">
							<a href="javascript:;doAction('setDSUserChange')" >담당이관</a>
						</span>
					</span>
				</div>
				
				<div class="scrollArea" style="height:380px">
					<table  class="cont_t_list06 mb15" style="width:100%;">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="30%" />
						</colgroup>
					<tbody>
						<tr>
							<th scope="row">SRM연계 협력사귀책</th>
							<td colspan="3">
								<input type="radio" name="st_impute_flag" value="SS" <%if("SS".equals(rowData.get("IMPUTE_TYPE"))){out.print("checked");}%>> 협력사&nbsp;
								<input type="radio" name="st_impute_flag" value="MS" <%if("MS".equals(rowData.get("IMPUTE_TYPE"))){out.print("checked");}%>> KeP/협력사&nbsp;
								<input type="radio" name="st_impute_flag" value="MM" <%if("MM".equals(rowData.get("IMPUTE_TYPE"))){out.print("checked");}%> onclick="clearAgent(this);"> KeP&nbsp;
								<input type="radio" name="st_impute_flag" value="ET" <%if("ET".equals(rowData.get("IMPUTE_TYPE"))){out.print("checked");}%> onclick="clearAgent(this);"> 기타&nbsp;
							</td>
						</tr>
						<tr>
							<th scope="row">업체지정</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" value="<%=rowData.get("AGENT_NAME")%>" style="width:70%" readonly onclick="javascript:doPop('masterCmCoBuyerAgntcmpyPop');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:70%" value="<%=rowData.get("IMPUTE_AGENT")%>">
								<a href="javascript:doPop('masterCmCoBuyerAgntcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_name','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th scope="row">클레임등급</th>
							<td>
								<select id="st_claim_grade" name="st_claim_grade">
									<option value="" > --- </option>
									<option <%=("상".equals(rowData.get("CLAIM_GRADE")) ? "selected" : "")%> value="상">상 (Level3)</option>
									<option <%=("중".equals(rowData.get("CLAIM_GRADE")) ? "selected" : "")%> value="중">중 (Level2)</option>
									<option <%=("하".equals(rowData.get("CLAIM_GRADE")) ? "selected" : "")%> value="하">하 (Level1)</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">요청 첨부파일</th>
							<td colspan="3">
								<input type="hidden" id="st_image_key1" name="st_image_key1" value="<%=CommonUtil.nvl(rowData.get("REQ_IMAGE_KEY"))%>" />
						<%
							if(!CommonUtil.nvl(rowData.get("REQ_IMAGE_KEY")).equals("")) {
						%>
								<a class="hyperLink" href="javascript:doPop('req_attach', 'R')">
									<img name="st_req_image_key_img" src="/resources/images/disk_on.gif" style="margin-top:2px" border="0">
								</a>
						<%
							} else {
						%>
								<img name="st_req_image_key_img" id="st_req_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:2px" border="0">
						<%
							}
						%>
							</td>
						</tr>
						<tr>
							<th scope="row">요청사항</th>
							<td colspan="3" style="height:100px;">
								<textarea rows="6" cols="70" id="st_req_remark" name="st_req_remark" style="text-align:left;width:98%;" readonly ><%=CommonUtil.nvl(rowData.get("REQ_REMARK"))%></textarea>
							</td>
						</tr>
				<%
					if("PS".equals(CommonUtil.nvl(rowData.get("RECV_FLAG")))) {
				%>
						<tr>
							<th scope="row">처리자 첨부파일</th>
							<td colspan="3">
								<input type="hidden" id="st_image_key2" name="st_image_key2" value="<%=CommonUtil.nvl(rowData.get("DS_IMAGE_KEY"))%>" />
					<%
						if(!CommonUtil.nvl(rowData.get("DS_IMAGE_KEY")).equals("")) {
					%>
								<a class="hyperLink" href="javascript:doPop('ds_attach', '')">
									<img name="st_ds_image_key_img" id="st_ds_image_key_img" src="/resources/images/disk_on.gif" style="margin-top:2px" border="0">
								</a>
					<%
						} else {
					%>
								<a class="hyperLink" href="javascript:doPop('ds_attach', '')">
									<img name="st_ds_image_key_img" id="st_ds_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:2px" border="0">
								</a>
					<%
						}
					%>
							</td>
						</tr>
						<tr>
							<th scope="row">처리자 진행내역&nbsp;&nbsp;</th>
							<td id="td_df_remark" colspan="3" style="height:100px;">
								<input type="hidden" id="st_ds_remark" name="st_ds_remark" value="">
								<input type="hidden" id="st_ds_remark_2" name="st_ds_remark_2" value="">
								<input type="hidden" id="st_ds_remark_3" name="st_ds_remark_3" value="">
								
								<textarea rows="6" cols="70" id="st_ds_remark_1" name="st_ds_remark_1" style="text-align:left;width:98%;"><%=CommonUtil.nvl(rowData.get("DS_REMARK_A"))%></textarea>
							</td>
						</tr>
				<%
					}
					if("PA".equals(CommonUtil.nvl(rowData.get("RECV_FLAG")))){
				%>
						<tr>
							<th scope="row">처리자 첨부파일</th>
							<td colspan="3">
								<input type="hidden" id="st_image_key2" name="st_image_key2" value="<%=CommonUtil.nvl(rowData.get("DS_IMAGE_KEY"))%>" />
						<%
							if(!CommonUtil.nvl(rowData.get("DS_IMAGE_KEY")).equals("")) {
						%>
								<a class="hyperLink" href="javascript:doPop('ds_attach', 'R')">
									<img name="st_ds_image_key_img" id="st_ds_image_key_img" src="/resources/images/disk_on.gif" style="margin-top:2px" border="0">
								</a>
						<%
							} else {
						%>
								<img name="st_ds_image_key_img" id="st_ds_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:2px" border="0">
						<%
							}
						%>
							</td>
						</tr>
						<tr>
							<th scope="row">처리자 진행내역&nbsp;&nbsp;</th>
							<td id="td_df_remark" colspan="3" style="height:100px;">
								<input type="hidden" id="st_ds_remark" name="st_ds_remark" value="">
								<input type="hidden" id="st_ds_remark_2" name="st_ds_remark_2" value="">
								<input type="hidden" id="st_ds_remark_3" name="st_ds_remark_3" value="">
								<textarea rows="6" cols="70" id="st_ds_remark_1" name="st_ds_remark_1" style="text-align:left;width:98%;" readonly><%=CommonUtil.nvl(rowData.get("DS_REMARK_A"))%></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">재요청 사유</th>
							<td colspan="3" style="height:70px;">
								<textarea rows="4" cols="70" id="st_re_req_note" name="st_re_req_note" style="text-align:left;width:98%;"></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">회신용 첨부파일</th>
							<td colspan="3">
								<input type="hidden" id="st_image_key3" name="st_image_key3" value="<%=CommonUtil.nvl(rowData.get("FEEDBACK_IMAGE_KEY"))%>" />
						<%
							if(!CommonUtil.nvl(rowData.get("FEEDBACK_IMAGE_KEY")).equals("")) {
						%>
								<a class="hyperLink" href="javascript:doPop('feedback_attach', '')">
									<img name="st_feedback_image_key_img" id="st_feedback_image_key_img" src="/resources/images/disk_on.gif" style="margin-top:2px" border="0">
								</a>
						<%
							} else {
						%>
								<a class="hyperLink" href="javascript:doPop('feedback_attach', '')">
									<img name="st_feedback_image_key_img" id="st_feedback_image_key_img" src="/resources/images/disk_off.gif" style="margin-top:2px" border="0">
								</a>
						<%
							}
						%>
							&emsp;※ 고객사에게 전달될 파일이므로 DRM에 유의하세요.
							</td>
						</tr>
						<tr>
							<th scope="row">고객사 회신내용</th>
							<td colspan="3" style="height:100px;">
								<textarea rows="6" cols="70" id="st_df_remark" name="st_df_remark" style="text-align:left;width:98%;" ><%=CommonUtil.nvl(rowData.get("DF_REMARK"))%></textarea>
							</td>
						</tr>
						<tr>
							<th scope="row">고객사 메일전송</th>
							<td colspan="3">
								<input type="checkbox"  id ="mail_send_flag" name="mail_send_flag">
								<input type= "hidden"  id ="st_mail_send_flag" name="st_mail_send_flag" value= "Y">
							</td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
	
	<div class="btnArea" style="margin-top: 10px;">
		<span class="fr">
		<% if("DC".equals(CommonUtil.nvl(rowData.get("RECV_FLAG")))){ %>
			<span class="btn_02"><a href="javascript:doAction('saveVocProgressStatePop','B');" >저장</a></span>
			<span class="btn_02"><a href="javascript:doAction('saveVocProgressStatePop','A');" >접수</a></span>
		<%} if("PS".equals(CommonUtil.nvl(rowData.get("RECV_FLAG")))){ %>
			<span class="btn_02"><a href="javascript:doAction('saveVocProgressStatePop2','B');" >저장</a></span>
			<span class="btn_02"><a href="javascript:doAction('saveVocProgressStatePop2','A');" >제출</a></span>
		<%} if("PA".equals(CommonUtil.nvl(rowData.get("RECV_FLAG")))){ %>
			<span class="btn_02"><a href="javascript:doAction('saveVocReReq');" >재요청</a></span>
			<span class="btn_02"><a href="javascript:doAction('setFinishSave');" >Feedback</a></span>
		<%} %>
		</span>
	</div>
<%
	}
%>
</div>
</div>
</form>
</body>
</html>
