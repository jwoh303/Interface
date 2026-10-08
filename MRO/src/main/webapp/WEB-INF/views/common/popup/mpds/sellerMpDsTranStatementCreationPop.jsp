<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서생성
* 기능 : 도안관련 발주 거래명세서 생성을 위한 팝업
* 프로그램 ID : PG_07_A_012_02
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-27
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
<link rel="stylesheet" href="/resources/styles/seller_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/sunny/jquery-ui.min.css"/>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String Session_user_id        = (String) _sessionInfo.getUserId();

String buyer		= CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String add_date		= CommonUtil.nvl((String) request.getParameter("st_add_date"),"");
String seq			= CommonUtil.nvl((String) request.getParameter("st_seq"),"");
String ds_seq		= CommonUtil.nvl((String) request.getParameter("st_ds_seq"),"");
String inv_user_id	= CommonUtil.nvl((String) request.getParameter("st_inv_user_id"),"");
String result = CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과   

Map<String,String> formData = null;

%>
<script type="text/javascript">
var popupSel = "";

function kep_onload_view(){
	<%
		if (_dataList==null || _dataList.size()==0){
	%>
// 			kepSearch();
	<%	
		}else{
			formData = _dataList.get(0);
		}
	%>
	kepSetCalender("st_inv_date");
	$("#st_inv_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}

//기능함수
function doAction(str) {
	st = new Date();
	popupSel = str;
	switch (str) {
		case "search":
			kepSearch(1);
			break;
		case "setInvoice": //송장생성
			var inv_date	= document.forms[0].st_inv_date.value;

			if(inv_date=="") {
				alert("납품일 선택하여 주십시오.");
				return ;
			}

			if(!confirm("송장생성 하시겠습니까?")) return;
			kepAjaxFormCall("/mpds/invoiceSellerMpDsTranStatementCreationPop.do","contentForm",popupSel); 
			break;
	}

}

//팝업함수호출
function doPop(str, value1) {
	popupSel = str;
	
	switch (str) {
		case "masterMpDsClosingDateChoicePop": //납품계획
			openSearchPopup('/mpds/showMasterMpDsClosingDateChoicePop.do','?ds_qty='+value1,'400,300,no');
			break;
	}
	
}



function kepSearch()
{ 
	  $('#contentForm').attr("action", "/mpds/getMasterMpDsOrderInfoConfirmPop.do").submit();    
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3){
// 	alert(popupSel+"::"+value1+":::"+value2+":::"+value3);

	if (popupSel == "masterMpDsClosingDateChoicePop") {	// 납품계획
		
		var htmlsrc = "<table>";

		if(value1.indexOf("@@") > -1){
			var value1Array = value1.split("@@");
			var value2Array = value2.split("@@");
	 		for(var x=0; x<value1Array.length; x++) {
	 			htmlsrc +="<tr>";
	 			htmlsrc +="<td height='25'>납품요청일 : "+value1Array[x]+"&nbsp;&nbsp;수량 : "+value2Array[x]+"</td>";
	 			htmlsrc +="</tr>";
	 		}
		}else{
 			htmlsrc +="<tr>";
 			htmlsrc +="<td height='25'>납품요청일 : "+value1+"&nbsp;&nbsp;수량 : "+value2+"</td>";
 			htmlsrc +="</tr>";
		}

		htmlsrc += "</table>";
// 		alert(htmlsrc);

		document.getElementById("deliverPlan").innerHTML=htmlsrc;
		
		document.getElementById("st_rd_date_all").value=value1;
		document.getElementById("st_ds_qty_all").value=value2;

// 		resizeMe();
		
	}
} 

// iframe의 크기를 resize한다.
// function resizeMe() {

//     nWidth  = document.body.scrollWidth ;
//     nHeight = document.body.scrollHeight ;
//     window.parent.setiResize(nWidth,nHeight);
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
	if(popupSel == "setInvoice"){
		opener.setPopupReturn('','');
	  	this.close();
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

 
</script> 
<body onload="kep_onload_view()">
	 <form name=contentForm id=contentForm method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="contentForm"> 
	<input type="hidden" name="st_buyer"		value="<%=buyer%>">
	<input type="hidden" name="st_add_date"		value="<%=add_date%>">
	<input type="hidden" name="st_ds_seq"		value="<%=ds_seq%>">
	<input type="hidden" name="st_seq"			value="<%=seq%>">
	<input type="hidden" name="st_inv_user_id" value="<%=inv_user_id%>">

<%
if (formData==null || formData.size()==0){
%>
<%}else{ %>	 	

	<input type="hidden" name="st_po_status"	value="<%=formData.get("STATUS")%>">
	<input type="hidden" id="st_rd_date_all" name="st_rd_date_all"		value="">
	<input type="hidden" id="st_ds_qty_all"	 name="st_ds_qty_all"	value="">
	<input type="hidden" name="st_status"		value="">
	<input type="hidden" name="st_change_user_id"	value="<%=Session_user_id%>">
	<input type="hidden" name="st_byit_comorg_code"	value="<%=formData.get("BYIT_COMORG_CODE")%>">
	<input type="hidden" name="st_contract_no"		value="<%=formData.get("CONTRACT_NO")%>">
	<input type="hidden" name="st_contract_seq"		value="<%=formData.get("CONTRACT_SEQ")%>">
	<input type="hidden" name="st_add_time"			value="<%=formData.get("ADD_TIME")%>">
	<input type="hidden" name="st_ds_qty"			value="<%=formData.get("DS_QTY")%>">

	  
	<div id="popWrapper" style="height:434px;">
    	<div id="popHeader">
        	<h1 class="title">발주생성 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	
            <table  class="cont_t_list06" style="width:100%;">
              <caption>발주생성  리스트</caption>
                <colgroup>
                    <col width="15%" />
                    <col width="35%" />
                    <col width="15%" />
                    <col width="35%" />
                </colgroup>
                <tbody>
			          <tr>
			            <th >품목코드</th>
			            <td colspan="3" >&nbsp;<%=formData.get("BUYER_ITEM_NO")%></td>
			          </tr>
			          <tr>
			            <th  >품목명</th>
			            <td colspan="3" ><%=formData.get("DESCRIPTION")%></td>
			          </tr>
			          <tr>
			            <th  >발주자</th>
			            <td colspan="3" ><%=formData.get("PURCHASER_NAME")%></td>
			          </tr>
			          <tr>
			            <th  >협력사</th>
			            <td ><%=formData.get("AGENT_NAME")%></td>
						<th >송장 발행일</th>
			            <td>
							<input type="text" name="st_inv_date" id="st_inv_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_inv_date')"></a>
<%-- 							<input type="text" name="st_inv_date_text" size="10" value="<%=CommonUtil.formatStrinigDate(curDate)%>" onKeyDown="" style="text-align:right"readonly> --%>
<!-- 							<a href="javascript:Calendar_Open();"><img src="/kr/sysop/proxbuy/images/icon/new_butt_query.gif"  align="absmiddle" border="0"></a> -->
<%-- 							<input type="hidden" name="st_inv_date" value="<%=curDate%>"> --%>
						</td>
			          </tr>
			          <tr >
			            <th  >수량</th>
			            <td >
							<%=CommonUtil.formatNumber(formData.get("DS_QTY"),true,0,3) %>
							<input type="hidden" name="st_ds_qty" value="<%=formData.get("DS_QTY")%>">
						</td>
			            <th >납품요청일</th>
			            <td><%=CommonUtil.formatStrinigDate(formData.get("RD_DATE")) %></td>
			          </tr>
			          <tr>
			            <th  >납품처</th>
			            <td colspan="3" ><%=formData.get("DELY_TO_LOCATION_TEXT")%></td>
			          </tr>
			          <tr>
			            <th  >제조모집단</th>
			            <td colspan="3" ><%=formData.get("REF_NO")%></td>
			          </tr>
			          <tr>
			            <th  >고객사 비고</th>
			            <td colspan="3" ><%=formData.get("BTOA_REMARK")%></td>
			          </tr>
			          <tr>
			            <th  >운영자 비고</th>
			            <td colspan="3" ><%=formData.get("ATOS_REMARK")%></td>
			          </tr>
			        </table>
			        <table width="560" border="0" cellspacing="0" cellpadding="0" height="1" bgcolor="#60A7E6">
			          <tr>
			            <td></td>
			          </tr>
                </tbody>
            </table>

			<div class="btnArea">
				<span class="fl">
					<font color="red"><b>※ 납기요청일에 입고 불가능할 경우 KeP로 즉시 연락 바랍니다.</b></font>
				</span>
		       	<span class="fr"> 
					<span class="btn_02 mr04"><a href="javascript:doAction('setInvoice');">송장생성</a></span>
				</span>
			</div>
<%} %>
        </div>
    </div>


</form> 
</body>
</html>
