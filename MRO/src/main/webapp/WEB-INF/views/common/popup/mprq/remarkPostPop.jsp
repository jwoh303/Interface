<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _data = (Map<String, String>) request.getAttribute("data"); // 조회된결과

String st_btoa_remark = CommonUtil.nvl( _data.get("BTOA_REMARK"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
st_btoa_remark = st_btoa_remark.replaceAll("&lt;br&gt;","\n");

String st_atob_remark = CommonUtil.nvl( _data.get("ATOB_REMARK"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
st_atob_remark = st_atob_remark.replaceAll("&lt;br&gt;","\n");

String st_atoa_remark = CommonUtil.nvl( _data.get("ATOA_REMARK"),"").replaceAll("<br>", "\r\n");  //  (조회조건)
st_atoa_remark = st_atoa_remark.replaceAll("&lt;br&gt;","\n");

String buyer = CommonUtil.nvl((String) request.getParameter("re_buyer"),"");
String quotation_no = CommonUtil.nvl((String) request.getParameter("re_quotation_no"),"");
String quotation_seq = CommonUtil.nvl((String) request.getParameter("re_quotation_seq"),"");
String revision = CommonUtil.nvl((String) request.getParameter("re_revision"),"");
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");
String st_title = CommonUtil.nvl((String) request.getParameter("st_title"),"");
%>
<script type="text/javascript"> 

function init(){
<%--    $("#st_btoa_remark").val(<%=st_btoa_remark%>); --%>
}

function kepConfirm()
{ 
	
  var st_atob_remark = $("#st_atob_remark").val();
  st_atob_remark = st_atob_remark.replace(/\r?\n/g, '<br>');
  
  var st_btoa_remark = $("#st_btoa_remark").val();
  st_btoa_remark = st_btoa_remark.replace(/\r?\n/g, '<br>');
  
  var st_atoa_remark = $("#st_atoa_remark").val();
  st_atoa_remark = st_atoa_remark.replace(/\r?\n/g, '<br>');
  
  
  document.forms.remarkform.re_buyer.value  = <%=buyer%>;            
  document.forms.remarkform.re_quotation_no.value  = <%=quotation_no%>;            
  document.forms.remarkform.re_quotation_seq.value  = <%=quotation_seq%>;            
  document.forms.remarkform.re_revision.value  = <%=revision%>;    
  document.forms.remarkform.re_atob_remark.value  =st_atob_remark;
  document.forms.remarkform.re_btoa_remark.value  = st_btoa_remark;
  document.forms.remarkform.re_atoa_remark.value  = st_atoa_remark;
  kepAjaxFormCallAsync("/mprq/saveRemarkPop.do","remarkform","saveRemarkPop");
}


function kepAjaxFormCallAsync(pUrl,pForm,pMethod) {    
	loader_obj("Y");
	$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: pUrl,
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: $("#"+pForm+"").serialize(),
		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT
		      async: false,
		      success:function( response ) {  	
		    	 loader_obj("N");
		    	 if(typeof response.Message != 'undefined'){
		    		 kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
		    		 return;
		    	} 
		    	 kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
			   },
			   error:function( response, textStatus) {
				   	loader_obj("N");
				   	if(textStatus == 'timeout'){
				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
				   	} 				   	
				 	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
				if(response.status == '403'){
					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
					location.href = "/login/sub_login.do";
					return;
				} 				  
				kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
			   }
		});  
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	  
    if(pMethod == "saveRemarkPop")  
    { 
    	alert("저장하였습니다.");    	    	      
    }
    this.close();
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {	
	if(pMethod == "saveRemarkPop")  
    { 
		alert("<%=CommonLang.msg("MSG228") %>");    	      
    }  	
	
} 

</script>  
<body onload="">
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
               		<th >고객사<br>▶<br>운영자</th>	
                <%
                	} else if ("ATOB".equals(st_title)) {
                %>  	
               		<th >운영사<br>▶<br>고객사</th>	
                <%
                	} else if ("ATOA".equals(st_title)) {
                %>  	
               		<th >고객사<br>▶<br>운영자</th>	
                <% } else { %>
                    <th >고객사</th> 		
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
               		<th >운영사<br>▶<br>고객사</th>	
                <%
                	} else if ("ATOB".equals(st_title)) {
                %>  	
               		<th >고객사<br>▶<br>운영자</th>	
                <%
                	} else if ("ATOA".equals(st_title)) {
                %>  	
               		<th >운영사<br>▶<br>고객사</th>		
                <% } else { %>
                    <th >운영사</th> 		
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
                    <th >운영사</th> 		
                    <td >
	                    <textarea name="st_atoa_remark" id="st_atoa_remark"  style="overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" <%=("R".equals(viewType))?"readonly" :"" %> ><%=st_atoa_remark%></textarea>
                    </td>
                </tr>
            </table>
                <% } %>      
<!--        	<textarea name="CONTEXT" id="CONTEXT"  rows="23"  style="width:100%"></textarea> -->
       	     <%
                	if (!"R".equals(viewType)) {
                %>  	
	       	<div class="btnArea ac mt20" style="margin-bottom:0px;"> 
			           	<span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span> 
			</div>
			<% } %> 		
        </div>
    </div>
    <form name="remarkform" id="remarkform" method="post">	
		<input type="hidden" name="re_buyer" id="re_buyer" value="" />		 
		<input type="hidden" name="re_quotation_no" id="re_quotation_no" value="" />
		<input type="hidden" name="re_quotation_seq" id="re_quotation_seq" value="" />
		<input type="hidden" name="re_revision" id="re_revision" value="" />
		<input type="hidden" name="re_atob_remark" id="re_atob_remark" value="" />
		<input type="hidden" name="re_btoa_remark" id="re_btoa_remark" value="" />
		<input type="hidden" name="re_atoa_remark" id="re_atoa_remark" value="" />
	</form>
</body>
</html>
