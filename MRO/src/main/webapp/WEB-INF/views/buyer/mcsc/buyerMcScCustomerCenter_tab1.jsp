<%--
**********************************************
* 메뉴 : 고객센터 > 1:1 문의
* 화면 : VOC 문의 목록
* 기능 : KEPAVCDT 기반 VOC 조회, 아코디언 상세
* 프로그램 ID : BU0900002
* 담당자 :
* 착수일 : 2026-04-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!-- 조회 조건 -->
<table class="ChatSearchTable mt20">
	<colgroup>
		<col width="80px" />
		<col width="500px" />
		<col width="60px" />
		<col width="240px" />
		<col width="60px" />
		<col width="230px" />
		<col width="110px" />
	</colgroup>
	<tr>
		<th height="70px">요청일자</th>
		<td>
			<div class="Buyer-datepicker-wrap" style="width:231px; margin-right:8px">
				<div class="Buyer-date-input" data-datepicker><input type="text" id="inq_from_date" placeholder="" readonly /><span></span></div>
				<span class="Buyer-dash">~</span>
				<div class="Buyer-date-input" data-datepicker><input type="text" id="inq_to_date" placeholder="" readonly /><span></span></div>
			</div>
			<button class="But_Month" style="width:50px" onclick="kepMonth_v2('inq_from_date','inq_to_date','1'); return false;">1개월</button>
			<button class="But_Month" style="width:50px" onclick="kepMonth_v2('inq_from_date','inq_to_date','3'); return false;">3개월</button>
			<button class="But_Month" style="width:50px" onclick="kepMonth_v2('inq_from_date','inq_to_date','6'); return false;">6개월</button>
			<button class="But_Month" style="width:50px" onclick="kepMonth_v2('inq_from_date','inq_to_date','12'); return false;">12개월</button>
		</td>
		<th>유형</th>
		<td>
			<select id="inq_claim_master" class="Select" style="width:210px">
				<option value="ALL">전체</option>
			</select>
		</td>
		<th>진행상태</th>
		<td>
			<select id="inq_recv_flag" class="Select" style="width:210px">
				<option value="ALL">전체</option>
				<option value="DC">답변대기</option>
				<option value="CX">문의취소</option>
				<option value="FB">답변완료</option>
			</select>
		</td>
		<td><button class="ButMSmallDarkGray" style="width:80px" onclick="fn_inquirySearch()">조회</button></td>
	</tr>
</table>

<!-- 문의 목록 -->
<div class="Chat-container" id="inquiryContainer">
</div>

<!-- 빈 목록 안내 -->
<div class="ChatWarning" id="inquiryEmpty" style="display:none;">
	<img src="/resources/imgs/Icon_Warning01.png"/><br/>등록하신 문의가 없습니다.
</div>

<div class="h30"></div>
<div class="ac">
	<button class="Butchat" onclick="location.href='/mcsc/showBuyerMcScInquiryWrite.do'">1:1 문의하기</button>
</div>

<script type="text/javascript">
var inquiryInitDone = false;

function fn_inquiryInit() {
	if (inquiryInitDone) return;
	inquiryInitDone = true;

	// VOC 유형 코드 로드
	fn_loadClaimMasterList();

	// 기본 1개월 날짜 설정
	kepMonth_v2('inq_from_date', 'inq_to_date', '1');

	// 조회
	fn_inquirySearch();
}

/* VOC 유형 코드 로드 */
function fn_loadClaimMasterList() {
	jQuery.ajax({
		url: '/mcsc/getBuyerQtypeCodeListJson.do',
		type: 'POST',
		dataType: 'json',
		success: function(result) {
			if (result.success && result.data) {
				var sel = document.getElementById('inq_claim_master');
				for (var i = 0; i < result.data.length; i++) {
					var opt = document.createElement('option');
					opt.value = result.data[i].CODE;
					opt.text = result.data[i].CODE_NAME;
					sel.appendChild(opt);
				}
			}
		}
	});
}

/* 문의 목록 조회 */
function fn_inquirySearch() {
	var param = {
		st_from_date: document.getElementById('inq_from_date').value,
		st_to_date: document.getElementById('inq_to_date').value,
		st_claim_master: document.getElementById('inq_claim_master').value,
		st_recv_flag: document.getElementById('inq_recv_flag').value
	};

	jQuery.ajax({
		url: '/mcsc/getBuyerInquiryListJson.do',
		type: 'POST',
		data: param,
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				fn_renderInquiryList(result.data || []);
			} else {
				alert(result.message || '조회 중 오류가 발생했습니다.');
			}
		},
		error: function() {
			alert('조회 중 오류가 발생했습니다.');
		}
	});
}

