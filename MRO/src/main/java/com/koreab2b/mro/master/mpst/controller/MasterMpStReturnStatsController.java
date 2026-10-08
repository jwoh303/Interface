package com.koreab2b.mro.master.mpst.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpst.service.MasterMpStReturnStatsService;

@Controller("masterMpStReturnStatsController")
public class MasterMpStReturnStatsController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStReturnStatsController.class);
	
	@Autowired
	private MasterMpStReturnStatsService masterMpStReturnStatsService;

	// 반품통계 전체 조회
	@RequestMapping(value = "/mpst/getMasterMpStReturnStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpStReturnStatsList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		pMap.put("st_yyyymm", pMap.get("st_from_date").toString().replaceAll("/", "") );
		
		List<Map<String,String>> _data = masterMpStReturnStatsService.getReturnStatsList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 반품통계 고객사 조회
	@RequestMapping(value = "/mpst/getMasterMpStReturnStatsBuyerList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpStReturnStatsBuyerList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		pMap.put("st_yyyymm", pMap.get("st_from_date").toString().replaceAll("/", "") );
		
		List<Map<String,String>> _data = masterMpStReturnStatsService.getReturnStatsBuyerList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 반품통계 협력사 조회
	@RequestMapping(value = "/mpst/getMasterMpStReturnStatsAgentList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpStReturnStatsAgentList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		pMap.put("st_yyyymm", pMap.get("st_from_date").toString().replaceAll("/", "") );
		
		List<Map<String,String>> _data = masterMpStReturnStatsService.getReturnStatsAgentList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
