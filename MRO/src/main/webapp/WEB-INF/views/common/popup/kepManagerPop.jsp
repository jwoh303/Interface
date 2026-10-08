<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); // 조회된결과
String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");  //  (조회조건)  
Map<String,String> rowData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	rowData = _dataList;
}
%>
<script type="text/javascript">
<!--
function setQuery()
{    
  $('#kepManagerPop').attr("action", "/common/kepManagerPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

function popupOnload(){
	//kepAjaxCommonQueryIdCombo('getWareHouseList','sampleCombo','SEL');
}
 

 //-->
</script> 
<body onload="">
	 <form name="kepManagerPop" id="kepManagerPop" method="post" >
	 <input type="hidden" name="st_user_id" id="st_user_id"  value="<%=st_user_id%>" /> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" >
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE146") %><!-- KeP 담당자 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div>
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>담당자 리스트</caption>
                    <colgroup>
                        <col width="20%" />  
                        <col width="40%" />  
                        <col width="40%" />    
                    </colgroup>
                    <thead>
                    	<tr>
                    		<th  scope="col"><%=CommonLang.get("HTITLE325") %><!-- 이름 --></th>
                    		<th  scope="col" colspan="2">
                            	<%=CommonLang.get("HTITLE326") %><!-- 전화번호 --> / <%=CommonLang.get("HTITLE43") %><!-- 팩스번호 --><br>
                    			<%=CommonLang.get("HTITLE41") %><!-- 이메일 -->
                    		</th>   
                    	</tr>
                    </thead>		   
                    <tbody>
                        <tr>
                           	<td rowspan="2"><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%></td>    
							<td><%=CommonUtil.nvl(rowData.get("PHONE_NUMBER"))%></td>
							<td><%=CommonUtil.nvl(rowData.get("FAX_NUMBER"))%></td>
						</tr>
						<tr>
							<td colspan="2">
								<a class="hyperLink" href="mailto:<%=CommonUtil.nvl(rowData.get("EMAIL"))%>"><%=CommonUtil.nvl(rowData.get("EMAIL"))%></a>
							</td>
                    </tbody>
                </table>  		 
        </div>
    </div>        
</div>
</form> 
</body>
</html>
