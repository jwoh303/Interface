<%--
**********************************************
* 메뉴 : HOME>구매대행홈
* 화면 : 구매대행홈
* 기능 : 
* 프로그램 ID : PG_07_M_014_00
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-08-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	//공통
	@SuppressWarnings (value="unchecked")
	List<Map<String, String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String _authGbn = (String) request.getAttribute("authGbn");
	// DL : KEP200417
	// BL : KEP2109035 KEP200040
	
	
	String _yyyyMm = CommonUtil.formatDateNoDateGubun(new Date(),0);
	String _lastYyyyMm = CommonUtil.addDate(new Date(), "M", -1, 0);
	
	String _currentYear = _yyyyMm.substring(0,4);
	String _currentMonth = _yyyyMm.substring(4,6);
	
	String _lastMonth = _lastYyyyMm.substring(4,6);
	
	String _deptNm	= _sessionInfo.getDepartmentName();
	String _userNm	= _sessionInfo.getUserNameLoc();
%>
<script>
	// 팝업 함수호출
	function doPop(str) {
		switch (str) {
			case "companyMng": // 회원사관리
				openSearchPopup('/common/misUserSelectAllPop2.do','','500,485,no');
				break;
			case "buyerMng": // 관리구매사지정
				openSearchPopup('/common/showAdminSafetyCompanyCodePop.do','?1=1','870,425,no');
				break;
		}
	}
	
</script>
</head>
<body>

<c:if test="${param.noHeaderGbn ne 'Y' }">
<div id="wrapper">
	<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
	<c:import charEncoding="utf-8" url="/menu/menu.do" >
	<c:param name="page" value="masterHeader"/>
	<c:param name="part" value="masterHeader"/>
	<c:param name="upperId" value="${param.upperId}"/>
	</c:import>
</c:if>

