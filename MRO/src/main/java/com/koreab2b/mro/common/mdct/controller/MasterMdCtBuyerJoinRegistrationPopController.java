package com.koreab2b.mro.common.mdct.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller("masterMdCtBuyerJoinRegistrationPopController")
public class MasterMdCtBuyerJoinRegistrationPopController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtBuyerJoinRegistrationPopController.class);
	
	/**
	 * 고객회원사 등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showMasterMdCtBuyerJoinRegistrationPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtBuyerJoinAlterRequestApprovalPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		return "common/popup/mdct/masterMdCtBuyerJoinRegistrationPop";
	}

}
