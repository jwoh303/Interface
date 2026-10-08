package com.koreab2b.mro.common.mpvo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpvo.service.MasterMpVoVocCompanyPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocCompanyPopController")
public class MasterMpVoVocCompanyPopController {
	@Autowired
	private MasterMpVoVocCompanyPopService masterMpVoVocCompanyPopService;
	
	/**
	 * VOC 고객사 복수 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocCompanyPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocCompanyPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		
		pMap.put("st_claim_kind", CommonUtil.nvl((String) pMap.get("st_claim_kind"), ""));
		pMap.put("st_sys_type", CommonUtil.nvl((String) pMap.get("st_sys_type"), ""));
		pMap.put("st_date_flag", CommonUtil.nvl((String) pMap.get("st_date_flag"), "-14"));
		
		List<Map<String, String>> _data = masterMpVoVocCompanyPopService.getMasterMpVoVocCompanyPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocCompanyPop";
	}
	
	/**
	 * VOC 협력사 복수 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocAgntcmpyPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocAgntcmpyPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		
		pMap.put("st_claim_kind", CommonUtil.nvl((String) pMap.get("st_claim_kind"), ""));
		pMap.put("st_sys_type", CommonUtil.nvl((String) pMap.get("st_sys_type"), ""));
		pMap.put("st_date_flag", CommonUtil.nvl((String) pMap.get("st_date_flag"), "-14"));
		
		List<Map<String, String>> _data = masterMpVoVocCompanyPopService.getMasterMpVoVocAgntcmpyPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocAgntcmpyPop";
	}
}
