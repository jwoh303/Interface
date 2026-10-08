package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoCategoryTotalViewPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 
 * @author cha3202
 * PG_06_B_006_50 , PG_06_B_006_60
 * 카테고리 합계보기 , 예산조회
 *
 */
@Controller("buyerMpSoCategoryTotalViewPopController")
public class BuyerMpSoCategoryTotalViewPopController {
 
	@Autowired
	private BuyerMpSoCategoryTotalViewPopService buyerMpSoCategoryTotalViewPopService;
	
	/**
	 * 카테고리 합계보기 조회PG_06_B_006_50
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getCategoryListSelectPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCategoryListSelectPop(ModelMap pModel,  HttpServletRequest req,@RequestParam Map<String, String> pMap) {
 
		 
		
		List<Map<String, String>> _data = buyerMpSoCategoryTotalViewPopService.getCategoryListSelectPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoCategoryTotalViewPop";
	}	 
	
	
	/**
	 * 예산조회PG_06_B_006_60
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerAdminBudgetListSql.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerAdminBudgetListSql(ModelMap pModel,  HttpServletRequest req,@RequestParam Map<String, String> pMap) {
 
		 
		
		List<Map<String, String>> _data = buyerMpSoCategoryTotalViewPopService.getBuyerAdminBudgetListSql(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoBudgetListPop";
	}	 
	
}
