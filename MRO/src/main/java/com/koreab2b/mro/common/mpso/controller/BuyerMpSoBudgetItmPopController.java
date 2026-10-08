package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoBudgetItmPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 동부한농 동부기술원 장바구니 관리코드 선택 팝업
 * @author cha3202
 *PG_06_B_006_01
 */
@Controller("buyerMpSoBudgetItmPopController")
public class BuyerMpSoBudgetItmPopController {
 

	@Autowired
	private BuyerMpSoBudgetItmPopService buyerMpSoBudgetItmPopService;
	
	/**
	 * 예산비목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoBudgetItmPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoBudgetItmPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoBudgetItmPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoBudgetItmPop";
	}	 
	
}
