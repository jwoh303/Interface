<%--
**********************************************
* 메뉴 : 벌크소싱 견적현황 > 벌크소싱 DM 발송이력
* 화면 : 벌크소싱 DM 발송이력
* 기능 : 
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>

<!doctype html>
<html>
<head>
<!-- <script src="/resources/js/common.js"></script> -->
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  

// String st_burq_no = CommonUtil.nvl((String) request.getParameter("burq_no"),"");
// String user_id = _sessionInfo.getUserId();
%>
<script type="text/javascript">
function kep_onload_view(){}
</script> 
<body onLoad="kep_onload_view()">
<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
<div id="popWrapper" style="height:120px;">
   	<div id="popHeader">
		<h1 class="title">협력사 메일발송 이력</h1>
		<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
	</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
            <!--조회영역-->
            <div>
            	<table style="width:100%;margin-top:10px;">
            		<thead>
            			<th align="center" >발송일시</th>
            			<th align="center" >발송자</th>
            			<th align="center" >수신자 이메일</th>
            		</thead>
            		<tbody>
					<%
        if (_dataList == null || _dataList.size() == 0){
        %>
        	<tr></tr>
            		<tr>
						<td class="TextTop" align="center" colspan="3"><b>조회된 데이터가 없습니다</b></td>
					</tr>        
		<%
        }else{
			for (int i = 0; i <_dataList.size(); i++) {
				Map<String,String> rowData = _dataList.get(i);
				
		%> 
						<tr>
							<td align="center" ><%=rowData.get("SEND_DATE")%>		</td>
							<td align="center" ><%=rowData.get("SEND_USER_NAME")%>		</td>
							<td align="center" ><%=rowData.get("RECV_ADDRESS")%>		</td>
						</tr>
            <%
        			}
        }
            %>
            	</tbod>
				</table>
            </div>
        </div>
    </div>        
</div>
</body>
</html>
