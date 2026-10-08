package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataValidation;
import org.apache.poi.ss.usermodel.DataValidationConstraint;
import org.apache.poi.ss.usermodel.Font;
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
 * 표준DB > 기준가 일괄수정 양식(13열)을 POI 로 생성한다.
 *
 * 상품정보 일괄수정 양식(MasterMdCmCmsItemModFormExcel)과 같은 골격이다 —
 * 병합 4행 헤더 · 안내문 행 · 드롭다운. 다른 점은 두 가지뿐이다.
 *   (1) 열이 13개로 고정이고 속성 구간이 없다.
 *   (2) 드롭다운이 종속이 아니라 단순 목록(기준가유형)이라 이름정의·INDIRECT 가 필요 없다.
 * ⚠ 열 순서는 cmsBasePriceForm.js 의 MDCM_PRICE_EXCEL_COLS 와 반드시 일치해야 한다.
 *   여기(COLS)의 SaveName 순서가 곧 엑셀 열 번호이고, 업로드 ColumnMapping 이 그 번호로 되읽는다.
 */
public class MasterMdCmCmsBasePriceFormExcel {

	/** 데이터 시작행(1-based). 헤더 4행 뒤. cmsBasePriceForm.js 의 MDCM_PRICE_DATA_START_ROW 와 같아야 한다. */
	public static final int DATA_START_ROW = 5;

	private static final String FORM_SHEET = "Sheet4";
	/* 드롭다운 원본 시트. 지우면 드롭다운이 통째로 죽으므로 이름으로 경고하고 숨긴다. */
	private static final String LIST_SHEET = "■코드목록(삭제금지)";

	private static final String MARK_ON  = "▼입력 시 반영";
	private static final String MARK_OFF = "▼미반영";

	/** 열 정의. {SaveName, 그룹명, 소제목, 2행 반영표시, 1행 안내문} — 배열 순서 = 엑셀 열 순서. */
	private static final String[][] COLS = {
		 {"CMS_CATLG_ID",      "상품정보코드",  "",           "",        ""}
		/* 기준가는 상품정보코드 단위로 반영한다.
		 * 양식 원본에 있는 열이라 자리는 남기되, 값은 내려보내지 않고 읽지도 않는다. */
		,{"BUY_INFO_SEQ",      "구매정보코드",  "",           MARK_OFF,  "참고 열입니다. 기준가는 상품정보코드 단위로 반영됩니다"}
		,{"DESCRIPTION_LOC",   "품목명",        "",           "",        ""}
		,{"MODEL_INFO",        "모델번호",      "",           "",        ""}
		,{"SPECIFICATION",     "규격",          "",           "",        ""}
		,{"MAKER_NAME",        "제조사",        "",           "",        ""}
		,{"ORIGIN_NAME",       "원산지",        "",           "",        ""}
		,{"MEASURE",           "단위",          "",           "",        ""}

		,{"PRICE_BEFORE",      "기존",          "기준가",     "",        ""}
		,{"PRICE_TYPE_BEFORE", "기존",          "기준가유형", "",        ""}

		,{"PRICE_AFTER",       "변경",          "기준가",     MARK_ON,   "숫자입력"}
		,{"PRICE_TYPE_AFTER",  "변경",          "기준가유형", MARK_ON,   ""}	// 안내문은 코드 목록으로 채운다
		,{"CHG_REASON",        "변경",          "변경사유",   MARK_ON,   "텍스트 입력"}
	};

	// 기준가유형[변경] 열의 위치(0-based). 드롭다운을 여기 건다.
	private static final int COL_PRICE_TYPE_AFTER = 11;

	/* 열의 성격. 색·글자색이 여기서 갈린다. (상품 양식과 같은 규약) */
	private static final int ROLE_FIXED  = 0;	// 시스템이 채워 보낸 값 — 고쳐도 반영되지 않는다
	private static final int ROLE_INPUT  = 1;	// 담당자가 채우는 칸
	private static final int ROLE_IGNORE = 2;	// 눈으로 보라고 둔 참고 칸(▼미반영)

