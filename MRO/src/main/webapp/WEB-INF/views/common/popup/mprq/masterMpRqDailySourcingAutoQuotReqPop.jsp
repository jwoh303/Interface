<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) 자동견적요청
* 기능 : 매입가제출 상세의 [자동견적요청]에서 연다. 자동견적 대상 협력사에게 견적을 요청한다.
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style type="text/css">
html, body{overflow:hidden;}
body{background-color:#e8e9ee;}
#popHeader, #popContainer{font-family:'Pretendard', sans-serif;}
#popWrapper #popHeader{height:40px;}
#popHeader h1.title{top:9px; font-size:18px; letter-spacing:0px;}
#popHeader .popClose{top:11px;}
#popContainer{padding:6px 10px 0 10px; background-color:#e8e9ee;}

input:focus, select:focus, textarea:focus{outline:none;}
.input30{height:22px; line-height:22px; padding:0 5px; color:#1b1b1b; font-size:12px; letter-spacing:-0.2px; font-weight:500; border:1px solid #DEDEDE; border-radius:4px; vertical-align:middle; box-sizing:border-box; background-color:#fff;}
.input30[readonly]{background-color:#f3f3f5;}
.input30.hasDatepicker{background-color:#fff;}
.ui-datepicker-trigger{cursor:pointer; vertical-align:middle;}
.textarea{width:100%; padding:4px 6px; font-size:12px; line-height:17px; color:#1b1b1b; border:none; resize:none; box-sizing:border-box; word-break:break-all; background-color:#fff;}
.ButOutline{height:26px; line-height:24px; padding:0 10px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.ButOutline:hover{color:#fff; border:1px solid #595D7E; background:#595D7E;}
.ButOutline-on{height:26px; line-height:24px; padding:0 14px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#fff; background-color:#595D7E; border:1px solid #595D7E; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.titBtn{height:20px; line-height:18px; padding:0 10px; font-size:12px; font-weight:500; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:4px; cursor:pointer;}
.titBtn:hover{background-color:#f6f6f6;}

.box{border:1px solid #c4c7ce; background-color:#fff; margin-bottom:6px;}
.box-title{display:flex; align-items:center; gap:6px; height:24px; padding:0 10px; font-size:13px; font-weight:600; letter-spacing:-0.3px; color:#000; background-color:#dfe1e6; border-bottom:1px solid #c4c7ce; white-space:nowrap;}
.box-title .right{margin-left:auto; display:flex; align-items:center; gap:4px; font-size:12px; font-weight:500;}
.box-title input[type=checkbox]{width:14px; height:14px; margin:0;}
.two-col{display:grid; grid-template-columns:minmax(0, 1fr) minmax(0, 1fr); gap:6px;}
.two-col .box{margin-bottom:0;}
.row-gap{margin-bottom:6px;}

.info-table{width:100%; border-collapse:collapse; table-layout:fixed; font-size:12px; color:#1b1b1b;}
.info-table th{height:21px; font-weight:500; letter-spacing:-0.5px; text-align:center; background-color:#e4e5ea; border:1px solid #cbcbcb;}
.info-table td{height:22px; padding:0 4px; text-align:center; border:1px solid #e1e1e1; background-color:#fff; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
.info-table tr > *:first-child{border-left:none;}
.info-table tr > *:last-child{border-right:none;}
.info-table tr:last-child td{border-bottom:none;}
.info-table tr:first-child th{border-top:none;}

.IBsheetScroll{overflow:auto; background-color:#fff; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.IBsheet-table{font-size:12px; color:#1b1b1b; background-color:#fff; border-collapse:collapse; table-layout:fixed;}
.IBsheet-table th{position:sticky; top:0; z-index:1; height:22px; padding:0 3px; font-weight:500; letter-spacing:-0.5px; text-align:center; border:1px solid #cbcbcb; background-color:#e4e5ea; white-space:nowrap;}
.IBsheet-table td{height:22px; padding:0 4px; border:1px solid #e1e1e1; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;}
.IBsheet-table td.ac{text-align:center;}
.IBsheet-table td.empty{text-align:left; padding-left:20px; color:#888888;}
.IBsheet-table input[type=checkbox]{width:13px; height:13px; margin:0; vertical-align:middle;}
.file-grid{height:92px;}
.agent-grid{height:132px;}

.pop-foot{display:flex; justify-content:flex-end; padding:4px 0 10px 0;}
</style>
</head>
<body onload="kep_onload_view();">
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">자동견적요청</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
	<div id="popContainer">
		<div class="box">
			<div class="box-title">견적일정
				<span class="right">견적마감일
					<input type="text" class="input30" id="end_date" style="width:90px;" readonly>
					<input type="text" class="input30" id="end_time" style="width:56px;" maxlength="5" readonly>
					<button type="button" class="titBtn" onclick="enableEndDate();">변경</button>
				</span>
			</div>
		</div>

		<div class="box">
			<div class="box-title">상품정보
				<span class="right">이미지필수 <input type="checkbox" id="image_req_yn"></span>
			</div>
			<table class="info-table">
				<colgroup><col width="12%" /><col width="7%" /><col width="12%" /><col width="*" /><col width="20%" /><col width="10%" /><col width="8%" /><col width="6%" /><col width="6%" /></colgroup>
				<tr><th>견적번호</th><th>순번</th><th>견적Key</th><th>상품명</th><th>규격</th><th>제조사</th><th>원산지</th><th>수량</th><th>단위</th></tr>
				<tr><td id="pQuotationNo"></td><td id="pQuotationSeq"></td><td id="pQuotationKey"></td><td id="pDescription" style="text-align:left;"></td><td id="pSpecification" style="text-align:left;"></td><td id="pMakerName"></td><td id="pOriginName"></td><td id="pItemQty" style="text-align:right;"></td><td id="pUnitMeasure"></td></tr>
			</table>
		</div>

		<div class="two-col row-gap">
			<div class="box">
				<div class="box-title">고객사 배송조건(협력사 노출)</div>
				<table class="info-table">
					<colgroup><col width="*" /><col width="10%" /><col width="12%" /><col width="10%" /><col width="12%" /><col width="21%" /></colgroup>
					<tr><th>고객사</th><th>TR</th><th>간선여부</th><th>택배</th><th>직접방문</th><th>필수참여업체수</th></tr>
					<tr><td id="dBuyerName"></td><td id="dTr"></td><td id="dTrunk"></td><td id="dParcel"></td><td id="dVisit"></td><td id="dMinAgentCnt"></td></tr>
				</table>
			</div>
			<div class="box">
				<div class="box-title">운영사비고</div>
				<textarea class="textarea" id="atoa_remark" style="height:44px;"></textarea>
			</div>
		</div>

		<div class="box">
			<div class="box-title">협력사 전달비고 (KeP ▶ 협력사)</div>
			<textarea class="textarea" id="atos_remark" style="height:64px;"></textarea>
		</div>

		<div class="two-col row-gap">
			<div class="box">
				<div class="box-title">고객사 첨부파일 <span class="right"><button type="button" class="titBtn" onclick="kepNotYet();">전달</button></span></div>
				<div class="IBsheetScroll file-grid"><table class="IBsheet-table" id="buyerFileGrid"></table></div>
			</div>
			<div class="box">
				<div class="box-title">협력사 전달파일 <span class="right"><button type="button" class="titBtn" onclick="kepNotYet();">추가</button><button type="button" class="titBtn" onclick="kepNotYet();">삭제</button></span></div>
				<div class="IBsheetScroll file-grid"><table class="IBsheet-table" id="agentFileGrid"></table></div>
			</div>
		</div>

		<div class="box">
			<div class="box-title">자동견적 대상 협력사 <span class="right">거래현황(최근 3개월 기준)</span></div>
			<div class="IBsheetScroll agent-grid"><table class="IBsheet-table" id="agentGrid"></table></div>
		</div>

		<div class="pop-foot"><button type="button" class="ButOutline-on" onclick="kepNotYet();">요청</button></div>
	</div>
</div>
<script type="text/javascript">
var FILE_COLS = [["", 30], ["구분", 90], ["파일명", 330]];
var AGENT_COLS = [
	["", 30], ["지정/추천유형", 110], ["유통레벨", 70], ["협력사명", 230], ["제재업체 등록사유", 150], ["대표자", 70],
	["전화번호", 100], ["주소", 220], ["대표거래 고객사", 150], ["거래횟수", 70], ["거래금액", 100]
];

function kep_onload_view() {
	buildFileGrid("buyerFileGrid");
	buildFileGrid("agentFileGrid");
	buildGrid("agentGrid", AGENT_COLS);
	setDefaultEndDate();
	var r = {};
	try {
		if (opener && opener.getReqInfo) r = opener.getReqInfo();
	} catch (e) {}
	$("#pQuotationNo").text(kepTrimStr(r.QUOTATION_NO));
	$("#pQuotationSeq").text(kepTrimStr(r.QUOTATION_SEQ));
	$("#pQuotationKey").text(kepTrimStr(r.QUOTATION_KEY));
	$("#pDescription").text(kepTrimStr(r.DESCRIPTION));
	$("#pSpecification").text(kepTrimStr(r.SPECIFICATION));
	$("#pMakerName").text(kepTrimStr(r.MAKER_NAME));
	$("#pOriginName").text(kepTrimStr(r.ORIGIN_NAME));
	$("#pItemQty").text(kepTrimStr(r.ITEM_QTY));
	$("#pUnitMeasure").text(kepTrimStr(r.UNIT_MEASURE));
	$("#dBuyerName").text(kepTrimStr(r.BUYER_NAME));
	$("#atos_remark").val(kepTrimStr(r.ATOS_REMARK));
	$("#atoa_remark").val(kepTrimStr(r.ATOA_REMARK));
}

function setDefaultEndDate() {
	var d = new Date();
	var time = "15:00";
	if (d.getHours() >= 10) {
		d.setDate(d.getDate() + 1);
		time = "10:00";
	}
	$("#end_date").val(kepFormatDate(d, "-"));
	$("#end_time").val(time);
}

function enableEndDate() {
	if ($("#end_date").hasClass("hasDatepicker")) return;
	kepSetCalender("end_date");
	$("#end_time").prop("readonly", false).focus();
}

function buildFileGrid(id) {
	buildGrid(id, FILE_COLS, [["첨부1", ""], ["첨부2", ""], ["첨부3", ""]]);
}

function buildGrid(id, cols, rows) {
	var w = 0;
	var $cg = $("<colgroup>");
	var $hd = $("<tr>");
	for (var i = 0; i < cols.length; i++) {
		w += cols[i][1];
		$cg.append($("<col>").attr("width", cols[i][1]));
		$hd.append(i == 0 ? $("<th>").append($("<input type='checkbox'>").click(function() {
			$(this).closest("table").find("td input[type=checkbox]").prop("checked", this.checked);
		})) : $("<th>").html(cols[i][0]));
	}
	var $bd = $("<tbody>");
	if (rows && rows.length > 0) {
		for (var r = 0; r < rows.length; r++) {
			var $tr = $("<tr>").append($("<td class='ac'>").append("<input type='checkbox'>"));
			for (var c = 0; c < rows[r].length; c++) $tr.append($("<td>").addClass(c == 0 ? "ac" : "").text(rows[r][c]));
			$bd.append($tr);
		}
	} else {
		$bd.append($("<tr>").append($("<td class='empty'>").attr("colspan", cols.length).text("조회된 데이터가 없습니다.")));
	}
	var $t = $("#" + id).empty().append($cg).append($("<thead>").append($hd)).append($bd);
	if (id.indexOf("File") > -1) $t.css("width", "100%"); else $t.css("width", w + "px");
}
</script>
</body>
</html>
