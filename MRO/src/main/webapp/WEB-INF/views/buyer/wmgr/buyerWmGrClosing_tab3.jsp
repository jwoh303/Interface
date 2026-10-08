<%--
**********************************************
* 메뉴 : 정산>정산관리
* 화면 : 부서별입고집계 탭
* 기능 : 부서별 입고 집계 조회
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
	SessionInfo _si3 = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String buyer3 = CommonUtil.nvl(_si3.getComCode());
	String userId3 = CommonUtil.nvl(_si3.getUserId());
	String p170000001_3 = CommonUtil.nvl(request.getParameter("p170000001"), "false");
	String grSttsType3 = CommonUtil.nvl(request.getParameter("grSttsType"), "N");
%>
<script type="text/javascript">
var mySheet3 = new ibsheetObject();

window.tabs = window.tabs || {};
tabs.buyerWmGrClosing_tab3 = {
	pagingMode : "N",
	current_page : "1",

	init: function(){
		var initsheet3 = {};
		initsheet3.Cfg = {MergeSheet:msHeaderOnly, CountPosition:3, HeaderRowHeight:35, DataRowHeight:30, Alternate:0, UseNoDataRow:1};
		initsheet3.Cols = [
			 {Align:"Center", SaveName:"sStatus",        Header:"상태",         Type:"Status", Width:50,  Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"NO",              Header:"No",           Type:"Text",   RelWidth:1, MinWidth:50,  Edit:false, Hidden:false}
			,{Align:"Center", SaveName:"BUYER",           Header:"고객사코드",   Type:"Text",   Width:130, Edit:false, Hidden:true}
			,{Align:"Center", SaveName:"REQ_DEPT",        Header:"요청부서코드", Type:"Text",   RelWidth:2, MinWidth:100, Edit:false, Hidden:false}
			,{Align:"Left",   SaveName:"REQ_DEPT_NAME",   Header:"요청부서명",   Type:"Text",   RelWidth:4, MinWidth:150, Edit:false, Hidden:false}
			,{Align:"Center", SaveName:"REF_PR_NO",       Header:"관리번호",     Type:"Text",   RelWidth:3, MinWidth:120, Edit:false, Hidden:false}
			,{Align:"Right",  SaveName:"GR_AMT",          Header:"입고집계금액", Type:"Float",  RelWidth:3, MinWidth:120, Edit:false, Hidden:false, Format:"#,###"}
			,{Align:"Center", SaveName:"AR_BILL_FLAG",    Header:"정산여부",     Type:"Text",   RelWidth:2, MinWidth:100, Edit:false, Hidden:false}
		];
		IBS_InitSheet(mySheet3, initsheet3, this.pagingMode);
		mySheet3.SetHighlightAfterSort(2);
		mySheet3.SetHeaderBackColor("#f2f7ff");
		mySheet3.SetTheme("DB", "DeepBlue");
		// 당월 기본 설정
		var now = new Date();
		$("#st_close_month_3").val(now.getFullYear() + "/" + ("0"+(now.getMonth()+1)).slice(-2));
	},

	search: function(){
		var closeMonth = $("#st_close_month_3").val();
		if(!closeMonth || closeMonth == "") {
			var now = new Date();
			closeMonth = now.getFullYear() + ("0"+(now.getMonth()+1)).slice(-2);
		}
		closeMonth = closeMonth.replace(/[/\-]/g, "");
		var fromDate = closeMonth + "01";
		var year = parseInt(closeMonth.substring(0,4));
		var month = parseInt(closeMonth.substring(4,6));
		var lastDay = new Date(year, month, 0).getDate();
		var toDate = closeMonth + ("0"+lastDay).slice(-2);

		var param = "st_com_code=<%=buyer3%>&st_user_id=<%=userId3%>";
		param += "&st_from_date=" + fromDate;
		param += "&st_to_date=" + toDate;
		param += "&st_gr_stts_type=<%=grSttsType3%>";
		var reqDept = $("#st_req_dept_3").val();
		if(reqDept && reqDept != "") param += "&st_req_dept_code=" + reqDept;
		param += "&st_closing_yn=ALL";
		param += "&paging=0";

		jQuery.ajax({
			url: "/wmgr/getBuyerWmGrWarehousingTotList_v2.do",
			type: "POST",
			data: param,
			dataType: "json",
			success: function(data) {
				mySheet3.LoadSearchData(data);
			},
			error: function(xhr) {
				alert("조회 중 오류가 발생했습니다.");
			}
		});
	},

	reload: function(){
		var now = new Date();
		var curMonth = now.getFullYear() + "/" + ("0"+(now.getMonth()+1)).slice(-2);
		$("#st_close_month_3").val(curMonth);
		$("#st_req_dept_3").val("");
		mySheet3.RemoveAll();
	},

	excelDown: function(){
		<% if("false".equals(p170000001_3)){ %>
		if(mySheet3.RowCount() == 0){
			alert("조회된 데이터가 없습니다.");
			return;
		}
		var nowDate = new Date().toISOString().slice(0,10).replace(/-/g,"");
		var param = {
			FileName: "부서별입고집계_" + nowDate,
			SheetName: "부서별입고집계",
			DownHeader: 1,
			Merge: 0,
			SheetDesign: 0,
			HiddenColumn: 0,
			OnlyHeaderMerge: 1
		};
		mySheet3.Down2Excel(param);
		<% } %>
	},

	prevMonth: function(){
		var val = ($("#st_close_month_3").val() || "").replace(/[/\-]/g, "");
		if(!val) return;
		var y = parseInt(val.substring(0,4));
		var m = parseInt(val.substring(4,6)) - 1;
		if(m < 1){ m = 12; y--; }
		$("#st_close_month_3").val(y + "/" + ("0"+m).slice(-2));
	},

	curMonth: function(){
		var now = new Date();
		$("#st_close_month_3").val(now.getFullYear() + "/" + ("0"+(now.getMonth()+1)).slice(-2));
	}
};
</script>

