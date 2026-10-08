<%--
**********************************************
* 메뉴 : 고객센터 > 내부 공지사항 등록/수정
* 화면 : 내부 공지사항 등록/수정
* 기능 : 관리자 내부 공지사항 등록/수정 폼 (BUYERBOARD)
* 프로그램 ID : BU0900007
* 담당자 :
* 착수일 : 2026-04-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head_v2.jspf" %>
<!-- TOAST UI Editor -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>
<style>
/* MonthNew.js 달력이 TOAST UI Editor 위에 표시되도록 z-index 보정 */
#calendarContainer { z-index: 9999 !important; }
/* 레이어 팝업 모서리 흰색 제거 */
.DIVLayerPopup { overflow: hidden; }
</style>
</head>
<%
String mode = CommonUtil.nvl((String) request.getAttribute("mode"), "write");
boolean isEditMode = "edit".equals(mode);
Map detail = null;
String bid = "";
if (isEditMode) {
	detail = (Map) request.getAttribute("detail");
	if (detail != null) {
		bid = String.valueOf(detail.get("BID"));
	}
}

String bycaComorgCode = "";
if (_sessionInfo != null) {
	bycaComorgCode = CommonUtil.nvl(_sessionInfo.getBycaComorgCode());
}
%>
<body onload="kep_onload_view()">
<script>
var isEditMode = <%=isEditMode%>;
var editor;

/* TOAST UI Editor 정렬 툴바 버튼 팩토리 */
function alignToolbarItem(dir) {
	var label = { left: '왼쪽 정렬', center: '가운데 정렬', right: '오른쪽 정렬' }[dir];
	var icon  = { left: '◧',         center: '▤',          right: '◨'          }[dir];
	var btn = document.createElement('button');
	btn.type = 'button';
	btn.className = 'toastui-editor-toolbar-icons';
	btn.style.cssText = 'background-image:none;width:32px;height:32px;padding:0;margin:0;display:inline-flex;align-items:center;justify-content:center;font-size:22px;font-weight:bold;line-height:1;';
	btn.innerHTML = '<span style="display:block;line-height:1;">' + icon + '</span>';
	btn.addEventListener('click', function() {
		editor.exec('align' + dir.charAt(0).toUpperCase() + dir.slice(1));
	});
	return { name: 'align-' + dir, tooltip: label, el: btn };
}

/* TOAST UI Editor WYSIWYG 정렬 커스텀 커맨드 플러그인 */
function alignPlugin() {
	function makeCmd(align) {
		return function(payload, state, dispatch) {
			var tr = state.tr;
			state.doc.nodesBetween(state.selection.from, state.selection.to, function(node, pos) {
				if (node.type.name === 'paragraph' || node.type.name === 'heading') {
					var attrs = Object.assign({}, node.attrs, { htmlAttrs: { style: 'text-align:' + align } });
					tr.setNodeMarkup(pos, null, attrs);
				}
			});
			if (tr.docChanged) { dispatch(tr); return true; }
			return false;
		};
	}
	return {
		wysiwygCommands: {
			alignLeft:   makeCmd('left'),
			alignCenter: makeCmd('center'),
			alignRight:  makeCmd('right')
		}
	};
}

