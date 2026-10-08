package com.koreab2b.mro.seller.mpcl.controller;

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
import com.koreab2b.mro.seller.mpcl.service.SellerMpClLogisRateDetailService;

@Controller("sellerMpClLogisRateDetailController")
public class SellerMpClLogisRateDetailController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(SellerMpClLogisRateDetailController.class);
	
	@Autowired
	private SellerMpClLogisRateDetailService sellerMpClLogisRateDetailService;
	
	// 조회
	@RequestMapping(value = "/mpcl/getSellerMpClLogisRateDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClLogisRateDetailList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClLogisRateDetailList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMpClLogisRateDetailService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드 (레거시)
	@RequestMapping(value = "/mpcl/excelSellerMpClLogisRateDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMpClLogisRateDetailService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

	// 조회 (리뉴얼)
	@RequestMapping(value = "/mpcl/getSellerMpClLogisRateDetailList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClLogisRateDetailList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClLogisRateDetailList_v2 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMpClLogisRateDetailService.getList_v2(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/mpcl/getSellerMpClLogisRateDetailList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpClLogisRateDetailList_v3(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClLogisRateDetailList_v3 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMpClLogisRateDetailService.getList_v3(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}


	// 엑셀다운로드 (리뉴얼)
	@RequestMapping(value = "/mpcl/excelSellerMpClLogisRateDetailList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList_v2(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = sellerMpClLogisRateDetailService.getList_v2(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
}
