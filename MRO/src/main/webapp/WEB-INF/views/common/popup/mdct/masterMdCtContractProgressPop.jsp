<%--
**********************************************
* 메뉴 : 회원사관리>계약관리>계약진행조회 
* 화면 : 계약진행조회 
* 기능 : 계약서 상세조회
* 프로그램 ID : PG_02_M_003_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-31
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _rowData = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 

String businessCond = (String)_sessionInfo.getBusinessCond();
String st_cont_no = CommonUtil.nvl((String) request.getParameter("st_cont_no"),"");  //  (조회조건)
String st_cont_count = CommonUtil.nvl((String) request.getParameter("st_cont_count"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
var popupSel = "";
var st;
var mt;

// 기능함수
function doAction(str) {
	st = new Date();

	// 선택된 항목 유무 체크
	switch (str) {
		case "contWithdraw":		// 회수
		case "contRevoke":			// 취소
		case "contCancel":			// 계약해지
		case "contReject":			// 반려
			kepAjaxFormCall("/mdct/saveMasterMdCtContractProgressPopReason.do","masterMdCtContractProgressPop", str);
			break;
		case "signMaster":	// 초기화
			if (doSignMaster()) {
				kepAjaxFormCall("/mdct/saveMasterMdCtContractProgressPopMaster.do","masterMdCtContractProgressPop", str);
			}
			break;
		case "signMasterOS2":	// 초기화
			kepAjaxFormCall("/mdct/saveMasterMdCtContractProgressPopMaster.do","masterMdCtContractProgressPop", str);
			break;	
		case "signVendor":	// 초기화
			if (singnData()) {
				kepAjaxFormCall("/mdct/getMasterMdCtContractProgressPopCertValidate.do","masterMdCtContractProgressPop", str);
			}
			break;
		case "vendorSigned" :
			if (doSignVendor()) {
				kepAjaxFormCall("/mdct/saveMasterMdCtContractProgressPopVendor.do","masterMdCtContractProgressPop", str);
			}
			break;
		case "print":
			 window.print();
			 break;
	}
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "contCancel":			// 계약해지
		case "contChange":			// 계약변경
		case "contClose":			// 계약변경
		case "contWithdraw":		// 회수
		case "contRevoke":			// 취소
		case "contReject":			// 반려
			if (contReason(str)) {
				openSearchPopup("/mdct/showMasterMdCtContractCancleRegPop.do", "?mode=" + str, "500,250,no");
			}	
			break;
		case "constractMod": // 고객사 M
			setReturn("constractMod", $("#st_cont_no").val(), $("#st_cont_count").val());
			break;
		case "contChg":
			if (confirm("해당 계약건을 연장하시겠습니까?")) {
				setReturn("contChg", "E");
			}
			break;
		case "contModify":
			if (confirm("해당 계약건의 내용을 변경하시겠습니까?")) {
				setReturn("contModify", "M");
			}
			break;	
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "contWithdraw" || pMethod == "contRevoke" || pMethod == "contReject" || pMethod == "contCancel") {
		var msg = "";
		if (pMethod == "contWithdraw") {
			msg = "회수";
		} else if (pMethod == "contRevoke") {
			msg = "취소";
		} else if (pMethod == "contReject") {	
			msg = "반려";
		} else if (pMethod == "contReject") {	
			msg = "반려";
		} else if (pMethod == "contCancel") {	
			msg = "해지";
		}
		
		if (sMsg == 'OK') {
			alert("계약서 " + msg + "가 정상적으로 완료되었습니다.");
			setReturn("OK");
		} else if (sMsg == "ERR") {
			alert("계약서 " + msg + "에 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		}
	} else if (pMethod == "signVendor") {
		doAction("vendorSigned");		
		
		if ("0000" != response.data.errorCode) {
			alert("유효하지 않은 인증서입니다.\n"+response.data.errorMsg);
			return;
		} else { 
			//인증성공
			doAction("vendorSigned");
		}
		
	} else if (pMethod == "vendorSigned" || pMethod == "signMaster" || pMethod == "signMasterOS2" || pMethod == "contClose" || pMethod == "contChange") {
		if (sMsg == 'OK') {
			alert("전자서명 하였습니다.");
			setReturn("OK");
		} else if (sMsg == "ERR") {
			alert("전자서명에 실패 하였습니다.\n다시 확인하여 주십시요!");
            return;
		} else if (sMsg == "cert") {
			alert("인증서 검증 중 오류 발생하였습니다.");
            return;
		}
	}
}

function  kepAjaxError(pMethod , response) {
	if (pMethod == "signVendor") { 
		alert("인증서 검증 중 오류 발생하였습니다.");
		return;
	} else {
		alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "contWithdraw" || popupSel == "contRevoke" || popupSel == "contCancel" || popupSel == "contReject") {
		$("#st_mode").val(popupSel);
		$("#st_reason").val(value1);
		doAction(popupSel);
	} else if (popupSel == "contRevokeOS2" || popupSel == "contClose") {
		$("#st_mode").val(popupSel);
		$("#st_reason").val(value1);
		doAction("signMasterOS2");
	} else if (popupSel == "contClose" || popupSel == "contChange") {
		$("#st_mode").val(popupSel);
		$("#st_reason").val(value1);
		doAction("signMasterOS2");
	} 
}

function setReturn(value1, value2, value3) { 
	opener.setPopupReturn(value1,value2,value3);
	this.close();
}

function contReason(str) {
	var msg = "";
	if (str == "contWithdraw") {
		msg = "회수";
	} else if (str == "contRevoke") {
		msg = "취소";
	} else if (str == "contReject") {	
		msg = "반려";
	} else if (str == "contCancel") {	
		msg = "해지";

		if (parseInt(kepGetNowTimeStr("YYYYMMDD", "")) > parseInt($("#st_end_date").val())) {
			alert("이미 계약종료일이 지났습니다.");
			return false;
		}
	} else if (str == "contRevokeOS2" || str == "contClose" || str == "contChange") {
		return true;
	}

	return confirm("해당 계약건을 " + msg + "하시겠습니까?");
}

function doSignMaster() {
	if ($("#st_cont_status").val() == "OS2") {
		signType = "[취소서명]";
	} else if ($("#st_cont_status").val() == "OS1") {
		signType = "[계약서명]";
	}
	
	var conf = confirm(signType + " 계약서에 서명하시겠습니까?");
	if (conf) {
		$("#st_mode").val('signedMaster');
		$("#st_doc_type").val('A');
		$("#st_sign_source").val(document.getElementById('contentDiv').innerHTML);
	}
	if (conf && "OS2" != $("#st_cont_status").val() && ("R" == $("#st_cont_chg_type").val() || "M" == $("#st_cont_chg_type").val())) {
		var beforeEndDate = $("#st_before_end_date").val();

		if (parseInt(kepGetNowTimeStr("YYYYMMDD", "")) <= parseInt(beforeEndDate)) {
			alert("이전 차수 계약을 종료처리 합니다.\n계약종료사유를 입력하여 주세요.");
			doPop("contChange");
			return false;
		}
	}
	/* else if (conf && "OS2" == $("#st_cont_status").val()) {
		alert("계약을 취소처리 합니다.\n계약취소사유를 입력하여 주세요.");
		doPop("contRevokeOS2");
		return false;	
	}
	*/
	return conf;
}

function singnData() {
	var signedData = "";

	init();
	
	userdn = document.CC_Object_id.GetUserDN();
	if (userdn == null || userdn == "" ) { 
		return false;
	} else {
		signedData = document.CC_Object_id.SignData(document.getElementById('contentDiv').innerHTML, "SHA1", "");
		$("#st_sign_value").val(signedData);

		if (signedData == null || signedData == "" ) {
			errmsg = document.CC_Object_id.GetErrorContent();
			errcode = document.CC_Object_id.GetErrorCode();
			alert( "SignData :"+errmsg );
			return false;
		} else {
			getR = document.CC_Object_id.GetRFromKey(userdn, "");
			if (getR == "") {
				alert("주민번호/사업자번호를 확인할 수 없는 인증서입니다.");
				return false;
			}
			$("#getR").val(getR);
		}
	}
	return true;
}

function doSignVendor() {
	var signType = "";
	
	if ($("#st_cont_status").val() == "CS2") {
		signType = "[취소서명]";
	} else if ($("#st_cont_status").val() == "CS1") {
		signType = "[계약서명]";
	}
	
	var conf = confirm(signType + " 계약서에 서명하시겠습니까?");
	
	if (conf) {
		$("#st_mode").val('signedVendor');
		$("#st_doc_type").val("A");
		$("#st_sign_source").val(document.getElementById('contentDiv').innerHTML);
	}
	
	return conf;
}

function init() {
	var Ret;
	var policies = "";
	
	 if (document.CC_Object_id.object == null) {
    	 window.open( "/module/crosscert/ccc-sample/Object_chk.html" ,"BicImage","width=600,height=470,toolbar=no,location=no,resizable=yes,menubar=no,status=no,scrollbars=yes");
    	 return;
     }
	 
	// 법인상호연동용(범용)
	policies +="1.2.410.200004.5.2.1.1"	+ "|";								// 한국정보인증				법인
	policies +="1.2.410.200004.5.1.1.7"	+ "|";								// 한국증권전산				법인, 단체, 개인사업자
	policies +="1.2.410.200005.1.1.5"		+ "|";								// 금융결제원				법인, 임의단체, 개인사업자
	policies +="1.2.410.200004.5.3.1.1"	+ "|";								// 한국전산원				기관(국가기관 및 비영리기관)
	policies +="1.2.410.200004.5.3.1.2"	+ "|";								// 한국전산원				법인(국가기관 및 비영리기관을  제외한 공공기관, 법인)
	policies +="1.2.410.200004.5.4.1.2"	+ "|";								// 한국전자인증				법인, 단체, 개인사업자
	policies +="1.2.410.200004.5.4.1.201"	+ "|";								// 한국전자인증				전자인증 법인 인터텟뱅킹용
	policies +="1.2.410.200012.1.1.3"		+ "|";								// 한국무역정보통신			법인  
	policies +="1.2.410.200004.5.4.2.26"	+ "|";								// 한국전자인증				특정용 세무조사법  

	// 법인 인터넷뱅킹용 인증서(OID)
	policies +="1.2.410.200005.1.1.2"		+ "|";								// 금융결제원				법인 인터넷뱅킹용

	policies +="1.2.410.200004.5.4.1.200"	+ "|";
	policies +="1.2.410.200004.5.4.2.31"	+ "|";								// S-OIL
	policies +="1.2.410.100001.2.2.1"		+ "|";								// GPKI 인증서
	policies +="1.2.410.200004.5.4.2.406"	+ "|";								// kep9900원짜리 전용
	
	Ret =  document.CC_Object_id.SetCommonInfoFromVal("211.192.169.70",4502, 	"211.192.169.180", 389, "211.192.169.180", 389, "CN=ROOT-RSA-CRL,OU=ROOTCA,O=KISA,C=KR", "no", 	policies);
	if ( Ret != 0 ) { 
		alert( "인증 초기 설정에 실패하였습니다." );
		return false;
	} else {
		Ret =  document.CC_Object_id.SetPKCSInform(1, 0, 0, 0, 0, 0, 0, 1, "SEED");
		if ( Ret != 0 ) { 
			alert( "인증 초기 설정에 실패하였습니다." );
			return false;
		} else 	{
			return true;
		}
	}	
}
//-->
</script> 
<body onload="">
<form name="masterMdCtContractProgressPop" id="masterMdCtContractProgressPop" method="post" >
<input type="hidden" name="st_cont_no" id="st_cont_no"  value="<%=st_cont_no%>" />
<input type=hidden name="st_cont_count" id="st_cont_count"  value="<%=st_cont_count%>" />
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}" />
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}" />
<input type=hidden name="st_reason" id="st_reason"  value="" />
<input type=hidden name="st_mode" id="st_mode"  value="" />
<input type=hidden name="st_doc_type" id="st_doc_type"  value="" />
<input type=hidden name="st_sign_source" id="st_sign_source"  value="" />
<input type=hidden name="st_sign_value" id="st_sign_value"  value="" />
<input type="hidden" name="signedDataTemp" id="signedDataTemp" value="" />
<input type="hidden" name="getR" id="getR" value="" />

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
    	<div id="popHeader">
        	<h1 class="title">계약서 상세 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <% if (_rowData != null) {  %>
            <input type="hidden" id="st_irs_no" name="st_irs_no" value="<%=CommonUtil.nvl(_rowData.get("IRS_NO"))%>" />
            <input type="hidden" id="st_form_no" name="st_form_no" value="<%=CommonUtil.nvl(_rowData.get("FORM_NO"))%>" />
           	<input type="hidden" id="st_company_code" name="st_company_code" value="<%=CommonUtil.nvl(_rowData.get("COMPANY_CODE"))%>" />
           	<input type="hidden" id="st_company_type" name="st_company_type" value="<%=CommonUtil.nvl(_rowData.get("COMPANY_TYPE"))%>" />
           	<input type="hidden" id="st_biz_type" name="st_biz_type" value="<%=CommonUtil.nvl(_rowData.get("BIZ_TYPE"))%>" />
           	<input type="hidden" id="st_cont_status" name="st_cont_status" value="<%=CommonUtil.nvl(_rowData.get("CONT_STATUS"))%>" />
           	<input type="hidden" id="st_cont_chg_type" name="st_cont_chg_type" value="<%=CommonUtil.nvl(_rowData.get("CONT_CHG_TYPE"))%>" />
           	<input type="hidden" id="st_end_date" name="st_end_date" value="<%=CommonUtil.nvl(_rowData.get("END_DATE"))%>" />
           	<input type="hidden" id="st_before_end_date" name="st_before_end_date" value="<%=CommonUtil.nvl(_rowData.get("BEFORE_END_DATE"))%>" />
           	<input type="hidden" id="st_before_cont_count" name="st_before_cont_count" value="<%=CommonUtil.nvl(_rowData.get("BEFORE_CONT_COUNT"))%>" />
           	<input type="hidden" id="st_atach_uuid" name="st_atach_uuid" value="<%=CommonUtil.nvl(_rowData.get("ATACH_UUID"))%>" />
           	
            <div class="contArea" style="height:590px">
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>계약서 상세</caption>
	                <colgroup>
	                    <col width="12%" />
	                    <col width="30%" />
	                    <col width="12%" />
	                    <col width="*" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">계약번호</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("CONT_NO"))%>-<%=CommonUtil.nvl(_rowData.get("CONT_COUNT"))%></td>
	                        <th scope="row">계약명</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("CONT_TITLE"))%></td>
					</tbody>
				</table>
				<%
				String height = "";
				if ("END".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) {
					height	 = "395px";
				} else {
					height	 = "465px";
				}
				%>
				<div id="contentDiv" class="scrollArea mb10" style="text-align:left;height:<%=height%>; padding:10px;"><%=CommonUtil.nvl(_rowData.get("CONTENT"))%></div>
				<% if ("END".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) { %>
				<div class="mt05 pl10"  style="height:46px;border:1px solid #5e799d;">
               			<% if ("C001".equals(CommonUtil.nvl(_rowData.get("BIZ_TYPE")))) { %>
							<p style="height:13px"><font size="1px" color="black">Copyright ⓒ 2014 by KOREA E PLATFORM CO.,LTD. ALL RIGHTS RESERVED.</font></p>
							<p style="height:13px"><font size="1px" color="black">(주)코리아이플랫폼과 <%=CommonUtil.nvl(_rowData.get("COMPANY_NAME")) %> 협력사 간의 본 전자계약서에 포함된 정보나 자료는 (주)코리아이플랫폼의 허가 없이 다른 목적으로 사용할 수 없습니다.</font></p>
							<p style="height:13px"><font size="1px" color="black">본 전자계약서는 (주)코리아이플랫폼 전자구매시스템(http://www.koreab2b.co.kr)에서 전자서명(공인인증)으로 체결된 계약서임을 확인합니다.</font></p>
               			<% } else if ("C002".equals(CommonUtil.nvl(_rowData.get("BIZ_TYPE")))) { %>
							<p style="height:13px"><font size="1px" color="darkgray">Copyright ⓒ 2014 by KOREA E PLATFORM CO.,LTD. ALL RIGHTS RESERVED.</font></p>
							<p style="height:13px"><font size="1px" color="darkgray">(주)코리아이플랫폼과  <%=CommonUtil.nvl(_rowData.get("COMPANY_NAME")) %> 고객사(협력사) 간의 본 전자계약서에 포함된 정보나 자료는 (주)코리아이플랫폼의 허가 없이 다른 목적으로 사용할 수 없습니다.</font></p>
							<p style="height:13px"><font size="1px" color="darkgray">본 전자계약서는 (주)코리아이플랫폼 전자구매시스템(http://www.koreab2b.co.kr)에서 전자서명(공인인증)으로 체결된 계약서임을 확인합니다.</font></p> 
                		<% } %>
				</div>
				<% } %>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>계약서 상세</caption>
	                <colgroup>
	                    <col width="12%" />
	                    <col width="*" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">첨부서식</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("ATACH_UUID"))%></td>
						</tr>
						<tr>
							<th scope="row">작성자</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("USER_NAME"))%></td>
						</tr>
					</tbody>
				</table>
					                
        	</div>
        	<!--버튼영역-->
			<div class="btnArea mb05">
				<span class="fl">
				<%
				if ("M".equals(businessCond)) {
					if ("TMP".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) {
				%>
					<!--  span class="btn_02 mr04"><a href="javascript:doPop('fileUpload'); ">파일추가</a></span -->
					<span class="btn_02"><a href="javascript:doPop('constractMod');">수정</a></span>
				<% } else if ("CS1".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) {  %>
					<span class="btn_02 mr04"><a href="javascript:doPop('contWithdraw'); ">회수</a></span>
				<% } else if ("OS1".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) {  %>
					<span class="btn_02 mr04"><a href="javascript:doAction('signMaster'); ">전자서명</a></span>
					<span class="btn_02"><a href="javascript:doPop('contRevoke');">취소</a></span>
				<% } else if ("OS2".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) {  %>
					<span class="btn_02"><a href="javascript:doAction('signMaster');">전자서명</a></span>
				<% } else if ("END".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) {  %>
					<span class="btn_02 mr04"><a href="javascript:doPop('contChg'); ">계약연장</a></span>
					<span class="btn_02 mr04"><a href="javascript:doPop('contCancel'); ">계약해지</a></span>
					<span class="btn_02"><a href="javascript:doPop('contModify');">계약변경</a></span>
				<% } %>
					<span class="btn_02"><a href="javascript:doAction('print');">인쇄</a></span>
				<% } %>
				<%
				if (!"M".equals(businessCond)) {
					if ("CS1".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS"))) || "CS2".equals(CommonUtil.nvl(_rowData.get("CONT_STATUS")))) {
				%>
					<span class="btn_02 mr04"><a href="javascript:doAction('signVendor'); ">전자서명</a></span>
					<span class="btn_02"><a href="javascript:doPop('contReject');">반려</a></span>
				<% } %>
					<span class="btn_02"><a href="javascript:doAction('print');">인쇄</a></span>
				<% } %>	
				</span>	
			</div>
	    <% } %>
	    </div>
	</div>
	<div id="ksign" style="position:absolute; left:0px; top:0px; width:100%; height:100%;" >
		<object id="CC_Object_id" classid="CLSID:A099920B-630C-426B-91EC-737685CEEE17" codebase="/module/crosscert/ccc-sample/AxCrossCert.cab#Version=2,6,6,0" width= Document.body.clientWidth height= Document.body.clientHeight></object>
	</div>
</form> 
</body>
</html>
