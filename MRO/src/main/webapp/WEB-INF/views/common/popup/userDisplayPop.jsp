<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String result = CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과  
String user_id = CommonUtil.nvl((String) request.getParameter("user_id"),"");  //  (조회조건)
String selected="";
String user_type="";
String p01_1010_05 = "";

Map<String,String> rowData = null;
if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1.get(0);
	user_type = CommonUtil.nvl(rowData.get("USER_TYPE"));
	if (user_type.equals("A")){
	    selected = "Admin사용자";
	}else if (user_type.equals("M")){
	    selected = "운영 관리자";
	}else{
	    selected = "일반사용자";
	}
	
	p01_1010_05 = CommonUtil.getSpecialCheckReturn(CommonUtil.nvl(rowData.get("COM_CODE")),"P01-1010-05","COL01_DATA", request); // 고객사별 사번 라벨명
	if(p01_1010_05 == null){
		p01_1010_05 = "사번";
	}else if("".equals(p01_1010_05)){
		p01_1010_05 = "사번";
	}
}
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	<%
	if(_sessionInfo == null){
%>
		$('#userDisplayPop').attr("action", "http://www.koreab2b.com").submit();
<%
	}
%>
	<%
		if ("".equals(result)){
	%>
			setQuery();
	<%	
		}
	%>
}
function setQuery()
{  
  $('#userDisplayPop').attr("action", "/common/commonList.do").submit();        
}
function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}
 //-->
</script> 
<body onload="kep_onload_view(); ">
	 <form name=userDisplayPop id=userDisplayPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="userDisplayPop"> 
	 <input type="hidden"  name="user_id"  id="user_id"  value="<%=user_id%>"  onkeydown="kepEnter()" /> 
<%
if (_dataList1==null || _dataList1.size()==0){
	if(!"".equals(result)){
%>
<script>alert("사용자 정보가 없습니다.");self.close();</script>
<%		
	}
%>

<%}else{ %>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:502px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사용자 상세조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
      	</div>
	<!--팝업내용입니다-->
	<div id="popContainer" class="scrollArea" style="height:427px">
	<h4 class="b">[ LOGIN 정보 ]</h4>	
	<table  class="board_write" summary="사용자 대한 정보입력">
		<caption>LOGIN 정보</caption>
			<colgroup>
				<col width="17%" />
				<col width="33%" />
				<col width="19%" />
				<col width="*" />
			</colgroup>
		<tbody> 
    	  <tr>
			<th scope="row">ID</th>
			<td class="TextTop"><%=CommonUtil.nvl(rowData.get("USER_ID"))%></td>
			<th scope="row"><%=p01_1010_05%></th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("LEGACY_USER_ID"))%></td>
		  </tr>
		  <tr>
		  	<th scope="row">PASSWORD</th>
			<td scope="row" ></td>
			<th scope="row">PASSWORD</th>
			<td scope="row">확인</td>
		  </tr>
		  <tr>
		  	<th scope="row">이름(국문)</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("USER_NAME_LOC"))%></td>
			<th scope="row">이름(영문)</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("USER_NAME_ENG"))%></td>
		  </tr>
		  <tr>
			<th scope="row">사용언어</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("LANG"))%></td>
			<th scope="row">이메일수신여부</th>
			<%
					String mail_recv_flag_text = "";
					String mail_recv_flag = CommonUtil.nvl(rowData.get("MAIL_RECV_FLAG"));
					if(mail_recv_flag.equals("Y")){
						mail_recv_flag_text = "수신";
					}else {
						mail_recv_flag_text = "수신거부";
					}
				%>
			<td scope="row"><%=mail_recv_flag_text%></td>
		  </tr>
    	</tbody>
    </table> 
    
	<h4 class="b">[ USER 정보 ]</h4>	
	<table  class="board_write" summary="사용자 대한 정보입력">
		<caption>USER 정보</caption>
			<colgroup>
				<col width="17%" />
				<col width="35%" />
				<col width="17%" />
				<col width="*" />
			</colgroup>
		<tbody> 
		  <tr>
			<th scope="row">이메일</th>
			<td scope="row"><%=CommonUtil.nvl3(rowData.get("EMAIL"), "")%></td>
			<th scope="row">사용자 구분</th>
			<td scope="row"><%=selected %></td>
		  </tr>
		  <tr>
		  	<th scope="row">우편번호</th>
			<td scope="row" ><%=CommonUtil.nvl(rowData.get("ZIP_CODE"))%></td>
			<th scope="row">국가</th>
			<td scope="row" ><%=CommonUtil.nvl(rowData.get("COUNTRY_TEXT"))%></td>
		  </tr>
		  <tr>
		  	<th scope="row">지역</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("CITY_TEXT"))%></td>
			<th scope="row">핸드폰</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("MOBILE_PHONE"))%></td>
		  </tr>
    	  <tr>
			<th scope="row">주소(국문)</th>
			<td class="TextTop" colspan="3"><%=CommonUtil.nvl(rowData.get("ADDRESS_LOC"))%></td>
		  </tr>
    	  <tr>
			<th scope="row">주소(영문)</th>
			<td class="TextTop" colspan="3"><%=CommonUtil.nvl(rowData.get("ADDRESS_ENG"))%></td>
		  </tr>
		  <tr>
	  	  <th scope="row">전화번호</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("PHONE_NUMBER"))%></td>
			<th scope="row">팩스</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("FAX_NUMBER"))%></td>
		  </tr>
    	</tbody>
    </table> 
    
    <h4 class="b">[ 회사정보 ]</h4>	
	<table  class="board_write" summary="사용자 대한 정보입력">
		<caption>회사정보</caption>
			<colgroup>
				<col width="17%" />
				<col width="35%" />
				<col width="17%" />
				<col width="*" />
			</colgroup>
		<tbody> 
    	  <tr>
			<th scope="row">회사명</th>
			<td class="TextTop" colspan="3"><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></td>
		  </tr>
    	  <tr>
 		    <th scope="row">부서</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("DEPARTMENT_TEXT"))%></td>
			<th scope="row">직급</th>
			<td scope="row"><%=CommonUtil.nvl(rowData.get("POSITION_TEXT"))%></td>
		  </tr>
    	</tbody>
    </table> 
    </div>
</div>      
<%}%>
</form> 
</body>
</html>
