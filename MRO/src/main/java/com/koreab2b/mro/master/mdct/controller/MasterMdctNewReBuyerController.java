package com.koreab2b.mro.master.mdct.controller;

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
import com.koreab2b.mro.master.mdct.service.MasterMdctNewReBuyerService;

@Controller("masterMdctNewReBuyerController")
public class MasterMdctNewReBuyerController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdctNewReBuyerController.class);
	
	@Autowired
	private MasterMdctNewReBuyerService masterMdctNewReBuyerService;
	
	// 전체 조회
	@RequestMapping(value = "/mdct/getMasterMdctNewReBuyerAllList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdctNewReBuyerAllList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdctNewReBuyerAllList 요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMdctNewReBuyerService.getAllList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 개인 조회
	@RequestMapping(value = "/mdct/getMasterMdctNewReBuyerIndvList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdctNewReBuyerIndvList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdctNewReBuyerIndvList 요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMdctNewReBuyerService.getIndvList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
