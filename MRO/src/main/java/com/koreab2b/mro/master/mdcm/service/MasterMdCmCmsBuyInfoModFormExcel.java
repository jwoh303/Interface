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
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFDataValidationHelper;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFName;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.koreab2b.mro.util.CommonUtil;

/**
 * 표준DB > 구매정보 일괄수정 양식(38열)을 POI 로 생성한다.
 *
 * 기준가 양식(MasterMdCmCmsBasePriceFormExcel)과 같은 골격이다 — 병합 4행 헤더 · 안내문 행 · 드롭다운.
 * 다른 점은 앞 14열이 조회 전용이고 뒤 24열이 [기존/변경/변경사유] 세트 7묶음이라는 것뿐이다.
 * ⚠ 열 순서는 cmsBuyInfoModForm.js 의 MDCM_MODB_EXCEL_COLS 와 반드시 일치해야 한다.
 * ⚠ 공급상태·품목구분·과세구분은 **명칭**으로 주고받는다(기존값과 나란히 비교돼야 해서다). 코드 복원은 화면·서버가 한다.
 */
public class MasterMdCmCmsBuyInfoModFormExcel {

	/** 데이터 시작행(1-based). 헤더 4행 뒤. cmsBuyInfoModForm.js 의 MDCM_MODB_DATA_START_ROW 와 같아야 한다. */
	public static final int DATA_START_ROW = 5;

	private static final String FORM_SHEET = "Sheet4";
	/* 드롭다운 원본 시트. 지우면 [변경]·[변경사유] 드롭다운이 통째로 죽으므로 이름으로 경고한다. */
	private static final String LIST_SHEET = "■코드목록(삭제금지)";

	/* 변경사유 드롭다운을 [변경] 값에 따라 갈라 넣기 위한 이름 영역.
	 * INDIRECT 가 셀에 적힌 글자를 그대로 이름으로 찾으므로 이름은 화면 표기와 글자가 같아야 한다. */
	private static final String STATUS_ON   = "가능";
	private static final String STATUS_OFF  = "불가";

	private static final String MARK_ON  = "▼입력 시 반영";
	private static final String MARK_OFF = "▼미반영";

