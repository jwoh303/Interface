<%--
**********************************************
* 메뉴 : 납품관리>납품실적 관리
* 화면 : 납품실적 관리
* 기능 : 
* 프로그램 ID : PG_07_M_012_00
* 담당자 : 개발3 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var statusImg0="/resources/images/rd_rdo_gro.gif";
var statusImg1="/resources/images/rd_rdo_grn.gif";
var statusImg2="/resources/images/rd_rdo_roo.gif";
var statusImg3="/resources/images/rd_rdn_gro.gif";
var statusImg4="/resources/images/rd_rdn_grn.gif";
var statusImg5="/resources/images/rd_rdn_roo.gif";
var statusImg6="/resources/images/rd_qtn_gro.gif";
var statusImg7="/resources/images/rd_qtn_grn.gif";
var statusImg8="/resources/images/rd_qtn_roo.gif";
var statusImg9="/resources/images/rd_inv_no.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		  { Align:"Center",	Width:50,	Edit:false,	Hidden:false,	Type:"Image",	Header:"상태",		SaveName:"STATUS_IMG"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
		, { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_PR_NO"}
		, { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"주문번호",	SaveName:"REF_NO"}
		, { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PD_PO_NO"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주항번",	SaveName:"PO_SEQ"}
		, { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		, { Align:"Left",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"SCM비고",	SaveName:"SCM_REMARK"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}
		, { Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"비고",		SaveName:"PO_REMARK"}
		, { Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",	Header:"단위",		SaveName:"UNIT_MEASURE"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"매입단가",	SaveName:"AGENT_PRICE"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"매출단가",	SaveName:"UNIT_PRICE"}
		, { Align:"Right",	Width:60,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"발주수량",	SaveName:"PD_ITEM_QTY"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_DATE"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납기요청일",SaveName:"RD_DATE"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납품합의일",SaveName:"APPROVAL_RD_DATE"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납품예정일",SaveName:"CD_DATE"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납품일",	SaveName:"INVOICE_DATE"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"배송확정일",SaveName:"DELIVERY_DATE"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"입고일",	SaveName:"GR_DATE"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"납품수량",	SaveName:"INV_QTY"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"확정수량",	SaveName:"DELIVERY_QTY"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"입고수량",	SaveName:"GR_ITEM_QTY"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Int",		Header:"매입금액",	SaveName:"AGENT_ITEM_AMT"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Int",		Header:"판매금액",	SaveName:"PD_ITEM_AMT"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Int",		Header:"납품금액",	SaveName:"DELIVERY_AMT"}
		, { Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Int",		Header:"입고금액",	SaveName:"GR_ITEM_AMT"}
		, { Align:"Center",	Width:120,	Edit:false,	Hidden:false,	Type:"Text",	Header:"납품실적",	SaveName:"DELIVERY_RESULT"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"입고상태",	SaveName:"GR_STATUS"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"송장번호",	SaveName:"INV_NO"}
		, { Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"송장항번",	SaveName:"INV_SEQ"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"계약서",	SaveName:"CONTRACT_NO"}
		, { Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"합의이력",	SaveName:"APPROVAL_HISTORY", Image:"/resources/images/but_icon01.gif"}
		
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"BUYER",				SaveName:"BUYER"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"AGENT",				SaveName:"AGENT"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
// 	mySheet.SetCountPosition(4);
	
	//비고이미지설정
	mySheet.SetImageList(0, statusImg0);
	mySheet.SetImageList(1, statusImg1);
	mySheet.SetImageList(2, statusImg2);
	mySheet.SetImageList(3, statusImg3);
	mySheet.SetImageList(4, statusImg4);
	mySheet.SetImageList(5, statusImg5);
	mySheet.SetImageList(6, statusImg6);
	mySheet.SetImageList(7, statusImg7);
	mySheet.SetImageList(8, statusImg8);
	mySheet.SetImageList(9, statusImg9);

	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");		// 고객사
	setLinkCol(mySheet, "PD_PO_NO");		// 발주번호
	setLinkCol(mySheet, "BUYER_ITEM_NO");	// 품목코드
	setLinkCol(mySheet, "SCM_REMARK");		// SCM비고
	setLinkCol(mySheet, "AGENT_NAME");		// 협력사
	setLinkCol(mySheet, "APPROVAL_HISTORY");// 합의이력
	setLinkCol(mySheet, "INV_NO");			// 송장번호
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	//$("#st_buyer_name").val("(주)빙그레 도농공장");
	//$("#st_buyer_code").val("KRBING0002");
	
	var searchYn = "<%=searchYn%>";
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	
	if(searchYn == "Y"){
		$("#st_from_date").val( kepToMonthAdd("12","M"));
		var st_from_date = $("#st_from_date").val();		
		st_from_date = st_from_date.substring(0,8);
		$("#st_from_date").val( st_from_date + "01");
		$("#st_check_sinv_qty").val("납품실적미입력");
		
		doAction("search");
	}
}

// 기능함수
function doAction(str) {

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if(!validCheck('true')){
				return;
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvDeliveryRecordManageList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			$("#st_buyer_code").val('');		
			$("#st_agent_code").val('');
			break;
	}
}

function validCheck() {
	
	var buyer_code      = $("#st_buyer_code").val();
	var agent_code      = $("#st_agent_code").val();
	
	if(buyer_code == "" && agent_code == "") {
		alert("고객사 또는 협력사를 선택해 주십시요.");
		return false;
	}
	
	return true;
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(mySheet.RowCount() <= 0) return;
	
	for(var i = 1; i <= mySheet.RowCount(); i++){
		
		var DELIVERY_RESULT = mySheet.GetCellValue(i,"DELIVERY_RESULT");
		var GR_STATUS = mySheet.GetCellValue(i,"GR_STATUS");
		
		if(DELIVERY_RESULT == "납품실적입력완료" && GR_STATUS == "입고완료"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 0);
		}else if(DELIVERY_RESULT == "납품실적입력완료" && GR_STATUS == "미입고"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 1);
		}else if(DELIVERY_RESULT == "납품실적입력완료" && GR_STATUS == "부분입고"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 2);
		}else if(DELIVERY_RESULT == "납품실적미입력" && GR_STATUS == "입고완료"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 3);
		}else if(DELIVERY_RESULT == "납품실적미입력" && GR_STATUS == "미입고"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 4);
		}else if(DELIVERY_RESULT == "납품실적미입력" && GR_STATUS == "부분입고"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 5);
		}else if(DELIVERY_RESULT == "납품실적수량불일치" && GR_STATUS == "입고완료"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 6);
		}else if(DELIVERY_RESULT == "납품실적수량불일치" && GR_STATUS == "미입고"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 7);
		}else if(DELIVERY_RESULT == "납품실적수량불일치" && GR_STATUS == "부분입고"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 8);
		}else if(DELIVERY_RESULT == "송장미생성" && GR_STATUS == "송장미생성"){ 
			mySheet.SetCellImage(i, "STATUS_IMG", 9);
		}
	}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvDeliveryRecordManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer";
			break;
		case "seller": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller";
			break;
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
		
	} else if (column == 'PD_PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PD_PO_NO");
		
		openSearchPopup("/common/mpso/poDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO, "900,550,no");
		
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var BUYER = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
		var BUYER_ITEM_NO = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var CONTRACT_NO = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var CONTRACT_SEQ = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		
		getBuyerCatalogDisplayPop(BUYER, BUYER_ITEM_NO, CONTRACT_NO, CONTRACT_SEQ);
		
	} else if (column == 'SCM_REMARK') { // SCM비고
		//http://130.100.101.21:7004/kr/sysop/proxbuy/scm/sysop_proxbuy_scm_scmremark.jsp?ds_seq=&po_no=PO14000001&po_seq=000002&buyer=KRILJI0001
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PD_PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		
		openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "520,500,no");
		
	} else if (column == 'AGENT_NAME') { // 협력사
		var ID = mySheet.GetCellValue(Row,"AGENT");
		getAgentDisplayPop(ID);
		
	} else if (column == 'APPROVAL_HISTORY') { // 합의이력
//		console.log("column APPROVAL_HISTORY click ==>> " + column);
	
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PD_PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		var BUYER_NAME = mySheet.GetCellValue(Row,"BUYER_NAME");
		var RD_DATE = mySheet.GetCellValue(Row,"RD_DATE");
		
		openSearchPopup("/mpiv/getCommonMpIvAgrmntDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ+"&st_buyer_name="+BUYER_NAME+"&st_rd_date="+RD_DATE, "920,610,no");
	
	} else if (column == 'INV_NO') { // 송장번호
		var INV_NO = mySheet.GetCellValue(Row,"INV_NO");
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		
		openSearchPopup("/common/mpiv/invoiceDisplayPop.do", '?INV_NO='+INV_NO+'&BUYER='+BUYER, "820,550,no");
		
	} else if (column == 'STATUS_IMG') { // 상태
		window.open("/resources/html/common/popup/mpiv/masterMpIvDeliveryStateLegend.html", "mpIvDeliveryStateLegend", "width=410,height=230,toolbar=no,location=no,resizable=yes,menubar=no,status=no,scrollbars=no,resizable=no");
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer") {	// 구매회원사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);	
	} else if (popupSel == "seller") {	// 협력회원사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}

	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>납품실적 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>납품실적 관리</caption>
					<colgroup>
							<col width="8%" />
							<col width="34%" />
							<col width="6%" />
							<col width="20%" />
							<col width="6%" />
							<col width="20%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>
								<select id="st_date_gubun" name="st_date_gubun" style="width:80%" class="TitSelect">
									<option value="add">발주일</option>
									<option value="gr">입고일</option>
								</select>
							</th>
							<td >
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:75px; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:75px; text-align:center;" >
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th><font color="red"><b>*</b></font>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
								<input type="hidden" name="st_agent_code" id="st_agent_code"  style="width:80%value ="">
								<a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:60%;" value ="" onKeyDown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:60%;" value =""  onKeyDown="kepEnter()">
							</td>
							<th>관리번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_ref_pr_no" id="st_ref_pr_no" style="width:60%;" value =""  onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>납품실적</th>
							<td>
								<select id="st_check_sinv_qty" name="st_check_sinv_qty" style="width:62%;">
									<option value="">---------전체--------</option>
									<option value="납품실적입력완료">납품실적입력완료</option>
									<option value="납품실적미입력">납품실적미입력</option>
									<option value="납품실적수량불일치">납품실적수량불일치</option>
									<option value="송장미생성">송장미생성</option>
								</select>
							</td>
							<th>입고유무</th>
							<td >
								<select name="st_check_gr_qty" style="width:62%">
									<option value="">---------전체--------</option>
									<option value="입고완료">입고완료</option>
									<option value="미입고">미입고</option>
									<option value="부분입고">부분입고</option>
									<option value="송장미생성">송장미생성</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            <table style="width:100%;">
				<tr>
					<td align="left">
		           		<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		               	<label for="b_no02" class="hidden">정렬개수선택</label>
							<select name="onepagerow" style="width: 70px;" >
							<option value="50" selected>50건</option>
							<option value="100">100건</option>
							<option value="500">500건</option>
						</select>
					</td>
				</tr>
			</table>
		</form>
					
		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
<!--내용 종료-->	                 

</body>
</html>
