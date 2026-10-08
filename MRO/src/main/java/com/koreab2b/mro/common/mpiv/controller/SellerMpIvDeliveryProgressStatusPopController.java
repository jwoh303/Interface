package com.koreab2b.mro.common.mpiv.controller;


import java.util.Map;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("sellerMpIvDeliveryProgressStatusPopController")
public class SellerMpIvDeliveryProgressStatusPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryProgressStatusPopController.class);

	/**
	 * 진행상태에 따른 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/sellerMpIvDeliveryProgressStatusPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String sellerMpIvDeliveryProgressStatusPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/sellerMpIvDeliveryProgressStatusPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		return "common/popup/mpiv/sellerMpIvDeliveryProgressStatusPop_v2";
	}	 
}
