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

import com.koreab2b.mro.common.mprq.service.BuyerMpRqQuotationNegoHistoryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqQuotationNegoHistoryPopController")
public class BuyerMpRqQuotationNegoHistoryPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqQuotationNegoHistoryPopController.class);

	@Autowired
	private BuyerMpRqQuotationNegoHistoryPopService buyerMpRqQuotationNegoHistoryPopService;
	
	/**
	 * 견적단가이력 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotationNegoHistoryPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqQuotationNegoHistoryPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = buyerMpRqQuotationNegoHistoryPopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "/common/popup/mprq/buyerMpRqQuotationNegoHistoryPop";
	}
}
