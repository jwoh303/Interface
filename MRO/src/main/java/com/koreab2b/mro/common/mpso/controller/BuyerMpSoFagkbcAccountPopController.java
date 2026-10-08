package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoFagkbcAccountPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 셰플러코리아 장바구니 관리번호 선택 팝업
 * @author cha3202
 *PG_06_B_006_03
 */
@Controller("buyerMpSoFagkbcAccountPopController")
public class BuyerMpSoFagkbcAccountPopController {
 

	@Autowired
	private BuyerMpSoFagkbcAccountPopService buyerMpSoFagkbcAccountPopService;
	
	/**
	 * FAGKBC소모품계정과목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoFagkbcAccountPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoFagkbcAccountPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoFagkbcAccountPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoFagkbcAccountPop";
	}	 
	
}
