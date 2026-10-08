<%--
**********************************************
* 메뉴 : 납품관리>제작/수입품 일정등록>제작/수입품 일정등록상세
* 화면 : 제작/수입품 일정등록상세
* 기능 : 제작/수입품 일정등록상세
* 프로그램 ID : PG_07_A_013_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/tld/commonUtil.tld" prefix="cu"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>
</head>
<script type="text/javascript">
	var popupSel = "";

	// 최초 화면 함수 
	function kep_onload_view() {
		//조회조건 초기화(기존값 재설정)
		initSearchCondition("searchForm", "st_from_date", "${st_from_date}"); //시작일(FROM)
		initSearchCondition("searchForm", "st_to_date", "${st_to_date}"); //시작일(TO)
		initSearchCondition("searchForm", "st_recv_flag", "${st_recv_flag}"); //진행상태
		initSearchCondition("searchForm", "st_desc_spec", "${st_desc_spec}"); //품목명/규격
		initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}"); //품목코드
		initSearchCondition("searchForm", "st_buyer", "${st_buyer}"); //요청공장
		initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}"); //요청공장
		initSearchCondition("searchForm", "st_po_no", "${st_po_no}"); //요청공장
		initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}"); //요청공장
		initSearchCondition("searchForm", "st_item_make_type", "${st_item_make_type}"); //요청공장

		initSearchCondition("searchForm", "st_date_type", "${st_date_type}"); //정렬기준
		initSearchCondition("searchForm", "st_order_by", "${st_order_by}"); //정렬순서
		initSearchCondition("searchForm", "onepagerow", "${onepagerow }"); //페이징단위
		$("#st_from_date").val(kepToMonthAdd("2", "M"));
	}

	var st;
	//기능함수
	function doAction(str) {
		switch (str) {
		case "search": //조회
			kepSearch($("#curPage").val());
			break;

		case "reload": //초기화
			kepReload("searchForm");
			// 조회일 초기 셋팅
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			$("#st_from_date").val(kepToMonthAdd("2", "M"));
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD', '/'));
			jspTableClean("table_list");
			break;

		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpds/excelSellerMpDscropProtectList.do";
			document.forms.searchForm.submit();
			break;

		case "cartCheck": // 저장	
			var btnEvent = "cartCheck";
			if (setGridData(btnEvent)) {
				if (!confirm("이동 하시겠습니까?")) {
					return;
				}
				kepAjaxFormCall("/mpds/saveSellerMpDscropProtectList.do",
						"processForm", btnEvent);
			}
			break;

		case "printPum": // 견적서 출력
			alert("견적서 출력");
			break;

		}
	}

	// 조회
	function kepSearch(curPage) {
		if (kep_dateSearchCheck($("#st_from_date").val(), $("#st_to_date")
				.val()) == false)
			return;
		document.forms.searchForm.curPage.value = curPage;
		$('#searchForm').attr("action",
				"/mpiv/getSellerMpIvMkImScheduleRegList.do").submit();
	}

	// 팝업 함수호출
	function doPop(str, value1, value2, value3, value4, value5, value6) {
		switch (str) {
		case "catalogDetailPop": // 품목코드
			openSearchPopup('/common/catalogDetailPop.do', '?BUYER=' + value1
					+ '&BUYER_ITEM_NO=' + value2, '800,290,no');
			break;
			
		case "sellerMpIvMkImScheduleRegDetailPop": // 포장지 도안 관리 등록 (작물보호)
			openSearchPopup('/mpiv/getSellerMpIvMkImScheduleRegDetailPop.do',
					'?st_buyer=' + value1
					+ '&st_po_no=' + value2
					+ '&st_po_seq=' + value3
					+ '&st_opkg_seq=' + value4
					+ '&st_rd_date=' + value5
					+ '&st_buyer_item_no=' + value6
					+ '&st_open_type=agent'
					, '720,715,1,1');
			break;
			
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "720,505,no");
			break;
			
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
			
		case "attach"://파일 첨부
			popupSel = "fileUpload";
			gridIndex = value2;
			var type="PO";
			var viewType="R";
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			break;
			
		}
	}
	function setBuyerChoiceReturn(buyer, com_name){
		$("#st_buyer_code").val(buyer);
		$("#st_buyer_name").val(com_name);
	}
	// 콜백함수(파일명은 모두 동일)
	function setPopupReturn(code, text) {
		if (popupSel = "dept") {
			$("#st_btoa_user_dept_code").val(code);
			$("#st_btoa_user_dept_name").val(text);
		}
	}

	// 선택된 그리드 값을 셋팅
	function setGridData(btnEvent) {
		var returnValue = true;
		var chkGridValue = {
			keys : [ "st_status" ],
			value0 : [ "합의완료", "장바구니" ],
			msg0 : [ "합의완료된 상품들만 장바구니에 담을수 있습니다." ]
		};
		var formArr = getFormToArr("document.forms.contentForm", true, chkGridValue);
		if (formArr != null && formArr != "") {
			document.forms.processForm.s_SAVENAME.value = formArr[0];
			$("#process").html(formArr[1]);
		} else {
			alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
			returnValue = false;
		}

		return returnValue;
	}
	// ajax 공통 호출후 성공시 처리 함수
	function kepAjaxSuccess(pMethod, response) {
		var msg = response.Message;
		if (msg != "") {
			alert(msg);
		}
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}
	
	function setFristPage(){
		$("#curPage").val(1);
	}
