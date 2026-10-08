<%--
**********************************************
* 메뉴 : VOC Daily Summary>
* 화면 : VOC Daily Summary
* 기능 : 
* 프로그램 ID : PG_90_C_800_11
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-25
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _weekDataList = (List<Map<String,String>>) request.getAttribute("week_data"); // 조회된결과  
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _todayDataList = (List<Map<String,String>>) request.getAttribute("today_data"); // 조회된결과  

String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"), _sessionInfo.getUserNameLoc());
String st_user_dept = CommonUtil.nvl((String) request.getParameter("st_user_dept"),_sessionInfo.getDepartment());
%>

<script src="/resources/js/common.js"></script>
</head>
<body>
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>VOC Daily Summary</h3>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method = "post">
       		<!-- HIDDEN -->
			<input type="hidden" id="st_user_id" name="st_user_id"		value="<%=st_user_id%>">
			<input type="hidden" id="st_user_name" name="st_user_name"	value="<%=st_user_name%>">
			<input type="hidden" id="st_user_dept" name="st_user_dept"	value="<%="st_user_dept"%>">
			<!-- HIDDEN -->
			<div class="main_table_summ">
				<p>
					<img src="/resources/images/m_ball_blue.gif" alt="ball_blue" style="vertical-align:middle" /> 금주 VOC 현황 전사 : (&nbsp;&nbsp;) 은 본인의 건수      
				</p>
			</div>
           	<div class="wrap_tbl">
			<table class="t_masterMain01" style="width: 100%">
				<colgroup>
		            <col width="8%" />
		            <col width="8%" />
		            <col width="8%" />
		            <col width="9%" />
		            <col width="8%" />
		            <col width="8%" />
		            <col width="8%" />
		            <col width="9%" />
		            <col width="8%" />
		            <col width="8%" />
		            <col width="8%" />
		            <col width="9%" />
		        </colgroup>
		        <thead>
					<tr>
					  <th class="bigtit" scope="col"  colspan="6">접수현황</th>
					  <th class="bigtit" scope="col"  colspan="6">처리현황</th>
					</tr>
					<tr>
					  <th scope="col"  colspan="2">Offline 접수</th>
					  <th scope="col"  colspan="2">Online 접수</th>
					  <th scope="col"  colspan="2">합계</th>
					  <th scope="col"  colspan="2">당일처리</th>
					  <th scope="col"  colspan="2">1일이상</th>
					  <th scope="col"  colspan="2">미처리 건</th>
					</tr>
					<tr>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					</tr>
				</thead>
				<tbody>
	 		<%
	        if (_weekDataList == null || _weekDataList.size() == 0){
	        %>
	        		<tr>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
					</tr>
	        <%
	        }else{
				for (int j=0; j<_weekDataList.size(); j++) {
					Map<String,String> rowData = _weekDataList.get(j);
			%> 
					<tr>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("CM")) %>(<%=CommonUtil.bnvl(rowData.get("CM_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("SM")) %>(<%=CommonUtil.bnvl(rowData.get("SM_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("CB")) %>(<%=CommonUtil.bnvl(rowData.get("CB_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("SB")) %>(<%=CommonUtil.bnvl(rowData.get("SB_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("C")) %>(<%=CommonUtil.bnvl(rowData.get("C_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("S")) %>(<%=CommonUtil.bnvl(rowData.get("S_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("C_DAY")) %>(<%=CommonUtil.bnvl(rowData.get("C_DAY_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("S_DAY")) %>(<%=CommonUtil.bnvl(rowData.get("S_DAY_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("C_DAYS")) %>(<%=CommonUtil.bnvl(rowData.get("C_DAYS_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("S_DAYS")) %>(<%=CommonUtil.bnvl(rowData.get("S_DAYS_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("C_ING")) %>(<%=CommonUtil.bnvl(rowData.get("C_ING_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("S_ING")) %>(<%=CommonUtil.bnvl(rowData.get("S_ING_OWN")) %>)</td>
					</tr>
	            <%
	                        } 
	        			}
	            %>
				</tbody>
			</table>
			<br/>
			<div class="main_table_summ">
				<p>
					<img src="/resources/images/m_ball_blue.gif" alt="ball_blue" style="vertical-align:middle" /> 당일 VOC 현황 전사 : (&nbsp;&nbsp;) 은 본인의 건수      
				</p>
			</div>
           	<div class="wrap_tbl">
			<table class="t_masterMain01" style="width: 100%">
				<colgroup>
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		            <col width="10%" />
		        </colgroup>
		        <thead>
					<tr>
					  <th class="bigtit" scope="col"  colspan="6">접수현황</th>
					  <th class="bigtit" scope="col"  colspan="4">처리현황</th>
					</tr>
					<tr>
					  <th scope="col"  colspan="2">Offline 접수</th>
					  <th scope="col"  colspan="2">Online 접수</th>
					  <th scope="col"  colspan="2">합계</th>
					  <th scope="col"  colspan="2">처리건수</th>
					  <th scope="col"  colspan="2">미처리건</th>
					</tr>
					<tr>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					  <th scope="col" >Claim</th>
					  <th scope="col" >단순</th>
					</tr>
				</thead>
				<tbody>
	 		<%
	        if (_todayDataList == null || _todayDataList.size() == 0){
	        %>
                    <tr>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
						<td style="text-align: center;">0(0)</td>
					</tr>
	        <%
	        }else{
				for (int j=0; j<_todayDataList.size(); j++) {
					Map<String,String> rowData = _todayDataList.get(j);
			%> 
					<tr>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("CM")) %>(<%=CommonUtil.bnvl(rowData.get("CM_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("SM")) %>(<%=CommonUtil.bnvl(rowData.get("SM_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("CB")) %>(<%=CommonUtil.bnvl(rowData.get("CB_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("SB")) %>(<%=CommonUtil.bnvl(rowData.get("SB_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("C")) %>(<%=CommonUtil.bnvl(rowData.get("C_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("S")) %>(<%=CommonUtil.bnvl(rowData.get("S_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("C_END")) %>(<%=CommonUtil.bnvl(rowData.get("C_END_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("S_END")) %>(<%=CommonUtil.bnvl(rowData.get("S_END_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("C_ING")) %>(<%=CommonUtil.bnvl(rowData.get("C_ING_OWN")) %>)</td>
						<td style="text-align: center;"><%=CommonUtil.bnvl(rowData.get("S_ING")) %>(<%=CommonUtil.bnvl(rowData.get("S_ING_OWN")) %>)</td>
					</tr>
	            <%
	                        } 
	        			}
	            %>
				</tbody>
			</table>
		</form>
</body>
</html>
