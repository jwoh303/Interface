package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.koreab2b.mro.util.CommonUtil;

/**
 * 표준DB > 구매정보 고객사 매핑변경 양식(10열)을 POI 로 생성한다.
 *
 * 일괄수정 양식(MasterMdCmCmsBuyInfoModFormExcel)과 같은 골격이고, 밴드가 셋으로 단순하다.
 *   기존 표준DB(2) · 매핑 고객사DB(6) · 변경 표준DB(2 — 입력칸)
 * 그룹사 1건이 고객사 N행으로 펼쳐지므로 한 구매정보에 여러 행이 나온다.
 * ⚠ 열 순서는 cmsBuyInfoMapForm.js 의 MDCM_MAP_EXCEL_COLS 와 반드시 일치해야 한다.
 */
public class MasterMdCmCmsBuyInfoMapFormExcel {

	/** 데이터 시작행(1-based). 헤더 3행 뒤. cmsBuyInfoMapForm.js 의 MDCM_MAP_DATA_START_ROW 와 같아야 한다. */
	public static final int DATA_START_ROW = 4;

	private static final String FORM_SHEET = "Sheet1";

	private static final String MARK_ON = "▼입력 시 반영";

	/** 열 정의. {SaveName, 그룹명, 소제목, 2행 반영표시, 1행 안내문} — 배열 순서 = 엑셀 열 순서. */
	private static final String[][] COLS = {
		 {"CMS_CATLG_ID",    "기존 표준DB",      "상품정보코드",     "",      ""}
		,{"BUY_INFO_SEQ",    "기존 표준DB",      "구매정보코드",     "",      ""}

		,{"GROUP_CODE",      "매핑 고객사DB",    "그룹사코드",       "",      ""}
		,{"GROUP_NAME",      "매핑 고객사DB",    "그룹사명",         "",      ""}
		,{"BUYER_CODE",      "매핑 고객사DB",    "고객사코드",       "",      ""}
		,{"BUYER_NAME",      "매핑 고객사DB",    "고객사명",         "",      ""}
		,{"BUYER_ITEM_NO",   "매핑 고객사DB",    "고객사 품목코드",  "",      ""}
		,{"CSV_YN",    "매핑 고객사DB",    "고객사지정여부",   "",      "Y 인 행은 동일 협력사로만 이관할 수 있습니다"}

		,{"NEW_CMS_CATLG_ID","변경 표준DB",      "*상품정보코드",    MARK_ON, "이관할 상품정보코드"}
		,{"NEW_BUY_INFO_SEQ","변경 표준DB",      "*구매정보코드",    MARK_ON, "이관할 구매정보 순번 (ex. 00001)"}
	};

	/* 열의 성격. 색·글자색이 여기서 갈린다. */
	private static final int ROLE_FIXED = 0;	// 시스템이 채워 보낸 값 — 고쳐도 반영되지 않는다
	private static final int ROLE_INPUT = 1;	// 담당자가 채우는 칸

	private static final byte[] C_BAND_A   = rgb(0x40, 0x40, 0x40);
	private static final byte[] C_BAND_B   = rgb(0x59, 0x59, 0x59);
	private static final byte[] C_SUB_FIX  = rgb(0xD9, 0xD9, 0xD9);
	private static final byte[] C_FIXED    = rgb(0xE7, 0xE6, 0xE6);
	private static final byte[] C_INPUT    = rgb(0xFF, 0xF2, 0xCC);
	private static final byte[] C_GUIDE_BG = rgb(0xF7, 0xF7, 0xF7);
	private static final byte[] C_TXT      = rgb(0x33, 0x33, 0x33);
	private static final byte[] C_TXT_HEAD = rgb(0xFF, 0xFF, 0xFF);
	private static final byte[] C_TXT_MUTE = rgb(0x80, 0x80, 0x80);
	private static final byte[] C_LINE     = rgb(0xBF, 0xBF, 0xBF);
	private static final byte[] C_LINE_GRP = rgb(0x40, 0x40, 0x40);

	private final XSSFWorkbook wb;
	private CellStyle[]   stGuide = new CellStyle[2];
	private CellStyle[][] stGroup = new CellStyle[2][2];
	private CellStyle[][] stSub   = new CellStyle[2][2];
	private CellStyle[][] stData  = new CellStyle[2][2];

	private MasterMdCmCmsBuyInfoMapFormExcel() {
		this.wb = new XSSFWorkbook();
	}

	/**
	 * 양식 워크북을 만든다.
	 *
	 * @param rows 고객사 매핑 1건 = Map 1개. 키는 COLS 의 SaveName
	 */
	public static XSSFWorkbook build(List<Map<String,String>> rows) {
		MasterMdCmCmsBuyInfoMapFormExcel maker = new MasterMdCmCmsBuyInfoMapFormExcel();
		return maker.make(rows);
	}