function kep_onload_view() {
	/* 게시기간 기본값 설정 (buyerMpSoOrderProgress_tab1 패턴) */
	if (!isEditMode) {
		$("#FROM_DATE").val(kepGetNowTimeStr('YYYYMMDD','/'));
		$("#TO_DATE").val(kepToMonthAdd("1","P"));
	} else {
		/* 수정모드: 서버 포맷(YYYY.MM.DD)을 MonthNew.js 포맷(YYYY/MM/DD)으로 변환 */
		var fromVal = $("#FROM_DATE").val();
		var toVal = $("#TO_DATE").val();
		if (fromVal) $("#FROM_DATE").val(fromVal.replace(/\./g, '/'));
		if (toVal) $("#TO_DATE").val(toVal.replace(/\./g, '/'));
	}

	editor = new toastui.Editor({
		el: document.querySelector('#editor'),
		height: '400px',
		initialEditType: 'wysiwyg',
		previewStyle: 'vertical',
		language: 'ko-KR',
		plugins: [alignPlugin],
		toolbarItems: [
			['heading', 'bold', 'italic', 'strike'],
			['hr', 'quote'],
			['ul', 'ol', 'task'],
			[alignToolbarItem('left'), alignToolbarItem('center'), alignToolbarItem('right')],
			['table', 'image', 'link'],
			['code', 'codeblock'],
			['scrollSync']
		],
		hooks: {
			addImageBlobHook: function(blob, callback) {
				var formData = new FormData();
				formData.append('files', blob);
				formData.append('TYPE', 'BO');

				jQuery.ajax({
					url: '/common/fileUploadAjax_v2.do',
					type: 'POST',
					data: formData,
					processData: false,
					contentType: false,
					dataType: 'json',
					success: function(res) {
						if (res.result === 'U') {
							var imgUrl = '/common/download_v2.do?DOC_NO=' + res.docNo;
							callback(imgUrl, blob.name || 'image');
						} else {
							alert(res.message || '이미지 업로드에 실패했습니다.');
						}
					},
					error: function() {
						alert('이미지 업로드 중 오류가 발생했습니다.');
					}
				});
			}
		}
	});

	/* 수정모드: AJAX로 기존 내용 로드 (base64 이미지 등 대용량 HTML 대응) */
	if (isEditMode) {
		jQuery.ajax({
			url: '/mcsc/getBuyerInternalNoticeDetailJson.do',
			type: 'POST',
			data: { BID: document.getElementById('BID').value, st_byca_comorg_code: document.getElementById('st_byca_comorg_code').value },
			dataType: 'json',
			success: function(res) {
				if (res.success && res.data && res.data.CONTEXT) {
					editor.setHTML(res.data.CONTEXT);
				}
			}
		});
	}
}
</script>
<div id="wrapper">
	<c:import charEncoding="utf-8" url="/menu/menu.do">
		<c:param name="page" value="buyerHeader_v2"/>
		<c:param name="part" value="buyerHeader_v2"/>
	</c:import>
	<div id="container2">
		<div class="container">
			<!-- 고객센터 타이틀 -->
			<div class="SVCTitBox mt30">
				<div class="SVCTit">고객센터</div>
				<form class="SVCSearch" onsubmit="return false;">
					<input type="text" placeholder="검색" style="width:75%;">
					<button type="button">고객사검색버튼</button>
				</form>
				<button class="Butchat" onclick="location.href='/mcsc/showBuyerMcScInquiryWrite.do'">1:1 문의하기</button>
			</div>
			<div class="SVCTab mt30">
				<div style="border-bottom:1px solid #2172ec;" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=1'">1:1 문의</div>
				<div style="border-bottom:1px solid #2172ec;" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=2'">공지사항</div>
				<div style="border:1px solid #2172ec;border-bottom:0px solid #2172ec; background-color:#fff; color:#2172ec;">내부 공지사항</div>
			</div>

			<h4 class="mt20" style="font-size:16px; font-weight:bold;">
				<%=isEditMode ? "내부 공지사항 수정" : "새 내부 공지사항 등록"%>
			</h4>

			<form id="intNoticeForm" method="post">
				<input type="hidden" id="BID" name="BID" value="<%=bid%>" />
				<input type="hidden" id="st_byca_comorg_code" name="st_byca_comorg_code" value="<%=bycaComorgCode%>" />
				<input type="hidden" id="IMAGE_KEY" name="IMAGE_KEY" value="<%=isEditMode && detail != null ? CommonUtil.nvl(String.valueOf(detail.get("IMAGE_KEY"))) : ""%>" />

				<table class="ChatTable mt20" width="100%">
					<colgroup>
						<col width="130px" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>제목</th>
						<td>
							<input type="text" class="input30" style="width:99%;" id="SUBJECT" name="SUBJECT" placeholder="제목을 입력해주세요"
								value="<%=isEditMode && detail != null ? CommonUtil.nvl(String.valueOf(detail.get("SUBJECT"))) : ""%>" />
						</td>
					</tr>
					<tr>
						<th>게시기간</th>
						<td>
							<div class="Buyer-datepicker-wrap" style="width:231px;">
								<div class="Buyer-date-input" data-datepicker><input type="text" id="FROM_DATE" name="FROM_DATE" placeholder="시작일" readonly
									value="<%=isEditMode && detail != null ? CommonUtil.nvl(String.valueOf(detail.get("FROM_DATE_DIS"))) : ""%>" /><span></span></div>
								<span class="Buyer-dash">~</span>
								<div class="Buyer-date-input" data-datepicker><input type="text" id="TO_DATE" name="TO_DATE" placeholder="종료일" readonly
									value="<%=isEditMode && detail != null ? CommonUtil.nvl(String.valueOf(detail.get("TO_DATE_DIS"))) : ""%>" /><span></span></div>
							</div>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<div id="editor"></div>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td>
							<button type="button" class="ButDarkGray_Small" onclick="fn_intAttachPopup()">파일첨부</button>
							<span id="IntFileName" style="margin-left:10px; font-size:13px; color:#888;"><%=isEditMode && detail != null && !"".equals(CommonUtil.nvl(String.valueOf(detail.get("IMAGE_KEY")))) ? "첨부파일 있음" : "첨부파일 없음"%></span>
						</td>
					</tr>
				</table>
			</form>

			<div class="ac mt30">
				<button class="ButPrimary_large" style="width:150px" onclick="fn_registerInternalNotice()">
					<%=isEditMode ? "수정" : "등록"%>
				</button>
			</div>
			<div class="h80"></div>
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
	</div>
