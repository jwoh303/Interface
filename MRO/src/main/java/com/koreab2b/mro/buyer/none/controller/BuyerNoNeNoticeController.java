package com.koreab2b.mro.buyer.none.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.none.service.BuyerNoNeNoticeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerNoNeNoticeController")
public class BuyerNoNeNoticeController {
	
	@Autowired
	private BuyerNoNeNoticeService buyerNoNeNoticeService;
	
	// 조회
	@RequestMapping(value = "/none/getbuyerNoNeNoticeListPop.do", method = RequestMethod.POST)
	public String getbuyerNoNeNoticeListPop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerNoNeNoticeService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/none/buyerNoNeNoticeListPop";
	}
	
	// 조회
	@RequestMapping(value = "/none/getbuyerNoNeNoticeDetailPop.do", method = RequestMethod.POST)
	public String getbuyerNoNeNoticeDetailPop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 화면 조회
		Map<String, String> _data = buyerNoNeNoticeService.getDetail(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "buyer/none/buyerNoNeNoticeDetailPop";
	}

}
