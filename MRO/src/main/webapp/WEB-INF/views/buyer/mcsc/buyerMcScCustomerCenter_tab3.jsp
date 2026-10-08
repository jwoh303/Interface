<%--
**********************************************
* 메뉴 : 고객센터 > 내부 공지사항
* 화면 : 내부 공지사항 목록
* 기능 : 고객사 자체 공지사항 (BUYERBOARD) 아코디언 리스트, 관리자 CRUD
* 프로그램 ID : BU0900006
* 담당자 :
* 착수일 : 2026-04-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 검색바 + 새 공지사항 버튼 -->
<div id="intNoticeAdminTop" style="display:none; margin-top:20px; padding-bottom:15px; border-bottom:1px solid #dedede; overflow:hidden;">
	<div style="float:left; display:flex; align-items:center; gap:8px;">
		<div style="display:inline-flex; align-items:center; border:1px solid #dedede; border-radius:6px; height:38px; width:250px; background:#fff;">
			<input type="text" id="intNoticeSearchKeyword" placeholder="검색어를 입력하세요" style="flex:1; padding:0 12px; border:none; outline:none; font-size:14px; background:transparent;" onkeypress="if(event.keyCode==13){fn_internalNoticeSearch(); return false;}" />
			<button type="button" style="width:38px; height:38px; border:none; background:transparent; cursor:pointer;" onclick="fn_internalNoticeSearch();"><img src="/resources/imgs/Search_icon_gray.png" style="width:18px; vertical-align:middle;" /></button>
		</div>
		<button class="ButMSmallDarkGray" style="width:80px; display:none;" onclick="fn_internalNoticeSearch()">조회</button>
	</div>
	<div style="float:right;">
		<button class="ButOutline_Medium" onclick="location.href='/mcsc/showBuyerMcScInternalNoticeWrite.do'" id="newBoardCreate">새 공지사항</button>
	</div>
</div>

<!-- 내부 공지사항 목록 -->
<div class="NoticeSub-container mt20" id="intNoticeContainer">
</div>
<!-- 관리자: 선택 건수 + 삭제 (체크박스 1개 이상 선택 시 뷰포트 하단 고정) -->
<div id="intNoticeAdminBottom" style="display:none; position:fixed; left:0; right:0; bottom:0; z-index:1000; background:#2172ec; border-top:1px solid #1a5fd0; box-shadow:0 -2px 8px rgba(33,114,236,0.25); padding:14px 30px;">
	<div class="right" style="text-align:right; color:#fff;">
		<span class="Number" id="intCheckedCountStr" style="color:#fff; font-weight:600; margin-right:12px;">0건 선택됨</span>
		<button class="ButOutline_Medium" style="background:#fff; color:#2172ec; border-color:#fff;" onclick="fn_deleteInternalNotice()">삭제</button>
	</div>
</div>

<script type="text/javascript">
var intNoticeInitDone = false;

function fn_internalNoticeInit() {
	if (intNoticeInitDone) return;
	intNoticeInitDone = true;

	// 관리자 UI 표시 (하단 선택 바는 체크 시에만 표시되므로 여기선 상단만 노출)
	if (g_isAdmin === 'Y') {
		document.getElementById('intNoticeAdminTop').style.display = 'block';
	}else{
		document.getElementById('newBoardCreate').style.display = 'none';
		
	}

	fn_internalNoticeSearch();
}

/* 내부 공지사항 조회 */
function fn_internalNoticeSearch() {
	jQuery.ajax({
		url: '/mcsc/getBuyerInternalNoticeListJson.do',
		type: 'POST',
		data: { st_byca_comorg_code: g_bycaComorgCode, st_keyword: jQuery('#intNoticeSearchKeyword').val() || '' },
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				fn_renderIntNoticeList(result.data || []);
			} else {
				alert(result.message || '조회 중 오류가 발생했습니다.');
			}
		},
		error: function() {
			alert('조회 중 오류가 발생했습니다.');
		}
	});
}

