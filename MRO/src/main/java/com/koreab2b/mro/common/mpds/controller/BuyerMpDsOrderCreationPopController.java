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

import com.koreab2b.mro.common.mpds.service.BuyerMpDsOrderCreationPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsOrderCreationPopController")
public class BuyerMpDsOrderCreationPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsOrderCreationPopController.class);

	@Autowired
	private BuyerMpDsOrderCreationPopService buyerMpDsOrderCreationPopService;
	
	/**
	 * 발주생성 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getBuyerMpDsOrderCreationPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsOrderCreationPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsOrderCreationPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpDsOrderCreationPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpds/buyerMpDsOrderCreationPop";
	}	 
	
}
