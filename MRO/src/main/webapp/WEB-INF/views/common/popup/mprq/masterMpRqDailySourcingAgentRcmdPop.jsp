<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) 지정/추천협력사
* 기능 : 매입가제출 상세의 자동견적대상 추천협력사 수를 눌러 고객사-지정 · 고객사-선호 · 구매팀-통합 협력사를 본다.
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
body{background-color:#fff;}
#popHeader, #popContainer{font-family:'Pretendard', sans-serif;}
#popWrapper #popHeader{height:40px;}
#popHeader h1.title{top:9px; font-size:18px; letter-spacing:0px;}
#popHeader .popClose{top:11px;}
#popContainer{padding:2px 14px 12px 14px;}
.sec-title{height:26px; line-height:26px; margin-top:8px; font-size:14px; font-weight:600; letter-spacing:-0.3px; color:#000;}
.grid-box{height:92px; overflow-y:auto; overflow-x:hidden; border:1px solid #c4c7ce; background-color:#fff; scrollbar-width:thin; scrollbar-color:#acadb3 #ebecf2;}
.grid{width:100%; border-collapse:collapse; table-layout:fixed; font-size:12.5px; color:#1b1b1b;}
.grid th{position:sticky; top:0; height:22px; font-weight:500; letter-spacing:-0.5px; text-align:center; background-color:#e4e5ea; border:1px solid #cbcbcb;}
.grid td{height:22px; padding:0 6px; border:1px solid #e1e1e1; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
.grid td.no{text-align:center; background-color:#f7f7f9;}
.grid td.type{text-align:center;}
.grid td.empty{text-align:center; color:#888888;}
.grid td a{color:#2172EC; text-decoration:none; cursor:pointer;}
</style>
</head>
<body onload="kep_onload_view();">
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">지정/추천협력사</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
	<div id="popContainer">
		<p class="sec-title">고객사-지정협력사</p>
		<div class="grid-box"><table class="grid"><colgroup><col width="40" /><col width="34%" /><col width="*" /></colgroup>
			<thead><tr><th>No</th><th>매핑유형</th><th>협력사</th></tr></thead><tbody id="listAssign"></tbody></table></div>

		<p class="sec-title">고객사-선호협력사</p>
		<div class="grid-box"><table class="grid"><colgroup><col width="40" /><col width="34%" /><col width="*" /></colgroup>
			<thead><tr><th>No</th><th>매핑유형</th><th>협력사</th></tr></thead><tbody id="listPrefer"></tbody></table></div>

		<p class="sec-title">구매팀-통합협력사</p>
		<div class="grid-box"><table class="grid"><colgroup><col width="40" /><col width="34%" /><col width="*" /></colgroup>
			<thead><tr><th>No</th><th>매핑유형</th><th>협력사</th></tr></thead><tbody id="listPool"></tbody></table></div>
	</div>
</div>
<script type="text/javascript">
function kep_onload_view() {
	render("listAssign", []);
	render("listPrefer", []);
	render("listPool", []);
}

function render(id, list) {
	var $b = $("#" + id).empty();
	if (list.length == 0) {
		$b.append("<tr><td class='empty' colspan='3'>조회된 데이터가 없습니다.</td></tr>");
		return;
	}
	for (var i = 0; i < list.length; i++) {
		var r = list[i];
		var $tr = $("<tr>");
		$tr.append($("<td class='no'>").text(i + 1));
		$tr.append($("<td class='type'>").text(r.MAPPING_TYPE_NM));
		$tr.append($("<td>").append($("<a>").text(r.AGENT_NAME + "(" + r.AGENT_CODE + ")").attr("data-code", r.AGENT_CODE).click(function() {
			getAgentDisplayPop($(this).attr("data-code"));
		})));
		$b.append($tr);
	}
}
</script>
</body>
</html>
