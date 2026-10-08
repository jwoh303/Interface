<%--
**********************************************
* 메뉴 : 고객센터 > 공지사항
* 화면 : 공지사항 목록 (운영사 공지 - 조회 전용)
* 기능 : 공지사항 아코디언 리스트, 읽음 추적
* 프로그램 ID : BU0900004
* 담당자 :
* 착수일 : 2026-04-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 검색바 + 조회 버튼 -->
<div style="margin-top:20px; padding-bottom:15px; border-bottom:1px solid #dedede; display:flex; align-items:center; gap:8px;">
	<div style="display:inline-flex; align-items:center; border:1px solid #dedede; border-radius:6px; height:38px; width:250px; background:#fff;">
		<input type="text" id="noticeSearchKeyword" placeholder="검색어를 입력하세요" style="flex:1; padding:0 12px; border:none; outline:none; font-size:14px; background:transparent;" onkeypress="if(event.keyCode==13){fn_noticeSearch(); return false;}" />
		<button type="button" style="width:38px; height:38px; border:none; background:transparent; cursor:pointer;" onclick="fn_noticeSearch();"><img src="/resources/imgs/Search_icon_gray.png" style="width:18px; vertical-align:middle;" /></button>
	</div>
	<button class="ButMSmallDarkGray" style="width:80px; display:none;" onclick="fn_noticeSearch()">조회</button>
</div>

<!-- 공지사항 목록 -->
<div class="NoticeSub-container mt20" id="noticeContainer">
</div>

<script type="text/javascript">
var noticeInitDone = false;

function fn_noticeInit() {
	if (noticeInitDone) return;
	noticeInitDone = true;
	fn_noticeSearch();
}

/* 공지사항 조회 (전체+거래사별 합산) */
function fn_noticeSearch() {
	jQuery.ajax({
		url: '/mcsc/getBuyerNoticeListJson.do',
		type: 'POST',
		data: { st_keyword: jQuery('#noticeSearchKeyword').val() || '' },
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				fn_renderNoticeList(result.data || []);
			} else {
				alert(result.message || '조회 중 오류가 발생했습니다.');
			}
		},
		error: function() {
			alert('조회 중 오류가 발생했습니다.');
		}
	});
}

/* 공지사항 목록 렌더링 */
function fn_renderNoticeList(data) {
	var container = document.getElementById('noticeContainer');

	if (!data || data.length === 0) {
		container.innerHTML = '<div class="ChatWarning"><img src="/resources/imgs/Icon_Warning01.png"/><br/>공지사항이 없습니다.</div>';
		if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh();
		return;
	}

	var html = '';

	for (var i = 0; i < data.length; i++) {
		var d = data[i];
		var readYn = d.READ_YN || 'N';
		var newIcon = (readYn === 'N') ? '<img src="/resources/imgs/seller_new.png" class="new-icon" style="margin-right:5px;vertical-align:middle;" />' : '';

		html += '<div class="NoticeSub-item" data-bid="' + d.BID + '" data-btype="' + (d.BTYPE || 'NT') + '" data-read="' + readYn + '">';
		html += '  <button class="NoticeSub-question">';
		html += '    <table width="100%"><tr>';
		html += '      <td width="*">' + newIcon + (d.IMPORTANT_FLAG === 'Y' ? '<span style="color:#e74c3c; font-weight:bold;">[중요] </span>' : '') + (d.SUBJECT || '') + '</td>';
		html += '      <td width="100px" style="text-align:right;">' + (d.REG_DATE_DIS || '') + '</td>';
		html += '    </tr></table>';
		html += '    <span class="NoticeSubarrow"><img src="/resources/imgs/arrow_down.png" /></span>';
		html += '  </button>';
		html += '  <div class="NoticeSub-answer">';
		html += '    <table width="100%">';
		html += '      <tr><td><div class="notice-content">' + fn_escapeAndBr(d.CONTEXT) + '</div></td></tr>';
		html += '      <tr>';
		html += '        <td style="padding-top:15px;">';
		html += '          <span style="color:#888;">작성자 : ' + (d.COM_NAME_LOC || '') + '</span>';

		if (d.IMAGE_KEY && d.IMAGE_KEY !== '') {
			html += '          <button class="ButDownload_Tiny_Outline" style="margin-left:15px;" onclick="fn_noticeFileDown(\'' + d.IMAGE_KEY + '\')"><img src="/resources/imgs/Icon_Download.png" style="vertical-align:middle;" /> 첨부파일</button>';
		}

		html += '        </td>';
		html += '      </tr>';
		html += '    </table>';
		html += '  </div>';
		html += '</div>';
	}

	container.innerHTML = html;
	fn_bindNoticeAccordion();
	if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh();
}

/* 아코디언 바인딩 + 읽음 처리 */
function fn_bindNoticeAccordion() {
	var items = document.querySelectorAll('#noticeContainer .NoticeSub-item');
	items.forEach(function(item) {
		var question = item.querySelector('.NoticeSub-question');
		var answer = item.querySelector('.NoticeSub-answer');
		question.addEventListener('click', function() {
			if (item.classList.contains('active')) {
				answer.style.maxHeight = null;
				item.classList.remove('active');
			} else {
				answer.style.maxHeight = answer.scrollHeight + 'px';
				item.classList.add('active');

				// 읽음 처리
				var bid = item.getAttribute('data-bid');
				var btype = item.getAttribute('data-btype');

				if (item.getAttribute('data-read') === 'N') {
					var newIconEl = item.querySelector('.new-icon');
					if (newIconEl) newIconEl.style.display = 'none';
					item.setAttribute('data-read', 'Y');
					if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh();
					fn_markNoticeAsRead(bid, btype);
				}
			}
		});
	});
}

/* 읽음 처리 */
function fn_markNoticeAsRead(bid, btype) {
	jQuery.ajax({
		url: '/mcsc/markBuyerNoticeAsRead.do',
		type: 'POST',
		data: { bid: bid, btype: btype },
		dataType: 'json'
	});
}

/* 첨부파일 다운로드 */
function fn_noticeFileDown(imageKey) {
	if (!imageKey || imageKey === '') return;
	var type = 'BO';
	var viewType = 'R';
// 	kepFileUploadOpenPopup(imageKey, type, viewType);
	var src = '/common/fileUploadPop_v2.do?DOC_NO='+imageKey+'&viewType='+viewType+'&TYPE='+type;
	openLayerPop(src,"600px","510px");
}
function fn_escapeAndBr(text) {
	if (!text) return '';
	var div = document.createElement('div');
	div.textContent = text;
	var escaped = div.innerHTML;
	return escaped.replace(/\r\n|\n|\r/g, '<br/>');
}
</script>
