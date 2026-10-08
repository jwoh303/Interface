package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.SellerMpIvKtagPlanEntryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvKtagPlanEntryPopController")
public class SellerMpIvKtagPlanEntryPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvKtagPlanEntryPopController.class);

	@Autowired
	private SellerMpIvKtagPlanEntryPopService sellerMpIvKtagPlanEntryPopService;
	
	/**
	 * 분할납품 계획입력 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
//	@RequestMapping(value = "/mpiv/getSellerKtagPlanEntryPop.do", method = {RequestMethod.GET,RequestMethod.POST})
//	public String getSellerMpIvKtagPlanEntryPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
//		logger.debug("/mpiv/getSellerMpIvKtagPlanEntryPop.do 요청 파라미터 for jsp : {}", pMap); 
//		List<Map<String, String>> _data = sellerMpIvKtagPlanEntryPopService.getList(pMap); 
//		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
//		return "common/popup/mpiv/sellerMpIvKtagPlanEntryPop";
//	}	 
	
	
	/* 조회 */
	@RequestMapping(value = "/mpiv/getsellerMpIvKtagPlanEntryPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getsellerMpIvKtagPlanEntryPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, String> pMap) { 
		//pMap = CommonUtil.removeSlash(pMap);
		pMap.put("BUYER", CommonUtil.nvl((String)  pMap.get("st_buyer"),"ALL"));
		pMap.put("INV_NO", CommonUtil.nvl((String)  pMap.get("st_inv_no"),"ALL"));
		pMap.put("INV_SEQ", CommonUtil.nvl((String)  pMap.get("st_inv_seq"),"ALL"));
		pMap.put("BUYER_ITEM_NO", CommonUtil.nvl((String)  pMap.get("st_buyer_item_no"),"ALL"));
		List<Map<String, String>> _data = sellerMpIvKtagPlanEntryPopService.getList(pMap); 	
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));    
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "/common/popup/mpiv/sellerMpIvKtagPlanEntryPop_v2";
		} else {
			return "/common/popup/mpiv/sellerMpIvKtagPlanEntryPop";
		}
		
		
		
	}
	
	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvKtagPlanEntryPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpIvKtagPlanEntryPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();

		String flag = sellerMpIvKtagPlanEntryPopService.updateSelectedData(pMap);
		
		_response.put("msg", flag);
		
		return  _response;
	}
	
}
