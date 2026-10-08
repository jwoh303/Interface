<%--
**********************************************
* 메뉴 : 정산관리>마감관리>마감정보조회
* 화면 : 마감정보조회
* 기능 : 협력사 마감 내역을 조회하고 세금계산서를 출력할 수 있다.
* 프로그램 ID : PG_07_A_018_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>

</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  // 요청부서코드
	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  // 요청부서명
	String st_ap_yn = CommonUtil.nvl((String) request.getParameter("st_ap_yn"),"");  //AP정산여부
	
	// 조회조건 E
%>

<body onload="kep_onload_view()">
	<div id="wrapper">
		<!-- 메뉴 S -->
		<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="sellerHeader" />
			<c:param name="part" value="header" />
		</c:import>

		<div id="container2">
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="sellerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			<!-- 메뉴 E -->
			<!--내용 시작-->
			<div id="ContArea">
				<h3>마감정보조회</h3>
				<!--버튼영역-->
				<div id="searchBtnA">
					<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> <span class="btn_reset"><a
						href="javascript:doAction('reload');">초기화</a></span>
				</div>
				<!--조회영역-->
				<form name="searchForm" id="searchForm" method="post">
					<!--HIDDEN-->
					<!-- 공통 -->
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>"> <input type="hidden" name="curPage"
						id="curPage" value="<%=curPage%>" />
					<!-- 화면 내 정의 -->
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}"> <input type="hidden" name="st_user_id"
						id="st_user_id" value="${sessionInfo.userId}">

					<div id="cont_searchA">
						<table class="cont_t_list01">
							<caption>조회</caption>
							<colgroup>
								<col width="8%" />
								<col width="25%" />
								<col width="9%" />
								<col width="25%" />
								<col width="8%" />
								<col width="25%" />
							</colgroup>

							<tbody>
								<tr>
									<td>조회일</td>
									<td colspan="3"><input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly
										style="width: 100px; text-align: center;" value="<%=st_from_date%>"> <a href="javascript:kepCalendar('st_from_date')"></a>
										&nbsp;~&nbsp; <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly
										style="width: 100px; text-align: center;" value="<%=st_to_date%>"> <a href="javascript:kepCalendar('st_to_date')"></a> 
							            <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
									</td>

									<td>고객사</td>
									<td><input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width: 65%; ime-mode: active"
										value="<%=st_buyer_name%>" onclick="javascript:doPop('icomcmpyPop');" READONLY> <input type="hidden" name="st_buyer_code"
										id="st_buyer_code" value="<%=st_buyer_code%>"> <a href="javascript:doPop('icomcmpyPop');"><img
											src="/resources/images/btn_search03.gif" alt="검색" /></a> <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img
											src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a></td>
								</tr>
								<tr>
									<td>정산여부</td>
									<td>
										<select id="st_ap_yn"  name="st_ap_yn" >
											<option value = "" <%if ("".equals(st_ap_yn)) {%>selected<%} %>>전체</option>
											<option value = "Y" <%if ("Y".equals(st_ap_yn)) {%>selected<%} %>>Y</option>
											<option value = "N" <%if ("N".equals(st_ap_yn)) {%>selected<%} %>>N</option>
										</select> 
									</td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</tr>
							</tbody>
						</table>
					</div>

					<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top: 3px;" /> <label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow">
							<option value="10" <%if ("10".equals(onepagerow)) {%> selected <%}%>>10건</option>
							<option value="20" <%if ("20".equals(onepagerow)) {%> selected <%}%>>20건</option>
							<option value="30" <%if ("30".equals(onepagerow)) {%> selected <%}%>>30건</option>
							<option value="40" <%if ("40".equals(onepagerow)) {%> selected <%}%>>40건</option>
							<option value="50" <%if ("50".equals(onepagerow)) {%> selected <%}%>>50건</option>
					</select> </span> <span class="fr">총건수 <%=total_cnt%></span> <br>
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<!-- 공통 -->
					<input type="hidden" name="curPage" id="curPage" value="<%=curPage%>" />

					<table id="table_list"  class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="10%" />
							<col width="10%" />
							<col width="*" />
							<col width="9%" />
							<col width="9%" />
							<col width="9%" />
							<col width="9%" />
							<col width="9%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">고객사<br>발주일
								</th>
								<th scope="col">품목코드<br>발주번호
								</th>
								<th scope="col">품명<br>규격
								</th>
								<th scope="col">단가<br>단위
								</th>
								<th scope="col">발주수량<br>발주금액
								</th>
								<th scope="col">납품총수량<br>납품금액
								</th>
								<th scope="col">입고총수량<br>입고금액
								</th>
								<th scope="col">납품예정일<br>납품확정일
								</th>
								<th scope="col">고객사발주번호</th>
							</tr>
						</thead>
						<tbody>
							<%
								if (_gridList == null || _gridList.size() == 0){
							%>
							<tr>
								<td colspan="9" align="center" height="50"><span>조회된 데이타가 없습니다.</span></td>
							</tr>
							<%
								}else{
								for (int j=0; j<_gridList.size(); j++) {
									Map<String,String> rowData = _gridList.get(j);
									String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
							%>
							<tr align="center" bgcolor="<%=tclass%>">
								<td title="고객사" class="td02"><a class="hyperLink" href="javascript:doPop('agent','<%=String.valueOf(rowData.get("BUYER2"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_NAME")))%></a></td>
								<td title="품목코드" class="td02"><a class="hyperLink"
									href="javascript:doPop('masterWmCoGoodsCodePop','<%=String.valueOf(rowData.get("BYIT_COMORG_CODE"))%>','<%=String.valueOf(rowData.get("BUYER_ITEM_NO"))%>','<%=String.valueOf(rowData.get("CONTRACT_NO"))%>','<%=String.valueOf(rowData.get("CONTRACT_SEQ"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></a></td>
								<td title="품명" class="td02 left"><%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%></td>
								<td title="단가" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("AGENT_PRICE")),true,0,3)%></td>
								<td title="발주수량" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("PO_QTY")),true,0,3)%></td>
								<td title="납품총수량" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("DELIVERY_QTY")),true,0,3)%></td>
								<td title="입고총수량" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("GR_QTY")),true,0,3)%></td>
								<td title="납품예정일" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
								<td rowspan="2" title="고객사발주번호" class="font1_black1"><%=String.valueOf(CommonUtil.nvl(rowData.get("LEGACY_PO_NO")))%></td>
							</tr>
							<tr bgcolor="<%=tclass%>">
								<td title="발주일" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
								<td title="발주번호" class="td02"><a class="hyperLink"
									href="javascript:doPop('commonMpIvOrderInfoPop','<%=String.valueOf(rowData.get("BUYER"))%>','<%=String.valueOf(rowData.get("PO_NO"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("PO_NO")))%></a></td>
								<td title="규격" class="td02 left"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
								<td title="단위" class="td02 right"><%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%></td>
								<td title="발주금액" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("PO_AMT")),true,0,3)%></td>
								<td title="납품금액" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("DELIVERY_AMT")),true,0,3)%></td>
								<td title="입고금액" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("GR_AMT")),true,0,3)%></td>
								<td title="납품확정일" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("DELIVERY_DATE"))%></td>
							</tr>
							<%
								} 
							        			}
							%>
						</tbody>
					</table>
					<!-- 페이징 -->
					<p id="paging" class="paging">
						<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow)%>
					</p>

					<!-- 버튼영역 -->
					<div class="btnArea">
						<div class="fr">
							<span class="btn_04 mr04"> <a href="javascript:doAction('reportOpen');">고객사별 집계</a>
							</span> <span class="btn_04"> <a href="javascript:doAction('excelDown');">엑셀다운로드</a>
							</span>
						</div>
					</div>
				</form>

				<form name="processForm" id="processForm" method="post">
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" /> <input type="hidden" name="total_cnt" id="total_cnt" value="<%=total_cnt%>" />
					<input type="hidden" name="curPage" id="curPage" value="<%=curPage%>" /> <input type="hidden" name="onepagerow" id="onepagerow"
						value="<%=onepagerow%>" />
					<div id="process"></div>
				</form>
			</div>

			<!--내용 종료-->
		</div>
		<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp"%>
	</div>
