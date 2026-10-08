package com.koreab2b.mro.master.mdcm.service;

import java.util.ArrayList;
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
 * 표준DB > 구매정보 일괄등록 양식(14열)을 POI 로 생성한다.
 *
 * 기준가 양식(MasterMdCmCmsBasePriceFormExcel)과 골격이 같고 다른 점은 세 가지다.
 *   (1) 헤더가 3행이다 — 안내문 / 항목명 / 소제목(매입단가 유효기간의 시작일·종료일).
 *   (2) 기존값 밴드가 없다. 전 열이 입력칸이라 담당자가 채워 넣는 빈 양식이다.
 *   (3) 목록에서 체크한 상품이 있으면 상품정보코드만 채워 내린다.
 * ⚠ 열 순서는 cmsBuyInfoRegForm.js 의 MDCM_REG_EXCEL_COLS 와 반드시 일치해야 한다.
 */
public class MasterMdCmCmsBuyInfoRegFormExcel {

	/** 데이터 시작행(1-based). 헤더 3행 뒤. cmsBuyInfoRegForm.js 의 MDCM_REG_DATA_START_ROW 와 같아야 한다. */
	public static final int DATA_START_ROW = 4;

	private static final String FORM_SHEET = "Sheet1";
	/* 드롭다운 원본 시트. 지우면 드롭다운이 통째로 죽으므로 이름으로 경고하고 숨긴다. */
	private static final String LIST_SHEET = "■코드목록(삭제금지)";

	/** 열 정의. {SaveName, 항목명, 소제목, 안내문} — 배열 순서 = 엑셀 열 순서. */
	private static final String[][] COLS = {
		 {"CMS_CATLG_ID",   "상품정보코드",        "",       ""}
		,{"AGENT",          "협력사코드",          "",       ""}
		,{"BUY_PRICE",      "매입단가 (VAT별도)",  "",       "숫자"}
		,{"MIN_ORDER_QTY",  "최소주문수량",        "",       "숫자"}
		,{"PUR_UNIT_QTY",   "주문배수수량",        "",       "숫자"}
		,{"PROCESS_TYPE",   "거래유형",            "",       "직납 : 0  재고 : 1  TR : 2  VMI : 3"}
		,{"DELIVERY_TYPE",  "배송유형",            "",       "택배  자차"}
		,{"WAREHOUSE_CODE", "입고TR",              "",       "물류센터명을 목록에서 선택"}
		,{"DELIVERY_LT",    "배송일수",            "",       "숫자"}
		,{"ITEM_MAKE_TYPE", "품목구분",            "",       "표준품_내자 : ST  표준품_외자 : SI  주문제작품_내자 : MK  주문제작품_외자 : MI"}
		,{"TAX_TYPE",       "과세구분",            "",       "과세 : 11  면세 : 12"}
		,{"SELLER_ITEM_NO", "협력사 품목코드",     "",       ""}
		,{"BUY_OPEN_DATE",  "매입단가 유효기간",   "시작일", "ex. 20260102"}
		,{"BUY_CLOSE_DATE", "매입단가 유효기간",   "종료일", "ex. 20270101"}
	};

	private static final int COL_PROCESS_TYPE   = 5;
	private static final int COL_DELIVERY_TYPE  = 6;
	private static final int COL_WAREHOUSE_CODE = 7;
	private static final int COL_ITEM_MAKE_TYPE = 9;
	private static final int COL_TAX_TYPE       = 10;

	private static final int ROLE_INPUT = 0;

	private static final byte[] C_BAND_A   = rgb(0x40, 0x40, 0x40);
	private static final byte[] C_BAND_B   = rgb(0x59, 0x59, 0x59);
	private static final byte[] C_INPUT    = rgb(0xFF, 0xF2, 0xCC);
	private static final byte[] C_GUIDE_BG = rgb(0xF7, 0xF7, 0xF7);
	private static final byte[] C_TXT      = rgb(0x33, 0x33, 0x33);
	private static final byte[] C_TXT_HEAD = rgb(0xFF, 0xFF, 0xFF);
	private static final byte[] C_TXT_MUTE = rgb(0x80, 0x80, 0x80);
	private static final byte[] C_LINE     = rgb(0xBF, 0xBF, 0xBF);
	private static final byte[] C_LINE_GRP = rgb(0x40, 0x40, 0x40);

	private final XSSFWorkbook wb;
	/* 스타일은 [성격][그룹 첫 열인가] 로 미리 만들어 재사용한다.
	 * 셀마다 만들면 XSSF 스타일 수가 폭발해 파일이 무거워지고 엑셀이 경고를 낸다. */
	private CellStyle[]   stGuide = new CellStyle[2];
	private CellStyle[][] stGroup = new CellStyle[2][2];
	private CellStyle[][] stSub   = new CellStyle[1][2];
	private CellStyle[][] stData  = new CellStyle[1][2];