	/** 열 정의. {SaveName, 그룹명, 소제목, 2행 반영표시, 1행 안내문} — 배열 순서 = 엑셀 열 순서. */
	private static final String[][] COLS = {
		 {"CMS_CATLG_ID",      "상품정보코드",        "",            "",       ""}
		,{"BUY_INFO_SEQ",      "구매정보코드",        "",            "",       ""}
		,{"DESCRIPTION_LOC",   "품목명",              "",            "",       ""}
		,{"MODEL_INFO",        "모델번호",            "",            "",       ""}
		,{"SPECIFICATION",     "규격",                "",            "",       ""}
		,{"MAKER_NAME",        "제조사",              "",            "",       ""}
		,{"ORIGIN_CODE_NAME",       "원산지",              "",            "",       ""}
		,{"ORDER_MEASURE",           "단위",                "",            "",       ""}
		,{"MIN_ORDER_QTY",     "최소주문수량",        "",            "",       ""}
		,{"PUR_UNIT_QTY",      "주문배수수량",        "",            "",       ""}
		,{"PROCESS_TYPE",      "거래유형",            "",            "",       ""}
		,{"DELIVERY_TYPE",     "배송유형",            "",            "",       ""}
		,{"AGENT_NAME",       "협력사명",            "",            "",       ""}
		,{"AGENT",             "협력사코드",          "",            "",       ""}

		,{"STATUS_BEFORE",     "공급상태",            "기존",        "",       ""}
		,{"STATUS_AFTER",      "공급상태",            "변경",        MARK_ON,  "가능 / 불가"}
		,{"STATUS_REASON",     "공급상태",            "변경사유",    MARK_ON,  ""}	// 안내문은 사유 목록으로 채운다
		,{"ALT_CODE",          "공급상태",            "대체코드",    MARK_ON,  "변경사유가 중복존재일 경우 기재必"}

		,{"BUY_PRICE_BEFORE",      "매입단가(VAT별도)",   "기존",        "",       ""}
		,{"BUY_PRICE_AFTER",       "매입단가(VAT별도)",   "변경",        MARK_ON,  "숫자입력"}
		,{"BUY_PRICE_REASON",      "매입단가(VAT별도)",   "변경사유",    MARK_ON,  "텍스트 입력"}

		,{"BUY_OPEN_DATE_BEFORE", "매입단가 유효기간",   "기존 시작일", "",       ""}
		,{"BUY_CLOSE_DATE_BEFORE",   "매입단가 유효기간",   "기존 종료일", "",       ""}
		,{"BUY_OPEN_DATE_AFTER",  "매입단가 유효기간",   "변경 시작일", MARK_ON,  "ex. 20260102"}
		,{"BUY_CLOSE_DATE_AFTER",    "매입단가 유효기간",   "변경 종료일", MARK_ON,  "ex. 20270101"}
		,{"BUY_DATE_REASON",      "매입단가 유효기간",   "변경사유",    MARK_ON,  "텍스트 입력"}

		,{"DELIVERY_LT_BEFORE",         "배송일수",            "기존",        "",       ""}
		,{"DELIVERY_LT_AFTER",          "배송일수",            "변경",        MARK_ON,  "숫자입력"}
		,{"DELIVERY_LT_REASON",         "배송일수",            "변경사유",    MARK_ON,  "텍스트 입력"}

		,{"ITEM_MAKE_TYPE_BEFORE",       "품목구분",            "기존",        "",       ""}
		,{"ITEM_MAKE_TYPE_AFTER",        "품목구분",            "변경",        MARK_ON,  ""}	// 안내문은 코드 목록으로 채운다
		,{"ITEM_MAKE_TYPE_REASON",       "품목구분",            "변경사유",    MARK_ON,  "텍스트 입력"}

		,{"TAX_TYPE_BEFORE",        "과세구분",            "기존",        "",       ""}
		,{"TAX_TYPE_AFTER",         "과세구분",            "변경",        MARK_ON,  "과세 / 면세"}
		,{"TAX_TYPE_REASON",        "과세구분",            "변경사유",    MARK_ON,  "텍스트 입력"}

		,{"SELLER_ITEM_NO_BEFORE",     "협력사 품목코드",     "기존",        "",       ""}
		,{"SELLER_ITEM_NO_AFTER",      "협력사 품목코드",     "변경",        MARK_ON,  "지우려면 DELETE 입력"}
		,{"SELLER_ITEM_NO_REASON",     "협력사 품목코드",     "변경사유",    MARK_ON,  "텍스트 입력"}
	};

	// 드롭다운을 거는 열의 위치(0-based)
	private static final int COL_STATUS_AFTER = 15;
	private static final int COL_STATUS_REASON = 16;
	private static final int COL_MAKE_AFTER   = 30;
	private static final int COL_TAX_AFTER    = 33;

	/* 열의 성격. 색·글자색이 여기서 갈린다. (기준가 양식과 같은 규약) */
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
	private static final byte[] C_TXT_ON   = rgb(0x40, 0x40, 0x40);
	private static final byte[] C_LINE     = rgb(0xBF, 0xBF, 0xBF);
	private static final byte[] C_LINE_GRP = rgb(0x40, 0x40, 0x40);

	private final XSSFWorkbook wb;
	/* 스타일은 [성격/띠][그룹 첫 열인가] 로 미리 만들어 재사용한다.
	 * 셀마다 만들면 XSSF 스타일 수가 폭발해 파일이 무거워지고 엑셀이 경고를 낸다. */
	private CellStyle[]   stGuide = new CellStyle[2];
	private CellStyle[][] stMark  = new CellStyle[2][2];
	private CellStyle[][] stGroup = new CellStyle[2][2];
	private CellStyle[][] stSub   = new CellStyle[2][2];
	private CellStyle[][] stData  = new CellStyle[2][2];

