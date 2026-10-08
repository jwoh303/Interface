package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoKolonGlobalCostCenterPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 코오롱글로벌CostCenter
 * @author cha3202
 *PG_06_B_006_08
 */
@Controller("buyerMpSoKolonGlobalCostCenterPopController")
public class BuyerMpSoKolonGlobalCostCenterPopController { 

	@Autowired
	private BuyerMpSoKolonGlobalCostCenterPopService buyerMpSoKolonGlobalCostCenterPopService;
	
	/**
	 * 코오롱글로벌CostCenter 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoKolonGlobalCostCenterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoKolonGlobalCostCenterPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoKolonGlobalCostCenterPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoKolonGlobalCostCenterPop";
	}	 
	
}
