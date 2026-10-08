<%--
**********************************************
* 화면 : (팝업) 결재대상 조회 - 표준DB 구매정보 매입단가 인상
* 기능 : DOC_TYPE = SP(단건) / SPM(일괄) 의 결재대상 노출
*        - 협력사별로 묶어 노출하고, 묶음마다 총 인상금액 · 총 인상율을 얹는다
*        - 인상율(%) = (변경-기존)/기존*100
*        ★ 매입단가는 인상이 결재 대상이다(기준가와 반대)
* 담당자 : 홍준우
* 착수일 : 2026-09-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="org.springframework.web.util.HtmlUtils"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style>
.spList{ table-layout:fixed; }
.spList th{ white-space:nowrap; font-size:12px; }
.spList td{ font-size:12px; word-break:break-all; }
.spList th.chg{ background:#e4eaf4; color:#31456b; }
.spList th.sep, .spList td.sep{ border-left:2px solid #9fb0cc; }
.spList td.rateUp{ color:#c02020; font-weight:bold; }
.spList tr.vendorRow td{ background:#eef2f8; color:#3c639c; font-weight:bold; }
</style>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data");

String DOCU_NO  = HtmlUtils.htmlEscape(CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""));
String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),"");
String divHeight = "200px";
if("Y".equals(POP_FLAG)) divHeight = "600px";

int _cnt = (_dataList == null) ? 0 : _dataList.size();

/* 협력사 묶음별 합계를 미리 계산해 둔다 - 묶음 헤더 행이 본문보다 먼저 그려지기 때문이다.
   SQL 이 협력사 순으로 정렬해 내리므로 연속 구간이 곧 한 묶음이다. */
java.util.Map<String,double[]> _sum = new java.util.LinkedHashMap<String,double[]>();
if (_cnt > 0) {
	for (int j=0; j<_cnt; j++) {
		Map<String,String> r = _dataList.get(j);
		String key = CommonUtil.nvl(r.get("AGENT"));
		double[] v = _sum.get(key);
		if (v == null) { v = new double[2]; _sum.put(key, v); }
		try {
			v[0] += Double.parseDouble(CommonUtil.nvl(r.get("RE_BUY_PRICE_RAW"), "0").replaceAll("[^0-9.-]", ""));
			v[1] += Double.parseDouble(CommonUtil.nvl(r.get("CH_BUY_PRICE_RAW"), "0").replaceAll("[^0-9.-]", ""));
		} catch (NumberFormatException e) { }
	}
}
%>
<body>
	<form name="approvalSpListPop" id="approvalSpListPop" method="post">
	<input type="hidden" name="VIEW" id="VIEW" value="approvalSpListPop">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
		<%
		if("Y".equals(POP_FLAG)){ %>
			<div id="popHeader">
			<h1 class="title">결재문서 상세</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
		<%}%>
		<!--팝업내용입니다-->
		<div id="popContainer">

			<div class="scrollArea" style="height:<%=divHeight %>">
				<!--grid-->
				<h3>결재번호 : <%=DOCU_NO %></h3>
				<table class="cont_t_list02 spList" style="width:100%">
					<caption>매입단가 인상 결재 리스트</caption>
					<colgroup>
						<col width="4%" />
						<col width="9%" />
						<col width="9%" />
						<col width="13%" />
						<col width="8%" />
						<col width="10%" />
						<col width="7%" />
						<col width="4%" />
						<col width="8%" />
						<col width="8%" />
						<col width="5%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">No</th>
							<th scope="col">상품정보코드</th>
							<th scope="col">구매정보코드</th>
							<th scope="col">품목명</th>
							<th scope="col">모델번호</th>
							<th scope="col">규격</th>
							<th scope="col">제조사</th>
							<th scope="col">단위</th>
							<th scope="col">변경 전</th>
							<th scope="col" class="chg sep">변경 후</th>
							<th scope="col" class="chg">인상율</th>
							<th scope="col" class="chg">인상사유</th>
						</tr>
					</thead>
					<tbody>
<%
if (_cnt == 0){
%>
					<tr bgcolor="#FFFFFF">
						<td colspan="12" align="center" height="50">
						<span>조회된 데이타가 없습니다.</span>
						</td>
					</tr>
<%
}else{
	String _prevAgent = null;
	for (int j=0; j<_cnt; j++) {
		Map<String,String> rowData = _dataList.get(j);
		String _agent = HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("AGENT")));

		if (!_agent.equals(_prevAgent)) {
			_prevAgent = _agent;

			String _agentNm = HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("AGENT_NAME")));
			if ("".equals(_agentNm)) { _agentNm = "(협력사 미지정)"; }

			double[] v = _sum.get(_agent);
			double _gap = (v == null) ? 0 : (v[1] - v[0]);
			String _gapTxt  = new java.text.DecimalFormat("#,##0").format(_gap);
			String _rateTxt = (v == null || v[0] == 0) ? "-"
			                : new java.text.DecimalFormat("#,##0.00").format(_gap / v[0] * 100) + "%";
%>
					<tr class="vendorRow">
						<td class="left" colspan="12">
							협력사 : <%=_agentNm %>&nbsp;&nbsp;/&nbsp;&nbsp;총 인상 금액 : <%=_gapTxt %>원&nbsp;&nbsp;/&nbsp;&nbsp;총 인상율 : <%=_rateTxt %>
						</td>
					</tr>
<%		}
%>
					<tr>
						<td class="center" title="No"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("NO")))%></td>
						<td class="center" title="상품정보코드"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("CMS_CATLG_ID")))%></td>
						<td class="center" title="구매정보코드"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("BUY_INFO_SEQ")))%></td>
						<td class="left" title="품목명"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("DESCRIPTION_LOC")))%></td>
						<td class="left" title="모델번호"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("MODEL_INFO")))%></td>
						<td class="left" title="규격"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
						<td class="left" title="제조사"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
						<td class="center" title="단위"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("ORDER_MEASURE")))%></td>
						<td class="right" title="변경 전"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("RE_BUY_PRICE_VIEW")))%></td>
						<td class="right sep" title="변경 후"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("CH_BUY_PRICE_VIEW")))%></td>
						<td class="center rateUp" title="인상율"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("UP_RATE")))%></td>
						<td class="left" title="인상사유"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("CHANGE_REASON")))%></td>
					</tr>
<%	}
}%>
					</tbody>
				</table>
				<p class="right mt05">전체 <%=_cnt %> 건</p>
			</div>
		</div>
	</div>
	</form>
</body>
</html>
