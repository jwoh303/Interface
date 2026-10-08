<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리
* 화면 : (팝업) 상세분류 선택 (복수선택)
* 기능 : 대분류>카테고리>소분류>상세분류 4단 드릴다운에서 상세분류를 체크 → [>] 로 우측 바구니에 담고
*        [확인] 으로 조회조건에 반영한다. (조회조건 [상세분류] 돋보기 전용)
*        - 바닥 [카테고리조회] 버튼과 그리드 [상세분류] 클릭은 종전대로 단일선택 팝업
*          (masterMdCmCmsItemCategorySelPop)을 그대로 쓴다. 이 팝업은 조회조건에서만 열린다.
*        - 백엔드는 단일선택 팝업과 공유한다 :
*            드릴다운 /mdcm/getMasterMdCmCmsItemCategorySelPop.do      (부모 CMS_CATEG_ID 로 하위 조회)
*            검색     /mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do (검색어 / 담당 카테고리)
*        - 반환 : opener.setPopupReturn(코드'@'연결, 명칭'@'연결) — 끝에 '@' 를 남겨 kepMultiName 이 "○○ 외 N건"으로 센다.
* 담당자 : 홍준우
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<style type="text/css">
	.cateWrap      { width:100%; overflow:hidden; }
	.cateCol       { float:left; width:16%; margin-right:1%; }
	.cateColArrow  { float:left; width:10%; text-align:center; padding-top:130px; }
	.cateColSel    { float:left; width:21%; }
	.cateColTitle  { height:24px; line-height:24px; border:1px solid #cdcdcd; background:#f4f4f4; font-size:12px; color:#333333; font-weight:600; text-align:center; margin:0 0 3px 0; }
	.cateBox       { border:1px solid #cdcdcd; height:300px; overflow-y:auto; overflow-x:hidden; background:#ffffff; padding:5px; }
	.cateBox ul    { margin:0; padding:0; list-style:none; }
	.cateBox li    { font-size:12px; line-height:22px; border-bottom:1px solid #f2f2f2; word-break:break-all; }
	.cateBox li a  { color:#003C76; text-decoration:none; cursor:pointer; }
	.cateBox li a.cateSelected { color:#2c96da; font-weight:bold; }
	.cateBox input[type="checkbox"] { margin:0 4px 0 0; padding:0; vertical-align:middle; }
	.cateColTitle input[type="checkbox"] { margin:0 4px 0 0; padding:0; vertical-align:middle; }
	.cateBox label { cursor:pointer; }
	.cateEmpty     { color:#888888; font-size:12px; line-height:normal; padding:5px 0; }
</style>
</head>
<%
SessionInfo _sessionInfoCateg = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = (_sessionInfoCateg == null) ? "" : CommonUtil.nvl(_sessionInfoCateg.getUserId());
// 조회조건에 이미 선택돼 있던 상세분류코드('@' 연결). 팝업을 다시 열면 그대로 바구니에 복원한다.
String st_categ_id_multi = CommonUtil.nvl((String) request.getParameter("st_categ_id_multi"),"");
%>
<body onload="kep_onload_view();">
<form name="masterMdCmCmsItemCategoryMultiSelPop" id="masterMdCmCmsItemCategoryMultiSelPop" method=post onsubmit="return false;">
	<input type="hidden" id="st_pre_categ_id" name="st_pre_categ_id" value="<%=st_categ_id_multi%>">
	<input type="hidden" id="st_user_id" name="st_user_id" value="<%=st_user_id%>">

	<div id="popWrapper">
		<div id="popHeader">
			<h1 class="title">상세분류 선택</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div class="fl">
				<input type="radio" name="st_dept_yn" id="st_dept_yn_all"  value="N" checked onclick="loadEntry();">&nbsp;전체
				&nbsp;&nbsp;
				<input type="radio" name="st_dept_yn" id="st_dept_yn_mine" value="Y" onclick="loadEntry();">&nbsp;담당 카테고리
			</div>
			<div class="fr">
				<span class="btn_search"><a href="javascript:loadEntry();">조회</a></span>
				<span class="btn_reset"><a href="javascript:kepReset();">초기화</a></span>
			</div>
			<br>
			<!--조회영역-->
			<div id="cont_searchA" class="mt10">
				<table class="cont_t_list01" style="width:100%">
					<caption>상세분류 검색</caption>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
					<tbody>
					<tr>
						<td>카테고리</td>
						<td>
							<input type=text name="st_categ_search" id="st_categ_search" style="width:70%;" value="" onkeydown="kepEnter()" class="input_type_text">
						</td>
						<td>상세분류</td>
						<td>
							<input type=text name="st_itm_search" id="st_itm_search" style="width:70%;" value="" onkeydown="kepEnter()" class="input_type_text">
						</td>
					</tr>
					</tbody>
				</table>
			</div>

			<!-- 좌 : 4단 드릴다운(대분류>카테고리>소분류>상세분류) / 가운데 : 담기·빼기 / 우 : 선택한 상세분류 -->
			<div class="cateWrap mt10">
				<div class="cateCol">
					<p class="cateColTitle">대분류</p>
					<div class="cateBox"><ul id="cateMenu1"></ul></div>
				</div>
				<div class="cateCol">
					<p class="cateColTitle">카테고리</p>
					<div class="cateBox"><ul id="cateMenu2"></ul></div>
				</div>
				<div class="cateCol">
					<p class="cateColTitle">소분류</p>
					<div class="cateBox"><ul id="cateMenu3"></ul></div>
				</div>
				<div class="cateCol">
					<p class="cateColTitle"><input type="checkbox" id="chkAllList" onclick="toggleAll('list');">상세분류</p>
					<div class="cateBox"><ul id="cateMenu4"></ul></div>
				</div>
				<div class="cateColArrow">
					<span class="btn_02 mr04"><a href="javascript:moveToSel();">&gt;</a></span>
					<br>
					<span class="btn_02 mr04"><a href="javascript:moveToList();">&lt;</a></span>
				</div>
				<div class="cateColSel">
					<p class="cateColTitle"><input type="checkbox" id="chkAllSel" onclick="toggleAll('sel');">상세분류 (<span id="selCnt">0</span>)</p>
					<div class="cateBox"><ul id="selMenu"></ul></div>
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
var NODATA = "조회 내용이 없습니다.";

// 조회된 상세분류의 코드→명칭. 재검색으로 목록에서 사라져도 바구니 명칭을 잃지 않도록 누적해 둔다.
var categNameMap = {};
// 바구니에 담긴 상세분류코드 (선택 순서 유지)
var selIds = [];

function kep_onload_view(){
	restorePreSelected();	// 조회조건에 있던 선택분 복원 (명칭은 opener 의 hidden 에서 가져온다)
	renderSel();
	loadEntry();
}

function kepEnter() {
	if (event.keyCode == 13) {
		loadEntry();
	}
}

/*
 * 진입 열 조회. 목업 기준으로 네 갈래다.
 *   전체 + 검색어 없음        → 대분류 열에 depth1 전량 (여기서부터 드릴다운)
 *   담당 카테고리             → 대분류 열은 비우고, 카테고리 열에 담당 depth2 를 바로 노출
 *   카테고리 검색어           → 대분류 열은 비우고, 카테고리 열에 매칭 depth2 를 노출
 *   상세분류 검색어           → 상세분류 열에 매칭 depth4 를 바로 노출 (위 조건과 병행 가능)
 */
function loadEntry(){
	var deptYn    = $("input[name=st_dept_yn]:checked").val();
	var categWord = $.trim($("#st_categ_search").val());
	var itmWord   = $.trim($("#st_itm_search").val());

	clearMenu(1); clearMenu(2); clearMenu(3); clearMenu(4);

	if (deptYn == "Y" || categWord != "") {
		// 카테고리(depth2) 부터 시작 — 대분류 열은 비워 둔다
		searchDepth(2, categWord, deptYn);
	} else {
		drillDown(1, "");
	}

	if (itmWord != "") {
		searchDepth(4, itmWord, deptYn);
	}
}

/*
 * 상위 클릭 → 하위 열 조회 (단일선택 팝업과 같은 드릴다운 매퍼를 쓴다)
 */
function drillDown(depth, parentId){
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmCmsItemCategorySelPop.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { param2: depth, param3: parentId, st_sour_dept_yn: "N", st_user_id: $("#st_user_id").val(), st_sour_sg_id: "" },
		async: false,
		success: function( response ) {
			renderMenu(depth, (response && response.data) ? response.data : []);
		},
		error: function( response ) {
			alert("오류가 발생하였습니다.");
		}
	});
}

/*
 * 검색어 / 담당 카테고리 조회 (단일선택 팝업과 같은 검색 매퍼를 쓴다)
 *   deptYn='Y' 이면 매퍼가 ICOMCOD3(CMSM/CMDSM) 담당 SG 로 범위를 좁힌다.
 */
function searchDepth(depth, keyword, deptYn){
	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		data: { param2: depth, param3: keyword, st_sour_dept_yn: deptYn, st_user_id: $("#st_user_id").val(), st_sour_sg_id: "" },
		async: false,
		success: function( response ) {
			renderMenu(depth, (response && response.data) ? response.data : []);
		},
		error: function( response ) {
			alert("오류가 발생하였습니다.");
		}
	});
}

// 열 비우기
function clearMenu(depth){
	$("#cateMenu"+depth).empty().append($('<li class="cateEmpty">').text(NODATA));
	if (depth == 4) $("#chkAllList").prop("checked", false);
}

// 열 제목의 전체선택 체크박스 (좌측은 이미 담겨 잠긴 행을 건드리지 않는다)
function toggleAll(which){
	if (which == "list"){
		$(".itmChk:not(:disabled)").prop("checked", $("#chkAllList").prop("checked"));
	} else {
		$(".selChk").prop("checked", $("#chkAllSel").prop("checked"));
	}
}

/*
 * 열 렌더. 상세분류(ITM)는 체크박스, 그 위 단계는 드릴다운 링크.
 * ⚠ 명칭에 따옴표가 섞여도 깨지지 않도록 문자열 이어붙이기 대신 노드로 조립한다.
 */
function renderMenu(depth, rows){
	var $ul = $("#cateMenu"+depth).empty();
	if (depth == 4) $("#chkAllList").prop("checked", false);
	if (rows.length == 0){
		$ul.append($('<li class="cateEmpty">').text(NODATA));
		return;
	}
	for (var i=0; i<rows.length; i++){
		var id   = $.trim(rows[i].CMS_CATEG_ID);
		var name = $.trim(rows[i].CATEG_NAME);
		var type = $.trim(rows[i].CATEG_TYPE);
		var $li  = $('<li>');

		if (type == "ITM"){
			categNameMap[id] = name;
			var used = ($.inArray(id, selIds) >= 0);
			var $chk = $('<input type="checkbox" class="itmChk">').val(id);
			if (used) { $chk.prop("checked", true).prop("disabled", true); }
			$li.append($('<label>').append($chk).append($('<span>').text(name)));
		} else if (depth >= 4){
			// 4단이 끝이라 더 내려갈 열이 없다. ITM 이 아닌 잔여 행은 표시만 한다.
			$li.append($('<span>').text(name));
		} else {
			var $a = $('<a>').text(name).data("categId", id).data("depth", depth);
			$a.on("click", function(){
				var d  = $(this).data("depth");
				var cid = $(this).data("categId");
				$("#cateMenu"+d+" a.cateSelected").removeClass("cateSelected");
				$(this).addClass("cateSelected");
				for (var n=d+1; n<=4; n++) { clearMenu(n); }
				drillDown(d+1, cid);
			});
			$li.append($a);
		}
		$ul.append($li);
	}
}

// 조회조건에 이미 들어 있던 '코드@코드@' 를 바구니로 복원한다.
// 명칭은 여는 화면의 hidden(st_categ_name_multi) 에서 같은 순서로 받아 온다 — URL 로 넘기면 길어져 잘릴 수 있다.
function restorePreSelected(){
	var pre = $.trim($("#st_pre_categ_id").val());
	if (pre == "") return;

	var names = [];
	try {
		var raw = opener.document.getElementById("st_categ_name_multi").value;
		if (raw) names = raw.split("@");
	} catch (e) { names = []; }

	var arr = pre.split("@");
	for (var i=0; i<arr.length; i++){
		var v = $.trim(arr[i]);
		if (v == "" || $.inArray(v, selIds) >= 0) continue;
		selIds.push(v);
		if (names[i] != null && $.trim(names[i]) != "") categNameMap[v] = $.trim(names[i]);
	}
}

// 우측 바구니 렌더
function renderSel(){
	var $ul = $("#selMenu").empty();
	$("#chkAllSel").prop("checked", false);
	if (selIds.length == 0){
		$ul.append($('<li class="cateEmpty">').text("선택한 상세분류가 없습니다."));
	} else {
		for (var i=0; i<selIds.length; i++){
			var id = selIds[i];
			var $chk = $('<input type="checkbox" class="selChk">').val(id);
			$ul.append($('<li>').append($('<label>').append($chk)
			                                        .append($('<span>').text(categNameMap[id] ? categNameMap[id] : id))));
		}
	}
	$("#selCnt").text(selIds.length);
}

// [>] 체크한 상세분류 → 바구니
function moveToSel(){
	var moved = 0;
	$(".itmChk:checked:not(:disabled)").each(function(){
		var id = $(this).val();
		if ($.inArray(id, selIds) < 0){ selIds.push(id); moved++; }
	});
	if (moved == 0){
		alert("담을 상세분류를 선택하세요.");
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
		alert("뺄 상세분류를 선택하세요.");
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

// 상세분류 열의 '담김' 표시를 현재 바구니 기준으로 다시 칠한다(재조회 없이).
function markListUsed(){
	$("#chkAllList").prop("checked", false);
	$(".itmChk").each(function(){
		var used = ($.inArray($(this).val(), selIds) >= 0);
		$(this).prop("checked", used).prop("disabled", used);
	});
}

// 초기화 : 라디오·검색어·선택 모두 비우고 대분류부터 다시
function kepReset(){
	$("#st_dept_yn_all").prop("checked", true);
	$("#st_categ_search").val("");
	$("#st_itm_search").val("");
	selIds = [];
	renderSel();
	loadEntry();
}

// 확인 : '코드@코드@' / '명칭@명칭@' 로 돌려준다(끝에 '@' 유지). 빈 선택이면 조회조건을 지우는 의미가 된다.
function setReturn(){
	var ids = "";
	var names = "";
	for (var i=0; i<selIds.length; i++){
		ids   += selIds[i] + "@";
		names += (categNameMap[selIds[i]] ? categNameMap[selIds[i]] : selIds[i]) + "@";
	}
	opener.setPopupReturn(ids, names);
	this.close();
}
</script>
</html>