/* 문의 목록 렌더링 */
function fn_renderInquiryList(data) {
	var container = document.getElementById('inquiryContainer');
	var emptyDiv = document.getElementById('inquiryEmpty');

	if (!data || data.length === 0) {
		container.innerHTML = '';
		emptyDiv.style.display = 'block';
		if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh(1);
		return;
	}
	emptyDiv.style.display = 'none';

	var html = '';
	for (var i = 0; i < data.length; i++) {
		var d = data[i];
		var isCompleted = (d.RECV_FLAG === 'FB');
		var isCancelled = (d.RECV_FLAG === 'CX');
		var readYn = d.READ_YN || 'Y'; // 미답변/취소는 N 아이콘 없음
		var newIcon = (readYn === 'N') ? '<img src="/resources/imgs/seller_new.png" class="new-icon" style="margin-right:5px;vertical-align:middle;" />' : '';
		var attachBtn = (d.REQ_IMAGE_KEY && d.REQ_IMAGE_KEY !== '')
			? '<button class="ButDownload_Tiny_Outline"  onclick="event.stopPropagation(); fn_inquiryFileDown(\'' + d.REQ_IMAGE_KEY + '\')">첨부파일</button>'
			: '';
		var answerAttachBtn = (d.FEEDBACK_IMAGE_KEY && d.FEEDBACK_IMAGE_KEY !== '')
			? '<button class="ButDownload_Tiny_Outline" style="margin-left:10px;" onclick="event.stopPropagation(); fn_inquiryFileDown(\'' + d.FEEDBACK_IMAGE_KEY + '\')">첨부파일</button>'
			: '';

		// 진행상태 텍스트 매핑: 답변대기 / 문의취소 / 답변완료
		var statusText = '답변대기';
		var statusStyle = '';
		if (isCompleted) {
			statusText = '답변완료';
			statusStyle = ' style="color:#2172ec"';
		} else if (isCancelled) {
			statusText = '문의취소';
			statusStyle = ' style="color:#888"';
		}

		html += '<div class="Chat-item" data-vcno="' + d.VC_NO + '" data-read="' + readYn + '">';
		html += '  <button class="Chat-question">';
		html += '    <table width="100%"><tr>';
		html += '      <th width="100px">' + newIcon + '<span' + statusStyle + '>' + statusText + '</span></th>';
		html += '      <td width="80px">' + (d.CLAIM_TEXT || '') + '</td>';
		html += '      <td width="*">' + (d.REQ_REMARK || '').substring(0, 60) + '</td>';
		html += '      <td width="100px">' + (d.REQ_DATE_DIS || '') + '</td>';
		html += '    </tr></table>';
		html += '    <span class="Chatarrow"><img src="/resources/imgs/arrow_down.png" /></span>';
		html += '  </button>';
		html += '  <div class="Chat-answer">';

		if (isCompleted) {
			// 답변완료 (FB): 요청내역 + Kepanswer 답변 영역
			html += '    <table width="100%">';
			html += '      <tr>';
			html += '        <td width="180px"></td>';
			html += '        <td width="*" style="white-space:pre-wrap;">' + (d.REQ_REMARK || '') + '</td>';
			html += '      </tr>';
			if (attachBtn) {
				html += '      <tr><td></td><td>' + attachBtn + '</td></tr>';
			}
			html += '      <tr>';
			html += '        <td></td>';
			html += '        <td style="padding-right:80px">';
			html += '          <table width="100%" class="Kepanswer">';
			html += '            <tr>';
			html += '              <td width="50px"><span class="ChipsRound_Blue">답변</span></td>';
			html += '              <td width="*" style="white-space:pre-wrap;">' + (d.DF_REMARK || '') + '</td>';
			html += '              <td width="100px" style="text-align:right">' + (d.DF_DATE_DIS || '') + '</td>';
			html += '            </tr>';
			if (answerAttachBtn) {
				html += '            <tr><td style="border-top:none !important; padding-top:0 !important;"></td><td colspan="2" style="border-top:none !important; padding-top:0 !important;">' + answerAttachBtn + '</td></tr>';
			}
			html += '            <tr>';
			html += '              <td></td>';
			html += '              <td colspan="2" class="NewChat">문의에 대한 답변이 부족하거나 추가문의사항이 있으시면 새로운 문의사항으로 등록해주세요 ';
			html += '                <button type="button" class="ButMSmallDarkGray" onclick="event.stopPropagation(); location.href=\'/mcsc/showBuyerMcScInquiryWrite.do\';">새로운 문의하기</button>';
			html += '              </td>';
			html += '            </tr>';
			html += '          </table>';
			html += '        </td>';
			html += '      </tr>';
			html += '    </table>';
		} else if (isCancelled) {
			// 문의취소 (CX): 요청내역만 표시
			html += '    <table width="100%">';
			html += '      <tr>';
			html += '        <td width="100px"></td>';
			html += '        <td width="80px"></td>';
			html += '        <td width="*" style="white-space:pre-wrap;">' + (d.REQ_REMARK || '') + '</td>';
			html += '      </tr>';
			if (attachBtn) {
				html += '      <tr><td></td><td></td><td>' + attachBtn + '</td></tr>';
			}
			html += '    </table>';
		} else {
			// 답변대기 (DC, PS, PA): 요청내역 + 첨부파일(있으면) + 문의취소하기 버튼(DC만)
			html += '    <table width="100%">';
			html += '      <tr>';
			html += '        <td width="100px"></td>';
			html += '        <td width="80px"></td>';
			html += '        <td width="*" style="white-space:pre-wrap;">' + (d.REQ_REMARK || '') + '</td>';
			html += '      </tr>';
			if (attachBtn) {
				html += '      <tr><td></td><td></td><td>' + attachBtn + '</td></tr>';
			}
			if (d.RECV_FLAG === 'DC') {
				html += '      <tr>';
				html += '        <td></td>';
				html += '        <td></td>';
				html += '        <td valign="bottom"><button type="button" class="ChipsDefault_Gray" style="cursor:pointer;" onclick="event.stopPropagation(); fn_cancelInquiry(\'' + d.VC_NO + '\');">문의취소하기</button></td>';
				html += '      </tr>';
			}
			html += '    </table>';
		}

		html += '  </div>';
		html += '</div>';
	}

	container.innerHTML = html;
	fn_bindInquiryAccordion();
	if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh(1);
}

