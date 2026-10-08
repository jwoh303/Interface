package com.koreab2b.mro.master.mdct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdct.service.MasterMdCtBuyerChargeEntryService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtBuyerChargeEntryController")
public class MasterMdCtBuyerChargeEntryController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdCtBuyerChargeEntryController.class);
	
	@Autowired
	private MasterMdCtBuyerChargeEntryService masterMdCtBuyerChargeEntryService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerChargeEntryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtBuyerChargeEntryList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtBuyerChargeEntryList 요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCtBuyerChargeEntryService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 조회
	@RequestMapping(value = "/mdct/selectMasterMdCtBuyerChargeEntryUserIdCheck.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> selectMasterMdCtBuyerChargeEntryUserIdCheck(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData);
		
		String _rtnMsg = masterMdCtBuyerChargeEntryService.getKepUserIdCheck(formData, gridData);
		
		_response.put("msg", _rtnMsg);
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtBuyerChargeEntryList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCtBuyerChargeEntryList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtBuyerChargeEntryService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtBuyerChargeEntryList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtBuyerChargeEntryList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("deletetMasterMdCtBuyerChargeEntryList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("deletetMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtBuyerChargeEntryService.deleteSelectedData(formData, gridData);
		_response.put("msg", rtnMsg);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
				
		return _response;
	}
}
