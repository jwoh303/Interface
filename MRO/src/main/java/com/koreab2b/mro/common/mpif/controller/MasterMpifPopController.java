package com.koreab2b.mro.common.mpif.controller;

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

import com.koreab2b.mro.common.mpif.service.MasterMpifPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpifPopController")
public class MasterMpifPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpifPopController.class);
	
	@Autowired
	MasterMpifPopService masterMpifPopService;

	/**
	 * I/F 메세지 조회 공통 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpif/getIfMessagePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getIfMessagePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		List<Map<String, String>> _data = masterMpifPopService.getIfMessage(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mpif/masterMpIfMessagePop";
	}
}