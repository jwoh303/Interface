package com.koreab2b.mro.common.mdam.controller;

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

import com.koreab2b.mro.common.mdam.service.BuyerMdAmBudgetDepartmentChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmBudgetDepartmentChoicePopController")
public class BuyerMdAmBudgetDepartmentChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDepartmentChoicePopController.class);

	@Autowired
	private BuyerMdAmBudgetDepartmentChoicePopService buyerMdAmBudgetDepartmentChoicePopService;
	
	/**
	 * 예산부서선택 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetDepartmentChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMdAmBudgetDepartmentChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdam/getBuyerMdAmBudgetDepartmentChoicePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMdAmBudgetDepartmentChoicePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdam/buyerMdAmBudgetDepartmentChoicePop";
	}	 
	
}
