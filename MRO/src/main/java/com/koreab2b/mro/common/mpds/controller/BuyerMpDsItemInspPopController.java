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

import com.koreab2b.mro.common.mpds.service.BuyerMpDsItemInspPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsItemInspPopController")
public class BuyerMpDsItemInspPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsItemInspPopController.class);

	@Autowired
	private BuyerMpDsItemInspPopService buyerMpDsItemInspPopService;
	
	/**
	 * 항목별 검사 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getBuyerMpDsItemInspPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsItemInspPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsItemInspPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpDsItemInspPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpds/buyerMpDsItemInspPop";
	}	 
	
}
