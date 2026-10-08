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
import com.koreab2b.mro.common.mprq.service.MasterMpRqBuyerQuotationSendPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqBuyerQuotationSendPopController")
public class MasterMpRqBuyerQuotationSendPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBuyerQuotationSendPopController.class);

	@Autowired
	private MasterMpRqBuyerQuotationSendPopService masterMpRqBuyerQuotationSendPopService;
	
	/**
	 * 고객사 견적제출  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerQuotationSendPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBuyerQuotationSendPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqBuyerQuotationSendPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mprq/saveBuyerQuotationSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerQuotationSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		Map<String,String> _result = masterMpRqBuyerQuotationSendPopService.saveBuyerQuotationSend(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	// 환율정보저장
	@RequestMapping(value = "/mprq/saveExpBuyerQuotationSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveExpBuyerQuotationSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		Map<String,String> _result = masterMpRqBuyerQuotationSendPopService.saveExpBuyerQuotationSend(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg","EXP");
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}

}
