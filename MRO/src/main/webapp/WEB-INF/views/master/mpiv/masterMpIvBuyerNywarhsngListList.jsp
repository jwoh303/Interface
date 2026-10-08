<%--
**********************************************
* 메뉴 : 납품관리>고객사 미입고 목록
* 화면 : 고객사 미입고 목록
* 기능 : 
* 프로그램 ID : PG_07_M_010_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-09-01
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
	String st_mainOpen	= CommonUtil.nvl((String)request.getParameter("st_mainOpen"));
%> 
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : true,	Type:"DummyCheck",	Header:"선택",	SaveName:"SELECTED"}
					,{ Align:"Left",	Width:125,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "STTS",	Header:"상태"}      
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "BUYER_NAME",	Header:"고객사명"}      
					,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "LEGACY_PO_NO",	Header:"I/F발주번호"}      
					,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "LEGACY_PO_SEQ",	Header:"I/F발주항번"}       
					,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "REF_PR_NO",	Header:"관리번호"}      
					,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "PO_NO",	Header:"발주번호"} 
					,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "PO_SEQ",	Header:"발주항번"}
					,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "BUYER_ITEM_NO",	Header:"품목코드"}
					,{ Align:"Center",	Width:85,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "SCM_REMARK",	Header:"SCM비고"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "DESCRIPTION",	Header:"품목명"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "SPECIFICATION",	Header:"규격"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "PO_REMARK",	Header:"비고"}
					,{ Align:"Center",	Width:40,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "UNIT_MEASURE",	Header:"단위"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", SaveName: "PO_CREATE_DATE",	Header:"발주일"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", SaveName: "RD_DATE",	Header:"납기요청일"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", SaveName: "HA_DATE",	Header:"납품합의일"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", SaveName: "PO_QTY",	Header:"발주수량"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", SaveName: "GI_GR_QTY",	Header:"기입고수량"}
					,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", SaveName: "UNIT_PRICE",	Header:"매출단가"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", SaveName: "AGENT_PRICE",	Header:"매입단가"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "AGENT_NAME",	Header:"협력사"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}", SaveName: "INV_QTY",	Header:"납품수량"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date", SaveName: "INVOICE_DATE",	Header:"납품예정일"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "DELIVERY_QTY",	Header:"배송확정수량"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "DELIVERY_DATE",	Header:"배송확정일"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "ADD_USER_DEPT",	Header:"요청부서"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "ADD_USER_NAME",	Header:"요청자"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "PO_USER_NAME",	Header:"발주자"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "PURCHASER_ID",	Header:"발주자ID"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "PA_KEP_USER_ID",	Header:"KEP담당자"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text", SaveName: "APPROVAL_HISTORY",	Header:"합의이력", Image:"/resources/images/but_icon01.gif"}
					
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "ADD_USER_DEPT",	Header:"ADD_USER_DEPT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "ADD_USER_ID",	Header:"ADD_USER_ID"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "PO_SEQ",	Header:"PO_SEQ"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "BUYER",	Header:"BUYER"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "AGENT",	Header:"AGENT"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "CONTRACT_NO",	Header:"CONTRACT_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "CONTRACT_SEQ",	Header:"CONTRACT_SEQ"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "LEGACY_PO_NO",	Header:"LEGACY_PO_NO"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "LEGACY_PO_SEQ",	Header:"LEGACY_PO_SEQ"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "DS_DELAY_REASON",	Header:"DS_DELAY_REASON"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text", SaveName: "PR_USER_INFO",	Header:"PR_USER_INFO"}

	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "SCM_REMARK");	//SCM비고
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "ADD_USER_NAME");	//요청자
	setLinkCol(mySheet, "PO_USER_NAME");	//발주자
	setLinkCol(mySheet, "APPROVAL_HISTORY");// 합의이력
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	var searchYn = "<%=searchYn%>";
	
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
	
	st = new Date();

	switch (str) {
		case "search":	 // 조회
		
			if(document.getElementById("st_nodate").checked == false){
				if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			}
			if($("#st_buyer_code").val() == ''){
		        alert("고객사를 선택해 주십시요");
		        return ;
		    }
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvBuyerNywarhsngListList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			$("#st_nodate").attr("checked", false);
			$("#st_buyer_code").val('');		
			$("#st_agent_code").val('');
			break;
		
		case "excelDown":	// 엑셀다운로드
			if($("#st_buyer_code").val() == ''){
		        alert("고객사를 선택해 주십시요");
		        return ;
		    }
		
		    $("#pageflag").val('0');
	
		    var downCol = "";
			for(var i=0;i<=mySheet.LastCol();i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
					downCol += "|"+i;	
				}
			}
			var param = {FileName:"고객사미입고목록.xlsx",DownCols:downCol.substring(1)};

			kepDownExcel(document.searchCondition ,mySheet , "/mpiv/excelMasterMpIvBuyerNywarhsngListList.do", param);
			$("#pageflag").val('1');
		
			break;
			
		case "buyNotGrTotalAmt":	// 거래집계내역
			//http://130.100.101.21:7004/kr/sysop/proxbuy/delivery/delay/sysop_proxybuy_not_gr_list_main_amp.jsp?st_buyer=KRBING0002&st_buyer_name=(주)빙그레 도농공장&st_agent=ALL&st_agent_name=ALL&st_po_no=ALL&st_ref_no=ALL&st_fromDate=20140823&st_toDate=20140923
	
			if($("#st_buyer_code").val() == ''){
				alert("고객사를 선택해 주십시요");
				return ;
			}
		
			var buyer		= $("#st_buyer_code").val();
			var buyerName	= $("#st_buyer_name").val();
			var agent		= $("#st_agent_code").val();
			var agentName	= $("#st_agent_name").val();
			var poNo		= $("#st_po_no").val();
			var refNo		= $("#st_ref_no").val();
			var fromDate	= $("#st_from_date").val();
			var toDate		= $("#st_to_date").val();
			var nodate		= "Y";
			
			if(document.getElementById("st_nodate").checked == false){
				nodate = "N";
			}
			
			if(isEmpty(agent)){
				agent = "ALL";
			}
			var param = "["+buyer+"]["+buyerName+"]["+agent+"]["+agentName+"]["+poNo+"]["+refNo+"]["+fromDate.replace(/[/]/gi,"")+"]["+toDate.replace(/[/]/gi,"")+"]["+nodate+"]";

			reportOpen("RD_06_S_001_93", param);
			break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvBuyerNywarhsngListList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyerMulti": // 고객사 M
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no')
			popupSel = "buyerMulti";
			break;
		case "req_user_name": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?open=Y&BUSINESS_COND=S", "500,466,no");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup("/common/mpso/poDetailPop.do", "?st_print_flag=N&st_buyer="+BUYER+"&st_po_no="+PO_NO, "900,550,no");
	
	} else if (column == 'BUYER_ITEM_NO') { // 상품코드
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		getBuyerCatalogDisplayPop(buyer, buyerItemNo, contractNo, contractSeq);

	} else if (column == 'SCM_REMARK') { // SCM비고
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "520,500,no");
		
	} else if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT");
		getAgentDisplayPop(agent);

	} else if (column == 'ADD_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"ADD_USER_ID");
		openSearchPopup("/common/userDisplayPop.do", "?user_id="+ID, "800,500,no");
		
	} else if (column == 'PO_USER_NAME') { // 발주자
		var ID = mySheet.GetCellValue(Row,"PURCHASER_ID");
		openSearchPopup("/common/userDisplayPop.do", "?user_id="+ID, "800,500,no");
		
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
	if (popupSel == "buyerMulti") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	}else if (popupSel == "req_user_name") {	// 협력사
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
			<h3>고객사 미입고 목록</h3>
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
					<caption>고객사 미입고 목록</caption>
					<colgroup>
						<col width="9%" />
						<col width="25%" />
						<col width="9%" />
						<col width="25%" />
						<col width="9%" />
                        <col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
						  <th>납기요청일</th>
				          <td  colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
		                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>		
								<input type="checkbox" name="st_nodate" id="st_nodate"  value="Y" <%if ("Y".equals(st_mainOpen)) { %> checked <%} %>>기간무시						
							</td>
							<th><font color="red">*</font>고객사</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly onclick="javascript:doPop('buyerMulti');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr> 
							<th>발주번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_po_no" name="st_po_no" style="width:67%;" value="" onkeyup="kepToUpper('st_po_no')" onkeydown="kepEnter()">
							</td>
							<th>관리번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_ref_no" name="st_ref_no" style="width:67%;" value="" onkeydown="kepEnter()">
							</td>
							<th>협력사</th>
							<td>
							    <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
					        	<input type="hidden" name="st_agent_code" id="st_agent_code" value=""> 
		                        <a href="javascript:doPop('req_user_name');"><img src="/resources/images/btn_search03.gif"></a>
		                        <a href="javascript:kepEraser('st_req_user_id','st_req_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
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
					<td  align="right">
							<span class="btn_05"><a href="javascript:doAction('buyNotGrTotalAmt')" style="height:25px;">거래내역집계</a></span>
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
  			
  		<!--버튼영역-->
		<div class="btnArea">
			<span class="fr">
				<span class="btn_06 mr04" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>
		</div>
<!--내용 종료-->	                 

</body>
</html>
