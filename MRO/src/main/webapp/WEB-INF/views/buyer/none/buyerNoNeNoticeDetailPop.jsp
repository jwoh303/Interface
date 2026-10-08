<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 공지사항 상세정보 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
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
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> rowData = (Map<String,String>) request.getAttribute("data"); // 조회된결과
String st_bid = CommonUtil.nvl((String) request.getParameter("st_bid"),"");
String st_btype = CommonUtil.nvl((String) request.getParameter("st_btype"),"");
String search_flag = CommonUtil.nvl((String) request.getParameter("search_flag"),"");
String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	<%
		if (!"Y".equals(search_flag)){
	%>
			setQuery();
	<%	
		}
	%>
}

function setQuery()
{ 
  $('#bellerNoNeNoticeDetailPop').attr("action", "/none/getbuyerNoNeNoticeDetailPop.do").submit();   
}

function  attach_popup(){	
	var type = "BOARD";
	var viewType = "R";
	var img_key = $("#IMAGE_KEY").val(); 	   	 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

 //-->
</script> 
<body onload="kep_onload_view()">
	 <form name=bellerNoNeNoticeDetailPop id=bellerNoNeNoticeDetailPop method=post >
	 	<input type="hidden" name="search_flag" value="Y"/>
	 	<input type="hidden" id="st_bid" name="st_bid" value="<%=st_bid%>"/>
	 	<input type="hidden" id="st_btype" name="st_btype" value="<%=st_btype%>"/>
	 	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>"/>
<%
if (rowData==null ){
%>
<%}else{ %>	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<input type="hidden" id="IMAGE_KEY" name="IMAGE_KEY" value="<%=rowData.get("IMAGE_KEY") %>"/>
	
	<div id="popWrapper" style="height:604px;">
    	<div id="popHeader">
        	<h1 class="title">공지사항</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:517px;">
        	<div class="scrollArea" style="height:500px">
				<table  class="board_write" >
					<caption>게시글 작성</caption>
					<colgroup>
						<col width="18%" />
						<col width="*" />
					</colgroup>
					<tbody>
					<tr>
			    		<th scope="row"><label for="u_SUBJECT">제목</label></th>
			    		<td><%=rowData.get("SUBJECT") %></td>
			    	</tr>
			    	<tr>
			    		<th scope="row"><label for="u_REG_USER_NAME">작성자</label></th>
			    		<td><%=rowData.get("REG_USER_NAME") %></td>
			    	</tr>
			    	<tr>
			    		<th scope="row"><label for="u_ACL">게시범위</label></th>
			    		<td><%=rowData.get("ACL_DIS") %></td>
			    	</tr>
			    	<tr>
			    		<th scope="row"><label for="u_FROM_DATE">게시기간</label></th>
			    		<td><%=rowData.get("FROM_DATE") %> - <%=rowData.get("TO_DATE") %></td>
			    	</tr>
			    	<tr>
			    		<th scope="row"><label for="u_CONTEXT">내용</label></th>
			    		<td>
			    			<textarea name="CONTEXT" id="CONTEXT"  rows="20" cols="200"><%=rowData.get("CONTEXT").replaceAll("<br>","\n") %></textarea>
			    		</td>
			    	</tr>
<% if( rowData.get("IMAGE_KEY") != null && !"".equals(rowData.get("IMAGE_KEY")) ){ %>
			    	<tr>
			    		<th scope="row"><label for="u_FILE">첨부파일</label></th>
			    		<td> 
			    		<a href="javascript:attach_popup();"> <img id="diskimg" src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>			
			            </td>
			    	</tr>
<% } %>
			    	</tbody>
			    </table>
			</div>
        </div>
    </div>         
<%}%>                     
</form> 
</body>
</html>
