<%--
**********************************************
* 메뉴 : 도안관리>도안관리>작물보호
* 화면 : 작물보호
* 기능 : 관리되는 작물보호 도안목록을 조회한다.
* 프로그램 ID : PG_07_A_013_00
* 담당자 : 개발2 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
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
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";

	// 최초 화면 함수 
	function kep_onload_view() {
		var initsheet = {};
		initsheet.Cols = [ 
			 { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
			,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
			,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
			,{ Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}
			,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
			,{ Align:"Center",	Width:90,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목구분",	SaveName:"ITEM_MAKE_TYPE_NAME"}
			,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"진행상태",	SaveName:"RECV_FLAG_NAME"}
			,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"진행상태",	SaveName:"RECV_FLAG"}
			,{ Align:"Center",	Width:110,	Edit:false,	Hidden:false,	Type:"Text",	Header:"완료기한",	SaveName:"MK_TYPE_NAME"}
			,{ Align:"Center",	Width:130,	Edit:false,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
			,{ Align:"Center",	Width:130,	Edit:false,	Hidden:false,	Type:"Date",	Header:"처리예정일",	SaveName:"MK_DATE"}
			,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납기요청일",SaveName:"RD_DATE"}
			,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납품예정일",SaveName:"DS_DATE"}
			,{ Align:"Left",	Width:130,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사비고",	SaveName:"AGENT_REMARK"}
			,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Image",	Header:"첨부파일",	SaveName:"IMAGE_KEY_YN"}
			,{ Align:"Center",	Width:80,	Edit:false,	Hidden:true,	Type:"Text",	Header:"AGENT_IMAGE_KEY",	SaveName:"AGENT_IMAGE_KEY"}
			
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"BUYER",				SaveName:"BUYER"}
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"PO_SEQ",			SaveName:"PO_SEQ"}
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"AGENT",				SaveName:"AGENT"}
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"REQ_USER_ID",		SaveName:"REQ_USER_ID"}
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"PURCHASER_ID",		SaveName:"PURCHASER_ID"}
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",		SaveName:"CONTRACT_NO"}
			,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
		];
		
		initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:5};
		IBS_InitSheet(mySheet, initsheet,pagingMode);
		mySheet.SetCountPosition(4);
		
		setLinkCol(mySheet, "BUYER_NAME");		// 고객사
		setLinkCol(mySheet, "PO_NO");			// 발주번호
		setLinkCol(mySheet, "MK_TYPE_NAME");
		setLinkCol(mySheet, "RECV_FLAG_NAME");
		setLinkCol(mySheet, "MK_DATE");
		
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);
		
		kepSetCalender("st_from_date");
//		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("2","M"));
		$("#st_gr_flag").val("GR");
		$("#st_gr_flag_check").attr("checked", "checked");