<div id="Search3" class="SearchContent">
	<!-- [slide9] 부서별입고집계 -->
	<div class="Importance"><img src="/resources/imgs/Icon_Importance.png" /> '부서별입고집계' 화면에서는 요청부서별로 확정된 마감 금액을 조회할 수 있습니다.</div>
	<table class="TabSearchTable">
		<colgroup>
			<col width="100px" />
			<col width="630px" />
			<col width="80px" />
			<col width="470px" />
		</colgroup>
		<tr>
			<th>마감년월</th>
			<td>
				<div class="Buyer-datepicker-wrap" style="width:305px">
					<div class="date-input" data-monthpicker style="width:295px">
						<input type="text" id="st_close_month_3" placeholder="" readonly />
						<span>1</span>
					</div>
				</div>
				<button class="But_MonthON" style="width:80px" onclick="tabs.buyerWmGrClosing_tab3.prevMonth();">-1개월</button>
				<button class="But_Month" style="width:80px" onclick="tabs.buyerWmGrClosing_tab3.curMonth();">당월</button>
			</td>
			<th>요청부서명</th>
			<td>
				<select id="st_req_dept_3" class="Select40" style="width:470px;">
					<option value="">전체</option>
				</select>
			</td>
		</tr>
	</table>
	<div class="SearchBtnBox">
		<button class="ButOutline_Medium" onclick="tabs.buyerWmGrClosing_tab3.reload();">초기화</button>
		<button class="ButDarkGray_Medium" onclick="tabs.buyerWmGrClosing_tab3.search();">조회</button>
	</div>
	<div class="ArraySub mt30 mb10">
		<div class="buttonLeft">
			<button class="But_ExcelDown40" onclick="tabs.buyerWmGrClosing_tab3.excelDown();">엑셀 다운로드</button>
		</div>
		<div class="buttonRight"></div>
	</div>
	<div class="IBSheetBuyer">
		<script type="text/javascript">createIBSheet("mySheet3", "100%", "100%");</script>
	</div>
	<div class="h50"></div>
</div>
