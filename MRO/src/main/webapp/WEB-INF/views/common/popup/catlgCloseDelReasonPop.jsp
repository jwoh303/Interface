<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String popup_type = CommonUtil.nvl((String) request.getParameter("st_type"),""); // C : 단종, D: 삭제
String title = "";

if(popup_type.equals("C")){
	title = "단종";
}else if(popup_type.equals("D")){
	title = "삭제";
}

%>
<script type="text/javascript">
var title = "<%=title%>";
var type = "<%=popup_type%>";

function setReturn(){
	var reason = document.forms.catlgCloseDelReasonPop.st_reason.value;
	var reason_text = document.getElementById("st_reason")[document.getElementById("st_reason").selectedIndex].text;
	
	if(reason == null || reason == ""){
		alert("<%=title%>" + " 사유를 선택하여 주시기 바랍니다.");
		return;
	}
	
	opener.setPopupReturn(reason, reason_text);
  this.close();
}

</script> 
<body>
	 <form name=catlgCloseDelReasonPop id=catlgCloseDelReasonPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="catlgCloseDelReasonPop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:150px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=title%> 사유 입력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
		
			<!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
					<caption>사유 입력</caption>
					하단 사유로 인해 선택하신 품목을 <%=title%>처리 하시겠습니까?
					
					<colgroup>
						<col width="80%" />
						<col width="20%" />
					</colgroup>
					
					<tbody>
						<tr>
							<td>
							<%if(popup_type.equals("C")){%>
								<select id="st_reason" name="st_reason"><%= CommonUtil.getCodeComboList("CC01", "SEL", "" , "", "", "") %></select>
							<%}else if(popup_type.equals("D")){%>
								<select id="st_reason" name="st_reason"><%= CommonUtil.getCodeComboList("CD01", "SEL", "" , "", "", "") %></select>
							<%}%>
							</td>
							<td  class="right">
								<span class="btn_search"><a href="javascript:setReturn();">확인</a></span> 
							</td>
						</tr>
					</tbody>
				</table>
            </div>            
           	<!--grid-->
    	</div>        
	</div>
	</form> 
</body>
</html>
