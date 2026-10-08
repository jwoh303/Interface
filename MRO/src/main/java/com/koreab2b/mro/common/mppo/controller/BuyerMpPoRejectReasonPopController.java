package com.koreab2b.mro.common.mppo.controller;

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

import com.koreab2b.mro.common.mppo.service.BuyerMpPoRejectReasonPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoRejectReasonPopController")
public class BuyerMpPoRejectReasonPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpPoRejectReasonPopController.class);

	@Autowired
	private BuyerMpPoRejectReasonPopService buyerMpPoRejectReasonPopService;
	
	/**
	 * 반려사유 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mppo/getBuyerMpPoRejectReasonPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpPoRejectReasonPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mppo/getBuyerMpPoRejectReasonPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpPoRejectReasonPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mppo/buyerMpPoRejectReasonPop";
	}	 
	
}
