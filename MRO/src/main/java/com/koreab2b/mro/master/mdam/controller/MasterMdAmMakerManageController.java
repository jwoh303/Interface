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
import com.koreab2b.mro.master.mdam.service.MasterMdAmMakerManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmMakerManageController")
public class MasterMdAmMakerManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmMakerManageController.class);

	@Autowired
	private MasterMdAmMakerManageService masterMdAmMakerManageService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmMakerManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmMakerManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmMakerManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdam/excelMasterMdAmMakerManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdAmMakerManageService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmMakerManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmMakerManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmMakerManageService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mdam/delMasterMdAmMakerManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmMakerManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdAmMakerManage MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmMakerManageService.delSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
