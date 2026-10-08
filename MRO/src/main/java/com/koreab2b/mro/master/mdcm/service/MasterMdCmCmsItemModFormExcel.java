package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.DataValidationConstraint;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Name;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataValidationHelper;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.koreab2b.mro.util.CommonUtil;

/**
 * 표준DB > 상품정보 일괄수정 양식(58열)을 POI 로 생성한다.
 *
 * IBSheet Down2Excel 로는 만들 수 없는 것들이 있어 서버가 직접 만든다 —
 * 병합 4행 헤더 · 안내문 행 · 상품상태 종속 드롭다운(별도 시트 + 이름정의 + INDIRECT).
 * ⚠ 열 순서는 cmsItemModForm.js 의 MDCM_MOD_EXCEL_COLS 와 반드시 일치해야 한다.
 *   여기(COLS)의 SaveName 순서가 곧 엑셀 열 번호이고, 업로드 ColumnMapping 이 그 번호로 되읽는다.
 */
public class MasterMdCmCmsItemModFormExcel {

	/** 데이터 시작행(1-based). 헤더 4행 뒤. ⚠ D열 드롭다운 수식 INDIRECT(C5) 의 5 와 한 몸이다. */
	public static final int DATA_START_ROW = 5;

	/** 양식이 담는 속성 쌍 개수. cmsItemModForm.js 의 MDCM_MOD_ATTR_COUNT 와 같아야 한다. */
	public static final int ATTR_COUNT = 13;

	private static final String FORM_SHEET = "Sheet3";
	/* 드롭다운 원본 시트. 지우면 드롭다운이 통째로 죽으므로 이름으로 경고하고 숨긴다. */
	private static final String LIST_SHEET = "■코드목록(삭제금지)";

	private static final String MARK_ON   = "▼입력 시 반영";
	private static final String MARK_CHG  = "▼변경 시 반영";
	private static final String MARK_OFF  = "▼미반영";
	private static final String GUIDE_TXT = "텍스트 입력";

