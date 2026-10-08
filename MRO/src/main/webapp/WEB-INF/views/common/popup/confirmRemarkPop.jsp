<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String st_btoa_remark = CommonUtil.nvl((String) request.getParameter("st_btoa_remark"),"");  //  (조회조건)
st_btoa_remark = st_btoa_remark.replaceAll("&lt;br&gt;","\n");

String st_atob_remark = CommonUtil.nvl((String) request.getParameter("st_atob_remark"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
st_atob_remark = st_atob_remark.replaceAll("&lt;br&gt;","\n");

String st_atoa_remark = CommonUtil.nvl((String) request.getParameter("st_atoa_remark"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
st_atoa_remark = st_atoa_remark.replaceAll("&lt;br&gt;","\n");

String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)

String st_title = CommonUtil.nvl((String) request.getParameter("title"), ""); 

String confirm_remark = CommonUtil.nvl((String) request.getParameter("confirm_remark"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
confirm_remark = confirm_remark.replaceAll("&lt;br&gt;","\n");

String confirmType = CommonUtil.nvl((String) request.getParameter("confirmType"),"");  //  (조회조건)

String st_buyer = CommonUtil.nvl((String) request.getParameter("buyer"), "");
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("quotation_no"), "");
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("quotation_seq"), "");
String st_revision = CommonUtil.nvl((String) request.getParameter("revision"), "");
String st_seq = CommonUtil.nvl((String) request.getParameter("seq"), "");

	//단가합의 사유 추가
	boolean p04402709 = CommonUtil.getSpecialCheckReturn(st_buyer,"P04-4027-09");

%>
<script type="text/javascript"> 

function kepConfirm_remark() {
	var confirm_remark = $("#confirm_remark").val();
	$('#st_confirm_remark').attr('value', confirm_remark);
	if(confirm("저장하시겠습니까?")){		
		kepAjaxPopFormCall("/mprq/buyerSaveUnitpriceAgrmntNegoReqPop.do","buyerMpRqSaveConfirmRemarkPop","proc");
	}
}
/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxPopSuccess(pMethod , response) {
	var sMsg = response.msg;
	var alertMsg = "";
	
	if (sMsg == "OK") {		
		alertMsg = "저장 되었습니다.";		
	}else{
		alertMsg = "처리 하던중 오류가 발생하였습니다.";
	}
	
	alert(alertMsg);
	var confirm_remark = $('#confirm_remark').val();	
	var seq = $('#st_seq').val();	
	this.close();	
	opener.setPopupReturn("",seq, confirm_remark);
}

</script>  
<body onload="">
<form name="buyerMpRqSaveConfirmRemarkPop" id="buyerMpRqSaveConfirmRemarkPop" method="post" >	 
	 <input type="hidden" id="st_buyer" name="st_buyer"	value="<%=st_buyer %>">
	 <input type="hidden" id="st_quotation_no" name="st_quotation_no"	value="<%=st_quotation_no %>">
	 <input type="hidden" id="st_quotation_seq"  name="st_quotation_seq"  value="<%=st_quotation_seq%>">
	 <input type="hidden" id="st_revision" name="st_revision"	value="<%=st_revision %>">
	 <input type="hidden" id="st_confirm_remark" name="st_confirm_remark"	value="">
	 <input type="hidden" id="st_seq" name="st_seq"	value="<%=st_seq %>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:304px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        <input type="hidden" id="viewType" name="viewType" value="<%=viewType%>"/>
			<table class="cont_t_list05" style="background-color: #FAF9CF;">
                <tr> 
                <%
                	if ("A".equals(st_title)) {
                %>  	
               		<th style="width: 13%">고객사<br>▶<br>운영자</th>	
                <%
                	} else if ("ATOB".equals(st_title)) {
                %>  	
               		<th style="width: 13%">운영사<br>▶<br>고객사</th>	
                <%
                	} else if ("ATOA".equals(st_title)) {
                %>  	
               		<th style="width: 13%">고객사<br>▶<br>운영자</th>	
                <% } else { %>
                    <th style="width: 13%">고객사</th> 		
                <% } %> 		
                    <td >
               	<% if ("ATOB".equals(st_title)) {
                %>  	
                        <textarea id="st_atob_remark" name="st_atob_remark" style="width:100%; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_atob_remark%></textarea>
				<% } else { %>
                        <textarea id="st_btoa_remark" name="st_btoa_remark" style="width:100%; overflow:auto; border-color:white; border-width:0; background-color: #FAF9CF;" rows="5" cols="35" readonly><%=st_btoa_remark%></textarea>
				<% } %>
				
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>
			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >
            <table class="cont_t_list05">
                <tr> 
                <%
                	if ("A".equals(st_title)) {
                %>  	
               		<th style="width: 13%">운영사<br>▶<br>고객사</th>	
                <%
                	} else if ("ATOB".equals(st_title)) {
                %>  	
               		<th style="width: 13%">고객사<br>▶<br>운영자</th>	
                <%
                	} else if ("ATOA".equals(st_title)) {
                %>  	
               		<th style="width: 13%">운영사<br>▶<br>고객사</th>		
                <% } else { %>
                    <th style="width: 13%">운영사</th> 		
                <% } %> 
                    <td >
                <%
                	if ("ATOB".equals(st_title)) {
                %>  	
                        <textarea name="st_btoa_remark" id="st_btoa_remark"  style="overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(viewType))?"readonly" :"" %> ><%=st_btoa_remark%></textarea>
                <% } else { %>
                        <textarea name="st_atob_remark" id="st_atob_remark"  style="overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(viewType))?"readonly" :"" %> ><%=st_atob_remark%></textarea>
                <% } %>      
                    </td>
                </tr>
            </table>
                <%
                	if ("ATOA".equals(st_title)) {
                %>  	
            <table class="cont_t_list05">
                <tr> 
                    <th style="width: 13%">운영사</th> 		
                    <td >
	                    <textarea name="st_atoa_remark" id="st_atoa_remark"  style="overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(viewType))?"readonly" :"" %> ><%=st_atoa_remark%></textarea>
                    </td>
                </tr>
            </table>
                <% } %>
             	<%
                	if (p04402709 == true) {
                %>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>
			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >      	
            <table class="cont_t_list05">
                <tr> 
                    <th style="width: 13%">단가합의<br>비고</th> 		
                    <td>
	                    <textarea name="confirm_remark" id="confirm_remark"  style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(confirmType))?"readonly" :"" %> ><%=confirm_remark%></textarea>
                    </td>
                </tr>
            </table>
            <% if("R".equals(confirmType)) { }
            
            else {%>
            <div class="btnArea ac mt20" style="margin-bottom:0px;"> 
			           	<span class="fr btn_02"><a href="javascript:kepConfirm_remark()">저장</a></span> 
			</div>
			
              <% } 
             } %>            
<!--        	<textarea name="CONTEXT" id="CONTEXT"  rows="23"  style="width:100%"></textarea> -->
       	    	
        </div>
    </div>
    </form>
</body>
</html>
