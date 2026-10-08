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

import com.koreab2b.mro.common.mpds.service.BuyerMpDsQualityCmplnOccurFactorDeductPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsQualityCmplnOccurFactorDeductPopController")
public class BuyerMpDsQualityCmplnOccurFactorDeductPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsQualityCmplnOccurFactorDeductPopController.class);

	@Autowired
	private BuyerMpDsQualityCmplnOccurFactorDeductPopService buyerMpDsQualityCmplnOccurFactorDeductPopService;
	
	/**
	 * 품질불만 발생요인별 감점 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getBuyerMpDsQualityCmplnOccurFactorDeductPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsQualityCmplnOccurFactorDeductPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsQualityCmplnOccurFactorDeductPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpDsQualityCmplnOccurFactorDeductPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpds/buyerMpDsQualityCmplnOccurFactorDeductPop";
	}	 
	
}