</script>
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
			<c:set var="total_cnt" value='0' />
			<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1) %>' />
			<c:forEach items="${data}" var="_gridList" begin="1" end="1">
				<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
			</c:forEach>
			<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
			<c:set var="onepagerow" value='${onepagerow }' />
			<!-- 메뉴 E -->
			<!--내용 시작-->
			<div id="ContArea">
				<h3>제작품/수입품 일정 등록 및 조회</h3>
				<!--버튼영역-->
				<div id="searchBtnA">
					<span class="btn_search"><a
						href="javascript:doAction('search');">조회</a></span> <span
						class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
				</div>
				<!--조회영역-->
				<form name="searchForm" id="searchForm" method="post">
					<!-- HIDDEN -->
					<!-- 공통 -->
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" name="curPage" id="curPage" value='<c:out value="${curPage }"/>' />
					<!-- 화면 내 정의 -->
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

					<div id="cont_searchA">
						<table class="cont_t_list01">
							<caption>조회</caption>
							<colgroup>
								<col width="10%" />
								<col width="25%" />
								<col width="7%" />
								<col width="25%" />
								<col width="7%" />
								<col width="25%" />
							</colgroup>
							<tbody>
								<tr>
									<td align="right">
										<select name="st_date_type" id="st_date_type" class="TitSelect">
											<option value="PO">발주일</option>
											<option value="RD">납기요청일</option>
											<option value="DS">납품예정일</option>
											<option value="MK">처리예정일</option>
										</select>
									</td>
									<td colspan="">
										<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width: 30%; text-align: center;" value="">
										 ~ 
										<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width: 30%; text-align: center;" value="">
									</td>
									<td>진행상태</td>
									<td>
										<select name="st_recv_flag" id="st_recv_flag">
											<option value="">전체</option>
											<option value="BG">신규</option>
											<option value="IG">진행중</option>
											<option value="ED">완료</option>
										</select>
									</td>
									<td>품목타입</td>
									<td>
										<select name="st_item_make_type" id="st_item_make_type">
											<option value="">전체</option>
											<option value="MK">주문제작</option>
											<option value="IM">수입품</option>
										</select>
									</td>
								</tr>
								<tr>
									<td>고객사</td>
									<td>
										<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
										<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
										<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');">
											<img src="/resources/images/btn_search03.gif" alt="검색" />
										</a>
										<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');">
											<img src="/resources/images/btn_eraser2.gif" alt="조건지우기">
										</a>
									</td>
									<td>발주번호</td>
									<td>
										<input type="text" name="st_po_no" id="st_po_no" value="" style="ime-mode: active; width: 87%" value="" onKeyDown="kepEnter()">
									</td>
									<td>품목코드</td>
									<td>
