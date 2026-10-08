package com.koreab2b.mro.master.mdcm.controller;

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

import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemCategorySelPopService;

@Controller("masterMdCmCmsItemCategorySelPopController")
public class MasterMdCmCmsItemCategorySelPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCmsItemCategorySelPopController.class);

	@Autowired
	private MasterMdCmCmsItemCategorySelPopService masterMdCmCmsItemCategorySelPopService;

	// 카테고리 드릴다운/초기 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemCategorySelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemCategorySelPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getMasterMdCmCmsItemCategorySelPop.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmCmsItemCategorySelPopService.getList(pMap);
		_response.put("data", _data);
		return _response;
	}

	// 카테고리 검색 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemCategorySelPopSearch(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getMasterMdCmCmsItemCategorySelPopSearch.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmCmsItemCategorySelPopService.getSearchList(pMap);
		_response.put("data", _data);
		return _response;
	}

	// 상세분류 선택 시 하단 속성 조회 (STUB - 속성 실 테이블 확정 시 매퍼 교체)
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemCategoryAttrList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemCategoryAttrList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getMasterMdCmCmsItemCategoryAttrList.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmCmsItemCategorySelPopService.getAttrList(pMap);
		_response.put("data", _data);
		return _response;
	}

	// 상세분류 정보 단건 조회 (리스트 그리드 상세분류 클릭 시 사전세팅용 - 경로/명/카테고리(SG))
	@RequestMapping(value = "/mdcm/getMasterMdCmCmsItemCategoryInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCmsItemCategoryInfo(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcm/getMasterMdCmCmsItemCategoryInfo.do 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> _data = masterMdCmCmsItemCategorySelPopService.getCategoryInfo(pMap);
		_response.put("data", _data);
		return _response;
	}

}
