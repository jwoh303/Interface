<%--
**********************************************
* 메뉴 : 고객사 > 견적관리
* 화면 : 신규상품견적의뢰
* 기능 : 고객사가 운영사에게 신규상품 견적의뢰를 한다
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf"%>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
<script>
window.calendarPositionOffset = {
		top:-150,
		left:50
	};
</script>
</head>
<%
	@SuppressWarnings(value = "unchecked")

	String menuId = CommonUtil.nvl((String) request.getParameter("menuId"), ""); // 메뉴아이디	
	String tabIndex = CommonUtil.nvl((String) request.getParameter("tabIndex"),"1"); // tab Index

	if (myMenuListHeader != null) { //null이 아닌 경우에만 체크
		for (int i = 0; i < myMenuListHeader.size(); i++) {
			if (myMenuListHeader.get(i).get("MENU_ID").equals(menuId)) {
				myMenuFlag = true;
				break;
			}
		}
	}

	List<Map<String, String>> _gridList = (List<Map<String, String>>) request.getAttribute("data"); // 조회된결과
	List<Map<String, String>> _gridList2 = (List<Map<String, String>>) request.getAttribute("data2"); // 조회된결과(기등록건)
	String total_cnt = CommonUtil.nvlObj((List<Map<String, String>>) _gridList, "0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"), "1"); // 현재페이지  (필수)
	String curIdx = CommonUtil.nvl((String) request.getParameter("curIdx"), "1"); //  현재 탭  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), CommonUtil.nvl(_sessionInfo.getRowCnt(),"30")); // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String pageString = "30,50,100,200,500,1000";
	if(!Arrays.asList(pageString.split(",")).contains(onepagerow)){
		onepagerow = "30";
	}
	String itemFlag = CommonUtil.nvl((String) request.getParameter("itemFlag"), "N");
	Map<String,String> itemData = null;
	if(itemFlag.equals("Y")){
		itemData = _gridList2.get(0);
	}
	// 조회조건 E
	String gubun_msg = CommonUtil.nvl((String) request.getAttribute("gubun_msg"), ""); // 등록후 결과
	String item_cnt_no_msg = CommonUtil.nvl((String) request.getAttribute("item_cnt_no_msg"), ""); // 등록후 결과
	String msg = CommonUtil.nvl((String) request.getAttribute("msg"), ""); // 결과
	String buyer = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String user_id = _sessionInfo.getUserId();
	String user_name = _sessionInfo.getUserNameLoc();
	String user_dept = _sessionInfo.getDepartment();
	

	String pg_row = CommonUtil.nvl((String) request.getParameter("st_pg_row"), "10");
	String pg_no = CommonUtil.nvl((String) request.getParameter("st_page"), "1");
	String item_gubun_flag = "";
	item_gubun_flag = "<select name='st_item_gubun_flag'><option value=ALL selected >-선택-</option><option value='O'>표준품</option><option value='T'>제작품</option></select>";
	String tot_cnt_string = "";
	int tot_cnt = 0; //전체데이타row수
	int rec_cnt = 0;
	int page_display_cnt = 0;
	String read_only = "";
	String user_group = CommonUtil.nvl((String) _sessionInfo.getUserGroup(), ""); //사용자견적권한

	// 빙그레 특수로직
	String p060000068 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000068", "COL01_DATA");
	//카테고리 필수 특수로직.
	boolean p04404201 = CommonUtil.getSpecialCheckReturn(buyer, "P04-4042-01");
	//요청단가 필수 특수로직.
	boolean p04405301 = CommonUtil.getSpecialCheckReturn(buyer, "P04-4053-01");
	//제조사 필수 특수로직.
	boolean p04405401 = CommonUtil.getSpecialCheckReturn(buyer, "P04-4054-01");
	//고객사 단위 사용 특수로직.
	boolean p04405501 = CommonUtil.getSpecialCheckReturn(buyer, "P04-4055-01");
	//품목 NO_CODE만 가능 특수로직.
	boolean p060000132 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000132");
	// 카테고리 선택 팝업 통제 
	boolean bqt00003 = CommonUtil.getSpecialCheckReturn(buyer, "BQT00003");
	
	//고객사 단위 사용 특수로직(코드로 표시) 
	boolean bqt00004 = CommonUtil.getSpecialCheckReturn(buyer, "BQT00004");
	
	//자동채번 고객사
	boolean getCodeCDNO = CommonUtil.getCode3CheckReturn("CDNO", buyer, "KRKORE0001");
%>

