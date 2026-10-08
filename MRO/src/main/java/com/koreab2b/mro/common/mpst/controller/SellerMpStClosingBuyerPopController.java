package com.koreab2b.mro.common.mpst.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpst.service.SellerMpStClosingBuyerPopService;

@Controller("sellerMpStClosingBuyerPopController")
public class SellerMpStClosingBuyerPopController {
	@Autowired
	private SellerMpStClosingBuyerPopService sellerMpStClosingBuyerPopService;

	@RequestMapping(value = "/mpst/showSellerMpStClosingBuyerPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoAccountSelPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String, String>> _data = sellerMpStClosingBuyerPopService.getSellerMpStClosingBuyerPop(pMap); 
		pModel.addAttribute("data", _data); 
		
		return "common/popup/mpst/sellerMpStClosingBuyerPop";
	}
	
}
