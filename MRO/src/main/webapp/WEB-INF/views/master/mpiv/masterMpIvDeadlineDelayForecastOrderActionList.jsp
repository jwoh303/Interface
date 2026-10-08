<%--
**********************************************
* 메뉴 : 납품관리>납기지연예상발주 조치
* 화면 : 납기지연예상발주 조치
* 기능 : 
* 프로그램 ID : PG_07_M_008_00
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
	String ivDelayGubun	= CommonUtil.nvl((String)request.getParameter("st_iv_delay_gubun"),"IV_EXPECT_DELAY");
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_PR_NO"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"주문번호",	SaveName:"REF_NO"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"SCM비고",	SaveName:"SCM_REMARK"}
		,{ Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"비고",		SaveName:"PO_REMARK"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",	Header:"단위",		SaveName:"UNIT_MEASURE"}
		,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",		Header:"발주수량",	SaveName:"ITEM_QTY"}
		,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",		Header:"단가",		SaveName:"UNIT_PRICE"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납기요청일",SaveName:"RD_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_DATE"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
		,{ Align:"Left",	Width:130,	Edit:false,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"REQ_DEPT_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주자",	SaveName:"PURCHASER_NAME"}
		
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납품예정일",SaveName:"DS_DATE"}
		
		,{ Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Int",		Header:"납품횟수",SaveName:"RD_CNT", Image:"/resources/images/but_icon01.gif"}
		
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Date",	Header:"납품합의일",SaveName:"APPROVAL_RD_DATE"} // 최근합의일 
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"최근합의내역",	SaveName:"REASON_CODE_REMARK"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"최근합의사유",	SaveName:"REASON_REMARK"}
		
		,{ Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"합의이력", SaveName:"APPROVAL_HISTORY", Image:"/resources/images/but_icon01.gif"}
		
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"BUYER",				SaveName:"BUYER"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"PO_SEQ",			SaveName:"PO_SEQ"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"AGENT",				SaveName:"AGENT"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"REQ_USER_ID",		SaveName:"REQ_USER_ID"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"PURCHASER_ID",		SaveName:"PURCHASER_ID"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",	SaveName:"BYIT_COMORG_CODE"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",		SaveName:"CONTRACT_NO"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
		
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"SELLER",			SaveName:"SELLER"}
		,{ Align:"Left",	Hidden:true,	Type:"Text",	Header:"ADD_USER_ID",		SaveName:"ADD_USER_ID"}
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	
	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_user_dept_cd','getKepDeptList','SEL','${sessionInfo.department}');
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NAME");		// 고객사
	setLinkCol(mySheet, "PO_NO");			// 발주번호
	setLinkCol(mySheet, "BUYER_ITEM_NO");	// 품목코드
	setLinkCol(mySheet, "SCM_REMARK");		// SCM비고
	setLinkCol(mySheet, "RD_CNT");			// 납품횟수
	setLinkCol(mySheet, "APPROVAL_HISTORY");// 합의이력
	setLinkCol(mySheet, "AGENT_NAME");		// 협력사
	setLinkCol(mySheet, "REQ_USER_NAME");	// 요청자
	setLinkCol(mySheet, "PURCHASER_NAME");	// 발주자

//	$("#st_buyer_name").val("두산인프라코어(주)");
//	$("#st_buyer_code").val("KRDHIM0001");
	
	var searchYn = "<%=searchYn%>";
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	$("#st_iv_delay_gubun").val("<%=ivDelayGubun%>");
	
	if(searchYn == "Y"){
		doAction("search");
	}
}
	
// 기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
		
			if(!validCheck('true')){
				return;
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvDeadlineDelayForecastOrderActionList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_user_dept_cd").val("${sessionInfo.department}");
			$("#st_buyer_code").val('');
			$("#st_agent_code").val('');
			break;
	}

}

function validCheck() {

	var user_dept_cd = $("#st_user_dept_cd").val();
	var buyer_code   = $("#st_buyer_code").val();
	
	if(user_dept_cd == "") {
		alert("담당부서를 선택해 주십시요.");
		return false;
	}
	
	if(buyer_code == "") {
		alert("고객사를 선택해 주십시요.");
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
   	
	if (msg != "") {
		alert(msg);
	}
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "delayBuyer": // 지연고객사 팝업
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no')
			popupSel = "delayBuyer";
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
		
	} else if (column == 'PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
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
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		
		openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "520,500,no");
		
	} else if (column == 'AGENT_NAME') { // 협력사
		var ID = mySheet.GetCellValue(Row,"AGENT");
		getAgentDisplayPop(ID);
		
	} else if (column == 'REQ_USER_NAME') { // 요청자

		var REQ_USER_ID = mySheet.GetCellValue(Row,"REQ_USER_ID");
		openSearchPopup("/common/userDisplayPop.do", "?user_id="+REQ_USER_ID, "800,500,no");
	
	} else if (column == 'PURCHASER_NAME') { // 발주자

		var PURCHASER_ID = mySheet.GetCellValue(Row,"PURCHASER_ID");
		openSearchPopup("/common/userDisplayPop.do", "?user_id="+PURCHASER_ID, "800,500,no");
		
	} else if (column == 'RD_CNT') { // 납품횟수
//		console.log("column RD_CNT click ==>> " + column);
		
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		
		var RD_DATE = mySheet.GetCellValue(Row,"RD_DATE");
		var ITEM_QTY = mySheet.GetCellValue(Row,"ITEM_QTY");
		
		var SELLER = mySheet.GetCellValue(Row,"SELLER");
		var ADD_USER_ID = mySheet.GetCellValue(Row,"ADD_USER_ID");
		
		openSearchPopup("/mpiv/getMasterMpIvMultiDeliveryPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ+"&st_rd_date="+RD_DATE+"&st_item_qty="+ITEM_QTY+"&st_seller="+SELLER+"&st_add_user_id="+ADD_USER_ID, "550,600,no");
		
	} else if (column == 'APPROVAL_HISTORY') { // 합의이력
//		console.log("column APPROVAL_HISTORY click ==>> " + column);
	
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		var BUYER_NAME = mySheet.GetCellValue(Row,"BUYER_NAME");
		var RD_DATE = mySheet.GetCellValue(Row,"RD_DATE");
		
		openSearchPopup("/mpiv/getCommonMpIvAgrmntDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ+"&st_buyer_name="+BUYER_NAME+"&st_rd_date="+RD_DATE, "920,610,no");
		
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "delayBuyer") {	// 지연고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
		//$("#st_buyer_name").val(value2);
		
	} else if (popupSel == "seller") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);	
	}

	grbRow="";	//초기화
}

