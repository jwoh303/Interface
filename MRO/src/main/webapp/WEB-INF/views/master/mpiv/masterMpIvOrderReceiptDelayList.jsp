<%--
**********************************************
* 메뉴 : 납품관리>발주접수지연목록
* 화면 : 발주접수지연목록
* 기능 : 
* 프로그램 ID : PG_07_M_007_00
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
	String gubun		= CommonUtil.nvl((String)request.getParameter("st_gubun"));
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
		,{ Align:"Right",	Width:80,	Edit:false,	Hidden:false,	Type:"Int",		Header:"경과일수",	SaveName:"OVER_DAY"}
		,{ Align:"Left",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
		,{ Align:"Left",	Width:130,	Edit:false,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"REQ_DEPT_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"REQ_USER_NAME"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주자",	SaveName:"PURCHASER_NAME"}
		
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
	setLinkCol(mySheet, "AGENT_NAME");		// 협력사
	setLinkCol(mySheet, "REQ_USER_NAME");	// 요청자
	setLinkCol(mySheet, "PURCHASER_NAME");	// 발주자
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	calChange();
	
//	$("#st_buyer_name").val("두산인프라코어(주)");
//	$("#st_buyer_code").val("KRDHIM0001");
	
	//$("#st_from_date").attr("disabled", true);
	//$("#st_to_date").attr("disabled", true);	
	
	var searchYn = "<%=searchYn%>";
	var gubun = "<%=gubun%>";
	
	if(gubun == "IV_LONG_DO_NO"){
		$("input[name='st_gubun']").eq(1).attr("checked", "checked");
	} else {
		$("input[name='st_gubun']").eq(0).attr("checked", "checked");
	}
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	
	if(searchYn == "Y"){
		doAction("search");
	}
}	

var st;
var mt;
// 기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			// 발주일 체크 시
			if($("#st_po_date_chk").is(":checked")){
				if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			}
			if(!validCheck('true')){
				return;
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvOrderReceiptDelayList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val('');
			$("#st_agent_code").val('');
			$("#st_user_dept_cd").val("${sessionInfo.department}");
			$("#st_po_date_chk").attr("checked", false);
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			mySheet.RemoveAll();
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
	}
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "delayBuyer") {	// 지연고객사
		$("#st_buyer_code").val(value1);
		//$("#st_buyer_name").val(value2);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	} else if (popupSel == "seller") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);	
	}

	grbRow="";	//초기화
}

function calChange(){
	if($("#st_po_date_chk").is(":checked")){
		$("#st_from_date").datepicker("option","disabled",false);
		$("#st_to_date").datepicker("option","disabled",false);
	} else {
		$("#st_from_date").datepicker("option","disabled",true);
		$("#st_to_date").datepicker("option","disabled",true);
	}
	return;
}

function gubunChange(){
	
	var gubunVal = $("input[name=st_gubun]:checked").val();
	
	if(gubunVal == "IV_DO_NO"){
		$("#ivDoNoMsg").show();
		$("#ivLongDoNoMsg").hide();
	} else {
		$("#ivDoNoMsg").hide();
		$("#ivLongDoNoMsg").show();
	}
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>발주접수지연목록</h3>
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
			
				<table  class="cont_t_list01" style="width:1024px;">
					<caption>발주접수지연목록</caption>
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
									<input type="radio" class="Noborder"  name="st_gubun" value="IV_DO_NO" onClick="javascript:gubunChange();" checked="checked" > 미접수</input>&nbsp;&nbsp;
									<input type="radio" class="Noborder"  name="st_gubun" value="IV_LONG_DO_NO" onClick="javascript:gubunChange();"> 장기미접수</input>
								</span>
								<span>
									<div id="ivDoNoMsg" style="display:block;">&nbsp;&nbsp;&nbsp;발주 후 1일 이상 7일 미만 경과 했는데 협력사에서 아직 수주접수 하지 않은 품목</div>
									<div id="ivLongDoNoMsg" style="display:none;">&nbsp;&nbsp;&nbsp;발주 후 7일 이상 경과 했는데 아직 수주접수 하지 않은 품목</div>
								</span>
							</td>
						</tr>
						<tr>
							<th><font color="red"><b>*</b></font>담당부서</th>
							<td>
								<select name = "st_user_dept_cd" id="st_user_dept_cd" class="TitSelect"></select>
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
							<th>
								<input type= "checkbox" class="Noborder"  id="st_po_date_chk" name="st_po_date_chk" value="Y" style="margin-top:4px;" onClick="javascript:calChange();"/>
								발주일
							</th>
							<td>
								
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:75px; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:75px; text-align:center;" >
								<!--
								&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								-->
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
		<div class="ib_product" style="border-top:2px solid #3c639c;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
<!--내용 종료-->	                 

</body>
</html>
