<%--
**********************************************
* 메뉴 : 고객센터 > 공지사항 등록/수정
* 화면 : 공지사항 등록/수정
* 기능 : 관리자 공지사항 등록/수정 폼
* 프로그램 ID : BU0900005
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
</head>
<%
String mode = CommonUtil.nvl((String) request.getAttribute("mode"), "write");
boolean isEditMode = "edit".equals(mode);
Map<String, String> detail = null;
String bid = "";
if (isEditMode) {
	detail = (Map<String, String>) request.getAttribute("detail");
	if (detail != null) {
		bid = CommonUtil.nvl(detail.get("BID"));
	}
}
%>
<body onload="kep_onload_view()">
<script>
var isEditMode = <%=isEditMode%>;
function kep_onload_view() {
	fn_updateNoticeCharCount();
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
				<div style="border-bottom:1px solid #2172ec;" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=1'">1:1 문의</div>
				<div style="border:1px solid #2172ec;border-bottom:0px solid #2172ec; background-color:#fff; color:#2172ec;">공지사항</div>
				<div style="border-bottom:1px solid #2172ec;" onclick="location.href='/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=3'">내부 공지사항</div>
			</div>

			<h4 class="mt20" style="font-size:16px; font-weight:bold;">
				<%=isEditMode ? "공지사항 수정" : "새 공지사항 등록"%>
			</h4>

			<form id="noticeForm" method="post">
				<input type="hidden" id="BID" name="BID" value="<%=bid%>" />
				<input type="hidden" id="BTYPE" name="BTYPE" value="NT" />
				<input type="hidden" id="IMAGE_KEY" name="IMAGE_KEY" value="<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("IMAGE_KEY")) : ""%>" />

				<table class="ChatTable mt20" width="100%">
					<colgroup>
						<col width="130px" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>제목</th>
						<td>
							<input type="text" class="input30" style="width:99%;" id="SUBJECT" name="SUBJECT" placeholder="제목을 입력해주세요"
								value="<%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("SUBJECT")) : ""%>" />
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>
							<div style="height:300px;">
								<textarea id="CONTEXT" name="CONTEXT" style="width:100%; height:300px; resize:vertical;" placeholder="내용을 입력해주세요"><%=isEditMode && detail != null ? CommonUtil.nvl(detail.get("CONTEXT")) : ""%></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td>
							<input type="file" id="FileUpload" name="FileUpload" multiple style="display:none;" onchange="fn_showFileName(this)" />
							<label class="CustomUpload" for="FileUpload" style="cursor:pointer;">파일 선택</label>
							<span id="FileName" style="margin-left:10px;">선택된 파일이 없습니다.</span>
							<a href="javascript:fn_attachPopup();" style="margin-left:10px;">
								<img id="diskimg" src="/resources/images/disk_<%=isEditMode && detail != null && !"".equals(CommonUtil.nvl(detail.get("IMAGE_KEY"))) ? "on" : "off"%>.gif" width="20" height="20" border="0" style="vertical-align:middle;" />
							</a>
						</td>
					</tr>
				</table>
			</form>

			<div class="ac mt30">
				<button class="ButPrimary_large" style="width:150px" onclick="fn_registerNotice()">
					<%=isEditMode ? "수정" : "등록"%>
				</button>
			</div>
			<div class="h80"></div>
		</div>
		<%@ include file="/WEB-INF/views/common/include/buyerFooter_v2.jsp" %>
	</div>
</div>

<script type="text/javascript">
var popupSel;

/* 글자수 카운트 */
function fn_updateNoticeCharCount() {
	var ta = document.getElementById('CONTEXT');
	if (ta) {
		ta.addEventListener('input', function() {
			// 글자수 카운트 (필요 시 UI 추가)
		});
	}
}

/* 파일명 표시 */
function fn_showFileName(input) {
	var fileNameSpan = document.getElementById('FileName');
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

/* 파일 첨부 팝업 (기존 공통 사용) */
function fn_attachPopup() {
	popupSel = "file";
	var type = "BO";
	var viewType = "C";
	var imgKey = document.getElementById('IMAGE_KEY').value;
	kepFileUploadOpenPopup(imgKey, type, viewType);
}

/* 파일 첨부 콜백 */
function setPopupReturn(value1, value2) {
	if (popupSel !== "buyerMulti") {
		document.getElementById('IMAGE_KEY').value = value1;
		document.getElementById('diskimg').src = "/resources/images/disk_" + value2 + ".gif";
	}
}

/* 공지사항 등록/수정 */
function fn_registerNotice() {
	var subject = document.getElementById('SUBJECT').value.trim();
	var context = document.getElementById('CONTEXT').value.trim();

	if (!subject) {
		alert("제목을 입력해주세요.");
		document.getElementById('SUBJECT').focus();
		return;
	}
	if (!context) {
		alert("내용을 입력해주세요.");
		document.getElementById('CONTEXT').focus();
		return;
	}

	var confirmMsg = isEditMode ? "공지사항을 수정하시겠습니까?" : "선택한 공지사항을 등록하시겠습니까?";
	if (!confirm(confirmMsg)) return;

	var param = {
		BID: document.getElementById('BID').value,
		BTYPE: document.getElementById('BTYPE').value,
		SUBJECT: subject,
		CONTEXT: context,
		IMAGE_KEY: document.getElementById('IMAGE_KEY').value,
		EXPOSE_TARGET: 'BUY',
		ALL_CUSTOMER_FLAG: 'Y',
		NOTICE_TYPE: 'CMN',
		ALWAYS_SHOW_FLAG: 'Y'
	};

	var url = isEditMode ? '/mcsc/updateBuyerNoticeJson.do' : '/mcsc/registerBuyerNoticeJson.do';

	jQuery.ajax({
		url: url,
		type: 'POST',
		data: param,
		dataType: 'json',
		success: function(result) {
			if (result.success) {
				alert(isEditMode ? "공지사항이 수정되었습니다." : "선택하신 공지사항이 등록되었습니다.");
				location.href = '/mcsc/showBuyerMcScCustomerCenter.do?tabIndex=2';
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
