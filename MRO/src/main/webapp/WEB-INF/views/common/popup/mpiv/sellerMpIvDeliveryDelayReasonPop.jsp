<%--
**********************************************
* 메뉴 : 
* 화면 : 납품지연 사유
* 기능 : 납품지연사유를 입력하는 화면
* 프로그램 ID : PG_07_A_001_03
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
 <%
 	//st_pop_type multi 일 경우 확인버튼만 활성화.
	String st_pop_type           = CommonUtil.nvl((String)request.getParameter("st_pop_type"), "");
 	String st_year           = CommonUtil.nvl((String)request.getParameter("st_year"), "");
 	String st_month        = CommonUtil.nvl((String)request.getParameter("st_month"), "");
 	String st_day     = CommonUtil.nvl((String)request.getParameter("st_day"), "");
%> 

<script language="javascript">

//지연사유 저장
function setSave(flag){		// flag ==> 해당품목(one) 또는 모든품목(all)
	 
	var form = document.sellerMpIvDeliveryDelayReasonPop;
	var value = "";
	var st_year = "<%=st_year%>";
	var st_month = "<%=st_month%>";
	var st_day = "<%=st_day%>";
	
	for( var i = 0; i < form.rdo_delay_reason_cd.length-1; i++){
		if(form.rdo_delay_reason_cd[i].checked == true){
			value = form.rdo_delay_reason_cd[i].value;
		}
	}
	
	if(form.rdo_delay_reason_cd[4].checked == true){

		value = $("#st_delay_reason_txt").val();

		if(isEmpty(value)) {
			alert("납품지연 사유를 입력하여 주시길 바랍니다.");
			$("#st_delay_reason_txt").focus();
			return;
		}
	}
	
	if(isEmpty(value)) {
		alert("납품지연 사유를 선택해주시길 바랍니다.");
		return;
	}
	
	opener.setReason(value,flag,st_year,st_month,st_day);	
	parent.window.close();
}

// radiobutton 기타 click event
function setEtc(flag){
	if(flag == "Y"){
		alert("하단에 지연사유를 입력하시기 바랍니다.");
		$("#st_delay_reason_txt").val("");
		$("#st_delay_reason_txt").focus();
		return;	
	} else {
		$("#st_delay_reason_txt").val("");
		return;
	}
}

function init(){
	var st_pop_type = "<%=st_pop_type%>";
	if(st_pop_type == "multi_confirm"||st_pop_type == "delay_multi_confirm") return;
	
	var form = document.sellerMpIvDeliveryDelayReasonPop;
	var reason = opener.getDelayReason();

	for( var i = 0; i < form.rdo_delay_reason_cd.length-1; i++){

		if(form.rdo_delay_reason_cd[i].value == reason){
			form.rdo_delay_reason_cd[i].checked = true;		
		}
	}
	
	if(reason != "" && reason != "재고부족" && reason != "수입지연" && reason != "제작지연" &&  reason != "발주확인지연"){
		form.rdo_delay_reason_cd[4].checked = true;
		$("#st_delay_reason_txt").val(reason);
	}
}

function onFocus(){
	document.sellerMpIvDeliveryDelayReasonPop.rdo_delay_reason_cd[4].checked = true;
}

</script> 
</head>
<body onLoad="javascript:init();">
<form name="sellerMpIvDeliveryDelayReasonPop" id="sellerMpIvDeliveryDelayReasonPop" method=post >

<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div id="popWrapper" style="height:404px;">
   	<div id="popHeader">
		<h1 class="title">납품지연 사유</h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
	</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
            <!--조회영역-->
            <div>
            	<table style="width:100%;margin-top:10px;">
					<tr height="15px">
						<td style="text-align:left;">
							<input class="Noborder"  type="radio" name="rdo_delay_reason_cd" id="rdo_delay_reason_cd1" value="재고부족" onClick="javascript:setEtc('N');" />
							<label for="rdo_delay_reason_cd1">재고부족</label> 
						<td>
					</tr>
					<tr height="15px">
						<td style="text-align:left;">
							<input class="Noborder"  type="radio" name="rdo_delay_reason_cd" id="rdo_delay_reason_cd2" value="수입지연" onClick="javascript:setEtc('N');" /> 
							<label for="rdo_delay_reason_cd2">수입지연</label>
						</td>
					</tr>
					<tr height="15px">
						<td style="text-align:left;">
							<input class="Noborder"  type="radio" name="rdo_delay_reason_cd" id="rdo_delay_reason_cd3" value="제작지연" onClick="javascript:setEtc('N');" /> 
							<label for="rdo_delay_reason_cd3">제작지연</label>
						</td>
					</tr>
					<tr height="15px">
						<td style="text-align:left;">
							<input class="Noborder"  type="radio" name="rdo_delay_reason_cd" id="rdo_delay_reason_cd4" value="발주확인지연" onClick="javascript:setEtc('N');" /> 
							<label for="rdo_delay_reason_cd4">발주확인지연</label>
						</td>
					</tr>
					<tr height="15px">
						<td style="text-align:left;">
							<input class="Noborder"  type="radio" name="rdo_delay_reason_cd" id="rdo_delay_reason_cd5" value="기타" onClick="javascript:setEtc('Y');" />
							<label for="rdo_delay_reason_cd5">기타</label>
						</td>
					</tr>
					<tr height="10px">
						<td></td>
					</tr>
					<tr>
						<td>
							<textarea id="st_delay_reason_txt" cols="75" rows="10" onClick="onFocus();"></textarea>
						</td>
					</tr>
					<tr height="40px">
					<%if(!st_pop_type.equals("one") && !st_pop_type.equals("")){ %>
						<td><font color="red">※ 모든 품목 적용은 지연사유가 입력되지 않은 항목에만 적용</font></td>
					<%} %>
					</tr>
					<tr>
					<%if(st_pop_type.equals("confirm")){ %>
						<td style="text-align:right;" colspan="3">
			            	<span class="btn_04 mr04"><a href="javascript:setSave('confirm');">확인</a></span>
	            		</td>
					<%}else if(st_pop_type.equals("multi_confirm")){ %>
						<td style="text-align:right;" colspan="3">
			            	<span class="btn_04 mr04"><a href="javascript:setSave('multi_confirm');">확인</a></span>
	            		</td>
					<%}else if(st_pop_type.equals("delay_multi_confirm")){ %>
						<td style="text-align:right;" colspan="3">
			            	<span class="btn_04 mr04"><a href="javascript:setSave('delay_multi_confirm');">확인</a></span>
	            		</td>
					<%}else{ %>
						<%if(st_pop_type.equals("one")){ %>
							<td style="text-align:center;" colspan="3">
				            	<span class="btn_10"><a href="javascript:setSave('one');">해당품목 적용</a></span>
		            		</td>
	            		<%}else{ %>
	            			<td style="text-align:center;" colspan="3">
				            	<span class="btn_10"><a href="javascript:setSave('one');">해당품목만 적용</a></span>
				            	<span class="btn_10"><a href="javascript:setSave('all');">모든 품목 적용</a></span>
		            		</td>
	            		<%} %>
	            	<%} %>
	            	</tr>
				</table>
            </div>
        </div>
    </div>        
</div>
</form> 
</body>
</html>
