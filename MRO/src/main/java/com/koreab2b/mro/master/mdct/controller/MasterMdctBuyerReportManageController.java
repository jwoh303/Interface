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
import com.koreab2b.mro.master.mdct.service.MasterMdctBuyerReportManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdctBuyerReportManageController")
public class MasterMdctBuyerReportManageController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdctBuyerReportManageController.class);
	
	@Autowired
	private MasterMdctBuyerReportManageService masterMdctBuyerReportManageService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdctBuyerReportManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdctBuyerReportManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdctBuyerReportManageList 요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdctBuyerReportManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 개별처리
	@RequestMapping(value = "/mdct/saveMasterMdctBuyerReportManageOneProc.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdctBuyerReportManageOneProc(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdctBuyerReportManageOneProc 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdctBuyerReportManageOneProc 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdctBuyerReportManageService.updateSelectedProc(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 재생성
	@RequestMapping(value = "/mdct/saveMasterMdctBuyerReportManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdctBuyerReportManageList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdctBuyerReportManageList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdctBuyerReportManageList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdctBuyerReportManageService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 품의상신
	@RequestMapping(value = "/mdct/approvalMasterMdctBuyerReportManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> approvalMasterMdctBuyerReportManageList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("deletetMasterMdctBuyerReportManageList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("deletetMasterMdctBuyerReportManageList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdctBuyerReportManageService.approvalMasterMdctBuyerReportManageList(formData, gridData);
		_response.put("msg", rtnMsg);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
				
		return _response;
	}

}
