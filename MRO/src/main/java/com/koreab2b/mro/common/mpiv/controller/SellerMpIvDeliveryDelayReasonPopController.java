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

import com.koreab2b.mro.common.mpiv.service.SellerMpIvDeliveryDelayReasonPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryDelayReasonPopController")
public class SellerMpIvDeliveryDelayReasonPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryDelayReasonPopController.class);

	@Autowired
	private SellerMpIvDeliveryDelayReasonPopService sellerMpIvDeliveryDelayReasonPopService;
	
	/**
	 * 납품지연 사유 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryDelayReasonPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvDeliveryDelayReasonPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvDeliveryDelayReasonPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpIvDeliveryDelayReasonPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/sellerMpIvDeliveryDelayReasonPop";
	}	 
	
}
