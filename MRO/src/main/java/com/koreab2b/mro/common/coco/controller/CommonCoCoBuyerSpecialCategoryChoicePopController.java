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

import com.koreab2b.mro.common.coco.service.CommonCoCoBuyerSpecialCategoryChoicePopService;
import com.koreab2b.mro.common.coco.service.CommonCoCoBuyerCategoryChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonCoCoBuyerSpecialCategoryChoicePopController")
public class CommonCoCoBuyerSpecialCategoryChoicePopController {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBuyerSpecialCategoryChoicePopController.class);
	
	@Autowired
	private CommonCoCoBuyerSpecialCategoryChoicePopService CommonCoCoBuyerSpecialCategoryChoicePopService;
	@Autowired
	private CommonCoCoBuyerCategoryChoicePopService CommonCoCoBuyerCategoryChoicePopService;
	
	/**
	 * 특수 고객사 카테고리 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	                                       
	@RequestMapping(value = "/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBuyerSpecialCategoryChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonCoCoBuyerSpecialCategoryChoicePop.do 요청 파라미터 for jsp : {}", pMap);
		String buyer = pMap.get("st_buyer");
		pMap.put("st_buyer", CommonUtil.nvl((String)  buyer,""));
		
		String buyer_name = CommonCoCoBuyerCategoryChoicePopService.getCategoryComText(pMap); 
		pModel.addAttribute("buyer_name", buyer_name); 
		
		List<Map<String, String>> _data = CommonCoCoBuyerSpecialCategoryChoicePopService.getSpecialStdCategLevel1(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		String st_stdcateg_id   = CommonUtil.nvl((String) pMap.get("st_stdcateg_id"),"");
		 if((st_stdcateg_id.equals("")&&buyer.equals("KRDOOD0001")) || (st_stdcateg_id.equals("")&&buyer.equals("KRDOOS0004")))
         {
             st_stdcateg_id = "R";
         }
         if((st_stdcateg_id.equals("")&&buyer.equals("KRILJI0003")) || (st_stdcateg_id.equals("")&&buyer.equals("KRILJI0026")))
         {
             st_stdcateg_id = "6";
         }
         if((st_stdcateg_id.equals("")&&buyer.equals("KRHSDE0003")))
         {
             st_stdcateg_id = "9";
         }
         pModel.addAttribute("st_stdcateg_id", st_stdcateg_id); 
		
		return "common/popup/coco/commonCoCoBuyerSpecialCategoryChoicePop";
	}
	
	/**
	 * 고객사 카테고리 depth 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/coco/getBuyerSpecialCategorySearch.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerSpecialCategorySearch(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getBuyerSpecialCategorySearch 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_depth", CommonUtil.nvl((String)  pMap.get("st_depth"),"2"));
		pMap.put("st_categ_code", CommonUtil.nvl((String)  pMap.get("st_categ_code"),""));
		
		List<Map<String, String>> _data = CommonCoCoBuyerSpecialCategoryChoicePopService.getBuyerSpecialCategorySearch(pMap);
		
		_response.put("data", _data);
		return  _response; 
	}
	
	/**
	 * 고객사 카테고리 depth 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/coco/getBuyerSpecialCategorySearchReqValue.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerSpecialCategorySearchReqValue(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getBuyerSpecialCategorySearchReqValue 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_depth", CommonUtil.nvl((String)  pMap.get("st_depth"),"2"));
		
		pMap.put("st_searh_name", CommonUtil.nvl((String)  pMap.get("st_searh_name"),""));
		pMap.put("st_catalog",  CommonUtil.nvl((String)  pMap.get("st_catalog"),""));
		
		List<Map<String, String>> _data = CommonCoCoBuyerSpecialCategoryChoicePopService.getBuyerSpecialCategorySearchReqValue(pMap);
		
		_response.put("data", _data);
		return  _response; 
	}

}
