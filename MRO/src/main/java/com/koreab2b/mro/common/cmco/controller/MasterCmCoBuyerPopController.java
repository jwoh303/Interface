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

import com.koreab2b.mro.common.cmco.service.MasterCmCoBuyerPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmCoBuyerPopController")
public class MasterCmCoBuyerPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterCmCoBuyerPopController.class);

	@Autowired
	private MasterCmCoBuyerPopService masterCmCoBuyerPopService;
	
	/**
	 * 고객사 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmco/getMasterCmCoBuyerPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterCmCoBuyerPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/cmco/getMasterCmCoBuyerPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterCmCoBuyerPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/cmco/masterCmCoBuyerPop";
	}	 
	
}
