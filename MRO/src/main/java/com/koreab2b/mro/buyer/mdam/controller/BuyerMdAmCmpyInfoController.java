package com.koreab2b.mro.buyer.mdam.controller;

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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmCmpyInfoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmCmpyInfoController")
public class BuyerMdAmCmpyInfoController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmCmpyInfoController.class);

	@Autowired
	private BuyerMdAmCmpyInfoService buyerMdAmCmpyInfoService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmCmpyInfoList.do", method = RequestMethod.POST)
	public String getBuyerMdAmCmpyInfoList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		logger.debug("/mdam/buyerMdAmCmpyCorpManageService.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMdAmCmpyInfoService.getList(pMap);
		List<Map<String, String>> _passData = buyerMdAmCmpyInfoService.getPassList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("data_pass", CommonUtil.getListNvl(_passData));
		
		return "buyer/mdam/buyerMdAmCmpyInfoList";
	}

}
