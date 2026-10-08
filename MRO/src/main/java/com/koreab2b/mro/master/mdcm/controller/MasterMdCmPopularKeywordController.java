package com.koreab2b.mro.master.mdcm.controller;

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

import com.koreab2b.mro.master.mdcm.service.MasterMdCmPopularKeywordService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmPopularKeywordController")
public class MasterMdCmPopularKeywordController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmPopularKeywordController.class);

	@Autowired
	private MasterMdCmPopularKeywordService masterMdCmPopularKeywordService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmPopularKeywordList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmPopularKeywordList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		Map<String, Object> _response = new HashMap<String, Object>();

		Map<String,String> _data = masterMdCmPopularKeywordService.getList(pMap);
		
		_response.put("data", _data);
		
		return _response;
	}

	// 저장
	@RequestMapping(value = "/mdcm/saveMasterMdCmPopularKeywordList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmPopularKeyword(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		pMap = CommonUtil.removeSlash(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String rtnMsg = masterMdCmPopularKeywordService.updateSelectedData(pMap);
		
		_response.put("Message", rtnMsg);

		return  _response;
		
		
	}
}
