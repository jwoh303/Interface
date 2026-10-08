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
import com.koreab2b.mro.master.mdam.service.MasterMdAmRoleManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmRoleManageController")
public class MasterMdAmRoleManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmRoleManageController.class);

	@Autowired
	private MasterMdAmRoleManageService masterMdAmRoleManageService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmRoleManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmRoleManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmRoleManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 조회(상세)
	@RequestMapping(value = "/mdam/getMasterMdAmRoleManageDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmRoleManageDetailList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmRoleManageService.getDetailList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장(상세)
	@RequestMapping(value = "/mdam/saveMasterMdAmRoleManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmRoleManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmRoleManageService.updateSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제(상세)
	@RequestMapping(value = "/mdam/delMasterMdAmRoleManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmRoleManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdAmRoleManageDetail MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmRoleManageService.delSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}	

}
