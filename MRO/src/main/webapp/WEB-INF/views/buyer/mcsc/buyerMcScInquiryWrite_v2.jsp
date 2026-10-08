<%--
**********************************************
* 메뉴 : 고객센터 > 1:1 문의 등록
* 화면 : 1:1 문의(VOC) 등록
* 기능 : KEPAVCDT 기반 VOC 등록 폼
* 프로그램 ID : BU0900003
* 담당자 :
* 착수일 : 2026-04-13
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
<script src="/resources/js/common/HttpUtil.js" type="text/javascript"></script>
<script src="/resources/js/common/PopupUtil.js" type="text/javascript"></script>
</head>
<%
List<Map<String,String>> qtypeList = (List<Map<String,String>>) request.getAttribute("qtypeList");
%>
<body onload="kep_onload_view()">
<script>
function kep_onload_view() {
	fn_updateCharCount();
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
				<button class="Butchat" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=1'">1:1 문의하기</button>
			</div>
			<div class="SVCTab mt30">
				<div style="border:1px solid #2172ec;border-bottom:0px solid #2172ec; background-color:#fff; color:#2172ec;">1:1 문의</div>
				<div style="border-bottom:1px solid #2172ec;" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=2'">공지사항</div>
				<div style="border-bottom:1px solid #2172ec;" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=3'">내부 공지사항</div>
			</div>

			<form id="inquiryForm" method="post">
			<input type="hidden" id="st_image_key" name="st_image_key" value="" />
			<table class="ChatTable mt20" width="100%" style="table-layout:fixed;">
				<colgroup>
					<col width="130px" />
					<col width="230px" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>문의유형</th>
					<td colspan="2">
						<select class="Select" style="width:250px" id="st_claim_master" name="st_claim_master">
							<option value="">문의유형을 선택해주세요</option>
							<% if(qtypeList != null) { for(int i=0; i<qtypeList.size(); i++) { Map<String,String> qtype = qtypeList.get(i); %>
							<option value="<%=qtype.get("CODE")%>"><%=qtype.get("CODE_NAME")%></option>
							<% } } %>
						</select>
						<input class="input30" style="width:250px" id="st_buyer_item_no" name="st_buyer_item_no" placeholder="품목코드를 입력해주세요" type="text" />
						<input class="input30" style="width:250px" id="st_po_no" name="st_po_no" placeholder="발주번호를 입력해주세요" type="text" />
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="2">
						<div class="TextField" id="limitedArea">
							<textarea id="st_req_remark" name="st_req_remark" placeholder="" rows="5" style="width:97%"></textarea>
							<div class="meta" aria-live="polite"><span id="charCount">0</span>/2000 bytes</div>
						</div>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td colspan="2">
						<button type="button" class="ButDarkGray_Small" onclick="fn_inquiryAttachPopup()">파일첨부</button>
						<span id="InqFileName" style="margin-left:10px; font-size:13px; color:#888;">첨부파일 없음</span>
					</td>
				</tr>
				<tr style="display: none;">
					<th>SMS 알림</th>
					<td><span style="font-size:85%">답변이 오면 알려드릴까요? (선택)</span></td>
					<td>
						<label class="CheckMediumLabel"><input type="checkbox" id="st_sms_flag" name="st_sms_flag" value="Y"><span class="CheckMediumCustom"></span> SMS</label>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input class="input30" style="width:45px" id="st_phone1" name="st_phone1" type="text" maxlength="3" /> -
						<input class="input30" style="width:62px" id="st_phone2" name="st_phone2" type="text" maxlength="4" /> -
						<input class="input30" style="width:62px" id="st_phone3" name="st_phone3" type="text" maxlength="4" />
						<span style="font-size:85%">* 알림방법을 선택하지 않아도 1:1문의는 가능합니다.</span>
					</td>
				</tr>
			</table>
			</form>

			<div class="ac mt30">
				<button class="ButPrimary_large" style="width:150px" onclick="fn_registerInquiry()">등록</button>
			</div>
			<div class="h80"></div>
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
	</div>
</div>

<script type="text/javascript">
/* UTF-8 바이트 길이 계산 (DB VARCHAR2 바이트 제한과 일치) */
var REQ_REMARK_MAX_BYTES = 2000;
function fn_utf8ByteLen(str) {
	return unescape(encodeURIComponent(str)).length;
}

/* 바이트 초과 시 초과하지 않는 지점까지 잘라냄 */
function fn_truncateByBytes(str, maxBytes) {
	var bytes = 0;
	for (var i = 0; i < str.length; i++) {
		var chunk = fn_utf8ByteLen(str.charAt(i));
		if (bytes + chunk > maxBytes) return str.substr(0, i);
		bytes += chunk;
	}
	return str;
}

/* 글자(바이트) 카운트 + 입력 제한 */
function fn_updateCharCount() {
	var ta = document.getElementById('st_req_remark');
	var cnt = document.getElementById('charCount');
	if (!ta || !cnt) return;
	function refresh() {
		var len = fn_utf8ByteLen(ta.value);
		if (len > REQ_REMARK_MAX_BYTES) {
			ta.value = fn_truncateByBytes(ta.value, REQ_REMARK_MAX_BYTES);
			len = fn_utf8ByteLen(ta.value);
		}
		cnt.textContent = len;
	}
	refresh();
	ta.addEventListener('input', refresh);
}

/* 파일 첨부 팝업 (내부 공지 등록 화면과 동일 패턴 - PopupUtil + file_attach.html) */
function fn_inquiryAttachPopup() {
	PopupUtil.callback(function(api) {
		var imgKey = document.getElementById('st_image_key').value;
		if (api.loadExistingDoc && imgKey) {
			api.loadExistingDoc(imgKey);
		}
		api.onConfirm(function(result) {
			if (result.docNo) {
				document.getElementById('st_image_key').value = result.docNo;
				document.getElementById('InqFileName').textContent = result.fileNames ? '첨부: ' + result.fileNames : '첨부파일 있음';
			}
		});
	}).show(PopupUtil.POPUP_URLS.FILE_ATTACH);
}

/* VOC 문의 등록 */
function fn_registerInquiry() {
	var claimMaster = document.getElementById('st_claim_master').value;
	var buyerItemNo = document.getElementById('st_buyer_item_no').value.trim();
	var poNo = document.getElementById('st_po_no').value.trim();
	var reqRemark = document.getElementById('st_req_remark').value.trim();

	if (!claimMaster) {
		alert("문의유형을 선택해주세요.");
		document.getElementById('st_claim_master').focus();
		return;
	}
	if (!reqRemark) {
		alert("내용을 입력해주세요.");
		document.getElementById('st_req_remark').focus();
		return;
	}
	if (fn_utf8ByteLen(reqRemark) > REQ_REMARK_MAX_BYTES) {
		alert("내용은 " + REQ_REMARK_MAX_BYTES + " bytes 이내로 입력해주세요. (한글 약 " + Math.floor(REQ_REMARK_MAX_BYTES/3) + "자)");
		document.getElementById('st_req_remark').focus();
		return;
	}
	// 발주번호 형식 체크 (입력값이 있는 경우만)
	if (poNo !== '') {
		var regex = /^PO\d{8}$/;
		if (!regex.test(poNo)) {
			alert("발주번호 형식이 올바르지 않습니다. (예: PO00000000)");
			document.getElementById('st_po_no').focus();
			return;
		}
	}

	if (!confirm("작성하신 요청내용으로 등록하시겠습니까?")) return;

	var param = {
		st_claim_master: claimMaster,
		st_ph_date: '',
		st_buyer_item_no: buyerItemNo,
		st_po_no: poNo,
		st_req_remark: reqRemark,
		st_image_key: document.getElementById('st_image_key').value
	};

	jQuery.ajax({
		url: '/mcsc/registerBuyerInquiryJson.do',
		type: 'POST',
		data: param,
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				alert(result.message || "요청이 접수되었습니다.");
				location.href = '/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=1';
			} else {
				alert(result.message || '등록에 실패했습니다.');
			}
		},
		error: function() {
			alert('등록 중 오류가 발생했습니다.');
		}
	});
}
</script>
</body>
</html>
