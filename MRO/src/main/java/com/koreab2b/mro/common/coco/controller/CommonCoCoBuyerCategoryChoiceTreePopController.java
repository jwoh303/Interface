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

import com.koreab2b.mro.common.coco.service.CommonCoCoBuyerCategoryChoiceTreePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonCoCoBuyerCategoryChoiceTreePopController")
public class CommonCoCoBuyerCategoryChoiceTreePopController {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBuyerCategoryChoicePopController.class);
	
	@Autowired
	private CommonCoCoBuyerCategoryChoiceTreePopService commonCoCoBuyerCategoryChoiceTreePopService;
	
	/**
	 * 고객사 카테고리 선택 팝업 ( 트리형 )
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBuyerCategoryChoiceTreePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonCoCoBuyerCategoryChoiceTreePop.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		
		String root_category_name = commonCoCoBuyerCategoryChoiceTreePopService.getCategoryComText(pMap); 
		List<Map<String,String>> _data = commonCoCoBuyerCategoryChoiceTreePopService.getCategoryTreeRootSelect(pMap);

		pModel.addAttribute("root_category_name", root_category_name); 
		pModel.addAttribute("data", _data); 
		return "common/popup/coco/commonCoCoBuyerCategoryChoiceTreePop";
	}
	
	/**
	 * 고객사 카테고리 선택 팝업 ( 트리형 )
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBuyerCategoryChoiceTreePop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBuyerCategoryChoiceTreePop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonCoCoBuyerCategoryChoiceTreePop_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		
		String root_category_name = commonCoCoBuyerCategoryChoiceTreePopService.getCategoryComText(pMap); 
		List<Map<String,String>> _data = commonCoCoBuyerCategoryChoiceTreePopService.getCategoryTreeRootSelect(pMap);

		pModel.addAttribute("root_category_name", root_category_name); 
		pModel.addAttribute("data", _data); 
		return "common/popup/coco/commonCoCoBuyerCategoryChoiceTreePop_v2";
	}
	
	
	/**
	 * 고객사 카테고리 하위 목록 조회
	 * @param pMap
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/coco/getCategoryTreeChildSelect.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCategoryTreeChildSelect(@RequestParam Map<String, String> pMap, HttpServletRequest req) {
		logger.debug("getCategoryTreeChildSelect 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_category_id", CommonUtil.nvl((String)  pMap.get("st_category_id"),""));
		
		List<Map<String, String>> _data = commonCoCoBuyerCategoryChoiceTreePopService.getCategoryTreeChildSelect(pMap);
		
		_response.put("data", _data);
		return  _response; 
	}
}
