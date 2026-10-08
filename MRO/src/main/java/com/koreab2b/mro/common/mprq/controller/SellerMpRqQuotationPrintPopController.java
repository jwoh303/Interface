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

import com.koreab2b.mro.common.mprq.service.SellerMpRqQuotationPrintPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpRqQuotationPrintPopController")
public class SellerMpRqQuotationPrintPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpRqQuotationPrintPopController.class);

	@Autowired
	private SellerMpRqQuotationPrintPopService sellerMpRqQuotationPrintPopService;
	
	/**
	 * 견적서 출력  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getSellerMpRqQuotationPrintPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpRqQuotationPrintPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getSellerMpRqQuotationPrintPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpRqQuotationPrintPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mprq/sellerMpRqQuotationPrintPop";
	}	 
	
}
