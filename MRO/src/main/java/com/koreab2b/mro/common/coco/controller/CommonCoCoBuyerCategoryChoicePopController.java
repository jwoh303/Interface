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

import com.koreab2b.mro.common.coco.service.CommonCoCoBuyerCategoryChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonCoCoBuyerCategoryChoicePopController")
public class CommonCoCoBuyerCategoryChoicePopController {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBuyerCategoryChoicePopController.class);
	
	@Autowired
	private CommonCoCoBuyerCategoryChoicePopService commonCoCoBuyerCategoryChoicePopService;
	
	/**
	 * 고객사 카테고리 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBuyerCategoryChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBuyerCategoryChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonCoCoBuyerCategoryChoicePop.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_user_id", CommonUtil.nvl((String)  pMap.get("st_user_id"),""));
		
		String buyer_name = commonCoCoBuyerCategoryChoicePopService.getCategoryComText(pMap); 
		pModel.addAttribute("buyer_name", buyer_name); 
		return "common/popup/coco/commonCoCoBuyerCategoryChoicePop";
	}
	
	/**
	 * 고객사 카테고리 depth 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/coco/getBuyerCategorySearch.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerCategorySearch(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getBuyerCategorySearch 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_depth", CommonUtil.nvl((String)  pMap.get("st_depth"),"1"));
		pMap.put("st_categ_code", CommonUtil.nvl((String)  pMap.get("st_categ_code"),""));
		
		List<Map<String, String>> _data = commonCoCoBuyerCategoryChoicePopService.getBuyerCategorySearch(pMap);
		
		_response.put("data", _data);
		return  _response; 
	}
	
	/**
	 * 고객사 카테고리 depth 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/coco/getBuyerCategorySearchReqValue.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerCategorySearchReqValue(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getBuyerCategorySearchReqValue 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_depth", CommonUtil.nvl((String)  pMap.get("st_depth"),"1"));
		
		pMap.put("st_searh_name", CommonUtil.nvl((String)  pMap.get("st_searh_name"),""));
		pMap.put("st_catalog",  CommonUtil.nvl((String)  pMap.get("st_catalog"),""));
		
		List<Map<String, String>> _data = commonCoCoBuyerCategoryChoicePopService.getBuyerCategorySearchReqValue(pMap);
		
		_response.put("data", _data);
		return  _response; 
	}

	/**
	 * 고객사 카테고리 선택 팝업_v2
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBuyerCategoryChoicePop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBuyerCategoryChoicePop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonCoCoBuyerCategoryChoicePop_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_user_id", CommonUtil.nvl((String)  pMap.get("st_user_id"),""));
		
		String buyer_name = commonCoCoBuyerCategoryChoicePopService.getCategoryComText(pMap); 
		pModel.addAttribute("buyer_name", buyer_name); 
		return "common/popup/coco/commonCoCoBuyerCategoryChoicePop_v2";
	}
}
