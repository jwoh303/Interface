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

import com.koreab2b.mro.common.mprq.service.BuyerMpRqDepartmentTotalPopService;

@Controller("buyerMpRqDepartmentTotalPopController")
public class BuyerMpRqDepartmentTotalPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqDepartmentTotalPopController.class);

	@Autowired
	private BuyerMpRqDepartmentTotalPopService buyerMpRqDepartmentTotalPopService;
	
	/**
	 * 부서별 집계  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqDepartmentTotalPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqDepartmentTotalPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getBuyerMpRqDepartmentTotalPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String,String> _data1 = buyerMpRqDepartmentTotalPopService.getHdForm(pMap); 
		List<Map<String, String>> _data2 = buyerMpRqDepartmentTotalPopService.getList(pMap); 
		pModel.addAttribute("data1", _data1); 
		pModel.addAttribute("data2", _data2); 
		
		return "common/popup/mprq/buyerMpRqDepartmentTotalPop";
	}	 
	
	
	
}
