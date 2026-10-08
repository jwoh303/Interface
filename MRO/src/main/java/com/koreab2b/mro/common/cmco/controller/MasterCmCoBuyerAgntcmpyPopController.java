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

import com.koreab2b.mro.common.cmco.service.MasterCmCoBuyerAgntcmpyPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmCoBuyerAgntcmpyPopController")
public class MasterCmCoBuyerAgntcmpyPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterCmCoBuyerAgntcmpyPopController.class);

	@Autowired
	private MasterCmCoBuyerAgntcmpyPopService masterCmCoBuyerAgntcmpyPopService;
	
	/**
	 * 고객사, 협력사 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmco/getMasterCmCoBuyerAgntcmpyPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterCmCoBuyerAgntcmpyPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("/cmco/getMasterCmCoBuyerAgntcmpyPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterCmCoBuyerAgntcmpyPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/cmco/masterCmCoBuyerAgntcmpyPop";
	}	 
	
}