</div>

<script type="text/javascript">
var intPopupSel;

/* 파일명 표시 */
function fn_showIntFileName(input) {
	var fileNameSpan = document.getElementById('IntFileName');
	if (input.files && input.files.length > 0) {
		var names = [];
		for (var i = 0; i < input.files.length; i++) {
			names.push(input.files[i].name);
		}
		fileNameSpan.textContent = names.join(', ');
	} else {
		fileNameSpan.textContent = '선택된 파일이 없습니다.';
	}
}

/* 파일 첨부 팝업 (PopupUtil - 협력사 회원가입과 동일) */
function fn_intAttachPopup() {
	PopupUtil.callback(function(api) {
		var imgKey = document.getElementById('IMAGE_KEY').value;
		if (api.loadExistingDoc && imgKey) {
			api.loadExistingDoc(imgKey);
		}
		api.onConfirm(function(result) {
			if (result.docNo) {
				document.getElementById('IMAGE_KEY').value = result.docNo;
				document.getElementById('IntFileName').textContent = result.fileNames ? '첨부: ' + result.fileNames : '첨부파일 있음';
			}
		});
	}).show(PopupUtil.POPUP_URLS.FILE_ATTACH);
}

/* 내부 공지사항 등록/수정 */
function fn_registerInternalNotice() {
	var subject = document.getElementById('SUBJECT').value.trim();
	var context = editor.getHTML().trim();
	var fromDate = document.getElementById('FROM_DATE').value.trim();
	var toDate = document.getElementById('TO_DATE').value.trim();

	if (!subject) {
		alert("제목을 입력해주세요.");
		document.getElementById('SUBJECT').focus();
		return;
	}
	if (!fromDate || !toDate) {
		alert("게시기간을 입력해주세요.");
		return;
	}
	/* 에디터 빈 내용 체크: 빈 태그만 있는 경우도 빈 값으로 처리 */
	var contextText = context.replace(/<[^>]*>/g, '').trim();
	if (!contextText) {
		alert("내용을 입력해주세요.");
		editor.focus();
		return;
	}

	var confirmMsg = isEditMode ? "내부 공지사항을 수정하시겠습니까?" : "내부 공지사항을 등록하시겠습니까?";
	if (!confirm(confirmMsg)) return;

	var param = {
		BID: document.getElementById('BID').value,
		st_byca_comorg_code: document.getElementById('st_byca_comorg_code').value,
		SUBJECT: subject,
		CONTEXT: context,
		FROM_DATE: fromDate,
		TO_DATE: toDate,
		IMAGE_KEY: document.getElementById('IMAGE_KEY').value
	};

	var url = isEditMode ? '/mcsc/updateBuyerInternalNoticeJson.do' : '/mcsc/registerBuyerInternalNoticeJson.do';

	jQuery.ajax({
		url: url,
		type: 'POST',
		data: param,
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				alert(isEditMode ? "내부 공지사항이 수정되었습니다." : "내부 공지사항이 등록되었습니다.");
				location.href = '/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=3';
			} else {
				alert(result.message || '처리에 실패했습니다.');
			}
		},
		error: function() {
			alert('처리 중 오류가 발생했습니다.');
		}
	});
}
</script>
</body>
</html>
