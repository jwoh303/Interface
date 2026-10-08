<%--
**********************************************
* 메뉴 : 
* 화면 : 회사정보 사용자 상세조회 
* 기능 : 회사정보 및 사용자 리스트를 조회 팝업
* 프로그램 ID : PG_01_M_008_02
* 담당자 : 이수영	 ( 설계 : 권우재 )
* 착수일 : 2014-06-16
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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("compyData"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("userData"); // 조회된 결과

String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
<!--

//최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
	kepSearch();
	<% } %>
}

function kepSearch()
{  
  $('#masterMdCpCompyDetailViewPop').attr("action", "/mdcp/getMasterMdCpCompyDetailViewPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch();
			break;
	}
}

 //-->
</script> 
<body onload="kep_onload_view();">
<form name="masterMdCpCompyDetailViewPop" id="masterMdCpCompyDetailViewPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">회원사 상세정보 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div class="scrollArea" style="height:510px;" >
				<% if (_rowData != null) {  %>
				<b>[회원사 정보]</b>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>회원사 정보관리</caption>
	                <colgroup>
	                    <col width="18%" />
	                    <col width="32%" />
	                    <col width="18%" />
	                    <col width="32%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">회원사코드</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("COM_CODE"))%></td>
	                        <th scope="row">법인그룹</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
						</tr>
						
						<tr>
	                        <th scope="row">회원사명(국문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
	                        <th scope="row">회원사명(영문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">사업자등록번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
	                        <th scope="row">대표자명</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">대표전화번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("TEL_NO"))%></td>
	                        <th scope="row">대표FAX번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("FAX_NO"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">업태</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE"))%></td>
	                        <th scope="row">종목</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">우편번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%></td>
	                        <th scope="row">법인등록번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("CORP_REG_NO")) %></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">주소</th>
	                      	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC"))%></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">경리담당자</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("AC_EMP_NM")) %></td>
	                      	<th scope="row">전화번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("AC_EMP_TEL")) %></td>
	                    </tr>
					</tbody>
				</table>
				<br />
				<b>[개인정보]</b>
				<table class="cont_t_list02" style="width:100%">
					<colgroup>
						<col width="20%" />
						<col width="14%" />
						<col width="18%" />
						<col width="18%" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">사용자 아이디</th>
							<th scope="col">사용자명</th>
							<th scope="col">전화번호</th>
							<th scope="col">휴대전화</th>
							<th scope="col">이메일</th>
						</tr>
					</thead>
					<tbody>
					<% if (_gridList == null || _gridList.size() == 0) { %>
						<tr>
							<td colspan="15" align="center" height = "50"> 
								<span>조회된 데이타가 없습니다.</span>
							</td>
						</tr>
					<%
					} else {
						for (int j=0; j<_gridList.size(); j++) {
							Map<String,String> rowData2 = _gridList.get(j);
							String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
					%> 
						<tr align="center" bgcolor="<%=tclass%>">
							<td title="사용자 아이디"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData2.get("USER_ID"))))%></td>
							<td title="사용자명"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData2.get("USER_NAME_LOC"))))%></td>
							<td title="전화"><%=String.valueOf(CommonUtil.phoneMasking(CommonUtil.nvl(rowData2.get("PHONE_NUMBER"))))%></td>
							<td title="휴대전화번호"><%=String.valueOf(CommonUtil.phoneMasking(CommonUtil.nvl(rowData2.get("MOBILE_PHONE"))))%></td>
							<td title="이메일"><%=String.valueOf(CommonUtil.emailMasking(CommonUtil.nvl3(rowData2.get("EMAIL"),"")))%></td>
						</tr>
					<%
						} 
					}
					%>
					</tbody>
				</table>
				</div>
				<% } %>
			</div>
		</div>
</form> 
</body>
</html>
