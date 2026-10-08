package com.koreab2b.mro.common.mppo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mppo.service.BuyerMpPoDvlyAgrmntHistoryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoDvlyAgrmntHistoryPopController")
public class BuyerMpPoDvlyAgrmntHistoryPopController {
 

	@Autowired
	private BuyerMpPoDvlyAgrmntHistoryPopService buyerMpPoDvlyAgrmntHistoryPopService;
	
	/**
	 * 납품합의 이력관리 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mppo/getBuyerMpPoDvlyAgrmntHistoryPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpPoDvlyAgrmntHistoryPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//logger.debug("/mppo/getBuyerMpPoDvlyAgrmntHistoryPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpPoDvlyAgrmntHistoryPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mppo/buyerMpPoDvlyAgrmntHistoryPop";
	}	 
	
}
