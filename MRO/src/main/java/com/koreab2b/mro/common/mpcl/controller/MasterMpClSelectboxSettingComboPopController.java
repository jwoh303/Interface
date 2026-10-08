package com.koreab2b.mro.common.mpcl.controller;

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

import com.koreab2b.mro.common.mpcl.service.MasterMpClSelectboxSettingComboPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpClSelectboxSettingComboPopController")
public class MasterMpClSelectboxSettingComboPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpClSelectboxSettingComboPopController.class);

	@Autowired
	private MasterMpClSelectboxSettingComboPopService masterMpClSelectboxSettingComboPopService;
	
	/**
	 * selectbox 설정 콤보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpcl/getMasterMpClSelectboxSettingComboPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpClSelectboxSettingComboPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpcl/getMasterMpClSelectboxSettingComboPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMpClSelectboxSettingComboPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpcl/masterMpClSelectboxSettingComboPop";
	}	 
	
}
