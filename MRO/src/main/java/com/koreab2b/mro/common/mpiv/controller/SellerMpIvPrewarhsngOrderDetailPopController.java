package com.koreab2b.mro.common.mpiv.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpiv.service.SellerMpIvPrewarhsngOrderDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvPrewarhsngOrderDetailPopController")
public class SellerMpIvPrewarhsngOrderDetailPopController {

	@Autowired
	private SellerMpIvPrewarhsngOrderDetailPopService sellerMpIvPrewarhsngOrderDetailPopService;
	
	/**
	 * 선입고요청 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvPrewarhsngOrderDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpIvPrewarhsngOrderDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		pMap.put("st_com_code", CommonUtil.nvl((String) pMap.get("st_com_code"), ""));
		pMap.put("st_buyer_code", CommonUtil.nvl((String) pMap.get("st_buyer_code"), ""));
		pMap.put("st_inv_no", CommonUtil.nvl((String) pMap.get("st_inv_no"), ""));
		
		List<Map<String, String>> _data = sellerMpIvPrewarhsngOrderDetailPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/sellerMpIvPrewarhsngOrderDetailPop";
	}	 
	
}