</body>

<script type="text/javascript">
	var popupSel = "";

	// 최초 화면 함수 
	function kep_onload_view() {

		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
<%if("".equals(st_from_date)){%>
	dateSetting();
<%}%>
	}

	function dateSetting() {
		// 일자 설정
		var tempDate = kepToMonthAdd("1", "M").replace(/[/]/gi, "");
		var tempYear = tempDate.substring(0, 4);
		var tempMonth = tempDate.substring(4, 6);
		var tempDay = lastDay(tempYear, tempMonth);

		$("#st_from_date").val(kepGetDateStr(tempYear + tempMonth + "01", "/"));
		$("#st_to_date").val(kepGetDateStr(tempDay, "/"));
	}

	//현재달의 마지막날(일자) 구하기
	function lastDay(y, m) {
		var d2, s = "";
		var year, month, day;

		d2 = new Date(y, m, "");

		year = d2.getFullYear();
		month = (d2.getMonth() + 1);
		day = d2.getDate();

		if (month < 10) {
			month = "0" + month;
		}
		if (day < 10) {
			day = "0" + day;
		}

		s = year.toString() + month.toString() + day.toString();

		return (s);
	}

	var st;
	//기능함수
	function doAction(str) {
		switch (str) {
		case "search": //조회
			if(!validCheck('true')){
				return;
			}
		
			kepSearch(1);
			break;

		case "reload": //초기화
			kepReload("searchForm");
			// 조회일 초기 셋팅
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");

			dateSetting();
// 			$("#st_from_date").val(kepToMonthAdd("1", "M"));
// 			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD', '/'));
			$("#st_buyer_code").val('');
// 			kepSearch(-1);
			jspTableClean("table_list");
			break;

		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpcl/excelSellerMpClClosingInfoList.do";
			document.forms.searchForm.submit();
			break;

		case "reportOpen": // 고객사별 집계
			var agent_code = $("#st_com_code").val();
			var st_from_date = $("#st_from_date").val().replace(/\//gi, "");
			var st_to_date = $("#st_to_date").val().replace(/\//gi, "");

			reportOpen("RD_06_S_001_91", "[" + agent_code + "][" + st_from_date + "][" + st_to_date + "]");
			break;

		}
	}

	// 조회
	function kepSearch(curPage) {
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
		document.forms.searchForm.curPage.value = curPage;
		$('#searchForm').attr("action", "/mpcl/getSellerMpClClosingInfoList.do").submit();
	}

	// 팝업 함수호출
	function doPop(str, value1, value2, value3, value4, value5) {
		switch (str) {
		case "icomcmpyPop": // 고객사 선택
			popupSel = "icomcmpyPop";
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "agent": // 회원사 정보
			popupSel = "agent";
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code=" + value1, "800,550,no");
			break;
		case "commonMpIvOrderInfoPop": // 발주정보 조회
			popupSel = "commonMpIvOrderInfoPop";
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer=" + value1 + "&st_po_no=" + value2, "930,600,no");
			break;
		case "masterWmCoGoodsCodePop": // 제품 상세정보
			popupSel = "masterWmCoGoodsCodePop";
			//openSearchPopup("/wmco/showMasterWmCoGoodsCodePop.do", "?BUYER_ITEM_NO=" + value2 + "&BYIT_COMORG_CODE=" + value1 + "&CONTRACT_NO="
			//		+ value3 + "&CONTRACT_SEQ=" + value4, "800,255,no");
			
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			
			break;
		}
	}

	// 콜백함수(파일명은 모두 동일)
	function setPopupReturn(code, text) {
		if (popupSel = "icomcmpyPop") {
			$("#st_buyer_code").val(code);
			$("#st_buyer_name").val(text);
		}
	}
	
	function validCheck() {
		if (kepGetDateDiff('st_from_date','st_to_date','D') > 31 ){
			alert("조회기간을 1개월 단위로 조회가 가능합니다.");
			return false;
		}
		return true;
	}	
</script>
</html>
