<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) 고객사 검색
* 기능 : 고객사명·그룹사 검색 또는 고객사코드 일괄입력으로 조회해 선택 고객사를 조회조건에 반영한다.
* 프로그램 ID :
* 담당자 : 홍준우
* 착수일 : 2026-09-29
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style type="text/css">
	.guide      { color:#666666; margin:0 0 6px 0; }
	.codeArea   { border:1px solid #cdcdcd; background:#f7f8fa; padding:8px 10px; margin-top:8px; overflow:hidden; }
	.codeArea .codeTit { font-weight:bold; color:#333333; margin-bottom:5px; }
	.codeArea textarea { float:left; width:62%; height:72px; box-sizing:border-box; border:1px solid #cdcdcd; padding:4px 6px; font-size:12px; resize:none; ime-mode:disabled; }
	.codeArea .codeSide { float:left; width:36%; margin-left:2%; }
	.codeArea .codeSide ul { margin:0 0 8px 0; padding:0; list-style:none; color:#666666; font-size:11.5px; line-height:18px; }
	.codeMsg    { clear:both; color:#d0021b; font-size:11.5px; padding-top:4px; word-break:break-all; }
	.bsBoxTitle { font-weight:bold; color:#003399; margin:0 0 4px 0; }
	.bsBox      { border:1px solid #cdcdcd; height:250px; overflow-y:auto; overflow-x:hidden; background:#ffffff; }
	.bsBox table { width:100%; border-collapse:collapse; table-layout:fixed; }
	.bsBox th   { border-bottom:1px solid #cdcdcd; background:#f4f4f4; color:#333333; font-weight:600; font-size:12px; height:24px; padding:0 3px; vertical-align:middle; white-space:nowrap; position:sticky; top:0; }
	.bsBox td   { border-bottom:1px solid #ededed; font-size:12px; height:24px; padding:0 3px; vertical-align:middle; line-height:24px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
	.bsBox input[type="checkbox"] { margin:0; padding:0; vertical-align:middle; }
	.bsBox tr.on td { background:#eef4fb; color:#888888; }
	.bsEmpty    { color:#888888; text-align:center; padding:20px 0; line-height:normal; }
	.moveBtns   { float:left; width:8%; padding-top:80px; text-align:center; }
	.moveBtns .btn_02 { display:inline-block; margin-bottom:6px; }
	#cont_searchA input[type="text"] { width:90%; box-sizing:border-box; }
	#cont_searchA input[type="radio"] { vertical-align:middle; margin:0 3px 2px 0; }
	#cont_searchA label { margin-right:12px; }
</style>
</head>
<%
String st_pre_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"), "");
%>
<body onload="kep_onload_view();">
<form name="masterMpRqDailySourcingBuyerSelPop" id="masterMpRqDailySourcingBuyerSelPop" method="post" onsubmit="return false;">
	<input type="hidden" id="st_pre_buyer_code" value="<%=CommonUtil.formatHTMLCode(st_pre_buyer_code)%>">

	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">고객사 검색</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
		<div id="popContainer">
			<p class="guide">고객사명 검색 또는 고객사코드 일괄입력으로 고객사를 조회할 수 있습니다.</p>

			<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
					<caption>고객사 검색</caption>
					<colgroup>
						<col width="10%" />
						<col width="38%" />
						<col width="10%" />
						<col width="42%" />
					</colgroup>
					<tbody>
					<tr>
						<td>고객사</td>
						<td><input type="text" class="input_type_text" id="st_com_name_loc" placeholder="고객사명을 입력하세요." onkeydown="kepEnter()" style="ime-mode:active;"></td>
						<td>그룹사</td>
						<td><input type="text" class="input_type_text" id="st_comorg_name" placeholder="그룹사명을 입력하세요." onkeydown="kepEnter()" style="ime-mode:active;"></td>
					</tr>
					<tr>
						<td>검색옵션</td>
						<td colspan="2">
							<label><input type="radio" name="st_comorg_type" value="ALL" checked="checked">전체</label>
							<label><input type="radio" name="st_comorg_type" value="RESP">내가 담당인 고객사</label>
							<label><input type="radio" name="st_comorg_type" value="MNG">나의 관리 고객사</label>
						</td>
						<td class="right">
							<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>
							<span class="btn_reset"><a href="javascript:kepReset();">초기화</a></span>
						</td>
					</tr>
					</tbody>
				</table>
			</div>

			<div class="codeArea">
				<p class="codeTit">고객사코드 일괄입력</p>
				<textarea id="st_code_text" placeholder="예)&#10;C000123&#10;C000456&#10;C000789"></textarea>
				<div class="codeSide">
					<ul>
						<li>• 줄바꿈 또는 쉼표로 여러 코드를 입력할 수 있습니다.</li>
						<li>• 중복 코드는 자동 제외됩니다.</li>
					</ul>
					<span class="btn_02"><a href="javascript:codeSearch();">코드조회</a></span>
					<span class="btn_02"><a href="javascript:codeReset();">입력초기화</a></span>
				</div>
				<p class="codeMsg" id="codeMsg"></p>
			</div>

			<div class="mt10" style="width:100%; overflow:hidden;">
				<div style="float:left; width:46%;">
					<p class="bsBoxTitle">조회 결과 (총 <span id="listCnt">0</span>건)</p>
					<div class="bsBox">
						<table>
							<caption class="hidden">조회 결과</caption>
							<colgroup>
								<col width="28px" />
								<col width="*" />
								<col width="96px" />
								<col width="30%" />
							</colgroup>
							<thead>
								<tr>
									<th><input type="checkbox" id="chkAllList" onclick="toggleAll('list');"></th>
									<th>고객사</th>
									<th>고객사코드</th>
									<th>그룹사</th>
								</tr>
							</thead>
							<tbody id="listBody"></tbody>
						</table>
					</div>
				</div>
				<div class="moveBtns">
					<span class="btn_02"><a href="javascript:moveToSel(false);">&gt;</a></span><br>
					<span class="btn_02"><a href="javascript:moveToList(false);">&lt;</a></span><br>
					<span class="btn_02"><a href="javascript:moveToSel(true);" title="같은 그룹사 모두 담기">&gt;&gt;</a></span><br>
					<span class="btn_02"><a href="javascript:moveToList(true);" title="같은 그룹사 모두 빼기">&lt;&lt;</a></span>
				</div>
				<div style="float:left; width:46%;">
					<p class="bsBoxTitle">선택 고객사 (총 <span id="selCnt">0</span>건)</p>
					<div class="bsBox">
						<table>
							<caption class="hidden">선택 고객사</caption>
							<colgroup>
								<col width="28px" />
								<col width="*" />
								<col width="96px" />
								<col width="30%" />
							</colgroup>
							<thead>
								<tr>
									<th><input type="checkbox" id="chkAllSel" onclick="toggleAll('sel');"></th>
									<th>고객사</th>
									<th>고객사코드</th>
									<th>그룹사</th>
								</tr>
							</thead>
							<tbody id="selBody"></tbody>
						</table>
					</div>
				</div>
			</div>

			<div class="mt10" style="text-align:right; border-top:1px solid #dddddd; padding-top:8px;">
				<span class="btn_02"><a href="javascript:setReturn();">확인</a></span>
				<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
			</div>
		</div>
	</div>
</form>
</body>

<script type="text/javascript">
var MAX_CODE_CNT = 1000;
var buyerMap = {};
var listCodes = [];
var selCodes = [];

function kep_onload_view() {
	renderList();
	renderSel();
	var pre = parseCodes($("#st_pre_buyer_code").val());
	if (pre.length > 0) {
		requestList({ st_comorg_type: "ALL", st_com_code_multi: pre.join("@") + "@" }, function(rows) {
			for (var i = 0; i < rows.length; i++) {
				if ($.inArray(rows[i].code, selCodes) < 0) selCodes.push(rows[i].code);
			}
			renderSel();
		});
	}
}

function kepEnter() {
	if (event.keyCode == 13) {
		kepSearch();
	}
}

function parseCodes(text) {
	var arr = kepTrimStr(text).split(/[\s,;@]+/);
	var out = [];
	for (var i = 0; i < arr.length; i++) {
		var v = $.trim(arr[i]).toUpperCase();
		if (v != "" && $.inArray(v, out) < 0) out.push(v);
	}
	return out;
}

function requestList(data, callback) {
	loader_obj("Y");
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mprq/getMasterMpRqDailySourcingBuyerSelPopList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: data,
		success: function(response) {
			loader_obj("N");
			if (response && response.errMsg) {
				alert(response.errMsg);
				return;
			}
			var src = (response && response.data) ? response.data : [];
			var rows = [];
			for (var i = 0; i < src.length; i++) {
				var r = {
					code: kepTrimStr(src[i].COM_CODE),
					name: kepTrimStr(src[i].COM_NAME_LOC),
					orgCode: kepTrimStr(src[i].BYCA_COMORG_CODE),
					orgName: kepTrimStr(src[i].COMORG_NAME)
				};
				buyerMap[r.code] = r;
				rows.push(r);
			}
			callback(rows);
		},
		error: function() {
			loader_obj("N");
			alert("오류가 발생하였습니다.");
		}
	});
}

function kepSearch() {
	var type = $("input:radio[name=st_comorg_type]:checked").val();
	var name = $.trim($("#st_com_name_loc").val());
	var org = $.trim($("#st_comorg_name").val());
	if (type == "ALL" && name == "" && org == "") {
		alert("검색옵션이 전체일 때는 고객사 또는 그룹사를 입력하세요.");
		return;
	}
	$("#codeMsg").text("");
	requestList({ st_comorg_type: type, st_com_name_loc: name, st_comorg_name: org }, function(rows) {
		setList(rows);
	});
}

function codeSearch() {
	var codes = parseCodes($("#st_code_text").val());
	if (codes.length == 0) {
		alert("고객사코드를 입력하세요.");
		return;
	}
	if (codes.length > MAX_CODE_CNT) {
		alert("고객사코드는 한 번에 " + MAX_CODE_CNT + "건까지 조회할 수 있습니다. (입력 " + codes.length + "건)");
		return;
	}
	requestList({ st_comorg_type: "ALL", st_com_code_multi: codes.join("@") + "@" }, function(rows) {
		setList(rows);
		var found = {};
		for (var i = 0; i < rows.length; i++) found[rows[i].code] = true;
		var miss = [];
		for (var j = 0; j < codes.length; j++) {
			if (!found[codes[j]]) miss.push(codes[j]);
		}
		$("#codeMsg").text(miss.length > 0 ? "조회되지 않은 코드 " + miss.length + "건 (없는 코드이거나 조회 권한 밖) : " + miss.join(", ") : "");
	});
}

function codeReset() {
	$("#st_code_text").val("");
	$("#codeMsg").text("");
}

function setList(rows) {
	listCodes = [];
	for (var i = 0; i < rows.length; i++) listCodes.push(rows[i].code);
	renderList();
}

function rowCells(code) {
	var r = buyerMap[code] || { code: code, name: "", orgName: "" };
	return [
		$('<td class="left">').text(r.name).attr("title", r.name),
		$('<td class="center">').text(r.code),
		$('<td class="left">').text(r.orgName).attr("title", r.orgName)
	];
}

function renderList() {
	var $body = $("#listBody").empty();
	$("#chkAllList").prop("checked", false);
	if (listCodes.length == 0) {
		$body.append($('<tr>').append($('<td colspan="4" class="bsEmpty">').text("조회된 고객사가 없습니다.")));
	} else {
		for (var i = 0; i < listCodes.length; i++) {
			var code = listCodes[i];
			var used = ($.inArray(code, selCodes) >= 0);
			var $chk = $('<input type="checkbox" class="listChk">').val(code);
			if (used) $chk.prop("checked", true).prop("disabled", true);
			var $tr = $('<tr>').append($('<td class="center">').append($chk)).append(rowCells(code));
			if (used) $tr.addClass("on");
			$body.append($tr);
		}
	}
	$("#listCnt").text(listCodes.length);
}

function renderSel() {
	var $body = $("#selBody").empty();
	$("#chkAllSel").prop("checked", false);
	if (selCodes.length == 0) {
		$body.append($('<tr>').append($('<td colspan="4" class="bsEmpty">').text("선택한 고객사가 없습니다.")));
	} else {
		for (var i = 0; i < selCodes.length; i++) {
			var $chk = $('<input type="checkbox" class="selChk">').val(selCodes[i]);
			$body.append($('<tr>').append($('<td class="center">').append($chk)).append(rowCells(selCodes[i])));
		}
	}
	$("#selCnt").text(selCodes.length);
}

function toggleAll(which) {
	if (which == "list") {
		$(".listChk:not(:disabled)").prop("checked", $("#chkAllList").prop("checked"));
	} else {
		$(".selChk").prop("checked", $("#chkAllSel").prop("checked"));
	}
}

function orgOf(code) {
	return (buyerMap[code] && buyerMap[code].orgCode) ? buyerMap[code].orgCode : "";
}

function withGroup(checked, pool) {
	var orgs = [];
	for (var i = 0; i < checked.length; i++) {
		var org = orgOf(checked[i]);
		if (org != "" && $.inArray(org, orgs) < 0) orgs.push(org);
	}
	var out = checked.slice(0);
	for (var j = 0; j < pool.length; j++) {
		if ($.inArray(pool[j], out) < 0 && $.inArray(orgOf(pool[j]), orgs) >= 0) out.push(pool[j]);
	}
	return out;
}

function moveToSel(group) {
	var checked = [];
	$(".listChk:checked:not(:disabled)").each(function() { checked.push($(this).val()); });
	if (checked.length == 0) {
		alert("담을 고객사를 선택하세요.");
		return;
	}
	var targets = group ? withGroup(checked, listCodes) : checked;
	for (var i = 0; i < targets.length; i++) {
		if ($.inArray(targets[i], selCodes) < 0) selCodes.push(targets[i]);
	}
	renderList();
	renderSel();
}

function moveToList(group) {
	var checked = [];
	$(".selChk:checked").each(function() { checked.push($(this).val()); });
	if (checked.length == 0) {
		alert("뺄 고객사를 선택하세요.");
		return;
	}
	var targets = group ? withGroup(checked, selCodes) : checked;
	var rest = [];
	for (var i = 0; i < selCodes.length; i++) {
		if ($.inArray(selCodes[i], targets) < 0) rest.push(selCodes[i]);
	}
	selCodes = rest;
	renderList();
	renderSel();
}

function kepReset() {
	$("#st_com_name_loc").val("");
	$("#st_comorg_name").val("");
	$("input:radio[name=st_comorg_type][value=ALL]").prop("checked", true);
	codeReset();
	listCodes = [];
	selCodes = [];
	renderList();
	renderSel();
}

function setReturn() {
	var codes = "", names = "", orgCodes = "", orgNames = "";
	for (var i = 0; i < selCodes.length; i++) {
		var r = buyerMap[selCodes[i]] || { code: selCodes[i], name: selCodes[i], orgCode: "", orgName: "" };
		codes += r.code + "@";
		names += (r.name == "" ? r.code : r.name) + "@";
		orgCodes += r.orgCode + "@";
		orgNames += r.orgName + "@";
	}
	opener.setPopupReturn(codes, names, orgCodes, orgNames);
	self.close();
}
</script>
</html>
