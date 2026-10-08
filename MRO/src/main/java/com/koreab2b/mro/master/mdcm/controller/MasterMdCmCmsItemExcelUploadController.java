package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsBasePriceFormExcel;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemExcelUploadService;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemModFormExcel;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCmsItemExcelUploadController")
public class MasterMdCmCmsItemExcelUploadController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsItemExcelUploadController.class);

	@Autowired
	private MasterMdCmCmsItemExcelUploadService masterMdCmCmsItemExcelUploadService;

	// 상품정보 엑셀 업로드 (팝업) - 담당 상세분류 최대 속성 개수(maxAttr) 계산 후 동적 속성 컬럼 생성용으로 전달
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemExcelUploadPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsItemExcelUploadPop(ModelMap pModel, @RequestParam Map<String,Object> pMap) {
		List<Map<String,String>> formList = masterMdCmCmsItemExcelUploadService.getFormList(pMap);
		int maxAttr = masterMdCmCmsItemExcelUploadService.getMaxAttrCount(formList);
		pModel.addAttribute("maxAttr", maxAttr);
		return "common/popup/mdcm/masterMdCmCmsItemExcelUploadPop";
	}

	// 상품정보 엑셀 업로드 (팝업) - 담당 상세분류별 속성 목록 (IBSheet AJAX, 로드 시 그리드 적재)
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemExcelUploadFormList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemExcelUploadFormList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String,Object> pMap) {
		logger.debug("엑셀업로드 양식 목록 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemExcelUploadService.getFormList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data, pMap);
	}

	/*
	 * 일괄수정 결과 확인 - 업로드한 행의 [기존] 값과 대체코드 실재 여부를 한 번에 돌려준다.
	 * 업로드 직후 1회만 호출한다(행마다 부르지 않는다).
	 *   codes       : 업로드한 상품정보코드 '@' 연결 → data   (CMS_CATLG_ID + *_BEFORE + 속성명/기존 속성값)
	 *   altCodes    : 입력된 대체코드 '@' 연결      → alt    (그 중 실재하는 코드만)
	 *   makerCodes  : 입력된 제조사 변경코드 '@' 연결 → maker  (실재하는 코드만, ICOMCOD1 M104)
	 *   originCodes : 입력된 원산지 변경코드 '@' 연결 → origin (실재하는 코드만, ICOMCOD1 M001)
	 * ⚠ 조회 전용이다. 여기서 반영(INSERT/UPDATE)은 하지 않는다.
	 */
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemExcelUploadBeforeList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemExcelUploadBeforeList(@RequestParam Map<String,Object> pMap) {
		List<String> codes       = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		List<String> altCodes    = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("altCodes")), "@");
		List<String> makerCodes  = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("makerCodes")), "@");
		List<String> originCodes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("originCodes")), "@");

		logger.debug("일괄수정 [기존]값 요청 : 코드 {} 건 / 대체코드 {} 건 / 제조사 {} 건 / 원산지 {} 건",
				new Object[]{codes.size(), altCodes.size(), makerCodes.size(), originCodes.size()});

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("data",   masterMdCmCmsItemExcelUploadService.getBeforeList(codes));
		result.put("alt",    masterMdCmCmsItemExcelUploadService.getExistingCodes(altCodes));
		result.put("maker",  masterMdCmCmsItemExcelUploadService.getExistingMakerCodes(makerCodes));
		result.put("makerName", masterMdCmCmsItemExcelUploadService.getMakerNames(makerCodes));
		result.put("origin", masterMdCmCmsItemExcelUploadService.getExistingOriginCodes(originCodes));
		return result;
	}

	/*
	 * 일괄수정 양식 다운로드  — 목록에서 체크한 상품의 현재값이 채워진 58열 양식.
	 * IBSheet Down2Excel 으로는 병합 4행 헤더·종속 드롭다운을 만들 수 없어 서버가 POI 로 직접 만든다.
	 * 응답이 파일이라 화면은 일반 form submit 으로 부른다(AJAX 아님).
	 */
	@RequestMapping(value = "/mdcm/downMasterMdCmCmsItemModForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public void downMasterMdCmCmsItemModForm(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String,Object> pMap) {
		List<String> codes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		String downToken   = CommonUtil.nvl((String) pMap.get("downToken"));	// 화면 로딩바를 내릴 완료 신호

		logger.debug("일괄수정 양식 다운로드 요청 : {} 건", codes.size());

		if (codes.size() == 0) {
			writeIframeAlert(res, "양식을 받을 상품을 선택하세요.", downToken);
			return;
		}
		if (codes.size() > MOD_FORM_MAX_ROWS) {
			writeIframeAlert(res, "양식은 한 번에 " + MOD_FORM_MAX_ROWS + "건까지 받을 수 있습니다.", downToken);
			return;
		}

		List<Map<String,String>> rows    = masterMdCmCmsItemExcelUploadService.getModFormRows(codes);
		List<List<String>>       reasons = masterMdCmCmsItemExcelUploadService.getStatusReasonLists();

		XSSFWorkbook wb = MasterMdCmCmsItemModFormExcel.build(rows, reasons.get(0), reasons.get(1),
				masterMdCmCmsItemExcelUploadService.getTrHandleNames());
		IBSheetUtil.drmExcelOut(req, res, wb, "업로드양식(상품정보 일괄수정).xlsx", downToken);
	}

	/*
	 * 기준가 일괄수정 양식 다운로드  — 목록에서 체크한 상품의 현재 기준가가 채워진 13열 양식.
	 * ★ 기준가는 상품정보코드 단위다(사용자 결정 2026-09-01) — 양식의 구매정보코드 열은 참고 열이라 비워 내려간다.
	 * 일괄수정 양식과 같은 이유로 POI 로 직접 만든다(병합 4행 헤더·드롭다운) + DRM(Madn).
	 */
	@RequestMapping(value = "/mdcm/downMasterMdCmCmsBasePriceForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public void downMasterMdCmCmsBasePriceForm(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String,Object> pMap) {
		List<String> codes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		String downToken   = CommonUtil.nvl((String) pMap.get("downToken"));	// 화면 로딩바를 내릴 완료 신호

		logger.debug("기준가 양식 다운로드 요청 : {} 건", codes.size());

		if (codes.size() == 0) {
			writeIframeAlert(res, "양식을 받을 상품을 선택하세요.", downToken);
			return;
		}
		if (codes.size() > MOD_FORM_MAX_ROWS) {
			writeIframeAlert(res, "양식은 한 번에 " + MOD_FORM_MAX_ROWS + "건까지 받을 수 있습니다.", downToken);
			return;
		}

		List<Map<String,String>> rows  = masterMdCmCmsItemExcelUploadService.getBasePriceFormRows(codes);
		List<String>             types = masterMdCmCmsItemExcelUploadService.getBasePriceTypeNames();

		XSSFWorkbook wb = MasterMdCmCmsBasePriceFormExcel.build(rows, types);
		IBSheetUtil.drmExcelOut(req, res, wb, "업로드양식(기준가 일괄수정).xlsx", downToken);
	}

	// 기준가 일괄수정 결과 확인 (팝업). 목록이 파싱해 둔 행을 opener 로 읽어 가므로 넘길 모델이 없다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBasePricePop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsBasePricePop(ModelMap pModel, @RequestParam Map<String,Object> pMap) {
		return "common/popup/mdcm/masterMdCmCmsBasePricePop";
	}

	/*
	 * 기준가 일괄수정 결과 - 업로드한 행의 [기존] 기준가와 기준가유형 목록을 한 번에 돌려준다.
	 * 업로드 직후 1회만 호출한다(행마다 부르지 않는다).
	 *   codes : 업로드한 상품정보코드 '@' 연결 → data  (CMS_CATLG_ID + 상품 기본정보 + PRICE_BEFORE/PRICE_TYPE_BEFORE)
	 *                                          → types (ICOMCOD1 M183 명칭 목록 — 기준가유형 값 검증용)
	 * ⚠ 조회 전용이다. 여기서 반영(INSERT/UPDATE)은 하지 않는다.
	 */
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsBasePriceBeforeList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsBasePriceBeforeList(@RequestParam Map<String,Object> pMap) {
		List<String> codes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");

		logger.debug("기준가 일괄수정 [기존]값 요청 : 코드 {} 건", codes.size());

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("data",  masterMdCmCmsItemExcelUploadService.getBasePriceBeforeList(codes));
		result.put("types", masterMdCmCmsItemExcelUploadService.getBasePriceTypeNames());
		return result;
	}

	/*
	 * 양식 다운로드 상한. 화면(masterMdCmCmsItemList.jsp MOD_FORM_MAX_ROWS)과 같은 값이어야 한다.
	 * POI(XSSF)가 워크북을 메모리에 통째로 만들기 때문에 걸어 둔 한계다 — 셀당 약 1KB.
	 */
	private static final int MOD_FORM_MAX_ROWS = 1000;

	/*
	 * 파일 응답 자리에 안내를 띄운다. 다운로드는 숨은 iframe 을 대상으로 submit 되므로
	 * 그냥 예외를 던지면 사용자에게 아무것도 보이지 않는다.
	 */
	private void writeIframeAlert(HttpServletResponse res, String message, String downToken) {
		try {
			res.reset();
			IBSheetUtil.setDownTokenCookie(res, downToken);		// 이 경로로 끝나도 로딩바는 내려야 한다
			res.setContentType("text/html; charset=utf-8");
			String safe = message.replace("\\", "\\\\").replace("'", "\\'");
			res.getWriter().print("<script>alert('" + safe + "');</script>");
			res.getWriter().flush();
		} catch (Exception e) {
			logger.error("양식 다운로드 안내 출력 실패", e);
		}
	}
}
