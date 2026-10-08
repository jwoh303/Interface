<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
// String st_atos_remark = CommonUtil.nvl((String) request.getParameter("st_atos_remark"),"");  //  (조회조건)
// String st_stoa_remark = CommonUtil.nvl((String) request.getParameter("st_stoa_remark"),"");  //  (조회조건)
String viewType = CommonUtil.nvl((String) request.getParameter("viewType"),"");  //  (조회조건)
// String titleType = CommonUtil.nvl((String) request.getParameter("titleType"),"");  //  (조회조건)
%>
<script type="text/javascript">

function init(){
<%--    $("#st_btoa_remark").val(<%=st_btoa_remark%>); --%>
//    $("#st_atob_remark").val("");
   
//   opener.setPopupReturn(value1,"");
//   this.close();

}

function kepConfirm()
{ 
	var frm = document.forms[0];
	var reason = "";
		if(frm.st_giveup_reason[4].checked) {
			var aa = frm.st_giveup_reason_etc.value;
			if(aa.length < 5 ){ 
				alert("기타사유를 5자리 이상으로 입력 바랍니다.");
				frm.st_giveup_reason_etc.focus();
				return;
			}
		}
		var length = frm.st_giveup_reason.length;
		for(var i=0; i<length; i++){
			if(frm.st_giveup_reason[i].checked){
				if(frm.st_giveup_reason[4].checked){
					reason = frm.st_giveup_reason_etc.value; 
				}else{
					reason = frm.st_giveup_reason[i].value;
				}
				break;		
			} 
		}
  opener.AgentGiveUp(reason);
  this.close();
}

function setReason(){
	$("#st_giveup_reason_etc").focus();
}

</script>  
<!-- <body onload=""> -->
<body >
<form>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:402px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:327px;">
        <input type="hidden" id="viewType" name="viewType" value="<%=viewType%>"/>
			<table class="cont_t_list05">
					<tr>
						<td bgcolor="6DAEE7" height="2"></td>
					</tr>
					<tr bgcolor="E7F5FF">
						<td height="20">
							&nbsp;<input class="Noborder"  type="radio" name="st_giveup_reason" value="제작불가 품목(스페셜제작, 정밀가공 등)" >&nbsp;<b>제작불가 품목(스페셜제작, 정밀가공 등)</b>
						</td>
					</tr>
					<tr bgcolor="E7F5FF">
						<td height="20">
							&nbsp;<input class="Noborder"  type="radio" name="st_giveup_reason" value="자재 수급불가 품목" >&nbsp;<b>자재 수급불가 품목</b>  
						</td>
					</tr>
					<tr bgcolor="E7F5FF">
						<td height="20">
							&nbsp;<input class="Noborder"  type="radio" name="st_giveup_reason" value="미취급 품목" >&nbsp;<b>미취급 품목</b>  
						</td>
					</tr>
					<tr bgcolor="E7F5FF">
						<td height="20">
							&nbsp;<input class="Noborder"  type="radio" name="st_giveup_reason" value="단종 품목(대체품 無)" >&nbsp;<b>단종 품목(대체품 無)</b>  
						</td>
					</tr>
					<tr bgcolor="E7F5FF">
						<td height="20">
							&nbsp;<input class="Noborder"  type="radio" name="st_giveup_reason" value="기타" onclick="setReason();">&nbsp;<b>기타</b> 
						</td>
				    </tr>
					<tr>
						<td bgcolor="6DAEE7" height="2"></td>
					</tr>
					<tr>
						<td height="32">
							<table style="width:100%;">
								<tr>
									<td width="80" class="font1_table_1">&nbsp;&nbsp;<img src="/resources/images/br_00.gif"> 기타 사유</td>
									<td > 
										<textarea id="st_giveup_reason_etc" name="st_giveup_reason_etc" rows="3" cols="45" ></textarea>
									</td>
								</tr>
							</table> 		
						</td>
					</tr>
					<tr>
						<td bgcolor="6DAEE7" height="2"></td>
					</tr>
            </table>
            <%
                	if (!"R".equals(viewType)) {
                %>  	                 	       	
	       	<div class="btnArea ac mt20" style="margin-bottom:0px;"> 
	           <span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span>
			</div> 	
			<%
                	}
                %>  		
        </div>
    </div>
</form>    
</body>
</html>