	/** 열 정의. {SaveName, 그룹명, 소제목, 2행 반영표시, 1행 안내문} — 배열 순서 = 엑셀 열 순서. */
	private static final String[][] COLS = {
		 {"CMS_CATLG_ID",       "상품정보코드",    "",         "",        ""}
		,{"STATUS_BEFORE",      "상품상태",        "기존",     "",        ""}
		,{"STATUS_AFTER",       "상품상태",        "변경",     MARK_ON,   "미사용 / 사용 중 선택"}
		,{"CHG_REASON",         "상품상태",        "변경사유", MARK_ON,   "▶C열 \"미사용\" 기재 시 사유1 : 중복존재 사유2 : 단종 사유3 : 일시품절"
		                                                               + " ▶C열 \"사용\" 기재 시 사유1 : 신규거래발생 사유2 : 재고보유품(단종) 사유3 : 일시품절해제"}
		,{"ALT_CODE",           "상품상태",        "대체코드", MARK_ON,   "▶D열 \"중복존재\"일 경우 기재必"}

		,{"DESCRIPTION_BEFORE", "품목명",          "기존",     "",        ""}
		,{"DESCRIPTION_AFTER",  "품목명",          "변경",     MARK_ON,   GUIDE_TXT}
		,{"DESCRIPTION_REASON", "품목명",          "변경사유", MARK_ON,   GUIDE_TXT}

		,{"MODEL_BEFORE",       "모델번호",        "기존",     "",        ""}
		,{"MODEL_AFTER",        "모델번호",        "변경",     MARK_ON,   GUIDE_TXT}
		,{"MODEL_REASON",       "모델번호",        "변경사유", MARK_ON,   GUIDE_TXT}

		,{"MAKER_BEFORE",       "제조사",          "기존",     "",        ""}
		,{"MAKER_CODE_BEFORE",  "제조사",          "기존코드", "",        ""}
		,{"MAKER_CODE_AFTER",   "제조사",          "변경코드", MARK_ON,   "제조사 변경 시, 원산지는 별도의 입력 없이 제조사 기준으로 반영"}
		,{"MAKER_REASON",       "제조사",          "변경사유", MARK_ON,   GUIDE_TXT}

		,{"ORIGIN_BEFORE",      "원산지",          "기존",     "",        ""}
		,{"ORIGIN_CODE_BEFORE", "원산지",          "기존코드", "",        ""}
		,{"ORIGIN_CODE_AFTER",  "원산지",          "변경코드", MARK_ON,   "제조사 대표 등록 원산지와 상이하여 원산지 변경이 필요할 경우, 입력 시 반영"}
		,{"ORIGIN_REASON",      "원산지",          "변경사유", MARK_ON,   GUIDE_TXT}

		,{"MEASURE_BEFORE",     "단위",            "기존",     "",        ""}
		,{"MEASURE_AFTER",      "단위",            "변경",     MARK_ON,   GUIDE_TXT}
		,{"MEASURE_REASON",     "단위",            "변경사유", MARK_ON,   GUIDE_TXT}

		,{"ITEM_GUBUN_BEFORE",  "상품구분",        "기존",     "",        ""}
		,{"ITEM_GUBUN_AFTER",   "상품구분",        "변경",     MARK_ON,   "표준품 / 비표준품 중 선택"}
		,{"ITEM_GUBUN_REASON",  "상품구분",        "변경사유", MARK_ON,   GUIDE_TXT}

		,{"TR_BEFORE",          "TR취급가능여부",  "기존",     "",        ""}
		,{"TR_AFTER",           "TR취급가능여부",  "변경",     MARK_ON,   "목록에서 선택"}
		,{"TR_REASON",          "TR취급가능여부",  "변경사유", MARK_ON,   GUIDE_TXT}

		,{"SPEC_BEFORE",        "규격",            "기존",     MARK_OFF,  ""}
		,{"SPEC_REASON",        "규격",            "변경사유", MARK_ON,   GUIDE_TXT}
	};

	// 상품상태 변경/변경사유 열의 위치(0-based). 드롭다운을 여기 건다.
	private static final int COL_STATUS_AFTER = 2;
	private static final int COL_CHG_REASON   = 3;

	// 이름정의 이름 = C열에 들어갈 값과 문자열이 같아야 INDIRECT 가 찾아간다.
	private static final String NAME_OUT = "미사용";
	private static final String NAME_IN  = "사용";

	// 상품구분·TR 드롭다운의 이름정의. 목록시트 C·D 열을 가리킨다.
	private static final String NAME_GUBUN = "상품구분목록";
	private static final String NAME_TR    = "TR취급목록";

	/* 상품구분 드롭다운 값. 화면과 같은 2값으로 접어 보여준다(M118 은 4값이지만 양식은 표준품/비표준품만 받는다). */
	private static final String[] GUBUN_LIST = { "표준품", "비표준품" };

	/* 열의 성격. 색·글자색이 여기서 갈린다. */
	private static final int ROLE_FIXED  = 0;	// 시스템이 채워 보낸 값 — 고쳐도 반영되지 않는다
	private static final int ROLE_INPUT  = 1;	// 담당자가 채우는 칸
	private static final int ROLE_IGNORE = 2;	// 눈으로 보라고 둔 참고 칸(▼미반영)

