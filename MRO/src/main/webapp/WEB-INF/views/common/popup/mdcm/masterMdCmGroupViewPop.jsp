<%--
**********************************************
* 메뉴 : 
* 화면 : 그룹보기 
* 기능 : 그룹정보 보기 팝업
* 프로그램 ID : PG_03_M_001_02
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-06-10
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  //  (조회조건)  
String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  //  (조회조건)
String status_flag = CommonUtil.nvl((String) request.getParameter("status_flag"),"");
%>

<script type="text/javascript">
<!--
function popupOnload(){
	var status_flag = document.forms[0].status_flag.value;
	if(status_flag!='N'){
		setQuery();
	}
}

function setQuery()
{  
	document.forms[0].status_flag.value = "N";	
	$('#masterMdCmGroupViewPop').attr("action", "/mdcm/getMasterMdCmGroupViewPop.do").submit();    
}
 //-->
 
</script> 
<body onload="popupOnload();">
<form name="masterMdCmGroupViewPop" id="masterMdCmGroupViewPop" method=post >
<input type="hidden" name="st_buyer_code" id="st_buyer_code"  value="<%=st_buyer_code%>">
<input type=hidden name="st_buyer_name" id="st_buyer_name"  value="<%=st_buyer_name%>">
<input type = "hidden" name = "status_flag" id="st_buyer_name"  value = "<%=status_flag%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">그룹보기 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--grid-->
            <div class="scrollArea" style="height:433px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>그룹보기  리스트</caption>
                    <colgroup>
                        <col width="20%" /> 
                        <col width="25%" />
                        <col width="10%" />
                        <col width="20%" /> 
                        <col width="25%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">고객사코드</th> 
                            <th scope="col">고객사명</th>
                            <th scope="col">카탈로그관리단위</th>
                            <th scope="col">그룹코드</th> 
                            <th scope="col">그룹명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td>
							<%=_tmp.get("COM_CODE")%>
						</td>
						<td class="left" >
							<%=_tmp.get("COM_NAME_LOC")%>
					   </td>
						<td>
							<%=_tmp.get("BYCA_COMORG_LEVEL")%>
						</td>
						<td>
							<%=_tmp.get("BYCA_COMORG_CODE")%>
					   </td>
					   <td class="left" >
							<%=_tmp.get("COMORG_NAME")%>
					   </td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
