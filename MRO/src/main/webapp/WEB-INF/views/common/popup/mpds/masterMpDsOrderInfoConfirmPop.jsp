<%--
**********************************************
* 메뉴 : 
* 화면 : 발주 정보 확인
* 기능 : 발주정보를 확이하기 위한 팝업
* 프로그램 ID : PG_07_M_002_09
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-20
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
String po_status	= CommonUtil.nvl((String) request.getParameter("st_po_status"),"");
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
}

//기능함수
function doAction(str) {
	st = new Date();
	popupSel = str;
	switch (str) {
		case "search":
			kepSearch(1);
			break;
		case "setPoDataDel": //주문취소
			if(!confirm("주문을 취소 하시겠습니까?")) return;
			kepAjaxFormCall("/mpds/cancelMasterMpDsOrderInfoConfirmPop.do","contentForm",popupSel); 
			break;
		case "setPoDataModify": //수정
			if(!confirm("수정 하시겠습니까?")) return;
			kepAjaxFormCall("/mpds/modifyMasterMpDsOrderInfoConfirmPop.do","contentForm",popupSel); 
			break;
		case "setPoDataReg": //발주 생성
			if(!confirm("발주 생성 하시겠습니까?")) return;
			kepAjaxFormCall("/mpds/regMasterMpDsOrderInfoConfirmPop.do","contentForm",popupSel); 
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
		case "agent" : //협력사
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N','500,466,no');
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
		
	}else if (popupSel == "agent") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
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
	if(popupSel == "setPoDataDel" || popupSel == "setPoDataModify" || popupSel == "setPoDataReg"){
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
	<input type="hidden" name="tmp_company"		value="<%=seq%>">

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
        	<h1 class="title">발주정보 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	
            <table  class="cont_t_list06" style="width:100%;">
              <caption>발주정보  리스트</caption>
                <colgroup>
                    <col width="20%" />
                    <col width="80%" />
                </colgroup>
                <tbody>
		          <tr>
		            <th>품목코드</th>
		            <td><input type="text" name="st_buyer_item_no" value="<%=formData.get("BUYER_ITEM_NO")%>" onKeyDown=""></td>
		          </tr>
		          <tr>
		            <th  >품목명</th>
		            <td ><%=formData.get("DESCRIPTION")%></td>
		          </tr>
		          <tr>
		            <th  >발주자</th>
		            <td ><%=formData.get("PURCHASER_NAME")%></td>
		          </tr>
		          <tr>
		            <th  >협력사</th>
		            <td ><input type="text" id="st_agent_name" name="st_agent_name"  value="<%=formData.get("AGENT_NAME")%>" readonly onclick="javascript:doPop('agent');">
						<input type="hidden" id="st_agent_code" name="st_agent_code"  value="<%=formData.get("AGENT")%>">
					</td>
		          </tr>
		          <tr bgcolor="#ffffff" style="padding-top:5px">
		            <th  height="50">납품계획</th>
						<td>
							<table><tr>
							<td><div id="deliverPlan">납품계획을 입력 바랍니다.</div></td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;<span class="btn_04 mr04"><a href="javascript:doPop('masterMpDsClosingDateChoicePop','<%=formData.get("DS_QTY")%>' );">납품계획 입력</a></span></td>
							</tr></table>
						</td>
<!-- 						<a href="javascript:sysop_dongbu_admin_plan_rddate_pop();"><img src="/resources/images/but_delivery_plan_input.gif"  align="absmiddle" border="0"></a> -->
		          </tr>
		          <tr>
		            <th  >납품처</th>
		            <td ><input type="text" name="st_dely_to_location_text" style="width:98%" value="<%=formData.get("DELY_TO_LOCATION_TEXT")%>" onKeyDown=""></td>
		          </tr>
		          <tr>
		            <th  >제조모집단</th>
		            <td ><input type="text" name="st_ref_no" style="width:98%" value="<%=formData.get("REF_NO")%>" onKeyDown=""></td>
		          </tr>
				  <%
					if(com_code.equals("KRKORE0001")) {
					%>
		          <tr>
		            <th  >협력사 비고</th>
		            <td ><input type="text" name="st_atos_remark" style="width:98%" value="<%=formData.get("ATOS_REMARK")%>" onKeyDown=""></td>
		          </tr>
				  <tr>
		            <th  >KeP 비고</th>
		            <td ><input type="text" name="st_atoa_remark" style="width:98%" value="<%=formData.get("ATOA_REMARK")%>" onKeyDown=""></td>
		          </tr>
	  				<%
		  			}
					%>
		           <tr>
		            <th  >고객사 비고</th>
		            <td ><input type="text" name="st_btoa_remark" style="width:98%" value="<%=formData.get("BTOA_REMARK")%>" onKeyDown=""></td>
		          </tr>
				  <tr>
		            <th  >납품지연사유</th>
		            <td ><input type="text" name="st_reason_remark" style="width:98%;border-width:0px;" value="<%=formData.get("REASON_REMARK")%>" readonly ></td>
		          </tr>
                </tbody>
            </table>

			<div class="btnArea">
		       	<span class="fr"> 
					<%
						if(po_status.equals("PR") || po_status.equals("PO") || po_status.equals("DS")) {
					%>
	<!-- 						<a href="javascript:setPoDataDel();"><img src="/resources/images/but_cancel_order.gif"  align="absmiddle" border="0"></a> -->
	<!-- 						<a href="javascript:setPoDataModify();"><img src="/resources/images/but_edit.gif"  align="absmiddle" border="0"></a> -->
							<span class="btn_02 mr04"><a href="javascript:doAction('setPoDataDel');">주문취소</a></span> 
							<span class="btn_02 mr04"><a href="javascript:doAction('setPoDataModify')">수정</a></span> 
							<%
								if(com_code.equals("KRKORE0001") && formData.get("PO_QTY").equals("0") ) {
							%>
							<span class="btn_02"><a href="javascript:doAction('setPoDataReg')">발주</a></span>
<!-- 									<a href="javascript:setPoDataReg();"><img src="/resources/images/but_buy.gif"  align="absmiddle" border="0"></a> -->
							<%
								}
							%>
					<%
						}
					%>
				</span>
			</div>
<%} %>
        </div>
    </div>


</form> 
</body>
</html>
