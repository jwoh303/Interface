<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>구매정보 조회 및 관리 > 구매정보 상세 팝업 > [변경]
* 화면 : (팝업) 구매정보코드 상태변경
* 기능 : 상세 팝업에서 바꾼 항목만 [변경항목|기존|변경|변경사유] 로 보여주고 사유를 받는다.
*        - 공급상태 행 : 사유 드롭다운(가능→불가 5종 / 불가→가능 4종)
*          대체코드는 구매정보에 두지 않는다 — 상품정보(CMSCATLG.ALT_CATLG_ID) 한 곳에만 있다.
*        - 그 외 항목(매입단가·배송일수·품목구분·협력사품목코드·과세구분) : 상세사유 텍스트
*        - [변경] → 매입단가 '인상'이 있으면 결재 요청 화면, 나머지는 즉시 적용
*        - st_blocked=Y : [불가→가능] 차단 안내만 노출 (상품상태가 미사용일 때)
*        변경 내역은 URL 이 아니라 opener.mdcmBuyChangeItems 로 받는다 —
*        한글 명칭을 encodeURI 하면 3배로 불어 URL 길이를 넘긴다(상품 s9 와 같은 규약).
* 담당자 : 홍준우
* 착수일 : 2026-09-08
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>

<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
	String st_catlg_id   = CommonUtil.nvl((String) request.getParameter("st_catlg_id"), "");
	String st_buy_info   = CommonUtil.nvl((String) request.getParameter("st_buy_info"), "");
	// 공급상태 변경 방향 : OUT=가능→불가 · IN=불가→가능 · 공란=공급상태를 안 바꿈
	String st_reason_dir = CommonUtil.nvl((String) request.getParameter("st_reason_dir"), "");
	boolean isBlocked    = "Y".equals(CommonUtil.nvl((String) request.getParameter("st_blocked"), ""));
	String st_com_code   = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getComCode());
	String st_login_id   = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserId());
	String st_login_nm   = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserNameLoc());
%>
<script type="text/javascript">
var CATLG_ID   = "<%=st_catlg_id%>";
var BUY_INFO   = "<%=st_buy_info%>";
var REASON_DIR = "<%=st_reason_dir%>";
var COM_CODE   = "<%=st_com_code%>";
var LOGIN_ID   = "<%=st_login_id%>";
var LOGIN_NAME = "<%=st_login_nm%>";
var items      = [];		// [{key,label,before,after}] — 상세 팝업이 넘긴 변경 항목

/* 공급상태 변경사유.
 * ⚠ 공통코드 미적재라 화면에 둔다 — ICOMCOD1 에 코드타입이 생기면 상품 s9 처럼 서버 조회로 교체할 것.
 *   (상품은 M182.TEXT3 로 방향을 가른다. 여기도 같은 관례로 한 타입에 방향을 넣는다.) */
var REASONS = {
	 OUT : [ {code:"DUP",    name:"중복존재"}
	        ,{code:"DISC",   name:"단종"}
	        ,{code:"SOLD",   name:"일시품절"}
	        ,{code:"PRCF",   name:"단가갱신거부"}
	        ,{code:"CTEND",  name:"협력사 계약종료"} ]
	,IN  : [ {code:"NEWTR",  name:"신규거래발생"}
	        ,{code:"STOCK",  name:"재고보유품(단종)"}
	        ,{code:"SOLDR",  name:"일시품절해제"}
	        ,{code:"PRCAGR", name:"단가합의갱신"} ]
};

function kep_onload_view(){
<% if(!isBlocked){ %>
	try { items = opener.mdcmBuyChangeItems; } catch (e) { items = null; }
	if (!items || items.length == 0) {
		alert("변경된 항목이 없습니다.");
		self.close();
		return;
	}
	renderItems();
	showPriceApprNote();
<% } %>
}

/* 매입단가 결재 안내 — 결재를 타는 인상일 때만 띄운다. */
function showPriceApprNote(){
	var el = document.getElementById("priceApprNote");
	if(!el){ return; }
	el.style.display = hasPriceUp() ? "" : "none";
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
			// 공급상태 : 사유 선택
			$td.append($("#reasonTpl").html());
		} else {
			$td.append($('<input type="text" class="reasonTxt">')
				.attr("id", "rsn_" + it.key).attr("placeholder", "상세사유 텍스트 입력"));
		}
		$tr.append($td);
		$body.append($tr);
	}
	fillReasonOptions();
}

/* 방향(OUT/IN)에 맞는 사유만 드롭다운에 채운다. */
function fillReasonOptions(){
	var sel = document.getElementById("st_reason");
	if (!sel) { return; }

	var list = REASONS[REASON_DIR] || REASONS.OUT;
	for (var i = 0; i < list.length; i++) {
		var op = document.createElement("option");
		op.value = list[i].code;
		op.text  = list[i].name;
		sel.appendChild(op);
	}
}

