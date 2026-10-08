<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 조회 및 관리 > 상세 팝업 > [요청]
* 화면 : (팝업) 상품정보코드 상태변경
* 기능 : 상세 팝업에서 바꾼 항목만 [변경항목|기존|변경|변경사유] 로 보여주고 사유를 받는다.
*        - 상품상태 행 : 사유 드롭다운(ICOMCOD1 M182, TEXT3 로 방향 구분) + 중복존재 시 대체코드
*          대체코드는 손입력이 아니라 [대체코드 조회] 팝업에서 고른다 (masterMdCmCmsItemAltCodeSelPop)
*        - 그 외 항목 : 상세사유 텍스트
*        - [요청] → CMSCATLG_REQ / CMSCATLG_REQ_DT 에 수정요청 등록 (진행상태 REQ)
*          요청자는 [상품정보 수정요청 현황] 화면에서 진행상태를 본다. 승인/반려는 DB관리파트 화면(미신설).
*        변경 내역은 URL 이 아니라 opener.mdcmChangeItems 로 받는다 —
*        한글 명칭을 encodeURI 하면 3배로 불어 URL 길이를 넘긴다.
* 담당자 : 홍준우
* 착수일 : 2026-06-25 (재작성 2026-08-31)
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>

<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
	String st_catlg_id  = CommonUtil.nvl((String) request.getParameter("st_catlg_id"), "");
	// 상품상태 변경 방향 : OUT=사용→미사용 · IN=미사용→사용 · 공란=상품상태를 안 바꿈
	String st_reason_dir = CommonUtil.nvl((String) request.getParameter("st_reason_dir"), "");

	// 사유 목록은 방향으로 좁힌다 — M182.TEXT3 : OUT(사용→미사용) / IN(미사용→사용) / SYS(시스템 자동변경, 화면에 안 낸다)
	Map<String,String> _rsnParam = new HashMap<String,String>();
	_rsnParam.put("st_reason_dir", "".equals(st_reason_dir) ? "OUT" : st_reason_dir);
%>
<script type="text/javascript">
var CATLG_ID   = "<%=st_catlg_id%>";
var REASON_DIR = "<%=st_reason_dir%>";
var items      = [];		// [{key,label,before,after}] — 상세 팝업이 넘긴 변경 항목

// 대체코드가 필요한 사유 — ICOMCOD1 M182 의 CODE 기준. '중복존재' 하나다.
var REASON_NEED_ALT = ["DUP"];

function kep_onload_view(){
	try { items = opener.mdcmChangeItems; } catch (e) { items = null; }
	if (!items || items.length == 0) {
		alert("변경된 항목이 없습니다.");
		self.close();
		return;
	}
	renderItems();
}

/* 변경항목 표 렌더.
 * ⚠ 명칭에 따옴표가 섞여도 안 깨지도록 문자열 이어붙이기 대신 노드로 조립한다. */
function renderItems(){
	var $body = $("#itemBody").empty();

	for (var i = 0; i < items.length; i++) {
		var it  = items[i];
		var $tr = $('<tr>');
		$tr.append($('<td class="center">').text(it.label));
		$tr.append($('<td class="center">').text(it.before));
		$tr.append($('<td class="center">').text(it.after));

		var $td = $('<td class="left">');
		if (it.key == "STATUS") {
			// 상품상태 : 사유 선택 + (중복존재일 때만) 대체코드 + 안내문구
			$td.append($("#reasonTpl").html());
		} else {
			$td.append($('<input type="text" class="reasonTxt">')
				.attr("id", "rsn_" + it.key).attr("placeholder", "상세사유 텍스트 입력"));
		}
		$tr.append($td);
		$body.append($tr);
	}
	toggleAltCode();
}

/* 사유 선택에 따라 대체코드 칸·안내문구를 켠다. */
function toggleAltCode(){
	var sel = document.getElementById("st_reason");
	if (!sel) { return; }

	var need = false;
	for (var i = 0; i < REASON_NEED_ALT.length; i++) {
		if (REASON_NEED_ALT[i] == sel.value) { need = true; break; }
	}
	$("#altCodeWrap").css("display", need ? "block" : "none");
}

/* [요청] — 입력 검증 후 변경요청으로 넘긴다. */
function doRequest(){
	var sel = document.getElementById("st_reason");

	if (sel) {
		if ($.trim(sel.value) == "") {
			alert("변경사유를 선택해 주세요.");
			sel.focus();
			return;
		}
		var need = false;
		for (var i = 0; i < REASON_NEED_ALT.length; i++) {
			if (REASON_NEED_ALT[i] == sel.value) { need = true; break; }
		}
		if (need) {
			var alt = $.trim($("#st_alt_code").val());
			if (alt == "") {
				alert("선택한 사유는 대체코드 입력이 필요합니다.");
				openAltCodePop();
				return;
			}
			if (alt == CATLG_ID) {
				alert("대체코드는 이 상품정보코드와 같을 수 없습니다.");
				return;
			}
		}
	}

	// 상품상태가 아닌 항목은 상세사유 텍스트가 있어야 한다 —
	// 사유가 비면 DB관리파트 화면에서 승인·반려 판단을 할 수 없다.
	for (var i = 0; i < items.length; i++) {
		if (items[i].key == "STATUS") { continue; }
		var $txt = $("#rsn_" + items[i].key);
		if ($.trim($txt.val()) == "") {
			alert("[" + items[i].label + "] 의 변경사유를 입력해 주세요.");
			$txt.focus();
			return;
		}
	}

	saveChangeReq();
}

