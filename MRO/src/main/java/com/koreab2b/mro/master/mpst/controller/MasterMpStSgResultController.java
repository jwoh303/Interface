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
import com.koreab2b.mro.master.mpst.service.MasterMpStSgResultService;

@Controller("masterMpStSgResultController")
public class MasterMpStSgResultController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStSgResultController.class);

	@Autowired
	private MasterMpStSgResultService masterMpStSgResultService;
	
	// 조회
	@RequestMapping(value = "/mpst/getMasterMpStSgResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStSgResultList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStSgResultService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 팝업조회
	@RequestMapping(value = "/mpst/getMasterMpStCategoryRecordPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStCategoryRecordPopList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStSgResultService.getPopList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpst/excelMasterMpStSgResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		List<Map<String,String>> _data = masterMpStSgResultService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

}
