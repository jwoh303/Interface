<%--
**********************************************
* 메뉴 : 
* 화면 : KEP 사업자번호 목록
* 기능 : 
* 프로그램 ID : PG_10_M_900_04
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
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
<title>KEP 사업자번호 목록</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
%>

<script type="text/javascript">
<!--
	function kepSearch()
	{  
	  $('#masterCmCoKEPCorpRegNoListPop').attr("action", "/cmco/getMasterCmCoKEPCorpRegNoListPop.do").submit();    
	}
	
	function kepEnter() {	
		if (event.keyCode == 13) { 
			kepSearch();
		}
	}
	
	function setReturn(value1,value2)
	{ 
	  opener.setPopupReturn(value1,value2);
	  this.close();
	}
 //-->
</script> 
<body onload="">
<form name="masterCmCoKEPCorpRegNoListPop" id="masterCmCoKEPCorpRegNoListPop" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">KEP 사업자번호 목록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div id="searchBtnA02"></div>   
           	<!--grid-->
            <div class="scrollArea" style="height:160px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>KEP 사업자번호 목록 리스트</caption>
                    <colgroup>
                        <col width="35%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">구분</th> 
                            <th scope="col">사업자번호</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if ( _dataList == null || _dataList.size() == 0 ) {
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "100px">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%
} else {
	for ( int j=0; j<_dataList.size(); j++ ) {
		Map<String,String> _tmp = _dataList.get(j);
%> 
					<tr>
						<td class="left pl10">
						 	<a href="javascript:setReturn('<%=_tmp.get("TEXT3")%>','<%=_tmp.get("TEXT4")%>','')"><%=_tmp.get("TEXT4")%></a>
						</td>
						<td>
						  	<a href="javascript:setReturn('<%=_tmp.get("TEXT3")%>','<%=_tmp.get("TEXT4")%>','')"><%=_tmp.get("TEXT3")%></a>
					   </td>
                    </tr> 
<%
	} 
}
%>                                 
                    </tbody>
                </table>                  
	        </div>
	    </div>        
	</div>
</form> 
</body>
</html>
