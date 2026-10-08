<%--
**********************************************
* 메뉴 : 
* 화면 : 개인정보 조회 
* 기능 : 협력사 사용자 상세정보 조회 팝업
* 프로그램 ID : PG_01_A_003_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-25
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
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String st_user_id=  CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId());
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
<!--
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
	kepSearch();
	<% } %>
}

function kepSearch()
{  
  $('#sellerMdCtPrivateInfoPop').attr("action", "/mdct/getSellerMdCtPrivateInfoPop.do").submit();    
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
<body onload="">
<form name="sellerMdCtPrivateInfoPop" id="sellerMdCtPrivateInfoPop" method=post >
<input type=hidden name="st_user_id" id="st_user_id"  value="<%=st_user_id%>">
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:444px;">
    	<div id="popHeader">
        	<h1 class="title">개인정보 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/s_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div id="ContArea" style="width:770px;margin-left:0;" >
           	<!--grid-->
            	<% if (_rowData != null) {  %>
            	<b>[LOG IN 정보]</b>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>LOG IN 정보</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">ID</th>
	                        <td colspan="3">
	                        	<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>
	                        </td>
						</tr>
	                    <tr>
	                        <th scope="row">이름(국문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%></td>
	                        <th scope="row">이름(영문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("USER_NAME_ENG"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">E-mail</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("EMAIL"))%></td>
	                        <th scope="row">메일수신여부</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("MAIL_RECV_FLAG")).equals("Y") ? "수신" : "수신거부"%></td>
	                    </tr>
					</tbody>
				</table>	
				<br />
				<b>[USER 정보]</b>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>USER 정보</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
						<tr>
	                        <th scope="row">우편번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%></td>
	                        <th scope="row">국가</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("COUNTRY_TEXT"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">핸드폰</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%></td>
	                        <th scope="row">지역</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("CITY_TEXT"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">주소(국문)</th>
	                      	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">전화번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER"))%></td>
	                        <th scope="row">FAX</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("FAX_NUMBER"))%></td>
	                    </tr>
					</tbody>
				</table>	
				<br />
				<b>[회사정보]</b>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>회사정보</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
						<tr>
	                        <th scope="row">회사명</th>
	                      	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">부서</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("DEPARTMENT_TEXT"))%></td>
	                        <th scope="row">직급</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("POSITION_TEXT"))%></td>
	                    </tr>
					</tbody>
				</table>	  
				<% } %>           
		</div>        
	</div>
</form> 
</body>
</html>
