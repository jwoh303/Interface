package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.mpiv.service.SellerMpIvDeliveryDelayBuyerChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryDelayBuyerChoicePopController")
public class SellerMpIvDeliveryDelayBuyerChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryDelayBuyerChoicePopController.class);

	@Autowired
	private SellerMpIvDeliveryDelayBuyerChoicePopService sellerMpIvDeliveryDelayBuyerChoicePopService;
	
	/**
	 * 납품지연고객사 선택 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryDelayBuyerChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvDeliveryDelayBuyerChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvDeliveryDelayBuyerChoicePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpIvDeliveryDelayBuyerChoicePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		return "common/popup/mpiv/sellerMpIvDeliveryDelayBuyerChoicePop";
	}	 
	
}
