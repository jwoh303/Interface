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
import com.koreab2b.mro.master.mpst.service.MasterMpStBuyerQuotationStatsService;

@Controller("masterMpStBuyerQuotationStatsController")
public class MasterMpStBuyerQuotationStatsController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStBuyerQuotationStatsController.class);

	@Autowired
	private MasterMpStBuyerQuotationStatsService masterMpStBuyerQuotationStatsService;
	
	// 조회
	@RequestMapping(value = "/mpst/getMasterMpStBuyerQuotationStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStBuyerQuotationStatsList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStBuyerQuotationStatsService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	@RequestMapping(value = "/mpst/excelMasterMpStBuyerQuotationStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMpStBuyerQuotationStatsList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpStBuyerQuotationStatsService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

}
