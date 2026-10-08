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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpst.service.MasterMpStHeadTeamResultService;

@Controller("masterMpStHeadTeamResultController")
public class MasterMpStHeadTeamResultController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStHeadTeamResultController.class);

	@Autowired
	private MasterMpStHeadTeamResultService masterMpStHeadTeamResultService;
	
	// 조회
	@RequestMapping(value = "/mpst/getMasterMpStHeadTeamResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStHeadTeamResultList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStHeadTeamResultService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}

	// 차트 조회
	@RequestMapping(value = "/mpst/getMasterMpStHeadTeamResultList1.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStHeadTeamResultList1(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStHeadTeamResultService.getList1(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
		
	// 엑셀다운로드
	@RequestMapping(value = "/mpst/excelMasterMpStHeadTeamResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
	
		List<Map<String,String>> _data = masterMpStHeadTeamResultService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
}
