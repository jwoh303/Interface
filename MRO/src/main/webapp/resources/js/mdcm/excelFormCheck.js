/**********************************************
 * 표준DB 양식 업로드 — 올린 파일이 그 화면의 양식이 맞는지 확인한다. (공용)
 *
 * LoadExcel 은 열 이름이 아니라 **자리**로 읽는다(Mode:"NoHeader") — 다른 양식을 올려도
 * A열부터 순서대로 꽂혀 그대로 통과한다(구매정보 양식을 상품정보에 올려도 읽힌다).
 * → StartRow 를 1 로 내려 머리글까지 데이터로 읽고, 그룹명·소제목 두 행을 대조해 먼저 거른다.
 *
 * 기대값(MDCM_*_FORM_HEAD)은 서버 생성기 *FormExcel.java 의 COLS 와 한 몸이다 — 양식 열을 바꾸면 같이 바꾼다.
 * ⚠ 병합된 칸은 읽는 쪽이 값을 줄 수도 안 줄 수도 있다 — 좌상단 칸만 담고 나머지는 빈 값으로 두어 건너뛴다.
 **********************************************/

// 엑셀 1행이 시트의 HeaderRows() 자리에 온다 — 양식 데이터 첫 행의 시트 행번호.
function mdcmFormFirstDataRow(sheet, dataStartRow) {
	return sheet.HeaderRows() + parseInt(dataStartRow, 10) - 1;
}

/* [그룹명, 소제목] 표 → 대조 목록 [행 올림수, 컬럼, 기대값]. 빈 값은 대조하지 않는다. */
function mdcmFormSignature(cols, head) {
	var sig = [];
	for (var i = 0; i < head.length && i < cols.length; i++) {
		if (head[i][0] != "") { sig.push([2, cols[i], head[i][0]]); }
		if (head[i][1] != "") { sig.push([1, cols[i], head[i][1]]); }
	}
	return sig;
}

// 공백은 무시하고 맞춘다 — 양식 글자의 띄어쓰기까지 걸고 넘어지면 실무가 막힌다.
function mdcmFormTextEq(a, b) {
	var x = (a == null) ? "" : ("" + a).replace(/\s+/g, "");
	var y = (b == null) ? "" : ("" + b).replace(/\s+/g, "");
	return x == y;
}

/* 양식이 맞으면 true. 아니면 안내하고 false — 부르는 쪽은 시트를 비우고 멈춘다. */
function mdcmFormCheck(sheet, dataStartRow, cols, head, formName) {
	var dataRow = mdcmFormFirstDataRow(sheet, dataStartRow);
	var sig = mdcmFormSignature(cols, head);

	for (var i = 0; i < sig.length; i++) {
		var r = dataRow - sig[i][0];
		if (r < sheet.HeaderRows() || r > sheet.LastRow()
			|| !mdcmFormTextEq(sheet.GetCellValue(r, sig[i][1]), sig[i][2])) {
			alert("[" + formName + "] 양식이 아닙니다.\n\n"
				+ "해당 양식을 내려받아 작성한 파일만 올릴 수 있습니다.\n"
				+ "머리글 행을 지우거나 열을 넣고 빼도 올릴 수 없습니다.");
			return false;
		}
	}
	return true;
}