	/* 색. 무채색 한 계열로만 간다. 그룹은 같은 회색의 진/연 두 단계와 굵은 세로선으로 나누고,
	 * 유일한 유채색인 연노랑은 "여기를 채우세요"(입력칸) 하나에만 쓴다. */
	private static final byte[] C_BAND_A   = rgb(0x40, 0x40, 0x40);	// 그룹 띠(홀수) — 차콜
	private static final byte[] C_BAND_B   = rgb(0x59, 0x59, 0x59);	// 그룹 띠(짝수) — 한 톤 밝게
	private static final byte[] C_SUB_FIX  = rgb(0xD9, 0xD9, 0xD9);	// 4행 소제목 : 기존/고정
	private static final byte[] C_FIXED    = rgb(0xE7, 0xE6, 0xE6);	// 기존값 — 회색
	private static final byte[] C_INPUT    = rgb(0xFF, 0xF2, 0xCC);	// 입력칸 — 연노랑
	private static final byte[] C_IGNORE   = rgb(0xF2, 0xF2, 0xF2);	// 참고칸 — 아주 옅은 회색
	private static final byte[] C_GUIDE_BG = rgb(0xF7, 0xF7, 0xF7);	// 안내문 줄
	private static final byte[] C_TXT      = rgb(0x33, 0x33, 0x33);
	private static final byte[] C_TXT_HEAD = rgb(0xFF, 0xFF, 0xFF);	// 차콜 바탕 위 그룹명
	private static final byte[] C_TXT_MUTE = rgb(0x80, 0x80, 0x80);
	private static final byte[] C_TXT_ON   = rgb(0x40, 0x40, 0x40);	// ▼입력 시 반영
	private static final byte[] C_TXT_CHG  = rgb(0x59, 0x59, 0x59);	// ▼변경 시 반영
	private static final byte[] C_LINE     = rgb(0xBF, 0xBF, 0xBF);
	private static final byte[] C_LINE_GRP = rgb(0x40, 0x40, 0x40);	// 그룹 경계 세로선

	private final XSSFWorkbook wb;
	/* 스타일은 [성격/띠][그룹 첫 열인가] 로 미리 만들어 재사용한다.
	 * 셀마다 만들면 XSSF 스타일 수가 폭발해 파일이 무거워지고 엑셀이 경고를 낸다. */
	private CellStyle[]   stGuide = new CellStyle[2];
	private CellStyle[][] stMark  = new CellStyle[3][2];	// [표시구분][그룹 첫 열]
	private CellStyle[][] stGroup = new CellStyle[2][2];	// [띠][그룹 첫 열]
	private CellStyle[][] stSub   = new CellStyle[2][2];	// [소제목 계열][그룹 첫 열]
	private CellStyle[][] stData  = new CellStyle[3][2];	// [ROLE][그룹 첫 열]

	private MasterMdCmCmsItemModFormExcel() {
		this.wb = new XSSFWorkbook();
	}

	/**
	 * 양식 워크북을 만든다.
	 *
	 * @param rows        상품 1건 = Map 1개. 키는 COLS 의 SaveName (+ ATTRn_NM / ATTRn_VAL)
	 * @param reasonOut   상품상태 '미사용' 방향 변경사유 목록
	 * @param reasonIn    상품상태 '사용' 방향 변경사유 목록
	 */
	public static XSSFWorkbook build(List<Map<String,String>> rows, List<String> reasonOut, List<String> reasonIn,
			List<String> trNames) {
		MasterMdCmCmsItemModFormExcel maker = new MasterMdCmCmsItemModFormExcel();
		return maker.make(rows, reasonOut, reasonIn, trNames);
	}

	private XSSFWorkbook make(List<Map<String,String>> rows, List<String> reasonOut, List<String> reasonIn,
			List<String> trNames) {
		XSSFSheet form = wb.createSheet(FORM_SHEET);
		XSSFSheet list = wb.createSheet(LIST_SHEET);

		initStyles();
		writeReasonSheet(list, reasonOut, reasonIn, trNames);
		createNames(reasonOut.size(), reasonIn.size(), (trNames == null) ? 0 : trNames.size());
		writeHeader(form);
		int lastRow = writeData(form, rows);
		addValidations(form, lastRow);

		form.createFreezePane(1, 4);
		wb.setSheetHidden(wb.getSheetIndex(list), true);
		wb.setActiveSheet(0);
		return wb;
	}

