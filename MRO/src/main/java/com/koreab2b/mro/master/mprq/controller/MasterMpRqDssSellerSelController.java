package com.koreab2b.mro.master.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mprq.service.MasterMpRqDssSellerSelService;

@Controller("masterMpRqDssSellerSelController")
public class MasterMpRqDssSellerSelController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDssSellerSelController.class);

	@Autowired
	private MasterMpRqDssSellerSelService masterMpRqDssSellerSelService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqDssSellerSelList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqDssSellerSelList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpRqDssSellerSelService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	@RequestMapping(value = "/mprq/getDssAgent.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getDssAgent(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqDssSellerSelService.getDssAgent(pMap);
		_response.put("data", _data);
		
		return _response;
	}

}
