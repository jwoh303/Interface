package com.koreab2b.mro.buyer.mdam.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmCatalogCowayService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmCatalogCowayController")
public class BuyerMdAmCatalogCowayController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmCatalogCowayController.class);

	@Autowired
	private BuyerMdAmCatalogCowayService buyerMdAmCatalogCowayService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmCatalogCoway.do", method = RequestMethod.POST)
	public String getBuyerMdAmCatalogCoway(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdAmCatalogCowayService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/mdam/buyerMdAmCatalogCowayList";
	}
	
}
