<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리
* 화면 : (팝업) 카테고리 선택 (복수선택)
* 기능 : KEPSGMG(구 SG) 를 조회해 체크 → [>] 로 우측 바구니에 담고 [확인] 으로 조회조건에 반영한다.
*        - 표준DB 전용 신규 개발. 공용 팝업(mprq masterMpRqSgChoicePop)과 JSP·SQL 어느 것도 공유하지 않는다.
*        - 페이징 없음 : /mdcm/getMasterMdCmCmsItemSgSelPopList.do 로 전량(dev 152건)을 받아 화면에서 렌더한다.
*        - 반환 : opener.setPopupReturn(코드'@'연결, 명칭'@'연결) — 끝에 '@' 를 남겨 kepMultiName 이 "○○ 외 N건"으로 센다.
* 프로그램 ID :
* 담당자 :
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style type="text/css">
	.sgBoxTitle { font-weight:bold; color:#003399; margin:0 0 4px 0; }
	.sgBox      { border:1px solid #cdcdcd; height:300px; overflow-y:auto; overflow-x:hidden; background:#ffffff; }
	.sgBox table { width:100%; border-collapse:collapse; table-layout:fixed; }
	.sgBox th   { border-bottom:1px solid #cdcdcd; background:#f4f4f4; color:#333333; font-weight:600; font-size:12px; height:24px; padding:0 3px; vertical-align:middle; white-space:nowrap; }
	.sgBox td   { border-bottom:1px solid #ededed; font-size:12px; height:24px; padding:0 3px; vertical-align:middle; line-height:24px; word-break:break-all; }
	.sgBox input[type="checkbox"] { margin:0; padding:0; vertical-align:middle; }
	.sgBox tr.on td { background:#eef4fb; }
	.sgEmpty    { color:#888888; text-align:center; padding:20px 0; line-height:normal; }
	/* 조회조건 입력칸 폭을 한 줄로 맞춘다 - input 은 size 속성(글자수)으로, select 는 % 로 잡혀 있어 서로 달랐다. */
	#cont_searchA input[type="text"], #cont_searchA select { width:95%; box-sizing:border-box; -moz-box-sizing:border-box; }
</style>
</head>
<%
// 조회조건으로 이미 선택돼 있던 카테고리 코드('@' 연결). 팝업을 다시 열면 그대로 바구니에 복원한다.
String st_sg_id_multi = CommonUtil.nvl((String) request.getParameter("st_sg_id_multi"),"");
boolean mySgOnly = "Y".equals(request.getParameter("st_my_sg_yn"));
%>
<body onload="kep_onload_view();">
<form name="masterMdCmCmsItemSgSelPop" id="masterMdCmCmsItemSgSelPop" method=post onsubmit="return false;">
	<input type="hidden" id="st_pre_sg_id" name="st_pre_sg_id" value="<%=st_sg_id_multi%>">
	<input type="hidden" id="st_my_sg_yn" name="st_my_sg_yn" value="<%=mySgOnly ? "Y" : ""%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">카테고리 선택</h1>
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
					<caption>카테고리 검색</caption>
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="30%" />
					</colgroup>
					<tbody>
					<tr>
						<td>카테고리 코드</td>
						<td>
							<input type=text name="st_sg_id" id="st_sg_id" value="" onkeydown="kepEnter()" class="input_type_text">
						</td>
						<td>카테고리명</td>
						<td>
							<input type=text name="st_sg_nm" id="st_sg_nm" value="" onkeydown="kepEnter()" class="input_type_text">
						</td>
					</tr>
					<!-- ★ 신설 : 구매팀명 드롭다운 + 구매담당자명 검색 -->
					<tr>
<% if (mySgOnly) { %>
						<td></td>
						<td><input type="hidden" name="st_kep_dept" id="st_kep_dept" value=""></td>
<% } else { %>
						<td>구매팀명</td>
						<td>
							<!-- SOURDEPT 에서 구매본부(130)·구매기획팀(138) 제외. 담당자 선택 팝업과 같은 목록을 쓴다 -->
							<select name="st_kep_dept" id="st_kep_dept"><%=CommonUtil.getCodeComboQueryIdList("commonPopup.masterMdCmCmsItemMngrDeptCombo","ALL","")%></select>
						</td>
<% } %>
						<td>구매담당자명</td>
						<td>
							<input type=text name="st_kep_user_name" id="st_kep_user_name" value="" onkeydown="kepEnter()" class="input_type_text">
						</td>
					</tr>
					</tbody>
				</table>
			</div>

			<!-- 좌 : 조회 목록 / 가운데 : 담기·빼기 / 우 : 선택한 카테고리 -->
			<div class="mt10" style="width:100%; overflow:hidden;">
				<div style="float:left; width:64%;">
					<p class="sgBoxTitle">카테고리 목록 (<span id="listCnt">0</span>)</p>
					<div class="sgBox">
						<table>
							<caption class="hidden">카테고리 목록</caption>
							<colgroup>
								<col width="26px" />
								<col width="86px" />
								<col width="*" />
<% if (!mySgOnly) { %>
								<col width="110px" />
<% } %>
								<col width="86px" />
							</colgroup>
							<thead>
								<tr>
									<th><input type="checkbox" id="chkAllList" onclick="toggleAll('list');"></th>
									<th>카테고리코드</th>
									<th>카테고리</th>
<% if (!mySgOnly) { %>
									<th>구매팀명</th>
<% } %>
									<th>구매담당자</th>
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
					<p class="sgBoxTitle">선택한 카테고리 (<span id="selCnt">0</span>)</p>
					<div class="sgBox">
						<table>
							<caption class="hidden">선택한 카테고리</caption>
							<colgroup>
								<col width="26px" />
								<col width="86px" />
								<col width="*" />
<% if (mySgOnly) { %>
								<col width="70px" />
<% } %>
							</colgroup>
							<thead>
								<tr>
									<th><input type="checkbox" id="chkAllSel" onclick="toggleAll('sel');"></th>
									<th>카테고리코드</th>
									<th>카테고리</th>
<% if (mySgOnly) { %>
									<th>구매담당자</th>
<% } %>
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
var sgNameMap = {};
var sgMngrMap = {};
// 바구니에 담긴 코드 (선택 순서 유지)
var selIds = [];
var mySgOnly = ($("#st_my_sg_yn").val() == "Y");

function kep_onload_view(){
	kepSearch(true);	// 최초 진입 = 전체 조회 (+ 조회조건에 있던 선택분 복원)
}

function kepEnter() {
	if (event.keyCode == 13) {
		kepSearch();
	}
}

/*
 * 목록 조회 (페이징 없음 - 조건에 맞는 전량을 받는다)
 * restorePre : 최초 진입 시에만 true. 조회조건에서 넘어온 선택분을 바구니에 복원한다.
 */
function kepSearch(restorePre){
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmCmsItemSgSelPopList.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { st_sg_id: $.trim($("#st_sg_id").val())
			  , st_sg_nm: $.trim($("#st_sg_nm").val())
			  , st_kep_dept: $.trim($("#st_kep_dept").val())
			  , st_kep_user_name: $.trim($("#st_kep_user_name").val())
			  , st_my_sg_yn: $("#st_my_sg_yn").val() },
		success: function( response ) {
			var rows = (response && response.data) ? response.data : [];
			for (var i=0; i<rows.length; i++){
				sgNameMap[$.trim(rows[i].SG_ID)] = $.trim(rows[i].SG_NAME);
				sgMngrMap[$.trim(rows[i].SG_ID)] = (rows[i].KEP_USER_NAME == null) ? "" : $.trim(rows[i].KEP_USER_NAME);
			}
			if (restorePre === true) { restorePreSelected(); }
			renderList(rows);
			renderSel();
		},
		error: function( response ) {
			alert("오류가 발생하였습니다.");
		}
	});
}

// 조회조건에 이미 들어 있던 '코드@코드@' 를 바구니로 복원
function restorePreSelected(){
	var pre = $.trim($("#st_pre_sg_id").val());
	if (pre == "") return;
	var arr = pre.split("@");
	for (var i=0; i<arr.length; i++){
		var v = $.trim(arr[i]);
		if (v != "" && $.inArray(v, selIds) < 0) selIds.push(v);
	}
}

// 좌측 목록 렌더. 이미 바구니에 담긴 건은 체크된 채 잠근다.
function renderList(rows){
	var $body = $("#listBody").empty();
	$("#chkAllList").prop("checked", false);
	if (rows.length == 0){
		$body.append($('<tr>').append($('<td colspan="' + (mySgOnly ? 4 : 5) + '" class="sgEmpty">').text("조회된 데이타가 없습니다.")));
	} else {
		for (var i=0; i<rows.length; i++){
			var id   = $.trim(rows[i].SG_ID);
			var name = $.trim(rows[i].SG_NAME);
			// 담당자 미배정 카테고리는 두 열이 공란이다(정상)
			var dept = (rows[i].KEP_DEPT_NAME == null) ? "" : $.trim(rows[i].KEP_DEPT_NAME);
			var mngr = (rows[i].KEP_USER_NAME == null) ? "" : $.trim(rows[i].KEP_USER_NAME);
			var used = ($.inArray(id, selIds) >= 0);
			var $chk = $('<input type="checkbox" class="listChk">').val(id);
			if (used) { $chk.prop("checked", true).prop("disabled", true); }
			var $tr = $('<tr>').append($('<td class="center">').append($chk))
			                   .append($('<td class="center">').text(id))
			                   .append($('<td class="left">').text(name));
			if (!mySgOnly) $tr.append($('<td class="left">').text(dept));
			$tr.append($('<td class="center">').text(mngr));
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
		$body.append($('<tr>').append($('<td colspan="' + (mySgOnly ? 4 : 3) + '" class="sgEmpty">').text("선택한 카테고리가 없습니다.")));
	} else {
		for (var i=0; i<selIds.length; i++){
			var id = selIds[i];
			var $chk = $('<input type="checkbox" class="selChk">').val(id);
			var $tr = $('<tr>').append($('<td class="center">').append($chk))
			                   .append($('<td class="center">').text(id))
			                   .append($('<td class="left">').text(sgNameMap[id] ? sgNameMap[id] : ""));
			if (mySgOnly) $tr.append($('<td class="center">').text(sgMngrMap[id] ? sgMngrMap[id] : ""));
			$body.append($tr);
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
		alert("담을 카테고리를 선택하세요.");
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
		alert("뺄 카테고리를 선택하세요.");
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

// 초기화 : 검색어 + 선택 모두 비우고 전체 재조회
function kepReset(){
	$("#st_sg_id").val("");
	$("#st_sg_nm").val("");
	$("#st_kep_dept").val("");			// 드롭다운 기본값 = 전체
	$("#st_kep_user_name").val("");
	selIds = [];
	kepSearch();
}

// 확인 : '코드@코드@' / '명칭@명칭@' 로 돌려준다(끝에 '@' 유지). 빈 선택이면 조회조건을 지우는 의미가 된다.
function setReturn(){
	var ids = "";
	var names = "";
	for (var i=0; i<selIds.length; i++){
		ids   += selIds[i] + "@";
		names += (sgNameMap[selIds[i]] ? sgNameMap[selIds[i]] : selIds[i]) + "@";
	}
	opener.setPopupReturn(ids, names);
	this.close();
}
</script>
</html>