//		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	}
	
	// 그리드 표시후 처리	 
	function mySheet_OnLoadData(DATA) {
		return DATA;
	}
		
	// 조회 후처리
	function mySheet_OnSearchEnd(code, msg, stCode) {
		loader_obj("N");
		if(!checkedSession(stCode)){return;}

		if (msg != "") {
			alert(msg);
		}
		if(!checkedSession(stCode)){return;}

		if(mySheet.RowCount() <= 0) return;
		
		var CheckDate = $('#CheckDate').val();
		for(var i = 1; i <= mySheet.RowCount(); i++){
			if(mySheet.GetCellValue(i,"RECV_FLAG") != "ED")
				mySheet.SetCellFontBold(i,"RECV_FLAG_NAME",1);
			if(mySheet.GetCellValue(i,"MK_DATE") == CheckDate)
				mySheet.SetCellFontColor(i, "MK_DATE", "#FF0000");
			if(mySheet.GetCellValue(i,"RD_DATE") == CheckDate)
				mySheet.SetCellFontColor(i, "RD_DATE", "#FF0000");
			if(mySheet.GetCellValue(i,"DS_DATE") == CheckDate)
				mySheet.SetCellFontColor(i, "DS_DATE", "#FF0000");
		}
	}
	
	// 그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		var column = mySheet.ColSaveName(mySheet.GetSelectCol());
		grbRow = Row;		//현재 Row를 전역변수에 셋팅

		if (column == 'BUYER_NAME') { // 고객사
			var ID = mySheet.GetCellValue(Row,"BUYER");
			getAgentDisplayPop(ID);
			
		} else if (column == 'PO_NO') { // 발주번호
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			openSearchPopup("/common/mpso/poDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO, "900,550,no");
			
		} else if (column == 'RECV_FLAG_NAME' || column == 'MK_DATE' || column == 'MK_TYPE_NAME') { // 발주번호
			var BUYER = mySheet.GetCellValue(Row,"BUYER");
			var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
			var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
			doPop('masterMpIvMkImScheduleRegDetailPop',BUYER, PO_NO, PO_SEQ,'0013112','20150126','13010005');
			
		} else if (column == 'IMAGE_KEY_YN') { // 발주번호
			doPop('attach', mySheet.GetCellValue(Row,"AGENT_IMAGE_KEY"));
		}
		return;
	}
	
	var st;
	//기능함수
	function doAction(str) {
		switch (str) {
		case "search": //조회
			if(!validCheck('true')){
				return;
			}
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvMkImScheduleRegList.do" , pagingMode );
			break;

		case "reload": //초기화
			kepReload("searchCondition");
			$("#st_buyer_name").val('');
			$("#st_buyer_code").val('');
			$("#st_agent_name").val('');
			$("#st_agent_code").val('');
			$("#st_po_no").val('');
			$("#st_buyer_item_no").val('');
			$("#st_from_date").val(kepToMonthAdd("2", "M"));
			$("#st_gr_flag").val("GR");
			$("#st_gr_flag_check").attr("checked", "checked");

			mySheet.RemoveAll();
			
			// 조회일 초기 셋팅
//			kepSetCalender("st_from_date");
//			kepSetCalender("st_to_date");
//			$("#st_from_date").val(kepToMonthAdd("2", "M"));
//			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD', '/'));
//			jspTableClean("table_list");
			break;

		case "excelDown": // 엑셀다운로드
			document.forms.searchCondition.action = "/mpds/excelSellerMpDscropProtectList.do";
			document.forms.searchCondition.submit();
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
	
	//validation 체크
	function validCheck() {
	 	var buyer_code      = $("#st_buyer_code").val();
		
		if(buyer_code == "") {
			alert("고객사를 선택해 주십시요.");
			return false;
		}
		return true;
	}

	// 팝업 함수호출
	function doPop(str, value1, value2, value3, value4, value5, value6) {
		switch (str) {
			case "catalogDetailPop": // 품목코드
				openSearchPopup('/common/catalogDetailPop.do', '?BUYER=' + value1
						+ '&BUYER_ITEM_NO=' + value2, '800,290,no');
				break;
			case "masterMpIvMkImScheduleRegDetailPop": // 포장지 도안 관리 등록 (작물보호)
				openSearchPopup('/mpiv/getMasterMpIvMkImScheduleRegDetailPop.do',
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
	// 			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "720,505,no");
				openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
				popupSel = "buyer";
				break;
				
			case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
				openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
				break;
			case "attach": // 발주번호 click시 발주정보 팝업
				popupSel = "fileUpload";
				gridIndex = value2;
				var type="PO";
				var viewType="R";
				openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
				break;
			case "buyerMulti": // 고객사 M
				popupSel = "buyerMulti";
				openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no')
				break;
			case "seller": // 협력사
				popupSel = "seller";
				openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
				break;
		}
	}
	
	function setBuyerChoiceReturn(buyer, com_name){
		$("#st_buyer_code").val(buyer);
		$("#st_buyer_name").val(com_name);
	}
	
	// 콜백함수(파일명은 모두 동일)
	function setPopupReturn(code, text) {
		if (popupSel == "buyerMulti") {	// 다중 고객사
			$("#st_buyer_code").val(code);
			$("#st_buyer_name").val(kepMultiName(text,"@"));
		} else if (popupSel == "buyer") {	// 구매회원사
			$("#st_buyer_code").val(code);
			$("#st_buyer_name").val(text);
		} else if (popupSel == "dept") {
			$("#st_btoa_user_dept_code").val(code);
			$("#st_btoa_user_dept_name").val(text);
		} else if (popupSel == "seller") {	// 협력회원사
			$("#st_agent_code").val(code);
			$("#st_agent_name").val(text);
		}
		grbRow="";	//초기화
			
	}

	// 선택된 그리드 값을 셋팅
	function setGridData(btnEvent) {
		var returnValue = true;
		var chkGridValue = {
			keys : [ "st_status" ],
			value0 : [ "합의완료", "장바구니" ],
			msg0 : [ "합의완료된 상품들만 장바구니에 담을수 있습니다." ]
		};

		var formArr = getFormToArr("document.forms.contentForm", true,
				chkGridValue);
		if (formArr != null && formArr != "") {
			document.forms.processForm.s_SAVENAME.value = formArr[0];
			$("#process").html(formArr[1]);
		} else {
			alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
			returnValue = false;
		}

		return returnValue;
	}
	
	//입고완료제외체크
	function setCheckBox(){
		if($("#st_gr_flag_check").is(":checked")){
			$("#st_gr_flag").val("GR");
		} else {
			$("#st_gr_flag").val("ALL");
		}
	}
	
	// ajax 공통 호출후 성공시 처리 함수
	function kepAjaxSuccess(pMethod, response) {
		var msg = response.Message;
		if (msg != "") {
			alert(msg);
		}
		kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvMkImScheduleRegList.do" , pagingMode );
	}
</script>

<body onload="kep_onload_view()">
	<div id="searchBtnA">
		<h3>제작품/수입품 일정 등록 및 조회</h3>
		<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
	</div>
	<c:set var="total_cnt" value='0' />
	<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1)%>' />
	<c:forEach items="${data}" var="_gridList" begin="1" end="1">
		<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
	</c:forEach>
	<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
	<c:set var="onepagerow" value='${onepagerow }' />
	<!--조회영역-->
	<form name="searchCondition" method="post">
		<div id="cont_searchA">
			<!--HIDDEN-->
			<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
			<input type="hidden" name="total_cnt" id="total_cnt" value='<c:out value="${total_cnt }" />' /> 
			<input type="hidden" name="curPage" id="curPage" value='<c:out value="${curPage }"/>' />
			<input type="hidden" name="onepagerow" id="onepagerow" value='<c:out value="${onepagerow }"/>' />
			<!-- HIDDEN -->
			<!-- 공통 -->
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" name="curPage" id="curPage" value='<c:out value="${curPage }"/>' />
			<!-- 화면 내 정의 -->
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

			<input type="hidden" id="CheckDate" value="${CheckDate }">
			<table  class="cont_t_list01" style="width:1024px;">
				<caption>발주접수지연목록</caption>
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
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width: 30%; text-align: center;" value=""> (시작일)
						</td>
						<td colspan="4">
							<input class="input_type_text" type="checkbox" id="st_gr_flag_check" name="st_gr_flag_check" value="" onChange="setCheckBox();">
							<input type="hidden"   id="st_gr_flag" name="st_gr_flag" value="" />
							<b><font color="#333333">입고완료제외</font></b>
						</td>
					</tr>
					<tr>
						<td><font color="red"><b>*</b></font>고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
							<a href="javascript:doPop('buyerMulti');">
<!-- 							<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"> -->
								<img src="/resources/images/btn_search03.gif" alt="검색" />
							</a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');">
								<img src="/resources/images/btn_eraser2.gif" alt="조건지우기">
							</a>
						</td>
						<td>협력사</td>
						<td>
	                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
	                        <input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
	                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                           </td>
						<td>발주번호</td>
						<td>
							<input type="text" name="st_po_no" id="st_po_no" value="" style="ime-mode: active; width: 87%" value="" onKeyDown="kepEnter()">
						</td>
					</tr>
					<tr>
						<td>진행상태</td>
						<td>
							<select name="st_recv_flag">
								<option value="">전체</option>
								<option value="BG">신규</option>
								<option value="IG">진행중</option>
								<option value="ED">완료</option>
							</select>
						</td>
						<td>품목타입</td>
						<td>
							<select name="st_item_make_type">
								<option value="">전체</option>
								<option value="MK">주문제작</option>
								<option value="IM">수입품</option>
							</select>
						</td>
						<td>품목코드</td>
						<td>
							<input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width: 87%" value="" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
	
	<!--grid-->
	<div class="ib_product" style="border-top:2px solid #3c639c;">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "354px");
		</script>
	</div>
</body>
</html>
