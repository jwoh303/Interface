package com.koreab2b.mro.master.mdcm.controller;

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

import com.koreab2b.mro.master.mdcm.service.MasterMdCmContractSelPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmContractSelPopController")
public class MasterMdCmContractSelPopController {
	
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmContractSelPopController.class);
	
	@Autowired
	private MasterMdCmContractSelPopService masterMdCmContractSelPopService;
	
	/**
	 * 구매사(고객사) 선택 (다건) 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmContractSelPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmContractSelPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/mdcm/getMasterMdCmContractSelPop.do 요청 파라미터 for jsp : {}", pMap);
		pMap.put("st_buyer", CommonUtil.nvl(pMap.get("st_buyer"), ""));
		pMap.put("nu_i", CommonUtil.nvl(pMap.get("nu_i"), ""));
		
		List<Map<String, String>> _data = masterMdCmContractSelPopService.getMasterMdCmContractSelPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcm/masterMdCmContractSelPop";
	}
}
