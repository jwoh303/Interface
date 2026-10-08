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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmUnitpriceAlterHistoryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmUnitpriceAlterHistoryPopController")
public class MasterMdCmUnitpriceAlterHistoryPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmUnitpriceAlterHistoryPopController.class);

	@Autowired
	private MasterMdCmUnitpriceAlterHistoryPopService masterMdCmUnitpriceAlterHistoryPopService;
	
	/**
	 * 단가변경이력  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmUnitpriceAlterHistoryPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmUnitpriceAlterHistoryPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmUnitpriceAlterHistoryPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCmUnitpriceAlterHistoryPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcm/masterMdCmUnitpriceAlterHistoryPop";
	}	 
	
}