/* 내부 공지사항 목록 렌더링 */
function fn_renderIntNoticeList(data) {
	var container = document.getElementById('intNoticeContainer');

	if (!data || data.length === 0) {
		container.innerHTML = '<div class="ChatWarning"><img src="/resources/imgs/Icon_Warning01.png"/><br/>내부 공지사항이 없습니다.</div>';
		if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh(3);
		return;
	}

	var isAdmin = (g_isAdmin === 'Y');
	var html = '';

	for (var i = 0; i < data.length; i++) {
		var d = data[i];
		var readYn = d.READ_YN || 'N';
		var newIcon = (readYn === 'N') ? '<img src="/resources/imgs/seller_new.png" class="new-icon" style="margin-right:5px;vertical-align:middle;" />' : '';

		html += '<div class="NoticeSub-item" data-bid="' + d.BID + '" data-read="' + readYn + '">';
		html += '  <button class="NoticeSub-question">';
		html += '    <table width="100%"><tr>';

		if (isAdmin) {
			html += '      <td width="50px" style="text-align:center;"><label class="CheckLargeLabel"><input type="checkbox" class="int-notice-checkbox" value="' + d.BID + '" onchange="fn_updateIntCheckedCount()" onclick="event.stopPropagation();" /><span class="CheckLargeCustom"></span></label></td>';
		}

		html += '      <td width="*">' + newIcon + (d.SUBJECT || '') + '</td>';
		html += '      <td width="100px" style="text-align:right;">' + (d.REG_DATE_DIS || '') + '</td>';
		html += '    </tr></table>';
		html += '    <span class="NoticeSubarrow"><img src="/resources/imgs/arrow_down.png" /></span>';
		html += '  </button>';
		html += '  <div class="NoticeSub-answer">';
		html += '    <div style="text-align:right; padding-bottom:10px; margin-bottom:10px;">';
		html += '      <span style="color:#888; font-size:13px;">작성자 : ' + (d.USER_NAME_LOC || '') + ' | 게시기간 : ' + (d.FROM_DATE_DIS || '') + ' ~ ' + (d.TO_DATE_DIS || '') + '</span>';
		html += '    </div>';
		html += '    <table width="100%">';
		html += '      <tr><td><div class="notice-content">' + (d.CONTEXT || '') + '</div></td></tr>';
		html += '      <tr>';
		html += '        <td style="padding-top:15px;">';

		if (d.IMAGE_KEY && d.IMAGE_KEY !== '') {
			html += '          <button class="ButDownload_Tiny_Outline" style="margin-left:15px;" onclick="fn_intNoticeFileDown(\'' + d.IMAGE_KEY + '\')">첨부파일</button>';
		}

		if (d.REG_USER_ID && d.REG_USER_ID === g_userId) {
			html += '          <button class="ButOutline_Small" style="float:right;" onclick="location.href=\'/mcsc/showBuyerMcScInternalNoticeWrite.do?st_bid=' + d.BID + '\'">수정하기</button>';
		}

		html += '        </td>';
		html += '      </tr>';
		html += '    </table>';
		html += '  </div>';
		html += '</div>';
	}

	container.innerHTML = html;
	fn_bindIntNoticeAccordion();
	fn_updateIntCheckedCount();
	if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh(3);
}

/* 아코디언 바인딩 + 읽음 처리 */
function fn_bindIntNoticeAccordion() {
	var items = document.querySelectorAll('#intNoticeContainer .NoticeSub-item');
	items.forEach(function(item) {
		var question = item.querySelector('.NoticeSub-question');
		var answer = item.querySelector('.NoticeSub-answer');
		question.addEventListener('click', function(e) {
			if (e.target.closest('.CheckLargeLabel')) return;
			if (item.classList.contains('active')) {
				answer.style.maxHeight = null;
				item.classList.remove('active');
			} else {
				answer.style.maxHeight = answer.scrollHeight + 'px';
				item.classList.add('active');

				if (item.getAttribute('data-read') === 'N') {
					var bid = item.getAttribute('data-bid');
					var newIconEl = item.querySelector('.new-icon');
					if (newIconEl) newIconEl.style.display = 'none';
					item.setAttribute('data-read', 'Y');
					if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh(3);
					fn_markInternalNoticeAsRead(bid);
				}
			}
		});
	});
}

/* 읽음 처리 */
function fn_markInternalNoticeAsRead(bid) {
	jQuery.ajax({
		url: '/mcsc/markBuyerInternalNoticeAsRead.do',
		type: 'POST',
		data: { bid: bid },
		dataType: 'json'
	});
}

/* 첨부파일 다운로드 */
function fn_intNoticeFileDown(imageKey) {
	if (!imageKey || imageKey === '') return;
	var iframe = document.getElementById('intNoticeDownFrame');
	if (!iframe) {
		iframe = document.createElement('iframe');
		iframe.id = 'intNoticeDownFrame';
		iframe.style.display = 'none';
		document.body.appendChild(iframe);
	}
	iframe.src = '/common/download_v2.do?DOC_NO=' + imageKey;
}

/* 관리자: 선택 건수 업데이트 + 하단 바 노출 제어 */
function fn_updateIntCheckedCount() {
	var cnt = document.querySelectorAll('.int-notice-checkbox:checked').length;
	document.getElementById('intCheckedCountStr').innerHTML = cnt + '건 선택됨';
	var bar = document.getElementById('intNoticeAdminBottom');
	if (bar) bar.style.display = (g_isAdmin === 'Y' && cnt > 0) ? 'block' : 'none';
}

/* 관리자: 선택 삭제 */
function fn_deleteInternalNotice() {
	var checked = document.querySelectorAll('.int-notice-checkbox:checked');
	if (checked.length === 0) {
		alert('삭제할 공지사항을 선택해 주세요.');
		return;
	}
	if (!confirm('선택한 공지사항을 삭제하시겠습니까?')) return;

	var bids = [];
	checked.forEach(function(chk) { bids.push(chk.value); });

	jQuery.ajax({
		url: '/mcsc/deleteBuyerInternalNoticeJson.do',
		type: 'POST',
		data: { BID: bids.join(','), st_byca_comorg_code: g_bycaComorgCode },
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				alert('선택하신 공지사항이 삭제되었습니다.');
				var bar = document.getElementById('intNoticeAdminBottom');
				if (bar) bar.style.display = 'none';
				document.getElementById('intCheckedCountStr').innerHTML = '0건 선택됨';
				fn_internalNoticeSearch();
			} else {
				alert(result.message || '삭제에 실패했습니다.');
			}
		},
		error: function() {
			alert('삭제 중 오류가 발생했습니다.');
		}
	});
}
</script>