/* 수정요청 등록.
 * 변경항목은 병렬 파라미터로 보낸다(순서가 곧 REQ_SEQ) — 배열 6개의 길이가 반드시 같아야 값이 안 밀린다.
 * ⚠ traditional:true 가 없으면 jQuery 가 `st_job_column[]` 로 보내 서버 MultiValueMap 키가 어긋난다. */
function saveChangeReq(){
	var jobColumns = [], oldData = [], newData = [], reasonCodes = [], reasonRemarks = [], altCodes = [];

	var statusReason = $.trim($("#st_reason").val() || "");
	var statusAlt    = $.trim($("#st_alt_code").val() || "");

	for (var i = 0; i < items.length; i++) {
		var it = items[i];
		jobColumns.push(it.key);
		// 저장은 코드값으로 한다(상세팝업 collectChanges 의 beforeCode/afterCode).
		// 코드가 따로 없는 항목(품목명·모델번호·규격)은 표시값과 같은 값이 들어 있다.
		oldData.push(it.beforeCode != null ? it.beforeCode : it.before);
		newData.push(it.afterCode  != null ? it.afterCode  : it.after);

		if (it.key == "STATUS") {
			reasonCodes.push(statusReason);
			reasonRemarks.push("");
			altCodes.push(statusAlt);
		} else {
			reasonCodes.push("");
			reasonRemarks.push($.trim($("#rsn_" + it.key).val() || ""));
			altCodes.push("");
		}
	}

	$.ajax({
		type: "POST",
		dataType: "json",
		url: "/mdcm/saveMasterMdCmCmsItemChangeReq.do",
		headers: { 'X-Requested-With': 'XMLHttpRequest' },
		traditional: true,
		data: {
			 st_catlg_id      : CATLG_ID
			,st_job_column    : jobColumns
			,st_old_data      : oldData
			,st_new_data      : newData
			,st_reason_code   : reasonCodes
			,st_reason_remark : reasonRemarks
			,st_alt_code      : altCodes
		},
		success: function( response ) {
			alert(response.Message);
			if (response.Result && response.Result.Code == 1) { self.close(); }
		},
		error: function( response ) {
			alert("수정요청 등록에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
		}
	});
}

/* 대체코드 조회 팝업 열기.
 * 실재·미사용·일회성 검증은 팝업의 [적용] 이 한다 — 여기 칸은 readonly 라 손입력이 들어올 수 없다. */
function openAltCodePop(){
	openSearchPopup("/mdcm/showMasterMdCmCmsItemAltCodeSelPop.do"
	               ,"?st_catlg_id=" + CATLG_ID
	               ,"1150,626,yes");
}

function clearAltCode(){
	$("#st_alt_code").val("");
}

/* 대체코드 조회 팝업의 [적용] 이 돌려준다 (value1=상품정보코드, value2=품목명). */
function setPopupReturn(value1, value2){
	$("#st_alt_code").val($.trim(value1));
}
</script>

<style>
.guideMsg{ display:block; font-size:13px; color:#444; margin:6px 2px 8px; }
#popContainer input[type="text"]{ border:1px solid #aaaaaa; background:#fff;
  font-family:"돋움", Dotum, Verdana; font-size:12px; color:#666666;
  height:22px; line-height:22px; padding:0 4px; vertical-align:middle;
  -moz-box-sizing:border-box; box-sizing:border-box; }
#popContainer select{ font-family:"돋움", Dotum, Verdana; font-size:12px; height:22px; vertical-align:middle;
  -moz-box-sizing:border-box; box-sizing:border-box; }
#popContainer .cont_t_list02 td{ padding:4px 6px; }
.reasonTxt{ width:96%; }
.altNote{ display:block; color:#c0392b; font-size:12px; margin-top:3px; }
#altCodeWrap{ display:none; margin-top:4px; }
</style>

<body onload="kep_onload_view();">
	<div id="popWrapper" style="width:760px;">
		<div id="popHeader">
			<h1 class="title">상품정보코드 상태변경</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">

			<span class="guideMsg">변경 내용 확인 후 사유를 입력해주세요.</span>

			<table class="cont_t_list02" summary="변경항목" style="width:100%">
				<caption>변경항목</caption>
				<colgroup>
					<col width="16%" />
					<col width="22%" />
					<col width="22%" />
					<col width="*" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">변경항목</th>
						<th scope="col">기존</th>
						<th scope="col">변경</th>
						<th scope="col">변경사유</th>
					</tr>
				</thead>
				<tbody id="itemBody"></tbody>
			</table>

			<div class="btnArea mt05" style="text-align:center; padding:10px 0 6px;">
				<span class="btn_02 mr04"><a href="javascript:doRequest();">요청</a></span>
				<span class="btn_02"><a href="javascript:self.close();">취소</a></span>
			</div>
			<br>
		</div>
	</div>

	<!--상품상태 행에 꽂을 사유 입력 묶음 (renderItems 가 복제해 쓴다)-->
	<script type="text/html" id="reasonTpl">
		<select id="st_reason" name="st_reason" style="width:60%;" onchange="toggleAltCode();">
			<%=CommonUtil.getCodeComboQueryIdList("master.mdcm.getCmsItemChangeReasonCodeList", "SEL", _rsnParam, "") %>
		</select>
		<span id="altCodeWrap">
			<input type="text" id="st_alt_code" name="st_alt_code" style="width:44%;" placeholder="대체코드" readonly>
			<a href="javascript:openAltCodePop();"><img src="/resources/images/btn_search03.gif" alt="대체코드 조회"></a>
			<a href="javascript:clearAltCode();"><img src="/resources/images/btn_eraser2.gif" alt="지우기"></a>
			<span class="altNote">선택한 사유는 대체코드 입력이 필요합니다.</span>
		</span>
	</script>
</body>
</html>
