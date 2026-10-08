<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) [나의협력사] 관리 - 협력사추가
* 기능 : [나의협력사] 관리의 [협력사추가]에서 연다. 협력사를 검색해 골라 관리 화면에 넘긴다.
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

input:focus{outline:none;}
.input30{height:22px; line-height:22px; padding:0 5px; color:#1b1b1b; font-size:12px; letter-spacing:-0.2px; font-weight:500; border:1px solid #DEDEDE; border-radius:4px; vertical-align:middle; box-sizing:border-box; background-color:#fff;}
.ButOutline{height:26px; line-height:24px; padding:0 10px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.ButOutline:hover{color:#fff; border:1px solid #595D7E; background:#595D7E;}
.ButOutline-on{height:26px; line-height:24px; padding:0 14px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#fff; background-color:#595D7E; border:1px solid #595D7E; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}

.box{border:1px solid #c4c7ce; background-color:#fff;}
.box-title{display:flex; align-items:center; height:24px; padding:0 10px; font-size:13px; font-weight:600; letter-spacing:-0.3px; color:#000; background-color:#dfe1e6; border-bottom:1px solid #c4c7ce;}
.srch-line{display:flex; align-items:center; gap:6px; height:34px; padding:0 10px; font-size:12px; color:#1b1b1b; border-bottom:1px solid #c4c7ce; white-space:nowrap;}
.srch-line .cnt{margin-left:auto; color:#404046;}

.IBsheetScroll{height:160px; overflow:auto; background-color:#fff; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.IBsheet-table{font-size:12px; color:#1b1b1b; background-color:#fff; border-collapse:collapse; table-layout:fixed;}
.IBsheet-table th{position:sticky; top:0; z-index:1; height:22px; padding:0 3px; font-weight:500; letter-spacing:-0.5px; text-align:center; border:1px solid #cbcbcb; background-color:#e4e5ea; white-space:nowrap;}
.IBsheet-table td{height:22px; padding:0 4px; border:1px solid #e1e1e1; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;}
.IBsheet-table td.ac{text-align:center;}
.IBsheet-table td.ar{text-align:right;}
.IBsheet-table td.empty{text-align:left; padding-left:20px; color:#888888;}
.IBsheet-table input[type=checkbox]{width:13px; height:13px; margin:0; vertical-align:middle;}

.move-line{display:flex; justify-content:center; align-items:center; gap:60px; height:28px; border-top:1px solid #c4c7ce; border-bottom:1px solid #c4c7ce; background-color:#f1f2f4;}
.move-btn{width:40px; height:22px; padding:0; cursor:pointer; background:none; border:none;}
.move-btn svg{display:block; margin:0 auto;}
.pop-foot{display:flex; justify-content:flex-end; padding:6px 0 10px 0;}
</style>
</head>
<body onload="kep_onload_view();">
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">[나의협력사] 관리 - 협력사추가</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
	<div id="popContainer">
		<div class="box">
			<div class="box-title">협력사 조회</div>
			<div class="srch-line">
				협력사 검색 <input type="text" class="input30" id="st_agent_name" style="width:200px;" onkeydown="if (event.keyCode == 13) doSearch();">
				<button type="button" class="ButOutline" onclick="doSearch();">조회</button>
				<span class="cnt">조회 <span id="srchCnt">0</span>건 · 거래현황(최근 3개월 기준)</span>
			</div>
			<div class="IBsheetScroll"><table class="IBsheet-table" id="srchGrid"></table></div>
			<div class="move-line">
				<button type="button" class="move-btn" title="담기" onclick="moveIn();"><svg width="26" height="14" viewBox="0 0 26 14"><path d="M2 2 L13 11 L24 2" fill="none" stroke="#E8912D" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg></button>
				<button type="button" class="move-btn" title="빼기" onclick="moveOut();"><svg width="26" height="14" viewBox="0 0 26 14"><path d="M2 12 L13 3 L24 12" fill="none" stroke="#E8912D" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/></svg></button>
			</div>
			<div class="IBsheetScroll" style="height:120px;"><table class="IBsheet-table" id="pickGrid"></table></div>
		</div>
		<div class="pop-foot"><button type="button" class="ButOutline-on" onclick="doConfirm();">확인</button></div>
	</div>
</div>
<script type="text/javascript">
var COLS = [
	["", 30, null], ["유형", 70, "DIST_LEVEL_NM", "ac"], ["협력사", 230, "AGENT"], ["주소", 250, "ADDRESS_LOC"],
	["대표거래 고객사", 170, "TOP_BUYER_NAME"], ["거래횟수", 70, "PO_CNT", "ar"], ["거래금액", 100, "PO_AMT", "ar"]
];
var srchRows = [];
var pickRows = [];
var busy = false;

function kep_onload_view() {
	render("srchGrid", srchRows, "협력사명을 입력하고 조회하세요.");
	render("pickGrid", pickRows, "담은 협력사가 없습니다.");
	$("#st_agent_name").focus();
}

function doSearch() {
	if (busy) return;
	var name = $.trim($("#st_agent_name").val());
	if (name.length < 2) {
		alert("협력사명을 2자 이상 입력하세요.");
		return;
	}
	busy = true;
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/getMasterMpRqMyAgentGroupSearchAgentList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { st_agent_name: name },
		success: function(res) {
			busy = false;
			if (res && res.errMsg) {
				alert(res.errMsg);
				return;
			}
			srchRows = (res && res.data) ? res.data : [];
			$("#srchCnt").text(srchRows.length);
			render("srchGrid", srchRows, "조회된 협력사가 없습니다.");
		},
		error: function() {
			busy = false;
			alert("조회 중 오류가 발생했습니다.");
		}
	});
}

function render(id, list, emptyText) {
	var w = 0;
	var $cg = $("<colgroup>");
	var $hd = $("<tr>");
	for (var i = 0; i < COLS.length; i++) {
		w += COLS[i][1];
		$cg.append($("<col>").attr("width", COLS[i][1]));
		$hd.append(i == 0 ? $("<th>").append($("<input type='checkbox'>").click(function() {
			$(this).closest("table").find("td input[type=checkbox]").prop("checked", this.checked);
		})) : $("<th>").text(COLS[i][0]));
	}
	var $bd = $("<tbody>");
	if (list.length == 0) {
		$bd.append($("<tr>").append($("<td class='empty'>").attr("colspan", COLS.length).text(emptyText)));
	}
	for (var r = 0; r < list.length; r++) {
		var d = list[r];
		var $tr = $("<tr>").append($("<td class='ac'>").append($("<input type='checkbox'>").attr("data-idx", r)));
		for (var c = 1; c < COLS.length; c++) {
			var f = COLS[c][2];
			var v = (f == "AGENT") ? kepTrimStr(d.AGENT_NAME) + "(" + d.AGENT_CODE + ")" : (f == "PO_CNT" || f == "PO_AMT") ? kepCommaNum(kepTrimStr(d[f])) : kepTrimStr(d[f]);
			$tr.append($("<td>").addClass(COLS[c][3] || "").text(v).attr("title", v));
		}
		$bd.append($tr);
	}
	$("#" + id).empty().append($cg).append($("<thead>").append($hd)).append($bd).css("width", w + "px");
}

function moveIn() {
	var idx = kepCheckedIdx("srchGrid");
	if (idx.length == 0) {
		alert("담을 협력사를 선택하세요.");
		return;
	}
	for (var i = 0; i < idx.length; i++) {
		var d = srchRows[idx[i]];
		var dup = false;
		for (var j = 0; j < pickRows.length; j++) {
			if (pickRows[j].AGENT_CODE == d.AGENT_CODE) dup = true;
		}
		if (!dup) pickRows.push(d);
	}
	render("srchGrid", srchRows, "조회된 협력사가 없습니다.");
	render("pickGrid", pickRows, "담은 협력사가 없습니다.");
}

function moveOut() {
	var idx = kepCheckedIdx("pickGrid");
	if (idx.length == 0) {
		alert("뺄 협력사를 선택하세요.");
		return;
	}
	var keep = [];
	for (var i = 0; i < pickRows.length; i++) {
		if ($.inArray(i, idx) < 0) keep.push(pickRows[i]);
	}
	pickRows = keep;
	render("pickGrid", pickRows, "담은 협력사가 없습니다.");
}

function doConfirm() {
	if (pickRows.length == 0) {
		alert("담은 협력사가 없습니다.");
		return;
	}
	try {
		if (opener && opener.addAgents) opener.addAgents(pickRows);
	} catch (e) {
		alert("[나의협력사] 관리 창이 닫혀 있습니다.");
		return;
	}
	self.close();
}
</script>
</body>
</html>
