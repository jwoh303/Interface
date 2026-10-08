<%--
**********************************************
* 메뉴 : 
* 화면 : 비용부서조회
* 기능 : 비용부서조회
* 프로그램 ID : PG_06_B_010_01
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-16
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
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 


String open      = CommonUtil.nvl((String) request.getParameter("open"),"");
 
String dept_nm = CommonUtil.nvl((String) request.getParameter("dept_nm"),"");  //  (조회조건)
String dept_cd = CommonUtil.nvl((String) request.getParameter("dept_cd"),"");  //  (조회조건)
String userDept       = _sessionInfo.getDepartment();
String user_id       = _sessionInfo.getUserId();
%>

<script type="text/javascript">
<!--

function kep_onload(){
	
	<% if ("Y".equals(open)){  %>
	kepSearch();
	<%}%>
}


function kepSearch()
{  
  $('#buyerUserCowayBudgetOrderListPop').attr("action", "/mpso/getBuyerUserCowayBudgetOrderListPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}
 
 //-->
</script> 
<body onload="kep_onload()">
<form name="buyerUserCowayBudgetOrderListPop" id="buyerUserCowayBudgetOrderListPop" method=post >
<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
<input type=hidden name="st_userDept" id="st_userDept"  value="<%=userDept%>"> 	
<input type=hidden name="st_user_id" id="st_user_id"  value="<%=user_id%>"> 	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:480px;">
    	<div id="popHeader">
        	<h1 class="title">비용부서조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>비용부서조회 리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="15%" />
							<col width="5%" />
							<col width="10%" />
							<col width="15%" /> 							
						</colgroup>						
						<tbody>
						<tr>
							<td>조직명</td>
							<td> 
								<input type=text name=dept_nm id="dept_nm" size=20 value="<%=dept_nm%>" onkeydown="kepEnter()" class="input_type_text" />
                            </td>
						    <td></td>						 
							<td>코드</td>
							<td> 
								<input type=text name=dept_cd id="dept_cd" size=20 value="<%=dept_cd%>" onkeydown="kepEnter()"  class="input_type_text"> 
                            </td>
						    <td></td>	
						  </tr>
						  <tr>
							<td>유형</td>
							<td> 
								<input name="" type="radio" value="" class="noline" checked> 오더 <input name="" type="radio" value="" class="noline" disabled> WBS
                            </td>	
                            <td></td>
                            <td></td>					    
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>비용부서조회 리스트</caption>
                    <colgroup>
                   		<col width="10%" /> 
                        <col width="30%" /> 
                        <col width="*" />  
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col">NO</th> 
                            <th scope="col">코드</th> 
                            <th scope="col">조직명</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j); 
    		
%> 
                        <tr>
                        		<td><%=rowData.get("NUM")%></td>
								 <td><a href="javascript:opener.setDeptAccount('<%=rowData.get("NODE_KEY")%>','<%=rowData.get("LTEXT")%>');self.close();"><%=rowData.get("NODE_KEY")%></a></td>
							     <td class="left"><a href="javascript:opener.setDeptAccount('<%=rowData.get("NODE_KEY")%>','<%=rowData.get("LTEXT")%>');self.close();"><%=rowData.get("LTEXT")%></a></td>
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
