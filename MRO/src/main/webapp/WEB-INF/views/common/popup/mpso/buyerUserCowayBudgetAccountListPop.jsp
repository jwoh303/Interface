<%--
**********************************************
* 메뉴 : 
* 화면 : 계정조회
* 기능 : 계정조회
* 프로그램 ID :PG_06_B_010_02
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

String open      = CommonUtil.nvl((String) request.getParameter("open"),""); 
String userDept       = _sessionInfo.getDepartment();

String st_buyer                 = CommonUtil.nvl((String)request.getParameter("st_buyer"),""); 
String st_userDept                = CommonUtil.nvl((String)request.getParameter("st_userDept"),""); 
String st_cart_sum_price        = CommonUtil.nvl((String)request.getParameter("st_cart_sum_price"),"0"); 
String account_nm               = CommonUtil.nvl((String)request.getParameter("account_nm"),""); 
String account_cd               = CommonUtil.nvl((String)request.getParameter("account_cd"),""); 
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
 	$('#buyerUserCowayBudgetAccountListPop').attr("action", "/mpso/getBuyerUserCowayBudgetAccountListPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
} 
 //-->
</script> 
<body onload="kep_onload()">
<form name="buyerUserCowayBudgetAccountListPop" id="buyerUserCowayBudgetAccountListPop" method=post >
<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>"> 
<input type=hidden name="st_userDept" id="st_userDept"  value="<%=st_userDept%>"> 	
<input type=hidden name="st_cart_sum_price" id="st_cart_sum_price"  value="<%=st_cart_sum_price%>"> 	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:470px;">
    	<div id="popHeader">
        	<h1 class="title">계정조회</h1>
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
						<caption>계정조회 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="20%" />
							<col width="5%" />
							<col width="25%" />
							<col width="30%" /> 
						</colgroup>						
						<tbody>
						<tr>
							<td>계정명</td>
							<td> 
								<input type=text name=account_nm id="account_nm" size=20 value="<%=account_nm%>" onkeydown="kepEnter()" class="input_type_text" > 
                            </td>
						    <td></td>						 
							<td>계정코드</td>
							<td> 
								<input type=text name=account_cd id="account_cd" size=20 value="<%=account_cd%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						    <td></td>	
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>계정조회 리스트</caption>
                    <colgroup>
				        <col width="30%" />
				        <col width="40%" />
				        <col width="30%" />
                    </colgroup>
                    <thead>
                        <tr>
                        	<th scope="col">계정코드</th> 
                            <th scope="col">계정명</th> 
                            <th scope="col">계정잔액</th> 
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
			              		<%
				                        // 사용가능한 예산이 있거나 , 예산미적용 계정일 경우 선택 가능하도록 설정
				                    if(rowData.get("PLAN_AMT_FLAG").equals("Y") && Double.parseDouble(rowData.get("MPAMT")) >= Double.parseDouble(st_cart_sum_price)){
				                %>
			              		<td><a href="javascript:opener.setBdgtAccount('<%=rowData.get("BGACT")%>','<%=rowData.get("ACTTX")%>');self.close();"><%=rowData.get("BGACT")%></a></td>
			              		<td> <a href="javascript:opener.setBdgtAccount('<%=rowData.get("BGACT")%>','<%=rowData.get("ACTTX")%>');self.close();"><%=rowData.get("ACTTX")%></a></td>
				                <td class="right"> <a href="javascript:opener.setBdgtAccount('<%=rowData.get("BGACT")%>','<%=rowData.get("ACTTX")%>');self.close();"><%=CommonUtil.formatNumber(rowData.get("MPAMT"),true,0,3)%></a></td>
				                <%
				                    }else{  // 예산적용 계정인데 0일 경우는 선택을 하지 못하도록 설정
				                %>
				                   <td> <%=rowData.get("BGACT")%></td>
				                   <td> <%=rowData.get("ACTTX")%></td>
				                   <td class="right"> <%=CommonUtil.formatNumber(rowData.get("MPAMT"),true,0,3)%></td>
				                <%
				                    }
				                %>
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
