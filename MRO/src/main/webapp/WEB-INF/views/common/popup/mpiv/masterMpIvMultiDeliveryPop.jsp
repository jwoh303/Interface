<%--
**********************************************
* 메뉴 : 
* 화면 : Multi-delivery
* 기능 : 
* 프로그램 ID : PG_07_M_009_02
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
<%@ include file="../../../common/include/head.jspf"  %>

<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	
	String buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
	String po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
	String po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");  //  (조회조건)
	String rd_date = CommonUtil.nvl((String) request.getParameter("st_rd_date"),"");  //  (조회조건)
	String item_qty = CommonUtil.nvl((String) request.getParameter("st_item_qty"),"");  //  (조회조건)
	
	String seller = CommonUtil.nvl((String) request.getParameter("st_seller"),"");  //  (조회조건)
	String add_user_id = CommonUtil.nvl((String) request.getParameter("st_add_user_id"),"");  //  (조회조건)
	int inv_cnt = 0;
	
%>

<script type="text/javascript">

function masterNoNeDivsnDeliveryPlanAlterPop(){
	var inv_cnt = $("#st_inv_cnt").val();	
	if(inv_cnt == 0) {	
		location.href = "/mpiv/getMasterMpIvDivsnDeliveryPlanAlterPop.do?st_buyer=<%=buyer%>&st_po_no=<%=po_no%>&st_po_seq=<%=po_seq%>&st_rd_date=<%=rd_date%>&st_item_qty=<%=item_qty%>&st_seller=<%=seller%>&st_add_user_id=<%=add_user_id%>";
	} else {
		alert("송장이 생성되었으므로 변경할 수 없습니다.");
		return;
	}	
}

</script>
</head> 
<body onload="">
<form name="masterMpIvMultiDeliveryPop" id="masterMpIvMultiDeliveryPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:544px;">
		<div id="popHeader">
			<h1 class="title">분할납품 계획</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<!--조회영역-->
			<table class="cont_t_list02"  style="width:100%">
				<caption>분할납품계획 리스트</caption>
				<colgroup>
					<col width="20%" />
					<col width="30%" /> 
					<col width="20%" /> 
					<col width="*" /> 
				</colgroup>
				<tbody>
					<tr>
						<th style="text-align:left;">&nbsp;&nbsp;발주번호</th>
						<td class="left">&nbsp;<%=po_no%></td>
						<th style="text-align:left;">&nbsp;&nbsp;발주항번</th>
						<td class="left">&nbsp;<%=po_seq%></td>
					</tr>
					<tr>
						<th style="text-align:left;">&nbsp;&nbsp;발주수량</th>
						<td class="left">&nbsp;<%=item_qty%></td>
						<th style="text-align:left;">&nbsp;&nbsp;납기요청일</th>
						<td class="left">&nbsp;<%=CommonUtil.formatStrinigDate(rd_date)%></td>
					</tr>
				</tbody>
			</table>
			
			<!--grid-->
			<div class="scrollArea" style="height:338px">
				<table  class="cont_t_list02"  style="width:100%">
					<caption>분할납품계획 리스트</caption>
					<colgroup>
						<col width="20%" /> 
						<col width="30%" /> 
						<col width="*" /> 
					</colgroup>
					<thead>
						<tr>
							<th scope="col">순번</th> 
							<th scope="col">납품예정일</th> 
							<th scope="col">납품수량</th> 
						</tr>
					</thead>
					<tbody>
				<%
					if (_dataList == null || _dataList.size() == 0){
				%>
						<tr bgcolor="#FFFFFF">
							<td colspan="3" align="center" height = "280">
								<span class="font1">조회된 데이타가 없습니다.</span>
							</td> 
						</tr>
				<%	} else {
						
						for (int j=0; j<_dataList.size(); j++) {
							Map<String,String> _tmp = _dataList.get(j);
							
							if(!CommonUtil.nvl(String.valueOf(_tmp.get("INV_QTY"))).equals("0")){								
								inv_cnt++;
							}
				%>
						<tr>
							<td>
								<%=j+1%>
							</td>
							<td>
								<%=CommonUtil.nvl(_tmp.get("CD_DATE"))%>
							</td>
							<td>
								<%=CommonUtil.nvl(_tmp.get("CD_QTY"))%>
							</td>
						</tr> 
				<%		}
					}
				%>
					<input type="hidden" id="st_inv_cnt" name="st_inv_cnt" value="<%=inv_cnt%>" />
					</tbody>
				</table>
			</div>
			<br>
			<div id="searchBtnA02">
				<span class="btn_06"><a href="javascript:masterNoNeDivsnDeliveryPlanAlterPop();">납품계획변경</a></span>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
