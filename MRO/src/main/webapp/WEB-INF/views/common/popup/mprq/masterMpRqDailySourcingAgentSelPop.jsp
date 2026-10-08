<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) 협력사선택
* 기능 : 매입가제출 상세의 [협력사선택]에서 연다. 추천/지정·검색 협력사 중 견적요청 대상을 골라 견적을 요청한다.
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
html, body{height:100%; overflow:hidden;}
body{background-color:#e8e9ee;}
#popWrapper{display:flex; flex-direction:column; height:100%;}
#popHeader, #popContainer, .pop-foot{font-family:'Pretendard', sans-serif;}
#popWrapper #popHeader{flex:none; height:40px;}
#popHeader h1.title{top:9px; font-size:18px; letter-spacing:0px;}
#popHeader .popClose{top:11px;}
#popContainer{flex:1 1 auto; min-height:0; overflow-y:auto; padding:6px 10px 0 10px; background-color:#e8e9ee; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}

input:focus, select:focus, textarea:focus{outline:none;}
.input30{height:22px; line-height:22px; padding:0 5px; color:#1b1b1b; font-size:12px; letter-spacing:-0.2px; font-weight:500; border:1px solid #DEDEDE; border-radius:4px; vertical-align:middle; box-sizing:border-box; background-color:#fff;}
.input30[readonly]{background-color:#f3f3f5;}
.input30.hasDatepicker{background-color:#fff;}
.ui-datepicker-trigger{cursor:pointer; vertical-align:middle;}
.Select{height:22px; line-height:20px; color:#24252B; font-size:12px; font-weight:500; cursor:pointer; vertical-align:middle; border:1px solid #DEDEDE; border-radius:4px; background-color:#fff; box-sizing:border-box;}
.textarea{width:100%; padding:4px 6px; font-size:12px; line-height:17px; color:#1b1b1b; border:none; resize:none; box-sizing:border-box; word-break:break-all; background-color:#fff;}
.ButOutline{height:26px; line-height:24px; padding:0 10px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.ButOutline:hover{color:#fff; border:1px solid #595D7E; background:#595D7E;}
.ButOutline-on{height:26px; line-height:24px; padding:0 14px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#fff; background-color:#595D7E; border:1px solid #595D7E; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.titBtn{height:20px; line-height:18px; padding:0 10px; font-size:12px; font-weight:500; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:4px; cursor:pointer; white-space:nowrap;}
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
.IBsheet-table td.map{text-align:center; background-color:#f1f2f4;}
.IBsheet-table td.empty{text-align:left; padding-left:20px; color:#888888;}
.IBsheet-table input[type=checkbox]{width:13px; height:13px; margin:0; vertical-align:middle;}
.IBsheet-table td.ar{text-align:right;}
.IBsheet-table td.ban{color:#d23c3c;}
.IBsheet-table tr.off td{color:#aaaaaa;}
.file-grid{height:92px;}
.rcmd-grid{height:92px; border:1px solid #c4c7ce;}
.agent-grid{height:118px;}

.rcmd-wrap{display:grid; grid-template-columns:minmax(0, 1fr) minmax(0, 1fr); gap:6px 16px; padding:6px 10px 10px 10px;}
.rcmd-name{height:22px; line-height:22px; font-size:12px; font-weight:500; color:#1b1b1b;}

.srch-line{display:flex; align-items:center; gap:6px; height:34px; padding:0 10px; font-size:12px; color:#1b1b1b; white-space:nowrap;}
.srch-line .right{margin-left:auto; display:flex; align-items:center; gap:4px;}
.move-line{display:flex; justify-content:center; align-items:center; gap:60px; height:28px; margin-bottom:6px;}
.move-btn{width:40px; height:22px; padding:0; cursor:pointer; background:none; border:none;}
.move-btn svg{display:block; margin:0 auto;}

.pop-foot{flex:none; display:flex; justify-content:flex-end; gap:4px; padding:7px 10px; background-color:#e8e9ee; border-top:1px solid #c4c7ce;}

.layer-mask{display:none; position:fixed; left:0; top:0; right:0; bottom:0; z-index:100; background-color:rgba(0,0,0,0.2);}
.grp-layer{position:absolute; left:50%; top:50%; width:340px; margin:-80px 0 0 -170px; font-family:'Pretendard', sans-serif; background-color:#fff; border:1px solid #9a9ca5; box-shadow:0 2px 10px rgba(0,0,0,0.25);}
.grp-layer .box-title a{margin-left:auto; font-size:16px; font-weight:400; color:#666; text-decoration:none;}
.grp-layer .grp-layer-body{padding:16px 20px 14px 20px; text-align:center; font-size:12px; color:#1b1b1b;}
.grp-layer .grp-layer-body .input30{width:100%; margin-top:8px;}
.grp-layer .grp-layer-btns{display:flex; justify-content:center; gap:6px; margin-top:12px;}
</style>
</head>
<body onload="kep_onload_view();">
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">협력사선택</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
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
			<div class="box-title">추천/지정협력사</div>
			<div class="rcmd-wrap">
				<div><p class="rcmd-name">고객사-지정협력사</p><div class="IBsheetScroll rcmd-grid"><table class="IBsheet-table" id="rcmdAssignGrid"></table></div></div>
				<div><p class="rcmd-name">고객사-선호협력사</p><div class="IBsheetScroll rcmd-grid"><table class="IBsheet-table" id="rcmdPreferGrid"></table></div></div>
				<div><p class="rcmd-name">구매팀-통합협력사</p><div class="IBsheetScroll rcmd-grid"><table class="IBsheet-table" id="rcmdPoolGrid"></table></div></div>
				<div><p class="rcmd-name">고객사 소재지역 거래실적(제조사, 상세분류)</p><div class="IBsheetScroll rcmd-grid"><table class="IBsheet-table" id="rcmdAreaGrid"></table></div></div>
			</div>
		</div>

		<div class="box">
			<div class="srch-line">
				협력사 검색 <input type="text" class="input30" id="st_agent_name" style="width:200px;" onkeydown="enterSearch();">
				<button type="button" class="ButOutline" onclick="doSearch();">조회</button>
				<span class="right">
					<button type="button" class="ButOutline" onclick="doReset();">초기화</button>
					<button type="button" class="ButOutline" onclick="openMyAgentMngPop();">[나의협력사] 관리</button>
					<button type="button" class="ButOutline" onclick="openMyAgentLayer();">[나의협력사] 등록</button>
					<select class="Select" id="myAgentGroup" style="width:150px;" onchange="pickMyAgentGroup(this);"><option value="">[나의협력사] 선택</option></select>
				</span>
			</div>
		</div>

		<div class="box" style="margin-bottom:0;">
			<div class="box-title">조회협력사 <span class="right">거래현황(최근 3개월 기준)</span></div>
			<div class="IBsheetScroll agent-grid"><table class="IBsheet-table" id="srchGrid"></table></div>
		</div>

		<div class="move-line">
			<button type="button" class="move-btn" title="협력사 IN" onclick="moveIn();"><svg width="26" height="14" viewBox="0 0 26 14"><path d="M2 2 L13 11 L24 2" fill="none" stroke="#E8912D" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg></button>
			<button type="button" class="move-btn" title="협력사 OUT" onclick="moveOut();"><svg width="26" height="14" viewBox="0 0 26 14"><path d="M2 12 L13 3 L24 12" fill="none" stroke="#E8912D" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg></button>
		</div>

		<div class="box">
			<div class="box-title">견적요청 대상 협력사
				<span class="right">단독입찰 <input type="checkbox" id="single_bid_yn" onclick="toggleSingleBid();">
					<select class="Select" id="single_bid_reason" style="width:220px;" disabled>
						<option value="">선택</option>
						<option value="1">1. 고객사 지정 협력사</option>
						<option value="2">2. 선입고/선진행</option>
						<option value="3">3. 표준 DB</option>
						<option value="4">4. 제조사(제작품 or 독점)</option>
						<option value="5">5. 총판/대리점(독점)</option>
						<option value="6">6. 지정 대리점(지역 or 품목 or 제조사정책)</option>
						<option value="7">7. 설비종속형(장비납품업체)</option>
						<option value="8">8. 거래조건 충족(재고운영 등)</option>
						<option value="9">9. 선정 협력사 견적 재진행(재진행사유: 추가 Nego등)</option>
						<option value="10">10. 기타(상세사유 입력)</option>
					</select>
					<button type="button" class="titBtn" id="single_bid_file" onclick="kepNotYet();" disabled>첨부</button>
				</span>
			</div>
			<div class="IBsheetScroll agent-grid"><table class="IBsheet-table" id="targetGrid"></table></div>
		</div>
	</div>
	<div class="pop-foot">
		<button type="button" class="ButOutline" onclick="kepNotYet();">미스미견적</button>
		<button type="button" class="ButOutline" onclick="kepNotYet();">미스미추가</button>
		<button type="button" class="ButOutline-on" onclick="kepNotYet();">견적요청</button>
	</div>
</div>

<div class="layer-mask" id="myAgentLayer">
	<div class="grp-layer">
		<div class="box-title">요청정보 <a href="javascript:closeMyAgentLayer();">✕</a></div>
		<div class="grp-layer-body">
			[나의협력사] 그룹명을 입력하세요.
			<input type="text" class="input30" id="my_agent_group_name" maxlength="50" onkeydown="if (event.keyCode == 13) saveMyAgentGroup('N');">
			<div class="grp-layer-btns">
				<button type="button" class="ButOutline-on" onclick="saveMyAgentGroup('N');">확인</button>
				<button type="button" class="ButOutline" onclick="closeMyAgentLayer();">닫기</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var FILE_COLS = [["", 30], ["구분", 90], ["파일명", 330]];
var RCMD_COLS = [["", 30], ["매핑유형", 110], ["협력사", 260]];
var SRCH_COLS = [
	["", 30], ["유통레벨", 70, "DIST_LEVEL_NM", "ac"], ["협력사", 230, "AGENT"], ["제재업체 등록사유", 150, "SANCTION"], ["주소", 220, "ADDRESS_LOC"],
	["대표거래 고객사", 150, "TOP_BUYER_NAME"], ["거래횟수", 70, "PO_CNT", "ar"], ["거래금액", 100, "PO_AMT", "ar"]
];
var TARGET_COLS = [
	["", 30], ["지정/추천유형", 110, "RCMD_TYPE", "ac"], ["유통레벨", 70, "DIST_LEVEL_NM", "ac"], ["협력사", 230, "AGENT"], ["대표자", 70, "CEO_NAME_LOC", "ac"], ["전화번호", 100, "TEL_NO", "ac"],
	["주소", 220, "ADDRESS_LOC"], ["대표거래 고객사", 150, "TOP_BUYER_NAME"], ["거래횟수", 70, "PO_CNT", "ar"], ["거래금액", 100, "PO_AMT", "ar"]
];
var buyer = "";
var srchRows = [];
var targetRows = [];
var busy = false;

function kep_onload_view() {
	buildGrid("buyerFileGrid", FILE_COLS, [["첨부1", ""], ["첨부2", ""], ["첨부3", ""]], true);
	buildGrid("agentFileGrid", FILE_COLS, [["첨부1", ""], ["첨부2", ""], ["첨부3", ""]], true);
	buildGrid("rcmdAssignGrid", RCMD_COLS, [["전체", ""], ["상세분류", ""], ["제조사", ""]], true);
	buildGrid("rcmdPreferGrid", RCMD_COLS, [["전체", ""], ["상세분류", ""], ["제조사", ""]], true);
	buildGrid("rcmdPoolGrid", RCMD_COLS, [["상세분류", ""], ["제조사", ""], ["제조사-상세분류", ""]], true);
	buildGrid("rcmdAreaGrid", RCMD_COLS, [], true);
	renderAgentGrid("srchGrid", SRCH_COLS, srchRows);
	renderAgentGrid("targetGrid", TARGET_COLS, targetRows);
	setDefaultEndDate();
	var r = {};
	try {
		if (opener && opener.getReqInfo) r = opener.getReqInfo();
	} catch (e) {}
	buyer = kepTrimStr(r.BUYER);
	reloadMyAgentGroups();
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

function buildGrid(id, cols, rows, fit) {
	var w = 0;
	var $cg = $("<colgroup>");
	var $hd = $("<tr>");
	for (var i = 0; i < cols.length; i++) {
		w += cols[i][1];
		$cg.append($("<col>").attr("width", cols[i][1]));
		$hd.append(i == 0 ? $("<th>").append($("<input type='checkbox'>").click(function() {
			$(this).closest("table").find("td input[type=checkbox]:enabled").prop("checked", this.checked);
		})) : $("<th>").html(cols[i][0]));
	}
	var $bd = $("<tbody>");
	var isRcmd = (cols == RCMD_COLS);
	if (rows && rows.length > 0) {
		for (var r = 0; r < rows.length; r++) {
			var $tr = $("<tr>").append($("<td class='ac'>").append("<input type='checkbox'>"));
			for (var c = 0; c < rows[r].length; c++) $tr.append($("<td>").addClass(c == 0 ? (isRcmd ? "map" : "ac") : "").text(rows[r][c]));
			$bd.append($tr);
		}
	} else {
		$bd.append($("<tr>").append($("<td class='empty'>").attr("colspan", cols.length).text("조회된 데이터가 없습니다.")));
	}
	$("#" + id).empty().append($cg).append($("<thead>").append($hd)).append($bd).css("width", fit ? "100%" : w + "px");
}

function toggleSingleBid() {
	var on = $("#single_bid_yn").is(":checked");
	$("#single_bid_reason, #single_bid_file").prop("disabled", !on);
	if (!on) $("#single_bid_reason").val("");
}

function renderAgentGrid(id, cols, list) {
	var w = 0;
	var $cg = $("<colgroup>");
	var $hd = $("<tr>");
	for (var i = 0; i < cols.length; i++) {
		w += cols[i][1];
		$cg.append($("<col>").attr("width", cols[i][1]));
		$hd.append(i == 0 ? $("<th>").append($("<input type='checkbox'>").click(function() {
			$(this).closest("table").find("td input[type=checkbox]:enabled").prop("checked", this.checked);
		})) : $("<th>").html(cols[i][0]));
	}
	var $bd = $("<tbody>");
	if (list.length == 0) {
		$bd.append($("<tr>").append($("<td class='empty'>").attr("colspan", cols.length).text("조회된 데이터가 없습니다.")));
	}
	for (var r = 0; r < list.length; r++) {
		var d = list[r];
		var ban = (d.SANCTION_YN == "Y" && cols == SRCH_COLS);
		var $tr = $("<tr>").toggleClass("off", ban).append($("<td class='ac'>").append($("<input type='checkbox'>").attr("data-idx", r).prop("disabled", ban)));
		for (var c = 1; c < cols.length; c++) {
			var f = cols[c][2];
			var $td = $("<td>").addClass(cols[c][3] || "");
			if (f == "AGENT") {
				$td.append($("<a>").text(kepTrimStr(d.AGENT_NAME) + "(" + d.AGENT_CODE + ")").attr("data-code", d.AGENT_CODE).css({ color: "#2172EC", cursor: "pointer" }).click(function() {
					getAgentDisplayPop($(this).attr("data-code"));
				}));
			} else if (f == "SANCTION") {
				$td.addClass("ban").text(d.SANCTION_YN == "Y" ? "제재업체" : "");
			} else if (f == "PO_CNT" || f == "PO_AMT") {
				$td.text(kepCommaNum(kepTrimStr(d[f])));
			} else {
				$td.text(kepTrimStr(d[f])).attr("title", kepTrimStr(d[f]));
			}
			$tr.append($td);
		}
		$bd.append($tr);
	}
	$("#" + id).empty().append($cg).append($("<thead>").append($hd)).append($bd).css("width", w + "px");
}

function doSearch() {
	if (busy) return;
	var name = $.trim($("#st_agent_name").val());
	if (name.length < 2) {
		alert("협력사명을 2자 이상 입력하세요.");
		return;
	}
	post("/mprq/getMasterMpRqMyAgentGroupSearchAgentList.do", { st_agent_name: name, st_buyer: buyer }, function(res) {
		if (res.errMsg) {
			alert(res.errMsg);
			return;
		}
		srchRows = res.data || [];
		renderAgentGrid("srchGrid", SRCH_COLS, srchRows);
	});
}

function doReset() {
	$("#st_agent_name").val("");
	$("#myAgentGroup").val("");
	$("#single_bid_yn").prop("checked", false);
	toggleSingleBid();
	srchRows = [];
	targetRows = [];
	renderAgentGrid("srchGrid", SRCH_COLS, srchRows);
	renderAgentGrid("targetGrid", TARGET_COLS, targetRows);
}

function hasTarget(code) {
	for (var i = 0; i < targetRows.length; i++) {
		if (targetRows[i].AGENT_CODE == code) return true;
	}
	return false;
}

function moveIn() {
	var idx = kepCheckedIdx("srchGrid");
	if (idx.length == 0) {
		alert("견적요청 대상에 넣을 협력사를 선택하세요.");
		return;
	}
	for (var i = 0; i < idx.length; i++) {
		var d = srchRows[idx[i]];
		if (!hasTarget(d.AGENT_CODE)) targetRows.push($.extend({ RCMD_TYPE: "조회" }, d));
	}
	renderAgentGrid("srchGrid", SRCH_COLS, srchRows);
	renderAgentGrid("targetGrid", TARGET_COLS, targetRows);
}

function moveOut() {
	var idx = kepCheckedIdx("targetGrid");
	if (idx.length == 0) {
		alert("견적요청 대상에서 뺄 협력사를 선택하세요.");
		return;
	}
	var keep = [];
	for (var i = 0; i < targetRows.length; i++) {
		if ($.inArray(i, idx) < 0) keep.push(targetRows[i]);
	}
	targetRows = keep;
	renderAgentGrid("targetGrid", TARGET_COLS, targetRows);
}

function reloadMyAgentGroups() {
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/getMasterMpRqMyAgentGroupList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		success: function(res) {
			var list = (res && res.data) ? res.data : [];
			var $s = $("#myAgentGroup").empty().append("<option value=''>[나의협력사] 선택</option>");
			for (var i = 0; i < list.length; i++) {
				$s.append($("<option>").val(list[i].GROUP_CODE).attr("data-name", list[i].GROUP_NAME).text(list[i].GROUP_NAME + " (" + list[i].AGENT_CNT + ")"));
			}
		}
	});
}

function pickMyAgentGroup(sel) {
	var code = sel.value;
	var name = $(sel).find("option:selected").attr("data-name");
	sel.value = "";
	if (code == "" || busy) return;
	if (targetRows.length > 0 && !confirm("견적요청 대상 협력사 " + targetRows.length + "건을 비우고 '" + name + "' 그룹으로 바꿀까요?")) return;
	post("/mprq/getMasterMpRqMyAgentGroupAgentList.do", { GROUP_CODE: code, st_buyer: buyer }, function(res) {
		var list = res.data || [];
		var rows = [];
		var skip = [];
		for (var i = 0; i < list.length; i++) {
			if (list[i].SANCTION_YN == "Y") {
				skip.push(list[i].AGENT_NAME + "(제재업체)");
			} else if (list[i].ACTIVE_YN != "Y") {
				skip.push(list[i].AGENT_NAME + "(거래중지)");
			} else {
				rows.push($.extend({ RCMD_TYPE: "나의협력사" }, list[i]));
			}
		}
		targetRows = rows;
		renderAgentGrid("targetGrid", TARGET_COLS, targetRows);
		if (skip.length > 0) alert("다음 협력사 " + skip.length + "건은 제외했습니다.\n\n" + skip.join("\n"));
	});
}

function openMyAgentMngPop() {
	openSearchPopup("/mprq/showMasterMpRqMyAgentGroupMngPop.do", "", "1000,376,no");
}

function openMyAgentLayer() {
	if (targetRegList().length == 0) {
		alert("견적요청 대상 협력사가 없습니다.");
		return;
	}
	$("#my_agent_group_name").val("");
	$("#myAgentLayer").show();
	$("#my_agent_group_name").focus();
}

function targetRegList() {
	var idx = kepCheckedIdx("targetGrid");
	var list = [];
	for (var i = 0; i < targetRows.length; i++) {
		if (idx.length == 0 || $.inArray(i, idx) > -1) list.push(targetRows[i].AGENT_CODE);
	}
	return list;
}

function saveMyAgentGroup(mergeYn) {
	if (busy) return;
	var name = $.trim($("#my_agent_group_name").val());
	if (name == "") {
		alert("그룹명을 입력하세요.");
		return;
	}
	var codes = targetRegList();
	post("/mprq/saveMasterMpRqMyAgentGroup.do", { GROUP_NAME: name, MERGE_YN: mergeYn, AGENT_CODES: codes.join(",") }, function(res) {
		if (res.result == "DUP") {
			if (confirm("'" + name + "' - " + res.msg)) saveMyAgentGroup("Y");
			return;
		}
		if (res.result != "OK") {
			alert(res.msg);
			return;
		}
		closeMyAgentLayer();
		reloadMyAgentGroups();
		alert("[나의협력사] '" + name + "' 그룹에 저장했습니다.");
	});
}

function post(url, data, success) {
	busy = true;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: url,
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: data,
		success: function(res) {
			busy = false;
			success(res || {});
		},
		error: function() {
			busy = false;
			alert("처리 중 오류가 발생했습니다.");
		}
	});
}

function closeMyAgentLayer() {
	$("#myAgentLayer").hide();
}

function enterSearch() {
	if (event.keyCode == 13) doSearch();
}
</script>
</body>
</html>
