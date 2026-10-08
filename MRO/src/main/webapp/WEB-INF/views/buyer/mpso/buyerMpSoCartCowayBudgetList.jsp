<%--
**********************************************
* 메뉴 : 코웨이예산조회
* 화면 : 코웨이예산조회
* 기능 : 코웨이예산조회
* 프로그램 ID : 
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-11-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), sessionInfo.getComCode());  
String userDept=  CommonUtil.nvl((String) request.getParameter("st_dept_code"), sessionInfo.getDepartment());  
String open      = CommonUtil.nvl((String) request.getParameter("open"),""); 


String total_cnt = "";

String req_date = CommonUtil.addDate(new Date(),"D",0,1);
///System.out.println("req_date " +req_date);
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

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3>예산조회</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회"><a href="javascript:doAction('search');">조회</a></span> 
            	<span class="btn_reset"><a href="javascript:kepReload('searchForm');">초기화</a></span>  
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_department" id="st_department" value="${sessionInfo.department}">
		
 
			
		<div id="cont_searchA">	
			<table class="cont_t_list01"  >
				<caption>조회</caption>
				<colgroup>
                    <col width="6%" />
                    <col width="15%" />
                    <col width="6%" />
                    <col width="15%" />
                    <col width="6%" />
                    <col width="*" />
				</colgroup>
				
				<tbody>
				 
				<tr>
					<th>년도</th>
					<td>
						 <select name="st_from_year" id="st_from_year"  style="width:70px;height:20px;">
			                		<option value="2014" <% if (year.equals("2014")) { %> selected <%} %>>2014</option>
			                		<option value="2015" <% if (year.equals("2015")) { %> selected <%} %>>2015</option>
			                		<option value="2016" <% if (year.equals("2016")) { %> selected <%} %>>2016</option>
			                		<option value="2017" <% if (year.equals("2017")) { %> selected <%} %>>2017</option>
			                		<option value="2018" <% if (year.equals("2018")) { %> selected <%} %>>2018</option>
			                		<option value="2019" <% if (year.equals("2019")) { %> selected <%} %>>2019</option>
			                		<option value="2020" <% if (year.equals("2020")) { %> selected <%} %>>2020</option>
			                	</select>
					</td>
                       	<th>월</th>
						<td>
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
			                	</select>
						</td>   
						<th>부서</th>
						<td>
								<select name="st_account_type" >
        								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("st_user_id",user_id); 
								%>
								<%= CommonUtil.getCodeComboQueryIdList("buyer.mpso.getAAA","NO",_map,st_account_type) %>
          						</select> 
						</td>
					</tr>
				</tbody>
			</table>
		</div>
 		
   
               	<br>
	</form>   
		<table class="cont_t_list02" >
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
        	total_cnt = "0";
        %>
                    <tr>
                        <td colspan="6" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
        	total_cnt = String.valueOf(_dataList.size());     	
			for (int j=0; j<_dataList.size(); j++) {				
				Map<String,String> rowData = _dataList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";  
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>">  
					        <td class="center" height="25" title="예산부서코드">&nbsp;<%=rowData.get("AUFNR")%></td>
					        <td class="left"  title="예산부서">&nbsp;<%=rowData.get("AUFNR_NM")%></td>
					        <td class="center" title="계정코드">&nbsp;<%=rowData.get("BGACT")%></td>
					        <td class="left"   title="계정명">&nbsp;<%=rowData.get("ACTTX")%></td>
					        <td class="right"  title="잔여예산"><%=CommonUtil.formatNumber(rowData.get("REST_AMT"),true,0,3)%>&nbsp;</td>
					        <td class="right"  title="주문금액"><%=CommonUtil.formatNumber(rowData.get("MPAMT"),true,0,3)%>&nbsp;</td>
				</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
<%	if (_dataList != null && _dataList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_dataList.size() %>" >
<%	}	%>
				<!-- 페이징 -->
		<p id="paging" class="paging">
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
<br>
		 

        </div>
        <br/>  
 
</div> 
<!--내용 종료-->	                  
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";
var selectedRow = "";

// 최초 화면 함수 
function kep_onload_view(){
	 
} 


var st;
//기능함수
function doAction(str) {
		
	switch (str) {
	case "search":	 //조회
		if(document.forms.searchForm.st_account_type.value == ""){
			alert("부서정보가 필요합니다");
			return;
		}
		
		kepSearch();
		break; 
		 
	case "kep_reload":	 //초기화
		kep_reload();
		break; 
		
	}
}


function kep_reload(){ 
	searchForm.reset();
}


//조회
function kepSearch(){
	
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartBudgetCoway.do").submit();   
} 


</script>
</html>
