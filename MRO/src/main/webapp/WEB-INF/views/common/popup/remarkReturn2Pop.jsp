<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String st_return_remark = CommonUtil.nvl((String) request.getParameter("st_return_remark"),"");  //  (조회조건)
String st_gubun = CommonUtil.nvl((String) request.getParameter("st_gubun"),"N");  //  (조회조건)
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)
st_return_remark = st_return_remark.replaceAll("&lt;br&gt;","\n");
%>

<script type="text/javascript">

function init(){
}

function kepConfirm()
{ 
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, '<br>');
  	var value2 = "";
  	opener.setPopupReturn(value1, value2);
  	this.close();
}
//운영특이사항 return
function remarkConfirm()
{
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, ' ');
  	var value2 = "";
  	opener.setRemarkPopupReturn(value1, value2);
  	this.close();
}
//품목정비 제출 return
function itemChgConfirm(){
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, ' ');
  	var value2 = "";
  	opener.setItemChgPopupReturn(value1, value2);
  	this.close();	
}
//추가정비 제출 return
function afterItemChgConfirm(){
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, ' ');
  	var value2 = "";
  	opener.setAfterItemChgPopupReturn(value1, value2);
  	this.close();	
}
//네고정비 제출 return
function negoItemChgConfirm(){
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, ' ');
  	var value2 = "";
  	opener.setNegoItemChgPopupReturn(value1, value2);
  	this.close();	
}
//SG지정 재요청 return
function sgDChgConfirm(){
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, ' ');
  	var value2 = "";
  	opener.setSgDChgPopupReturn(value1, value2);
  	this.close();	
}
// 견적진행조회 ANY 정비 제출 return
function anyItemChgConfirm(){
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, ' ');
  	var value2 = "";
  	opener.setAnyItemChgPopupReturn(value1, value2);
  	this.close();	
}
function kepConfirm2() // SCM비고 저장
{ 
	var value1 = $("#st_return_remark").val();
	value1 = value1.replace(/\r?\n/g, '<br>');
	
	$.ajax({
	      type: "POST",
	      dataType:"json",
	      url: "/mprq/saveScmRemark.do",
	      headers: { 'X-Requested-With': 'XMLHttpRequest' },
	      data: { st_return_remark:value1,st_buyer: $("#st_buyer").val(),st_quotation_no: $("#st_quotation_no").val(),st_quotation_seq: $("#st_quotation_seq").val(),st_revision: $("#st_revision").val()},
	     async : false,
	     success:function( response ) {
	    	 alert(response.Message);
	    	 
	    	 opener.doAction('search');
	    	 parent.close();
		      },
		 error:function( response ) {  	
			 alert(response.Message);
		      }	
	 }); 
	
}

</script>  
<body onload="" >
	<form id="remarkReturn2Pop" name="remarkReturn2Pop">
	<input type="hidden" id="st_buyer"  name="st_buyer" value="<%=st_buyer %>">	
	<input type="hidden" id="st_quotation_no"  name="st_quotation_no" value="<%=st_quotation_no%>">	
	<input type="hidden" id="st_quotation_seq"  name="st_quotation_seq" value="<%=st_quotation_seq%>">	
	<input type="hidden" id="st_revision"  name="st_revision" value="<%=st_revision%>">	
		<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
		<div id="popWrapper" style="height:232px; min-height: 100px;">
	    	<div id="popHeader">
	    	<%if("REMARK".equals(st_gubun)) { %><!-- 운영특이사항 비고 일괄 입력 -->
	        	<h1 class="title">운영 특이사항</h1>
	    	<%}else if("ITEMCHG".equals(st_gubun)) { %><!-- 품목정비 제출 -->
	        	<h1 class="title">품목정비 제출</h1>
	        <%}else if("AFTERITEMCHG".equals(st_gubun)) { %><!-- 추가정비 제출 -->
	        	<h1 class="title">추가정비 제출</h1>
        	<%}else if("NEGOITEMCHG".equals(st_gubun)) { %><!-- 네고정비 제출 -->
        		<h1 class="title">네고정비 제출</h1>
       		<%}else if("SGDCHG".equals(st_gubun)) { %><!-- SG지정 재요청 -->
        		<h1 class="title">SG지정 재요청</h1>
        	<%}else if("ANYITEMCHG".equals(st_gubun)) { %><!-- 견적진행조회 ANY 정비 제출 -->
        		<h1 class="title">정비 제출</h1>
	        <%}else{%>
	        	<h1 class="title">내용</h1>
	        <%}%>
	            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	        </div>
	        <!--팝업내용입니다-->
	        <div id="popContainer">
	
				<table class="cont_t_list05" >
	                <tr> 
	                    <th >비고</th>
	                    <td >
	                        <textarea id="st_return_remark" name="st_return_remark"  style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="7" cols="35"  ><%=st_return_remark %></textarea>
	                    </td>
	                </tr>
	            </table>
	            <table >
	                <tr> 
	                    <td></td>
	                </tr>
	            </table>
	             <%
	               	if ("RQ".equals(st_gubun)) {
	               %>  			
		       	<div class="btnArea ac mt10" style="margin-bottom:0px;">   
		           	<span class="fr btn_02"><a href="javascript:kepConfirm2()">확인</a></span> 
				</div>
				<%} else if ("KEP".equals(st_gubun)) { %>
				<%} else if ("REMARK".equals(st_gubun)) { %><!-- 운영특이사항 비고 일괄 입력 -->
					<span class="fr btn_02"><a href="javascript:remarkConfirm()">확인</a></span>
				<%} else if ("ITEMCHG".equals(st_gubun)) { %><!-- 품목정비 제출 -->
					<span class="fr btn_02"><a href="javascript:itemChgConfirm()">확인</a></span>
				<%} else if ("AFTERITEMCHG".equals(st_gubun)) { %><!-- 추가정비 제출 -->
					<span class="fr btn_02"><a href="javascript:afterItemChgConfirm()">확인</a></span>
				<%} else if ("NEGOITEMCHG".equals(st_gubun)) { %><!-- 네고정비 제출 -->
					<span class="fr btn_02"><a href="javascript:negoItemChgConfirm()">확인</a></span>
				<%} else if ("SGDCHG".equals(st_gubun)) { %><!-- SG지정 재요청 -->
					<span class="fr btn_02"><a href="javascript:sgDChgConfirm()">확인</a></span>
				<%} else if ("ANYITEMCHG".equals(st_gubun)) { %><!-- 견적진행조회 ANY 정비 제출 -->
					<span class="fr btn_02"><a href="javascript:anyItemChgConfirm()">확인</a></span>
				<%} else { %>
		       	<div class="btnArea ac mt10" style="margin-bottom:0px;">   
		           	<span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span> 
				</div> 	
				<%} %>
	        </div>
    	</div>
    </form>
</body>
</html>
