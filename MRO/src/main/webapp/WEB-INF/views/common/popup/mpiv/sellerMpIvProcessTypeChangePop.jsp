<%--
**********************************************
* 메뉴 : 
* 화면 : 거래유형 변경요청
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2023-10-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Vector"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
<%
	String user_id = _sessionInfo.getUserId();
	String agent = _sessionInfo.getComCode();
	String buyer = CommonUtil.nvl((String) request.getParameter("value1"));
	String po_no = CommonUtil.nvl((String) request.getParameter("value2"));
	String process_type = CommonUtil.nvl((String) request.getParameter("value3"));
%>

<script language="javascript">
// 변경요청
function processTypeChangeRequest(){
	var ch_process_type = $("#ch_process_type").val();
	var value_reason_text = $("#st_reason_text").val();
	
	if(ch_process_type == ""){
		alert("변경요청할 거래유형을 선택하세요.");
		return;
	}else if(ch_process_type == "Y"){ // 택배 선택 시
		$("#st_parcel_yn").val("Y");
	}else{
		$("#st_parcel_yn").val("N");
	}
	
	if(isEmpty(value_reason_text)) {
		alert("상세사유를 입력하세요.");
		return;
	}
	
	if(!confirm("거래유형 변경요청 시 KeP 승인 전까지 납품을 할 수 없습니다.\n변경 요청 하시겠습니까?"))
		return;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvProcessTypeChangeReqPop.do","sellerMpIvProcessTypeChangePop","save");
}

// OPENER창의 지연사유 값 얻기
function init(){
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	alert("거래유형 변경요청 등록완료.\n요청사항 진행현황은 [납품관리>납품현황>요청사항 진행관리]에서 확인 가능");
	parent.window.close(); // 거래유형 변경요청 팝업
	opener.window.close(); // 수주접수 상세 팝업
	opener.opener.kepSearch("1"); // 수주접수
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function kepAjaxError(pMethod , response) {	
	if(pMethod == "save"){ 
		alert("요청 등록에 실패 하였습니다. 관리자에게 문의하여 주십시오"); 
	}
}
</script>
</head>

<body onload="javascript:init();">
<form name="sellerMpIvProcessTypeChangePop" id="sellerMpIvProcessTypeChangePop" method="post" >
	<!-- HIDDEN -->
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=user_id%>">
	<input type="hidden" name="st_agent" id="st_agent" value="<%=agent%>">
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer%>">
	<input type="hidden" name="st_po_no" id="st_po_no" value="<%=po_no%>">
	<input type="hidden" name="re_process_type" id="re_process_type" value="<%=process_type%>">
	<input type="hidden" name="st_parcel_yn" id="st_parcel_yn" value="N">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:280px;">
    	<div id="popHeader">
        	<h1 class="title">거래유형 변경요청</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
		<div id="popContainer">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		            <td valign="bottom">
		                <table width="100%"  class="cont_t_list06">
			                <colgroup>
					            <col width="30%" />
					            <col width="70%" />
					        </colgroup>
					        
					        <tr> 
		                        <th>기존 거래유형</th>
		                        <td style="text-align: left;">TR</td>
		                    </tr>
		                    <tr> 
		                        <th>변경 거래유형</th>
		                        <td style="text-align: left;">
		                        	<select id="ch_process_type" name="ch_process_type" style="width:95%;">
										<option value="">선택</option>
										<option value="Y">고객사 직접납품(택배)</option>
										<option value="N">고객사 직접납품(자차)</option>
									</select>
								</td>
		                    </tr>
		                    
		                    <tr> 
		                        <th><font color="red">*</font> 상세사유</th>
		                        <td colSpan="3">
		                        	<input type="text" name="st_reason_text" id="st_reason_text" style="width:95%"; value=""/>
		                        	<input type="text" style="display:none"/>
								</td>
		                    </tr>
		                </table>
		                
		                <span style="text-align:left;">
		                	<font color="red">해당 발주번호 내 모든 품목이 변경요청되며, KeP 확인 전까지 수주접수 내역에서 제외됩니다.</font><br>
		                	<font color="red">거래유형 변경요청 후 진행상황은 <b>[납품관리>납품현황>요청사항 진행현황]</b>에서 확인 가능합니다.</font><br>
		                </span>
		                
		                <br><br>
		                
		                <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
		                    <tr>
		                        <td align="center">
		                        	<span class="btn_04"><a href="javascript:processTypeChangeRequest();">변경요청</a></span>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		</div>        
	</div>
</form> 
</body>
</html>