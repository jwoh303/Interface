package com.koreab2b.mro.common.mdcp.controller;

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

import com.koreab2b.mro.common.mdcp.service.MasterMdCpCompyDetailViewPopService;

@Controller("masterMdCpCompyDetailViewPopController")
public class MasterMdCpCompyDetailViewPopController {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpUserDetailViewPopController.class);

	@Autowired
	private MasterMdCpCompyDetailViewPopService masterMdCpCompyDetailViewPopService;
	
	/**
	 * 사용자 상세조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/showMasterMdCpCompyDetailViewPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpCompyDetailViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpCompyDetailViewPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _compyData = masterMdCpCompyDetailViewPopService.getCompyList(pMap);
		List<Map<String, String>> _userData = masterMdCpCompyDetailViewPopService.getUserList(pMap);
		
		pModel.addAttribute("compyData", _compyData);
		pModel.addAttribute("userData", _userData);

		return "common/popup/mdcp/masterMdCpCompyDetailViewPop";
	}
	
}
