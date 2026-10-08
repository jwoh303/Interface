<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String st_req_user = CommonUtil.nvl((String) request.getParameter("st_req_user"),"");  //  (조회조건)
String st_req_user_remark = CommonUtil.nvl((String) request.getParameter("st_req_user_remark"),"");  //  (조회조건)
st_req_user_remark = st_req_user_remark.replaceAll("&lt;br&gt;","\n");

%>
<script type="text/javascript">

function kep_onload_view(){

}

function kepConfirm()
{ 
	var value1 = $("#st_req_user").val();
	var value2 = $("#st_req_remark").val();
	value2 = value2.replace(/\r?\n/g, '<br>');
 
	if(value1 == ""){
		alert("요청자를 입력하여 주십시오.");
		return;
	}
	if(value2 == ""){
		alert("요청내역을 입력하여 주십시오.");
		return;
	}
	
  opener.setPopupReturn(value1,value2);
  this.close();
}


</script>  
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:224px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">비고 수정 사유 입력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <!--팝업내용입니다-->
        <div id="popContainer">
        
			<table class="cont_t_list05" style="background-color: #FAF9CF;">
				<tr > 
					<td width="20%"><b>요청자</b></td>
					<td  width="80%" >
						<input type="text" id="st_req_user" name="st_req_user" style="width:98%;" value="<%=st_req_user%>">
					</td>
				</tr>
                <tr> 
                	<td width="20%"><b>요청내용</b></td>
                    <td width="80%" >
                        <textarea rows="4" id="st_req_remark"  name="st_req_remark"  style="width:100%;"><%=st_req_user_remark%></textarea>
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table>
	       	<div class="btnArea ac mt20" style="margin-bottom:0px;">   
	           <span class="fr btn_02"><a href="javascript:kepConfirm()">확인</a></span>
			</div> 	
        </div>
    </div>
</body>
</html>
