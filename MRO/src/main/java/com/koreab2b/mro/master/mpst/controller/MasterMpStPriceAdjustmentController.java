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
import com.koreab2b.mro.master.mpst.service.MasterMpStPriceAdjustmentService;

@Controller("masterMpStPriceAdjustmentController")
public class MasterMpStPriceAdjustmentController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStPriceAdjustmentController.class);

	@Autowired
	private MasterMpStPriceAdjustmentService masterMpStPriceAdjustmentService;
	
	// 견적 최저가 예외 현황
	@RequestMapping(value = "/mpst/getMasterMpStQuotExceptionList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void getMasterMpStQuotExceptionList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMpStPriceAdjustmentService.getMasterMpStQuotExceptionList(pMap);
			
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
		
	// 견적 최저가 예외 상세
	@RequestMapping(value = "/mpst/getMasterMpStQuotExceptionDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void getMasterMpStQuotExceptionDetailList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
			
		List<Map<String,String>> _data = masterMpStPriceAdjustmentService.getMasterMpStQuotExceptionDetailList(pMap);
			
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
		
	// 주문 단가조정 현황
	@RequestMapping(value = "/mpst/getMasterMpStPoPriceAdjustList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void getMasterMpStPoPriceAdjustList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅			
		pMap = IBSheetUtil.addParamForPaging3(pMap);
			
		List<Map<String,String>> _data = masterMpStPriceAdjustmentService.getMasterMpStPoPriceAdjustList(pMap);
			
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
		
	// 주문 단가조정 상세
	@RequestMapping(value = "/mpst/getMasterMpStPoPriceAdjustDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void getMasterMpStPoPriceAdjustDetailList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
				
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
				
		List<Map<String,String>> _data = masterMpStPriceAdjustmentService.getMasterMpStPoPriceAdjustDetailList(pMap);
				
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
}
