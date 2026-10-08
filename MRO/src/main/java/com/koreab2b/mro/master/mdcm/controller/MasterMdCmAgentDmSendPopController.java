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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmAgentDmSendPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMdCmAgentDmSendPopController")
public class MasterMdCmAgentDmSendPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmAgentDmSendPopController.class);

	@Autowired
	private MasterMdCmAgentDmSendPopService masterMdCmAgentDmSendPopService;

	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdcmAgentDmSendPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMdcmAgentDmSendPopList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		LOGGER.debug("pMap : {}", pMap.toString());
		
		// 협력사 수신정보 조회
		List<Map<String,String>> _data = masterMdCmAgentDmSendPopService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}

	/**
	 * 협력사 DM 발송
	 * @param pReq
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdcmAgentDmSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdcmAgentDmSend(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("pMap : {}", pMap.toString());
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCmAgentDmSendPopService.saveMasterMdcmAgentDmSend(formData, gridData);

//		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);

		return _response;
	}

	/**
	 * 메일 템플릿 목록 취득
	 * @param pReq
	 * @param pMap
	 * @return Map<String, Object> _response
	 */
	@RequestMapping(value = "/mdcm/getMasterMdcmAgentDmSendTemplateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdcmAgentDmSendTemplateList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		//페이징용 파라미터의 셋팅
		LOGGER.debug("/mdcm/getMasterMdcmAgentDmSendTemplateList.do Map 요청 파라미터 : formData {} ", pMap);
		// 메일 템플릿 목록 조회
		List<Map<String,String>> _data = masterMdCmAgentDmSendPopService.getDmSendTemplateList(pMap);
		_response.put("data", _data);
		return  _response;
	}
	
	/**
	 * 이슈 정보 취득
	 * @param pReq
	 * @param pMap
	 * @return Map<String, Object> _response
	 */
	@RequestMapping(value = "/mdcm/getMasterMdcmAgentDmIssueList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdcmAgentDmIssueList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		//페이징용 파라미터의 셋팅
		LOGGER.debug("/mdcm/getMasterMdcmAgentDmInfoList.do pMap 요청 파라미터 : formData {} ", pMap);

		// 이슈 정보 취득
		List<Map<String,String>> _data = masterMdCmAgentDmSendPopService.getAgentDmIssueList(pMap);
		
		_response.put("data", _data);
		return  _response;
	}	
}
