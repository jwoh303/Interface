<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) [나의협력사] 관리
* 기능 : 협력사선택의 [나의협력사] 관리에서 연다. 내 그룹별 협력사를 추가·삭제하고, 그룹을 삭제한다.
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

.ButOutline{height:26px; line-height:24px; padding:0 10px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#404046; background-color:#fff; border:1px solid #DEDEDE; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}
.ButOutline:hover{color:#fff; border:1px solid #595D7E; background:#595D7E;}
.ButOutline-on{height:26px; line-height:24px; padding:0 14px; font-size:12.5px; font-weight:500; letter-spacing:-0.5px; color:#fff; background-color:#595D7E; border:1px solid #595D7E; border-radius:6px; cursor:pointer; vertical-align:middle; white-space:nowrap;}

.mng-wrap{display:grid; grid-template-columns:180px minmax(0, 1fr); gap:6px;}
.box{border:1px solid #c4c7ce; background-color:#fff;}
.box-title{display:flex; align-items:center; gap:4px; height:24px; padding:0 10px; font-size:13px; font-weight:600; letter-spacing:-0.3px; color:#000; background-color:#dfe1e6; border-bottom:1px solid #c4c7ce; white-space:nowrap;}
.box-title .right{margin-left:auto; display:flex; align-items:center; gap:4px;}
.box-title .ButOutline{height:20px; line-height:18px; font-size:12px; border-radius:4px;}

.grp-list{height:300px; overflow-y:auto; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.grp-list div{display:flex; align-items:center; height:30px; padding:0 10px; font-size:12.5px; color:#1b1b1b; border-bottom:1px solid #eceef2; cursor:pointer; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
.grp-list div:hover{background-color:#f4f5f8;}
.grp-list div.on{font-weight:600; background-color:#e4e7f2;}
.grp-list div .cnt{margin-left:auto; padding-left:6px; font-size:11.5px; font-weight:400; color:#888;}
.grp-list .empty{justify-content:center; color:#888; cursor:default;}
.grp-list .empty:hover{background:none;}

.IBsheetScroll{height:300px; overflow:auto; background-color:#fff; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.IBsheet-table{font-size:12px; color:#1b1b1b; background-color:#fff; border-collapse:collapse; table-layout:fixed;}
.IBsheet-table th{position:sticky; top:0; z-index:1; height:22px; padding:0 3px; font-weight:500; letter-spacing:-0.5px; text-align:center; border:1px solid #cbcbcb; background-color:#e4e5ea; white-space:nowrap;}
.IBsheet-table td{height:22px; padding:0 4px; border:1px solid #e1e1e1; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;}
.IBsheet-table td.ac{text-align:center;}
.IBsheet-table td.ar{text-align:right;}
.IBsheet-table td.empty{text-align:left; padding-left:20px; color:#888888;}
.IBsheet-table tr.off td{color:#aaaaaa;}
.IBsheet-table input[type=checkbox]{width:13px; height:13px; margin:0; vertical-align:middle;}
.IBsheet-table a{color:#2172EC; text-decoration:underline; cursor:pointer;}

.pop-foot{display:flex; justify-content:flex-end; gap:4px; padding:6px 0 10px 0;}
</style>
</head>
<body onload="kep_onload_view();">
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">[나의협력사] 관리</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
	<div id="popContainer">
		<div class="mng-wrap">
			<div class="box">
				<div class="box-title">그룹명</div>
				<div class="grp-list" id="grpList"></div>
			</div>
			<div class="box">
				<div class="box-title">대상 협력사 <span id="curGroupName" style="font-weight:500; color:#595D7E;"></span>
					<span class="right">
						<button type="button" class="ButOutline" onclick="openAddPop();">협력사추가</button>
						<button type="button" class="ButOutline" onclick="removeChecked();">협력사삭제</button>
					</span>
				</div>
				<div class="IBsheetScroll"><table class="IBsheet-table" id="agentGrid"></table></div>
			</div>
		</div>
		<div class="pop-foot">
			<button type="button" class="ButOutline" onclick="deleteGroup();">그룹삭제</button>
			<button type="button" class="ButOutline-on" onclick="saveGroup();">저장</button>
		</div>
	</div>
</div>
<script type="text/javascript">
var MAX_AGENT_CNT = 100;
var COLS = [
	["", 30, null], ["유형", 70, "DIST_LEVEL_NM", "ac"], ["협력사", 220, "AGENT"], ["주소", 240, "ADDRESS_LOC"], ["사업자번호", 100, "IRS_NO", "ac"],
	["대표거래 고객사", 160, "TOP_BUYER_NAME"], ["거래횟수", 70, "PO_CNT", "ar"], ["거래금액", 100, "PO_AMT", "ar"]
];
var groups = [];
var curCode = "";
var rows = [];
var dirty = false;
var busy = false;

function kep_onload_view() {
	renderRows();
	loadGroups("");
	$(window).on("beforeunload", function() {
		if (dirty) return "저장하지 않은 변경이 있습니다.";
	});
}

function loadGroups(selectCode) {
	post("/mprq/getMasterMpRqMyAgentGroupList.do", {}, function(res) {
		groups = res.data || [];
		var $l = $("#grpList").empty();
		if (groups.length == 0) {
			$l.append("<div class='empty'>등록된 그룹이 없습니다.</div>");
			curCode = "";
			rows = [];
			$("#curGroupName").text("");
			renderRows();
			return;
		}
		for (var i = 0; i < groups.length; i++) {
			$l.append($("<div>").attr("data-code", groups[i].GROUP_CODE).attr("title", groups[i].GROUP_NAME)
				.append($("<span>").text(groups[i].GROUP_NAME)).append($("<span class='cnt'>").text(groups[i].AGENT_CNT))
				.click(function() { pickGroup($(this).attr("data-code")); }));
		}
		var code = selectCode;
		if (!findGroup(code)) code = groups[0].GROUP_CODE;
		showGroup(code);
	});
}

function findGroup(code) {
	for (var i = 0; i < groups.length; i++) {
		if (groups[i].GROUP_CODE == code) return groups[i];
	}
	return null;
}

function pickGroup(code) {
	if (busy || code == curCode) return;
	if (dirty) {
		if (!confirm("저장하지 않은 변경이 있습니다. 저장하고 이동할까요?")) return;
		saveGroup(function() { loadGroups(code); });
		return;
	}
	showGroup(code);
}

function showGroup(code) {
	curCode = code;
	var g = findGroup(code);
	$("#curGroupName").text(g ? "- " + g.GROUP_NAME : "");
	$("#grpList div").removeClass("on").filter("[data-code='" + code + "']").addClass("on");
	post("/mprq/getMasterMpRqMyAgentGroupAgentList.do", { GROUP_CODE: code }, function(res) {
		rows = res.data || [];
		dirty = false;
		renderRows();
	});
}

function renderRows() {
	var w = 0;
	var $cg = $("<colgroup>");
	var $hd = $("<tr>");
	for (var i = 0; i < COLS.length; i++) {
		w += COLS[i][1];
		$cg.append($("<col>").attr("width", COLS[i][1]));
		$hd.append(i == 0 ? $("<th>").append($("<input type='checkbox'>").click(function() {
			$("#agentGrid td input[type=checkbox]").prop("checked", this.checked);
		})) : $("<th>").text(COLS[i][0]));
	}
	var $bd = $("<tbody>");
	if (rows.length == 0) {
		$bd.append($("<tr>").append($("<td class='empty'>").attr("colspan", COLS.length).text(curCode == "" ? "그룹을 선택하세요." : "담긴 협력사가 없습니다.")));
	}
	for (var r = 0; r < rows.length; r++) {
		var d = rows[r];
		var $tr = $("<tr>").toggleClass("off", d.ACTIVE_YN == "N").append($("<td class='ac'>").append($("<input type='checkbox'>").attr("data-idx", r)));
		for (var c = 1; c < COLS.length; c++) {
			var f = COLS[c][2];
			var $td = $("<td>").addClass(COLS[c][3] || "");
			if (f == "AGENT") {
				$td.append($("<a>").text(kepTrimStr(d.AGENT_NAME) + "(" + d.AGENT_CODE + ")").attr("data-code", d.AGENT_CODE).click(function() {
					getAgentDisplayPop($(this).attr("data-code"));
				}));
				if (d.ACTIVE_YN == "N") $td.append(" [거래중지]");
			} else if (f == "PO_CNT" || f == "PO_AMT") {
				$td.text(kepCommaNum(kepTrimStr(d[f])));
			} else {
				$td.text(kepTrimStr(d[f])).attr("title", kepTrimStr(d[f]));
			}
			$tr.append($td);
		}
		$bd.append($tr);
	}
	$("#agentGrid").empty().append($cg).append($("<thead>").append($hd)).append($bd).css("width", w + "px");
}

function openAddPop() {
	if (curCode == "") {
		alert("그룹을 먼저 선택하세요.");
		return;
	}
	openSearchPopup("/mprq/showMasterMpRqMyAgentGroupAddPop.do", "", "900,420,no");
}

function addAgents(list) {
	var added = 0, dup = 0;
	for (var i = 0; i < list.length; i++) {
		if (hasAgent(list[i].AGENT_CODE)) {
			dup++;
			continue;
		}
		if (rows.length >= MAX_AGENT_CNT) {
			alert("그룹 한 개에는 협력사를 " + MAX_AGENT_CNT + "개까지 담을 수 있습니다.");
			break;
		}
		rows.push($.extend({}, list[i]));
		added++;
	}
	if (added > 0) dirty = true;
	renderRows();
	if (dup > 0) alert("이미 담긴 협력사 " + dup + "건은 제외했습니다.");
}

function hasAgent(code) {
	for (var i = 0; i < rows.length; i++) {
		if (rows[i].AGENT_CODE == code) return true;
	}
	return false;
}

function removeChecked() {
	var $chk = $("#agentGrid td input[type=checkbox]:checked");
	if ($chk.length == 0) {
		alert("삭제할 협력사를 선택하세요.");
		return;
	}
	var del = {};
	$chk.each(function() { del[$(this).attr("data-idx")] = true; });
	var keep = [];
	for (var i = 0; i < rows.length; i++) {
		if (!del[i]) keep.push(rows[i]);
	}
	rows = keep;
	dirty = true;
	renderRows();
}

function saveGroup(onSaved) {
	if (busy) return;
	if (curCode == "") {
		alert("그룹을 선택하세요.");
		return;
	}
	if (typeof onSaved != "function" && !dirty) {
		alert("변경된 내용이 없습니다.");
		return;
	}
	var codes = [];
	for (var i = 0; i < rows.length; i++) codes.push(rows[i].AGENT_CODE);
	post("/mprq/saveMasterMpRqMyAgentGroupAgent.do", { GROUP_CODE: curCode, AGENT_CODES: codes.join(",") }, function(res) {
		if (res.result != "OK") {
			alert(res.msg);
			return;
		}
		dirty = false;
		notifyOpener();
		if (typeof onSaved == "function") {
			onSaved();
			return;
		}
		alert("저장했습니다.");
		loadGroups(curCode);
	});
}

function deleteGroup() {
	if (busy) return;
	var g = findGroup(curCode);
	if (!g) {
		alert("삭제할 그룹을 선택하세요.");
		return;
	}
	if (!confirm("'" + g.GROUP_NAME + "' 그룹과 담긴 협력사 " + g.AGENT_CNT + "건을 삭제할까요?")) return;
	post("/mprq/deleteMasterMpRqMyAgentGroup.do", { GROUP_CODE: curCode }, function(res) {
		if (res.result != "OK") {
			alert(res.msg);
			return;
		}
		dirty = false;
		notifyOpener();
		loadGroups("");
	});
}

function notifyOpener() {
	try {
		if (opener && opener.reloadMyAgentGroups) opener.reloadMyAgentGroups();
	} catch (e) {}
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
</script>
</body>
</html>
