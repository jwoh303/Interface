package com.koreab2b.mro.common.mdcm.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.koreab2b.mro.common.mdcm.service.SellerMdCmBuyerCatalogAlterPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCmBuyerCatalogAlterPopController")
public class SellerMdCmBuyerCatalogAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCmBuyerCatalogAlterPopController.class);

	@Autowired
	private SellerMdCmBuyerCatalogAlterPopService sellerMdCmBuyerCatalogAlterPopService;
	
	/**
	 * 고객사 카탈로그 변경 화면 SHOW
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/showSellerMdCmBuyerCatalogAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMdCmBuyerCatalogAlterPopDetail(ModelMap pModel, HttpServletRequest pRequest) {
//		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		
		String st_item_no = CommonUtil.nvl((String) pRequest.getParameter("st_item_no"),"");  //  (조회조건)
		
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("st_item_no", st_item_no);
		
		Map<String, String> _data = sellerMdCmBuyerCatalogAlterPopService.getData(pMap); 
		
		pModel.addAttribute("data", _data);

		return "common/popup/mdcm/sellerMdCmBuyerCatalogAlterPop";
	}
	
}