<body onload="kep_onload_view()">
	<div id="wrapper">
		<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
		<c:import charEncoding="utf-8" url="/menu/menu.do">
			<c:param name="page" value="buyerHeader_v2" />
			<c:param name="part" value="buyerHeader_v2" />
		</c:import>
		<!--내용 시작-->
		<!--조회영역-->
		<form name="searchForm" id="searchForm" method="post">
			<!--HIDDEN-->
			<input type="hidden" name="st_check" id="st_check" value="">
			<input type="hidden" name="tabIndex" id="tabIndex" value="<%=tabIndex%>">
			<input type="hidden" name="st_buyer" id="st_buyer" value="${_sessionInfo.comCode}"> <input type="hidden"
				name="st_pass_flag" id="st_pass_flag" value="">
			<!-- 비교견적서 변수-->
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>"> <input
				type="hidden" name="curPage" id="curPage" value="<%=curPage%>" />
			<input type="hidden" name="curIdx" id="curIdx" value="<%=curIdx%>" />
			<input type="hidden" id="st_btoa_user_mail" name="st_btoa_user_mail" style="width: 80%" value="${_sessionInfo.email}"> <input
				type="hidden" id="st_btoa_user_tel" name="st_btoa_user_tel" style="width: 80%" value="${_sessionInfo.tel}"> <input
				type="hidden" id="st_btoa_user_fax" name="st_btoa_user_fax" style="width: 80%;" value="${_sessionInfo.fax}">
		</form>

		<div class="SubPageTit">
			견적등록
			<%
			if (myMenuFlag) {
		%>
			<button class="But_Star_on"></button>
			<%
				} else {
			%>
			<button class="But_Star_off"></button>
			<%
				}
			%>
			<div class="SubPageGuide">
				<ul>
					<li><img src="../../../../resources/imgs/Icon_Home.png" /></li>
					<li>상품견적등록</li>
					<li>견적등록</li>
				</ul>
			</div>
		</div>
		<div class="container">
			<div class="SubSearchTab">
				<button class="TabTit" data-tab="Search1" id="btn1">신규등록</button>
				<button class="TabTit" data-tab="Search2" id="btn2">임시저장</button>
			</div>
			<div id="Search1" class="SearchContent">
				<div class="ImportanceRow">
					<img src="/resources/imgs/Icon_Importance.png" /> 
						<span class="tit"> <%=CommonLang.get("HTITLE1189")%><!-- 상품견적 등록 방법 --> </span>
						<br /> &nbsp; &nbsp;&nbsp; ·&nbsp;&nbsp; &nbsp;<%=CommonLang.get("HTITLE1190")%><!-- 견적 요청 전 [기존품목 확인]에서 등록하려는 상품이 이미 존재하는지 먼저 확인해 주세요. -->
						<br />  &nbsp; &nbsp;&nbsp; ·&nbsp;&nbsp; &nbsp;<%=CommonLang.get("HTITLE1191")%><!-- 상품 정보를 모두 입력한 뒤 [견적요청] 버튼을 눌러 최종적으로 요청해 주세요. --> 
						<br /> &nbsp; &nbsp;&nbsp; ·&nbsp;&nbsp; &nbsp;<%=CommonLang.get("HTITLE1192")%><!-- 등록할 상품이 많다면 [엑셀업로드] 팝업에서 양식을 다운로드해 정보를 작성한 후, 한 번에 견적을 요청할 수 있습니다. --> 
				</div>
				<div class="ArraySub mt30 mb10">
					<div class="buttonLeft">
						<button class="ButOutline_Medium"  onclick="javascript:doAction('add'); return false;"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --> </button>
			            <button class="ButOutline_Medium"  onclick="javascript:doAction('del'); return false;"><%=CommonLang.get("HTITLE37")%><!-- 행삭제 --> </button>
			            <button class="ButOutline_Medium" onclick="javascript:doAction('copy'); return false;"><%=CommonLang.get("HTITLE1212")%><!--행복사--> </button>
			            <button class="But_ExcelDown40" onclick="javascript:doPop('excelUpload'); return false;"><%=CommonLang.get("HTITLE34")%><!-- 엑셀업로드 --> </button>
					</div>
					<div class="buttonRight">
			            <button class="ButOutline_Medium"  onclick="javascript:doPop('buyerMpRqCatalogRegYnPop'); return false;"><%=CommonLang.get("HTITLE1199")%> </button>
			            <%if(!user_group.equals("Z")) {%>
			            <button class="ButOutline_Medium" onclick="javascript:doAction('save'); return false;"><%=CommonLang.get("HTITLE38")%> </button>
			            <button class="ButPrimary_Medium" onclick="javascript:doAction('reg'); return false;"><%=CommonLang.get("HTITLE1010")%> </button>
			            <%} %>
			        </div>
				</div>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage"
						value="<%=curPage%>" /> <input type="hidden" name="file_get_y"
						id="file_get_y" value="">
					<table class="PDEstimate" width="1280px" id="tblshow1">
						<tr>
							<th width="50px"><label class="CheckLargeLabel">
											<input type="checkbox" onclick="checkAll('1',this)">
									<span class="CheckLargeCustom"></span></label>
							</th>
						   <th width="420px"><%=CommonLang.get("HTITLE1074")%><!-- 기본정보 --> <div class="exShow"> <img src="/resources/imgs/Icon_question.png" ><div class="layerShow"><%=CommonLang.get("HTITLE1475")%> <!-- · 품목코드 : 고객사 전용 상품코드(미입력 시 자동채번) --><br/><%=CommonLang.get("HTITLE1476")%> <!-- · 품목명 : 요청 상품의 명칭 --><br/><%=CommonLang.get("HTITLE1477")%> <!-- · 모델번호 : 제조사에서 부여한 모델번호 --><br/><%=CommonLang.get("HTITLE1478")%> <!-- · 규격 : 상품의 규격/사양 정보 --><br/><%=CommonLang.get("HTITLE1479")%> <!-- · 제조사 : 상품을 생산한 제조사명 --><br/><%=CommonLang.get("HTITLE1480")%> <!-- · 원산지 : 상품의 원산지(생산국가) --><br/><%=CommonLang.get("HTITLE1481")%> <!-- · 비고 : 견적 관련하여 코리아이플랫폼에 전달할 내용을 기재해주세요. --></div></div></th>
			               <th width="350px"><%=CommonLang.get("HTITLE1194")%><!-- 수량 및 금액 --> <div class="exShow"> <img src="/resources/imgs/Icon_question.png" ><div class="layerShow"><%=CommonLang.get("HTITLE1482")%> <!-- · 단위 : 상품 거래 단위 선택 (EA, BOX 등) --><br/><%=CommonLang.get("HTITLE1483")%> <!-- · 수량 : 구매 예정 수량 (최소 주문수량 설정 기준으로 활용) --><br/><%=CommonLang.get("HTITLE1484")%> <!-- · 단가구분 : 산정 기준 선택 (실적가/시장가/목표가) --><br/><%=CommonLang.get("HTITLE1485")%> <!-- · 요청단가 : --><br/> <%=CommonLang.get("HTITLE1486")%> <!-- - 실적가: 거래 실적 또는 견적 이력 있는 상품의 단가 --><br/> <%=CommonLang.get("HTITLE1487")%> <!-- - 시장가: 인터넷 검색 등을 통해 확인 가능한 시장 단가 --><br/> <%=CommonLang.get("HTITLE1488")%> <!-- - 목표가: 실적가 및 시장가가 없는 경우, 요청자가 희망하는 목표 단가 --><br/><%=CommonLang.get("HTITLE1489")%> <!-- · 카테고리 : 카테고리 선택 시, 해당 카테고리로 상품 등록 --><br/><%=CommonLang.get("HTITLE1490")%> <!-- · 첨부파일 : 상품 관련 참고자료(카탈로그,사양서 등) 첨부 --><br/><%=CommonLang.get("HTITLE1514")%> <!-- 체크박스로 행 선택 후 파일 첨부 시, 선택한 모든 행에 동일 파일 일괄 적용 --></div></div></th>
			               <th width="360px"><%=CommonLang.get("HTITLE1453")%><!-- 협력사 및 추가정보 --> <div class="exShow"> <img src="/resources/imgs/Icon_question.png" ><div class="layerShow"><%=CommonLang.get("HTITLE1491")%> <!-- · 지정협력사 : 견적을 요청할 협력사를 직접 지정 --><br/><%=CommonLang.get("HTITLE1492")%> <!-- · 기존협력사 : 해당 상품의 기존 거래 이력이 있는 협력사 정보 입력 --><br/><%=CommonLang.get("HTITLE1493")%> <!-- · 선입고여부 : 정식 발주 전 선입고 여부(Y/N) --><br/><%=CommonLang.get("HTITLE1494")%> <!-- · 제작품 : 규격에 맞춰 별도 주문 제작되는 상품 여부(Y/N) --><br/><%=CommonLang.get("HTITLE1495")%> <!-- · 안전인증품 : 안전인증이 완료된 제품으로 견적 제출 --><br/><%=CommonLang.get("HTITLE1496")%> <!-- · 회신요청일 : 회신 희망일자 --></div></div></th>
			               <th width="100px"><%=CommonLang.get("HTITLE1197")%><!-- 복사 · 삭제 --> </th>
						</tr>
						<tr id="row">
							<td align="center" rowspan="2"><label class="CheckLargeLabel"><input type="checkbox" id="InCheck__0" name="InCheck"><span class="CheckLargeCustom"></span></label> 
								<input type='hidden' name='excel_up' id='excel_up' value='N'>
								<input type="hidden" name="catalogSet" id="catalogSet__0"
						value="N" /></td>
							<td align="center" style="vertical-align:top;border-bottom:none">
								<table class="PDEstimateNoLine" width="360px">
									<tr>
										<th width="80px"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
										<td width="250px"><input class="input40"
											style="width: 260px" id="st_buyer_item_no__0"
											name="st_buyer_item_no" type="text" <%if(itemFlag.equals("Y")) {%> value="<%=CommonUtil.nvl(itemData.get("BUYER_ITEM_NO"))%>" readonly <%} %> /></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --> <span>*</span></th>
										<td><input class="input40" style="width: 260px" onclick="javascript:catalogSetCheck(this);"
											id="st_description__0" name="st_description" type="text" <%if(itemFlag.equals("Y")) {%> value="<%=CommonUtil.nvl(itemData.get("DESCRIPTION_LOC"))%>" readonly <%} %>/></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE1454")%><!-- 모델번호 --> </th>
										<td><input class="input40" style="width: 260px" onclick="javascript:catalogSetCheck(this);"
											id="st_maker_part_no__0" name="st_maker_part_no" type="text" <%if(itemFlag.equals("Y")) {%> value="<%=CommonUtil.nvl(itemData.get("MAKER_PART_NO"))%>" readonly <%} %>/></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE14")%><!-- 규격 --> <span>*</span></th>
										<td><input class="input40" style="width: 260px" onclick="javascript:catalogSetCheck(this);"
											id="st_specification__0" name="st_specification" type="text" <%if(itemFlag.equals("Y")) {%> value="<%=CommonUtil.nvl(itemData.get("SPECIFICATION"))%>" readonly <%} %> /></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE15")%><!-- 제조사 --><% if (p04405401) { %> <span>*</span> <% } %></th>
										<td><input class="input40"
											style="width: 260px" id="st_maker_name__0" onclick="javascript:catalogSetCheck(this);"
											name="st_maker_name" type="text" <%if(itemFlag.equals("Y")) {%> value="<%=CommonUtil.nvl(itemData.get("MAKER_NAME"))%>" readonly <%} %>/></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></th>
										<td>
											<div class="SearchInput"
												style="width: 280px; display: flex; align-items: center; gap: 2px;">
												<input type="text" id="st_origin_name__0"
													name="st_origin_name" readonly
													style="flex: 1; width: 0; height: 30px;" <%if(itemFlag.equals("Y")) {%> value="<%=CommonUtil.nvl(itemData.get("ORIGIN_NAME"))%>" <%} %>> 
													<input type="hidden" id="st_origin_code__0" name="st_origin_code"
													<%if(itemFlag.equals("Y")) {%> value="<%=CommonUtil.nvl(itemData.get("ORIGIN_CODE"))%>" <%} %>>
												<button type="button" onclick="doPop('country',this);"
													style="width: 40px; height: 30px; white-space: nowrap;"><%=CommonLang.get("HTITLE120")%></button>
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td align="center" style="vertical-align:top;border-bottom:none">
								<table class="PDEstimateNoLine" width="330px">
									<tr>
										<th width="85px"><%=CommonLang.get("HTITLE52")%><!-- 단위 --> <span>*</span></th>
										<td width="235px"><select id="st_unit_measure__0"
											name="st_unit_measure" class="Select40" style="width: 242px;">
												<%
													if (p04405501) {//고객사 단위 사용
												%>
												<%=CommonUtil.getCodeBComboList(buyer, "NO", "UNIT", "ICOMCOD2", "", "TEXT1")%>
												<%
													} else if(bqt00004) {
												%>
												<%=CommonUtil.getCodeBComboListCode(buyer, "NO", "UNIT", "ICOMCOD2", "", "TEXT1")%>
												<%
													} else {
												%>
												<%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo", "")%>
												<%
													}
												%>
										</select></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE45")%><!-- 수량 --> <span>*</span></th>
										<td>
											<input type="text" min="1" class="input40_Num" onkeyup="validNumCheck(this);"
											style="width: 220px" id="st_item_qty__0" name="st_item_qty"
											value="" />
										</td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE46")%><!-- 단가구분 --> <span>*</span></th>
										<td><select class="Select40" style="width: 242px;"
											name='st_req_price_type' id="st_req_price_type__0">
												<%=CommonUtil.getCodeComboList("M150", "SEL", "", "", "", "")%>
										</select></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE50")%><!-- 요청단가 --><% if (p04405301 == true) { %> <span>*</span> <% } %></th>
										<td>
											<input type="text" min="1" class="input40_Price"
											onkeyup="validNumCheck(this);" style="width: 220px"
											id="st_buyer_target_price__0" name="st_buyer_target_price"
											value="">
										</td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --> <%
											if (p04404201) {
										%> <span>*</span>
											<%
												}
											%></th>
										<td>
											<div class="SearchInput"
												style="width: 240px; display: flex; display:inline-block;">
												<input type="text" id="st_category_name__0"
													name="st_category_name" value="" readonly
													style="width:85%;"> <input
													type="hidden" id="st_category_code__0"
													name="st_category_code" value="">
												<button type="button" onclick="doPop('category',this);"><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></button>
											</div>
										</td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></th>
										<td><button type="button" id="attachBtn__0"
												class="FileOutline" style="width: 242px"
												onclick="doPop('attach',this);"><%=CommonLang.get("HTITLE440")%><!-- 등록 --></button> <input
											type='hidden' name='st_image_key' id='st_image_key__0'
											value=""></td>
									</tr>
								</table>
							</td>
							<td align="center" style="vertical-align:top;border-bottom:none">
								<table class="PDEstimateNoLine" width="320px">
									
									<tr>
										<th width="105px"><%=CommonLang.get("HTITLE967")%><!-- 지정협력사 --></th>
										<td width="215px"><input class="input40" style="width: 190px"
											id="st_buyer_assign_agent_code__0"
											name="st_buyer_assign_agent_code" type="text" /></td>
									</tr>
									<tr>
										<th><%=CommonLang.get("HTITLE121")%><!-- 기존협력사 --></th>
										<td><input class="input40" style="width: 190px"
											id="st_agent_name__0" name="st_agent_name" type="text" /></td>
									</tr>
									<tr>
										<th height="28px"><%=CommonLang.get("HTITLE582")%><!-- 선입고여부 --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_pre_gr_flag__0" value="Y"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_pre_gr_flag__0" value="N" checked="checked"><span
												class="RadioLargeTxt"></span>N</label></td>
										<input id="st_pre_gr_flag_text__0" name="st_pre_gr_flag"
											type="hidden" value="N" />
									</tr>
									<tr>
										<th height="28px"><%=CommonLang.get("HTITLE968")%><!-- 제작품 --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_make_goods_flag__0" value="Y"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_make_goods_flag__0" value="N" checked="checked"><span
												class="RadioLargeTxt"></span>N</label> <input
											id="st_make_goods_flag_text__0" name="st_make_goods_flag"
											type="hidden" value="N" /></td>
									</tr>
									<tr style="display: none;">
										<th height="28px"><%=CommonLang.get("HTITLE914")%><!-- MSDS --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_msds_flag__0" value="Y"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_msds_flag__0" value="N" checked="checked"><span
												class="RadioLargeTxt"></span>N</label> <input
											id="st_msds_flag_text__0" name="st_msds_flag" type="hidden"
											value="N" /></td>
									</tr>
									<tr style="display: none;">
										<th height="28px"><%=CommonLang.get("HTITLE1200")%><!-- 안전인증품 --></th>
										<td><label class="RadioLargeLabel"
											style="margin-right: 15px"><input type="radio"
												name="st_safety_flag__0" value="Y"><span
												class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
											class="RadioLargeLabel"><input type="radio"
												name="st_safety_flag__0" value="N" checked="checked"><span
												class="RadioLargeTxt"></span>N</label></td>
									</tr>
									<input id="st_safety_flag_text__0" name="st_safety_flag"
										type="hidden" value="N" />
									<tr>
										<th><%=CommonLang.get("HTITLE51")%><!-- 회신요청일 --> <span>*</span></th>
										<td><div class="Buyer-datepicker-wrap"
												style="width: 206px;">
												<div class="Buyer-date-input" data-datepicker
													style="width: 200px;">
													<input type="text" id="st_btoa_end_date__0"
														name="st_btoa_end_date" readonly style="width: 180px;"
														value=""><span></span>
												</div>
											</div></td>
									</tr>
								</table>
							</td>
							<td align="center" rowspan="2">
								<button class="Copy_Outline40"
									onclick="javascript:copyRow(this); return false;"></button> <br />
								<button class="WasteBasket_Outline40 mt10"
									onclick="javascript:delRow(this); return false;"></button>
							</td>
						</tr>
						<tr>
							<td colspan="3" align="center"  style="border-top:none; padding:1px 0px 5px 0px;">
							<table class="PDEstimateNoLine"  width="1080px"  >
								<tr>
									<th width="78px"><%=CommonLang.get("HTITLE122")%><!-- 비고 --> </th>
									<td><input class="input40" style="width: 980px"
										id="st_btoa_remark__0" name="st_btoa_remark" type="text"
										value="<%=p060000068%>" /></td>
								</tr>
							</table>
							</td>
						</tr>
					</table>
				</form>
				<div class="h50"></div>
				<form name="processForm" id="processForm" method="post">
					<input type="hidden" name="tabIndex" id="tabIndex" value="1" />
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="buyer" id="buyer" value="" /> <input
						type="hidden" name="gubun" id="gubun" value="" /> <input
						type="hidden" name="total_cnt" id="total_cnt"
						value="<%=total_cnt%>" /> <input type="hidden" name="curPage"
						id="curPage" value="<%=curPage%>" /> <input type="hidden"
						name="onepagerow" id="onepagerow" value="<%=onepagerow%>" />
					<div id="process"></div>
				</form>
			</div>
			<!--Tab1끝 -->

			<div id="Search2" class="SearchContent">
				<div class="ImportanceRow">
				    <img src="/resources/imgs/Icon_Importance.png" /> <span
				        class="tit"> <%=CommonLang.get("HTITLE1189")%> </span><br /> &nbsp; &nbsp;&nbsp;
				    ·&nbsp;&nbsp; &nbsp;<%=CommonLang.get("HTITLE1193")%> <!-- 임시저장한 견적 품목 정보를 확인하고, 이어서 견적을 요청할 수 있는 메뉴입니다. --><br />
				</div>
				<div class="ArraySub mt30 mb10">
				    <div class="buttonLeft">
				        <button class="ButOutline_Medium"
				            onclick="javascript:doAction('del2'); return false;"><%=CommonLang.get("HTITLE37")%><!-- 행삭제 --> </button>
				    </div>
				    <%if(!user_group.equals("Z")) {%>
				    <div class="buttonRight">
				        <button class="ButOutline_Medium"
				            onclick="javascript:doAction('save2'); return false;"><%=CommonLang.get("HTITLE38")%><!-- 임시저장 --> </button>
				        <button class="ButPrimary_Medium"
				            onclick="javascript:doAction('reg2'); return false;"><%=CommonLang.get("HTITLE1010")%><!-- 견적요청 --> </button>
				    </div>
				    <%} %>
				</div>
				<form name="contentForm2" id="contentForm2" method="post">
				    <input type="hidden" name="curPage" id="curPage"
				        value="<%=curPage%>" /> <input type="hidden" name="file_get_y"
				        id="file_get_y" value="">
				    <%
				        if (_gridList != null && _gridList.size() > 0) {
				    %>
				    <input type="hidden" name="display_item_cnt" id="display_item_cnt"
				        value="<%=_gridList.size()%>">
				    <%
				        }
				    %>
				    <table class="PDEstimate" width="1280px" id="tblshow2">
				        <tr>
				            <th width="50px"><label class="CheckLargeLabel"><input
				                    type="checkbox" onclick="checkAll('2',this)"><span
				                    class="CheckLargeCustom"></span></label></th>
				            <th width="420px"><%=CommonLang.get("HTITLE1074")%><!-- 기본정보 --> </th>
			               <th width="350px"><%=CommonLang.get("HTITLE1194")%><!-- 수량 및 금액 --> </th>
			               <th width="360px"><%=CommonLang.get("HTITLE1453")%><!-- 협력사 및 추가정보 --> </th>
			               <th width="100px"><%=CommonLang.get("HTITLE1197")%><!-- 복사 · 삭제 --> </th>
				        </tr>
				        <%
				            if (_gridList == null || _gridList.size() == 0) {
				        %>
				        <tr>
				            <td colspan="15" align="center" height="50"><span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
				                </td>
				        </tr>
				        <%
				            } else {
				                Map<String, String> rowData = null;
				                for (int j = 0; j < _gridList.size(); j++) {
				                    rowData = _gridList.get(j);
				        %>
				        <tr id="row">
				            <td align="center" rowspan="2"><label class="CheckLargeLabel"><input
				                    type="checkbox" id="InCheck<%=j%>" name="InCheck"><span
				                    class="CheckLargeCustom"></span></label> <input type='hidden'
				                name='excel_up' id='excel_up' value='N'> 
				                <input type="hidden" name="st_byit_comorg_code"
				                value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
				                 <input
				                type="hidden" name="st_buyer" value="<%=buyer%>"> <input
				                type="hidden" name="st_quotation_no" id="st_quotation_no<%=j %>"
				                value="<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%>">
				                <input type="hidden" name="st_quotation_seq" id="st_quotation_seq<%=j %>"
				                value="<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"))%>">
				                <input type="hidden" name="st_revision" id="st_revision<%=j %>"
				                value="<%=CommonUtil.nvl(rowData.get("REVISION"))%>"> <input
				                type="hidden" name="st_req_type"
				                value="<%=CommonUtil.nvl(rowData.get("REQ_TYPE"))%>"> <input
				                type="hidden" name="st_cms_categ_id"
				                value="<%=CommonUtil.nvl(rowData.get("CMS_CATEG_ID"))%>">
				                <input type="hidden" name="st_cms_catlg_id"
				                value="<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>">
				                <input type="hidden" name="st_imgfile_dir"
				                value="<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>">
				                <input type="hidden" name="st_imgfile_name"
				                value="<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>">
				                <inptu type="hidden" id="rowi" name="rowi" value="<%=j%>"></td>
				            <td align="center" style="vertical-align:top;border-bottom:none">
				                <table class="PDEstimateNoLine" width="360px">
				                    <tr>
				                        <th width="80px"><%=CommonLang.get("HTITLE12")%> <!-- 품목코드 --></th>
				                        <td width="250px"><input class="input40"
				                            style="width: 260px; background: #EAEAEA;"
				                            id="st_buyer_item_no<%=j%>" name="st_buyer_item_no"
				                            type="text" readonly
				                            value="<%=rowData.get("BUYER_ITEM_NO")%>" /></td>
				                    </tr>
				                    <%
				                        //미계약상품, 기등록 상품일 경우 품명.규격 수정 불가
				                                if (CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("G")
				                                        || CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("N")) {
				                    %>
				                    <tr>
				                        <th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --> <span>*</span></th>
				                        <td><input class="input40"
				                            style="width: 260px; background: #EAEAEA;"
				                            id="st_description<%=j%>" name="st_description" type="text"
				                            readonly value="<%=rowData.get("DESCRIPTION")%>" /></td>
				                    </tr>
				                    <tr>
				                        <th><%=CommonLang.get("HTITLE1454")%><!-- 모델번호 --> </th>
				                        <td><input class="input40"
				                            style="width: 260px; background: #EAEAEA;"
				                            id="st_maker_part_no<%=j%>" name="st_maker_part_no"
				                            type="text" readonly
				                            value="<%=rowData.get("MAKER_PART_NO")%>" /></td>
				                    </tr>
				                    <tr>
				                        <th><%=CommonLang.get("HTITLE14")%><!-- 규격 --> <span>*</span></th>
				                        <td><input class="input40"
				                            style="width: 260px; background: #EAEAEA;"
				                            id="st_specification<%=j%>" name="st_specification"
				                            type="text" readonly
				                            value="<%=rowData.get("SPECIFICATION")%>" /></td>
				                    </tr>
				                    <%
				                        } else {
				                    %>
				                    <tr>
				                        <th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --> <span>*</span></th>
				                        <td><input class="input40" style="width: 260px"
				                            id="st_description<%=j%>" name="st_description" type="text"
				                            value="<%=rowData.get("DESCRIPTION")%>" /></td>
				                    </tr>
				                    <tr>
				                        <th><%=CommonLang.get("HTITLE1454")%><!-- 모델번호 --> </th>
				                        <td><input class="input40"
				                            style="width: 260px;"
				                            id="st_maker_part_no<%=j%>" name="st_maker_part_no"
				                            type="text" 
				                            value="<%=rowData.get("MAKER_PART_NO")%>" /></td>
				                    </tr>
				                    <tr>
				                        <th><%=CommonLang.get("HTITLE14")%><!-- 규격 --> <span>*</span></th>
				                        <td><input class="input40" style="width: 260px"
				                            id="st_specification<%=j%>" name="st_specification"
				                            type="text" value="<%=rowData.get("SPECIFICATION")%>" /></td>
				                    </tr>
				                    <%
				                        }
				                    %>
				                    <tr>
							            <th><%=CommonLang.get("HTITLE15")%><!-- 제조사 --> <%if (p04405401 == true) {%> <span>*</span><%}%></th>
							            <td><input class="input40"
							                style="width: 260px" id="st_maker_name<%=j%>"
							                name="st_maker_name" type="text"
							                value="<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>" /></td>
							        </tr>
							        <tr>
							            <th><%=CommonLang.get("HTITLE120")%><!-- 원산지 --> </th>
							            <td>
							                <div class="SearchInput"
							                    style="width: 280px; display: flex; align-items: center; gap: 2px;">
							                    <input type="text" id="st_origin_name<%=j%>"
							                        name="st_origin_name"
							                        value="<%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%>"
							                        readonly style="flex: 1; width: 0; height: 30px;">
							                    <input type="hidden" id="st_origin_code<%=j%>"
							                        name="st_origin_code"
							                        value="<%=CommonUtil.nvl(rowData.get("ORIGIN_CODE"))%>">
							                    <button type="button"
							                        onclick="doPop('country',this,'<%=j%>');"
							                        style="width: 40px; height: 30px; white-space: nowrap;"><%=CommonLang.get("HTITLE120")%> </button>
							                </div>
							            </td>
							        </tr>
				                </table>
				            </td>
							<td align="center" style="vertical-align:top;border-bottom:none">
							    <table class="PDEstimateNoLine" width="330px">
							    	<tr>
							            <th><%=CommonLang.get("HTITLE52")%><!-- 단위 --> <span>*</span></th>
							            <td width="235px"><select id="st_unit_measure<%=j%>"
							                name="st_unit_measure" class="Select40" style="width: 242px;">
							                    <%
							                        if (p04405501) {//고객사 단위 사용
							                    %>
							                    <%=CommonUtil.getCodeBComboList(buyer, "NO", "UNIT", "ICOMCOD2",
							    CommonUtil.nvl(rowData.get("UNIT_MEASURE")), "TEXT1")%>
							                    <%
													} else if(bqt00004) {
												%>
												<%=CommonUtil.getCodeBComboListCode(buyer, "NO", "UNIT", "ICOMCOD2",
							    CommonUtil.nvl(rowData.get("UNIT_MEASURE")), "TEXT1")%>
							                    <%
							                        } else {
							                    %>
							                    <%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo", "",
							    CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%>
							                    <%
							                        }
							                    %>
							            </select></td>
							        </tr>
							        <tr>
							            <th><%=CommonLang.get("HTITLE45")%><!-- 수량 --> <span>*</span></th>
							            <td><input type="text" min="1" class="input40_Num"
							                style="width: 220px" id="st_item_qty<%=j%>"
							                name="st_item_qty" onkeyup="validNumCheck(this);"
							                value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>" /></td>
							        </tr>
							        <tr>
							            <th><%=CommonLang.get("HTITLE46")%><!-- 단가구분 --> <span>*</span></th>
							            <td width="165px"><select class="Select40" style="width: 242px;"
							                name='st_req_price_type' id="st_req_price_type<%=j%>">
							                    <%=CommonUtil.getCodeComboList("M150", "SEL",
							CommonUtil.nvl(rowData.get("REQ_PRICE_TYPE"), ""), "", "", "")%>
							            </select></td>
							        </tr>
							        <tr>
							            <th><%=CommonLang.get("HTITLE50")%><!-- 요청단가 --> <%
							                if (p04405301 == true) {
							            %> <span>*</span>
							                <%
							                    }
							                %></th>
							            <td><input type="text" min="1"
							                class="input40_Price" onkeyup="validNumCheck(this);" style="width: 220px"
							                id="st_buyer_target_price<%=j%>" name="st_buyer_target_price"
							                value="<%=CommonUtil.nvl(rowData.get("BUYER_TARGET_PRICE"))%>" />
							            </td>
							        </tr>
							        <tr>
							            <th><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --> <%
							                if (p04404201) {
							            %> <span>*</span>
							                <%
							                    }
							                %></th>
							            <td>
							                <div class="SearchInput"
							                    style="width: 240px; display:inline-block;">
							                    <input type="text" id="st_category_name<%=j%>"
							                        name="st_category_name"
							                        value="<%=rowData.get("CATEGORY_NAME")%>" readonly
							                        style="width:85%;"> <input
							                        type="hidden" id="st_category_code<%=j%>"
							                        name="st_category_code"
							                        value="<%=rowData.get("CATEGORY_CODE")%>">
							                    <button type="button"
							                        onclick="doPop('category',this,'<%=j%>');"
							                        ><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --> </button>
							                </div>
							            </td>
							        </tr>
							        <tr>
							            <th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --> </th>
							            <td><button type="button" class="<%=CommonUtil.nvl(rowData.get("IMAGE_CNT")).equals("0") ? "FileOutline" : "FileOutline_on"%>"
							                    id="attachBtn<%=j%>"
							                    onclick="doPop('attach',this,'<%=j%>');"
							                    style="width: 242px"><%if(CommonUtil.nvl(rowData.get("IMAGE_CNT")).equals("0")){%> <%=CommonLang.get("HTITLE440")%><!-- 등록 --> <%}else{ %> <%=CommonLang.get("HTITLE166") %><!-- 첨부 -->(<%=CommonUtil.nvl(rowData.get("IMAGE_CNT")) %>)<%} %></button> <input type='hidden'
							                name='st_image_key' id='st_image_key<%=j%>' value='<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>'>
							            </td>
							        </tr>
							    </table>
							</td>
							<td align="center" style="vertical-align:top;border-bottom:none">
							    <table class="PDEstimateNoLine" width="320px">
							        <tr>
							            <th width="105px"><%=CommonLang.get("HTITLE967")%><!-- 지정협력사 --> </th>
							            <td width="215px"><input class="input40" style="width: 190px"
							                id="st_buyer_assign_agent_code<%=j%>"
							                name="st_buyer_assign_agent_code" type="text"
							                value="<%=CommonUtil.nvl(rowData.get("BUYER_ASSIGN_AGENT_CODE"))%>" /></td>
							        </tr>
							        <tr>
							            <th><%=CommonLang.get("HTITLE121")%><!-- 기존협력사 --> </th>
							            <td><input class="input40" style="width: 190px"
							                id="st_agent_name<%=j%>" name="st_agent_name" type="text"
							                value="<%=CommonUtil.nvl(rowData.get("BTOA_AGENT_NAME"))%>" /></td>
							        </tr>
							        <tr>
							            <th height="28px"><%=CommonLang.get("HTITLE842")%><!-- 선입고여부 --> </th>
							            <td width="115px"><label class="RadioLargeLabel"
							                style="margin-right: 15px"><input type="radio"
							                    name="st_pre_gr_flag<%=j%>" value="Y"
							                    <%if (CommonUtil.nvl(rowData.get("PRE_GR_FLAG"), "N").equals("Y")) {%>
							                    checked="checked" <%}%>><span class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
							                <label class="RadioLargeLabel"><input type="radio"
							                    name="st_pre_gr_flag<%=j%>" value="N"
							                    <%if (CommonUtil.nvl(rowData.get("PRE_GR_FLAG"), "N").equals("N")) {%>
							                    checked="checked" <%}%>><span class="RadioLargeTxt"></span>N</label>
							            </td>
							            <input id="st_pre_gr_flag<%=j%>_text" name="st_pre_gr_flag"
							                type="hidden"
							                value="<%=CommonUtil.nvl(rowData.get("PRE_GR_FLAG"))%>" />
							        </tr>
							        <tr>
							            <th height="28px"><%=CommonLang.get("HTITLE968")%><!-- 제작품 --> </th>
							            <td><label class="RadioLargeLabel"
							                style="margin-right: 15px"><input type="radio"
							                    name="st_make_goods_flag<%=j%>" value="Y"><span
							                    class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <label
							                class="RadioLargeLabel"><input type="radio"
							                    name="st_make_goods_flag<%=j%>" value="N" checked="checked"><span
							                    class="RadioLargeTxt"></span>N</label> <input
							                id="st_make_goods_flag<%=j%>_text" name="st_make_goods_flag"
							                type="hidden" /></td>
							        </tr>
							        <tr style="display: none;">
							            <th height="28px"><%=CommonLang.get("HTITLE914")%><!-- MSDS --> </th>
							            <td><label class="RadioLargeLabel"
							                style="margin-right: 15px"><input type="radio"
							                    name="st_msds_flag<%=j%>" value="Y"
							                    <%if (CommonUtil.nvl(rowData.get("BUYER_MSDS_YN"), "N").equals("Y")) {%>
							                    checked="checked" <%}%>><span class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
							                <label class="RadioLargeLabel"><input type="radio"
							                    name="st_msds_flag<%=j%>" value="N"
							                    <%if (CommonUtil.nvl(rowData.get("BUYER_MSDS_YN"), "N").equals("N")) {%>
							                    checked="checked" <%}%>><span class="RadioLargeTxt"></span>N</label>
							                <input id="st_msds_flag<%=j%>_text" name="st_msds_flag"
							                type="hidden"
							                value="N" />
							            </td>
							        </tr>
							        <tr style="display: none;">
							            <th height="28px"><%=CommonLang.get("HTITLE1200")%><!-- 안전인증품 --> </th>
							            <td><label class="RadioLargeLabel"
							                style="margin-right: 15px"><input type="radio"
							                    name="st_safety_flag<%=j%>" value="Y"
							                    <%if (CommonUtil.nvl(rowData.get("SAFETY_FLAG"), "N").equals("Y")) {%>
							                    checked="checked" <%}%>><span class="RadioLargeTxt"></span>Y</label>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
							                <label class="RadioLargeLabel"><input type="radio"
							                    name="st_safety_flag<%=j%>" value="N"
							                    <%if (CommonUtil.nvl(rowData.get("SAFETY_FLAG"), "N").equals("N")) {%>
							                    checked="checked" <%}%>><span class="RadioLargeTxt"></span>N</label>
							                <input id="st_safety_flag<%=j %>_text" name="st_safety_flag"
							                type="hidden" value="<%=CommonUtil.nvl(rowData.get("SAFETY_FLAG"))%>" /></td>
							        </tr>
				                        <th><%=CommonLang.get("HTITLE51")%><!-- 회신요청일 --> <span>*</span></th>
				                        <td><div class="Buyer-datepicker-wrap"
				                                style="width: 206px;">
				                                <div class="Buyer-date-input" data-datepicker
				                                    style="width: 200px;">
				                                    <input type="text" id="st_btoa_end_date<%=j%>"
				                                        name="st_btoa_end_date" readonly style="width: 180px;"
				                                        value=""><span></span>
				                                </div>
				                            </div></td>
				                    </tr>
							    </table>
							</td>
							<td align="center" rowspan="2">
							    <button class="WasteBasket_Outline40 mt10" id="<%=j %>"
							        onclick="javascript:delRowCheck2(this); return false;"></button>
							</td>
						</tr>
						<tr>
            				<td colspan="3" align="center"  style="border-top:none; padding:1px 0px 5px 0px;">
              					<table class="PDEstimateNoLine"  width="1080px"  >
              						<tr>
				                        <th width="78px"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></th>
				                        <td width="1002px"><input class="input40" style="width: 980px"
				                            id="st_btoa_remark<%=j%>" name="st_btoa_remark" type="text"
				                            value="<%=CommonUtil.nvl(p060000068, rowData.get("BTOA_REMARK"))%>" /></td>
				                    </tr>
              					</table>
              				</td>
              			</tr>
						
						<%
							}
							}
						%>
					</table>
					<div class="h30"></div>
					<div class="Paging mt20">
						<%=CommonUtil.getPageSearchView("kepSearch", total_cnt, curPage, onepagerow)%>
					</div>
				</form>
				<form name="locationForm2" id="locationForm2" method="post">
					<input type="hidden" id="upperId" name="upperId"
						value="<c:out value="${param.upperId}"/>"> <input
						type="hidden" name="st_com_code" id="st_com_code"
						value="${sessionInfo.comCode}"> <input type="hidden"
						name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

				</form>
				<form name="processForm2" id="processForm2" method="post">
				<input type="hidden" name="tabIndex" id="tabIndex" value="2" />
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="buyer" id="buyer" value="" /> <input
						type="hidden" name="gubun" id="gubun" value="" /> <input
						type="hidden" name="total_cnt" id="total_cnt"
						value="<%=total_cnt%>" /> <input type="hidden" name="curPage"
						id="curPage" value="<%=curPage%>" /> <input type="hidden"
						name="onepagerow" id="onepagerow" value="<%=onepagerow%>" />
					<div id="process2"></div>
				</form>
				<form name="updateForm2" id="updateForm2" method="post">
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="tabIndex" id="tabIndex" value="2" />
					<input type="hidden" name="buyer" id="buyer" value="" /> <input
						type="hidden" name="gubun" id="gubun" value="" /> <input
						type="hidden" name="total_cnt" id="total_cnt"
						value="<%=total_cnt%>" /> <input type="hidden" name="curPage"
						id="curPage" value="<%=curPage%>" /> <input type="hidden"
						name="onepagerow" id="onepagerow" value="<%=onepagerow%>" /> <input
						type="hidden" name="st_update" id="st_update" value="" /> <input
						type="hidden" name="st_btoa_user_mail" id="st_btoa_user_mail"
						value="" /> <input type="hidden" name="st_btoa_user_tel"
						id="st_btoa_user_tel" value="" /> <input type="hidden"
						name="st_btoa_user_fax" id="st_btoa_user_fax" value="" /> <input
						type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer%>" />
					<input type="hidden" name="st_user_id" id="st_user_id"
						value="<%=user_id%>" /> <input type="hidden" name="st_user_name"
						id="st_user_name" value="<%=user_name%>" /> <input type="hidden"
						name="st_user_dept" id="st_user_dept" value="<%=user_dept%>" />
					<div id="process"></div>
				</form>
				<div class="h50"></div>
			</div>
			<!--Tab2끝 -->


			<!-- 탭 스크립트 -->
			<script>
      const tabLinks = document.querySelectorAll(".TabTit");
      const tabContents = document.querySelectorAll(".SearchContent");
    
      tabLinks.forEach(function(link,index) {
        link.addEventListener("click", function() {
           // 모든 탭 버튼, 컨텐츠 비활성화
           tabLinks.forEach(function(btn) {btn.classList.remove("active")});
           tabContents.forEach(function(content){ content.classList.remove("active")});
      
          // 클릭한 탭 활성화
          link.classList.add("active");
          document.getElementById(link.dataset.tab).classList.add("active");
          curIdx = index+1; //현재 탭 index를 저장
          tabIndex = index+1;
        });
      });
    </script>
		</div>

		<!--내용 종료-->
	</div>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp"%>
	</div>
