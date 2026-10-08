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

import com.koreab2b.mro.common.mpiv.service.SellerMpIvDivsnDeliveryPlanEntryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDivsnDeliveryPlanEntryPopController")
public class SellerMpIvDivsnDeliveryPlanEntryPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDivsnDeliveryPlanEntryPopController.class);

	@Autowired
	private SellerMpIvDivsnDeliveryPlanEntryPopService sellerMpIvDivsnDeliveryPlanEntryPopService;
	
	/**
	 * 분할납품 계획입력 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvDivsnDeliveryPlanEntryPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvDivsnDeliveryPlanEntryPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getSellerMpIvDivsnDeliveryPlanEntryPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpIvDivsnDeliveryPlanEntryPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/sellerMpIvDivsnDeliveryPlanEntryPop";
	}	 
	
}
