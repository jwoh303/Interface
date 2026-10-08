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
import com.koreab2b.mro.master.mpst.service.MasterMpStQuotationStatsService;

@Controller("masterMpStQuotationStatsController")
public class MasterMpStQuotationStatsController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStQuotationStatsController.class);

	@Autowired
	private MasterMpStQuotationStatsService masterMpStQuotationStatsService;
	
	// 조회
	@RequestMapping(value = "/mpst/getMasterMpStQuotationStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStQuotationStatsList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStQuotationStatsService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	@RequestMapping(value = "/mpst/excelMasterMpStQuotationStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMpStQuotationStatsList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpStQuotationStatsService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

	

}
