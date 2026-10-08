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

import com.koreab2b.mro.common.mdcp.service.MasterMdCpPaymentAccountFormPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpPaymentAccountFormPopController")
public class MasterMdCpPaymentAccountFormPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpPaymentAccountFormPopController.class);

	@Autowired
	private MasterMdCpPaymentAccountFormPopService masterMdCpPaymentAccountFormPopService;
	
	/**
	 * 결제계좌신고서  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/getMasterMdCpPaymentAccountFormPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpPaymentAccountFormPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpPaymentAccountFormPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCpPaymentAccountFormPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcp/masterMdCpPaymentAccountFormPop";
	}	 
	
}
