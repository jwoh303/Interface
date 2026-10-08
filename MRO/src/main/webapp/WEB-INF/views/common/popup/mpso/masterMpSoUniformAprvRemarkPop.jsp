<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
String st_return_remark = CommonUtil.nvl((String) request.getParameter("st_return_remark"),"");
String st_viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"R");
String st_title = CommonUtil.nvl((String) request.getParameter("title"),"Y");
st_return_remark = st_return_remark.replaceAll("&lt;br&gt;","\n");
%>

<script type="text/javascript">

function init(){
}

function kepConfirm(){
	var value1 = $("#st_return_remark").val();
	var value2 = "<%=st_title%>";
	
	if(value1 == "" && value2 != "Y"){
		alert("반려 시 필수로 의견을 입력하여 주시기 바랍니다.");
		$("#st_return_remark").focus();
		return;
	}
	
	value1 = value1.replace(/\r?\n/g, '<br>');
	opener.setPopupReturn(value1, value2);
	this.close();
}

</script>  
<body onload="">
	<form id="uniformAprvRemarkPop" name="uniformAprvRemarkPop">
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div id="popWrapper" style="height:232px; min-height:100px;">
	    	<div id="popHeader">
	        	<h1 class="title">의견</h1>
	            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	        </div>
	        <!--팝업내용입니다-->
	        <div id="popContainer">
				<table class="cont_t_list05">
					<tr>
						<th>의견</th>
						<td>
							<textarea id="st_return_remark" name="st_return_remark" style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="7" cols="35" <%if("R".equals(st_viewType)){%>readOnly<%}%>><%=st_return_remark%></textarea>
	                    </td>
	                </tr>
	            </table>

<%if("C".equals(st_viewType)){%>
		       	<div class="btnArea al mt10" style="margin-bottom:0px;">
		       		유니폼 생산 계획에 대하여 <%if("Y".equals(st_title)){%>결재<%}else{%>반려<%}%>하시겠습니까?
		           	<span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span>
				</div>
<%}%>
	        </div>
    	</div>
    </form>
</body>
</html>
