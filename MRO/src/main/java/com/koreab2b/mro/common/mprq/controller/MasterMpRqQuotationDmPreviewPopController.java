package com.koreab2b.mro.common.mprq.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mprq.service.MasterMpRqQuotationDmPreviewPopService;

@Controller("masterMpRqQuotationDmPreviewPopController")
public class MasterMpRqQuotationDmPreviewPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationDmPreviewPopController.class);

	@Autowired
	private MasterMpRqQuotationDmPreviewPopService masterMpRqQuotationDmPreviewPopService;
	
	// 견적내용 조회
	@RequestMapping(value = "/mprq/getMasterMdcmQuotationDmPreviewPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdcmQuotationDmPreviewPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqQuotationDmPreviewPopService.getList(pMap);
		_response.put("data", _data);
		
		return _response;
	}
}
