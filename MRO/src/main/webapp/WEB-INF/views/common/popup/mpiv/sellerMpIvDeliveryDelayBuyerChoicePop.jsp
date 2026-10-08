<%--
**********************************************
* 메뉴 : 
* 화면 : 납품지연고객사 선택
* 기능 : 납품이 지연된 고객사를 선택하기위한 팝업
* 프로그램 ID : PG_07_A_007_01
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"%>

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
%>

<script type="text/javascript">
	function doPop(str, value1) {
		switch (str) {
		case "agent": // 고객사
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="
					+ value1, "800,550,no");
			break;
		}
	}

	function setReturn(buyer, com_name) {
		opener.setBuyerChoiceReturn(buyer, com_name);
		self.close();
	}
	
	function kep_onload_view(){

	}
	
	function doAction(str) {
		switch (str) {
			case "search":	 //조회
// 				if (kepGetDateDiff('st_from_date','st_to_date','D') > 183 ){
// 					alert("조회기간을 6개월 단위로 조회가 가능합니다.");
// 					return;
// 				}
			
				kepSearch("1");
				break;
				
			case "reload":	//초기화
				kepReload("sellerMpIvDeliveryDelayBuyerChoicePop");
				
				// hidden값은 공통에서 처리안됨.
				$("#st_buyer_code").val("");
				$("#st_from_date").val(kepToMonthAdd("2","M","noslash"));
				$("#st_to_date").val(kepGetNowTimeStr("YYYYMMDD",""));
				
				jspTableClean("table_list");
				break;
		}
	}
	
	function kepSearch(curPage){
 
		$('#sellerMpIvDeliveryDelayBuyerChoicePop').attr("action", "/mpiv/getSellerMpIvDeliveryDelayBuyerChoicePop.do").submit();
	}
	
</script>
</head>

<body onload="kep_onload_view()">
	<form name="sellerMpIvDeliveryDelayBuyerChoicePop" id="sellerMpIvDeliveryDelayBuyerChoicePop" method=post>

		<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
		<div id="popWrapper" style="height: 404px;">
			<div id="popHeader">
				<h1 class="title">납품지연 고객사 선택</h1>
				<p class="popClose">
					<a href="javascript:self.close()">
						<img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" />
					</a>
				</p>
			</div>
			<!--팝업내용입니다-->
			<div id="popContainer">
				<font color="#666666">
					&nbsp;&nbsp; ※ 고객사코드 클릭시 고객사 상세정보, 고객사명 클릭시 선택.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;최근한달 기준으로 조회됩니다.
				</font> 
				<br>
				<!--grid-->
				<div class="scrollArea" style="height: 305px">
					<table class="cont_t_list02" style="width: 100%">
						<caption>납품지연고객사 선택 리스트</caption>
						<colgroup>
							<col width="30%" />
							<col width="*" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">고객사 코드</th>
								<th scope="col">고객사 명</th>
								<th scope="col">품목 수</th>
							</tr>
						</thead>
						<tbody>
							<%
								if (_dataList == null || _dataList.size() == 0) {
							%>
							<tr bgcolor="#FFFFFF">
								<td colspan="3" align="center" height="50">
									<span class="font1">조회된 데이타가 없습니다.</span>
								</td>
							</tr>
							<%
								} else {
									for (int j = 0; j < _dataList.size(); j++) {
										Map<String, String> _tmp = _dataList.get(j);
							%>
							<tr>
								<td>
									<a href="javascript:doPop('agent', '<%=_tmp.get("BUYER")%>')" class="hyperLink"> <%=_tmp.get("BUYER")%></a>
								</td>
								<td class="left">
									<a href="javascript:setReturn('<%=_tmp.get("BUYER")%>','<%=_tmp.get("BUYER_NAME")%>')" class="hyperLink"> <%=_tmp.get("BUYER_NAME")%></a>
								</td>
								<td class="right mr05">
									<%=CommonUtil.formatNumber(_tmp.get("DELAY_CNT"), true, 0, 3)%>
								</td>
							</tr>
							<%
									}
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
