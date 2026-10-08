package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoHongikAccntngItemPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 홍익대학교 관리번호(회계항목,계정과목) 선택 팝업
 * @author cha3202
 *PG_06_B_006_07
 */
@Controller("buyerMpSoHongikAccntngItemPopController")
public class BuyerMpSoHongikAccntngItemPopController {

 

	@Autowired
	private BuyerMpSoHongikAccntngItemPopService buyerMpSoHongikAccntngItemPopService;
	
	/**
	 * 홍익대학교 회계항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoHongikAccntngItemPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoHongikAccntngItemPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoHongikAccntngItemPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoHongikAccntngItemPop";
	}	 
	
}
