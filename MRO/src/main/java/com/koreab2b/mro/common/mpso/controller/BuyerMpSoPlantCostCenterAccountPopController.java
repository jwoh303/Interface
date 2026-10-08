package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoPlantCostCenterAccountPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoPlantCostCenterAccountPopController")
public class BuyerMpSoPlantCostCenterAccountPopController {
 
	@Autowired
	private BuyerMpSoPlantCostCenterAccountPopService buyerMpSoPlantCostCenterAccountPopService;
	
	/**
	 * PLANTCOSTCENTERACCOUNT 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoPlantCostCenterAccountPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoPlantCostCenterAccountPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoPlantCostCenterAccountPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoPlantCostCenterAccountPop";
	}	 
	
}