</body>

<script type="text/javascript">
let row_seq = 0;
var curPage = 1;  
var popupSel = "";
var btnEvent = "";
var g_Row          =  0;
var temp_yn = "N"; // 임시저장 여부
var curIdx ="<%=curIdx%>";
var tabIndex = "<%=tabIndex%>";
var product_cnt = 0;
var product_amt = 0;

var getCodeCDNO = "<%=getCodeCDNO%>"; //자동채번 고객사

var rowTemplate1 = null;
var rowTemplate2 = null;

// 최초 화면 함수
function kep_onload_view(){
	//페이지 로드 시 초기화 --> 라디오버튼 충돌 막기위해
	row_seq = 0;
// 	if(tabIndex != curIdx){
// 		tabIndex = curIdx;
// 	}
	$(".tab-content").removeClass("active");
	$(".TabTit").removeClass("active");
    $("#Search" + tabIndex).addClass("active");
    $("#btn" + tabIndex).addClass("active");
    
	$("input[name=st_btoa_end_date]").val(getWorkingDay());
	
	
	//자동채번 고객사들은 품목코드 수정 못함 cck --> 활성화 시켜놓고 추후 다시 비활성화 시킬 예정
// 	if(getCodeCDNO == "true"){
// 		$('#contentForm input[name="st_buyer_item_no"]').prop('readonly',true).css('background','#EAEAEA');
// 	}
	
	//추후 다 삭제하고 행추가 할 때 사용할 템플릿
	const tbody = document.getElementById('tblshow1').tBodies[0];
	rowTemplate1 = tbody.children[1].cloneNode(true);
	rowTemplate2 = tbody.children[2].cloneNode(true);
	
}	

