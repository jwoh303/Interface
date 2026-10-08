package com.koreab2b.mro.common.mprq.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mprq.service.BuyerMpRqCatalogRegYnPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqCatalogRegYnPopController")
public class BuyerMpRqCatalogRegYnPopController {

	@Autowired
	private BuyerMpRqCatalogRegYnPopService buyerMpRqCatalogRegYnPopService;
	
	/**
	 * 카탈로그 등록여부  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqCatalogRegYnPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqCatalogRegYnPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqCatalogRegYnPopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mprq/buyerMpRqCatalogRegYnPop";
		
	}	 
	
	/**
	 * 카탈로그 등록여부  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqCatalogRegYnPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpRqCatalogRegYnPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqCatalogRegYnPopService.getList_v2(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mprq/buyerMpRqCatalogRegYnPop_v2";
		
	}
}