	/* ── 목록 시트 : A열 = 미사용 방향, B열 = 사용 방향. 1행은 머리글이라 이름정의는 2행부터 잡는다. ── */
	private void writeReasonSheet(XSSFSheet list, List<String> reasonOut, List<String> reasonIn, List<String> trNames) {
		int trSize = (trNames == null) ? 0 : trNames.size();

		XSSFRow head = list.createRow(0);
		head.createCell(0).setCellValue(NAME_OUT);
		head.createCell(1).setCellValue(NAME_IN);
		head.createCell(2).setCellValue("상품구분");
		head.createCell(3).setCellValue("TR취급가능여부");

		int max = Math.max(Math.max(reasonOut.size(), reasonIn.size()), Math.max(GUBUN_LIST.length, trSize));
		for (int i = 0; i < max; i++) {
			XSSFRow r = list.createRow(i + 1);
			if (i < reasonOut.size())   { r.createCell(0).setCellValue(reasonOut.get(i)); }
			if (i < reasonIn.size())    { r.createCell(1).setCellValue(reasonIn.get(i)); }
			if (i < GUBUN_LIST.length)  { r.createCell(2).setCellValue(GUBUN_LIST[i]); }
			if (i < trSize)             { r.createCell(3).setCellValue(trNames.get(i)); }
		}
		for (int c = 0; c <= 3; c++) { list.setColumnWidth(c, 22 * 256); }
	}

	/* 이름정의 2건. D열 유효성 INDIRECT(C5) 가 C열 값('사용'/'미사용')으로 이 이름을 찾아간다. */
	private void createNames(int outCount, int inCount, int trCount) {
		addName(NAME_OUT,   "A", outCount);
		addName(NAME_IN,    "B", inCount);
		addName(NAME_GUBUN, "C", GUBUN_LIST.length);
		addName(NAME_TR,    "D", trCount);
	}

	private void addName(String name, String col, int count) {
		if (count <= 0) { return; }		// 코드가 비면 이름정의를 만들지 않는다(빈 범위는 엑셀이 거부한다)
		Name n = wb.createName();
		n.setNameName(name);
		n.setRefersToFormula("'" + LIST_SHEET + "'!$" + col + "$2:$" + col + "$" + (count + 1));
	}

	/* ── 헤더 4행 : 1행 안내문 / 2행 반영표시 / 3행 그룹명(병합) / 4행 소제목 ── */
	private void writeHeader(XSSFSheet form) {
		XSSFRow r1 = form.createRow(0);
		XSSFRow r2 = form.createRow(1);
		XSSFRow r3 = form.createRow(2);
		XSSFRow r4 = form.createRow(3);
		r1.setHeightInPoints(48);	// 안내문이 두세 줄로 접힌다
		r2.setHeightInPoints(16);
		r3.setHeightInPoints(20);
		r4.setHeightInPoints(20);

		int total = totalColCount();
		for (int c = 0; c < total; c++) {
			int edge = isGroupStart(c) ? 1 : 0;	// 그룹이 바뀌는 열에만 굵은 세로선을 세운다
			cell(r1, c, guideAt(c), stGuide[edge]);
			cell(r2, c, markAt(c),  stMark[markKindAt(c)][edge]);
			cell(r3, c, "",         stGroup[bandAt(c)][edge]);
			cell(r4, c, subAt(c),   stSub[subKindAt(c)][edge]);
			form.setColumnWidth(c, widthAt(c) * 256);
		}

		// 그룹명은 연속 구간의 첫 칸에 쓰고 가로 병합한다. 소제목이 없는 열(상품정보코드)은 세로 병합.
		int start = 0;
		while (start < total) {
			String group = groupAt(start);
			int end = start;
			while (end + 1 < total && groupAt(end + 1).equals(group)) { end++; }

			cell(r3, start, group, stGroup[bandAt(start)][1]);
			if (subAt(start).length() == 0 && start == end) {
				form.addMergedRegion(new CellRangeAddress(2, 3, start, end));
			} else if (end > start) {
				form.addMergedRegion(new CellRangeAddress(2, 2, start, end));
			}
			start = end + 1;
		}
	}