$(document).ready(function() {
    $('input[type=radio]').change(function() {
    	if(this.name.includes('__')){ // 신규등록화면
	    	var baseName = this.name.split('__')[0];
	    	var idx  = this.name.split('__')[1];
	    	var baseId = baseName+ '_text__' + idx;
	    	$('#'+baseId).val($('input[name="'+this.name+'"]:checked').val());
    	}else{
    		var baseName = this.name;
    		$('#'+baseName+'_text').val($('input[name="'+this.name+'"]:checked').val());
    	}
    });
});

function findOuterRow(el, outerTable) {
    var node = el;
    var tbody = outerTable.tBodies[0];
    while (node && node.parentElement !== tbody) {
        node = node.parentElement;
    }
    return node;
}

function checkNumber(event) {
	  if(event.key === '.' 
	     || event.key === '-'
	     || event.key >= 0 && event.key <= 9) {
	    return true;
	  }
	  
	  return false;
	}
//조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage;
	document.forms.searchForm.curIdx.value = curIdx;
	document.forms.searchForm.tabIndex.value = tabIndex;
	$('#searchForm').attr("action", "/mprq/showBuyerMpRqRequestQuotation_v2.do").submit();   
}

/* 신규 등록 화면 함수*/
// 행추가
function addRow() {
	
	var remark_data    = "<%=p060000068%>";
	
	const table = document.getElementById('tblshow1');
	const tbody = table.tBodies[0]; // 기존 tbody 참조
	const topLevelRows = tbody.children;

	row_seq++;

	const newRow1 = rowTemplate1.cloneNode(true);
    const newRow2 = rowTemplate2.cloneNode(true);

	const newRows = [newRow1, newRow2];
	newRows.forEach(function(row){
	    const inputs = row.querySelectorAll('input, select, button');
	    inputs.forEach(function(input){
	        if (input.type === 'radio') {
	            const baseName = input.name.split('__')[0];
	            input.name = baseName + "__" + row_seq;
	            input.checked = false;
	            if (input.value === 'N') {
	                input.checked = true;
	            }
	        } else if (input.type === 'checkbox') {
	            input.checked = false;
	        } else if (input.tagName === 'SELECT') {
	            if (input.name === 'st_req_price_type') {
	                input.value = '';
	            } else {
	                input.selectedIndex = 0;
	            }
	        } else {
	        	if(input.readOnly){
	        		
	        	}
	        	if(input.name === "st_btoa_remark"){
	        		input.value = remark_data;
	        	}else{
		            input.value = "";
	        	}
	        }
	        input.id = input.id.split('__')[0] + "__" + row_seq;
	    });
	    
	});

	tbody.appendChild(newRow1);
	tbody.appendChild(newRow2);
	
	['st_pre_gr_flag', 'st_make_goods_flag', 'st_msds_flag', 'st_safety_flag'].forEach(function(baseName) {
        var hiddenId = baseName + '_text__' + row_seq;
        var hidden = document.getElementById(hiddenId);
        console.log(hiddenId + ' : ' + hidden);
        if (hidden) hidden.value = 'N';
    });
    
    //회신요청일 초기화
	$("#st_btoa_end_date__"+row_seq).val(getWorkingDay());
    
}
function addRow2(param) {
	
	var remark_data    = "<%=p060000068%>";
	
	const table = document.getElementById('tblshow1');
	const tbody = table.tBodies[0]; // 기존 tbody 참조
	const topLevelRows = tbody.children;

	row_seq++;

	const newRow1 = rowTemplate1.cloneNode(true);
    const newRow2 = rowTemplate2.cloneNode(true);

	const newRows = [newRow1, newRow2];
	newRows.forEach(function(row){
	    const inputs = row.querySelectorAll('input, select, button');
	    inputs.forEach(function(input){
	        if (input.type === 'radio') {
	            const baseName = input.name.split('__')[0];
	            input.name = baseName + "__" + row_seq;
	            input.checked = false;
	            if (input.value === 'N') {
	                input.checked = true;
	                
	                var hiddenId = baseName + '_text__' + row_seq;
	                var hidden = document.getElementById(hiddenId);
	                if (hidden) hidden.value = 'N';
	            }
	        } else if (input.type === 'checkbox') {
	            input.checked = false;
	        } else if (input.tagName === 'SELECT') {
	            if (input.name === 'st_req_price_type') {
	                input.value = '';
	            } else {
	                input.selectedIndex = 0;
	            }
	        } else {
	        	if(input.name === "st_btoa_remark"){
	        		input.value = remark_data;
	        	}else{
		            input.value = "";
	        	}
	        }
	        input.id = input.id.split('__')[0] + "__" + row_seq;
	    });
	});
	
	//param로 가져온 값을 대입
	var fieldMapping = {
	    'st_buyer_item_no'        : param['st_buyer_item_no'],
	    'st_description'          : param['st_description'],
	    'st_maker_part_no'        : param['st_maker_part_no'],
	    'st_specification'        : param['st_specification'],
	    'st_maker_name'           : param['st_maker_name'],
	    'st_origin_name'          : param['st_origin_name'],
	    'st_origin_code'          : param['st_origin_code'],
	    'st_category_name'        : param['st_categ_name'],
	    'st_category_code'        : param['st_categ_id'],
	    'st_unit_measure'        : param['st_unit_measure']
	};

	Object.keys(fieldMapping).forEach(function(inputName) {
	    var val = fieldMapping[inputName];
	    if (val === undefined || val === null) return;
	    var target = newRow1.querySelector('[name="' + inputName + '"]')
	              || newRow2.querySelector('[name="' + inputName + '"]');
	    if (target) target.value = val;
	});

	const headerRow = tbody.children[0]; // 헤더 tr
	tbody.insertBefore(newRow2, headerRow.nextSibling);
	tbody.insertBefore(newRow1, headerRow.nextSibling);
    
	['st_pre_gr_flag', 'st_make_goods_flag', 'st_msds_flag', 'st_safety_flag'].forEach(function(baseName) {
        var hiddenId = baseName + '_text__' + row_seq;
        var hidden = document.getElementById(hiddenId);
        console.log(hiddenId + ' : ' + hidden);
        if (hidden) hidden.value = 'N';
    });
	
    //회신요청일 초기화
	$("#st_btoa_end_date__"+row_seq).val(getWorkingDay());
    //데이터 수정할 때 체크필요(기존품목 클릭으로 정보 가져오고 정보를 수정하려하면 신규상품으로 등록된다는 것 알려야 함) 
	$("#catalogSet__"+row_seq).val("Y");
    
}
//각 해당 ROW 삭제
function delRow(btn) {
	
	var table = document.getElementById('tblshow1');
	var tbody = table.tBodies[0];
    var allCheckboxes = table.querySelectorAll('input[name="InCheck"]');
    
    if (allCheckboxes.length === 1) {
    	var text = "<%=CommonLang.msg("MSG41")%>"; //모든 데이타를 삭제할수는 없습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
    	return;
    }
    
    var tr = btn.closest('tr');
    var nextTr = tr.nextElementSibling;
    
    tr.remove();
    if (nextTr) nextTr.remove();

}
function delRowCheck2(btn){
	var text = "<%=CommonLang.msg("MSG42")%>"; // 삭제하시겠습니까?
	var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
	var but2textC ="<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but1funcC = "javascript:delRow2('"+btn.id+"'); return false;"; 
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
	return;
}
function delRow2(index) {
	closePopText1();
	
	var query = "";
    var st_quotation_no = $("#st_quotation_no"+index).val();
    var st_quotation_seq = $("#st_quotation_seq"+index).val();
    var st_revision = $("#st_revision"+index).val();
    query = st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "&&";
    
    document.forms.updateForm2.st_update.value = query;
    
	kepAjaxFormCall("/mprq/delBuyerMpRqTempSaveList.do","updateForm2", "delRow2");

}

function executeDelRow(){
	closePopText1();
	
	const table = document.getElementById('tblshow1');
	// 헤더가 index 0, 첫 번째 데이터 행이 index 1
	const firstDataRow = table.rows[1]; 
	
	if (!firstDataRow) return;

	// 2. 행 내부의 모든 입력 요소(input, select) 가져오기
	const inputs = firstDataRow.querySelectorAll('input');
	const selects = firstDataRow.querySelectorAll('select');

	// 3. Input 요소 초기화
	inputs.forEach(function(el) {
		const name = el.name || "";

		if (el.type === 'checkbox') {
			el.checked = false; // 체크박스 해제 (InCheck)

		} else if (el.type === 'radio') {
			// 라디오 버튼은 value가 'N'인 것을 체크
			el.checked = (el.value === 'N');

		} else if (el.type === 'hidden') {
			// 히든 값 처리
			if (name === 'excel_up') {
				el.value = 'N';
			} else if (name.includes('_flag')) {
				el.value = 'N'; // flag 관련 히든값(st_pre_gr_flag_text 등) N으로 초기화
			} else {
				el.value = ''; // 나머지 hidden(st_image_key 등) 비움
			}

		} else if (el.type === 'text' || el.type === 'number') {
			// 텍스트 및 숫자형 input
			if (name === 'st_btoa_end_date') {
				// 회신요청일: getworkingday() 호출 (함수 없을 시 빈값)
				el.value = typeof getWorkingDay === 'function' ? getWorkingDay() : '';
			} else if (name === 'st_btoa_remark') {
				el.value = "<%=p060000068%>";
			} else {
				el.value = ''; // 나머지 품목명, 규격, 수량, 단가 등 비움
			}
		}
	});

	// 4. Select 요소 초기화
	selects.forEach(function(el) {
		if (el.name === 'st_req_price_type') {
			el.value = '';
		} else {
			el.selectedIndex = 0; // 단위(st_unit_measure) 등 나머지는 첫 번째 옵션
		}
	});

	// 5. 시각적 요소 초기화 (필요 시)
	const attachBtn = firstDataRow.querySelector('button[id^="attachBtn"]');
    if (attachBtn) {
        if (attachBtn.classList.contains('FileOutline_on')) {       // 클래스 리스트에서 _on이 붙은 클래스를 찾아 등록 전 버튼 클래스로 교체
            attachBtn.classList.remove('FileOutline_on');
            attachBtn.classList.add('FileOutline');
        }
        attachBtn.innerText = "<%=CommonLang.get("HTITLE440")%>";  // 등록
    }
}
// 행복사
function copyRow(btn) {
    var sourceRow = btn.closest('tr');
    var table = document.getElementById('tblshow1');
    
    var sourceRow2 = sourceRow.nextElementSibling;
    
    
    row_seq++; // 삭제 여부와 상관없이 번호는 계속 증가함
    
    // 1. 행 복사 (기존에 만든 copyRow 로직 활용)
    var newRow = sourceRow.cloneNode(true);
    var newRow2 = sourceRow2.cloneNode(true);
    
    function reindex(row){
    	// 2. id, name에 seq 맞춰서 추가
        const inputs = newRow.querySelectorAll('input, select,button');
        inputs.forEach(function(input){
            if (input.type === 'radio') {
                const baseName = input.name.split('__')[0];
                const baseSeq = input.name.split('__')[1];
                input.name = baseName + "__" + row_seq;
                input.checked = false;
            } else if (input.type === 'checkbox') {
                input.checked = false;
            } else {
                input.value = "";
            }
            input.id =  input.id.split('__')[0] + "__" + row_seq;
        });
    }
    
    reindex(newRow);
    if(newRow2){
    	reindex(newRow2);
    }
    
    // 2. 값 복사 : 원본 행의 값을 새 행의 input들에 매칭하여 입력
    var fields = [
        'st_item_qty', 'st_description', 'st_buyer_target_price', 'st_specification',
        'st_unit_measure', 'st_maker_name', 'st_origin_code', 'st_origin_name',
        'st_btoa_remark', 'st_category_code', 'st_category_name',
        'st_pre_gr_flag', 'st_make_goods_flag', 'st_msds_flag','st_safety_flag', 'st_req_price_type', 'st_btoa_end_date','st_maker_part_no'
    ];

    fields.forEach(function(name){
        var sourceVal = sourceRow.querySelector('[name="' + name + '"]')?.value || "";
        var targetInput = newRow.querySelector('[name="' + name + '"]');
        if (targetInput) targetInput.value = sourceVal;
    });
    
    //파일첨부 버튼은 초기화된 상태로 복사
    var attachBtn = newRow.querySelector('button[id^="attachBtn"]');
    if (attachBtn) {
        attachBtn.classList.remove('FileOutline_on');
        attachBtn.classList.add('FileOutline');
        attachBtn.innerText = "<%=CommonLang.get("HTITLE440")%>"; // 등록
    }
    
    if(sourceRow2 && newRow2){
    	var remarkFields = ['st_btoa_remark'];
        remarkFields.forEach(function(name){
            var sourceVal = sourceRow2.querySelector('[name="' + name + '"]')?.value || "";
            var targetInput = newRow2.querySelector('[name="' + name + '"]');
            if (targetInput) targetInput.value = sourceVal;
        });
    }
	
    const originalRadios = sourceRow.querySelectorAll('input[type="radio"]');
    const newRadios = newRow.querySelectorAll('input[type="radio"]');
    
    originalRadios.forEach(function(origRadio, index) {
        newRadios[index].checked = origRadio.checked; // 원본의 상태를 그대로 복사본에 적용
    });
    
    table.appendChild(newRow);
    if (newRow2) table.appendChild(newRow2);
    
}

