package com.koreab2b.mro.common.mdcm.controller;

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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmStndrdCatalogDetailViewPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmStndrdCatalogDetailViewPopController")
public class MasterMdCmStndrdCatalogDetailViewPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndrdCatalogDetailViewPopController.class);

	@Autowired
	private MasterMdCmStndrdCatalogDetailViewPopService masterMdCmStndrdCatalogDetailViewPopService;
	
	/**
	 * 표준카탈로그 상세보기  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmStndrdCatalogDetailViewPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmStndrdCatalogDetailViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmStndrdCatalogDetailViewPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCmStndrdCatalogDetailViewPopService.getList(pMap); 
		List<Map<String, String>> _attrData = masterMdCmStndrdCatalogDetailViewPopService.getCmsCatalogDispPopAttr(pMap);
		List<Map<String, String>> _imgData = masterMdCmStndrdCatalogDetailViewPopService.getCmsCatalogDispPopImg(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("attrData", CommonUtil.getListNvl(_attrData));
		pModel.addAttribute("imgData", CommonUtil.getListNvl(_imgData));
		pModel.addAttribute("st_cms_catlg_id", pMap.get("st_cms_catlg_id"));
		
		return "common/popup/mdcm/masterMdCmStndrdCatalogDetailViewPop";
	}	 
	
	// 저장
	@RequestMapping(value = "/mdcm/saveMasterMdCmStndrdCatalogDetailViewPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmStndrdCatalogDetailViewPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		logger.debug("saveMasterMdCmStndrdCatalogDetailViewPop MultiValueMap 요청 파라미터 : formData", pMap); 
		String rtnMsg = masterMdCmStndrdCatalogDetailViewPopService.updateSelectedData(pMap);

		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
}
