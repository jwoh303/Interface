<%--
**********************************************
* 메뉴 : 
* 화면 : 홍익대학교 회계항목
* 기능 : 홍익대학교 관리번호(회계항목,계정과목) 선택 팝업
* 프로그램 ID : PG_06_B_006_07
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-28
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

String plant = "";
String cost = "";
String acnt = "";

if(st_ref_no.length() > 6){
	String _st_ref_no[] = st_ref_no.split("_");
	if (_st_ref_no.length > 0){
		plant = CommonUtil.nvl((String) request.getParameter("plant_search"),_st_ref_no[0]);
		cost = CommonUtil.nvl((String) request.getParameter("cost_search"),_st_ref_no[1]);
		acnt = CommonUtil.nvl((String) request.getParameter("acnt_search"),_st_ref_no[2]);
	}
}else if(st_ref_no.length() > 4){
	plant = CommonUtil.nvl((String) request.getParameter("plant_search"),st_ref_no.substring(0,4));
	cost = CommonUtil.nvl((String) request.getParameter("cost_search"),st_ref_no);
	acnt = CommonUtil.nvl((String) request.getParameter("acnt_search"),"");
}else{
	plant = CommonUtil.nvl((String) request.getParameter("plant_search"),"");
	cost = CommonUtil.nvl((String) request.getParameter("cost_search"),"");
	acnt = CommonUtil.nvl((String) request.getParameter("acnt_search"),"");
}

String text1 ="회계항목";
String text2 ="계정과목";
String text3 ="회계별";
%>

<script type="text/javascript">

function kep_onload(){
	<% if ("Y".equals(open)){ %>
	document.buyerMpSoHongikAccntngItemPop.plant_search.value = "";
	$('#buyerMpSoHongikAccntngItemPop').attr("action", "/mpso/showBuyerMpSoHongikAccntngItemPop.do").submit();   
	<%}%>
}

 
function change_cost() {

	var plant_search = document.buyerMpSoHongikAccntngItemPop.plant_search.value;
	if(plant_search == "")
	{
		alert("<%=text1%>를 선택하셔야 합니다.");
		return;
	}
	$('#buyerMpSoHongikAccntngItemPop').attr("action", "/mpso/showBuyerMpSoHongikAccntngItemPop.do").submit();   
}

function fn_selSub() {
	var cost_search = document.buyerMpSoHongikAccntngItemPop.cost_search.value; 
	var plant_search = document.buyerMpSoHongikAccntngItemPop.plant_search.value;
	var acnt_search = document.buyerMpSoHongikAccntngItemPop.acnt_search.value;
	var ref_pr_no = plant_search + "_" + cost_search + "_" + acnt_search;
	
	if(cost_search == ""||cost_search == "ALL" ){
		alert("<%=text2%> 선택하셔야 합니다.");
			return;
	} 
	opener.setHongik(ref_pr_no, "<%=st_row%>", ref_pr_no);
	window.close();
} 

</script> 
<body onload="kep_onload()">
<form name="buyerMpSoHongikAccntngItemPop" id="buyerMpSoHongikAccntngItemPop" method=post >
<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
<input type=hidden name="st_ref_no" id="st_ref_no"  value="<%=st_ref_no%>">
<input type=hidden name="st_row" id="st_row"  value="<%=st_row%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">회계항목</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"> 
            <!--조회영역-->
            <div id="cont_searchA">
            
            <table class="cont_t_list01" style="width:100%">
				<caption>회계항목 리스트</caption>
				<colgroup>
					<col width="30%" />
					<col width="*" /> 
				</colgroup>						
			<tbody>
				<tr>
					<td><%=text1%></td>
					<td>
					
						<select name="plant_search" id="plant_search" style="width:70%" onChange="change_cost();">
						
							<%
							Map<String, String> _map = new HashMap<String, String>();
							_map.put("st_buyer",st_buyer); 
							%>
							<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getShopCartSrcSql_01_AccntngItem","NO",_map,plant) %>
						
						
						</select>							
					
					</td> 	
				</tr>		
			
				<tr>
					<td><%=text2%></td>
					<td>
					
					<select name="cost_search" id="cost_search" style="width:70%">
					
					<% 
					_map.put("st_buyer",st_buyer); 
					_map.put("st_plant",plant); 
					%>
					<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getShopCartSrcSql_02_AccntngItem","SEL",_map,cost) %>
					
					
					</select>							
					
					</td> 	
				</tr>						
			 
			 	<tr>
					<td><%=text3%></td>
					<td>
					
					<select name="acnt_search" id="acnt_search" style="width:70%">
					
					<% 
					_map.put("st_buyer",st_buyer); 
					_map.put("st_acnt",acnt); 
					%>
					<%= CommonUtil.getCodeComboList("M178", "", acnt) %>
					
					
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
