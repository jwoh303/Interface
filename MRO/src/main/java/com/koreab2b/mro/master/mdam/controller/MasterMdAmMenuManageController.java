package com.koreab2b.mro.master.mdam.controller;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdam.service.MasterMdAmMenuManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmMenuManageController")
public class MasterMdAmMenuManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmMenuManageController.class);

	@Autowired
	private MasterMdAmMenuManageService masterMdAmMenuManageService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmMenuManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmMenuManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmMenuManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmMenuManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmMenuManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
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
		String rtnMsg = masterMdAmMenuManageService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	
	// 조회(상세)
	@RequestMapping(value = "/mdam/getMasterMdAmMenuManageDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmMenuManageDetailList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmMenuManageService.getDetailList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 저장(상세)
	@RequestMapping(value = "/mdam/saveMasterMdAmMenuManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmMenuManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
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
		String rtnMsg = masterMdAmMenuManageService.updateSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제(상세)
	@RequestMapping(value = "/mdam/delMasterMdAmMenuManageDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmMenuManageDetail(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
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
		logger.debug("delMasterMdAmMenuManageDetail MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdAmMenuManageService.delSelectedDetailData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}	
}
