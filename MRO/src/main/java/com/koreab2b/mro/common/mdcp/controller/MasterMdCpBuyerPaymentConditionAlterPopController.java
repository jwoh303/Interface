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

import com.koreab2b.mro.common.mdcp.service.MasterMdCpBuyerPaymentConditionAlterPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpBuyerPaymentConditionAlterPopController")
public class MasterMdCpBuyerPaymentConditionAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpBuyerPaymentConditionAlterPopController.class);

	@Autowired
	private MasterMdCpBuyerPaymentConditionAlterPopService masterMdCpBuyerPaymentConditionAlterPopService;
	
	/**
	 * 고객사결제조건 수정 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/getMasterMdCpBuyerPaymentConditionAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpBuyerPaymentConditionAlterPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpBuyerPaymentConditionAlterPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCpBuyerPaymentConditionAlterPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcp/masterMdCpBuyerPaymentConditionAlterPop";
	}	 
	
}
