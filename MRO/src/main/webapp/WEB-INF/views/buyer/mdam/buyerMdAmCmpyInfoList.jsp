<%--
**********************************************
* 메뉴 : HOME>회사정보
* 화면 : 회사정보
* 기능 : 고객사 법인상세정보 조회
* 프로그램 ID : PG_01_B_005_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data_pass"); // 조회된 결과
Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

String _icogPass = "";
if (_dataList2 != null && _dataList2.size() != 0) {
	for (int j=0; j<_dataList2.size(); j++) {
		Map<String,String> _rowData2 = _dataList2.get(j);
		_icogPass += _rowData2.get("DOCU_TEXT");
		if (j < _dataList2.size() -1 ) {
			_icogPass += ", ";
		}
    }
}
%>

<script type="text/javascript">
<!--
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view() {
	<% if (_dataList==null || _dataList.size()==0) { %>
		doAction("search");
	<% } 	%>
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

// 조회
function kepSearch(){
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmCmpyInfoList.do").submit();   
}
//-->
</script>
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
	<h3><%=CommonLang.get("HTITLE737") %><!-- 회사정보 --></h3>
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
	  	
		<% if (_rowData != null) {  %>
		<table  class="cont_t_list06" style="width:100%;">
              <caption>회사법인정보관리</caption>
              <colgroup>
                  <col width="15%" />
                  <col width="35%" />
                  <col width="15%" />
                  <col width="35%" />
              </colgroup>
              <tbody>
			<tr>
				<th scope="row"><%=CommonLang.get("HTITLE331") %><!-- 회사코드 --></th>
                      <td><%=CommonUtil.nvl(_rowData.get("COM_CODE"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE332") %><!-- 법인그룹 --></th>
                      <td><%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%></td>
			</tr>
			
			<tr>
                      <th scope="row"><%=CommonLang.get("HTITLE333") %><!-- 회사명(국문) --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE334") %><!-- 회사명(영문) --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE335") %><!-- 사업자등록번호 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO")) %></td>
                      <th scope="row"><%=CommonLang.get("HTITLE336") %><!-- 설립년도 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("ESTABLISH_DATE"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE337") %><!-- 대표자(국문) --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE338") %><!-- 대표자(영문) --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("CEO_NAME_ENG"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE339") %><!-- 대표전화번호 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("TEL_NO"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE340") %><!-- 대표FAX번호 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("FAX_NO"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE341") %><!-- 업태 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE342") %><!-- 종목 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE343") %><!-- 우편번호 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE344") %><!-- 메일링서비스 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equalsIgnoreCase("Y") ? "적용" : "미적용"  %></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE794") %><!-- 주소(국문) --></th>
                    	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC"))%></td>
                    </tr>
                    <tr>
                    	<th scope="row"><%=CommonLang.get("HTITLE795") %><!-- 주소(영문) --></th>
                    	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("ADDRESS_ENG"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE347") %><!-- 홈페이지주소 --></th>
                    	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("HP_ADDRESS"))%></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE348") %><!-- 법인등록번호 --></th>
						<td><%=CommonUtil.nvl(_rowData.get("CORP_REG_NO"))%></td>
                    	<th scope="row"><%=CommonLang.get("HTITLE349") %><!-- 무역업등록번호 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("TRADE_REG_NO")) %></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE350") %><!-- DUNS-NO --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("DUNS_NO")) %></td>
                    	<th scope="row"><%=CommonLang.get("HTITLE351") %><!-- 신용등급 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("CREDIT_RATING")) %></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE352") %><!-- 입고담당자명 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("GR_EMP_NM")) %></td>
                    	<th scope="row"><%=CommonLang.get("HTITLE353") %><!-- 입고담당자 연락처 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("GR_EMP_TEL")) %></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE354") %><!-- 경리담당자명 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("AC_EMP_NM")) %></td>
                    	<th scope="row"><%=CommonLang.get("HTITLE355") %><!-- 경리담당자 연락처 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("AC_EMP_TEL")) %></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE356") %><!-- 물품대금수령처 --></th>
                    	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("PAY_RECVER")) %></td>
                  </tr>
                  <tr>
						<th scope="row"><%=CommonLang.get("HTITLE357") %><!-- 수금조건 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("PAY_TERMS")) %></td>
                    	<th scope="row"><%=CommonLang.get("HTITLE358") %><!-- 수금형태 --></th>
                    	<td><%=CommonUtil.nvl(_rowData.get("PAY_TYPE")) %></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
                    	<td colspan="3"><%=CommonUtil.nvl(_rowData.get("REMARK")) %></td>
                  </tr>
                  <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE362") %><!-- 전자결제범위 --></th>
                    	<td colspan="3"><%=_icogPass%></td>
                  </tr>
		</tbody>
	</table>
	<% } %>

		<!-- 버튼영역 -->
		<div class="btnArea">
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<div id="process">
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

</html>