	/* ── 데이터 : 5행부터. 값이 없는 열은 빈 칸으로 둔다(담당자가 채울 자리). ── */
	private int writeData(XSSFSheet form, List<Map<String,String>> rows) {
		int rowIdx = DATA_START_ROW - 1;
		int total  = totalColCount();

		for (int i = 0; i < rows.size(); i++) {
			Map<String,String> src = rows.get(i);
			XSSFRow r = form.createRow(rowIdx++);
			for (int c = 0; c < total; c++) {
				cell(r, c, CommonUtil.nvl(src.get(saveNameAt(c))), stData[roleAt(c)][isGroupStart(c) ? 1 : 0]);
			}
		}
		return Math.max(rowIdx, DATA_START_ROW);	// 데이터가 없어도 유효성은 첫 행에 걸어 둔다
	}

	/* ── 유효성 : C열 사용/미사용, D열은 C열 값에 종속 ──
	 * ⚠ setSuppressDropDownArrow(true) 가 "드롭다운 표시" 다(이름과 반대).
	 * ⚠ INDIRECT(C5) 의 상대참조는 범위 좌상단(D5) 기준으로 행마다 따라간다. */
	private void addValidations(XSSFSheet form, int lastRow) {
		XSSFDataValidationHelper h = new XSSFDataValidationHelper(form);
		int first = DATA_START_ROW - 1;
		int last  = Math.max(lastRow - 1, first);

		DataValidationConstraint statusCon = h.createExplicitListConstraint(new String[]{NAME_IN, NAME_OUT});
		addValidation(form, h, statusCon, first, last, COL_STATUS_AFTER);

		DataValidationConstraint reasonCon = h.createFormulaListConstraint("INDIRECT(C" + DATA_START_ROW + ")");
		addValidation(form, h, reasonCon, first, last, COL_CHG_REASON);

		/* 상품구분·TR 은 자유 입력이라 담당자가 안내문의 번호("1","2")를 그대로 적는 일이 있었다.
		 * 값 목록을 드롭다운으로 걸어 명칭만 들어오게 한다 - 등록 단계가 명칭으로 코드를 찾기 때문이다.
		 * 이름정의가 없으면(목록이 비면) 유효성도 걸지 않는다 - 빈 범위는 엑셀이 거부한다. */
		addNameValidation(form, h, first, last, "ITEM_GUBUN_AFTER", NAME_GUBUN);
		addNameValidation(form, h, first, last, "TR_AFTER",         NAME_TR);
	}

	/* 이름정의를 목록으로 쓰는 드롭다운. 대상 열은 SaveName 으로 찾는다 - 열이 늘거나 줄어도 따라간다. */
	private void addNameValidation(XSSFSheet form, XSSFDataValidationHelper h, int first, int last,
			String saveName, String rangeName) {
		if (wb.getName(rangeName) == null) { return; }
		int col = colOf(saveName);
		if (col < 0) { return; }
		addValidation(form, h, h.createFormulaListConstraint(rangeName), first, last, col);
	}

	/** SaveName 으로 열 번호(0-based)를 찾는다. 못 찾으면 -1. */
	private static int colOf(String saveName) {
		for (int i = 0; i < COLS.length; i++) {
			if (COLS[i][0].equals(saveName)) { return i; }
		}
		return -1;
	}

	private void addValidation(XSSFSheet form, XSSFDataValidationHelper h, DataValidationConstraint con,
			int firstRow, int lastRow, int col) {
		CellRangeAddressList range = new CellRangeAddressList(firstRow, lastRow, col, col);
		DataValidation dv = h.createValidation(con, range);
		dv.setSuppressDropDownArrow(true);
		dv.setShowErrorBox(true);
		dv.setEmptyCellAllowed(true);
		form.addValidationData(dv);
	}

