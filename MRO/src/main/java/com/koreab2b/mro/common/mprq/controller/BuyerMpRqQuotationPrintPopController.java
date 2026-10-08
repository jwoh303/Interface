package com.koreab2b.mro.common.mprq.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mprq.service.BuyerMpRqQuotationPrintPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqQuotationPrintPopController")
public class BuyerMpRqQuotationPrintPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqQuotationPrintPopController.class);

	@Autowired
	private BuyerMpRqQuotationPrintPopService buyerMpRqQuotationPrintPopService;
	
	/**
	 * 견적서출력  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotationPrintPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqQuotationPrintPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getBuyerMpRqQuotationPrintPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpRqQuotationPrintPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mprq/buyerMpRqQuotationPrintPop";
	}	 
	
}
