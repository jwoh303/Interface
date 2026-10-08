package com.koreab2b.mro.common.coco.controller;

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

import com.koreab2b.mro.common.coco.service.CommonCoCoBuyerCategoryChoiceDooPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonCoCoBuyerCategoryChoiceDooPopController")
public class CommonCoCoBuyerCategoryChoiceDooPopController {
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonCoCoBuyerCategoryChoiceDooPopController.class);
	
	@Autowired
	private CommonCoCoBuyerCategoryChoiceDooPopService commonCoCoBuyerCategoryChoiceDooPopService;
	
	/**
	 * 고객사 카테고리 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBuyerCategoryChoiceDooPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBuyerCategoryChoiceDooPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mpiv/getCommonCoCoBuyerCategoryChoiceDooPop.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		
		String buyer_name = commonCoCoBuyerCategoryChoiceDooPopService.getCategoryComText(pMap); 
		pModel.addAttribute("buyer_name", buyer_name); 
		return "common/popup/coco/commonCoCoBuyerCategoryChoiceDooPop";
	}
	
	/**
	 * 고객사 카테고리 depth 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/coco/getBuyerCategoryDooSearch.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerCategoryDooSearch(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getBuyerCategorySearch 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_depth", CommonUtil.nvl((String)  pMap.get("st_depth"),"1"));
		pMap.put("st_categ_code", CommonUtil.nvl((String)  pMap.get("st_categ_code"),""));
		
		List<Map<String, String>> _data = commonCoCoBuyerCategoryChoiceDooPopService.getBuyerCategorySearch(pMap);
		
		_response.put("data", _data);
		return  _response; 
	}
	
	/**
	 * 고객사 카테고리 depth 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/coco/getBuyerCategorySearchReqDooValue.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerCategorySearchReqDooValue(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		LOGGER.debug("getBuyerCategorySearchReqValue 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_depth", CommonUtil.nvl((String)  pMap.get("st_depth"),"1"));
		
		pMap.put("st_searh_name", CommonUtil.nvl((String)  pMap.get("st_searh_name"),""));
		pMap.put("st_catalog",  CommonUtil.nvl((String)  pMap.get("st_catalog"),""));
		
		List<Map<String, String>> _data = commonCoCoBuyerCategoryChoiceDooPopService.getBuyerCategorySearchReqValue(pMap);
		
		_response.put("data", _data);
		return  _response; 
	}

}
