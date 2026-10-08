package com.koreab2b.mro.common.mpvo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpvo.service.MasterMpVoVocDeptSearchPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocDeptSearchPopController")
public class MasterMpVoVocDeptSearchPopController {
	
	@Autowired
	private MasterMpVoVocDeptSearchPopService masterMpVoVocDeptSearchPopService;
	
	/**
	 * 건설사현장 검색 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocDeptSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocDeptSearchPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		pMap.put("com_code", CommonUtil.nvl((String) pMap.get("com_code"), ""));
		pMap.put("st_req_dept_name", CommonUtil.nvl((String) pMap.get("st_req_dept_name"), ""));
		List<Map<String, String>> _data = masterMpVoVocDeptSearchPopService.getMasterMpVoVocDeptSearchPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocDeptSearchPop";
	}
}
