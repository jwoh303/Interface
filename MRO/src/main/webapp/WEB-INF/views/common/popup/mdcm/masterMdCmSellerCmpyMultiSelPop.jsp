<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리
* 화면 : (팝업) 협력사 선택 (복수선택)
* 기능 : 협력사(ICOMCMPY BUSINESS_COND='S')를 조회해 체크 → [>] 로 우측 바구니에 담고 [확인] 으로 조회조건에 반영한다.
*        - 기존 단건 팝업(masterMdCmSellerCmpyChoicePop)·공용 팝업(/common/icomcmpyPop.do) 어느 것도 건드리지 않고 새로 만든 것이다.
*        - 페이징 없음. 운영 협력사가 17,916건이라 진입 시 전체 조회를 하지 않는다 —
*          협력사명 두 글자 이상을 입력해 조회해야 목록이 나오고, 결과는 앞 300건까지만 내린다.
*        - 반환 : opener.setPopupReturn(코드'@'연결, 명칭'@'연결) — 끝에 '@' 를 남겨 kepMultiName 이 "○○ 외 N건"으로 센다.
* 담당자 :
* 착수일 : 2026-09-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style type="text/css">
	.agBoxTitle { font-weight:bold; color:#003399; margin:0 0 4px 0; }
	.agBox      { border:1px solid #cdcdcd; height:300px; overflow-y:auto; overflow-x:hidden; background:#ffffff; }
	.agBox table { width:100%; border-collapse:collapse; table-layout:fixed; }
	.agBox th   { border-bottom:1px solid #cdcdcd; background:#f4f4f4; color:#333333; font-weight:600; font-size:12px; height:24px; padding:0 3px; vertical-align:middle; white-space:nowrap; }
	.agBox td   { border-bottom:1px solid #ededed; font-size:12px; height:24px; padding:0 3px; vertical-align:middle; line-height:24px; word-break:break-all; }
	.agBox input[type="checkbox"] { margin:0; padding:0; vertical-align:middle; }
	.agBox tr.on td { background:#eef4fb; }
	.agEmpty    { color:#888888; text-align:center; padding:20px 0; line-height:normal; }
	.agGuide    { color:#c0392b; font-size:12px; margin:4px 0 0 0; }
</style>
</head>
<%
// 조회조건으로 이미 선택돼 있던 협력사코드('@' 연결). 팝업을 다시 열면 그대로 바구니에 복원한다.
String st_agent_code_multi = CommonUtil.nvl((String) request.getParameter("st_agent_code_multi"),"");
// 명칭을 읽어 올 여는 화면의 hidden id. 다른 화면에서도 열 수 있게 파라미터로 받는다.
String st_name_field = CommonUtil.nvl((String) request.getParameter("st_name_field"),"st_agent_name_multi");
%>
<body onload="kep_onload_view();">
<form name="masterMdCmSellerCmpyMultiSelPop" id="masterMdCmSellerCmpyMultiSelPop" method=post onsubmit="return false;">
	<input type="hidden" id="st_pre_agent_code" name="st_pre_agent_code" value="<%=st_agent_code_multi%>">
	<input type="hidden" id="st_name_field" name="st_name_field" value="<%=st_name_field%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">협력사 선택</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div class="fr">
				<span class="btn_search"><a href="javascript:kepSearch();">조회</a></span>
				<span class="btn_reset"><a href="javascript:kepReset();">초기화</a></span>
			</div>
			<br>
			<!--조회영역-->
			<div id="cont_searchA" class="mt10">
				<table class="cont_t_list01" style="width:100%">
					<caption>협력사 검색</caption>
					<colgroup>
						<col width="20%" />
						<col width="80%" />
					</colgroup>
					<tbody>
					<tr>
						<td>협력사명</td>
						<td>
							<input type=text name="st_agent_nm" id="st_agent_nm" size=40 value="" onkeydown="kepEnter()" class="input_type_text">
							<span class="agGuide">두 글자 이상 입력해 조회하세요.</span>
						</td>
					</tr>
					</tbody>
				</table>
			</div>

			<!-- 좌 : 조회 목록 / 가운데 : 담기·빼기 / 우 : 선택한 협력사 -->
			<div class="mt10" style="width:100%; overflow:hidden;">
				<div style="float:left; width:64%;">
					<p class="agBoxTitle">협력사 목록 (<span id="listCnt">0</span>)</p>
					<div class="agBox">
						<table>
							<caption class="hidden">협력사 목록</caption>
							<colgroup>
								<col width="26px" />
								<col width="92px" />
								<col width="*" />
								<col width="70px" />
								<col width="106px" />
								<col width="130px" />
							</colgroup>
							<thead>
								<tr>
									<th><input type="checkbox" id="chkAllList" onclick="toggleAll('list');"></th>
									<th>협력사코드</th>
									<th>협력사명</th>
									<th>대표자</th>
									<th>전화번호</th>
									<th>대표품목</th>
								</tr>
							</thead>
							<tbody id="listBody">
							</tbody>
						</table>
					</div>
				</div>
				<div style="float:left; width:8%; padding-top:125px; text-align:center;">
					<span class="btn_02 mr04"><a href="javascript:moveToSel();">&gt;</a></span>
					<br>
					<span class="btn_02 mr04"><a href="javascript:moveToList();">&lt;</a></span>
				</div>
				<div style="float:left; width:28%;">
					<p class="agBoxTitle">선택한 협력사 (<span id="selCnt">0</span>)</p>
					<div class="agBox">
						<table>
							<caption class="hidden">선택한 협력사</caption>
							<colgroup>
								<col width="26px" />
								<col width="92px" />
								<col width="*" />
							</colgroup>
							<thead>
								<tr>
									<th><input type="checkbox" id="chkAllSel" onclick="toggleAll('sel');"></th>
									<th>협력사코드</th>
									<th>협력사명</th>
								</tr>
							</thead>
							<tbody id="selBody">
							</tbody>
						</table>
					</div>
				</div>
			</div>

			<div class="mt10" style="text-align:center;">
				<span class="btn_02"><a href="javascript:setReturn();">확인</a></span>
				&nbsp;
				<span class="btn_02"><a href="javascript:self.close();">닫기</a></span>
			</div>
		</div>
	</div>
</form>
</body>

<script type="text/javascript">
// 조회된 목록의 코드→명칭. 검색을 다시 해도 바구니의 명칭을 잃지 않도록 누적해 둔다.
var agentNameMap = {};
// 바구니에 담긴 코드 (선택 순서 유지)
var selIds = [];

function kep_onload_view(){
	// 협력사가 운영 17,916건이라 진입 시 전체 조회를 하지 않는다. 선택분 복원만 하고 목록은 비워 둔다.
	restorePreSelected();
	renderList([], true);
	renderSel();
	$("#st_agent_nm").focus();
}

function kepEnter() {
	if (event.keyCode == 13) {
		event.preventDefault();
		event.stopImmediatePropagation();
		kepSearch();
	}
}

/*
 * 목록 조회 (페이징 없음 - 조건에 맞는 앞 300건)
 * 협력사명 두 글자 이상이 필수다. 전건 스캔을 막기 위한 것이고 설계서 요구사항이기도 하다.
 */
function kepSearch(){
	var nm = $.trim($("#st_agent_nm").val());
	if (nm.length < 2){
		alert("협력사명을 두 글자 이상 입력하세요.");
		$("#st_agent_nm").focus();
		return;
	}
	loader_obj("Y");
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmSellerCmpyMultiSelPopList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { st_agent_nm: nm },
		complete: function() {
			loader_obj("N");
		},
		success: function( response ) {
			var rows = (response && response.data) ? response.data : [];
			for (var i=0; i<rows.length; i++){
				agentNameMap[$.trim(rows[i].COM_CODE)] = $.trim(rows[i].COM_NAME_LOC);
			}
			renderList(rows, false);
			renderSel();
		},
		error: function( response ) {
			alert("오류가 발생하였습니다.");
		}
	});
}

// 조회조건에 이미 들어 있던 '코드@코드@' 를 바구니로 복원한다.
// 명칭은 여는 화면의 hidden(st_name_field 가 가리키는 id) 에서 같은 순서로 받아 온다 — URL 로 넘기면 길어져 잘릴 수 있다.
function restorePreSelected(){
	var pre = $.trim($("#st_pre_agent_code").val());
	if (pre == "") return;

	var names = [];
	try {
		var raw = opener.document.getElementById($.trim($("#st_name_field").val())).value;
		if (raw) names = raw.split("@");
	} catch (e) { names = []; }

	var arr = pre.split("@");
	for (var i=0; i<arr.length; i++){
		var v = $.trim(arr[i]);
		if (v == "" || $.inArray(v, selIds) >= 0) continue;
		selIds.push(v);
		if (names[i] != null && $.trim(names[i]) != "") agentNameMap[v] = $.trim(names[i]);
	}
}

// 좌측 목록 렌더. 이미 바구니에 담긴 건은 체크된 채 잠근다.
// firstOpen : 진입 직후(조회 전)에는 '데이타 없음' 대신 안내 문구를 보여준다.
function renderList(rows, firstOpen){
	var $body = $("#listBody").empty();
	$("#chkAllList").prop("checked", false);
	if (rows.length == 0){
		var msg = (firstOpen === true) ? "협력사명을 두 글자 이상 입력해 조회하세요." : "조회된 데이타가 없습니다.";
		$body.append($('<tr>').append($('<td colspan="6" class="agEmpty">').text(msg)));
	} else {
		for (var i=0; i<rows.length; i++){
			var id   = $.trim(rows[i].COM_CODE);
			var name = $.trim(rows[i].COM_NAME_LOC);
			var ceo  = (rows[i].CEO_NAME_LOC == null) ? "" : $.trim(rows[i].CEO_NAME_LOC);
			var tel  = (rows[i].TEL_NO       == null) ? "" : $.trim(rows[i].TEL_NO);
			var item = (rows[i].BUSINESS_ITEMS == null) ? "" : $.trim(rows[i].BUSINESS_ITEMS);
			var used = ($.inArray(id, selIds) >= 0);
			var $chk = $('<input type="checkbox" class="listChk">').val(id);
			if (used) { $chk.prop("checked", true).prop("disabled", true); }
			var $tr = $('<tr>').append($('<td class="center">').append($chk))
			                   .append($('<td class="center">').text(id))
			                   .append($('<td class="left">').text(name))
			                   .append($('<td class="center">').text(ceo))
			                   .append($('<td class="center">').text(tel))
			                   .append($('<td class="left">').text(item));
			if (used) $tr.addClass("on");
			$body.append($tr);
		}
	}
	$("#listCnt").text(rows.length);
}

// 우측 바구니 렌더
function renderSel(){
	var $body = $("#selBody").empty();
	$("#chkAllSel").prop("checked", false);
	if (selIds.length == 0){
		$body.append($('<tr>').append($('<td colspan="3" class="agEmpty">').text("선택한 협력사가 없습니다.")));
	} else {
		for (var i=0; i<selIds.length; i++){
			var id = selIds[i];
			var $chk = $('<input type="checkbox" class="selChk">').val(id);
			$body.append($('<tr>').append($('<td class="center">').append($chk))
			                      .append($('<td class="center">').text(id))
			                      .append($('<td class="left">').text(agentNameMap[id] ? agentNameMap[id] : "")));
		}
	}
	$("#selCnt").text(selIds.length);
}

// 헤더 체크박스 (잠긴 행은 건드리지 않는다)
function toggleAll(which){
	if (which == "list"){
		$(".listChk:not(:disabled)").prop("checked", $("#chkAllList").prop("checked"));
	} else {
		$(".selChk").prop("checked", $("#chkAllSel").prop("checked"));
	}
}

// [>] 체크한 목록 → 바구니
function moveToSel(){
	var moved = 0;
	$(".listChk:checked:not(:disabled)").each(function(){
		var id = $(this).val();
		if ($.inArray(id, selIds) < 0){ selIds.push(id); moved++; }
	});
	if (moved == 0){
		alert("담을 협력사를 선택하세요.");
		return;
	}
	markListUsed();
	renderSel();
}

// [<] 체크한 바구니 → 제거
function moveToList(){
	var target = [];
	$(".selChk:checked").each(function(){ target.push($(this).val()); });
	if (target.length == 0){
		alert("뺄 협력사를 선택하세요.");
		return;
	}
	var rest = [];
	for (var i=0; i<selIds.length; i++){
		if ($.inArray(selIds[i], target) < 0) rest.push(selIds[i]);
	}
	selIds = rest;
	markListUsed();
	renderSel();
}

// 좌측 목록의 '담김' 표시를 현재 바구니 기준으로 다시 칠한다(재조회 없이).
function markListUsed(){
	$(".listChk").each(function(){
		var used = ($.inArray($(this).val(), selIds) >= 0);
		$(this).prop("checked", used).prop("disabled", used);
		if (used) { $(this).closest("tr").addClass("on"); }
		else      { $(this).closest("tr").removeClass("on"); }
	});
	$("#chkAllList").prop("checked", false);
}

// 초기화 : 검색어 + 선택 모두 비우고 목록도 비운다(진입 직후 상태로)
function kepReset(){
	$("#st_agent_nm").val("");
	selIds = [];
	renderList([], true);
	renderSel();
	$("#st_agent_nm").focus();
}

// 확인 : '코드@코드@' / '명칭@명칭@' 로 돌려준다(끝에 '@' 유지). 빈 선택이면 조회조건을 지우는 의미가 된다.
function setReturn(){
	var ids = "";
	var names = "";
	for (var i=0; i<selIds.length; i++){
		ids   += selIds[i] + "@";
		names += (agentNameMap[selIds[i]] ? agentNameMap[selIds[i]] : selIds[i]) + "@";
	}
	opener.setPopupReturn(ids, names);
	this.close();
}
</script>
</html>
