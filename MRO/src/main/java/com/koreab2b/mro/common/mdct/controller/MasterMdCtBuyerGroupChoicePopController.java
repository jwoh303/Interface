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

import com.koreab2b.mro.common.mdct.service.MasterMdCtBuyerGroupChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtBuyerGroupChoicePopController")
public class MasterMdCtBuyerGroupChoicePopController {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtBuyerGroupChoicePopController.class);

	@Autowired
	private MasterMdCtBuyerGroupChoicePopService masterMdCtBuyerGroupChoicePopService;
	
	/**
	 * 고객사 그룹 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerGroupChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtBuyerGroupChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getMasterMdCtBuyerGroupChoicePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCtBuyerGroupChoicePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/masterMdCtBuyerGroupChoicePop";
	}
}
