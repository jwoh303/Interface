package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoPartInfoPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * (주)게스템프 카테크 장바구니 계정과목 선택 팝업
 * @author cha3202
 *PG_06_B_006_20
 */
@Controller("buyerMpSoPartInfoPopController")
public class BuyerMpSoPartInfoPopController { 

	@Autowired
	private BuyerMpSoPartInfoPopService buyerMpSoPartInfoPopService;
	
	/**
	 * 파트정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoPartInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoPartInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoPartInfoPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoPartInfoPop";
	}	 
	
}