/* 매입단가가 인상(변경 후 > 변경 전)인지. 인상만 결재를 탄다 — 인하는 즉시 반영이다.
 * ⚠ 기준가(상품)는 반대다(인하가 결재). 헷갈리기 쉬운 지점. */
function hasPriceUp(){
	for (var i = 0; i < items.length; i++) {
		if (items[i].key != "BUY_PRICE") { continue; }
		var before = Number(String(items[i].before).replace(/,/g, ""));
		var after  = Number(String(items[i].after ).replace(/,/g, ""));
		if (!isNaN(before) && !isNaN(after) && after > before) { return true; }
	}
	return false;
}

/* [변경] — 입력 검증 후 반영(또는 결재 상신)으로 넘긴다. */
function doChange(){
	var sel = document.getElementById("st_reason");

	if (sel) {
		if ($.trim(sel.value) == "") {
			alert("변경사유를 선택해 주세요.");
			sel.focus();
			return;
		}
	}

	// 공급상태가 아닌 항목은 상세사유 텍스트가 있어야 한다.
	for (var i = 0; i < items.length; i++) {
		if (items[i].key == "STATUS") { continue; }
		var $txt = $("#rsn_" + items[i].key);
		if ($.trim($txt.val()) == "") {
			alert("[" + items[i].label + "] 의 변경사유를 입력해 주세요.");
			$txt.focus();
			return;
		}
	}

	if (hasPriceUp() && !confirm("매입단가 인상 건으로 품의가 상신됩니다.\n\n진행하시겠습니까?")) { return; }

	doSave();
}

/* 변경 항목을 서버 계약(CHG_KEY|CHG_VALUE|CHG_REASON|CHG_REASON_CODE) 으로 묶는다.
 * 값은 명칭이 아니라 코드(afterCode)를 보낸다 — 이력 JOB_COLUMN 과 어휘가 같아야 한다. */
function buildChangeParam(){
	var names = ["CHG_KEY","CHG_VALUE","CHG_REASON","CHG_REASON_CODE"];
	var p = { s_SAVENAME : names.join("|") };
	var i;
	for (i = 0; i < names.length; i++) { p[names[i]] = []; }

	var sel = document.getElementById("st_reason");

	for (i = 0; i < items.length; i++) {
		var it  = items[i];
		var val = (it.afterCode == null) ? it.after : it.afterCode;
		var rsnTxt = "", rsnCode = "";

		if (it.key == "STATUS") {
			rsnCode = sel ? $.trim(sel.value) : "";
			rsnTxt  = (sel && sel.selectedIndex >= 0) ? sel.options[sel.selectedIndex].text : "";
		} else {
			rsnTxt = $.trim($("#rsn_" + it.key).val() || "");
		}
		if (it.key == "BUY_PRICE") { val = String(val).replace(/,/g, ""); }

		p.CHG_KEY.push(it.key);
		p.CHG_VALUE.push(val);
		p.CHG_REASON.push(rsnTxt);
		p.CHG_REASON_CODE.push(rsnCode);
	}

	p.st_buy_info = BUY_INFO;

	var ctx = {};
	try { ctx = opener.mdcmBuyContext || {}; } catch (e) { ctx = {}; }
	p.st_agent = (ctx.vendorCode == null) ? "" : ctx.vendorCode;
	return p;
}

/* 공통 결재 팝업 호출. PARAM1 = 회사코드, PARAM2 = 상신자(서버가 KEY_2/KEY_3 로 옮긴다). */
function openApproval(pm_no){
	var t = "매입단가 인상 품의 - " + BUY_INFO;
	openSearchPopup("/common/approval/buyerCommonApprovalPop.do"
		, '?DOC_TYPE=SP&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO=' + pm_no
		+ '&PARAM1=' + COM_CODE
		+ '&PARAM2=' + LOGIN_ID
		+ '&st_title=' + t
		+ '&st_cont='
		, "1000,500,no");
}

/* 결재 팝업이 상신을 마치면 이 함수를 부른다(공통 계약). */
function kepApprovalReturn(flag, docu_no){
	alert("품의가 상신되었습니다.");
	self.close();
}

