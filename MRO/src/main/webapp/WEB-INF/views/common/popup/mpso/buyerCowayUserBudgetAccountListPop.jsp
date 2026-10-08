<%--
**********************************************
* 메뉴 : 
* 화면 : 부서예산조회
* 기능 : 부서예산조회
* 프로그램 ID : PG_06_B_010_03
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-16
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
String userDept=  CommonUtil.nvl((String) request.getParameter("st_dept_code"), _sessionInfo.getDepartment());  
String open      = CommonUtil.nvl((String) request.getParameter("open"),""); 

String req_date = CommonUtil.addDate(new Date(),"D",0,1);
//System.out.println("req_date " +req_date);
String req_date_year				=  req_date.substring(0,4);
String req_date_month			=  req_date.substring(4,6);
String req_date_day				=  req_date.substring(6,8); 

String year = CommonUtil.nvl((String) request.getParameter("st_from_year"),req_date_year);  //  (조회조건)
String month = CommonUtil.nvl((String) request.getParameter("st_from_month"),req_date_month);  //  (조회조건) 
String day = CommonUtil.nvl((String) request.getParameter("st_from_day"),req_date_day);  //  (조회조건) 
String st_account_type = CommonUtil.nvl((String) request.getParameter("st_account_type"),"");  //  (조회조건) 
String user_id       = _sessionInfo.getUserId();


//System.out.println("req_date_month " +(String) request.getParameter("st_from_month"));
//System.out.println("req_date_month " +req_date_month);
//System.out.println("month " +month);


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
  $('#buyerMpSoHiteJinroSiteConsmTeamPop').attr("action", "/mpso/getBuyerCowayUserBudgetAccountListPop.do").submit();    
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
<body onload="kep_onload()">
<form name="buyerMpSoHiteJinroSiteConsmTeamPop" id="buyerMpSoHiteJinroSiteConsmTeamPop" method=post >
<input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>"> 
<input type=hidden name="st_dept_code" id="st_dept_code"  value="<%=userDept%>"> 	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">부서예산조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>  
            	<span class="btn_reset"><a href="javascript:kepReload('buyerMpSoHiteJinroSiteConsmTeamPop');">초기화</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>부서예산조회 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="*" />  
						</colgroup>						
						<tbody>
						<tr>
							<td>년도</td>
							<td> 
								<label for="b_no02" class="hidden">년도선택</label>
			                	<select name="st_from_year" id="st_from_year"  style="width:70px;height:20px;">
			                		<option value="2014" <% if (year.equals("2014")) { %> selected <%} %> >2014</option>
			                		<option value="2015" <% if (year.equals("2015")) { %> selected <%} %>>2015</option>
			                		<option value="2016" <% if (year.equals("2016")) { %> selected <%} %>>2016</option>
			                		<option value="2017" <% if (year.equals("2017")) { %> selected <%} %>>2017</option>
			                	</select>&nbsp;년&nbsp;
			              		<label for="b_no02" class="hidden">월선택</label>
			                	<select name="st_from_month" id="st_from_month"  style="width:50px;height:20px;">
			                		<option value="01" <% if (month.equals("01")) { %> selected <%} %>>1</option>
			                		<option value="02" <% if (month.equals("02")) { %> selected <%} %>>2</option>
			                		<option value="03" <% if (month.equals("03")) { %> selected <%} %>>3</option>
			                		<option value="04" <% if (month.equals("04")) { %> selected <%} %>>4</option>
			                		<option value="05" <% if (month.equals("05")) { %> selected <%} %>>5</option>
			                		<option value="06" <% if (month.equals("06")) { %> selected <%} %>>6</option>
			                		<option value="07" <% if (month.equals("07")) { %> selected <%} %>>7</option>
			                		<option value="08" <% if (month.equals("08")) { %> selected <%} %>>8</option>
			                		<option value="09" <% if (month.equals("09")) { %> selected <%} %>>9</option>
			                		<option value="10" <% if (month.equals("10")) { %> selected <%} %>>10</option>
			                		<option value="11" <% if (month.equals("11")) { %> selected <%} %>>11</option>
			                		<option value="12" <% if (month.equals("12")) { %> selected <%} %>>12</option>
			                	</select>&nbsp;월
                            </td>
						</tr>
						<tr>			 
							<td>예산부서</td>
							<td> 
								<select name="st_account_type" >
        								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("st_user_id",user_id); 
								%>
								<%= CommonUtil.getCodeComboQueryIdList("buyer.mpso.getAAA","NO",_map,st_account_type) %>
          						</select>
                            </td>
						    <td></td>	
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:300px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>부서예산조회 리스트</caption>
                    <colgroup>
                        <col width="9%" /> 
                        <col width="9%" /> 
                        <col width="7%" /> 
                        <col width="13%" /> 
                        <col width="9%" /> 
                        <col width="9%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">예산부서코드</th> 
                            <th scope="col">예산부서</th> 
                            <th scope="col">계정코드</th> 
                            <th scope="col">계정명</th> 
                            <th scope="col">잔여예산</th> 
                            <th scope="col">주문금액</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="6" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j); 
    		
%> 
                        <tr>
					        <td class="center" height="25" title="예산부서코드">&nbsp;<%=rowData.get("AUFNR")%></td>
					        <td class="left"  title="예산부서">&nbsp;<%=rowData.get("AUFNR_NM")%></td>
					        <td class="center" title="계정코드">&nbsp;<%=rowData.get("BGACT")%></td>
					        <td class="left"   title="계정명">&nbsp;<%=rowData.get("ACTTX")%></td>
					        <td class="right"  title="잔여예산"><%=CommonUtil.formatNumber(rowData.get("REST_AMT"),true,0,3)%>&nbsp;</td>
					        <td class="right"  title="주문금액"><%=CommonUtil.formatNumber(rowData.get("MPAMT"),true,0,3)%>&nbsp;</td>
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
