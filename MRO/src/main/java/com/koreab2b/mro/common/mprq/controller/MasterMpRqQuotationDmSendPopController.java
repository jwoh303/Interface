package com.koreab2b.mro.common.mprq.controller;

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
import com.koreab2b.mro.common.mprq.service.MasterMpRqQuotationDmSendPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqQuotationDmSendPopController")
public class MasterMpRqQuotationDmSendPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationDmSendPopController.class);

	@Autowired
	private MasterMpRqQuotationDmSendPopService masterMpRqQuotationDmSendPopService;
	
	// 수신정보 조회
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationDmSendPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationDmSendPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqQuotationDmSendPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 템플릿 조회
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationDmSendTemplateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationDmSendTemplateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqQuotationDmSendPopService.getTemplateList(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	
	// 견적정비 DM 발송
	@RequestMapping(value = "/mprq/saveMasterMpRqQuotationDmSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqQuotationDmSend(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("요청 파라미터 : {}", pMap);
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqQuotationDmSendPopService.saveMasterMpRqQuotationDmSend(formData, gridData);

//		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);

		return _response;
	}
}
