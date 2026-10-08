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

import com.koreab2b.mro.common.mpds.service.BuyerMpDsInspDetailItemPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsInspDetailItemPopController")
public class BuyerMpDsInspDetailItemPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsInspDetailItemPopController.class);

	@Autowired
	private BuyerMpDsInspDetailItemPopService buyerMpDsInspDetailItemPopService;
	
	/**
	 * 검사 세부 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getBuyerMpDsInspDetailItemPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsInspDetailItemPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsInspDetailItemPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpDsInspDetailItemPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpds/buyerMpDsInspDetailItemPop";
	}	 
	
}
