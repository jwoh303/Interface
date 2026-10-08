package com.koreab2b.mro.common.mdcd.controller;

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

import com.koreab2b.mro.common.mdcd.service.MasterMdCdBuyerCardInfoRegPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCdBuyerCardInfoRegPopController")
public class MasterMdCdBuyerCardInfoRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdBuyerCardInfoRegPopController.class);

	@Autowired
	private MasterMdCdBuyerCardInfoRegPopService masterMdCdBuyerCardInfoRegPopService;
	
	/**
	 * 고객카드정보 등록  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcd/getMasterMdCdBuyerCardInfoRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCdBuyerCardInfoRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/getMasterMdCdBuyerCardInfoRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCdBuyerCardInfoRegPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcd/masterMdCdBuyerCardInfoRegPop";
	}	 
	
}
