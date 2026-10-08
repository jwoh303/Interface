<%--
**********************************************
* 메뉴 : HOME>판촉물제안하기>상품상세보기
* 화면 : 상품상세보기
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김경례 ( 설계 :  )
* 착수일 : 2014-10-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _dataList = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 
%>
<script type="text/javascript">
//<!--

//-->
</script>
</head>
<body>
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2" style="margin-right: 20px;">
<!--내용 시작-->
<div id="ContArea">
	<h3>상품상세보기</h3>
	<div id="searchBtnA">
	</div>
	<table  style="width:100%">
		<caption>상품상세보기</caption>
		<colgroup>
			<col width="220px" />
			<col width="*" />
		</colgroup>
		<tbody>
			<tr>
				<td width="220" vAlign="top">
					<table border="0" cellSpacing="0" cellPadding="0" width="100%">
						<tbody>
							<tr>
								<td height="230" vAlign="top" align="center">&nbsp;&nbsp; &nbsp;
									<img src = "/resources/images/icon_emptyimg.gif"  id="image1" name="image1" width="200" height="200">
								</td>
								<td width="20">&nbsp;</TD>
							</tr>
						</tbody>
					</table>
				</td>
				<td align="center">
					<table  class="cont_t_list06"  style="width:100%">
						<colgroup>
							<col width="120px" />
							<col width="32%" />
							<col width="120px" />
							<col width="32%" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">품목코드</th>
								<td>
									<%=CommonUtil.nvl(_dataList.get("ITEM_NO"))%></b>&nbsp;(<b><%=CommonUtil.nvl(_dataList.get("STATUS"))%></b>)
								</td>
								<th scope="row">현재상품상태</th>
								<td>
									<%=CommonUtil.nvl(_dataList.get("ITEM_STATUS"))%>
								</td>
							</tr>
							<tr>
								<th scope="row">품목명</th>
								<td colspan="3">
									<%=CommonUtil.nvl(_dataList.get("DESCRIPTION"))%>
								</td>
							</tr>
							<tr>
								<th scope="row">품목규격</th>
								<td colspan="3">
									<%=CommonUtil.nvl(_dataList.get("SPECIFICATION"))%>
								</td>
							</tr>
							<tr>
								<th scope="row">제조사</th>
								<td>
									<%=CommonUtil.nvl(_dataList.get("MAKER_NAME"))%>
								</td>
								<th scope="row">모델명</th>
								<td>
									<%=CommonUtil.nvl(_dataList.get("MAKER_PART_NO"))%>
								</td>
							</tr>
							<tr>
								<th scope="row">재질</th>
								<td>
									<%=CommonUtil.nvl(_dataList.get("QUALITY"))%>
								</td>
								<th scope="row">원산지</th>
								<td>
									<%=CommonUtil.nvl(_dataList.get("ORIGIN_TEXT"))%>
								</td>
							</tr>
							<tr>
								<th scope="row">배송기간</th>
								<td>
									최소(<%=CommonUtil.nvl(_dataList.get("MIN_DELIVERY_LT"))%> )일~최대(<%=CommonUtil.nvl(_dataList.get("MAX_DELIVERY_LT"))%> )일
								</td>
								<th scope="row">제작기간</th>
								<td>
									<%=CommonUtil.nvl(_dataList.get("MAKE_LT"))%>
								</td>
							</tr>
							<tr>
								<th scope="row">최소수량</th>
								<td>
									<%=CommonUtil.nvl(String.valueOf(_dataList.get("MIN_ORDER_QTY")))%>개
								</td>
								<th scope="row">단가(원)</th>
								<td>
									<b><%=CommonUtil.nvl(String.valueOf(_dataList.get("USER_PRICE")))%></b>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table  class="cont_t_list09"  style="width:100%">
						<colgroup>
							<col width="40%" />
							<col width="15%" />
							<col width="15%" />
							<col width="15%" />
							<col width="15%" />
						</colgroup>
						<tbody>
							<tr height="30">
								<th scope="row" style="padding:3px 10px; text-align:left;">인쇄옵션</th>
								<th scope="row" style="padding:3px 10px; text-align:left;" colspan="4">수량별 제안 단가</th>
							</tr>
							<tr height="30">
								<td rowspan="2" class="left">
									<%=CommonUtil.repl(_dataList.get("PRINT_OPT_PRICE"))%>
								</td>
								<td>
									<%=CommonUtil.nvl(_dataList.get("QTY1"))%>
								</td>
								<td>
									<%=CommonUtil.nvl(_dataList.get("QTY2"))%>
								</td>
								<td>
									<%=CommonUtil.nvl(_dataList.get("QTY3"))%>
								</td>
								<td>
									<%=CommonUtil.nvl(_dataList.get("QTY4"))%>
								</td>
							</tr>
							<tr height="30">
								<td>
									<%=CommonUtil.formatNumber(_dataList.get("PRICE1"),true,0,3)%>원
								</td>
								<td>
									<%=CommonUtil.formatNumber(_dataList.get("PRICE2"),true,0,3)%>원
								</td>
								<td>
									<%=CommonUtil.formatNumber(_dataList.get("PRICE3"),true,0,3)%>원
								</td>
								<td>
									<%=CommonUtil.formatNumber(_dataList.get("PRICE4"),true,0,3)%>원
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table  class="cont_t_list09"  style="width:100%">
						<colgroup>
							<col width="95%" />
						</colgroup>
						<tbody>
							<tr height="30">
								<th scope="row" style="padding:3px 10px; text-align:left;">상세정보</th>
							</tr>
							<tr height="50">
								<td class="left">
									<%=CommonUtil.repl(_dataList.get("REMARK"))%>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table  class="cont_t_list09"  style="width:100%">
						<colgroup>
							<col width="50%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr height="30">
								<th scope="row" style="padding:3px 10px; text-align:left;">삭제사유</th>
								<th scope="row" style="padding:3px 10px; text-align:left;">반려사유</th>
							</tr>
							<tr height="30">
								<td>
									<%=CommonUtil.nvl(_dataList.get("D_REMARK"))%>
								</td>
								<td>
									<%=CommonUtil.nvl(_dataList.get("B_REMARK"))%>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</tbody>
	</table>
	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fr">
			<span class="btn_04">
				<a href="/none/showSellerNoNeSaleshookProposal.do?search_yn=Y">목록으로</a>
			</span>
		</div>
	</div>
</div>

<!--내용 종료-->
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