	private MasterMdCmCmsBuyInfoRegFormExcel() {
		this.wb = new XSSFWorkbook();
	}

	/**
	 * 양식 워크북을 만든다.
	 *
	 * @param catlgIds   A열에 미리 채울 상품정보코드. 없으면 데이터행이 없는 빈 양식이 된다
	 * @param makeTypes  품목구분 코드 목록(ICOMCOD1 M132). 드롭다운 원본
	 * @param warehouses 입고TR(물류센터) 명칭 목록(ICOMCOD1 W001). 드롭다운 원본 — 저장은 센터코드라 업로드가 되돌린다
	 */
	public static XSSFWorkbook build(List<String> catlgIds, List<String> makeTypes, List<String> warehouses) {
		MasterMdCmCmsBuyInfoRegFormExcel maker = new MasterMdCmCmsBuyInfoRegFormExcel();
		return maker.make(catlgIds, makeTypes, warehouses);
	}

	private XSSFWorkbook make(List<String> catlgIds, List<String> makeTypes, List<String> warehouses) {
		XSSFSheet form = wb.createSheet(FORM_SHEET);
		XSSFSheet list = wb.createSheet(LIST_SHEET);

		initStyles();
		writeListSheet(list, makeTypes, warehouses);
		writeHeader(form);
		int lastRow = writeData(form, catlgIds);
		addValidations(form, lastRow, makeTypes, warehouses);

		form.createFreezePane(1, 3);
		wb.setSheetHidden(wb.getSheetIndex(list), true);
		wb.setActiveSheet(0);
		return wb;
	}

	/* ── 목록 시트 : 드롭다운 원본 ── */
	private void writeListSheet(XSSFSheet list, List<String> makeTypes, List<String> warehouses) {
		writeListCol(list, 0, "거래유형",  processTypeItems());
		writeListCol(list, 1, "배송유형",  deliveryTypeItems());
		writeListCol(list, 2, "품목구분",  toArray(makeTypes));
		writeListCol(list, 3, "과세구분",  taxTypeItems());
		writeListCol(list, 4, "입고TR",    toArray(warehouses));
	}

	private void writeListCol(XSSFSheet list, int col, String title, String[] items) {
		XSSFRow head = list.getRow(0);
		if (head == null) { head = list.createRow(0); }
		head.createCell(col).setCellValue(title);
		for (int i = 0; i < items.length; i++) {
			XSSFRow r = list.getRow(i + 1);
			if (r == null) { r = list.createRow(i + 1); }
			r.createCell(col).setCellValue(items[i]);
		}
		list.setColumnWidth(col, 18 * 256);
	}

	/* ── 헤더 3행 : 1행 안내문 / 2행 항목명(병합) / 3행 소제목 ── */
	private void writeHeader(XSSFSheet form) {
		XSSFRow r1 = form.createRow(0);
		XSSFRow r2 = form.createRow(1);
		XSSFRow r3 = form.createRow(2);
		r1.setHeightInPoints(42);
		r2.setHeightInPoints(20);
		r3.setHeightInPoints(20);

		int total = COLS.length;
		for (int c = 0; c < total; c++) {
			int edge = isGroupStart(c) ? 1 : 0;	// 그룹이 바뀌는 열에만 굵은 세로선을 세운다
			cell(r1, c, COLS[c][3], stGuide[edge]);
			cell(r2, c, "",         stGroup[bandAt(c)][edge]);
			cell(r3, c, COLS[c][2], stSub[roleAt(c)][edge]);
			form.setColumnWidth(c, widthAt(c) * 256);
		}

		// 항목명은 연속 구간의 첫 칸에 쓰고 가로 병합한다. 소제목이 없는 열은 세로 병합.
		int start = 0;
		while (start < total) {
			String group = COLS[start][1];
			int end = start;
			while (end + 1 < total && COLS[end + 1][1].equals(group)) { end++; }

			cell(r2, start, group, stGroup[bandAt(start)][1]);
			if (COLS[start][2].length() == 0 && start == end) {
				form.addMergedRegion(new CellRangeAddress(1, 2, start, end));
			} else if (end > start) {
				form.addMergedRegion(new CellRangeAddress(1, 1, start, end));
			}
			start = end + 1;
		}
	}

