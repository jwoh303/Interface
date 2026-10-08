package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsBuyInfoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCmsBuyInfoController")
public class MasterMdCmCmsBuyInfoController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsBuyInfoController.class);

	@Autowired
	private MasterMdCmCmsBuyInfoService masterMdCmCmsBuyInfoService;

	// 구매정보 조회 및 관리 - 목록 조회
	@RequestMapping(value = "/mdam/getMasterMdCmCmsBuyInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCmsBuyInfoList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("구매정보 목록 요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterMdCmCmsBuyInfoService.getList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 구매정보 조회 및 관리 - 조회결과 엑셀다운로드 (pageflag=0 으로 페이징이 풀린 전건)
	@RequestMapping(value = "/mdam/getMasterMdCmCmsBuyInfoExcelList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCmCmsBuyInfoList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("구매정보 엑셀다운로드 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterMdCmCmsBuyInfoService.getList(pMap);

		IBSheetUtil.excelOut(req, res, _data);
	}

	// 구매정보 상세 조회 및 수정 (팝업) - TCODE 단건 조회 후 모델에 담아 렌더
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsBuyInfoDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsBuyInfoDetailPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("구매정보 상세 요청 파라미터 : {}", pMap);

		Map<String,String> _data = masterMdCmCmsBuyInfoService.getDetail(pMap);

		pModel.addAttribute("data", _data);
		pModel.addAttribute("attrList", masterMdCmCmsBuyInfoService.getDetailAttrList(pMap));
		pModel.addAttribute("mapList",  masterMdCmCmsBuyInfoService.getDetailMapList(pMap));
		return "common/popup/mdcm/masterMdCmCmsBuyInfoDetailPop";
	}

	// 구매정보 변경이력 - 목록 조회
	@RequestMapping(value = "/mdam/getMasterMdCmCmsBuyInfoHistoryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCmsBuyInfoHistoryList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("구매정보 변경이력 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsBuyInfoService.getHistoryList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/**
	 * 구매정보코드 상태변경 [변경] / 결재요청 [품의상신].
	 * 매입단가 인상이 섞여 있으면(DB 현재값 기준) 그 항목만 뺀 채 반영하고
	 * 신청(KEPMGPHD/KEPMGPDT)을 만들어 채번된 PM_NO 를 돌려준다 — 화면이 그 번호로 결재 팝업(DOC_TYPE=SP)을 띄운다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsBuyInfoChange.do",  method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsBuyInfoChange(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("구매정보 변경 반영 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);

		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap, "s_SAVENAME");
		formData.put("st_user_id",   _sessionInfo.getUserId());
		formData.put("st_user_dept", _sessionInfo.getDepartment());
		formData.put("st_com_code",  _sessionInfo.getComCode());

		String pm_no = masterMdCmCmsBuyInfoService.saveChange(formData, gridData);

		mp.put("Code", 1);
		_response.put("Result", mp);
		// 인상이 있으면 채번된 PM_NO(=결재 BIZ_DOCU_NO), 없으면 공백
		_response.put("Message", pm_no);
		return _response;
	}

	/**
	 * 구매정보 일괄수정 인상분 품의 상신(SPM).
	 * 일괄 결재요청 화면이 인상 행만 모아 보내며, 채번된 PM_NO 를 돌려준다.
	 */
	@RequestMapping(value = "/mdcm/requestMasterMdCmCmsBuyInfoPriceUpBulk.do",  method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> requestMasterMdCmCmsBuyInfoPriceUpBulk(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("매입단가 인상 일괄 상신 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);

		Map<String, String> formData = new HashMap<String, String>();
		formData.put("st_user_id",   _sessionInfo.getUserId());
		formData.put("st_user_dept", _sessionInfo.getDepartment());
		formData.put("st_com_code",  _sessionInfo.getComCode());
		formData.put("st_gubun",     "SPM");

		String pm_no = masterMdCmCmsBuyInfoService.requestBuyPriceUpBulk(formData, gridData);

		mp.put("Code", 1);
		_response.put("Result", mp);
		_response.put("Message", pm_no);
		return _response;
	}
}
