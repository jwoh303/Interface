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

import com.koreab2b.mro.common.mprq.service.BuyerMpRqNegoReqPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqNegoReqPopController")
public class BuyerMpRqNegoReqPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqNegoReqPopController.class);

	@Autowired
	private BuyerMpRqNegoReqPopService buyerMpRqNegoReqPopService;
	
	/**
	 * 네고요청  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqNegoReqPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqNegoReqPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getBuyerMpRqNegoReqPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpRqNegoReqPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mprq/buyerMpRqNegoReqPop";
	}	 
	
}
