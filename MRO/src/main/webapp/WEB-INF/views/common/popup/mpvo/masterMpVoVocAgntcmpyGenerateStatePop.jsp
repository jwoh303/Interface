<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 별 상세현황 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_800_21
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-07-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.DateTimeUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

String st_sys_type = CommonUtil.nvl((String) request.getParameter("st_sys_type"), "");
String st_agent_code = CommonUtil.nvl((String) request.getParameter("st_agent_code"), "");
String st_recv_flag = CommonUtil.nvl((String) request.getParameter("st_recv_flag"), "");
String st_recv_type = CommonUtil.nvl((String) request.getParameter("st_recv_type"), "");
String st_agent_name = CommonUtil.nvl((String) request.getParameter("st_agent_name"), "");
String st_item_cnt = CommonUtil.nvl((String) request.getParameter("st_item_cnt"), "");
String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"), "");
String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"), "WEEK");
String st_date_flag = CommonUtil.nvl((String) request.getParameter("st_date_flag"), "-14");

String st_fromDate  = "";
String st_toDate    = DateTimeUtil.getFormatString("yyyyMMdd");

if(st_date_type.equals("WEEK")){
	st_fromDate = DateTimeUtil.addDays(st_toDate, Integer.parseInt(st_date_flag));
}else{
	st_fromDate = DateTimeUtil.addMonths(st_toDate, Integer.parseInt(st_date_flag));
}

%>

<script type="text/javascript">
<!--
 //-->
</script> 
<body onload="">
	 <form name="masterMpVoVocBizGenerateStatePop" id="masterMpVoVocBizGenerateStatePop" method="post" >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">협력사 별 상세현황</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<table  class="cont_t_list06 mb15" summary="협력사 별 상세현황" style="width:100%;">
				<caption>협력사 별 상세현황</caption>
				<colgroup>
					<col width="11%" />
					<col width="22%" />
					<col width="11%" />
					<col width="22%" />
					<col width="11%" />
					<col width="*" />
				</colgroup>
				<tbody>
		    	<tr>
		    		<th scope="row">협력사</th>
					<td><font color="blue"><b><%=st_agent_name%></b></font></td>
		    		<th scope="row">상태</th>
					<td><font color="blue"><b><%=st_recv_flag%></b></font></td>
		    		<th scope="row">발생건수</th>
					<td><font color="blue"><b><%=CommonUtil.formatNumber(st_item_cnt, true, 0, 0)%></b></font></td>
				</tr>
		        </tbody>
		   </table> 
	        <!--grid-->
			<div class="scrollArea" style="height:378px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>협력사 상세현황 리스트</caption>
	                <colgroup>
	                	<col width="10%" /> 
	                	<col width="20%" /> 
	                	<col width="10%" /> 
	                	<col width="21%" /> 
	                	<col width="27%" /> 
	                    <col width="*" /> 
					</colgroup>
	                <thead>
	                	<tr>
	                    	<th scope="col">접수일자</th> 
	                        <th scope="col">고객사명</th> 
	                    	<th scope="col">접수자</th> 
	                        <th scope="col" colspan="2">품목명/규격</th> 
	                    	<th scope="col">처리리드타임</th>
	                    </tr> 
	                    <tr>
	                        <th scope="col">처리완료일자</th> 
	                    	<th scope="col">접수번호/요청자</th> 
	                        <th scope="col">담당자</th> 
	                    	<th scope="col">귀책타입 [협력사명]</th> 
	                        <th scope="col">Claim유형</th> 
	                        <th scope="col">만족도</th> 
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
		Map<String,String> _tmp = _dataList.get(j);
	%> 
						<tr <%if(j%2 == 1){ %>style="background-color: #F0F8FF;"<%} %>>
							<td><%=_tmp.get("CD_DATE")%></td>
							<td class="left"><%=_tmp.get("BUYER_NAME")%></td>
							<td><%=_tmp.get("CD_USER_NAME")%></td>
							<td colspan="2"><%=_tmp.get("ITEM_DESC")%></td>
							<td>
								<% if(!"".equals(_tmp.get("LEAD_TIME"))){ %> 
									<%=_tmp.get("LEAD_TIME")%> 일
	               				<% }%>
							</td>
						</tr> 
						<tr <%if(j%2 == 1){ %>style="background-color: #F0F8FF;"<%} %>>
							<td><%=_tmp.get("DF_DATE")%></td>
							<td class="left"><%=_tmp.get("VC_NO")%>&nbsp;/&nbsp;<%=_tmp.get("REQ_USER_NAME")%></td>
							<td><%=_tmp.get("DS_USER_NAME")%></td>
							<td class="left">
								<% if(_tmp.get("IMPUTE_TYPE2").equals("SS") || _tmp.get("IMPUTE_TYPE2").equals("MS")){ %> 
									<%=_tmp.get("AGENT_NAME")%>
	               				<% }%>
							</td>
							<td class="left">
								<% if(_tmp.get("CLAIM_TEXT").equals("")){ %>    
									<%=_tmp.get("CLAIM_MASTER")%>
					            <%  }else{  %>
					            	<%=_tmp.get("CLAIM_MASTER")%>&nbsp;[<%=_tmp.get("CLAIM_TEXT")%>]
					            <%  }       %>
							</td>
							<td><%=_tmp.get("RUB_TYPE")%></td>
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
