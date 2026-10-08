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
import com.koreab2b.mro.master.mdct.service.MasterMdCtBuyerGroupManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtBuyerGroupManageController")
public class MasterMdCtBuyerGroupManageController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdCtBuyerGroupManageController.class);
	
	@Autowired
	private MasterMdCtBuyerGroupManageService masterMdCtBuyerGroupManageService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerGroupManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtBuyerGroupManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtBuyerGroupManageList 요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCtBuyerGroupManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerGroupManageGroupCheck.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtBuyerGroupManageGroupCheck(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("getMasterMdCtBuyerGroupManageGroupCheck 요청 파라미터 : {}", pMap);
		
		String _rtnMsg = masterMdCtBuyerGroupManageService.getCorpCheck(pMap);
		
		_response.put("msg", _rtnMsg);
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtBuyerGroupManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCtBuyerGroupManageList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdCtBuyerGroupManageList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdCtBuyerGroupManageList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtBuyerGroupManageService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtBuyerGroupManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtBuyerGroupManageList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("deleteMasterMdCtBuyerGroupManageList 요청 파라미터 : formData {}", pMap);

		String rtnMsg = masterMdCtBuyerGroupManageService.deleteSelectedData(pMap);
		_response.put("msg", rtnMsg);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
				
		return _response;
	}
}
