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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmCatalogService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmCatalogController")
public class BuyerMdAmCatalogController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmCatalogController.class);

	@Autowired
	private BuyerMdAmCatalogService buyerMdAmCatalogService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmCatalog.do", method = RequestMethod.POST)
	public String getBuyerMdAmCatalog(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdAmCatalogService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/mdam/buyerMdAmCatalogList";
	}
	
}