	private static final byte[] C_BAND_A   = rgb(0x40, 0x40, 0x40);
	private static final byte[] C_BAND_B   = rgb(0x59, 0x59, 0x59);
	private static final byte[] C_SUB_FIX  = rgb(0xD9, 0xD9, 0xD9);
	private static final byte[] C_FIXED    = rgb(0xE7, 0xE6, 0xE6);
	private static final byte[] C_INPUT    = rgb(0xFF, 0xF2, 0xCC);
	private static final byte[] C_IGNORE   = rgb(0xF2, 0xF2, 0xF2);
	private static final byte[] C_GUIDE_BG = rgb(0xF7, 0xF7, 0xF7);
	private static final byte[] C_TXT      = rgb(0x33, 0x33, 0x33);
	private static final byte[] C_TXT_HEAD = rgb(0xFF, 0xFF, 0xFF);
	private static final byte[] C_TXT_MUTE = rgb(0x80, 0x80, 0x80);
	private static final byte[] C_TXT_ON   = rgb(0x40, 0x40, 0x40);
	private static final byte[] C_LINE     = rgb(0xBF, 0xBF, 0xBF);
	private static final byte[] C_LINE_GRP = rgb(0x40, 0x40, 0x40);

	private final XSSFWorkbook wb;
	/* 스타일은 [성격/띠][그룹 첫 열인가] 로 미리 만들어 재사용한다.
	 * 셀마다 만들면 XSSF 스타일 수가 폭발해 파일이 무거워지고 엑셀이 경고를 낸다. */
	private CellStyle[]   stGuide = new CellStyle[2];
	private CellStyle[][] stMark  = new CellStyle[3][2];
	private CellStyle[][] stGroup = new CellStyle[2][2];
	private CellStyle[][] stSub   = new CellStyle[3][2];
	private CellStyle[][] stData  = new CellStyle[3][2];

	/** 기준가유형 안내문 — 드롭다운 목록을 "1. A 2. B" 형태로 펼쳐 1행에 적는다. */
	private String typeGuide = "";

	private MasterMdCmCmsBasePriceFormExcel() {
		this.wb = new XSSFWorkbook();
	}

	/**
	 * 양식 워크북을 만든다.
	 *
	 * @param rows       상품 1건 = Map 1개. 키는 COLS 의 SaveName
	 * @param priceTypes 기준가유형 명칭 목록(ICOMCOD1 M183). 드롭다운·안내문의 원본이다
	 */
	public static XSSFWorkbook build(List<Map<String,String>> rows, List<String> priceTypes) {
		MasterMdCmCmsBasePriceFormExcel maker = new MasterMdCmCmsBasePriceFormExcel();
		return maker.make(rows, priceTypes);
	}

	private XSSFWorkbook make(List<Map<String,String>> rows, List<String> priceTypes) {
		XSSFSheet form = wb.createSheet(FORM_SHEET);
		XSSFSheet list = wb.createSheet(LIST_SHEET);

		typeGuide = buildTypeGuide(priceTypes);
		initStyles();
		writeTypeSheet(list, priceTypes);
		writeHeader(form);
		int lastRow = writeData(form, rows);
		addValidations(form, lastRow, priceTypes);

		form.createFreezePane(1, 4);
		wb.setSheetHidden(wb.getSheetIndex(list), true);
		wb.setActiveSheet(0);
		return wb;
	}

	/** "1. 전체 카테고리 평균매익율+α 2. 판매권고가(구매수기입력)" + 미입력 규칙 안내. */
	private String buildTypeGuide(List<String> priceTypes) {
		StringBuffer sb = new StringBuffer();
		if (priceTypes != null) {
			for (int i = 0; i < priceTypes.size(); i++) {
				if (sb.length() > 0) { sb.append(" "); }
				sb.append(i + 1).append(". ").append(priceTypes.get(i));
			}
		}
		if (sb.length() > 0) { sb.append(" "); }
		sb.append("(미입력 시 기존과 동일)");
		return sb.toString();
	}

