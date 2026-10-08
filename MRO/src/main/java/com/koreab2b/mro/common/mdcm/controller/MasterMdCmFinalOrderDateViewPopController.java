package com.koreab2b.mro.common.mdcm.controller;

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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmFinalOrderDateViewPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmFinalOrderDateViewPopController")
public class MasterMdCmFinalOrderDateViewPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmFinalOrderDateViewPopController.class);

	@Autowired
	private MasterMdCmFinalOrderDateViewPopService masterMdCmFinalOrderDateViewPopService;
	
	/**
	 * 최종발주일보기  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmFinalOrderDateViewPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmFinalOrderDateViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmFinalOrderDateViewPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCmFinalOrderDateViewPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcm/masterMdCmFinalOrderDateViewPop";
	}	 
	
}
