<%--
**********************************************
* 메뉴 : 
* 화면 : 납품정보 변경 상세 팝업
* 기능 :
* 프로그램 ID :
* 담당자 : HSJ ( 설계 :  )
* 착수일 : 2023-12-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String st_type = CommonUtil.nvl((String) request.getParameter("value1"),"");  //  (조회조건)
String st_buyer = CommonUtil.nvl((String) request.getParameter("value2"),"");  //  (조회조건)
String st_po_no = CommonUtil.nvl((String) request.getParameter("value3"),"");  //  (조회조건)
String st_po_seq = CommonUtil.nvl((String) request.getParameter("value4"),"");  //  (조회조건)
String st_ds_seq = CommonUtil.nvl((String) request.getParameter("value5"),"");  //  (조회조건)
String st_seq = CommonUtil.nvl((String) request.getParameter("value6"),"");  //  (조회조건)
String st_agent = CommonUtil.nvl((String) request.getParameter("value7"),"");  //  (조회조건)
Map<String,String> rowData = null;

if (_dataList==null || _dataList.size()==0) {
}else {
	rowData = _dataList.get(0);
}
%>
<script type="text/javascript">
function kep_onload_view() {
	<%
		if (_dataList==null || _dataList.size()==0){
	%>
			setQuery();
	<%	
		}
	%>
}

function setQuery() {
  $('#sellerMpIvIvInfoChangeDetailPop').attr("action", "/mpiv/getSellerMpIvIvInfoChangeDetailPop.do").submit();   
}

function kepEnter() {
	if (event.keyCode == 13) {
		setQuery();
	}
}
</script> 
<body onload="kep_onload_view()">
	 <form name="sellerMpIvIvInfoChangeDetailPop" id="sellerMpIvIvInfoChangeDetailPop" method="post">
	 <input type="hidden" name="st_type" id="st_type" value="<%=st_type%>"/>
	 <input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer%>"/>
	 <input type="hidden" name="st_po_no" id="st_po_no" value="<%=st_po_no%>"/>
	 <input type="hidden" name="st_po_seq" id="st_po_seq" value="<%=st_po_seq%>"/>
	 <input type="hidden" name="st_ds_seq" id="st_ds_seq" value="<%=st_ds_seq%>"/>
	 <input type="hidden" name="st_seq" id="st_seq" value="<%=st_seq%>"/>
	 <input type="hidden" name="st_agent" id="st_agent" value="<%=st_agent%>"/>
<%
if (_dataList==null || _dataList.size()==0) {
%>
<%
} else {
%>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
        <div id="popHeader">
			<h1 class="title">납품정보 변경 상세</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		
        <!--팝업내용입니다-->
		<div id="popContainer">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		        <tr> 
		            <td valign="bottom">
		                <span style="text-align:left;">
		                	<b>■ 요청 내역</b><br>
		                </span>
		                
		                <table width="100%" class="cont_t_list06">
			                <colgroup>
					            <col width="20%" />
					            <col width="*" />
					        </colgroup>
					        
					        <tr> 
		                        <th>요청사항</th>
		                        <td style="text-align: center;">납품정보 변경</td>
		                    </tr>
		                    <tr> 
		                        <th>상세</th>
		                        <td>
		                        	- 사유 : <%=CommonUtil.nvl(rowData.get("AGENT_REMARK"))%>
								</td>
		                    </tr>
		                </table>
		               
		                <br><br>
		                
		                <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">
		                    <tr>
		                        <td align="center">
		                        	<span class="btn_04"><a href="javascript:self.close()">닫기</a></span>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		</div>
    </div>         
<%}%>                     
</form> 
</body>
</html>