/* 인상 외 항목은 즉시 반영된다. 매입단가 인상이면 서버가 신청을 만들고 PM_NO 를 돌려준다. */
function doSave(){
	loader_obj("Y");
	$.ajax({
		 type		: "POST"
		,url		: "/mdcm/saveMasterMdCmCmsBuyInfoChange.do"
		,headers	: { 'X-Requested-With': 'XMLHttpRequest' }
		,traditional: true
		,data		: buildChangeParam()
		,dataType	: "json"
		,success	: function(res){
			loader_obj("N");
			if (!res || !res.Result || res.Result.Code != 1) {
				alert("구매정보 변경 처리 중 오류가 발생하였습니다.\n\n"
				    + ((res && res.Message) ? res.Message : "관리자에게 문의 바랍니다."));
				return;
			}
			var pm_no = (res.Message == null) ? "" : res.Message;
			if (pm_no != "") {
				/* 매입단가는 결재 대기라 상세 화면에서 되돌린다. */
				reloadOpener(["BUY_PRICE"]);
				openApproval(pm_no);
				return;
			}
			alert("변경 내용이 반영되었습니다.");
			reloadOpener();
			self.close();
		}
		,error		: function(){
			loader_obj("N");
			alert("구매정보 변경 처리 중 오류가 발생하였습니다.\n\n관리자에게 문의 바랍니다.");
		}
	});
}

/* 반영된 항목 수. 결재로 빠지는 매입단가는 이 자리에서 세지 않는다. */
function appliedCount(pending){
	var n = 0;
	for (var i = 0; i < items.length; i++) {
		if ($.inArray(items[i].key, pending) < 0) { n++; }
	}
	return n;
}

/* 상세팝업과 그 밑의 목록을 다시 읽히게 한다.
 * pending = 결재를 타 아직 반영되지 않은 항목 키(매입단가 인상). 상세팝업이 그 칸만 되돌린다. */
function reloadOpener(pending){
	pending = pending || [];
	try {
		if (opener && !opener.closed) {
			if (typeof opener.applySaved == "function") {
				opener.applySaved({ pending : pending, applied : appliedCount(pending)
				                  , date : kepGetNowTimeStr("YYYYMMDD", ""), user : LOGIN_NAME });
			}
			else if (typeof opener.doAction == "function") { opener.doAction("reload"); }
		}
	} catch (e) { }
	try {
		if (opener && opener.opener && !opener.opener.closed
		    && typeof opener.opener.doAction == "function") { opener.opener.doAction("search"); }
	} catch (e) { }
}

</script>

<style>
.guideMsg{ display:block; font-size:13px; color:#444; margin:6px 2px 8px; }
.blockMsg{ display:block; text-align:center; font-size:14px; color:#c0392b; line-height:1.8; margin:24px 10px; }
#popContainer input[type="text"]{ border:1px solid #aaaaaa; background:#fff;
  font-family:"돋움", Dotum, Verdana; font-size:12px; color:#666666;
  height:22px; line-height:22px; padding:0 4px; vertical-align:middle;
  -moz-box-sizing:border-box; box-sizing:border-box; }
#popContainer select{ font-family:"돋움", Dotum, Verdana; font-size:12px; height:22px; vertical-align:middle;
  -moz-box-sizing:border-box; box-sizing:border-box; }
#popContainer .cont_t_list02 td{ padding:4px 6px; }
.reasonTxt{ width:96%; }
</style>

<body onload="kep_onload_view();">
	<div id="popWrapper" style="width:760px;">
		<div id="popHeader">
			<h1 class="title">구매정보코드 상태변경</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">

<% if(isBlocked){ %>
			<!--불가 → 가능 변경 불가 (상품상태가 미사용)-->
			<span class="blockMsg">
				[상품상태] [미사용]으로 확인되어, [공급가능]으로 변경이 불가합니다.<br>
				[상품정보 조회 및 관리화면]에서 [상품상태] [사용]으로 변경 후 진행해주세요.<br><br>
				먼저 [상품정보코드] 사용 변경이 필요합니다.<br>
				[상품정보코드] 사용 변경 이후 진행해주세요.
			</span>
			<div class="btnArea" style="text-align:center; padding:6px 0 14px;">
				<span class="btn_02"><a href="javascript:self.close();">확인</a></span>
			</div>
<% }else{ %>
			<span class="guideMsg">변경 내용 확인 후 사유를 입력해주세요.</span>

			<table class="cont_t_list02" summary="변경항목" style="width:100%">
				<caption>변경항목</caption>
				<colgroup>
					<col width="18%" />
					<col width="20%" />
					<col width="20%" />
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

			<p id="priceApprNote" style="margin:8px 2px 0; color:#555; font-size:12px; line-height:1.6; display:none;">
				※ <b style="color:#c0392b;">매입단가 인상</b>은 [변경] 시 결재가 상신됩니다.
			</p>

			<div class="btnArea mt05" style="text-align:center; padding:10px 0 6px;">
				<span class="btn_02 mr04"><a href="javascript:doChange();">변경</a></span>
				<span class="btn_02"><a href="javascript:self.close();">취소</a></span>
			</div>
<% } %>
			<br>
		</div>
	</div>

	<!--공급상태 행에 꽂을 사유 입력 묶음 (renderItems 가 복제해 쓴다)-->
	<script type="text/html" id="reasonTpl">
		<select id="st_reason" name="st_reason" style="width:60%;">
			<option value="">선택</option>
		</select>
	</script>
</body>
</html>
