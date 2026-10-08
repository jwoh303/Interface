<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
	String buyer			= request.getParameter("st_buyer");
	String quotation_no		= request.getParameter("st_quotation_no");
	String quotation_seq	= request.getParameter("st_quotation_seq");
	String revision			= request.getParameter("st_revision");
	String atos_remark = CommonUtil.nvl((String) request.getParameter("st_atos_remark"),"");  //  (조회조건)
	atos_remark = atos_remark.replaceAll("&lt;br&gt;","\n");
	atos_remark = atos_remark.replaceAll("%26","&");
	String stoa_remark = CommonUtil.nvl((String) request.getParameter("st_stoa_remark"),"");  //  (조회조건)
	stoa_remark = stoa_remark.replaceAll("&lt;br&gt;","\n");
	
%>
<script type="text/javascript">

function init(){
<%--    $("#st_atos_remark").val(<%=atos_remark%>); --%>
<%--    $("#st_stoa_remark").val(<%=stoa_remark%>); --%>
//    $("#st_atob_remark").val("");
   
//   opener.setPopupReturn(value1,"");
//   this.close();
}

function kepConfirm()
{ 
  var value1 = $("#st_stoa_remark").val();
  value1 = value1.replace(/\r?\n/g, '<br>');
  opener.setPopupReturn(value1,"");
  this.close();
}

</script>  
<body >

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:312px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table class="cont_t_list05">
				<tr> 
					<th width="21%">KEP</th>
					<td>
						<textarea rows="4" style="background-repeat:no-repeat;border:solid 0;background-position:center;width:97%;" readonly="readonly"><%=atos_remark%></textarea>
					</td>
				</tr>
			</table>        
             <table class="cont_t_list05">
                <tr> 
             		<th width="21%">협력사<br>▶<br>운영사</th>
						<td align="center" height="90">
								<textarea id="st_stoa_remark" name="st_stoa_remark" rows="7" style="background-repeat:no-repeat;background-position:center;width:97%"><%=stoa_remark%></textarea>
						</td>
                </tr>
            </table>
	       	<div class="btnArea ac mt15" style="margin-bottom:0px;"> 
	           	<span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span>
			</div> 	
        </div>
    </div>    
</body>
</html>
