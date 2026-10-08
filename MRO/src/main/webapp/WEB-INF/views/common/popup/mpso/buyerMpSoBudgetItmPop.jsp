<%--
**********************************************
* 메뉴 : 
* 화면 : 예산비목
* 기능 : 동부한농 동부기술원 장바구니 관리코드 선택 팝업
* 프로그램 ID : PG_06_B_006_01
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-27
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
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
String st_row = CommonUtil.nvl((String) request.getParameter("st_row"),"");  //  (조회조건)
String st_ref_no = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
function fn_selSub()
{
    account_search = document.forms.buyerMpSoBudgetItmPop.account_search.value;

    if(account_search == "")
    {
        alert("예산비목을 선택하셔야 합니다.");
        return;
    }
    else
    { 
        opener.setDong0121(account_search, '<%=st_row%>');
        window.close();
    }
}
 //-->
</script> 
<body onload="">
<form name="buyerMpSoBudgetItmPop" id="buyerMpSoBudgetItmPop" method=post > 
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:350px;">
    	<div id="popHeader">
        	<h1 class="title">동부한농 동부기술원 예산비목</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 
            <table  class="cont_t_list02"  style="width:100%">
            	<tr>
            		<td>
            		예산비목
            		</td>
            		<td>
                  <select name="account_search" id="account_search" style="width:50%"> 
                  
                  								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("st_buyer",st_buyer); 
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getKrdong0121Account","NO",_map,st_ref_no) %>
								
								
      				</select>
      				</td>
      				</tr>
      		</table>
      
          				<div class="btnArea">
        	<div class="fr">
                	<span class="btn_03 mr04"><a href="javascript:fn_selSub();">확인</a>
                 </span>
                </div>
               </div>
    		</div>   
    		

                
                
                
    </div>   
</form> 
</body>
</html>
