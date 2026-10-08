<%--
**********************************************
* 메뉴 : 구매대행>견적관리>데일리소싱(구매)
* 화면 : (팝업) TR취급불가 상세기준
* 기능 : 매입가제출 상세의 TR 취급가능여부 [참고] 버튼에서 여는 기준표.
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
#popContainer{padding:6px 14px 12px 14px;}
.sec-title{height:26px; line-height:26px; font-size:14px; font-weight:600; letter-spacing:-0.3px; color:#000;}
.grid{width:100%; border-collapse:collapse; table-layout:fixed; font-size:12.5px; color:#1b1b1b; border:2px solid #c4c7ce;}
.grid th{height:24px; font-weight:500; letter-spacing:-0.5px; text-align:center; background-color:#e4e5ea; border:1px solid #cbcbcb;}
.grid td{height:24px; padding:0 6px; text-align:center; border:1px solid #e1e1e1; white-space:nowrap;}
.grid td.no{background-color:#f7f7f9;}
.grid tr.warn td{color:#F6495F;}
</style>
</head>
<body>
<div id="popWrapper">
	<div id="popHeader"><h1 class="title">참고</h1><p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p></div>
	<div id="popContainer">
		<p class="sec-title">TR취급불가 상세기준</p>
		<table class="grid">
			<colgroup><col width="36" /><col width="46%" /><col width="*" /></colgroup>
			<tr><th></th><th>취급불가유형</th><th>상세기준</th></tr>
			<tr><td class="no">1</td><td>중량물</td><td>18kg 초과</td></tr>
			<tr><td class="no">2</td><td>부피물</td><td>L4200*W1800*H1800</td></tr>
			<tr><td class="no">3</td><td>장축물</td><td>한면 2m 초과</td></tr>
			<tr class="warn"><td class="no">4</td><td>극냉동-시약</td><td>-40℃ ~ -86℃</td></tr>
			<tr class="warn"><td class="no">5</td><td>위험물/유해화학물질</td><td>기준 별도 확인</td></tr>
			<tr><td class="no">6</td><td>파손주의품</td><td>유리/전자제품 등</td></tr>
			<tr><td class="no">7</td><td>고가품</td><td>500만원 이상</td></tr>
			<tr><td class="no">8</td><td>설치/수리품</td><td>설치/수리 등 추가 인건비 포함</td></tr>
		</table>
	</div>
</div>
</body>
</html>