// 선택된 행 복사
function checkedCopy(){
    // 1. 테이블과 체크된 박스들을 가져옵니다.
    const table = document.getElementById('tblshow1');
    const checkedBoxes = table.querySelectorAll('input[name="InCheck"]:checked');

    // 2. 선택된 항목이 없는 경우
    if (checkedBoxes.length === 0) {
    	var text = "<%=CommonLang.msg("MSG78")%>"; //선택된 항목이 없습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    // 3. 선택된 각 행을 복사하여 테이블에 추가
    checkedBoxes.forEach(function(checkbox) {
    		copyRow(checkbox);
    });

    // 7. 전체 선택 체크박스가 있었다면 해제
    const masterCheckbox = table.querySelector('th input[type="checkbox"]');
    if (masterCheckbox) {
        masterCheckbox.checked = false;
    }
}
//재귀함수
var changed_i=0;
var changed_tot_cnt= 0;

function checkedDel() {
	// 1. 테이블 내의 전체 데이터 행 체크박스와 선택된 체크박스를 가져옵니다.
	const table = document.getElementById('tblshow1');
	const allCheckboxes = table.querySelectorAll('input[name="InCheck"]');
	const checkedBoxes = table.querySelectorAll('input[name="InCheck"]:checked');
	
	// 2. 아무것도 선택하지 않은 경우
	if (checkedBoxes.length === 0) {
		var text = "<%=CommonLang.msg("MSG78")%>"; //선택된 항목이 없습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
	    return;
	}
	if(allCheckboxes.length === 1){
		var text = "<%=CommonLang.msg("MSG41")%>"; //모든 데이타를 삭제할수는 없습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
	    return;
	}
	
	// 3. 삭제 확인 및 실행
	var text = "<%=CommonLang.msg("MSG42")%>"; // 삭제하시겠습니까?
	var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
	var but2textC ="<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but1funcC = "javascript:executeDeleteRows(); return false;"; 
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
}

function executeDeleteRows() {
	closePopText1();
	
    const table = document.getElementById('tblshow1');
    const allCheckboxes = table.querySelectorAll('input[name="InCheck"]');
	const checkedBoxes = table.querySelectorAll('input[name="InCheck"]:checked');
	
	if (checkedBoxes.length === 0) return; // 선택된 항목이 없으면 함수 종료

	// 모든 데이터를 삭제하려고 하거나, 남은 데이터가 1개뿐인데 삭제하려는 경우
	if (allCheckboxes.length === 1 || checkedBoxes.length === allCheckboxes.length) {
		// 1. 남겨둘 첫 번째 행(tr) 지정
		const trToKeep = allCheckboxes[0].closest('tr');
		const trToKeepNext = trToKeep.nextElementSibling;
		
		// 2. 남겨진 행 내부의 폼 요소 데이터 초기화
		const formElements = trToKeep.querySelectorAll('input, select, textarea');
		formElements.forEach(function(el) {
			
			if (el.type === 'checkbox') {
				el.checked = false; // 체크박스 해제
				
			} else if (el.type === 'radio') {
				el.checked = (el.value === 'N');
				
			} else if (el.tagName === 'SELECT') {
				if (el.name === 'st_req_price_type') {
					el.value = '';
				} else {
					el.selectedIndex = 0; // 그 외 select 박스들도 첫 번째로 초기화 (필요시)
				}
			} else {
				if (el.name && el.name.includes('st_btoa_end_date')) {
					el.value = typeof getWorkingDay === 'function' ? getWorkingDay() : '';
				} else {
					el.value = ''; 
				}
			}
		});
		
		// 3. 남겨진 첫 번째 행을 제외한 나머지 모든 행 삭제
		for (let i = 1; i < allCheckboxes.length; i++) {
			const trToRemove = Array.from(table.querySelectorAll('tr'))
	        .find(function(tr){return tr.contains(allCheckboxes[i])});

		    if (trToRemove) {
		        const nextTr = trToRemove.nextElementSibling;
	
		        trToRemove.remove();
		        if (nextTr) nextTr.remove();
		    }
		}
	}else{
		const rowsToDelete = [];
	    checkedBoxes.forEach(function(checkbox) {
	    	const allTrs = Array.from(table.querySelectorAll('tr'));
	        const mainTr = allTrs.find(function(tr){ return tr.contains(checkbox)});
	        if (mainTr && !rowsToDelete.includes(mainTr)) {
	            const nextTr = mainTr.nextElementSibling;
	            rowsToDelete.push(mainTr);
	            if (nextTr) rowsToDelete.push(nextTr);
	        }
	    });
	    rowsToDelete.forEach(function(tr){tr.remove()});
	}
}

//견적의뢰
function checkForm() {
	const table = document.getElementById('tblshow1');
	const checkedBoxes = table.querySelectorAll('input[name="InCheck"]:checked');
	
	const allInChecks = table.querySelectorAll('input[name="InCheck"]'); 
  	var tot_cnt = allInChecks.length; // 테이블 행 수가 아닌 실제 데이터 건수
  	product_cnt = tot_cnt;

  	var nowDate             = kepGetNowTimeStr('YYYYMMDD','');
  	const itemSet = new Set();
  	
	if(checkedBoxes.length == 0) {
		var text = "<%=CommonLang.msg("MSG78")%>"; 		//선택된 항목이 없습니다.
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
	}
  
	if(tot_cnt < 2) {
		if(eval("document.forms.contentForm.InCheck").checked==true) {
			var buyer_item_no					= document.forms.contentForm.st_buyer_item_no.value;         // 품목코드
			var itemCodeEl = document.forms.contentForm.st_buyer_item_no;
			itemCodeEl.value = kepNormalizeItemCode(itemCodeEl.value);
			buyer_item_no = itemCodeEl.value;
			if(kepHasHangul(buyer_item_no)) {
				itemCodeEl.focus();
				var text = "품목코드에는 한글을 사용할 수 없습니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(buyer_item_no == '' || buyer_item_no == null) {
				buyer_item_no  = 'NO_CODE';	
			}
			var item_qty					= document.forms.contentForm.st_item_qty.value;              // 수량
// 			var item_qty_text				= kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty_text.value));              // 수량
			var description					= document.forms.contentForm.st_description.value;           // 품목명
			var buyer_target_price			= document.forms.contentForm.st_buyer_target_price.value;    // 실적단가
// 			var buyer_target_price_text		= kepFilterNum(kepTrimStr(document.forms.contentForm.st_buyer_target_price_text.value));    // 실적단가
			var btoa_end_date				= document.forms.contentForm.st_btoa_end_date.value.replaceAll('/','');         // 회신요청일
			var specification				= document.forms.contentForm.st_specification.value;         // 규격
          
			var image_key					= document.forms.contentForm.st_image_key.value;              // 첨부파일 이미지 키
			var btoa_remark					= document.forms.contentForm.st_btoa_remark.value;           // 비고
			var make_goods					= document.forms.contentForm.st_make_goods_flag.value;
			var st_req_price_type			= document.forms.contentForm.st_req_price_type.value;

			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				var text = "<%=CommonLang.msg("MSG40")%>"; 				//회신요청일은 현재일 이후여야 합니다.
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			// NO_CODE로만 진행하도록 통제
			<%if (p060000132 == true) {%>
					if(buyer_item_no != 'NO_CODE') {
						var text = "<%=CommonLang.msg("MSG592")%>"; 				//견적 시 품목코드 NO_CODE로만 진행 가능합니다.
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
			<%}%>
		
			var unit_measure				= document.forms.contentForm.st_unit_measure.value;          // 단위
			var maker_name					= document.forms.contentForm.st_maker_name.value;            // 제조사
			var origin_code					= document.forms.contentForm.st_origin_code.value;           // 원산지
			var agent_name					= document.forms.contentForm.st_agent_name.value;            // 기존협력사
			
			if(kepIsValueNull(kepTrimStr(item_qty)) || !(kepIsNumberStr(item_qty))) {
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty.focus();
				
				var text = "<%=CommonLang.msg("MSG555")%>"; 	//수량을 정수형으로 입력하여 주십시오.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if(item_qty == '0') {
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty.focus();
				
				var text = "<%=CommonLang.msg("MSG192")%>"; 			//수량에 1 이상의 숫자를 입력해 주십시요
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			

			var category_code      = document.forms.contentForm.st_category_code.value;       // 카테고리
			var category_name      = document.forms.contentForm.st_category_name.value;       // 카테고리
			<%// 롯데알미늄 카테고리 필수값 체크
			if ((p04404201 == true)) {%>
				if(kepIsValueNull(kepTrimStr(category_name))) {
					var text = "<%=CommonLang.msg("MSG489")%>"; //카테고리 필수값 체크
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			<%}%>
			
			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				document.forms.contentForm.st_description.focus();
				var text = "<%=CommonLang.msg("MSG48")%>"; //품명을 입력하여 주십시오.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
// 			buyer_target_price = buyer_target_price_text;
			<%// 요청단가 필수값 체크
			if ((p04405301 == true)) {%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					document.forms.contentForm.st_buyer_target_price.focus();
					var text = "<%=CommonLang.msg("MSG495")%>";	//요청단가를 입력하여 주십시오.
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			<%}%>
			
			if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
				if(!kepIsNumChkStr(buyer_target_price, 3)) {
					document.forms.contentForm.st_buyer_target_price.value   = "";
					document.forms.contentForm.st_buyer_target_price.focus();
					var text = "<%=CommonLang.msg("MSG49")%>";						//실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			}else {
				buyer_target_price = 0;
			}

			//단가구분 체크
			if(kepIsValueNull(kepTrimStr(st_req_price_type))) {
				document.forms.contentForm.st_req_price_type.focus();
				var text = "<%=CommonLang.msg("MSG961")%>"; //단가구분을 선택해주세요.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				document.forms.contentForm.st_specification.focus();
				var text = "<%=CommonLang.msg("MSG50")%>";		//규격을 입력하여 주십시오.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}

			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				var text = "<%=CommonLang.msg("MSG51")%>";		//회신요청일을 입력하여 주십시오.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		
		<%// 제조사 필수값 체크
			if ((p04405401 == true)) {%>
			if(kepIsValueNull(kepTrimStr(maker_name))) {
				document.forms.contentForm.st_maker_name.focus();
				var text = "<%=CommonLang.msg("MSG496")%>";	//제조사를 입력하여 주십시오.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		<%}%>	
		
		if(make_goods == "Y"){
			document.forms.contentForm.st_btoa_remark.value = "제작품, " +btoa_remark;
		}
		
		}
	} else {
		for(var i = 0; i < tot_cnt; i++) {
			if(document.forms.contentForm.InCheck[i].checked==true) {
				var buyer_item_no = document.forms.contentForm.st_buyer_item_no[i].value;                          // 품목코드
				var itemCodeEl = document.forms.contentForm.st_buyer_item_no[i];
				itemCodeEl.value = kepNormalizeItemCode(itemCodeEl.value);
				buyer_item_no = itemCodeEl.value;
				if(kepHasHangul(buyer_item_no)) {
					itemCodeEl.focus();
					var text = (i+1)+"번째 행의 품목코드에는 한글을 사용할 수 없습니다.";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				if(buyer_item_no == '' || buyer_item_no == null) {
					buyer_item_no  = 'NO_CODE';	
				}else{
					if(itemSet.has(buyer_item_no)){
						var text = "<%=CommonLang.msg("MSG736")%>"; 		//동일 품목코드로 견적의뢰할 수 없습니다. 품목코드 중복 확인 바랍니다.
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
					itemSet.add(buyer_item_no);
				}
				var item_qty						= document.forms.contentForm.st_item_qty[i].value;                               // 수량
// 				var item_qty_text					= kepFilterNum(document.forms.contentForm.st_item_qty_text[i].value);               // 수량
				var description						= document.forms.contentForm.st_description[i].value;                            // 품목명
				var buyer_target_price			= document.forms.contentForm.st_buyer_target_price[i].value;                     // 실적단가
// 				var buyer_target_price_text	= kepFilterNum(document.forms.contentForm.st_buyer_target_price_text[i].value);     // 실적단가
				var btoa_end_date					= document.forms.contentForm.st_btoa_end_date[i].value.replaceAll('/',''); // 회신요청일
				var specification					= document.forms.contentForm.st_specification[i].value;                          // 규격
				var btoa_remark						= document.forms.contentForm.st_btoa_remark[i].value;        // 비고
				var image_key						= document.forms.contentForm.st_image_key[i].value;           // 첨부파일 이미지 키
				var st_req_price_type				= document.forms.contentForm.st_req_price_type[i].value;
	            
				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//회신요청일은 현재일 이후여야 합니다.
					var text = "<%=CommonLang.msg("MSG40")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				var unit_measure						= document.forms.contentForm.st_unit_measure[i].value;           // 단위
				
				var maker_name						= document.forms.contentForm.st_maker_name[i].value;         // 제조사
				var origin_code						= document.forms.contentForm.st_origin_code[i].value;        // 원산지
				var agent_name						= document.forms.contentForm.st_agent_name[i].value;         // 기존협력사
				var make_goods					= document.forms.contentForm.st_make_goods_flag[i].value;

				// NO_CODE로만 진행하도록 통제
				<%if (p060000132 == true) {%>
						if(buyer_item_no != 'NO_CODE') {
							//견적 시 품목코드 NO_CODE로만 진행 가능합니다.
							var text = "<%=CommonLang.msg("MSG592")%>";
							openLayerPopText2(text,but1text,but1func,but1width);
							return;
						}
				<%}%>
			
				if(kepIsValueNull(kepTrimStr(item_qty)) || !(kepIsNumberStr(item_qty))) {
					document.forms.contentForm.st_item_qty[i].value="";
					document.forms.contentForm.st_item_qty[i].focus();
					//번째 행의 수량을 정수형으로 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG556")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				if(item_qty == '0') {
					document.forms.contentForm.st_item_qty[i].value ="";
					document.forms.contentForm.st_item_qty[i].focus();
					//수량에 1 이상의 숫자를 입력해 주십시요
					var text = "<%=CommonLang.msg("MSG192")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}

				var category_code      = document.forms.contentForm.st_category_code[i].value;       // 카테고리
				var category_name      = document.forms.contentForm.st_category_name[i].value;       // 카테고리
				<%// 롯데알미늄 카테고리 필수값 체크
			if ((p04404201 == true)) {%>
					// 카테고리 필수값 체크
					if(kepIsValueNull(kepTrimStr(category_name))) {
						//카테고리를 선택하세요
						var text = "<%=CommonLang.msg("MSG489")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				<%}%>
				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					document.forms.contentForm.st_description[i].focus();
					//번째 행의 품명을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG54")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}

				buyer_target_price = buyer_target_price;
				<%// 요청단가 필수값 체크
			if ((p04405301 == true)) {%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
						document.forms.contentForm.st_buyer_target_price[i].focus();
						//번째 행의 요청단가를 입력하여 주십시오.
						var text = (i+1)+"<%=CommonLang.msg("MSG501")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				<%}%>
				
				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						document.forms.contentForm.st_buyer_target_price[i].value    = "";
						document.forms.contentForm.st_buyer_target_price[i].focus();

						//번째 행의 실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						var text = (i+1)+"<%=CommonLang.msg("MSG55")%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				}else {
					buyer_target_price = 0;
				}
				
				//단가구분 체크
				if(kepIsValueNull(kepTrimStr(st_req_price_type))) {
					document.forms.contentForm.st_req_price_type[i].focus();
					//번째 행의 단가구분을 선택해주세요
					var text = (i+1)+"<%=CommonLang.msg("MSG962")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}

				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					document.forms.contentForm.st_specification[i].focus();
					
					//번째 행의 규격을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG56")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}

				// 등록요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오..
					var text = (i+1)+"<%=CommonLang.msg("MSG57")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			<%// 제조사 필수값 체크
			if ((p04405401 == true)) {%>
				if(kepIsValueNull(kepTrimStr(maker_name))) {
					document.forms.contentForm.st_maker_name[i].focus();
					//번째 행의 제조사를 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG502")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
			<%}%>

				if(make_goods == "Y"){
					if(document.forms.contentForm.st_btoa_remark[i].value.substring(0,4) != "제작품,") {						
						document.forms.contentForm.st_btoa_remark[i].value = "제작품, " +btoa_remark;
					}				
				}
			}
		}
	}

	var chkFlag = false;
	var chkGridValue = {};
	var formArr = getFormToArr_v3("document.forms.contentForm",chkFlag,chkGridValue);
	if(formArr != null && formArr !=""){
		$("#processForm").find("#s_SAVENAME").val(formArr[0].replace("check_status|",""));
		$("#process").html(formArr[1]);
		$("#process").find("#check_status").remove();
	}else{
		//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
		var text = (i+1)+"<%=CommonLang.msg("MSG13")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if(temp_yn == "Y"){ // 임시저장
		//임시저장한 데이터는 임시저장 화면에서 확인 가능합니다. 저장하시겠습니까?
		var text = "<%=CommonLang.msg("MSG770")%>";
		var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
		var but1funcC = "javascript:saveTemp(); return false;"; 
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
	}else{ // 결재
		// 건의 상품을 견적요청 하시겠습니까?
		var text = checkedBoxes.length+"<%=CommonLang.msg("MSG739")%>";
		var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
		var but1funcC = "javascript:saveReg(); return false;"; 
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
	
	}
}
function saveTemp(){
	closePopText1(); 
	temp_yn = "N";
	kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationTemp_v2.do","processForm",btnEvent);
}

function saveReg(){
	closePopText1(); 
	kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationStnd_v2.do","processForm",btnEvent);
}
/****** 신규등록 화면 함수 종료******/
 
/****** 임시저장 화면 함수 시작******/

// 견적의뢰
function setRequest(){
	var tot_cnt = $("#display_item_cnt").val();
    var checked_count = 0;
    var nowDate = kepGetNowTimeStr('YYYYMMDD','');
	var itemSet = new Set();
	
    if(tot_cnt==1){
        if(document.forms.contentForm2.InCheck.checked==true) checked_count = 1;
    }else{
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm2.InCheck[j].checked==true) {
                checked_count++;
                var buyer_item_no = document.forms.contentForm2.st_buyer_item_no[j].value;
                if(buyer_item_no == '' || buyer_item_no == null || buyer_item_no == "NO_CODE") {
                }else{
					if(itemSet.has(buyer_item_no)){
						var text = "<%=CommonLang.msg("MSG736")%>"; 		//동일 품목코드로 견적의뢰할 수 없습니다. 품목코드 중복 확인 바랍니다.
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
					itemSet.add(buyer_item_no);
				}
            }
        }
    }
    product_cnt = checked_count;
    
    if(checked_count==0) {
    	//견적의뢰할 품목을 선택하여 주십시요.
    	var text = "<%=CommonLang.msg("MSG43")%>"; 
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
	if(tot_cnt <= 1) {
		if(eval("document.forms.contentForm2.InCheck").checked==true) {
			var item_qty			= document.forms.contentForm2.st_item_qty.value;
// 			var item_qty_text		= kepFilterNum(kepTrimStr(document.forms.contentForm2.st_item_qty.value));              // 수량
			var description			= document.forms.contentForm2.st_description.value;
			var buyer_target_price	= document.forms.contentForm2.st_buyer_target_price.value;
			var btoa_end_date		= document.forms.contentForm2.st_btoa_end_date.value.replaceAll('/','');;
			var specification		= document.forms.contentForm2.st_specification.value;
			var st_category_code	= document.forms.contentForm2.st_category_code.value;
            var category_name		= document.forms.contentForm2.st_category_name.value;
            var maker_name			= document.forms.contentForm2.st_maker_name.value;
            var buyer_item_no		= document.forms.contentForm2.st_buyer_item_no.value;
            var st_req_price_type	= document.forms.contentForm2.st_req_price_type.value;
			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				//회신요청일을 입력하여 주십시오..
				var text = "<%=CommonLang.msg("MSG51")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				//회신요청일은 현재일 이후여야 합니다.
				var text = "<%=CommonLang.msg("MSG40")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			if(kepIsValueNull(kepTrimStr(item_qty)) || !(kepIsNumberStr(item_qty))) {
				document.forms.contentForm2.st_item_qty.value ="";
				document.forms.contentForm2.st_item_qty.focus();
				//수량을 정수형으로 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG555")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			<%// 롯데알미늄 카테고리 필수값 체크
			if ((p04404201 == true)) {%>
				if(kepIsValueNull(kepTrimStr(category_name))) {
					//카테고리를 선택하세요
					var text = "<%=CommonLang.msg("MSG489")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
			<%}%>
			
			// NO_CODE로만 진행하도록 통제
			<%if (p060000132 == true) {%>
				if(buyer_item_no != 'NO_CODE') {
					//견적 시 품목코드 NO_CODE로만 진행 가능합니다.
					var text = "<%=CommonLang.msg("MSG592")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
			<%}%>
			
			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				document.forms.contentForm2.st_description.focus();
				//품목명을 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG62")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;			}
			
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				document.forms.contentForm2.st_specification.focus();
				//규격을 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG50")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			<%// 요청단가 필수값 체크
			if ((p04405301 == true)) {%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					document.forms.contentForm2.st_buyer_target_price.focus();
					//요청단가를 입력하여 주십시오.
					var text = "<%=CommonLang.msg("MSG495")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
			<%}%>
			
			if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
				if(!kepIsNumChkStr(buyer_target_price, 3)) {
					document.forms.contentForm2.st_buyer_target_price.value   = "";
					document.forms.contentForm2.buyer_target_price.focus();
					//요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					var text = "<%=CommonLang.msg("MSG63")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
			}else{
				buyer_target_price = 0;
			}
			//단가구분 체크
			if(kepIsValueNull(kepTrimStr(st_req_price_type))) {
				document.forms.contentForm2.st_req_price_type.focus();
				var text = "<%=CommonLang.msg("MSG961")%>"; //단가구분을 선택해주세요.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			<%// 제조사 필수값 체크
			if ((p04405401 == true)) {%>
				if(kepIsValueNull(kepTrimStr(maker_name))) {
					document.forms.contentForm2.st_maker_name.focus();

					//제조사를 입력하여 주십시오.
					var text = "<%=CommonLang.msg("MSG496")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
			<%}%>
				//안전인증서 셋팅.
// 				if(document.forms.contentForm2.st_safety_yn.checked == true){
// 					document.forms.contentForm2.st_safety_flag.value = "Y";
// 				}else{
// 					document.forms.contentForm2.st_safety_flag.value = "N";
// 				}
		}
	} else {
		for(var i =0; i < tot_cnt; i++) {
			if(document.forms.contentForm2.InCheck[i].checked==true) {
				var item_qty				= document.forms.contentForm2.st_item_qty[i].value;
// 				var item_qty_text			= kepFilterNum(document.forms.contentForm2.st_item_qty[i].value);               // 수량
				var description			= document.forms.contentForm2.st_description[i].value;
				var buyer_target_price	= document.forms.contentForm2.st_buyer_target_price[i].value;
				var btoa_end_date		= document.forms.contentForm2.st_btoa_end_date[i].value.replaceAll('/','');;
				var specification			= document.forms.contentForm2.st_specification[i].value;
				var st_category_code		= document.forms.contentForm2.st_category_code[i].value;
	            var category_name		= document.forms.contentForm2.st_category_name[i].value;
	            var maker_name			= document.forms.contentForm2.st_maker_name[i].value;
	            var buyer_item_no		= document.forms.contentForm2.st_buyer_item_no[i].value;
	            var st_req_price_type	= document.forms.contentForm2.st_req_price_type[i].value;
				// 회신요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG64")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//번째 회신요청일은 현재일 이후여야 합니다.
					var text = (i+1)+"<%=CommonLang.msg("MSG65")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				if(kepIsValueNull(kepTrimStr(item_qty)) || !(kepIsNumberStr(item_qty))) {
					document.forms.contentForm2.st_item_qty[i].value="";
					document.forms.contentForm2.st_item_qty[i].focus();

					//번째 행의 수량을 정수형으로 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG556")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				<%// 롯데알미늄 카테고리 필수값 체크
			if ((p04404201 == true)) {%>
					if(kepIsValueNull(kepTrimStr(category_name))) {
						//카테고리를 선택하세요
						var text = "<%=CommonLang.msg("MSG489")%>"; 
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
				<%}%>
				
				// NO_CODE로만 진행하도록 통제
				<%if (p060000132 == true) {%>
						if(buyer_item_no != 'NO_CODE') {
							//견적 시 품목코드 NO_CODE로만 진행 가능합니다.
							var text = "<%=CommonLang.msg("MSG592")%>"; 
							openLayerPopText2(text,but1text,but1func,but1width);
					        return;

						}
				<%}%>
				
				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					document.forms.contentForm2.st_description[i].focus();
					//번째 행의 품명을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG54")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;

				}
				
				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					document.forms.contentForm2.st_specification[i].focus();
					//번째 행의 규격을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG56")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;

				}
				
				<%// 요청단가 필수값 체크
			if ((p04405301 == true)) {%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
						document.forms.contentForm2.st_buyer_target_price[i].focus();

						//번째 행의 요청단가를 입력하여 주십시오.
						var text = (i+1)+"<%=CommonLang.msg("MSG501")%>"; 
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;

					}
				<%}%>
				
				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						document.forms.contentForm2.st_buyer_target_price[i].value    = "";
						document.forms.contentForm2.buyer_target_price[i].focus();

						//번째 행의 요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						var text = (i+1)+"<%=CommonLang.msg("MSG67")%>"; 
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;

					}
				}else {
					buyer_target_price = 0;
				}
				
				//단가구분 체크
				if(kepIsValueNull(kepTrimStr(st_req_price_type))) {
					document.forms.contentForm2.st_req_price_type[i].focus();
					//번째 행의 단가구분을 선택해주세요
					var text = (i+1)+"<%=CommonLang.msg("MSG962")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;

				}
				
				<%// 제조사 필수값 체크
			if ((p04405401 == true)) {%>
					if(kepIsValueNull(kepTrimStr(maker_name))) {
						document.forms.contentForm2.st_maker_name[i].focus();
						//번째 행의 제조사를 입력하여 주십시오.
						var text = (i+1)+"<%=CommonLang.msg("MSG502")%>"; 
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;

					}
				<%}%>
					//안전인증서 셋팅.
// 					if(document.forms.contentForm2.st_safety_yn[i].checked == true){
// 						document.forms.contentForm2.st_safety_flag[i].value = "Y";
// 					}else{
// 						document.forms.contentForm2.st_safety_flag[i].value = "N";
// 					}
			}
		}
	}
	
	//건의 상품을 견적요청 하시겠습니까?
	var text = checked_count+"<%=CommonLang.msg("MSG739")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
	var but2textC ="<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but1funcC = "javascript:executeSetRequest(); return false"; 
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
	
}

function executeSetRequest(){
	closePopText1(); 
	var tot_cnt = $("#display_item_cnt").val();
	var query = "";
	if(eval(tot_cnt) < 2){
        var st_quotation_no			= document.forms.contentForm2.st_quotation_no.value;
        var st_quotation_seq			= document.forms.contentForm2.st_quotation_seq.value;
        var st_revision					= document.forms.contentForm2.st_revision.value;
        
        var st_buyer_item_no		= document.forms.contentForm2.st_buyer_item_no.value;
        var st_description				= document.forms.contentForm2.st_description.value;
        var st_specification			= document.forms.contentForm2.st_specification.value;
        var st_unit_measure			= document.forms.contentForm2.st_unit_measure.value;
        var st_maker_name			= document.forms.contentForm2.st_maker_name.value;
        var st_origin_code			= document.forms.contentForm2.st_origin_code.value;
        var st_btoa_end_date		= document.forms.contentForm2.st_btoa_end_date.value.replaceAll('/','');
        var st_buyer_target_price	= document.forms.contentForm2.st_buyer_target_price.value;
        var st_item_qty				= document.forms.contentForm2.st_item_qty.value;
        var st_agent_name			= document.forms.contentForm2.st_agent_name.value;
        var st_btoa_remark			= document.forms.contentForm2.st_btoa_remark.value;
        var st_image_key				= document.forms.contentForm2.st_image_key.value;
        var st_req_price_type		= document.forms.contentForm2.st_req_price_type.value;
        var st_category_code			= document.forms.contentForm2.st_category_code.value;
        //표준카테고리, 표준카탈로그 추가
        var st_cms_categ_id		= document.forms.contentForm2.st_cms_categ_id.value;
        var st_cms_catlg_id		= document.forms.contentForm2.st_cms_catlg_id.value;
        var st_req_type			= document.forms.contentForm2.st_req_type.value;
        var st_imgfile_dir		= document.forms.contentForm2.st_imgfile_dir.value;
        var st_imgfile_name		= document.forms.contentForm2.st_imgfile_name.value;
        var st_safety_flag		= document.forms.contentForm2.st_safety_flag.value;
        var st_msds_flag		= document.forms.contentForm2.st_msds_flag.value;
        var st_pre_gr_flag		= document.forms.contentForm2.st_pre_gr_flag.value;
        var st_maker_part_no		= document.forms.contentForm2.st_maker_part_no.value;
        
        if(document.forms.contentForm2.InCheck.checked == true){
            query =	st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
            			st_origin_code + "@@" + st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" + st_category_code +
            			 "@@" + st_cms_categ_id + "@@" + st_cms_catlg_id + "@@" + st_req_type + "@@" + st_imgfile_dir + "@@" + st_imgfile_name + "@@" + st_safety_flag+ "@@" + st_msds_flag+ "@@" + st_pre_gr_flag+"@@"+st_maker_part_no+"&&";
        }
    }else{
        for(var j = 0; j < tot_cnt; j++){
            var box							= eval("document.forms.contentForm2.InCheck[" + j + "]");
            var st_quotation_no			= document.forms.contentForm2.st_quotation_no[j].value;
            var st_quotation_seq			= document.forms.contentForm2.st_quotation_seq[j].value;
            var st_revision					= document.forms.contentForm2.st_revision[j].value;

            var st_buyer_item_no		= document.forms.contentForm2.st_buyer_item_no[j].value;
            var st_description				= document.forms.contentForm2.st_description[j].value;
            var st_specification			= document.forms.contentForm2.st_specification[j].value;
            var st_unit_measure			= document.forms.contentForm2.st_unit_measure[j].value;
            var st_maker_name			= document.forms.contentForm2.st_maker_name[j].value;
            var st_origin_code			= document.forms.contentForm2.st_origin_code[j].value;
            var st_btoa_end_date		= document.forms.contentForm2.st_btoa_end_date[j].value.replaceAll('/','');;
            var st_buyer_target_price	= document.forms.contentForm2.st_buyer_target_price[j].value;
            var st_item_qty				= document.forms.contentForm2.st_item_qty[j].value;
            var st_agent_name			= document.forms.contentForm2.st_agent_name[j].value;
            var st_btoa_remark			= document.forms.contentForm2.st_btoa_remark[j].value;
            var st_image_key				= document.forms.contentForm2.st_image_key[j].value;
            var st_req_price_type		= document.forms.contentForm2.st_req_price_type[j].value;
            var st_category_code			= document.forms.contentForm2.st_category_code[j].value;
            //표준카테고리, 표준카탈로그 추가
            var st_cms_categ_id		= document.forms.contentForm2.st_cms_categ_id[j].value;
            var st_cms_catlg_id		= document.forms.contentForm2.st_cms_catlg_id[j].value;
            var st_req_type			= document.forms.contentForm2.st_req_type[j].value;
            var st_imgfile_dir		= document.forms.contentForm2.st_imgfile_dir[j].value;
        	var st_imgfile_name		= document.forms.contentForm2.st_imgfile_name[j].value;
        	var st_safety_flag		= document.forms.contentForm2.st_safety_flag[j].value;
            var st_msds_flag		= document.forms.contentForm2.st_msds_flag[j].value;
            var st_pre_gr_flag		= document.forms.contentForm2.st_pre_gr_flag[j].value;
            var st_maker_part_no		= document.forms.contentForm2.st_maker_part_no[j].value;
            
            if(box.checked == true){
                query +=	st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
                				st_origin_code + "@@" +	st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" + st_category_code +
                				"@@" + st_cms_categ_id + "@@" + st_cms_catlg_id + "@@" + st_req_type + "@@" + st_imgfile_dir + "@@" + st_imgfile_name + "@@" + st_safety_flag+ "@@" + st_msds_flag+ "@@" + st_pre_gr_flag+"@@"+st_maker_part_no+"&&";
            }
        }
    }            
    
    document.forms.updateForm2.st_update.value = query;
    document.forms.updateForm2.st_btoa_user_mail.value = document.forms.searchForm.st_btoa_user_mail.value;
    document.forms.updateForm2.st_btoa_user_fax.value = document.forms.searchForm.st_btoa_user_fax.value;
    document.forms.updateForm2.st_btoa_user_tel.value = document.forms.searchForm.st_btoa_user_tel.value;

    var chkFlag = false;
	var chkGridValue = {};
	var formArr = getFormToArr_v3("document.forms.contentForm2",chkFlag,chkGridValue);
	if(formArr != null && formArr !=""){
		$("#processForm2").find("#s_SAVENAME").val(formArr[0].replace("check_status|",""));
		$("#process2").html(formArr[1]);
		$("#process2").find("#check_status").remove();
	}else{
		//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
		var text = "<%=CommonLang.msg("MSG13")%>"; 
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
	}
	
	kepAjaxFormCall("/mprq/saveBuyerMpRqTempRequestList_v2.do","updateForm2", btnEvent);
}
// 임시저장
function setSave(){
	var tot_cnt = $("#display_item_cnt").val();
    var checked_count = 0;
    var nowDate = kepGetNowTimeStr('YYYYMMDD','');
	var itemSet = new Set();
    if(tot_cnt==1){
        if(document.forms.contentForm2.InCheck.checked==true) checked_count = 1;
    }else{
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm2.InCheck[j].checked==true) {
                checked_count++;
                var buyer_item_no = document.forms.contentForm2.st_buyer_item_no[j].value;
                if(buyer_item_no == '' || buyer_item_no == null || buyer_item_no == "NO_CODE") {
                }else{
                	console.log(j +"::" + buyer_item_no)
					if(itemSet.has(buyer_item_no)){
						var text = "<%=CommonLang.msg("MSG736")%>"; 		//동일 품목코드로 견적의뢰할 수 없습니다. 품목코드 중복 확인 바랍니다.
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
					itemSet.add(buyer_item_no);
				}
            }
        }
    }
    
    if(checked_count==0) {
    	//저장할 품목을 선택하여 주십시요.
        var text = "<%=CommonLang.msg("MSG68")%>"; 
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    
	if(tot_cnt <= 1) {
		if(eval("document.forms.contentForm2.InCheck").checked==true) {
			var item_qty				= document.forms.contentForm2.st_item_qty.value;
// 			var item_qty_text			= kepFilterNum(kepTrimStr(document.forms.contentForm2.st_item_qty.value));              // 수량
			var description			= document.forms.contentForm2.st_description.value;
			var buyer_target_price	= document.forms.contentForm2.st_buyer_target_price.value;
			var btoa_end_date		= document.forms.contentForm2.st_btoa_end_date.value.replaceAll('/','');
			var specification			= document.forms.contentForm2.st_specification.value;
			var maker_name			= document.forms.contentForm2.st_maker_name.value;
			var st_req_price_type	= document.forms.contentForm2.st_req_price_type.value;
			
			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				//회신요청일을 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG51")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				//회신요청일은 현재일 이후여야 합니다.
				var text = "<%=CommonLang.msg("MSG40")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			if(kepIsValueNull(kepTrimStr(item_qty)) || !(kepIsNumberStr(item_qty))) {
				document.forms.contentForm2.st_item_qty.value ="";
				document.forms.contentForm2.st_item_qty.focus();

				//수량을 정수형으로 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG555")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				document.forms.contentForm2.st_description.focus();
				//품목명을 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG62")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				document.forms.contentForm2.st_specification.focus();
				//규격을 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG50")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			<%// 요청단가 필수값 체크
			if ((p04405301 == true)) {%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					document.forms.contentForm2.st_buyer_target_price.focus();
					
					//요청단가를 입력해주세요.
					var text = "<%=CommonLang.msg("MSG495")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
			<%}%>
			
			if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
				if(!kepIsNumChkStr(buyer_target_price, 3)) {
					document.forms.contentForm2.st_buyer_target_price.value   = "";
					document.forms.contentForm2.buyer_target_price.focus();

					//요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					var text = "<%=CommonLang.msg("MSG63")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
			}else{
				buyer_target_price = 0;
			}
		
			//단가구분 체크
			if(kepIsValueNull(kepTrimStr(st_req_price_type))) {
				document.forms.contentForm2.st_req_price_type.focus();
				//단가구분을 선택해주세요.
				var text = "<%=CommonLang.msg("MSG961")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			
			<%// 제조사 필수값 체크
			if ((p04405401 == true)) {%>
			if(kepIsValueNull(kepTrimStr(maker_name))) {
				document.forms.contentForm2.st_maker_name.focus();
				//제조사를 입력하여 주십시오.
				var text = "<%=CommonLang.msg("MSG496")%>"; 
				openLayerPopText2(text,but1text,but1func,but1width);
		        return;
			}
			<%}%>	
		}
	} else {
		for(var i =0; i < tot_cnt; i++) {
			if(document.forms.contentForm2.InCheck[i].checked==true) {
				var item_qty				= document.forms.contentForm2.st_item_qty[i].value;
// 				var item_qty_text			= kepFilterNum(document.forms.contentForm2.st_item_qty[i].value);               // 수량
				var description			= document.forms.contentForm2.st_description[i].value;
				var buyer_target_price	= document.forms.contentForm2.st_buyer_target_price[i].value;
				var btoa_end_date		= document.forms.contentForm2.st_btoa_end_date[i].value.replaceAll('/','');
				var specification			= document.forms.contentForm2.st_specification[i].value;
				var maker_name			= document.forms.contentForm2.st_maker_name[i].value;
				var st_req_price_type = document.forms.contentForm2.st_req_price_type[i].value;

				// 회신요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG64")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//번째 회신요청일은 현재일 이후여야 합니다.
					var text = (i+1)+"<%=CommonLang.msg("MSG65")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				if(kepIsValueNull(kepTrimStr(item_qty)) || !(kepIsNumberStr(item_qty))) {
					document.forms.contentForm2.st_item_qty[i].value="";
					document.forms.contentForm2.st_item_qty[i].focus();

					//번째 행의 수량을 정수형으로 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG556")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					document.forms.contentForm2.st_description[i].focus();
					//번째 행의 품명을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG54")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					document.forms.contentForm2.st_specification[i].focus();
					//번째 행의 규격을 입력하여 주십시오.
					var text = (i+1)+"<%=CommonLang.msg("MSG56")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
					return;
				}
				
				<%// 요청단가 필수값 체크
			if ((p04405301 == true)) {%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
						document.forms.contentForm2.st_buyer_target_price[i].focus();
						//번째 행의 요청단가를 입력하여 주십시오.
						var text = (i+1)+"<%=CommonLang.msg("MSG501")%>"; 
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
				<%}%>
				
				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						document.forms.contentForm2.st_buyer_target_price[i].value    = "";
						document.forms.contentForm2.buyer_target_price[i].focus();

						//번째 행의 요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						var text = (i+1)+"<%=CommonLang.msg("MSG67")%>"; 
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
				}else {
					buyer_target_price = 0;
				}
				
				//단가구분 체크
				if(kepIsValueNull(kepTrimStr(st_req_price_type))) {
					document.forms.contentForm2.st_req_price_type[i].focus();
					//번째 행의 단가구분을 선택해주세요
					var text = (i+1)+"<%=CommonLang.msg("MSG962")%>"; 
					openLayerPopText2(text,but1text,but1func,but1width);
			        return;
				}
				
				<%// 제조사 필수값 체크
			if ((p04405401 == true)) {%>
					if(kepIsValueNull(kepTrimStr(maker_name))) {
						document.forms.contentForm2.st_maker_name[i].focus();
						//번째 행의 제조사를 입력하여 주십시오.
						var text = (i+1)+"<%=CommonLang.msg("MSG502")%>"; 
						openLayerPopText2(text,but1text,but1func,but1width);
				        return;
					}
				<%}%>	
			}
		}
	}
	
	//선택된 내용을 저장하시겠습니까?
	var text = "<%=CommonLang.msg("MSG358")%>";
	var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
	var but2textC ="<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but1funcC = "javascript:executeSetSave(); return false";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
}

function executeSetSave(){
	closePopText1();
	var tot_cnt = $("#display_item_cnt").val();
    var query = "";
    
   	if(eval(tot_cnt) < 2){
           var st_quotation_no			= document.forms.contentForm2.st_quotation_no.value;
           var st_quotation_seq			= document.forms.contentForm2.st_quotation_seq.value;
           var st_revision				= document.forms.contentForm2.st_revision.value;
           
           var st_buyer_item_no		= document.forms.contentForm2.st_buyer_item_no.value;
           var st_description			= document.forms.contentForm2.st_description.value;
           var st_specification			= document.forms.contentForm2.st_specification.value;
           var st_unit_measure			= document.forms.contentForm2.st_unit_measure.value;
           var st_maker_name			= document.forms.contentForm2.st_maker_name.value;
           var st_origin_code			= document.forms.contentForm2.st_origin_code.value;
           var st_btoa_end_date		= document.forms.contentForm2.st_btoa_end_date.value.replaceAll('/','');
           var st_buyer_target_price	= document.forms.contentForm2.st_buyer_target_price.value;
           var st_item_qty				= document.forms.contentForm2.st_item_qty.value;
           var st_agent_name			= document.forms.contentForm2.st_agent_name.value;
           var st_btoa_remark			= document.forms.contentForm2.st_btoa_remark.value;
           var st_image_key				= document.forms.contentForm2.st_image_key.value;
           var st_req_price_type		= document.forms.contentForm2.st_req_price_type.value;
           var st_category_code			= document.forms.contentForm2.st_category_code.value;
           var st_msds_flag			= document.forms.contentForm2.st_msds_flag.value;
           var st_pre_gr_flag			= document.forms.contentForm2.st_pre_gr_flag.value;
           var st_maker_part_no			= document.forms.contentForm2.st_maker_part_no.value;

           if(document.forms.contentForm2.InCheck.checked == true){
               query =	st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
               			st_origin_code + "@@" + st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" + st_category_code + "@@" + st_msds_flag + "@@" + st_pre_gr_flag + "@@" + st_maker_part_no + "&&";
           }
       }else{
           for(var j = 0; j < tot_cnt; j++){
               var box							= eval("document.forms.contentForm2.InCheck[" + j + "]");
               var st_quotation_no			= document.forms.contentForm2.st_quotation_no[j].value;
               var st_quotation_seq			= document.forms.contentForm2.st_quotation_seq[j].value;
               var st_revision					= document.forms.contentForm2.st_revision[j].value;

               var st_buyer_item_no		= document.forms.contentForm2.st_buyer_item_no[j].value;
               var st_description				= document.forms.contentForm2.st_description[j].value;
               var st_specification			= document.forms.contentForm2.st_specification[j].value;
               var st_unit_measure			= document.forms.contentForm2.st_unit_measure[j].value;
               var st_maker_name			= document.forms.contentForm2.st_maker_name[j].value;
               var st_origin_code			= document.forms.contentForm2.st_origin_code[j].value;
               var st_btoa_end_date		= document.forms.contentForm2.st_btoa_end_date[j].value.replaceAll('/','');
               var st_buyer_target_price	= document.forms.contentForm2.st_buyer_target_price[j].value;
               var st_item_qty				= document.forms.contentForm2.st_item_qty[j].value;
               var st_agent_name			= document.forms.contentForm2.st_agent_name[j].value;
               var st_btoa_remark			= document.forms.contentForm2.st_btoa_remark[j].value;
               var st_image_key				= document.forms.contentForm2.st_image_key[j].value;
               var st_req_price_type		= document.forms.contentForm2.st_req_price_type[j].value;
               var st_category_code			= document.forms.contentForm2.st_category_code[j].value;
               var st_msds_flag			= document.forms.contentForm2.st_msds_flag[j].value;
               var st_pre_gr_flag			= document.forms.contentForm2.st_pre_gr_flag[j].value;
               var st_maker_part_no			= document.forms.contentForm2.st_maker_part_no[j].value;
               
               if(box.checked == true){
                   query += st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
                   		st_origin_code + "@@" + st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" +
                   		st_category_code + "@@" + st_msds_flag + "@@" + st_pre_gr_flag + "@@" + st_maker_part_no + "&&";
               }
           }
       }
       document.forms.updateForm2.st_update.value = query;
       document.forms.updateForm2.st_btoa_user_mail.value = document.forms.searchForm.st_btoa_user_mail.value;
       document.forms.updateForm2.st_btoa_user_fax.value = document.forms.searchForm.st_btoa_user_fax.value;
       document.forms.updateForm2.st_btoa_user_tel.value = document.forms.searchForm.st_btoa_user_tel.value;

   	kepAjaxFormCall("/mprq/saveBuyerMpRqTempSaveList_v2.do","updateForm2", btnEvent);
}
// 삭제
function setDelete(){
    var tot_cnt =  $("#display_item_cnt").val();
    var checked_count = 0;
    var query = "";
    if(eval(tot_cnt) == 0){
    	//조회한 데이타가 없습니다.
    	var text = "<%=CommonLang.msg("MSG69")%>"; 
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }

    if(tot_cnt==1){
        if(document.forms.contentForm2.InCheck.checked==true) checked_count = 1;
    }else{
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm2.InCheck[j].checked==true) {
            	checked_count++;
            }
        }
    }
    
    if(checked_count == "0"){
    	//삭제할 품목을 선택하여 주십시요.
    	var text = "<%=CommonLang.msg("MSG70")%>"; 
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }
    
   	//선택된 내용을 삭제하시겠습니까?
    var text = "<%=CommonLang.msg("MSG71")%>"; // 삭제하시겠습니까?
	var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
	var but2textC ="<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but1funcC = "javascript:executeDeleteRows2(); return false"; 
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
}

function executeDeleteRows2(){
	closePopText1();
    var query = "";
    var tot_cnt =  $("#display_item_cnt").val();
    
	if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm2.InCheck[0]");
        var st_quotation_no = document.forms.contentForm2.st_quotation_no.value;
        var st_quotation_seq = document.forms.contentForm2.st_quotation_seq.value;
        var st_revision = document.forms.contentForm2.st_revision.value;

        if(document.forms.contentForm2.InCheck.checked == true){
            query = st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "&&";
        }
    }else{
        for(var j = 0; j < tot_cnt; j++){
            var box = eval("document.forms.contentForm2.InCheck[" + j + "]");
            var st_quotation_no = document.forms.contentForm2.st_quotation_no[j].value;
            var st_quotation_seq = document.forms.contentForm2.st_quotation_seq[j].value;
            var st_revision = document.forms.contentForm2.st_revision[j].value;

            if(box.checked == true){
                query += st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "&&";
            }
        }
    }            
    
    document.forms.updateForm2.st_update.value = query;
    
	kepAjaxFormCall("/mprq/delBuyerMpRqTempSaveList.do","updateForm2", btnEvent);	
}

/****** 임시저장 화면 함수 종료 ******/
 
//기능함수
function doAction(str) {
	btnEvent = str;
	st = new Date();
	switch (str) {
		case "reg":  //견적요청
			temp_yn = "N";
			checkForm();
			break;
		case "add": // 행추가
			addRow();
			break;
		case "del": // 행삭제
			checkedDel();
			break;
		case "save": // 임시저장
			temp_yn = "Y";
			checkForm();
			break;
		case "copy": // 행복사
			checkedCopy();
			break;
		case "reg2":  //임시저장 - 견적요청버튼
			setRequest();
			break;
		case "save2": // 임시저장 - 임시저장버튼
			setSave();
			break;
		case "del2": // 삭제
			setDelete();
			break;
	}
}


/**
 * FORM 을 초기화
 */
function reload(){
	$('#searchForm').attr("action", "/mprq/showBuyerMpRqRequestQuotation_v2.do").submit();   
}

//전체선택/해제
function checkAll(idx, masterCheckbox) {
    // 1. 테이블 내에서 name이 "InCheck"인 모든 체크박스를 가져옵니다.
    const table = document.getElementById('tblshow'+idx);
    const checkboxes = table.querySelectorAll('input[name="InCheck"]');

    // 2. 헤더 체크박스의 상태에 따라 모든 체크박스의 상태를 변경합니다.
    checkboxes.forEach(function(checkbox) {
        checkbox.checked = masterCheckbox.checked;
    });
}
function executeReg1(type){ // 전자결재
	closePopText3();
	// 결재 연결
	if(type=='1'){
		btnEvent = "passReq";
		kepAjaxFormCall("/mprq/savePassReq_v2.do","processForm",btnEvent); 
	}else{
		btnEvent = "passReq2";
		kepAjaxFormCall("/mprq/savePassReq_v2.do","processForm2",btnEvent); 
	}
}
function executeReg2(type){ // 견적요청
	closePopText3();
	// 바로생성
	if(type=='1'){
		btnEvent = "noPassReq";
		kepAjaxFormCall("/mprq/saveNoPassReq_v2.do","processForm",btnEvent);
	}else{
		btnEvent = "noPassReq2";
		kepAjaxFormCall("/mprq/saveNoPassReq_v2.do","processForm2",btnEvent);
	}
} 
function btn3Layer(type){
	//견적요청 방식에 따라 전자결재 진행 여부를 선택해주세요. 
	var text = "<%=CommonLang.msg("MSG738")%>";
	var content = "<%=CommonLang.msg("MSG737")%>";
	var but1textC = "<%=CommonLang.get("HTITLE229")%>";	// 취소
	var but2textC = "<%=CommonLang.get("HTITLE1201")%>"; //  전자결재
	var but3textC = "<%=CommonLang.get("HTITLE1010")%>"; // 견적요청
	var but1funcC = "javascript:closePopText3(); return false;";
	var but2funcC = "javascript:executeReg1("+type+"); return false";
	var but3funcC = "javascript:executeReg2("+type+"); return false";
	var but1widthC = "120px";
	var but2widthC = "150px";
	var but3widthC = "150px";
	openLayerPopText3(text,content, but1textC, but2textC,but3textC, but1funcC, but2funcC,but3funcC, but1widthC, but2widthC, but3widthC);
}
var but1func = "javascript:closePopText2(); return false;";
var but1func2 = "javascript:closePopText2(); kepSearch('1'); return false;";
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if (pMethod == "reg"){
		var passFlag = response.msg.passflag;
		
		if (passFlag == "Y"){
// 			var type = "NG"; // 견적의뢰
<%-- 			var buyer = "<%=buyer%>"; --%>
// 			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");

			//전자결재 완료 후 견적을 요청합니다.<br/>결재를 진행하시겠습니까? 
			var text = "<%=CommonLang.msg("MSG740")%>"; 
			var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
			var but2textC ="<%=CommonLang.get("HTITLE229")%>";	// 취소
			var but1funcC = "javascript:kepSearch('1'); doPop('approval','"+response.msg.usrmsg+"'); return false"; 
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
			
		} else if (passFlag == "C"){
			btn3Layer('1');			
		} else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				//견적번호 + 정상적으로 처리 되었습니다.
				var text = msg + " " +"<%=CommonLang.msg("MSG507")%>"; 
				openLayerPopText2(text,but1text,but1func2,but1width);
		        return;
			}
			reload();
		}
	} else if (pMethod == "noPassReq"){
		var msg = response.msg.msg;   
		if (msg != ""){
			//견적번호 + 정상적으로 처리 되었습니다.
			var text = msg + " " +"<%=CommonLang.msg("MSG507")%>"; 
			openLayerPopText2(text,but1text,but1func2,but1width);
	        return;
		}
		reload();
	} else if (pMethod == "passReq"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=buyer%>";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer+'&nu_tot_price='+product_amt+'&nu_tot_cnt='+product_cnt, "800,860,no");
	} else if(pMethod == "save"){
		//정상적으로 임시저장되었습니다.
		var text = "<%=CommonLang.msg("MSG59")%>"; 
		openLayerPopText2(text,but1text,but1func2,but1width);
        return;
	} else if (pMethod == "reg2"){
		var passFlag = response.msg.passflag;
		
		if (passFlag == "Y"){
			//전자결재 완료 후 견적을 요청합니다.<br/>결재를 진행하시겠습니까? 
			var text = "<%=CommonLang.msg("MSG740")%>"; 
			var but1textC = "<%=CommonLang.get("HTITLE516")%>";	//확인
			var but2textC ="<%=CommonLang.get("HTITLE229")%>";	// 취소
			var but1funcC = "javascript:kepSearch('1');doPop('approval','"+response.msg.usrmsg+"'); return false"; 
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
		}else if (passFlag == "C"){
			btn3Layer('2');			
		}else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				//견적번호 생성 되었습니다.
				var text = msg +"<%=CommonLang.msg("MSG507")%>"; 
				openLayerPopText2(text,but1text,but1func2,but1width);
		        return;
			}
			kepSearch($("#curPage").val());
		}
	}else if (pMethod == "noPassReq2"){
		var msg = response.msg.msg;   
		if (msg != ""){
			var curpage=$("#curPage").val();
			//견적번호 + 정상적으로 생성되었습니다.
			var text = msg + " " +"<%=CommonLang.msg("MSG507")%>"; 
			openLayerPopText2(text,but1text,but1func2,but1width);
	        return;
		}
	}else if (pMethod == "passReq2"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=buyer%>";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer+'&nu_tot_price='+product_amt+'&nu_tot_cnt='+product_cnt, "800,860,no");
	}else if(pMethod == "del2"){
		//정상적으로 삭제되었습니다.
		var text = "<%=CommonLang.msg("MSG75")%>"; 
		openLayerPopText2(text,but1text,but1func2,but1width);
        return;
    }else if(pMethod == "delRow2"){
		//정상적으로 삭제되었습니다.
		var text = "<%=CommonLang.msg("MSG75")%>"; 
		openLayerPopText2(text,but1text,but1func2,but1width);
        return;
    }else if(pMethod == "save2"){
    	var passFlag = response.msg.passflag;
    	var msg = response.msg.msg;
    	var usrmsg = response.msg.usrmsg;
    	//정상적으로 저장되었습니다.
   		var text = "<%=CommonLang.msg("MSG76")%>"; 
		openLayerPopText2(text,but1text,but1func2,but1width);
 	  	return;
    }
};
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.
	var text = "<%=CommonLang.msg("MSG60")%>"; 
	openLayerPopText2(text,but1text,but1func,but1width);
    return;
} 
function kepApprovalReturn(flag,docu_no){
	reload();
}

let targetRowSeq = "";
let targetRow = null;
let page ="";
//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	switch (str) {
		case "excelUpload": 
			openSearchPopup('/mprq/showBuyerMpRqExcelUploadPop_v2.do','','1280,800,no');
			break;
		case "buyerMpRqCatalogRegYnPop": // 기존품목확인
			openSearchPopup("/mprq/showBuyerMpRqCatalogRegYnPop_v2.do?set=Y", "", "750,780,no"); 
			break;
		case "country": // 원산지
			var container = value1.closest('.SearchInput').parentElement;
		    var nameInput = container.querySelector('input[name="st_origin_name"]');
			
		    if (nameInput){
		    	if(nameInput.id.includes('__')) {
		        	targetRowSeq = nameInput.id.split('__')[1];
		        	page="1";
		    	}else{
		    		targetRowSeq = value2;
		    		page="2";
		    	}
		    }
			openSearchPopup("/common/countryCodePop_v2.do", "", "500,515,no"); 
			break;
		case "category": // 카테고리
			var buyer = "<%=buyer%>";
			var user_id = "<%=user_id%>";
			
			var container = value1.closest('.SearchInput').parentElement;
		    var nameInput = container.querySelector('input[name="st_category_name"]');
			
		    if (nameInput && nameInput.id.includes('__')) {
		        targetRowSeq = nameInput.id.split('__')[1]; 
		       	page="1";
		    }else{
	    		targetRowSeq = value2;
	    		page="2";
	    	}
		    var bqt00003 = "<%=bqt00003%>";
		    if (bqt00003 == "true"){
				openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop_v2.do",'?st_buyer='+buyer,"520,725,no");			
			} else {				
				openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop_v2.do",'?st_buyer='+buyer+'&st_user_id='+user_id,"800,750,no");			
			}				
			break;
		case "attach":
			var outerTable = value1.closest('table.PDEstimate'); // tblshow1 또는 tblshow2
		    var tr = findOuterRow(value1, outerTable);
		    targetRow = tr;
			
			var container = value1.closest('.FileOutline, .FileOutline_on').parentElement;
		    var nameInput = container.querySelector('input[name="st_image_key"]');
			
		    if (nameInput && nameInput.id.includes('__')) {
		        targetRowSeq = nameInput.id.split('__')[1];
		        page="1";
		    }else{
		    	targetRowSeq = value2;
	    		page="2";
		    }
			var image_key = nameInput.value;

			popupSel = "setImageKey";
			var src = '/common/fileUploadPop_v2.do?DOC_NO='+image_key+'&viewType=VI&TYPE=RFQ&bulkYn=Y';
			openLayerPop(src,"600px","510px");
	// 		openSearchPopup('/common/fileUploadPop_v2.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
			break;
		case "approval":
			var type = "NG"; // 견적의뢰
			var buyer = "<%=buyer%>";
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+value1+'&PARAM1='+buyer+'&nu_tot_price='+product_amt+'&nu_tot_cnt='+product_cnt, "800,860,no");
			break;
	}
}

function setPopupReturn(code, text, value){
	if (popupSel == "buyerMpRqCatalogRegYnPop"){ //기존품목확인
		addRow2(code);
	}
	if (targetRowSeq === "") return;
	if (popupSel == "country") { // 원산지
		if(page=="1"){
			$("#st_origin_code__" + targetRowSeq).val(code);
			$("#st_origin_name__" + targetRowSeq).val(value);
			$("#InCheck__" + targetRowSeq).prop('checked', true);
		}else{
			$("#st_origin_code" + targetRowSeq).val(code);
			$("#st_origin_name" + targetRowSeq).val(value);
			$("#InCheck" + targetRowSeq).prop('checked', true);
		}
		
	}else if (popupSel == "category") { // 카테고리
		if(page=="1"){
			$("#st_category_code__" + targetRowSeq).val(code);
			$("#st_category_name__" + targetRowSeq).val(text);
			$("#InCheck" + targetRowSeq).prop('checked', true);
		}else{
			$("#st_category_code" + targetRowSeq).val(code);
			$("#st_category_name" + targetRowSeq).val(text);
			$("#InCheck" + targetRowSeq).prop('checked', true);
		}
	}else if (popupSel == "setImageKey") {	//파일 첨부
		if (!targetRow) return;

		//파일 첨부한 곳 체크(파일 첨부 되었을 때만)
		if (text > 0) {
	    	var targetCheckbox = targetRow.querySelector('input[name="InCheck"]');
	   		if (targetCheckbox) targetCheckbox.checked = true;
		}

	    //체크된 모든 행에 일괄 적용
	    var table = targetRow.closest('table');
	    var checkedBoxes = table.querySelectorAll('input[name="InCheck"]:checked');

	    checkedBoxes.forEach(function(checkbox) {
	        var tr = checkbox.closest('tr');
	        var imgKeyInput = tr.querySelector('input[name="st_image_key"]');
	        var btn = tr.querySelector('button[id^="attachBtn"]');
	        if (!imgKeyInput || !btn) return;

	        imgKeyInput.value = code;

	        if (text > 0) {
	            btn.classList.remove('FileOutline');
	            btn.classList.add('FileOutline_on');
	            btn.innerText = '<%=CommonLang.get("HTITLE1202")%>' + text + '<%=CommonLang.get("HTITLE1203")%>';
	        } else {
	            btn.classList.remove('FileOutline_on');
	            btn.classList.add('FileOutline');
	            btn.innerText = '<%=CommonLang.get("HTITLE440")%>';
	        }
	    });

	    targetRow = null;
	}
    targetRowSeq = "";
}
function getWorkingDay() {	
	var date = new Date();	
	if(date.getDay() == 3 || date.getDay() == 4 || date.getDay() == 5) { // 수목금
		date.setDate(date.getDate() + 5);
	}
	else if(date.getDay() == 6) { // 토
		date.setDate(date.getDate() + 4);
	} else { // 일월화
		date.setDate(date.getDate() + 3);
	}
	
	var year = date.getFullYear();
	var month = date.getMonth();
	month += 1;
	if(month <= 9) {
		month = "0" + month;
	}
	
	var day = date.getDate();
	if(day <= 9) {
		day = "0" + day;
	}
	
	var result = year + '/'+ month + '/'+ day;
	return result;
}
function catalogSetCheck(input){
	var index = input.id.split('__')[1];
	if($("#catalogSet__"+index).val() == "Y"){
		//상품정보 수정 시 신규품목으로 견적요청됩니다. 진행하시겠습니까?
		var text = "<%=CommonLang.msg("MSG909")%>";
		//확인
		var but1textC = "<%=CommonLang.get("HTITLE516")%>";
		// 취소
		var but2textC ="<%=CommonLang.get("HTITLE229")%>";
		var but1funcC = "javascript:catalogContinue('"+index+"'); return false;"; 
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text, but1textC, but2textC, but1funcC, but2funcC, but1widthC, but2widthC);
		return;
	}
}
function catalogContinue(index){
	closePopText1();
	$("#st_buyer_item_no__"+index).val("");
	$("#catalogSet__"+index).val("N");
}

