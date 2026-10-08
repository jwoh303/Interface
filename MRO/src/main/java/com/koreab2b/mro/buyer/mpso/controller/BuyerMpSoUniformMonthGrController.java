package com.koreab2b.mro.buyer.mpso.controller;

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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoUniformMonthGrService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("buyerMpSoUniformMonthGrController")
public class BuyerMpSoUniformMonthGrController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoUniformMonthGrController.class);
	
	@Autowired
	private BuyerMpSoUniformMonthGrService buyerMpSoUniformMonthGrService;
	
	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoUniformMonthGrList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchBuyerMpSoUniformMonthGrList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = buyerMpSoUniformMonthGrService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpso/excelBuyerMpSoUniformMonthGrList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = buyerMpSoUniformMonthGrService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
}
