package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsBuyInfoMapFormExcel;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsBuyInfoMapMoveService;
import com.koreab2b.mro.util.CommonUtil;

/**
 * 표준DB 구매정보 > 고객사 매핑 이관 (s32~s36)
 *
 * 화면 라우트는 PopUpViewController 에 있다(순수 뷰라서).
 * 여기는 데이터 조회와 이관 실행만 맡는다.
 */
@Controller("masterMdCmCmsBuyInfoMapMoveController")
public class MasterMdCmCmsBuyInfoMapMoveController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsBuyInfoMapMoveController.class);

	@Autowired
	private MasterMdCmCmsBuyInfoMapMoveService masterMdCmCmsBuyInfoMapMoveService;

	// 표준DB 단건 정보 (기존/변경 패널이 같은 요청을 쓴다)
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsBuyInfoMapStdInfo.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsBuyInfoMapStdInfo(@RequestParam Map<String, Object> pMap) {
		logger.debug("매핑이관 표준DB 정보 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		_response.put("data", masterMdCmCmsBuyInfoMapMoveService.getStdInfo(pMap));
		return _response;
	}

	// 이관 대상 고객사 매핑정보 목록
	@RequestMapping(value = "/mdam/getMasterMdCmCmsBuyInfoMapCustList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsBuyInfoMapCustList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("매핑이관 고객사 매핑정보 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsBuyInfoMapMoveService.getCustList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 변경 표준DB 조회 (s34)
	@RequestMapping(value = "/mdam/getMasterMdCmCmsBuyInfoMapStdSelList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsBuyInfoMapStdSelList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("매핑이관 표준DB 조회 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterMdCmCmsBuyInfoMapMoveService.getStdSelList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/**
	 * [매핑이관] 실행. 체크한 고객사 계약행만 넘어온다.
	 * 고객사지정여부 Y + 협력사 불일치가 한 건이라도 있으면 전부 되돌리고 사유를 돌려준다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsBuyInfoMapMove.do",  method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsBuyInfoMapMove(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("매핑이관 실행 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap, "s_SAVENAME");

		int moved = masterMdCmCmsBuyInfoMapMoveService.moveMapping(formData, gridData);

		mp.put("Code", 1);
		_response.put("Result", mp);
		_response.put("Message", String.valueOf(moved));
		return _response;
	}

	/** 양식 1회 다운로드 상한. 등록·수정 양식과 같은 값이다. */
	private static final int FORM_MAX_ROWS = 1000;

	/*
	 * 고객사 매핑변경 양식 다운로드(10열).
	 * 체크한 구매정보에 매달린 고객사 매핑을 전개해 내리고, 마지막 2열을 비워 둔다.
	 * 응답이 파일이라 화면은 일반 form submit 으로 부른다(AJAX 아니).
	 */
	@RequestMapping(value = "/mdcm/downMasterMdCmCmsBuyInfoMapForm.do", method = {RequestMethod.GET, RequestMethod.POST})
	public void downMasterMdCmCmsBuyInfoMapForm(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String,Object> pMap) {
		List<String> codes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("codes")), "@");
		String downToken   = CommonUtil.nvl((String) pMap.get("downToken"));	// 화면 로딩바를 내릴 완료 신호

		logger.debug("구매정보 매핑변경 양식 다운로드 요청 : {} 건", codes.size());

		if (codes.size() == 0) {
			writeIframeAlert(res, "양식을 받을 구매정보를 선택하세요.", downToken);
			return;
		}
		if (codes.size() > FORM_MAX_ROWS) {
			writeIframeAlert(res, "양식은 한 번에 " + FORM_MAX_ROWS + "건까지 받을 수 있습니다.", downToken);
			return;
		}

		List<Map<String,String>> rows = masterMdCmCmsBuyInfoMapMoveService.getMapFormList(codes);

		/* 양식의 한 행 = 매핑된 고객사 계약 1건(ICOMCQDT)이다.
		   매핑이 하나도 없으면 받아도 빈 양식이라 내려보내지 않고 알린다. */
		if (rows.size() == 0) {
			writeIframeAlert(res, "선택한 구매정보에 매핑된 고객사가 없습니다.", downToken);
			return;
		}

		XSSFWorkbook wb = MasterMdCmCmsBuyInfoMapFormExcel.build(rows);
		IBSheetUtil.drmExcelOut(req, res, wb, "업로드양식(고객사 매핑변경).xlsx", downToken);
	}

	// 매핑변경 결과 확인 (팝업). 목록이 파싱해 둔 행을 opener 로 읽어 가므로 넘길 모델이 없다.
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoMapPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoMapPop(ModelMap pModel, @RequestParam Map<String,Object> pMap) {
		return "common/popup/mdcm/masterMdCmCmsBuyInfoMapPop";
	}

	/*
	 * 매핑변경 결과 - 검증에 필요한 것을 한 번에 돌려준다.
	 *   fromCodes : 업로드한 기존 구매정보코드 '@' 연결 → from (현재 매핑. 실재 판정도 겸한다)
	 *   toCodes   : 입력된 변경 구매정보코드 '@' 연결 → to   (실재하는 것만 + 협력사)
	 * ⚠ 조회 전용이다. 여기서 반영(UPDATE)은 하지 않는다.
	 */
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsBuyInfoMapCheckList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsBuyInfoMapCheckList(@RequestParam Map<String,Object> pMap) {
		List<String> fromCodes = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("fromCodes")), "@");
		List<String> toCodes   = CommonUtil.getStringArrary(CommonUtil.nvl((String) pMap.get("toCodes")),   "@");

		logger.debug("매핑변경 검증자료 요청 : 기존 {} 건 / 변경 {} 건", fromCodes.size(), toCodes.size());

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("from", masterMdCmCmsBuyInfoMapMoveService.getMapFormList(fromCodes));
		result.put("to",   masterMdCmCmsBuyInfoMapMoveService.getMapTargetList(toCodes));
		return result;
	}

	/**
	 * 매핑변경 결과 팝업 [확인]. 화면이 걸러 낸 정상 건만 넘어온다.
	 * 행마다 기존·변경 구매정보코드가 달라 이관도 행 단위로 돌린다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsBuyInfoMapBulk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsBuyInfoMapBulk(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("매핑변경 일괄 반영 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);

		int moved = 0;
		for (int i = 0; gridData != null && i < gridData.size(); i++) {
			List<Object> one = new java.util.ArrayList<Object>();
			one.add(gridData.get(i));
			moved += masterMdCmCmsBuyInfoMapMoveService.moveMapping(new HashMap<String, String>(), one);
		}

		mp.put("Code", 1);
		_response.put("Result", mp);
		_response.put("Message", String.valueOf(moved));
		return _response;
	}

	/*
	 * 파일 응답 자리에 안내를 띄운다. 다운로드는 숨은 iframe 을 대상으로 submit 되므로
	 * 그냥 예외를 던지면 사용자에게 아무것도 보이지 않는다.
	 */
	private void writeIframeAlert(HttpServletResponse res, String message, String downToken) {
		try {
			res.reset();
			IBSheetUtil.setDownTokenCookie(res, downToken);
			res.setContentType("text/html; charset=utf-8");
			String safe = message.replace("\\", "\\\\").replace("'", "\\'");
			res.getWriter().print("<script>alert('" + safe + "');</script>");
			res.getWriter().flush();
		} catch (Exception e) {
			logger.error("양식 다운로드 안내 출력 실패", e);
		}
	}
}