	private XSSFWorkbook make(List<Map<String,String>> rows) {
		XSSFSheet form = wb.createSheet(FORM_SHEET);

		initStyles();
		writeHeader(form);
		writeData(form, rows);

		form.createFreezePane(2, 3);
		wb.setActiveSheet(0);
		return wb;
	}

	/* ── 헤더 3행 : 1행 안내문 / 2행 그룹명(병합) / 3행 소제목 ── */
	private void writeHeader(XSSFSheet form) {
		XSSFRow r1 = form.createRow(0);
		XSSFRow r2 = form.createRow(1);
		XSSFRow r3 = form.createRow(2);
		r1.setHeightInPoints(36);
		r2.setHeightInPoints(20);
		r3.setHeightInPoints(20);

		int total = COLS.length;
		for (int c = 0; c < total; c++) {
			int edge = isGroupStart(c) ? 1 : 0;	// 그룹이 바뀌는 열에만 굵은 세로선을 세운다
			cell(r1, c, COLS[c][4], stGuide[edge]);
			cell(r2, c, "",         stGroup[bandAt(c)][edge]);
			cell(r3, c, subTitleAt(c), stSub[roleAt(c)][edge]);
			form.setColumnWidth(c, widthAt(c) * 256);
		}

		// 그룹명은 연속 구간의 첫 칸에 쓰고 가로 병합한다.
		int start = 0;
		while (start < total) {
			String group = COLS[start][1];
			int end = start;
			while (end + 1 < total && COLS[end + 1][1].equals(group)) { end++; }

			cell(r2, start, group, stGroup[bandAt(start)][1]);
			if (end > start) {
				form.addMergedRegion(new CellRangeAddress(1, 1, start, end));
			}
			start = end + 1;
		}
	}

	/* ── 데이터 : 4행부터. 변경 표준DB 2열은 빈 칸으로 둔다(담당자가 채울 자리). ── */
	private int writeData(XSSFSheet form, List<Map<String,String>> rows) {
		int rowIdx = DATA_START_ROW - 1;

		if (rows != null) {
			for (int i = 0; i < rows.size(); i++) {
				Map<String,String> src = rows.get(i);
				XSSFRow r = form.createRow(rowIdx++);
				for (int c = 0; c < COLS.length; c++) {
					cell(r, c, CommonUtil.nvl(src.get(COLS[c][0])), stData[roleAt(c)][isGroupStart(c) ? 1 : 0]);
				}
			}
		}
		return Math.max(rowIdx, DATA_START_ROW);
	}

	/* ── 스타일 ── */
	private void initStyles() {
		XSSFFont fGuide = font(9,  false, C_TXT_MUTE);
		XSSFFont fGroup = font(10, true,  C_TXT_HEAD);
		XSSFFont fSub   = font(9,  true,  C_TXT);
		XSSFFont fData  = font(9,  false, C_TXT);
		XSSFFont fFixed = font(9,  false, C_TXT_MUTE);

		for (int edge = 0; edge < 2; edge++) {
			boolean e = (edge == 1);

			stGuide[edge] = style(fGuide, C_GUIDE_BG, e, true, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_TOP);

			stGroup[0][edge] = style(fGroup, C_BAND_A, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stGroup[1][edge] = style(fGroup, C_BAND_B, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stSub[ROLE_FIXED][edge] = style(fSub, C_SUB_FIX, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stSub[ROLE_INPUT][edge] = style(fSub, C_INPUT,   e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stData[ROLE_FIXED][edge] = style(fFixed, C_FIXED, e, false, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_CENTER);
			stData[ROLE_INPUT][edge] = style(fData,  null,    e, false, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_CENTER);
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

	private XSSFFont font(int points, boolean bold, byte[] color) {
		XSSFFont f = wb.createFont();
		f.setFontHeightInPoints((short) points);
		if (bold) { f.setBoldweight(Font.BOLDWEIGHT_BOLD); }
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

	private static String subTitleAt(int col) {
		return COLS[col][2];
	}

	/** 열의 성격. ▼입력 시 반영 이 붙은 칸만 입력칸이고 나머지는 조회 전용이다. */
	private static int roleAt(int col) {
		return MARK_ON.equals(COLS[col][3]) ? ROLE_INPUT : ROLE_FIXED;
	}

	/** 그룹이 바뀌는 첫 열인가. */
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
		if ("BUYER_NAME".equals(save) || "GROUP_NAME".equals(save)) { return 22; }
		if ("BUYER_ITEM_NO".equals(save))                           { return 20; }
		if ("CSV_YN".equals(save))                            { return 16; }
		return 18;
	}
}
