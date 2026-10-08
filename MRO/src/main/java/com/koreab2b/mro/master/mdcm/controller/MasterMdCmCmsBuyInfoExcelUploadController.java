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
import org.springframework.util.MultiValueMap;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsBuyInfoExcelUploadService;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsBuyInfoModFormExcel;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsBuyInfoRegFormExcel;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCmsBuyInfoExcelUploadController")
public class MasterMdCmCmsBuyInfoExcelUploadController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsBuyInfoExcelUploadController.class);

	@Autowired
	private MasterMdCmCmsBuyInfoExcelUploadService masterMdCmCmsBuyInfoExcelUploadService;

	/*
	 * 구매정보 일괄등록 양식 다운로드 — 전 열이 입력칸인 빈 양식.
	 * 목록에서 체크한 행이 있으면 그 상품정보코드만 A열에 채워 내린다(같은 상품에 구매정보를 더 다는 용도).
	 * IBSheet Down2Excel 으로는 병합 헤더·드롭다운을 만들 수 없어 서버가 POI 로 직접 만든다.
	 * 응답이 파일이라 화면은 일반 form submit 으로 부른다(AJAX 아님).
	 */
	@RequestMapping(value = "/mdcm/downMasterMdCmCmsBuyInfoRegForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public void downMasterMdCmCmsBuyInfoRegForm(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String,Object> pMap) {
		List<String> codes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		String downToken   = CommonUtil.nvl((String) pMap.get("downToken"));	// 화면 로딩바를 내릴 완료 신호

		logger.debug("구매정보 등록 양식 다운로드 요청 : {} 건", codes.size());

		if (codes.size() > REG_FORM_MAX_ROWS) {
			writeIframeAlert(res, "양식은 한 번에 " + REG_FORM_MAX_ROWS + "건까지 받을 수 있습니다.", downToken);
			return;
		}

		List<String> makeTypes  = masterMdCmCmsBuyInfoExcelUploadService.getItemMakeTypeCodes();
		List<String> warehouses = masterMdCmCmsBuyInfoExcelUploadService.getWarehouseNames();

		XSSFWorkbook wb = MasterMdCmCmsBuyInfoRegFormExcel.build(codes, makeTypes, warehouses);
		IBSheetUtil.drmExcelOut(req, res, wb, "업로드양식(구매정보등록).xlsx", downToken);
	}

	// 구매정보 일괄등록 결과 확인 (팝업). 목록이 파싱해 둔 행을 opener 로 읽어 가므로 넘길 모델이 없다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoRegPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoRegPop(ModelMap pModel, @RequestParam Map<String,Object> pMap) {
		return "common/popup/mdcm/masterMdCmCmsBuyInfoRegPop";
	}

	/*
	 * 구매정보 일괄등록 결과 - 검증에 필요한 것을 한 번에 돌려준다.
	 * 업로드 직후 1회만 호출한다(행마다 부르지 않는다).
	 *   codes  : 업로드한 상품정보코드 '@' 연결 → data   (실재하는 상품의 품목명·모델번호·규격·제조사·단위)
	 *                                          → dups   (그 상품에 이미 달린 구매정보의 중복 판정 키)
	 *   agents : 입력된 협력사코드 '@' 연결     → agents (실재하는 협력사의 코드·명)
	 *                                          → makeTypes (품목구분 코드 목록 - 값 검증용)
	 * ⚠ 조회 전용이다. 여기서 등록(INSERT)은 하지 않는다.
	 */
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsBuyInfoRegCheckList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsBuyInfoRegCheckList(@RequestParam Map<String,Object> pMap) {
		List<String> codes  = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		List<String> agents = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("agents")), "@");

		logger.debug("구매정보 등록 검증자료 요청 : 상품 {} 건 / 협력사 {} 건", codes.size(), agents.size());

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("data",      masterMdCmCmsBuyInfoExcelUploadService.getItemList(codes));
		result.put("dups",      masterMdCmCmsBuyInfoExcelUploadService.getExistingKeyList(codes));
		result.put("agents",    masterMdCmCmsBuyInfoExcelUploadService.getAgentList(agents));
		result.put("makeTypes",  masterMdCmCmsBuyInfoExcelUploadService.getItemMakeTypeCodes());
		result.put("warehouses", masterMdCmCmsBuyInfoExcelUploadService.getWarehouseList());
		return result;
	}

	/*
	 * 구매정보 일괄수정 양식 다운로드 — 목록에서 체크한 구매정보의 현재값이 채워진 38열 양식.
	 * IBSheet Down2Excel 으로는 병합 4행 헤더·드롭다운을 만들 수 없어 서버가 POI 로 직접 만든다.
	 * 응답이 파일이라 화면은 일반 form submit 으로 부른다(AJAX 아님).
	 */
	@RequestMapping(value = "/mdcm/downMasterMdCmCmsBuyInfoModForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public void downMasterMdCmCmsBuyInfoModForm(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String,Object> pMap) {
		List<String> codes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		String downToken   = CommonUtil.nvl((String) pMap.get("downToken"));

		logger.debug("구매정보 수정 양식 다운로드 요청 : {} 건", codes.size());

		if (codes.size() == 0) {
			writeIframeAlert(res, "양식을 받을 구매정보를 선택하세요.", downToken);
			return;
		}
		if (codes.size() > REG_FORM_MAX_ROWS) {
			writeIframeAlert(res, "양식은 한 번에 " + REG_FORM_MAX_ROWS + "건까지 받을 수 있습니다.", downToken);
			return;
		}

		List<Map<String,String>> rows = masterMdCmCmsBuyInfoExcelUploadService.getModFormRows(codes);
		List<Map<String,String>> reasons = masterMdCmCmsBuyInfoExcelUploadService.getSupplyReasonList();
		List<String> makeTypes = masterMdCmCmsBuyInfoExcelUploadService.getItemMakeTypeNames();

		XSSFWorkbook wb = MasterMdCmCmsBuyInfoModFormExcel.build(rows, reasons, makeTypes);
		IBSheetUtil.drmExcelOut(req, res, wb, "업로드양식(구매정보 일괄수정).xlsx", downToken);
	}

	// 구매정보 일괄수정 결과 확인 (팝업). 목록이 파싱해 둔 행을 opener 로 읽어 가므로 넘길 모델이 없다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoModPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoModPop(ModelMap pModel, @RequestParam Map<String,Object> pMap) {
		return "common/popup/mdcm/masterMdCmCmsBuyInfoModPop";
	}

	/*
	 * 구매정보 일괄수정 결과 - 검증에 필요한 것을 한 번에 돌려준다.
	 * 업로드 직후 1회만 호출한다(행마다 부르지 않는다).
	 *   codes    : 업로드한 구매정보코드 '@' 연결 → data    (현재값. 실재 판정도 겸한다)
	 *   altCodes : 입력된 대체코드 '@' 연결        → alt     (실재하는 상품정보코드만)
	 *                                             → reasons (공급상태 변경사유 + 대체코드 필수 여부)
	 *                                             → makeTypes / taxTypes (값 검증용 명칭 목록)
	 * ⚠ 조회 전용이다. 여기서 반영(UPDATE)은 하지 않는다.
	 */
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsBuyInfoModBeforeList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsBuyInfoModBeforeList(@RequestParam Map<String,Object> pMap) {
		List<String> codes    = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		List<String> altCodes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("altCodes")), "@");

		logger.debug("구매정보 일괄수정 [기존]값 요청 : 코드 {} 건 / 대체코드 {} 건", codes.size(), altCodes.size());

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("data",      masterMdCmCmsBuyInfoExcelUploadService.getModBeforeList(codes));
		result.put("alt",       masterMdCmCmsBuyInfoExcelUploadService.getExistingCatlgCodes(altCodes));
		result.put("reasons",   masterMdCmCmsBuyInfoExcelUploadService.getSupplyReasonList());
		result.put("makeTypes", masterMdCmCmsBuyInfoExcelUploadService.getItemMakeTypeNames());
		result.put("taxTypes",  masterMdCmCmsBuyInfoExcelUploadService.getTaxTypeList());
		return result;
	}

	/**
	 * 구매정보 일괄수정 결과 팝업 [확인]. 화면이 걸러 낸 정상 건만 넘어온다.
	 * 반영 건수를 Message 로 돌려준다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsBuyInfoModBulk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsBuyInfoModBulk(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("구매정보 일괄수정 반영 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);

		int saved = masterMdCmCmsBuyInfoExcelUploadService.saveModBulk(_sessionInfo.getUserId(), gridData);

		mp.put("Code", 1);
		_response.put("Result", mp);
		_response.put("Message", String.valueOf(saved));
		return _response;
	}

	/**
	 * 구매정보 일괄등록 결과 팝업 [확인]. 화면이 걸러 낸 정상 건만 넘어온다.
	 * 등록 건수를 Message 로 돌려준다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsBuyInfoRegBulk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsBuyInfoRegBulk(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("구매정보 일괄등록 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);

		int saved = masterMdCmCmsBuyInfoExcelUploadService.saveRegBulk(_sessionInfo.getUserId(), gridData);

		mp.put("Code", 1);
		_response.put("Result", mp);
		_response.put("Message", String.valueOf(saved));
		return _response;
	}

	/*
	 * 양식 다운로드 상한. 화면(masterMdCmCmsBuyInfoList.jsp REG_FORM_MAX_ROWS)과 같은 값이어야 한다.
	 * POI(XSSF)가 워크북을 메모리에 통째로 만들기 때문에 걸어 둔 한계다.
	 */
	private static final int REG_FORM_MAX_ROWS = 1000;

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
