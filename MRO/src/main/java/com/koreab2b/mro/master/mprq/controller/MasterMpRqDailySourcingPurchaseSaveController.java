package com.koreab2b.mro.master.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.master.mprq.service.MasterMpRqDailySourcingPurchaseSaveService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqDailySourcingPurchaseSaveController")
public class MasterMpRqDailySourcingPurchaseSaveController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDailySourcingPurchaseSaveController.class);

	@Autowired
	private MasterMpRqDailySourcingPurchaseSaveService masterMpRqDailySourcingPurchaseSaveService;

	@RequestMapping(value = "/mprq/initMasterMpRqDailySourcingPurchase.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> initMasterMpRqDailySourcingPurchase(@RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		LOGGER.debug("요청 파라미터 : {}", gridData);
		Map<String,String> _result = masterMpRqDailySourcingPurchaseSaveService.initQuotation(formData, gridData);

		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}

	@RequestMapping(value = "/mprq/saveMasterMpRqDailySourcingPurchaseEndTime.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqDailySourcingPurchaseEndTime(@RequestParam MultiValueMap<String, String> pMap) {
		return toResponse(masterMpRqDailySourcingPurchaseSaveService.updateEndTime(CommonUtil.getMultiValueMapMap(pMap), CommonUtil.getMultiValueMapList(pMap)));
	}

	@RequestMapping(value = "/mprq/saveMasterMpRqDailySourcingPurchaseMsdsReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqDailySourcingPurchaseMsdsReq(@RequestParam MultiValueMap<String, String> pMap) {
		return toResponse(masterMpRqDailySourcingPurchaseSaveService.updateMsdsReq(CommonUtil.getMultiValueMapMap(pMap), CommonUtil.getMultiValueMapList(pMap)));
	}

	@RequestMapping(value = "/mprq/saveMasterMpRqDailySourcingPurchaseItemChgReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqDailySourcingPurchaseItemChgReq(@RequestParam MultiValueMap<String, String> pMap) {
		return toResponse(masterMpRqDailySourcingPurchaseSaveService.updateItemChgReq(CommonUtil.getMultiValueMapMap(pMap), CommonUtil.getMultiValueMapList(pMap)));
	}

	@RequestMapping(value = "/mprq/saveMasterMpRqDailySourcingPurchaseDbCleansingCopy.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqDailySourcingPurchaseDbCleansingCopy(@RequestParam MultiValueMap<String, String> pMap) {
		return toResponse(masterMpRqDailySourcingPurchaseSaveService.updateDbCleansingCopy(CommonUtil.getMultiValueMapMap(pMap), CommonUtil.getMultiValueMapList(pMap)));
	}

	private Map<String, Object> toResponse(String rtnMsg) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
