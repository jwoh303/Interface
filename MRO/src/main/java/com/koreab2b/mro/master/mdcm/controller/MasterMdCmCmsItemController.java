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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCmsItemController")
public class MasterMdCmCmsItemController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsItemController.class);

	@Autowired
	private MasterMdCmCmsItemService masterMdCmCmsItemService;

	@RequestMapping(value = "/mdam/getMasterMdCmCmsItemList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCmsItemList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemService.getList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	@RequestMapping(value = "/mdam/getMasterMdCmCmsItemExcelList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCmCmsItemList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("엑셀다운로드 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemService.getList(pMap);

		IBSheetUtil.excelOut(req, res, _data);
	}

	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemDetailPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("상세 요청 파라미터 : {}", pMap);

		Map<String,String> _data = masterMdCmCmsItemService.getDetail(pMap);

		// 규격 상세 속성(상세분류가 정의한 속성명 + 그 상품의 속성값 + 필수여부) - 같은 요청에서 함께 담는다
		List<Map<String,String>> _attrList = masterMdCmCmsItemService.getDetailAttrList(pMap);

		// 구매정보 리스트 (이 상품정보코드에 걸린 구매정보 전체) - 같은 요청에서 함께 담는다
		List<Map<String,String>> _buyInfoList = masterMdCmCmsItemService.getDetailBuyInfoList(pMap);

		pModel.addAttribute("data", _data);
		pModel.addAttribute("attrList", _attrList);
		pModel.addAttribute("buyInfoList", _buyInfoList);
		return "common/popup/mdcm/masterMdCmCmsItemDetailPop";
	}

	// MSDS 매핑(등록·변경) - MSDS 검색팝업이 돌려준 번호를 CMSCATLG 에 반영한다
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemMsdsMapping.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsItemMsdsMapping(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		return saveMsds(req, pMap, true);
	}

	// MSDS 매핑해제
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemMsdsClean.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsItemMsdsClean(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		return saveMsds(req, pMap, false);
	}

	// 매핑/해제 공통 처리.
	private Map<String, Object> saveMsds(HttpServletRequest req, MultiValueMap<String, String> pMap, boolean isMapping) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _userId = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserId());

		if (!CommonUtil.getCodeCheckReturn("CM10", _userId)) { //  MSDS 담당자(ICOMCOD1 CM10)
			mp.put("Code", 0);
			_response.put("Result", mp);
			_response.put("Message", "물질정보 권한자만 실행 가능합니다.");
			return _response;
		}

		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("st_user_id", _userId);

		String rtnMsg = isMapping ? masterMdCmCmsItemService.saveSelectedMsdsMapping(formData, gridData)
								  : masterMdCmCmsItemService.saveSelectedMsdsClean(formData, gridData);

		mp.put("Code", 1);
		_response.put("Result", mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	@RequestMapping(value = "/mdam/getMasterMdCmCmsItemHistoryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCmsItemHistoryList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("상품 변경이력 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemService.getHistoryList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/**
	 * 기준가 변경 팝업
	 * 인상은 즉시 반영, 인하는 결재 상신이라 신청만 만들고 채번된 PM_NO 를 돌려준다.
	 * 화면은 그 번호로 공통 결재 팝업(DOC_TYPE=BP)을 띄운다.
	 */
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemBasePriceChangePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMdCmCmsItemBasePriceChangePop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("기준가 변경 팝업 요청 파라미터 : {}", pMap);
		req.setAttribute("data", masterMdCmCmsItemService.getBasePriceInfo(pMap));
		return "common/popup/mdcm/masterMdCmCmsItemBasePriceChangePop";
	}

	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemBasePrice.do",  method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsItemBasePrice(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("기준가 변경 저장 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id",   _sessionInfo.getUserId());
		pMap.put("st_user_dept", _sessionInfo.getDepartment());
		pMap.put("st_com_code",  _sessionInfo.getComCode());

		String pm_no = masterMdCmCmsItemService.saveBasePrice(pMap);

		mp.put("Code", 1);
		_response.put("Result", mp);
		// 인하는 채번된 PM_NO(=결재 BIZ_DOCU_NO), 인상은 공백
		_response.put("Message", pm_no);
		return _response;
	}

	/**
	 * 기준가 일괄수정 결과 팝업 [확인].
	 * 정상 건만 넘어오며, 인상·유형 단독 변경은 즉시 반영하고 인하는 한 건의 신청으로 묶는다.
	 * 인하가 있으면 채번된 PM_NO 를 돌려주고 화면이 결재 팝업(DOC_TYPE=BPM)을 띄운다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemBasePriceBulk.do",  method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCmsItemBasePriceBulk(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("기준가 일괄 반영 요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);

		Map<String, String> formData = new HashMap<String, String>();
		formData.put("st_user_id",   _sessionInfo.getUserId());
		formData.put("st_user_dept", _sessionInfo.getDepartment());
		formData.put("st_com_code",  _sessionInfo.getComCode());

		String pm_no = masterMdCmCmsItemService.saveBasePriceBulk(formData, gridData);

		mp.put("Code", 1);
		_response.put("Result", mp);
		// 인하가 섞여 있으면 채번된 PM_NO(=결재 BIZ_DOCU_NO), 전부 인상이면 공백
		_response.put("Message", pm_no);
		return _response;
	}

	@RequestMapping(value = "/mdam/getMasterMdCmCmsItemBasePriceHistoryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCmsItemBasePriceHistoryList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("기준가 변경이력 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemService.getBasePriceHistoryList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
