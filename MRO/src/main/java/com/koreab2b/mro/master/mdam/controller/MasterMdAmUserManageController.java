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

import com.googlecode.ehcache.annotations.TriggersRemove;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdam.service.MasterMdAmUserManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmUserManageController")
public class MasterMdAmUserManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmUserManageController.class);

	@Autowired
	private MasterMdAmUserManageService masterMdAmUserManageService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmUserManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmUserManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmUserManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 조회(상세)
	@RequestMapping(value = "/mdam/getMasterMdAmUserManageDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmUserManageDetailList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmUserManageService.getDetailList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장(상세)
	@RequestMapping(value = "/mdam/saveMasterMdAmUserManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmUserManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		formData.put("REG_ID", _sessionInfo.getUserId());
		formData.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmUserManageService.updateSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제(상세)
	@RequestMapping(value = "/mdam/delMasterMdAmUserManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmUserManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		formData.put("REG_ID", _sessionInfo.getUserId());
		formData.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdAmUserManageDetail MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmUserManageService.delSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}	

}
