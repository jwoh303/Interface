package com.koreab2b.mro.master.mdam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.master.mdam.service.MasterMdAmCommonManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmCommonManageController")
public class MasterMdAmCommonManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmCommonManageController.class);

	@Autowired
	private MasterMdAmCommonManageService masterMdAmCommonManageService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmCommonManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmCommonManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmCommonManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmCommonManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmCommonManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmCommonManageService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mdam/delMasterMdAmCommonManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmCommonManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdAmCommonManage MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmCommonManageService.delSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}

	
	// 조회(상세)
	@RequestMapping(value = "/mdam/getMasterMdAmCommonManageDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmCommonManageDetailList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmCommonManageService.getDetailList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장(상세)
	@RequestMapping(value = "/mdam/saveMasterMdAmCommonManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmCommonManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmCommonManageService.updateSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제(상세)
	@RequestMapping(value = "/mdam/delMasterMdAmCommonManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmCommonManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdAmCommonManageDetail MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmCommonManageService.delSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
}
