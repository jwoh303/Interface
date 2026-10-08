package com.koreab2b.mro.master.mdsr.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.master.mdsr.service.MasterMdSrSrNewReqService;

@Controller("masterMdSrSrNewReqController")
public class MasterMdSrSrNewReqController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrNewReqController.class);

	@Autowired
	private MasterMdSrSrNewReqService masterMdSrSrNewReqService;
		
	// 저장
	@RequestMapping(value = "/mdsr/saveMasterMdSrSrNewReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdSrSrNewReq(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMdSrSrNewReqService.updateSelectedData(pMap);
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("usrmsg","N");
		mp.put("msg", _result);
		
		_response.put("msg", mp);
		return _response;
		
	}
	
	// 품의상신 DOCU_NO 채번
	@RequestMapping(value = "/mdsr/getSrNoMasterMdSrSrNewReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> approvalMasterMdSrSrNewReq(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String,String> _result = masterMdSrSrNewReqService.approvalSelectedData(pMap);
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("SR_NO"));
		
		_response.put("msg", mp);
		return _response;
	}

}
