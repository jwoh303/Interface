package com.koreab2b.mro.master.mpiv.controller;

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
import com.koreab2b.mro.master.mpiv.service.MasterMpIvScmManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIvScmManageController")
public class MasterMpIvScmManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvScmManageController.class);

	@Autowired
	private MasterMpIvScmManageService masterMpIvScmManageService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getMasterMpIvScmManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIvScmManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpIvScmManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpiv/excelMasterMpIvScmManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpIvScmManageService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mpiv/saveMasterMpIvScmManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpIvScmManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMpIvScmManageService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mpiv/delMasterMpIvScmManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpIvScmManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMpIvScmManage MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMpIvScmManageService.delSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
