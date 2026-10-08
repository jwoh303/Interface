package com.koreab2b.mro.common.cmco.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.cmco.service.MasterCmCoKEPCorpRegNoListPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmCoKEPCorpRegNoListPopController")
public class MasterCmCoKEPCorpRegNoListPopController {

	@Autowired
	private MasterCmCoKEPCorpRegNoListPopService masterCmCoKEPCorpRegNoListPopService;
	
	/**
	 * KEP 사업자번호 목록 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmco/showMasterCmCoKEPCorpRegNoListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterCmCoKEPCorpRegNoListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterCmCoKEPCorpRegNoListPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		return "common/popup/cmco/masterCmCoKEPCorpRegNoListPop";
	}	 
	
}