	/* ── 스타일 ──
	 * 성격(기존/입력/참고) × 그룹 첫 열 여부의 조합으로 미리 만들어 둔다. */
	private void initStyles() {
		XSSFFont fGuide   = font(9,  false, false, C_TXT_MUTE);
		XSSFFont fGroup   = font(10, true,  false, C_TXT_HEAD);
		XSSFFont fSub     = font(9,  true,  false, C_TXT);
		XSSFFont fData    = font(9,  false, false, C_TXT);
		XSSFFont fFixed   = font(9,  false, false, C_TXT_MUTE);
		XSSFFont fMarkOn  = font(9,  true,  false, C_TXT_ON);
		XSSFFont fMarkChg = font(9,  true,  false, C_TXT_CHG);
		XSSFFont fMarkOff = font(9,  false, true,  C_TXT_MUTE);

		for (int edge = 0; edge < 2; edge++) {
			boolean e = (edge == 1);

			stGuide[edge] = style(fGuide, C_GUIDE_BG, e, true, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_TOP);

			stMark[ROLE_FIXED][edge]  = style(fMarkOff, null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stMark[ROLE_INPUT][edge]  = style(fMarkOn,  null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stMark[ROLE_IGNORE][edge] = style(fMarkChg, null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stGroup[0][edge] = style(fGroup, C_BAND_A, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stGroup[1][edge] = style(fGroup, C_BAND_B, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stSub[ROLE_FIXED][edge]  = style(fSub,    C_SUB_FIX, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stSub[ROLE_INPUT][edge]  = style(fSub,    C_INPUT,  e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stData[ROLE_FIXED][edge]  = style(fFixed, C_FIXED,  e, false, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_CENTER);
			stData[ROLE_INPUT][edge]  = style(fData,  null,     e, false, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_CENTER);
			stData[ROLE_IGNORE][edge] = style(fFixed, C_IGNORE, e, false, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_CENTER);
		}
	}

	/** 스타일 한 개. bg 가 null 이면 채우지 않는다(흰 바탕 = 비어 있는 입력칸). */
	private CellStyle style(XSSFFont f, byte[] bg, boolean groupEdge, boolean wrap, short hAlign, short vAlign) {
		XSSFCellStyle st = wb.createCellStyle();
		st.setFont(f);
		st.setAlignment(hAlign);
		st.setVerticalAlignment(vAlign);
		st.setWrapText(wrap);
		if (bg != null) {
			st.setFillForegroundColor(new XSSFColor(bg));
			st.setFillPattern(CellStyle.SOLID_FOREGROUND);
		}
		st.setBorderTop(CellStyle.BORDER_THIN);
		st.setBorderBottom(CellStyle.BORDER_THIN);
		st.setBorderRight(CellStyle.BORDER_THIN);
		st.setBorderLeft(groupEdge ? CellStyle.BORDER_MEDIUM : CellStyle.BORDER_THIN);
		st.setTopBorderColor(new XSSFColor(C_LINE));
		st.setBottomBorderColor(new XSSFColor(C_LINE));
		st.setRightBorderColor(new XSSFColor(C_LINE));
		st.setLeftBorderColor(new XSSFColor(groupEdge ? C_LINE_GRP : C_LINE));
		return st;
	}

	private XSSFFont font(int points, boolean bold, boolean italic, byte[] color) {
		XSSFFont f = wb.createFont();
		f.setFontHeightInPoints((short) points);
		if (bold)   { f.setBoldweight(Font.BOLDWEIGHT_BOLD); }
		if (italic) { f.setItalic(true); }
		f.setColor(new XSSFColor(color));
		return f;
	}

	private static byte[] rgb(int r, int g, int b) {
		return new byte[]{(byte) 0xFF, (byte) r, (byte) g, (byte) b};
	}

	private void cell(Row row, int col, String value, CellStyle style) {
		XSSFCell c = (XSSFCell) row.createCell(col);
		c.setCellValue(value == null ? "" : value);
		c.setCellStyle(style);
	}

	/* ── 열 정의 접근자. COLS(고정 32열) 뒤에 속성 13쌍이 이어 붙는다. ── */

	public static int totalColCount() {
		return COLS.length + (ATTR_COUNT * 2);
	}

	/** 0-based 열 번호 → SaveName. 업로드 ColumnMapping 과 같은 순서를 보장하는 단일 출처다. */
	public static String saveNameAt(int col) {
		if (col < COLS.length) { return COLS[col][0]; }
		int n = (col - COLS.length) / 2 + 1;
		return ((col - COLS.length) % 2 == 0) ? ("ATTR" + n + "_NM") : ("ATTR" + n + "_VAL");
	}

	private static String groupAt(int col) {
		if (col < COLS.length) { return COLS[col][1]; }
		return "속성" + ((col - COLS.length) / 2 + 1);
	}

	private static String subAt(int col) {
		if (col < COLS.length) { return COLS[col][2]; }
		return ((col - COLS.length) % 2 == 0) ? "속성명" : "값";
	}

	private static String markAt(int col) {
		if (col < COLS.length) { return COLS[col][3]; }
		return ((col - COLS.length) % 2 == 0) ? "" : MARK_CHG;
	}

	private static String guideAt(int col) {
		if (col < COLS.length) { return COLS[col][4]; }
		return ((col - COLS.length) % 2 == 0) ? "" : GUIDE_TXT;
	}

	/** 열의 성격. 기존값·속성명은 고정, ▼미반영 참고칸은 IGNORE, 나머지는 입력칸. */
	private static int roleAt(int col) {
		String save = saveNameAt(col);
		if ("CMS_CATLG_ID".equals(save) || save.endsWith("_BEFORE") || save.endsWith("_NM")) { return ROLE_FIXED; }
		if (MARK_OFF.equals(markAt(col))) { return ROLE_IGNORE; }
		return ROLE_INPUT;
	}

	/** 4행 소제목의 색 구분. 같은 소제목은 반영 여부와 무관하게 같은 색으로 간다 — 기존 계열은 회색, 변경 계열은 입력색. */
	private static int subKindAt(int col) {
		String sub = subAt(col);
		if (sub.length() == 0 || sub.startsWith("기존") || "속성명".equals(sub)) { return ROLE_FIXED; }
		return ROLE_INPUT;
	}

	/** 2행 반영표시의 색 구분. 열의 성격과 1:1 이 아니라 표시 문구로 따로 정한다. */
	private static int markKindAt(int col) {
		String mark = markAt(col);
		if (MARK_ON.equals(mark))  { return ROLE_INPUT; }
		if (MARK_CHG.equals(mark)) { return ROLE_IGNORE; }
		return ROLE_FIXED;					// ▼미반영 · 빈칸
	}

	/** 그룹이 바뀌는 첫 열인가. 여기에만 굵은 세로선을 세워 항목군을 갈라 보인다. */
	private static boolean isGroupStart(int col) {
		return col == 0 || !groupAt(col).equals(groupAt(col - 1));
	}

	/** 그룹 띠 색 번갈이. 앞에서부터 몇 번째 그룹인지로 정한다. */
	private static int bandAt(int col) {
		int band = 0;
		for (int i = 1; i <= col; i++) {
			if (isGroupStart(i)) { band ^= 1; }
		}
		return band;
	}

	private static int widthAt(int col) {
		if (col >= COLS.length) { return 16; }
		String save = COLS[col][0];
		if (save.endsWith("_REASON") || "CHG_REASON".equals(save)) { return 20; }
		if (save.startsWith("DESCRIPTION") || save.startsWith("SPEC")) { return 26; }
		return 14;
	}
}
