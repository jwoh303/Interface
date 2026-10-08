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

import com.koreab2b.mro.common.mpcl.service.MasterMpClBuyerCorpRegNoListPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpClBuyerCorpRegNoListPopController")
public class MasterMpClBuyerCorpRegNoListPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpClBuyerCorpRegNoListPopController.class);

	@Autowired
	private MasterMpClBuyerCorpRegNoListPopService masterMpClBuyerCorpRegNoListPopService;
	
	/**
	 * 고객사 사업자번호 목록 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpcl/getMasterMpClBuyerCorpRegNoListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpClBuyerCorpRegNoListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpcl/getMasterMpClBuyerCorpRegNoListPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMpClBuyerCorpRegNoListPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpcl/masterMpClBuyerCorpRegNoListPop";
	}	 
	
}
