package com.koreab2b.mro.buyer.mpso.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoMonthReportService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("buyerMpSoMonthReportController")
public class BuyerMpSoMonthReportController {

	@Autowired
	private BuyerMpSoMonthReportService buyerMpSoMonthReportService;
	
	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoMonthReportList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpSoMonthReportList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = buyerMpSoMonthReportService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