document.addEventListener('change', function(e) {
    var target = e.target;
    if (target.type === 'radio' && /__\d+$/.test(target.name)) {
        if (target.checked) {
            var baseName = target.name.split('__')[0];
            var seq = target.name.split('__')[1];

            var hiddenId = baseName + '_text__' + seq;
            var hidden = document.getElementById(hiddenId);
            if (hidden) hidden.value = target.value;
        }
    }
});

function validNumCheck(input){
	const value = input.value;
	// 숫자가 아닌 문자 포함 여부 체크
	if (!/^\d*$/.test(value)) {
	  input.value = '';
// 	  alert('숫자만 입력 가능합니다.');
	  var text = "<%=CommonLang.msg("MSG951")%>";
	  openLayerPopText2(text,but1text,but1func,but1width);
	  return;
	}
	if (/^0/.test(value)) {
	    input.value = '';
// 	    alert('0으로 시작할 수 없습니다.');
	    var text = "<%=CommonLang.msg("MSG952")%>";
		  openLayerPopText2(text,but1text,but1func,but1width);
	    return;
	  }
	
	// 값이 있고 1 미만인 경우 체크
	if (value !== '' && Number(value) < 1) {
	  input.value = '';
// 	  alert('1 이상의 숫자를 입력해주세요.');
	  var text = "<%=CommonLang.msg("MSG953")%>";
	  openLayerPopText2(text,but1text,but1func,but1width);
	}
}
</script>
</html>