	private String reasonGuide = "";
	private String makeGuide   = "";

	private MasterMdCmCmsBuyInfoModFormExcel() {
		this.wb = new XSSFWorkbook();
	}

	/**
	 * 양식 워크북을 만든다.
	 *
	 * @param rows      구매정보 1건 = Map 1개. 키는 COLS 의 SaveName
	 * @param reasons   공급상태 변경사유 목록(ICOMCOD1 M185, 시스템 전용 제외). CODE/REASON_NAME/DIRECTION 계약
	 * @param makeTypes 품목구분 명칭 목록(ICOMCOD1 M132)
	 */
	public static XSSFWorkbook build(List<Map<String,String>> rows, List<Map<String,String>> reasons, List<String> makeTypes) {
		MasterMdCmCmsBuyInfoModFormExcel maker = new MasterMdCmCmsBuyInfoModFormExcel();
		return maker.make(rows, reasons, makeTypes);
	}

	private XSSFWorkbook make(List<Map<String,String>> rows, List<Map<String,String>> reasons, List<String> makeTypes) {
		XSSFSheet form = wb.createSheet(FORM_SHEET);
		XSSFSheet list = wb.createSheet(LIST_SHEET);

		String[] reasonOut = directionNames(reasons, "OUT");	// 가능 -> 불가
		String[] reasonIn  = directionNames(reasons, "IN");		// 불가 -> 가능

		reasonGuide = joinDirGuide(reasonOut, reasonIn);
		makeGuide   = joinGuide(makeTypes);
		initStyles();
		writeListSheet(list, reasonOut, reasonIn, makeTypes);
		writeHeader(form);
		int lastRow = writeData(form, rows);
		addValidations(form, lastRow, reasonOut, reasonIn, makeTypes);

		form.createFreezePane(2, 4);
		/* 목록 시트는 드롭다운 원본일 뿐이라 숨긴다 - 숨겨도 유효성·이름 영역은 그대로 동작한다.
		 * ⚠ 숨기기 취소로 다시 보이고 삭제도 된다 - 그래서 시트명으로도 한 번 경고한다. */
		wb.setSheetHidden(wb.getSheetIndex(list), true);
		wb.setActiveSheet(0);
		return wb;
	}

	/** "1. 중복존재 2. 단종 …" 형태로 1행 안내문을 만든다. */
	private String joinGuide(List<String> items) {
		return joinGuide(toArray(items));
	}

	private String joinGuide(String[] items) {
		StringBuffer sb = new StringBuffer();
		if (items != null) {
			for (int i = 0; i < items.length; i++) {
				if (sb.length() > 0) { sb.append(" "); }
				sb.append(i + 1).append(". ").append(items[i]);
			}
		}
		return sb.toString();
	}

	/** 변경사유 안내문 : 방향이 다르면 쓸 수 있는 사유도 다르다 - 갈라 적는다. */
	private String joinDirGuide(String[] reasonOut, String[] reasonIn) {
		StringBuffer sb = new StringBuffer();
		sb.append("[").append(STATUS_OFF).append("] ").append(joinGuide(reasonOut));
		sb.append("   [").append(STATUS_ON).append("] ").append(joinGuide(reasonIn));
		return sb.toString();
	}

