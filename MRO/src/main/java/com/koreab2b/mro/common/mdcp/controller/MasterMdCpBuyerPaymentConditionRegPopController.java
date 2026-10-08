package com.koreab2b.mro.common.mdcp.controller;

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

import com.koreab2b.mro.common.mdcp.service.MasterMdCpBuyerPaymentConditionRegPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpBuyerPaymentConditionRegPopController")
public class MasterMdCpBuyerPaymentConditionRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpBuyerPaymentConditionRegPopController.class);

	@Autowired
	private MasterMdCpBuyerPaymentConditionRegPopService masterMdCpBuyerPaymentConditionRegPopService;
	
	/**
	 * 고객사결제조건 등록 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/getMasterMdCpBuyerPaymentConditionRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpBuyerPaymentConditionRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpBuyerPaymentConditionRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCpBuyerPaymentConditionRegPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcp/masterMdCpBuyerPaymentConditionRegPop";
	}	 
	
}