	/* ── 목록 시트 : A열에 기준가유형. 드롭다운 원본이다. ── */
	private void writeTypeSheet(XSSFSheet list, List<String> priceTypes) {
		XSSFRow head = list.createRow(0);
		head.createCell(0).setCellValue("기준가유형");
		if (priceTypes != null) {
			for (int i = 0; i < priceTypes.size(); i++) {
				list.createRow(i + 1).createCell(0).setCellValue(priceTypes.get(i));
			}
		}
		list.setColumnWidth(0, 32 * 256);
	}

	/* ── 헤더 4행 : 1행 안내문 / 2행 반영표시 / 3행 그룹명(병합) / 4행 소제목 ── */
	private void writeHeader(XSSFSheet form) {
		XSSFRow r1 = form.createRow(0);
		XSSFRow r2 = form.createRow(1);
		XSSFRow r3 = form.createRow(2);
		XSSFRow r4 = form.createRow(3);
		r1.setHeightInPoints(48);
		r2.setHeightInPoints(16);
		r3.setHeightInPoints(20);
		r4.setHeightInPoints(20);

		int total = COLS.length;
		for (int c = 0; c < total; c++) {
			int edge = isGroupStart(c) ? 1 : 0;	// 그룹이 바뀌는 열에만 굵은 세로선을 세운다
			cell(r1, c, guideAt(c), stGuide[edge]);
			cell(r2, c, COLS[c][3], stMark[markKindAt(c)][edge]);
			cell(r3, c, "",         stGroup[bandAt(c)][edge]);
			cell(r4, c, COLS[c][2], stSub[roleAt(c)][edge]);
			form.setColumnWidth(c, widthAt(c) * 256);
		}

		// 그룹명은 연속 구간의 첫 칸에 쓰고 가로 병합한다. 소제목이 없는 열은 세로 병합.
		int start = 0;
		while (start < total) {
			String group = COLS[start][1];
			int end = start;
			while (end + 1 < total && COLS[end + 1][1].equals(group)) { end++; }

			cell(r3, start, group, stGroup[bandAt(start)][1]);
			if (COLS[start][2].length() == 0 && start == end) {
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

		for (int i = 0; i < rows.size(); i++) {
			Map<String,String> src = rows.get(i);
			XSSFRow r = form.createRow(rowIdx++);
			for (int c = 0; c < COLS.length; c++) {
				cell(r, c, CommonUtil.nvl(src.get(COLS[c][0])), stData[roleAt(c)][isGroupStart(c) ? 1 : 0]);
			}
		}
		return Math.max(rowIdx, DATA_START_ROW);	// 데이터가 없어도 유효성은 첫 행에 걸어 둔다
	}

	/* ── 유효성 : 기준가유형[변경] 열에 단순 목록 드롭다운 ──
	 * ⚠ setSuppressDropDownArrow(true) 가 "드롭다운 표시" 다(이름과 반대).
	 * 코드가 비면 유효성을 걸지 않는다 — 빈 목록은 엑셀이 거부한다. */
	private void addValidations(XSSFSheet form, int lastRow, List<String> priceTypes) {
		if (priceTypes == null || priceTypes.size() == 0) { return; }

		XSSFDataValidationHelper h = new XSSFDataValidationHelper(form);
		int first = DATA_START_ROW - 1;
		int last  = Math.max(lastRow - 1, first);

		String[] items = priceTypes.toArray(new String[priceTypes.size()]);
		DataValidationConstraint con = h.createExplicitListConstraint(items);

		CellRangeAddressList range = new CellRangeAddressList(first, last, COL_PRICE_TYPE_AFTER, COL_PRICE_TYPE_AFTER);
		DataValidation dv = h.createValidation(con, range);
		dv.setSuppressDropDownArrow(true);
		dv.setShowErrorBox(true);
		dv.setEmptyCellAllowed(true);
		form.addValidationData(dv);
	}

	/* ── 스타일 ── */
	private void initStyles() {
		XSSFFont fGuide   = font(9,  false, false, C_TXT_MUTE);
		XSSFFont fGroup   = font(10, true,  false, C_TXT_HEAD);
		XSSFFont fSub     = font(9,  true,  false, C_TXT);
		XSSFFont fSubOff  = font(9,  false, true,  C_TXT_MUTE);
		XSSFFont fData    = font(9,  false, false, C_TXT);
		XSSFFont fFixed   = font(9,  false, false, C_TXT_MUTE);
		XSSFFont fMarkOn  = font(9,  true,  false, C_TXT_ON);
		XSSFFont fMarkOff = font(9,  false, true,  C_TXT_MUTE);

		for (int edge = 0; edge < 2; edge++) {
			boolean e = (edge == 1);

			stGuide[edge] = style(fGuide, C_GUIDE_BG, e, true, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_TOP);

			stMark[ROLE_FIXED][edge]  = style(fMarkOff, null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stMark[ROLE_INPUT][edge]  = style(fMarkOn,  null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stMark[ROLE_IGNORE][edge] = style(fMarkOff, null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stGroup[0][edge] = style(fGroup, C_BAND_A, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stGroup[1][edge] = style(fGroup, C_BAND_B, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stSub[ROLE_FIXED][edge]  = style(fSub,    C_SUB_FIX, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stSub[ROLE_INPUT][edge]  = style(fSub,    C_INPUT,   e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stSub[ROLE_IGNORE][edge] = style(fSubOff, C_IGNORE,  e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stData[ROLE_FIXED][edge]  = style(fFixed, C_FIXED, e, false, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_CENTER);
			stData[ROLE_INPUT][edge]  = style(fData,  null,    e, false, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_CENTER);
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

	/* ── 열 정의 접근자 ── */

	public static int totalColCount() {
		return COLS.length;
	}

	/** 0-based 열 번호 → SaveName. 업로드 ColumnMapping 과 같은 순서를 보장하는 단일 출처다. */
	public static String saveNameAt(int col) {
		return COLS[col][0];
	}

	/** 1행 안내문. 기준가유형만 코드 목록으로 만들어 넣는다. */
	private String guideAt(int col) {
		if (col == COL_PRICE_TYPE_AFTER) { return typeGuide; }
		return COLS[col][4];
	}

	/** 열의 성격. 상품정보·기존값은 고정, ▼미반영 참고칸은 IGNORE, 나머지는 입력칸. */
	private static int roleAt(int col) {
		if (MARK_OFF.equals(COLS[col][3])) { return ROLE_IGNORE; }
		if (MARK_ON.equals(COLS[col][3]))  { return ROLE_INPUT; }
		return ROLE_FIXED;
	}

	/** 2행 반영표시의 색 구분. */
	private static int markKindAt(int col) {
		return MARK_ON.equals(COLS[col][3]) ? ROLE_INPUT : ROLE_FIXED;
	}

	/** 그룹이 바뀌는 첫 열인가. 여기에만 굵은 세로선을 세워 항목군을 갈라 보인다. */
	private static boolean isGroupStart(int col) {
		return col == 0 || !COLS[col][1].equals(COLS[col - 1][1]);
	}

	/** 그룹 띠 색 번갈이. */
	private static int bandAt(int col) {
		int band = 0;
		for (int i = 1; i <= col; i++) {
			if (isGroupStart(i)) { band ^= 1; }
		}
		return band;
	}

	private static int widthAt(int col) {
		String save = COLS[col][0];
		if ("SPECIFICATION".equals(save)) { return 30; }
		if ("DESCRIPTION_LOC".equals(save) || "CHG_REASON".equals(save)) { return 24; }
		if (save.startsWith("PRICE_TYPE")) { return 28; }
		return 14;
	}
}
