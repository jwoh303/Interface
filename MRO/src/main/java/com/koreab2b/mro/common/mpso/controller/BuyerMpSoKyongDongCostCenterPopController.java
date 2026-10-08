package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoKyongDongCostCenterPopService;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 경동보일러 장바구니 관리번호 선택 팝업
 * @author cha3202
 *PG_06_B_006_05
 */
@Controller("buyerMpSoKyongDongCostCenterPopController")
public class BuyerMpSoKyongDongCostCenterPopController {

 

	@Autowired
	private BuyerMpSoKyongDongCostCenterPopService buyerMpSoKyongDongCostCenterPopService;
	
	/**
	 * 경동CostCenter 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoKyongDongCostCenterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoKyongDongCostCenterPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		List<Map<String, String>> _data = buyerMpSoKyongDongCostCenterPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoKyongDongCostCenterPop";
	}	 
	
}