function gubunChange(){
	
	var gubunVal = $("#st_iv_delay_gubun").val();
	
	if(gubunVal == "IV_EXPECT_DELAY"){
		$("#ivExpectDelay").show();
		$("#ivDelay").hide();
		$("#ivLongExpectDelay").hide();
		$("#ivBadDelay").hide();
		$("#ivDsDelay").hide();
		
	} else if(gubunVal == "IV_DELAY"){
		$("#ivExpectDelay").hide();
		$("#ivDelay").show();
		$("#ivLongExpectDelay").hide();
		$("#ivBadDelay").hide();
		$("#ivDsDelay").hide();
		
	} else if(gubunVal == "IV_LONG_EXPECT_DELAY"){
		$("#ivExpectDelay").hide();
		$("#ivDelay").hide();
		$("#ivLongExpectDelay").show();
		$("#ivBadDelay").hide();
		$("#ivDsDelay").hide();
		
	} else if(gubunVal == "IV_BAD_DELAY"){
		$("#ivExpectDelay").hide();
		$("#ivDelay").hide();
		$("#ivLongExpectDelay").hide();
		$("#ivBadDelay").show();
		$("#ivDsDelay").hide();
		
	} else if(gubunVal == "DS_DELAY"){
		$("#ivExpectDelay").hide();
		$("#ivDelay").hide();
		$("#ivLongExpectDelay").hide();
		$("#ivBadDelay").hide();
		$("#ivDsDelay").show();
	}
}


	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>납기지연예상발주 조치</h3>
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
					<caption>납기지연예상발주 조치</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
					</colgroup>
							
					<tbody>
						<tr>
							<th>조회기준</th>
							<td colspan="5">
								<span class="fl">
									<select id="st_iv_delay_gubun" name="st_iv_delay_gubun" style="width:100px;" onClick="javascript:gubunChange();">
										<option value="IV_EXPECT_DELAY" selected="selected">납기지연예상</option>
										<option value="IV_DELAY">납기지연</option>
										<option value="IV_LONG_EXPECT_DELAY">장기지연</option>
										<option value="IV_BAD_DELAY">악성지연</option>
										<option value="DS_DELAY">납품예정일지연</option>
									</select>
								</span>
								<span>
									<div id="ivExpectDelay" style="display:block;">&nbsp;&nbsp;&nbsp;고객사 납품요청일이 아직 도래 하지 않은 발주건 중 "납품요청일" 대비, 공급사의 "납품예정일"이 늦는건에 대하여 사전 납기지연관리</div>
									<div id="ivDelay" style="display:none;">&nbsp;&nbsp;&nbsp;고객사의 "납품요청일" 대비, "납품확정일자" or "입고일자"가 1일이상 7일미만 기간동안 확정되지 않은 지연건 관리(PA)</div>
									<div id="ivLongExpectDelay" style="display:none;">&nbsp;&nbsp;&nbsp;고객사의 "납품요청일" 대비, "납품확정일자" or "입고일자"가 7일이상 30일미만 기간동안 확정되지 않은 장기지연건 관리(PM)</div>
									<div id="ivBadDelay" style="display:none;">&nbsp;&nbsp;&nbsp;고객사의 "납품요청일" 대비, "납품확정일자" or "입고일자"가 30일이상 확정되지 않은 장기 악성 지연건(사업담당자)</div>
									<div id="ivDsDelay" style="display:none;">&nbsp;&nbsp;&nbsp;고객사의 "납품요청일" 대비, 협력사의 "납품예정일"이 빠른 것 중에 "납품확정일자" or "입고일자"가 들록되지 않은 건 관리</div>
								</span>
							</td>
						</tr>
						<tr>
							<th><font color="red"><b>*</b></font>담당부서</th>
							<td>
								<select name="st_user_dept_cd" id="st_user_dept_cd"></select>
							</td>
							<th><font color="red"><b>*</b></font>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%;" value = "" READONLY>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
								<a href="javascript:doPop('delayBuyer');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:70%;" value ="" READONLY>
							<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:100px;" value ="">
								<a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr>
							<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:90%;" value ="" onKeyDown="kepEnter()">
							</td>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value =""  onKeyDown="kepEnter()">
							</td>
							<th>담당자확인</th>
							<td>
								<input type="radio" class="Noborder" name="st_kep_confirm" value="" border="0" checked>전체&nbsp;
								<input type="radio" class="Noborder" name="st_kep_confirm" value="Y" border="0">예&nbsp;
								<input type="radio" class="Noborder" name="st_kep_confirm" value="N" border="0">아니요
							</td>
						</tr>
					</tbody>
				</table>
			</div>
<!-- 
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
				</select>
			</span>
			<br>
			 -->
		</form>
					
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
  			
<!--내용 종료-->

</body>
</html>
