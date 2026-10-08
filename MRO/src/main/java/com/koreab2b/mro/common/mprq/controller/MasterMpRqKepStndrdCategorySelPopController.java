package com.koreab2b.mro.common.mprq.controller;

import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mprq.service.MasterMpRqKepStndrdCategorySelPopService;

@Controller("masterMpRqKepStndrdCategorySelPopController")
public class MasterMpRqKepStndrdCategorySelPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqKepStndrdCategorySelPopController.class);

	@Autowired
	private MasterMpRqKepStndrdCategorySelPopService masterMpRqKepStndrdCategorySelPopService;
	
	/**
	 * KeP표준 카테고리 선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqKepStndrdCategorySelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqKepStndrdCategorySelPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getMasterMpRqKepStndrdCategorySelPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqKepStndrdCategorySelPopService.getList(pMap); 
		_response.put("data", _data);
		return _response;
	}	 
	
	/**
	 * KeP표준 카테고리 조회조건 검색
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getCategorySelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCategorySelPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mprq/getCategorySelPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqKepStndrdCategorySelPopService.getCategorySelPop(pMap); 
		_response.put("data", _data);
		return _response;
	}	 
	
}