	/**
	 * 한 방향의 변경사유 명칭만 뽑는다.
	 * DIRECTION : OUT(가능→불가) / IN(불가→가능). 방향이 비어 있는 사유는 양쪽 모두에 둔다.
	 */
	private static String[] directionNames(List<Map<String,String>> reasons, String direction) {
		List<String> out = new ArrayList<String>();
		if (reasons != null) {
			for (Map<String,String> row : reasons) {
				String name = CommonUtil.nvl(row.get("REASON_NAME")).trim();
				String dir  = CommonUtil.nvl(row.get("DIRECTION")).trim();
				if (name.length() == 0) { continue; }
				if (dir.length() > 0 && !dir.equals(direction)) { continue; }
				if (!out.contains(name)) { out.add(name); }
			}
		}
		return out.toArray(new String[out.size()]);
	}

	private static String[] merge(String[] a, String[] b) {
		List<String> out = new ArrayList<String>();
		for (int i = 0; a != null && i < a.length; i++) { if (!out.contains(a[i])) { out.add(a[i]); } }
		for (int i = 0; b != null && i < b.length; i++) { if (!out.contains(b[i])) { out.add(b[i]); } }
		return out.toArray(new String[out.size()]);
	}

	/* ── 목록 시트 : 드롭다운 원본 ── */
	private void writeListSheet(XSSFSheet list, String[] reasonOut, String[] reasonIn, List<String> makeTypes) {
		writeListCol(list, 0, "공급상태",                  new String[]{STATUS_ON, STATUS_OFF});
		writeListCol(list, 1, "변경사유(" + STATUS_OFF + "로 변경)", reasonOut);
		writeListCol(list, 2, "변경사유(" + STATUS_ON  + "으로 변경)", reasonIn);
		writeListCol(list, 3, "품목구분",                  toArray(makeTypes));
		writeListCol(list, 4, "과세구분",                  new String[]{"과세", "면세"});

		/* [변경] 칸에 적힌 글자가 곳 이름이 되도록 같은 이름으로 등록한다. */
		defineName(STATUS_OFF, 1, reasonOut.length);
		defineName(STATUS_ON,  2, reasonIn.length);
	}

