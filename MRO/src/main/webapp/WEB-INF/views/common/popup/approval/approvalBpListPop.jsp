<%--
**********************************************
* 화면 : (팝업) 결재대상 조회 - 표준DB 기준가 인하
* 기능 : DOC_TYPE = BP(단건) / BPM(일괄) 의 결재대상 노출 (v9 s12·s20 / 설계서 0831 slide 17)
*        - 상품기본정보 + 기존/변경 기준가 + 변경 기준가유형 + 인하율 + 변경사유
*        - 기준가 유형은 [변경] 기준만 노출(slide 17 [2])
*        - 인하율(%) = (기존기준가-변경기준가)/기존기준가*100, 소수점 한자리 반올림(slide 17 [3])
* 담당자 : 홍준우
* 착수일 : 2026-09-04
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
/* 12칸이라 폭이 밀리지 않게 고정폭 + 헤더 줄바꿈 방지 */
.bpList{ table-layout:fixed; }
.bpList th{ white-space:nowrap; font-size:12px; }
.bpList td{ font-size:12px; word-break:break-all; }
/* 변경 기준가부터는 [변경] 구간이라 헤더색을 구분한다 */
.bpList th.chg{ background:#e4eaf4; color:#31456b; }
/* [기존] 과 [변경] 사이 경계선 - 변경 기준가 칸 왼쪽에 세로줄 */
.bpList th.sep, .bpList td.sep{ border-left:2px solid #9fb0cc; }
/* 인하율 : 하락 파랑 / 상승 빨강 */
.bpList td.rateDown{ color:#1a4f9c; font-weight:bold; }
.bpList td.rateUp{ color:#c02020; font-weight:bold; }
</style>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data");

String DOCU_NO  = HtmlUtils.htmlEscape(CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""));
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),"");
String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),"");
String divHeight = "200px";
if("Y".equals(POP_FLAG)) divHeight = "600px";

int _cnt = (_dataList == null) ? 0 : _dataList.size();
%>
<body>
	<form name="approvalBpListPop" id="approvalBpListPop" method="post">
	<input type="hidden" name="VIEW" id="VIEW" value="approvalBpListPop">
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
				<table class="cont_t_list02 bpList" style="width:100%">
					<caption>기준가 인하 결재 리스트</caption>
					<colgroup>
						<col width="4%" />
						<col width="9%" />
						<col width="15%" />
						<col width="9%" />
						<col width="11%" />
						<col width="8%" />
						<col width="4%" />
						<col width="7%" />
						<col width="7%" />
						<col width="11%" />
						<col width="5%" />
						<col width="10%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">No</th>
							<th scope="col">상품정보코드</th>
							<th scope="col">품목명</th>
							<th scope="col">모델번호</th>
							<th scope="col">규격</th>
							<th scope="col">제조사</th>
							<th scope="col">단위</th>
							<th scope="col">기존 기준가</th>
							<th scope="col" class="chg sep">변경 기준가</th>
							<th scope="col" class="chg">변경 기준가 유형</th>
							<th scope="col" class="chg">인하율</th>
							<th scope="col" class="chg">변경사유</th>
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
	for (int j=0; j<_dataList.size(); j++) {
		Map<String,String> rowData = _dataList.get(j);

		/* 인하율 색 : 값이 (기존-변경)/기존 이라 하락이면 양수, 상승이면 음수로 온다 */
		String _rate = HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("DOWN_RATE")));
		String _rateClass = "center";
		if(!"".equals(_rate)){
			try {
				double _r = Double.parseDouble(_rate.replaceAll("[^0-9.-]", ""));
				if(_r > 0)      { _rateClass = "center rateDown"; }
				else if(_r < 0) { _rateClass = "center rateUp"; }
			} catch(NumberFormatException e) { }
		}
%>
					<tr>
						<td class="center" title="No"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("NO")))%></td>
						<td class="center" title="상품정보코드"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("CMS_CATLG_ID")))%></td>
						<td class="left" title="품목명"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("DESCRIPTION_LOC")))%></td>
						<td class="left" title="모델번호"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("MODEL_INFO")))%></td>
						<td class="left" title="규격"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
						<td class="left" title="제조사"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
						<td class="center" title="단위"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("ORDER_MEASURE")))%></td>
						<td class="right" title="기존 기준가"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("RE_BASE_PRICE_VIEW")))%></td>
						<td class="right sep" title="변경 기준가"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("CH_BASE_PRICE_VIEW")))%></td>
						<td class="left" title="변경 기준가 유형"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("CH_BASE_PRICE_TYPE_NM")))%></td>
						<td class="<%=_rateClass%>" title="인하율"><%=_rate%></td>
						<td class="left" title="변경사유"><%=HtmlUtils.htmlEscape(CommonUtil.nvl(rowData.get("CHANGE_REASON")))%></td>
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
