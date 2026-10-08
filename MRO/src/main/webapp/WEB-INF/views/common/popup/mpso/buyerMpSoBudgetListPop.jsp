<%--
**********************************************
* 메뉴 : 
* 화면 : 예산조회
* 기능 : 예산조회
* 프로그램 ID : PG_06_B_006_60
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-05-23
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

String st_select_year=  CommonUtil.nvl((String) request.getParameter("st_select_year"),"");
String st_account_type = CommonUtil.nvl((String) request.getParameter("st_account_type"),"ALL");  //  (조회조건)
String st_term_type = CommonUtil.nvl((String) request.getParameter("st_term_type"),"ALL");  //  (조회조건)


String SessionUserName = "";  
String SessionComCode = "";
String SessionUserId = "";
String SessionUserDept = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	SessionUserName =  CommonUtil.nvl((String)sessionInfo.getDepartmentName());  
	SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
	SessionUserId =  CommonUtil.nvl((String)sessionInfo.getUserId());  
	SessionUserDept =  CommonUtil.nvl((String)sessionInfo.getDepartment());  
}  

String req_date			  = CommonUtil.formatDateNoDateGubun(new Date(),1);
String year				=  req_date.substring(0,4);
String month			=  req_date.substring(4,6);
String day				=  req_date.substring(6,8);

if ("".equals(st_select_year)){
	st_select_year = year;
}

%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#buyerMpSoBudgetListPop').attr("action", "/mpso/getBuyerAdminBudgetListSql.do").submit();    
}

function kepEraser(){
	
	kepReload("buyerMpSoBudgetListPop"); 
	
	$("#st_select_year").val("<%=year%>");
}
 
function kep_remark(st_btoa_remark){
	
	//st_btoa_remark = "st_btoa_remarkst_btoa_remarkst_btoa_remarkst_btoa_remarkst_btoa_remarkst_btoa_remarkst_btoa_remarkst_btoa_remark";
	
	if(st_btoa_remark == ""){
		alert("비고 내역이 없습니다.");
		return;
	}
	
	openSearchPopup("/common/remarkBtoAPop.do","?st_btoa_remark="+st_btoa_remark , "500,220,no"); 
}
 
function setPopupReturn(value1,value2) {
	
}
 
 
 //-->
</script> 
<body onload="">
<form name="buyerMpSoBudgetListPop" id="buyerMpSoBudgetListPop" method=post > 
	
<input type="hidden" name = "st_buyer"          value = "<%= SessionComCode %>">
<input type="hidden" name = "userID"            value = "<%= SessionUserId %>">
<input type="hidden" name = "change_user_dept"  value = "<%= SessionUserDept %>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:488px;">
    	<div id="popHeader">
        	<h1 class="title">부서예산조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            	<span class="btn_reset"><a href="javascript:kepEraser();">초기화</a></span>
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>예산조회보기 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>						
						<tbody>
						<tr>
							<th>부서명</th>
							<td><%=SessionUserName%></td>
						    <th>조회년도</th>						 
							<td>
							<%=st_select_year %><input type="hidden" name="st_select_year" value="<%=st_select_year %>"> 
							 </td>				
						</tr>					 
						<tr>
						    <th>예산편성기간</th>						 
							<td>
							<select name="st_term_type" style="width:150px">				
				            <option value = "ALL" <% if (st_term_type.equals("ALL")) { %> selected <%} %>>당월예산</option>			
				            <%
				            Map<String, String> search = new HashMap<String, String>();
				            search.put("SessionComCode",SessionComCode);
				            search.put("SessionUserDept",SessionUserDept);
				            if(!SessionComCode.equals("KRISER0001")) {
				            %>
							<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getTermType","NO",search,st_term_type) %>
						<%}%>
				          </select>
				          </td>									
							<th>계정분류</th>
							<td><select name="st_account_type" style="width:150px">				

       				            <%
				            Map<String, String> search1 = new HashMap<String, String>();
       				        search1.put("SEARCH",SessionComCode);
       				        search1.put("SessionUserDept",SessionUserDept);
       				
				            %>
							<%= CommonUtil.getCodeComboQueryIdList("common.mpso.getAccountTypeSelect","ALL",search1,st_account_type) %>
					

          </select></td> 
						</tr>								
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:290px;width:100%">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>예산조회보기 리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="25%" /> 
                        <col width="5%" /> 
                        <col width="10%" /> 
                        <col width="8%" /> 
                        <col width="6%" /> 
                        <col width="6%" /> 
                         <col width="6%" /> 
                         <col width="5%" /> 
                         <col width="8%" /> 
                         <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">예산<br>부서</th> 
                            <th scope="col">계정<br>분류</th> 
                            <th scope="col">기간<br>구분</th>
                            <th scope="col">기간</th> 
                            <th scope="col">예산</th> 
                            <th scope="col">실적금액</th> 
                            <th scope="col">임시실적금액</th> 
                            <th scope="col">잔액</th> 
                            <th scope="col">비고</th> 
                            <th scope="col">예산수립일</th>
                            <th scope="col">최종실적<br>발생일</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="15" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
%> 
                        <tr>
						<td class="left"> <%=_tmp.get("DEPT_NAME")%> </td>
						<td class="left"> <%=_tmp.get("ACCOUNT_TYPE_NAME")%> </td> 
						<td> <%=_tmp.get("TERM_TYPE")%> </td> 
						<td class="left"> <%=_tmp.get("TERM_TEXT")%> </td> 
						<td class="right"> <%=CommonUtil.formatNumber(_tmp.get("PLAN_AMT"),true,0,3)%> </td> 
						<td class="right"> <%=CommonUtil.formatNumber(_tmp.get("RESULT_AMT"),true,0,3)%> </td> 
						<td class="right"> <%=CommonUtil.formatNumber(_tmp.get("TEMP_AMT"),true,0,3)%> </td> 
						<td class="right"> <%=CommonUtil.formatNumber(_tmp.get("MONEY"),true,0,3)%></td> 
						<td>
						<a href="javascript:kep_remark('<%=_tmp.get("REMARK")%>')">
						<img src="/resources/images/but_img_<%=_tmp.get("REMARK_IMG")%>"  border="0">
						</a>
						<input type="hidden"   name="st_remark"	value="<%=_tmp.get("REMARK")%>">
						</td> 
						<td> <%=CommonUtil.formatStrinigDate(_tmp.get("PLAN_DATE"))%></td> 
						<td> <%=CommonUtil.formatStrinigDate(_tmp.get("LAST_RESULT_DATE"))%></td>  
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
