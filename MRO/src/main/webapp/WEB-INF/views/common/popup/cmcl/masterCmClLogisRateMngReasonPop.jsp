<%--
**********************************************
* 메뉴 : 마감관리 > 물류수수료율 등록 및 조회 > 저장 및 삭제 시 사유 입력 팝업
* 화면 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%

String popup_type = CommonUtil.nvl((String) request.getParameter("st_type"),""); // R : 저장, D: 삭제

%>
<script type="text/javascript">



function setReturn(){
	var reason = document.forms.logisRateMngReasonPop.st_reason.value;
	if(reason == null || reason == ""){
		alert("사유 입력바랍니다.");
		return;
	}
	
	opener.setPopupReturn(reason, '<%=popup_type%>');
  this.close();
}

</script> 
<body>
	 <form name=logisRateMngReasonPop id=logisRateMngReasonPop method=post >	  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:150px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
		
			<!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>사유</caption>
						<colgroup>
							<col width="100%" />
						</colgroup>						
						<tbody>
						<tr>
							<td>
								<textarea id="st_reason" name="st_reason" style="width: 99%;" rows="10"></textarea>
							</td>					 
						</tr>											 
					</tbody>
				</table>
            </div>
            <div class="btnArea">			
  			  <span class="fr">
	  			<span class="btn_02 mr04"><a href="javascript:setReturn();">확인</a></span>	  					 				
  			  </span>  			
		 </div>
    	</div>        
	</div>
	</form> 
</body>
</html>
