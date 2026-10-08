<%--
**********************************************
* 메뉴 : 
* 화면 : 수주접수 초기화요청
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2023-11-30
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
	String query = CommonUtil.nvl((String) request.getParameter("value1"),"");
%>

<script language="javascript">
// 변경요청
function ivInfoChangeRequest(){
	var form = document.sellerMpIvIvInfoChangePop;
	var value_reason = "";
	var value_reason_text = $("#st_change_reason_text").val();
	
	for( var i = 0; i < form.rdo_change_reason_cd.length; i++){
		if(form.rdo_change_reason_cd[i].checked == true){
			value_reason = form.rdo_change_reason_cd[i].value;
		}
	}
	
	if(isEmpty(value_reason)) {
		alert("변경사유를 선택하세요.");
		return;
	}
	
	if(value_reason == "기타사유" && isEmpty(value_reason_text)){
		alert("기타 상세사유를 입력하세요.");
		return;
	}

	if(value_reason == "기타사유"){
		$("#st_reason").val(value_reason_text);
	}else{
		$("#st_reason").val(value_reason);
	}
	
	if(!confirm("수주접수 초기화요청 시 KeP 승인 전까지 납품을 할 수 없습니다.\n변경 요청 하시겠습니까?"))
		return;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvIvInfoChangeReqList.do","sellerMpIvIvInfoChangePop","btnCreate");
}

function init(){
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnCreate"){
		alert("변경요청이  정상적으로 완료 되었습니다.");
		parent.window.close(); // 수주접수 초기화요청 팝업
		opener.doAction("search"); // 납품진행현황
	}
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response) {	
	if(pMethod == "btnCreate"){ 
		alert("요청 등록에 실패 하였습니다. 관리자에게 문의하여 주십시오"); 
	}
}
</script>
</head>

<body onload="javascript:init();">
<form name="sellerMpIvIvInfoChangePop" id="sellerMpIvIvInfoChangePop" method="post" >
	<!-- HIDDEN -->
	<input type="hidden" name="st_user_id" id="st_user_id" value="<%=user_id%>">
	<input type="hidden" name="st_agent" id="st_agent" value="<%=agent%>">
	<input type="hidden" name="st_query" id="st_query" value="<%=query%>">
	<input type="hidden" name="st_reason" id="st_reason" value="">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:280px;">
    	<div id="popHeader">
        	<h1 class="title">수주접수 초기화요청</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
		<div id="popContainer">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		            <td valign="bottom">
		                <table width="100%" class="cont_t_list05">
			                <colgroup>
					            <col width="25%" />
					            <col width="15%" />
					            <col width="5%"/>
					            <col width="*" />
					        </colgroup>
					        
					        <tr style="padding-left:5px"> 
		                        <th rowSpan="5">변경사유<br>(중복선택 불가)</th>
		                        <td>거래유형</td>
		                        <td style="padding-left:5px"><input type="radio" name="rdo_change_reason_cd" id="rdo_change_reason_cd1" style="vertical-align:middle;" value="거래유형"/></td>
		                        <td style="padding-left:5px">재 수주접수를 통해 거래유형 변경 목적</td>
		                    </tr>
		                    <tr> 
		                        <td>납품수량</td>
		                        <td style="padding-left:5px"><input type="radio" name="rdo_change_reason_cd" id="rdo_change_reason_cd2" style="vertical-align:middle;" value="납품수량"/></td>
		                        <td style="padding-left:5px">재 수주접수를 통해 분할계획 변경 목적</td>
		                    </tr>
		                    <tr> 
		                        <td>기타사유</td>
	                        	<td style="padding-left:5px"><input type="radio" name="rdo_change_reason_cd" id="rdo_change_reason_cd3" style="vertical-align:middle;" value="기타사유"/></td>
	                        	<td style="padding-left:5px"><input type="text" name="st_change_reason_text" id="st_change_reason_text" style="width:95%"; value=""/></td>
	                        	<input type="text" style="display:none"/>
								</td>
		                    </tr>
		                </table>
		                
		                <span style="text-align:left;">
		                	<font color="red">해당 발주번호 내 모든 품목이 변경요청되며, KeP 확인 전까지 납품이 불가합니다.</font><br>
		                	<font color="red">KeP 승인 후에는 수주접수부터 진행하시기 바랍니다.</font><br>
		                	<font color="red">변경요청 후 진행 상황은 <b>[납품관리>납품현황>요청사항 진행현황]</b>에서 확인 가능합니다.</font><br>
		                </span>
		                
		                <br><br><br>
		                
		                <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
		                    <tr>
		                        <td align="center">
		                        	<span class="btn_04"><a href="javascript:ivInfoChangeRequest();">변경요청</a></span>
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