/* 문의 취소 */
function fn_cancelInquiry(vcNo) {
	if (!confirm('해당 문의를 취소하시겠습니까?')) return;
	jQuery.ajax({
		url: '/mcsc/cancelBuyerInquiryJson.do',
		type: 'POST',
		data: { st_vc_no: vcNo },
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				alert('문의가 취소되었습니다.');
				fn_inquirySearch();
			} else {
				alert(result.message || '취소 중 오류가 발생했습니다.');
			}
		},
		error: function() {
			alert('취소 중 오류가 발생했습니다.');
		}
	});
}

/* 아코디언 바인딩 + 답변 확인 처리 */
function fn_bindInquiryAccordion() {
	var items = document.querySelectorAll('#inquiryContainer .Chat-item');
	items.forEach(function(item) {
		var question = item.querySelector('.Chat-question');
		var answer = item.querySelector('.Chat-answer');
		question.addEventListener('click', function() {
			if (item.classList.contains('active')) {
				answer.style.maxHeight = null;
				item.classList.remove('active');
			} else {
				answer.style.maxHeight = answer.scrollHeight + 'px';
				item.classList.add('active');
				setTimeout(function() {
					answer.style.maxHeight = answer.scrollHeight + 'px';
				}, 300);

				// 답변 미확인 시 읽음 처리 (답변완료 + READ_YN='N' 인 항목만)
				if (item.getAttribute('data-read') === 'N') {
					var vcNo = item.getAttribute('data-vcno');
					var newIconEl = item.querySelector('.new-icon');
					if (newIconEl) newIconEl.style.display = 'none';
					item.setAttribute('data-read', 'Y');
					if (window.MROBuyerNoticeTabIndicator) MROBuyerNoticeTabIndicator.refresh(1);
					fn_markInquiryAsRead(vcNo);
				}
			}
		});
	});
}

/* 답변 확인 처리 */
function fn_markInquiryAsRead(vcNo) {
	jQuery.ajax({
		url: '/mcsc/markBuyerInquiryAsRead.do',
		type: 'POST',
		data: { st_vc_no: vcNo },
		dataType: 'json'
	});
}

/* 첨부파일 다운로드 (내부 공지사항과 동일 패턴 - file_attach 업로드와 호환) */
function fn_inquiryFileDown(imageKey) {
	if (!imageKey || imageKey === '') return;
	var iframe = document.getElementById('inquiryDownFrame');
	if (!iframe) {
		iframe = document.createElement('iframe');
		iframe.id = 'inquiryDownFrame';
		iframe.style.display = 'none';
		document.body.appendChild(iframe);
	}
	iframe.src = '/common/download_v2.do?DOC_NO=' + imageKey;
}
</script>
