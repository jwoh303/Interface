<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
String remark = CommonUtil.nvl((String) request.getParameter("remark"),"");  //  (조회조건)
String reason = CommonUtil.nvl((String) request.getParameter("reason"),"");  //  (조회조건)
%>
<script type="text/javascript">
</script>
<body>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:200px;">
    	<div id="popHeader">
        	<h1 class="title">
        <%if(!remark.equals("")){%>
        		<%=CommonLang.get("HTITLE122")%><!-- 비고 -->
       	<%}else{%>
        		<%=CommonLang.get("HTITLE1168")%><!-- 구매사유 -->
       	<%}%>
        	</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 			<table >
                <tr>
                    <td height="5"></td>
                </tr>
            </table >
			<table class="cont_t_list05">
                <tr>
                    <td >
					<%if(!remark.equals("")){%>
						<textarea name="pr_remark" id="pr_remark" readonly="readonly" style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35"><%=remark%></textarea>
					<%}else{%>
						<textarea name="pr_remark" id="pr_remark" readonly="readonly" style="width:100%; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35"><%=reason%></textarea>
					<%}%>
                    </td>
                </tr>
            </table>
	 		<div class="btnArea">
				<span class="btn_02 mr04" title="확인" > <a href="javascript:self.close();"><%=CommonLang.get("HTITLE497")%><!-- 닫기 --></a></span>
			</div>
		</div>
	</div>
</body>
</html>
