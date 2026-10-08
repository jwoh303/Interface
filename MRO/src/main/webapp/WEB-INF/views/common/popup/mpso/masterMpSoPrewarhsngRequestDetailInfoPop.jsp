<%--
**********************************************
* 메뉴 : 
* 화면 : 선입고요청 상세정보
* 기능 : 선입고요청 상세정보를 조회하는 팝업 
* 프로그램 ID : PG_06_M_012_01
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-07-31
**********************************************
--%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<%
Map<String,String> _dataMap = (Map<String,String>) request.getAttribute("data"); // 조회된결과
if(_dataMap == null){
	_dataMap = new HashMap<String,String>();
}
String[] arry_po_no = CommonUtil.StrToArray(CommonUtil.nvl(_dataMap.get("PO_NO")), "$$");
String buyer_code = CommonUtil.nvl(_dataMap.get("BUYER_CODE"));

String com_type = "";
if (_sessionInfo != null){
	com_type =  CommonUtil.nvl((String)_sessionInfo.getComType()); 	
}
%>
</head>
<script>
function doAction(str, value1) {
	switch (str) {
		case "poDetailPop":	 //조회
			var po_no = value1;
			var buyer_code = "<%=buyer_code%>";
			openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+buyer_code+'&st_po_no='+po_no+'&st_print_flag=N','900,550,no');
	}
}
</script> 
<body>
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<div id="popWrapper" style="height:535px;">
		<div id="popHeader">
        	<h1 class="title">선입고요청 상세정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:456px;">
			<h2>선입고요청 상세정보</h2>
			<table  class="cont_t_list06 mb15" summary="선입고요청" style="width:100%;">
				<caption>선입고요청</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" />
					<col width="20%" />
					<col width="*" />
				</colgroup>
				<tbody>
					<tr> 
						<th scope="row">고객사</th>
						<td scope="row" colspan="3"><%=CommonUtil.nvl(_dataMap.get("BUYER_NAME"))%></td>
					</tr>
					<tr> 
						<th scope="row">요청자</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("REQ_USER_NAME"))%></td>
						<th scope="row">요청자부서</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("REQ_USER_DEPT_NAME"))%></td>
					</tr>
					<tr> 
						<th scope="row">요청자 연락처</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("REQ_USER_TEL_NO"))%></td>
						<th scope="row">요청일</th>
						<td scope="row"><%=CommonUtil.formatStrinigDate(_dataMap.get("BEFORE_GR_DATE"))%></td>
					</tr>
					<tr> 
						<th scope="row">품목코드</th>
						<td scope="row" colspan="3"><%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%></td>
					</tr>
					<tr> 
						<th scope="row">품목명</th>
						<td scope="row" colspan="3"><%=CommonUtil.nvl(_dataMap.get("DESCRIPTION"))%></td>
					</tr>
					<tr> 
						<th scope="row">규격</th>
						<td scope="row" colspan="3"><%=CommonUtil.nvl(_dataMap.get("SPECIFICATION"))%></td>
					</tr>
					<tr> 
						<th scope="row">제조사</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("MAKER_NAME"))%></td>
						<th scope="row">원산지</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("ORIGIN_NAME"))%></td>
					</tr>
					<tr> 
						<th scope="row">매출단가</th>
<%if(!com_type.equals("W")){%>
						<td scope="row"><%=CommonUtil.formatNumber(_dataMap.get("UNIT_PRICE"), true, 0, 3)%></td>
<%}else{%>
						<td scope="row"></td>
<%}%>
						<th scope="row">매입단가</th>
<%if(!com_type.equals("W")){%>
						<td scope="row"><%=CommonUtil.formatNumber(_dataMap.get("AGENT_PRICE"), true, 0, 3)%></td>
<%}else{%>
						<td scope="row"></td>
<%}%>
					</tr>
					<tr> 
						<th scope="row">선입고요청수량</th>
						<td scope="row"><%=CommonUtil.formatNumber(_dataMap.get("ITEM_QTY"), true, 0, 3)%></td>
						<th scope="row">선입고발주수량</th>
						<td scope="row"><%=CommonUtil.formatNumber(_dataMap.get("CLOSE_ITEM_QTY"), true, 0, 3)%></td>
					</tr>
					<tr>
						<th scope="row">단위</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("UNIT_MEASURE"))%></td>
						<th scope="row">거래유형</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("PROCESS_NAME"))%></td>
					</tr>
					<tr>
						<th scope="row">배송지</th>
						<td scope="row" colspan="3"><%=CommonUtil.nvl(_dataMap.get("DELY_TO_LOCATION"))%></td>
					</tr>
					<tr>
						<th scope="row">협력사</th>
						<td scope="row" colspan="3"><%=CommonUtil.nvl(_dataMap.get("AGENT_NAME"))%></td>
					</tr>
					<tr> 
						<th scope="row">협력사 담당자</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("AGENT_USER_NAME"))%></td>
						<th scope="row">협력사 연락처</th>
						<td scope="row"><%=CommonUtil.nvl(_dataMap.get("AGENT_TEL_NO"))%></td>
					</tr>
					<tr>
						<th scope="row">Kep 담당자</th>
						<td scope="row" colspan="3"><%=CommonUtil.nvl(_dataMap.get("KEP_USER_NAME"))%></td>
					</tr>
					<tr>
						<th scope="row">발주번호</th>
						<td scope="row" colspan="3">
<%
	if(arry_po_no != null){
		String[] arry_po_no2 = null;
		for(int inx = 0 ; inx < arry_po_no.length ; inx++){
			arry_po_no2 = CommonUtil.StrToArray(CommonUtil.nvl(arry_po_no[inx]), "||");
			if(inx == (arry_po_no.length - 1)){
%>						<a class="hyperLink"  href="javascript:doAction('poDetailPop', '<%=arry_po_no2[0]%>');"><%=arry_po_no2[0] %></a>		<%
			} else {
%>						<a class="hyperLink"  href="javascript:doAction('poDetailPop', '<%=arry_po_no2[0]%>');"><%=arry_po_no2[0] %></a>,	<%
			}
		}
	}
%>						
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</form> 
</body>
</html>