	/* ── 데이터 : 4행부터. 상품정보코드만 채우고 나머지는 담당자가 채울 빈 칸으로 둔다. ── */
	private int writeData(XSSFSheet form, List<String> catlgIds) {
		int rowIdx = DATA_START_ROW - 1;
		if (catlgIds != null) {
			for (int i = 0; i < catlgIds.size(); i++) {
				XSSFRow r = form.createRow(rowIdx++);
				for (int c = 0; c < COLS.length; c++) {
					String value = (c == 0) ? CommonUtil.nvl(catlgIds.get(i)) : "";
					cell(r, c, value, stData[roleAt(c)][isGroupStart(c) ? 1 : 0]);
				}
			}
		}
		return Math.max(rowIdx, DATA_START_ROW);	// 데이터가 없어도 유효성은 첫 행에 걸어 둔다
	}

	/* ── 유효성 : 코드값이 정해진 열에 드롭다운 ──
	 * ⚠ setSuppressDropDownArrow(true) 가 "드롭다운 표시" 다(이름과 반대).
	 * 목록이 비면 유효성을 걸지 않는다 — 빈 목록은 엑셀이 거부한다. */
	private void addValidations(XSSFSheet form, int lastRow, List<String> makeTypes, List<String> warehouses) {
		int first = DATA_START_ROW - 1;
		int last  = Math.max(lastRow - 1, first);

		addValidation(form, first, last, COL_PROCESS_TYPE,   processTypeItems());
		addValidation(form, first, last, COL_DELIVERY_TYPE,  deliveryTypeItems());
		addValidation(form, first, last, COL_ITEM_MAKE_TYPE, toArray(makeTypes));
		addValidation(form, first, last, COL_TAX_TYPE,       taxTypeItems());
		addValidation(form, first, last, COL_WAREHOUSE_CODE, toArray(warehouses));
	}

	private void addValidation(XSSFSheet form, int first, int last, int col, String[] items) {
		if (items == null || items.length == 0) { return; }

		XSSFDataValidationHelper h = new XSSFDataValidationHelper(form);
		DataValidationConstraint con = h.createExplicitListConstraint(items);
		DataValidation dv = h.createValidation(con, new CellRangeAddressList(first, last, col, col));
		dv.setSuppressDropDownArrow(true);
		dv.setShowErrorBox(true);
		dv.setEmptyCellAllowed(true);
		form.addValidationData(dv);
	}

	/* ── 스타일 ── */
	private void initStyles() {
		XSSFFont fGuide  = font(9,  false, false, C_TXT_MUTE);
		XSSFFont fGroup  = font(10, true,  false, C_TXT_HEAD);
		XSSFFont fSub    = font(9,  true,  false, C_TXT);
		XSSFFont fData   = font(9,  false, false, C_TXT);

		for (int edge = 0; edge < 2; edge++) {
			boolean e = (edge == 1);

			stGuide[edge] = style(fGuide, C_GUIDE_BG, e, true, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_TOP);

			stGroup[0][edge] = style(fGroup, C_BAND_A, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stGroup[1][edge] = style(fGroup, C_BAND_B, e, true, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

			stSub[ROLE_INPUT][edge]  = style(fSub,  C_INPUT, e, true,  CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stData[ROLE_INPUT][edge] = style(fData, null,    e, false, CellStyle.ALIGN_LEFT,   CellStyle.VERTICAL_CENTER);
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

	public static String[] processTypeItems() {
		return new String[]{"0", "1", "2", "3"};
	}

	public static String[] deliveryTypeItems() {
		return new String[]{"택배", "자차"};
	}

	public static String[] taxTypeItems() {
		return new String[]{"11", "12"};
	}

	private static String[] toArray(List<String> list) {
		if (list == null) { return new String[0]; }
		List<String> keep = new ArrayList<String>();
		for (String s : list) {
			String v = CommonUtil.nvl(s).trim();
			if (v.length() > 0) { keep.add(v); }
		}
		return keep.toArray(new String[keep.size()]);
	}

	/** 전 열이 담당자가 채우는 입력칸이다. */
	private static int roleAt(int col) {
		return ROLE_INPUT;
	}

	/** 항목이 바뀌는 첫 열인가. 여기에만 굵은 세로선을 세워 항목군을 갈라 보인다. */
	private static boolean isGroupStart(int col) {
		return col == 0 || !COLS[col][1].equals(COLS[col - 1][1]);
	}

	/** 항목 띠 색 번갈이. */
	private static int bandAt(int col) {
		int band = 0;
		for (int i = 1; i <= col; i++) {
			if (isGroupStart(i)) { band ^= 1; }
		}
		return band;
	}

	private static int widthAt(int col) {
		String save = COLS[col][0];
		if ("BUY_PRICE".equals(save))                                      { return 20; }
		if ("WAREHOUSE_CODE".equals(save))                                 { return 22; }
		if ("ITEM_MAKE_TYPE".equals(save) || "SELLER_ITEM_NO".equals(save)) { return 20; }
		if ("CMS_CATLG_ID".equals(save) || "AGENT".equals(save))            { return 16; }
		return 14;
	}
}