	/** 목록 시트의 한 열(머리글 아래)을 이름 영역으로 등록한다. INDIRECT 가 이 이름을 찾는다. */
	private void defineName(String name, int col, int count) {
		if (count <= 0) { return; }
		String colRef = CellReference.convertNumToColString(col);
		XSSFName n = wb.createName();
		n.setNameName(name);
		n.setRefersToFormula("'" + LIST_SHEET + "'!$" + colRef + "$2:$" + colRef + "$" + (count + 1));
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
		list.setColumnWidth(col, 24 * 256);
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

	/* ── 데이터 : 5행부터. 변경 열은 빈 칸으로 둔다(담당자가 채울 자리). ── */
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

	/* ── 유효성 : 값이 정해진 [변경] 열에 드롭다운 ──
	 * ⚠ setSuppressDropDownArrow(true) 가 "드롭다운 표시" 다(이름과 반대).
	 * 목록이 비면 유효성을 걸지 않는다 — 빈 목록은 엑셀이 거부한다. */
	private void addValidations(XSSFSheet form, int lastRow, String[] reasonOut, String[] reasonIn, List<String> makeTypes) {
		int first = DATA_START_ROW - 1;
		int last  = Math.max(lastRow - 1, first);

		addValidation(form, first, last, COL_STATUS_AFTER,  new String[]{STATUS_ON, STATUS_OFF});
		addReasonValidation(form, first, last, reasonOut, reasonIn);
		addValidation(form, first, last, COL_MAKE_AFTER,    toArray(makeTypes));
		addValidation(form, first, last, COL_TAX_AFTER,     new String[]{"과세", "면세"});
	}

	/* 변경사유는 같은 행의 [변경] 값에 딸린 목록만 보여 준다 -
	 * 불가로 내리는 사유(OUT)와 가능으로 되돌리는 사유(IN)는 서로 쓸 수 없다(업로드 검증도 같은 규약).
	 * ⚠ INDIRECT 의 행 번호는 유효성 영역의 첫 행 기준이다 - 행마다 상대로 따라 내려간다.
	 * ⚠ 한쪽 방향이 비면 이름 영역이 없으므로 전체 목록을 건다. */
	private void addReasonValidation(XSSFSheet form, int first, int last, String[] reasonOut, String[] reasonIn) {
		if (reasonOut.length == 0 || reasonIn.length == 0) {
			addValidation(form, first, last, COL_STATUS_REASON, merge(reasonOut, reasonIn));
			return;
		}

		String statusRef = "$" + CellReference.convertNumToColString(COL_STATUS_AFTER) + (first + 1);

		XSSFDataValidationHelper h = new XSSFDataValidationHelper(form);
		DataValidationConstraint con = h.createFormulaListConstraint("INDIRECT(" + statusRef + ")");
		DataValidation dv = h.createValidation(con, new CellRangeAddressList(first, last, COL_STATUS_REASON, COL_STATUS_REASON));
		dv.setSuppressDropDownArrow(true);
		dv.setShowErrorBox(true);
		dv.setEmptyCellAllowed(true);
		form.addValidationData(dv);
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
		XSSFFont fGuide   = font(9,  false, false, C_TXT_MUTE);
		XSSFFont fGroup   = font(10, true,  false, C_TXT_HEAD);
		XSSFFont fSub     = font(9,  true,  false, C_TXT);
		XSSFFont fData    = font(9,  false, false, C_TXT);
		XSSFFont fFixed   = font(9,  false, false, C_TXT_MUTE);
		XSSFFont fMarkOn  = font(9,  true,  false, C_TXT_ON);
		XSSFFont fMarkOff = font(9,  false, true,  C_TXT_MUTE);

		for (int edge = 0; edge < 2; edge++) {
			boolean e = (edge == 1);

			stGuide[edge] = style(fGuide, C_GUIDE_BG, e, true, CellStyle.ALIGN_LEFT, CellStyle.VERTICAL_TOP);

			stMark[ROLE_FIXED][edge] = style(fMarkOff, null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);
			stMark[ROLE_INPUT][edge] = style(fMarkOn,  null, e, false, CellStyle.ALIGN_CENTER, CellStyle.VERTICAL_CENTER);

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

	private static String[] toArray(List<String> list) {
		if (list == null) { return new String[0]; }
		List<String> keep = new ArrayList<String>();
		for (String s : list) {
			String v = CommonUtil.nvl(s).trim();
			if (v.length() > 0) { keep.add(v); }
		}
		return keep.toArray(new String[keep.size()]);
	}

	/* ── 열 정의 접근자 ── */

	public static int totalColCount() {
		return COLS.length;
	}

	/** 0-based 열 번호 → SaveName. 업로드 ColumnMapping 과 같은 순서를 보장하는 단일 출처다. */
	public static String saveNameAt(int col) {
		return COLS[col][0];
	}

	/** 1행 안내문. 사유·품목구분만 코드 목록으로 만들어 넣는다. */
	private String guideAt(int col) {
		if (col == COL_STATUS_REASON) { return reasonGuide; }
		if (col == COL_MAKE_AFTER)    { return makeGuide; }
		return COLS[col][4];
	}

	/** 열의 성격. ▼입력 시 반영 이 붙은 칸만 입력칸이고 나머지는 조회 전용이다. */
	private static int roleAt(int col) {
		return MARK_ON.equals(COLS[col][3]) ? ROLE_INPUT : ROLE_FIXED;
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
		if ("SPECIFICATION".equals(save))     { return 30; }
		if ("DESCRIPTION_LOC".equals(save))   { return 24; }
		if ("AGENT_NAME".equals(save))       { return 22; }
		if (save.endsWith("_REASON"))         { return 22; }
		if (save.startsWith("STATUS"))        { return 16; }
		if (save.startsWith("VALID"))         { return 15; }
		if (save.startsWith("ITEMNO"))        { return 18; }
		if (save.startsWith("MAKE"))          { return 18; }
		return 14;
	}
}
