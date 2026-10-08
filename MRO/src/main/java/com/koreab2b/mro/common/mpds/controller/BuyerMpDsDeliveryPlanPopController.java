package com.koreab2b.mro.common.mpds.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpds.service.BuyerMpDsDeliveryPlanPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsDeliveryPlanPopController")
public class BuyerMpDsDeliveryPlanPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsDeliveryPlanPopController.class);

	@Autowired
	private BuyerMpDsDeliveryPlanPopService buyerMpDsDeliveryPlanPopService;
	
	/**
	 * 납품계획 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getBuyerMpDsDeliveryPlanPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsDeliveryPlanPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsDeliveryPlanPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpDsDeliveryPlanPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpds/buyerMpDsDeliveryPlanPop";
	}	 
	
}
