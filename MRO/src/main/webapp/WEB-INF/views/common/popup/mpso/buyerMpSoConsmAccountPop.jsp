<%--
**********************************************
* 메뉴 : 
* 화면 : 소모품계정과목
* 기능 : 셰플러안산 장바구니 관리번호 선택 팝업
* 프로그램 ID : PG_06_B_006_04
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
String open = CommonUtil.nvl((String) request.getParameter("open"),"");

String plant = CommonUtil.nvl((String) request.getParameter("plant_search"),"");
String cost = CommonUtil.nvl((String) request.getParameter("cost_search"),"");
String account = CommonUtil.nvl((String) request.getParameter("account_search"),"");

if(!st_ref_no.equals(""))
{
    plant = st_ref_no.substring(0,2);
    cost = st_ref_no.substring(2,6);
    account = st_ref_no.substring(6,14);
}
%>

<script type="text/javascript">
<!--


function kep_onload(){
	
	<% if ("Y".equals(open)){ %>
	 change_cost();
	<%}%>
}
function fn_selSub()
{
    var plant_search = document.buyerMpSoConsmAccountPop.plant_search.value;
    var cost_search = document.buyerMpSoConsmAccountPop.cost_search.value;
    var account_search = document.buyerMpSoConsmAccountPop.account_search.value;

    if(plant_search == "")
    {
        alert("Category를 선택하셔야 합니다.");
        return;
    }
    else if(cost_search == "")
    {
        alert("Cost Center를 선택하셔야 합니다.");
        return;
    }
    else if(account_search == "")
    {
        alert("Account를 선택하셔야 합니다.");
        return;
    }
    else
    {
//        alert(plant_search+cost_search+account_search);
        opener.setInaKorea(plant_search+cost_search+account_search, '<%=st_row%>');
        window.close();
    }
}

function change_cost() {
	
	var plant_search = document.buyerMpSoConsmAccountPop.plant_search.value; 
    if(plant_search == "")
    {
        alert("Category를 선택하셔야 합니다.");
        return;
    } 
	$('#buyerMpSoConsmAccountPop').attr("action", "/mpso/showBuyerMpSoConsmAccountPop.do").submit();   
}
 //-->
</script> 
<body onload="kep_onload()">
<form name="buyerMpSoConsmAccountPop" id="buyerMpSoConsmAccountPop" method=post > 
	<input type="hidden" name="st_buyer" id="st_buyer" value="<%=st_buyer %>" />
	<input type="hidden" name="st_row" id="st_row" value="<%=st_row %>" />
	<input type="hidden" name="st_ref_no" id="st_ref_no" value="<%=st_ref_no %>" />
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:350px;">
    	<div id="popHeader">
        	<h1 class="title">소모품 계정과목</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 			
 		<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>소모품 계정과목 리스트</caption>
						<colgroup>
							<col width="30%" />
							<col width="*" /> 
						</colgroup>						
						<tbody>
						<tr>
							<td>Category</td>
							<td>
							
			                  <select name="plant_search" id="plant_search" style="width:90%" onChange="change_cost();">
			                  
			                  								<%
									 			Map<String, String> _map = new HashMap<String, String>();
									 			_map.put("st_buyer",st_buyer); 
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getShopCartSrcSql_01","NO",_map,plant) %>
											
											
			      				</select>							
							
							</td> 	
						</tr>		
						
						<tr>
							<td>Cost Center</td>
							<td>
							
			                  <select name="cost_search" id="cost_search" style="width:90%">
			                  
			                  								<% 
									 			_map.put("st_buyer",st_buyer); 
			                  					_map.put("st_plant",plant); 
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getShopCartSrcSql_02","SEL",_map,cost) %>
											
											
			      				</select>							
							
							</td> 	
						</tr>						
						
						<tr>
							<td>Account</td>
							<td>
							
			                  <select name="account_search" id="account_search" style="width:90%">
			                  
			                  								<% 
									 			_map.put("st_buyer",st_buyer); 
											%>
											<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getShopCartSrcSql_03","SEL",_map,account) %>
											
											
			      				</select>							
							
							</td> 	
						</tr>			
						
														
						</tbody>
			</table>
		</div>			 
            

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
