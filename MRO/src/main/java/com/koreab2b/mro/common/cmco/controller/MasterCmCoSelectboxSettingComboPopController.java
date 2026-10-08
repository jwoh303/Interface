package com.koreab2b.mro.common.cmco.controller;

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

import com.koreab2b.mro.common.cmco.service.MasterCmCoSelectboxSettingComboPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmCoSelectboxSettingComboPopController")
public class MasterCmCoSelectboxSettingComboPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterCmCoSelectboxSettingComboPopController.class);

	@Autowired
	private MasterCmCoSelectboxSettingComboPopService masterCmCoSelectboxSettingComboPopService;
	
	/**
	 * selectbox 설정 콤보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmco/getMasterCmCoSelectboxSettingComboPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterCmCoSelectboxSettingComboPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/cmco/getMasterCmCoSelectboxSettingComboPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterCmCoSelectboxSettingComboPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/cmco/masterCmCoSelectboxSettingComboPop";
	}	 
	
}
