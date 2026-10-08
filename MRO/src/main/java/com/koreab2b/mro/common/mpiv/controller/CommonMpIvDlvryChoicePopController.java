package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDlvryChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvDlvryChoicePopController")
public class CommonMpIvDlvryChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDlvryChoicePopController.class);

	@Autowired
	private CommonMpIvDlvryChoicePopService commonMpIvDlvryChoicePopService;
	
	/**
	 * 배송처 선택 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvDlvryChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvDlvryChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvDlvryChoicePop.do 요청 파라미터 for jsp : {}", pMap);
		pMap.put("st_buyer_code", CommonUtil.nvl((String)  pMap.get("st_buyer_code"),"ALL"));
		List<Map<String, String>> _data = commonMpIvDlvryChoicePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/commonMpIvDlvryChoicePop";
	}	 
	
}