<!-- 										<input type="text" name="st_description" id="st_description" style="width: 87%" value="" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()"> -->
										<input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width: 87%" value="" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div>
						<table style="width: 100%;">
							<tr>
								<td align="left">
									<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top: 3px;" />
									<label for="b_no02" class="hidden">정렬개수선택</label>
									<select name="onepagerow" id="onepagerow" onchange="javascript:setFristPage()">
										<option value="10">10건</option>
										<option value="20">20건</option>
										<option value="30">30건</option>
										<option value="40">40건</option>
										<option value="50">50건</option>
									</select>
									<span style="color: blue">※</span>날짜에 <span style="color: red">붉은표시</span>는 완료 1일 전입니다.
								</td>
							</tr>
						</table>
					</div>
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value='<c:out value="${curPage }"/>' />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="13%" />
							<col width="8%" />
							<col width="9%" />
							<col width="*" />
							<col width="8%" />
							<col width="10%" />
							<col width="9%" />
							<col width="12%" />
							<col width="6%" />
						</colgroup>
						<thead>
							<tr>
								<th rowspan="2">고객사</th>
								<th>발주번호<br>품목코드</th>
								<th>관리번호<br>발주금액</th>
								<th rowspan="2">품목명<br/>규격</th>
								<th>품목구분</th>
								<th rowspan="2">완료기한<br/>(처리예정일)</th>
								<th>납기요청일<br>납품예정일</th>
								<th rowspan="2">운영사 비고<BR>협력사 비고</th>
								<th colspan="2">운영사<BR>첨부파일</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${data == null || fn:length(data) == 0}">
									<tr>
										<td colspan="15" align="center" height="50">
											<span>조회된 데이타가 없습니다.</span>
										</td>
									</tr>
								</c:when>
								<c:when test="${fn:length(data) > 0}">
									<c:forEach items="${data}" var="_gridList">
										<c:set var="tclass" value='${(_gridList.RN % 2 != 0)? "#FFFFFF" : "#FAFAFA" }' />
										<tr align="center" bgcolor="${tclass }">
											<td title="고객사" align="center" rowspan="1">${_gridList.BUYER_NAME }</td>
											<td title="발주번호/품목코드" align="center">
												<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('commonMpIvOrderInfoPop','${_gridList.BUYER }','${_gridList.PO_NO }');">
													${_gridList.PO_NO }
												</a>
												<br />
												<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('catalogDetailPop','${_gridList.BUYER }','${_gridList.BUYER_ITEM_NO }');">
													${_gridList.BUYER_ITEM_NO }
												</a>
											</td>
											<c:set var="itemAmt" value="${_gridList.ITEM_AMT }"/>
											<td title="관리번호/발주금액" class="right">
												${_gridList.REF_PR_NO }
												<br />
												<%= CommonUtil.formatNumber(pageContext.getAttribute("itemAmt"), true, 0, 1) %>&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
											<td title="품목명//규격" class="left" rowspan="1">${_gridList.DESCRIPTION }<br />${_gridList.SPECIFICATION }</td>
											<td title="품목구분" align="center">${_gridList.ITEM_MAKE_TYPE_NAME }<br/>${_gridList.MK_TYPE_NAME }</td>
											<td title="일정등록" align="center">
												<a class="hyperLink" href="javascript:doPop('sellerMpIvMkImScheduleRegDetailPop','${_gridList.BUYER }','${_gridList.PO_NO }','${_gridList.PO_SEQ }','0013112','20150126','13010005');">
													<span style="color:blue">
														<b>${_gridList.RECV_FLAG_NAME }</b>
													</span> 
													<br />
													<c:choose>
														<c:when test="${_gridList.MK_DATE == CheckDate }">
															<span style="color:red">
																<b>${cu:formatStrinigDate(_gridList.MK_DATE) }</b>
															</span>
														</c:when>
														<c:otherwise>
															<b>${cu:formatStrinigDate(_gridList.MK_DATE) }</b>
														</c:otherwise>
													</c:choose>
												</a>
											</td>
											<td title="납기요청일/납품예정일" align="center">
												<c:choose>
													<c:when test="${_gridList.RD_DATE == CheckDate }">
														<span style="color:red">
															<b>${cu:formatStrinigDate(_gridList.RD_DATE) }</b>
														</span>
													</c:when>
													<c:otherwise>
														<b>${cu:formatStrinigDate(_gridList.RD_DATE) }</b>
													</c:otherwise>
												</c:choose>
												<br />
												<c:choose>
													<c:when test="${_gridList.DS_DATE == CheckDate }">
														<span style="color:red">
															<b>${cu:formatStrinigDate(_gridList.DS_DATE) }</b>
														</span>
													</c:when>
													<c:otherwise>
														${cu:formatStrinigDate(_gridList.DS_DATE) }
													</c:otherwise>
												</c:choose>
											</td>
											<td title="운영사 비고/협력사 비고" class="left">
												<b>${_gridList.ADMIN_REMARK }</b>
												<br />
												<span style="color: gray">${_gridList.AGENT_REMARK }</span>
											</td>
											<td title="운영사 첨부파일" align="center">
												<c:choose>
													<c:when test="${_gridList.ADMIN_IMAGE_KEY == '' }">
														<img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0"/>
													</c:when>
													<c:otherwise>
														<a href="javascript:doPop('attach', '${_gridList.ADMIN_IMAGE_KEY }', 'st_image_key_img');">
															<img name="st_image_key_img" id="st_image_key_img" src="/resources/images/disk_on.gif" border="0"/>
														</a>
													</c:otherwise>
												</c:choose>
												<input type="hidden" name="st_image_key" id="st_image_key" value="${_gridList.ADMIN_IMAGE_KEY }"/>
											</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
					<!-- 페이징 -->
					<p id="paging" class="paging">
						<%=CommonUtil.getPageView("kepSearch", Integer.parseInt(pageContext.getAttribute("total_cnt").toString()), (pageContext.getAttribute("curPage") == null) ? "0" : (String) pageContext.getAttribute("curPage"), (String) pageContext.getAttribute("onepagerow"))%>
						<span class="cl">[ 총 <c:out value="${total_cnt }" /> 건 ]</span>
					</p>
				</form>

				<form name="processForm" id="processForm" method="post">
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="total_cnt" id="total_cnt" value='<c:out value="${total_cnt }" />' /> 
					<input type="hidden" name="curPage" id="curPage" value='<c:out value="${curPage }"/>' />
					<input type="hidden" name="onepagerow" id="onepagerow" value='<c:out value="${onepagerow }"/>' />
					<div id="process"></div>
				</form>
			</div>

			<!--내용 종료-->
		</div>
		<c:import charEncoding="utf-8" url="/WEB-INF/views/common/include/sellerFooter.jsp" />
	</div>
</body>

</html>
