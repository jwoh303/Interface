package com.koreab2b.mro.common.mdct.controller;

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

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.mdct.service.MasterMdctBuyerCorpGroupPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdctBuyerCorpGroupPopController")
public class MasterMdctBuyerCorpGroupPopController {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdctBuyerCorpGroupPopController.class);

	@Autowired
	private MasterMdctBuyerCorpGroupPopService masterMdctBuyerCorpGroupPopService;
	

	/**
	 * 고객사 법인그룹 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/getMasterMdctBuyerCorpGroupPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String getMasterMdctBuyerCorpGroupPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getMasterMdctBuyerCorpGroupPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdctBuyerCorpGroupPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/masterMdctBuyerCorpGroupPop";
	}	 
}
