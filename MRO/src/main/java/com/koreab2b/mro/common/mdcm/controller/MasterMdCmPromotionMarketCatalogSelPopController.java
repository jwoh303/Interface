package com.koreab2b.mro.common.mdcm.controller;

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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmPromotionMarketCatalogSelPopService;

@Controller("masterMdCmPromotionMarketCatalogSelPopController")
public class MasterMdCmPromotionMarketCatalogSelPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmPromotionMarketCatalogSelPopController.class);

	@Autowired
	private MasterMdCmPromotionMarketCatalogSelPopService masterMdCmPromotionMarketCatalogSelPopService;
	
	/**
	 * 판촉물 전용마켓 카테고리 선택 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmPromotionMarketCatalogSelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmPromotionMarketCatalogSelPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getMasterMdCmPromotionMarketCatalogSelPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmPromotionMarketCatalogSelPopService.getList(pMap); 
		_response.put("data", _data);
		return _response;
	}	 
	
	/**
	 * 판촉물 전용마켓 카테고리  조회조건 검색
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getCategorySelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCategorySelPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getCategorySelPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmPromotionMarketCatalogSelPopService.getCategorySelPop(pMap); 
		_response.put("data", _data);
		return _response;
	}	 
	
	/**
	 * 품목정보에 따른 담당자 체크
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getSgInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSgInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getSgInfo.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmPromotionMarketCatalogSelPopService.getSgInfo(pMap); 
		_response.put("data", _data);
		return _response;
	}	
	
	/**
	 * 품목정보에 따른 카테고리 체크
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getBuyerSgInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerSgInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getSgInfo.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmPromotionMarketCatalogSelPopService.getBuyerSgInfo(pMap); 
		_response.put("data", _data);
		return _response;
	}
	/**
	 * 품목정보에 따른 고객사예외
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getCategInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCategInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getSgInfo.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmPromotionMarketCatalogSelPopService.getCategInfo(pMap); 
		_response.put("data", _data);
		return _response;
	}
	/**
	 * 신규회원사가입자체크
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getNewUserInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getNewUserInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmPromotionMarketCatalogSelPopService.getNewUserInfo(pMap); 
		_response.put("data", _data);
		return _response;
	}
	/**
	 * 주문불가능
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getOrderUserInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getOrderUserInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmPromotionMarketCatalogSelPopService.getOrderUserInfo(pMap); 
		_response.put("data", _data);
		return _response;
	}
	
	/**
	 * 품목정보에 따른 SMART팀  담당자 체크
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getSmartSgInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> getSmartSgInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getSmartSgInfo.do 요청 파라미터 for jsp : {}", pMap); 		
		Map<String, String> _data = masterMdCmPromotionMarketCatalogSelPopService.getSmartSgInfo(pMap);		
		return _data;
	}
	
	/**
	 * 품목정보에 따른 SMART팀  담당자 체크(ID리스트)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getSmartSgIdInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public List<String> getSmartSgIdInfo(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("/mdcm/getSmartSgIdInfo.do 요청 파라미터 for jsp : {}", pMap); 		
		List<String> _data = masterMdCmPromotionMarketCatalogSelPopService.getSmartSgIdInfo(pMap);		
		return _data;
	}
	
}
