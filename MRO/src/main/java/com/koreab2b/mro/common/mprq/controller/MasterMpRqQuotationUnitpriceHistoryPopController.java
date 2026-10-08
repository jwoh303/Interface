package com.koreab2b.mro.common.mprq.controller;

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
import com.koreab2b.mro.common.mprq.service.MasterMpRqQuotationUnitpriceHistoryPopService;

@Controller("masterMpRqQuotationUnitpriceHistoryPopController")
public class MasterMpRqQuotationUnitpriceHistoryPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationUnitpriceHistoryPopController.class);

	@Autowired
	private MasterMpRqQuotationUnitpriceHistoryPopService masterMpRqQuotationUnitpriceHistoryPopService;
	
	/**
	 * 견적단가이력 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationUnitpriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationUnitpriceHistoryPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqQuotationUnitpriceHistoryPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationUnitpriceHistoryPop2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationUnitpriceHistoryPop2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqQuotationUnitpriceHistoryPopService.getList2(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationUnitpriceHistoryPop3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationUnitpriceHistoryPop3(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqQuotationUnitpriceHistoryPopService.getList3(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/*엑셀다운로드*/
	@RequestMapping(value = "/mprq/excelMasterMpRqQuotationUnitpriceHistoryPop2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		List<Map<String,String>> _data = masterMpRqQuotationUnitpriceHistoryPopService.getList2(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}

	
}
