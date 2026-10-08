<%--
**********************************************
* 메뉴 : 고객사 견적 단가상세팝업
* 화면 : 고객사 견적 단가상세팝업
* 기능 : 견적단가 클릭 시 노출, 상품정보/ 견적제안이력/ 견적제출 상세 보여줌
* 프로그램 ID : 
* 담당자 : 이민아
* 착수일 : 2026-03-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/base.css" />
<link rel="stylesheet" type="text/css" href="css/main_buyer.css" />
</head>
<%@ include file="../include/head_v2.jspf"%>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _dataMap = (Map<String,String>) request.getAttribute("itemdata"); // 조회된결과
String status = CommonUtil.nvl(_dataMap.get("SOURCING_STATUS"));
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("negodata"); // 조회된결과
String bid_success_reason = _dataList.get(0).get("BID_SUCCESS_REASON"); //선정사유
String st_com_code = _sessionInfo.getComCode();
String user_group = _sessionInfo.getUserGroup();

//견적상세 팝업
boolean p04402705 = CommonUtil.getSpecialCheckReturn(st_com_code,"P04-4027-05");

//네고이력 팝업
boolean p04402706 = CommonUtil.getSpecialCheckReturn(st_com_code,"P04-4027-06");

//네고제출건에 대해서 네고요청, 단가합의 가능 기능
boolean p04402707 = CommonUtil.getSpecialCheckReturn(st_com_code, "P04-4027-07");
//네고제출건에 대해서 네고요청, 단가합의 기능 가능건 USER_GROUP='A'만 견적 상세 내용 보여줌
if (p04402707 == true) {
	if (!user_group.equals("A")) {
		p04402705 = false;
	}
}
%>
<script>
window.addEventListener('keydown', function(event) {
    // 엔터(13) 또는 스페이스바(32) 키 확인
    if (event.keyCode === 13 || event.keyCode === 32) {
      // 팝업창 닫기
      self.close();
    }
  });

</script>
<body onload="">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup">
    	<div class="PopupTit">견적단가 상세</div>
       	<div class="PopupTitSub">상품정보</div>
       	<table class="Table14pxList">
       		<colgroup>
				<col width="100px" />
				<col width="400px" />
		  	</colgroup>    
			<tr>
				<th>품목코드</th>
				<td><%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"))%></td>
			</tr>
			<tr>
				<th>품목명</th>
				<td><%=CommonUtil.nvl(_dataMap.get("DESCRIPTION"))%></td>
			</tr>
			<tr>
				<th>규격</th>
				<td><%=CommonUtil.nvl(_dataMap.get("SPECIFICATION"))%></td>
			</tr>
       	</table>
		<div class="h30"></div>
<%if(p04402706 == true){ //네고이력 특수로직%>
		<div class="PopupTitSub_RightTxt mt10">견적제출 이력<span>※ KeP에서 고객사에 제출한 견적 이력입니다.</span></div>
			<table class="Table14px">
			    <colgroup>
			      <col width="165px" />
			      <col width="165px" />
			      <col width="170px" />
			    </colgroup>  
				<tr>
					<th>제출일</th>
					<th>제출단가</th>
					<th>상태</th>
				</tr>
			<%
				if (_dataList2 == null || _dataList2.size() == 0){
			%>
               		<tr>
                        <td colspan="3" align="center" >
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
			<%
				} else {
					for (int j=0; j<_dataList2.size(); j++) {
						Map<String,String> _tmp = _dataList2.get(j);
			%>
					<tr>
						<td align="center">
						 	<%=CommonUtil.formatStrinigDate(_tmp.get("NEGO_DATE"))%>
						</td>
						<td align="right">
						 	<span class="F6495F"><%=CommonUtil.formatNumber(_tmp.get("NEGO_PRICE"),true,0,3)%></span>
						</td>
						<td align="center">
						<% if(status.equals("RQ02") || status.equals("RQ03") || status.equals("RQ04")){
							if(j == 0){%>
							<span class="ChipsDefault_Blue">견적완료</span>
							<%	}
						}%>
						</td>
					</tr> 
			<%
					}
				}
			%>
			</table>
 <%} %>	 
 <%if(p04402705 == true){ //견적상세 특수로직%>
       	<div class="PopupTitSub_RightTxt mt10">제출상세<span>※ 협력사가 제출한 견적 단가 및 납기 정보입니다</span></div>
		<table class="Table14pxList">
			<colgroup>
				<col width="100px" />
				<col width="400px" />
			</colgroup>
				<tr>
					<th scope="col" >단가선정사유</th>
					<td id="st_bid_success_reason"><%=bid_success_reason%></td>
				</tr>
		<table class="Table14px mt03">
			<colgroup>
				<col width="220px" />
				<col width="110px" />
				<col width="80px" />
				<col width="90px" />
			</colgroup>
			<tr>
				<tr>
					<th>협력사</th>
					<th>제출단가</th>
					<th>조달일수</th>
					<th>선정여부</th>
				</tr>
			</tr>
		<%
		if (_dataList == null || _dataList.size() == 0){
		%>
				<tr>
			       <td colspan="4" align="center">
			       <span>조회된 데이타가 없습니다.</span>
			       </td> 
				</tr>
		<%
		}else{
			for (int j=_dataList.size()-1; j>=0; j--) {
				Map<String,String> rowData = _dataList.get(j);
		%> 
				<tr>
		<%
		if(CommonUtil.nvl(rowData.get("AGENT_NAME_TYPE")).equals("B")){
		%>	                        
					<td><%=CommonUtil.nvl( rowData.get("AGENT_NAME_2"))%></td>
		<%
		}else{
		%>
					<td><%=CommonUtil.nvl( rowData.get("AGENT_NAME"))%></td>	
		<%
		}
		%>
					<td  align="right"><%=CommonUtil.formatNumber(rowData.get("ATOB_UNIT_PRICE"),true,0,3)%></td>
					<td  align="right"><%=CommonUtil.nvl( rowData.get("DELIVERY_LT"))%></td>
					<td  align="center"><%if(CommonUtil.nvl( rowData.get("BID_SUCCESS_FLAG")).equals("Y")){%>●<%} %></td>  
			</tr> 
		<% } 
		}%>     
		</table>
<%} %>
		<div class="h20"></div>
		<div class="PopupListBtnBox_Center mt20"><button class="ButPrimary_large" onclick="javascript:self.close();" >확인</button></div>  
	</div>
</body>
</html>
