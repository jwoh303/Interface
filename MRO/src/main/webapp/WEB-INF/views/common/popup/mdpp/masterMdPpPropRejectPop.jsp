<%--
**********************************************
* 메뉴 : 개선제안제도 > 개선제안현황 > 불채택 사유 팝업
* 화면 : 불채택 사유 팝업
* 기능 : 불채택 사유 팝업
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 현명환 )
* 착수일 : 2016-01-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
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
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
Map<String,String> rowData = _dataList != null && _dataList.size() > 0 ? _dataList.get(0) : null;

String sessionUserId = _sessionInfo.getUserId();
String sessionComCode = _sessionInfo.getComCode();

String st_pp_no = CommonUtil.nvl((String) request.getParameter("st_pp_no"), "");
%>

<script type="text/javascript">
var popupSel = "";

</script> 
<body onload="">
	<form name="masterMdPpPropDetailPop" id="masterMdPpPropDetailPop" method="post" >
		 <input type="hidden" id="st_user_id" name="st_user_id"	value="<%=sessionUserId %>">
		 <input type="hidden" id="st_pp_no" name="st_pp_no"	value="<%=st_pp_no %>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:225px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">불채택 사유</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

			<table class="cont_t_list05" >
                <tr> 
                    <th >불채택 사유</th>
                    <td >
                        <textarea id="st_btoa_remark" name="st_btoa_remark"  readOnly style="width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0;" rows="5" cols="35" ><%=rowData.get("PP_R_REMARK")%></textarea>
                    </td>
                </tr>
            </table>
            <table >
                <tr> 
                    <td></td>
                </tr>
            </table><br/><br/>	<br/>		
        </div>
    </div>
</form> 
</body>
</html>
