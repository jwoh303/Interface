package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpso.service.MasterMpSoAgentPoMngPopService;

@Controller("masterMpSoAgentPoMngPopController")
public class MasterMpSoAgentPoMngPopController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoAgentPoMngPopController.class);

	@Autowired
	private MasterMpSoAgentPoMngPopService masterMpSoAgentPoMngPopService; 
	
	// 협력사별 발주관리 팝업
	@RequestMapping(value = "/mpso/getMasterMpSoAgentPoMngPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoAgentPoMngPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMpSoAgentPoMngPop 요청 파라미터 : {}", pMap);
	
		List<Map<String,String>> _data = masterMpSoAgentPoMngPopService.getAgentPoMngList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}