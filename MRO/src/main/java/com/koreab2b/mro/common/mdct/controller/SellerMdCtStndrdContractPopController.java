package com.koreab2b.mro.common.mdct.controller;

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

import com.koreab2b.mro.common.mdct.service.SellerMdCtStndrdContractPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtStndrdContractPopController")
public class SellerMdCtStndrdContractPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtStndrdContractPopController.class);

	@Autowired
	private SellerMdCtStndrdContractPopService sellerMdCtStndrdContractPopService;
	
	/**
	 * 표준계약서 조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/getSellerMdCtStndrdContractPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMdCtStndrdContractPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getSellerMdCtStndrdContractPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMdCtStndrdContractPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/sellerMdCtStndrdContractPop";
	}	 
	
}
