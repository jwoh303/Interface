package com.koreab2b.mro.common.mpvo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpvo.service.MasterMpVoVocUserSearchPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocUserSearchPopController")
public class MasterMpVoVocUserSearchPopController {
	
	@Autowired
	private MasterMpVoVocUserSearchPopService masterMpVoVocUserSearchPopService;
	
	/**
	 * 담당자 검색
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocUserSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocUserSearchPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		List<Map<String, String>> _data = masterMpVoVocUserSearchPopService.getMasterMpVoVocUserSearchPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocUserSearchPop";
	}
}
