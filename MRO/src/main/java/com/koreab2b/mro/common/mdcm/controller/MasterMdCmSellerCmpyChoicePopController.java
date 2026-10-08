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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmSellerCmpyChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmSellerCmpyChoicePopController")
public class MasterMdCmSellerCmpyChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmSellerCmpyChoicePopController.class);

	@Autowired
	private MasterMdCmSellerCmpyChoicePopService masterMdCmSellerCmpyChoicePopService;
	
	/**
	 * 협력사 선택 -기존,신규협력사검색 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmSellerCmpyChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmSellerCmpyChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmSellerCmpyChoicePop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterMdCmSellerCmpyChoicePopService.getList(pMap);
		 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcm/masterMdCmSellerCmpyChoicePop";
	}	 
	
}
