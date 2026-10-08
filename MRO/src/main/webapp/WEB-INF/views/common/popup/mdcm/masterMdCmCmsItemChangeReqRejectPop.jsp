<%--
**********************************************
* 메뉴 : 구매대행>상품관리>표준DB관리>상품정보 수정요청 > [반려]
* 화면 : (팝업) 반려사유 기재
* 기능 : 반려사유를 한 번 입력받아 **체크된 요청 전체에 같은 사유**로 적용한다(설계 5p [12]).
*        - 대상 요청번호는 URL 이 아니라 opener.mdcmReqNoList 에 들어 있다.
*          여기서는 건수(st_req_cnt)만 받아 안내에 쓰고, 전송은 opener.submitReject 가 한다.
*        - 순수 입력 팝업이라 라우트는 PopUpViewController 에 둔다.
* 담당자 : 홍준우
* 착수일 : 2026-09-04
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
	String st_req_cnt = CommonUtil.nvl((String) request.getParameter("st_req_cnt"), "0");
%>
<script type="text/javascript">
var REQ_CNT = "<%=st_req_cnt%>";
var MAX_LEN = 1000;		// CMSCATLG_REQ.REJECT_REASON VARCHAR2(1000)

function kep_onload_view(){
	$("#guideCnt").text(REQ_CNT);
	$("#st_reject_reason").focus();
}

/* 확인 — 사유를 검증한 뒤 opener 로 넘긴다.
 * ⚠ 전송은 목록 화면이 한다(opener.submitReject). 팝업이 직접 AJAX 를 쏘면
 *   대상 요청번호 배열(opener.mdcmReqNoList)을 다시 넘겨받아야 해서 두 벌이 된다. */
function doConfirm(){
	var reason = $.trim($("#st_reject_reason").val());

	if (reason == "") {
		alert("반려사유를 입력해 주세요.");
		$("#st_reject_reason").focus();
		return;
	}
	if (reason.length > MAX_LEN) {
		alert("반려사유는 " + MAX_LEN + "자까지 입력할 수 있습니다.\n현재 : " + reason.length + "자");
		$("#st_reject_reason").focus();
		return;
	}

	try {
		opener.submitReject(reason);
	} catch (e) {
		alert("목록 화면을 찾지 못했습니다. 창을 닫고 다시 시도해 주세요.");
		return;
	}
	self.close();
}
</script>

<style>
.guideMsg{ display:block; font-size:13px; color:#444; margin:6px 2px 8px; }
/* ⚠ 팝업 스킨에는 input/textarea CSS 가 없다 — 지정하지 않으면 브라우저 기본 폰트로 뜬다 */
#popContainer textarea{ border:1px solid #aaaaaa; background:#fff;
  font-family:"돋움", Dotum, Verdana; font-size:12px; color:#666666;
  width:100%; height:110px; padding:4px; resize:none;
  -moz-box-sizing:border-box; box-sizing:border-box; }
.lenNote{ display:block; text-align:right; color:#888; font-size:11px; margin-top:2px; }
</style>

<body onload="kep_onload_view();">
	<div id="popWrapper" style="width:500px;">
		<div id="popHeader">
			<h1 class="title">반려사유 입력</h1>
			<p class="popClose"><a href="javascript:self.close()">
				<img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
			</a></p>
		</div>

		<!--팝업내용입니다-->
		<div id="popContainer">
			<span class="guideMsg">선택한 <strong><span id="guideCnt">0</span></strong>건에 아래 사유가 함께 적용됩니다.</span>

			<textarea id="st_reject_reason" name="st_reject_reason" maxlength="1000" placeholder="반려사유를 입력해 주세요."></textarea>
			<span class="lenNote">최대 1,000자</span>

			<div class="btnArea mt05" style="text-align:center; padding:12px 0 6px;">
				<span class="btn_02 mr04"><a href="javascript:doConfirm();">확인</a></span>
				<span class="btn_02"><a href="javascript:self.close();">취소</a></span>
			</div>
			<br>
		</div>
	</div>
</body>
</html>
