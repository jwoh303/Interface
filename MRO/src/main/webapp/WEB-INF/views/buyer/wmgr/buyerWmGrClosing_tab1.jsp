<%--
**********************************************
* 메뉴 : 정산>마감현황
* 화면 : 마감현황 탭
* 기능 : 마감현황 조회 (KEPTARDT AR 요약)
* 프로그램 ID : BU0601001
* 담당자 :
* 착수일 : 2026-04-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	SessionInfo _si1 = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String buyer1 = CommonUtil.nvl(_si1.getComCode());
	String userId1 = CommonUtil.nvl(_si1.getUserId());
	String email1 = CommonUtil.nvl(_si1.getEmail());
	String p170000001_1 = CommonUtil.nvl(request.getParameter("p170000001"), "false");
%>
<script type="text/javascript">
var mySheet1 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerWmGrClosing_tab1 = {
	pagingMode : "N",
	current_page : "1",

	init: function(){
		var initsheet1 = {};
		initsheet1.Cfg = {MergeSheet:msHeaderOnly, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
		initsheet1.Cols = [
			 {Align:"Center", SaveName:"sStatus",            Header:"<%=CommonLang.get("HTITLE255")%>",             Type:"Status", Width:50,  Edit:false, Hidden:true} /*상태*/
			,{Align:"Center", SaveName:"NO",                  Header:"No",               Type:"Text",   RelWidth:1, MinWidth:50,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"AR_CLOSE_MONTH",      Header:"<%=CommonLang.get("HTITLE1322")%>",           Type:"Text",   RelWidth:2, MinWidth:80,  Edit:false, Hidden:false} /*마감월*/
			,{Align:"Center", SaveName:"TAX_BILL_NO",         Header:"<%=CommonLang.get("HTITLE1323")%>",         Type:"Text",   RelWidth:4, MinWidth:150, Edit:false, Hidden:false} /*마감번호*/
			,{Align:"Right",  SaveName:"AMT",                 Header:"<%=CommonLang.get("HTITLE1324")%>",         Type:"Float",  RelWidth:3, MinWidth:80, Edit:false, Hidden:false, Format:"#,###"} /*공급가액*/
			,{Align:"Right",  SaveName:"TAX_AMT",             Header:"<%=CommonLang.get("HTITLE1325")%>",             Type:"Float",  RelWidth:2, MinWidth:80,  Edit:false, Hidden:false, Format:"#,###"} /*세액*/
			,{Align:"Right",  SaveName:"TOTAL_AMT",           Header:"<%=CommonLang.get("HTITLE1326")%>",             Type:"Float",  RelWidth:3, MinWidth:100, Edit:false, Hidden:false, Format:"#,###"} /*합계*/
			,{Align:"Center", SaveName:"TAX_TYPE_NM",         Header:"<%=CommonLang.get("HTITLE1327")%>",         Type:"Text",   RelWidth:2, MinWidth:80,  Edit:false, Hidden:false} /*세무구분*/
			,{Align:"Center", SaveName:"AR_TYPE",         	  Header:"<%=CommonLang.get("HTITLE1466")%>",         Type:"Text",   RelWidth:2, MinWidth:100,  Edit:false, Hidden:false} /*발행구분*/
			,{Align:"Center", SaveName:"NTS_SEND_STATUS_NM",  Header:"<%=CommonLang.get("HTITLE1328")%>",  Type:"Text",   RelWidth:2, MinWidth:100, Edit:false, Hidden:false} /*국세청 전송여부*/
			,{Align:"Center", SaveName:"ISSUE_DATE",          Header:"<%=CommonLang.get("HTITLE1329")%>", Type:"Text",  RelWidth:2, MinWidth:110, Edit:false, Hidden:false} /*세금계산서 발행일*/

			,{Align:"Center", SaveName:"DETAIL_BTN",          Header:"<%=CommonLang.get("HTITLE1330")%>",         Type:"Button", RelWidth:2, MinWidth:100,  Edit:false, Hidden:false, ClassName:"ChipsDefault_Gray_IBSheet"} /*상세내역*/
			,{Align:"Center", SaveName:"REPORT_BTN",          Header:"<%=CommonLang.get("HTITLE1331")%>",   Type:"Button", RelWidth:2, MinWidth:100, Edit:false, Hidden:false, ClassName:"Printer_IBSheet"} /*마감거래명세서*/
			,{Align:"Center", SaveName:"BYR_EMAIL_MASK",          Header:"<%=CommonLang.get("HTITLE1513")%>", Type:"Text",  RelWidth:2, MinWidth:110, Edit:false, Hidden:false} /*담당자email*/
			,{Align:"Center", SaveName:"BYR_EMAIL",          Header:"<%=CommonLang.get("HTITLE1513")%>", Type:"Text",  RelWidth:2, MinWidth:110, Edit:false, Hidden:true} /*세금계산서 발행일*/
			/* hidden */
			,{Align:"Center", SaveName:"BUYER_CODE",          Header:"BUYER_CODE",       Type:"Text",   Width:80,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"NTS_SEND_STATUS",     Header:"NTS_SEND_STATUS",  Type:"Text",   Width:50,  Edit:false, Hidden:true}
		];
		IBS_InitSheet(mySheet1, initsheet1, this.pagingMode);
		mySheet1.SetHighlightAfterSort(2);
		mySheet1.SetHeaderBackColor("#f2f7ff");
		mySheet1.SetTheme("DB", "DeepBlue");
		// 당월 기본 설정
		var now = new Date();
		$("#st_close_month_1").val(now.getFullYear() + "/" + ("0"+(now.getMonth()+1)).slice(-2));
	},

	search: function(){
		var closeMonth = $("#st_close_month_1").val();
		if(!closeMonth || closeMonth == "") {
			var now = new Date();
			closeMonth = now.getFullYear() + ("0"+(now.getMonth()+1)).slice(-2);
		}
		closeMonth = closeMonth.replace(/[/\-]/g, "");

		var st_own_flag = "";
		if($("#st_own_check").is(":checked")) {
			st_own_flag = "Y";		
		} else {
			st_own_flag = "N";
		}
		
		var ntsSendStatus = $("#st_nts_send_status_1").val() || "";

		var param = "st_com_code=<%=buyer1%>&st_user_id=<%=userId1%>&st_email=<%=email1%>";
		param += "&st_close_month=" + closeMonth;
		param += "&st_nts_send_status=" + encodeURIComponent(ntsSendStatus);
		param += "&st_own_flag=" + st_own_flag;

		jQuery.ajax({
			url: "/wmgr/getBuyerWmGrClosingArSummaryList_v2.do",
			type: "POST",
			data: param,
			dataType: "json",
			success: function(data) {
				mySheet1.LoadSearchData(data);
			},
			error: function(xhr) {
				alert("<%=CommonLang.msg("MSG841")%>"); /*조회 중 오류가 발생했습니다.*/
			}
		});
	},

	reload: function(){
		var now = new Date();
		var curMonth = now.getFullYear() + "/" + ("0"+(now.getMonth()+1)).slice(-2);
		$("#st_close_month_1").val(curMonth);
		$("#st_nts_send_status_1").val("");
		mySheet1.RemoveAll();
	},

	excelDown: function(){
		<% if("false".equals(p170000001_1)){ %>
		if(mySheet1.RowCount() == 0){
			alert("<%=CommonLang.msg("MSG842")%>"); /*조회된 데이터가 없습니다.*/
			return;
		}
		var nowDate = new Date().toISOString().slice(0,10).replace(/-/g,"");
		var param = {
			FileName: "<%=CommonLang.get("HTITLE1320")%>_" + nowDate, /*마감현황*/
			SheetName: "<%=CommonLang.get("HTITLE1320")%>", /*마감현황*/
			DownHeader: 1,
			Merge: 0,
			SheetDesign: 0,
			HiddenColumn: 0,
			OnlyHeaderMerge: 1
		};
		mySheet1.Down2Excel(param);
		<% } %>
	},

	prevMonth: function(){
		var val = ($("#st_close_month_1").val() || "").replace(/[/\-]/g, "");
		if(!val) return;
		var y = parseInt(val.substring(0,4));
		var m = parseInt(val.substring(4,6)) - 1;
		if(m < 1){ m = 12; y--; }
		$("#st_close_month_1").val(y + "/" + ("0"+m).slice(-2));
	},

	curMonth: function(){
		var now = new Date();
		$("#st_close_month_1").val(now.getFullYear() + "/" + ("0"+(now.getMonth()+1)).slice(-2));
	}
};
</script>

<div id="Search1" class="SearchContent">
	<!-- [slide7] 마감현황 -->
	<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" />
		<%=CommonLang.msg("MSG844")%><!--마감번호 단위로 확정 내역을 조회하고, [상세보기]로 품목별 내역을 확인하거나 [출력] 으로 마감거래명세서를 출력할 수 있습니다.-->
	</div>
	<table class="TabSearchTable">
		<colgroup>
			<col width="100px" />
			<col />
			<col width="120px" />
			<col />
		</colgroup>
		<tr>
			<th><%=CommonLang.get("HTITLE1332")%><!--마감년월--></th>
			<td style="width: 450px;">
				<div class="Buyer-datepicker-wrap" style="width:215px">
					<div class="date-input" data-monthpicker style="width:205px">
						<input type="text" id="st_close_month_1" placeholder="" readonly />
						<span>1</span>
					</div>
				</div>
				<button class="But_Month" style="width:80px" onclick="tabs.buyerWmGrClosing_tab1.prevMonth();"><%=CommonLang.get("HTITLE1333")%><!---1개월--></button>
				<button class="But_Month" style="width:80px" onclick="tabs.buyerWmGrClosing_tab1.curMonth();"><%=CommonLang.get("HTITLE1334")%><!--당월--></button>
			</td>
			<th><%=CommonLang.get("HTITLE1328")%><!--국세청 전송여부--></th>
			<td>
				<select id="st_nts_send_status_1" name="st_nts_send_status" class="Select40" style="width:230px">
					<option value=""><%=CommonLang.get("HTITLE29")%><!--전체--></option>
					<option value="7"><%=CommonLang.get("HTITLE1335")%><!--전송--></option>
					<option value="0"><%=CommonLang.get("HTITLE1336")%><!--미전송--></option>
				</select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 <label class="CheckLargeLabel" style="margin:0px;"><input type="checkbox"name="st_checkbox" id="st_own_check" onclick="javascript:tabs.buyerWmGrClosing_tab1.setFlag('1');" ><span class="CheckLargeCustom"></span></label>
    	  &nbsp;<%=CommonLang.get("HTITLE1512") %><!-- 본인 건만 조회 -->
			</td>
		</tr>
	</table>
	<div class="SearchBtnBox">
		<button class="ButOutline_Medium" onclick="tabs.buyerWmGrClosing_tab1.reload();"><%=CommonLang.get("HTITLE8")%><!--초기화--></button>
		<button class="ButDarkGray_Medium" onclick="tabs.buyerWmGrClosing_tab1.search();"><%=CommonLang.get("HTITLE7")%><!--조회--></button>
	</div>
	<div class="ArraySub mt30 mb10">
		<div class="buttonLeft">
			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrClosing_tab1.excelDown();"><%=CommonLang.get("HTITLE1337")%><!--엑셀 다운로드--></button>
		</div>
		<div class="buttonRight"></div>
	</div>
	<div class="IBSheetBuyer">
		<script type="text/javascript">createIBSheet("mySheet1", "100%", "100%");</script>
	</div>
	<div class="h50"></div>
</div>
<form name="reportPostForm" id="reportPostForm" method="post">
	<input type="hidden" name="fileName" id="fileName" value="">
	<input type="hidden" name="param" id="param" value="">
</form>
<script type="text/javascript">
function mySheet1_OnSearchEnd(code, msg, stCode, stMsg) {
	for(var i = mySheet1.HeaderRows(); i <= mySheet1.LastRow(); i++) {
		mySheet1.SetToolTipText(i,"BYR_EMAIL_MASK",mySheet1.GetCellValue(i,"BYR_EMAIL"));
		
		mySheet1.SetCellValue(i, "DETAIL_BTN", "<%=CommonLang.get("HTITLE1030")%>"); /*상세보기*/
		mySheet1.SetCellValue(i, "REPORT_BTN", "<%=CommonLang.get("HTITLE679")%>"); /*출력*/
		if(mySheet1.GetCellValue(i,"AR_TYPE") == "Y"){
			mySheet1.SetCellValue(i,"AR_TYPE","<%=CommonLang.get("HTITLE1467")%>"); /*자사발행*/
		}else{
			mySheet1.SetCellValue(i,"AR_TYPE","<%=CommonLang.get("HTITLE1468")%>"); /*타사업장발행*/
		}
		// 마감월 YYYYMM → YYYY/MM
		var cm = mySheet1.GetCellValue(i, "AR_CLOSE_MONTH");
		if(cm && cm.length == 6) mySheet1.SetCellValue(i, "AR_CLOSE_MONTH", cm.substring(0,4)+"/"+cm.substring(4,6));
		// 세금계산서 발행일 YYYYMMDD → YYYY/MM/DD
		var id = mySheet1.GetCellValue(i, "ISSUE_DATE");
		if(id && id.length == 8) mySheet1.SetCellValue(i, "ISSUE_DATE", id.substring(0,4)+"/"+id.substring(4,6)+"/"+id.substring(6,8));
	}
}

function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if(Row <= 0) return;
	var saveName = mySheet1.ColSaveName(Col);
	if(saveName == "DETAIL_BTN") {
		var taxBillNo = mySheet1.GetCellValue(Row, "TAX_BILL_NO");
		var buyerCode = mySheet1.GetCellValue(Row, "BUYER_CODE");
		if(taxBillNo != "") {
			PopupUtil.open({
				url: '/resources/html/buyer/popup/wmgr/buyer_closing_ar_detail.html',
				data: { taxBillNo: taxBillNo, comCode: buyerCode }
			});
		}
	}
	if(saveName == "REPORT_BTN") {
		openCloseGrReport(Row);
	}
}

// 마감거래명세서 출력 (AR 세금계산서 1건 단위 - 단일 통합 양식)
function openCloseGrReport(Row) {
	var taxBillNo = mySheet1.GetCellValue(Row, "TAX_BILL_NO");
	var buyerCode = mySheet1.GetCellValue(Row, "BUYER_CODE");
	if(taxBillNo == "") return;

	var rd_id = "RD_06_S_003_54"; /* 단일 통합 양식 (RD_06_S_003_39 입고 기본양식 복사본 - 작업자 수정 베이스) */
	var param = "["+taxBillNo+"]["+buyerCode+"]";
	
	reportPostOpen(rd_id, param);
}
</script>