<!--실적현황 내용시작-->
<div id="admin_home">
	<div id="main_table_div"> 
		<div class="main_table_summ">
			<div class="LinkImg" >
				<ul>
					<!-- layerView('layerMainWorkProcess','show'); -->
					<li class="bgNo"><a href="javascript:getMasterMdAmProxyMainWorkProcess();"><img src="/resources/images/m_link_img5.gif" /> <p>나의 주요업무처리</br><span>바로가기 >></span></p></a></li>
					<li class="bgYes"><a href="javascript:layerView('layerManageIndexDefine','show');"><img src="/resources/images/m_link_img6.gif" /> <p>관리지표정의</br><span>바로가기 >></span></p></a></li>
					<li class="bgYes"><a href="javascript:doPop('companyMng');"><img src="/resources/images/m_link_img7.gif"/><p>회원사관리</br><span>바로가기 >></span></p></a></li>
					<li class="bgYes"><a href="javascript:doPop('buyerMng');"><img src="/resources/images/m_link_img8.gif" /><p>관리고객사지정</br><span>바로가기 >></span></p></a></li>
				</ul>
			</div>
	<%
		if(_authGbn.equals("DL") || _authGbn.equals("BL")){
	%>
			<p class="B2BTit">주요처리업무<span>※ 기준 : 데이타 집계 1시간, (예외 : I/F오류건 실시간, 실적미등록 매일 8시 집계)</span></p>
	<%
		} else {
	%>
			<p class="B2BTit"><%=_currentMonth%>월 사업실적 [<%=_deptNm%> <%=_userNm%>]<span>(단위 : 천원)</span></p>
	<%
		}
	%>
		</div>
	
	<%
		if(_authGbn.equals("DL") || _authGbn.equals("BL")){
	%>
			<div class="wrap_tbl">
				<table class="t_masterMain05" summary="주요업무처리" >
					<colgroup>
						<col width="150px"><!--부서-->
						<col width="80px"><!--오류-->
						<col width="80px"><!--미접수-->
						<col width="80px"><!--장기미접수-->
						<col width="80px"><!--지연예상-->
						<col width="80px"><!--지연-->
						<col width="80px"><!--장기지연-->
						<col width="80px"><!--악성지연-->
						<col width="85px"><!--실적미등록-->
						<col width="95px"><!--고객사미입고-->
						<col width="85px"><!--의뢰건-->
						<col width="85px"><!--제출지연-->
						<col width="85px"><!--장기지연-->
					</colgroup>
					<thead>
						<tr>
							<th rowspan="2" class="BGblue"><span id="spanDeptNm">부서</span></th>
							<th rowspan="2" class="BGgrey">I/F오류</th>
							<th colspan="2" class="BGgrey">수주접수</th>
							<th colspan="6" class="BGgrey">납기</th>
							<th colspan="3" class="BGgrey">견적</th>
						</tr>
						<tr>
							<th class="BGgreen_S">미접수</th>
							<th class="BGgreen_S">장기미접수</th>
							<th class="BGblue_S">지연예상</th>
							<th class="BGblue_S">지연</th>
							<th class="BGblue_S">장기지연</th>
							<th class="BGblue_S">악성지연</th>
							<th class="BGblue_S">실적미등록</th>
							<th class="BGblue_S">고객사미입고</th>
							<th class="BGred_S">의뢰건</th>
							<th class="BGred_S">제출지연</th>
							<th class="BGred_S">장기지연</th>
						</tr>
					</thead>
					<tbody>
					<%
						if (_gridList == null || _gridList.size() == 0){
					%>
						<tr>
							<td colspan="12" class="time" height="50">
								조회된 데이타가 없습니다.
							</td>
						</tr>
					<%
						} else {
							
							int ifErrCnt = 0;
							int ivDoNoCnt = 0;
							int ivLongDoNoCnt = 0;
							int ivExpectDelayCnt = 0;
							int ivDelayCnt = 0;
							int ivLongExpectDelayCnt = 0;
							int ivBadDelayCnt = 0;
							int ivDiNoCnt = 0;
							int grNoDelay = 0;
							int qtRecvCnt = 0;
							int qtDelayCnt = 0;
							int qtLongDelayCnt = 0;
							
							for (int j=0; j<_gridList.size(); j++) {
								Map<String,String> rowData = _gridList.get(j);

								ifErrCnt 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("IF_ERR_CNT"),"0"));
								ivDoNoCnt 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("IV_DO_NO_CNT"),"0"));
								ivLongDoNoCnt 			+= Integer.parseInt(CommonUtil.nvl(rowData.get("IV_LONG_DO_NO_CNT"),"0"));
								ivExpectDelayCnt		+= Integer.parseInt(CommonUtil.nvl(rowData.get("IV_EXPECT_DELAY_CNT"),"0"));
								ivDelayCnt 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("IV_DELAY_CNT"),"0"));
								ivLongExpectDelayCnt	+= Integer.parseInt(CommonUtil.nvl(rowData.get("IV_LONG_EXPECT_DELAY_CNT"),"0"));
								ivBadDelayCnt 			+= Integer.parseInt(CommonUtil.nvl(rowData.get("IV_BAD_DELAY_CNT"),"0"));
								ivDiNoCnt 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("IV_DI_NO_CNT"),"0"));
								grNoDelay 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("GR_NO_DELAY"),"0"));
								qtRecvCnt 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("QT_RECV_CNT"),"0"));
								qtDelayCnt 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("QT_DELAY_CNT"),"0"));
								qtLongDelayCnt 			+= Integer.parseInt(CommonUtil.nvl(rowData.get("QT_LONG_DELAY_CNT"),"0"));
								
					%>
						<tr>
							<th class="row" scope="row"><%=CommonUtil.nvl(rowData.get("DEPT_NAME"))%></th>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IF_ERR_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IV_DO_NO_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IV_LONG_DO_NO_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IV_EXPECT_DELAY_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IV_DELAY_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IV_LONG_EXPECT_DELAY_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IV_BAD_DELAY_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("IV_DI_NO_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("GR_NO_DELAY"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("QT_RECV_CNT"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("QT_DELAY_CNT"),true,0,3)%></td>
							<td class="last pr10"><%=CommonUtil.formatNumber(rowData.get("QT_LONG_DELAY_CNT"),true,0,3)%></td>
						</tr>
					<%
							}
					%>
						<tr class="last">
							<th class="row" scope="row">합계</th>
							<td class="pr10"><%=CommonUtil.formatNumber(ifErrCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ivDoNoCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ivLongDoNoCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ivExpectDelayCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ivDelayCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ivLongExpectDelayCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ivBadDelayCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ivDiNoCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(grNoDelay,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(qtRecvCnt,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(qtDelayCnt,true,0,3)%></td>
							<td class="last pr10"><%=CommonUtil.formatNumber(qtLongDelayCnt,true,0,3)%></td>
						</tr>
					<%
						}
					%>
					
					</tbody>
				</table>
			</div>
	<%
		} else {
	%>
			<div class="wrap_tbl">
				<table class="t_masterMain05" summary="사업목표" >
					<colgroup>
						<col width="204px;">
						<col width="157px;">
						<col width="157px;">
						<col width="157px;">
						<col width="157px;">
						<col width="157px;">
						<col width="157px;">
					</colgroup>
					<thead>
						<tr>
							<th rowspan="2" class="BGgreen">고객사</th>
							<th colspan="2" class="BGblue"><%=_currentYear%>년 누계</th>
							<th colspan="2" class="BGblue"><%=_lastMonth%>월실적</th>
							<th colspan="2" class="BGblue"><%=_currentMonth%>월실적</th>
						</tr>
						<tr>
							<th class="BGgrey">매출</th>
							<th class="BGgrey">매출이익</th>
							<th class="BGgrey">매출</th>
							<th class="BGgrey">매출이익</th>
							<th class="BGgrey">매출</th>
							<th class="BGgrey">매출이익</th>
						</tr>
					</thead>
					<tbody>
					<%
						if (_gridList == null || _gridList.size() == 0){
					%>
						<tr>
							<td colspan="7" class="time" height="50">
								조회된 데이타가 없습니다.
							</td>
						</tr>
					<%
						} else {
							int ttlSaleWarehousing = 0;
							int ttlSaleMarginWarehousing = 0;
							int lmSaleWarehousing = 0;
							int lmSaleMarginWarehousing = 0;
							int smSaleDelivery = 0;
							int smSaleMarginDelivery = 0;
							
							for (int j=0; j<_gridList.size(); j++) {
								Map<String,String> rowData = _gridList.get(j);
								
								ttlSaleWarehousing			+= Integer.parseInt(CommonUtil.nvl(rowData.get("TTL_SALE_WAREHOUSING"),"0"));
								ttlSaleMarginWarehousing	+= Integer.parseInt(CommonUtil.nvl(rowData.get("TTL_SALE_MARGIN_WAREHOUSING"),"0"));
								lmSaleWarehousing 			+= Integer.parseInt(CommonUtil.nvl(rowData.get("LM_SALE_WAREHOUSING"),"0"));
								lmSaleMarginWarehousing 	+= Integer.parseInt(CommonUtil.nvl(rowData.get("LM_SALE_MARGIN_WAREHOUSING"),"0"));
								smSaleDelivery 				+= Integer.parseInt(CommonUtil.nvl(rowData.get("M_SALE_WAREHOUSING"),"0"));
								smSaleMarginDelivery 		+= Integer.parseInt(CommonUtil.nvl(rowData.get("M_SALE_MARGIN_WAREHOUSING"),"0"));
					%>
						<tr>
							<th class="row" scope="row"><%=CommonUtil.nvl(rowData.get("BUYER_NM"))%></th>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("TTL_SALE_WAREHOUSING"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("TTL_SALE_MARGIN_WAREHOUSING"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("LM_SALE_WAREHOUSING"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("LM_SALE_MARGIN_WAREHOUSING"),true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(rowData.get("M_SALE_WAREHOUSING"),true,0,3)%></td>
							<td class="last pr10"><%=CommonUtil.formatNumber(rowData.get("M_SALE_MARGIN_WAREHOUSING"),true,0,3)%></td>
						</tr>
					<%
							}
					%>
						<tr class="last">
							<th class="row" scope="row">합계</th>
							<td class="pr10"><%=CommonUtil.formatNumber(ttlSaleWarehousing,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(ttlSaleMarginWarehousing,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(lmSaleWarehousing,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(lmSaleMarginWarehousing,true,0,3)%></td>
							<td class="pr10"><%=CommonUtil.formatNumber(smSaleDelivery,true,0,3)%></td>
							<td class="last pr10"><%=CommonUtil.formatNumber(smSaleMarginDelivery,true,0,3)%></td>
						</tr>
					<%
						}
					%>
					
					</tbody>
				</table>
			</div>
	<%
		}
	%>
	</div>
</div>
<!--내용 종료-->	      
<c:if test="${param.noHeaderGbn ne 'Y' }"> 
	<%@ include file="/WEB-INF/views/common/include/masterFooter.jsp" %>
	</div>
</c:if>    

	
</body>
</html>			
