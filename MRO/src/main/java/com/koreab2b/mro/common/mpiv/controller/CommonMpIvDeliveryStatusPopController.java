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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDeliveryStatusPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvDeliveryStatusPopController")
public class CommonMpIvDeliveryStatusPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDeliveryStatusPopController.class);

	@Autowired
	private CommonMpIvDeliveryStatusPopService commonMpIvDeliveryStatusPopService;
	
	/**
	 * 납품상태 범례 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvDeliveryStatusPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvDeliveryStatusPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvDeliveryStatusPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonMpIvDeliveryStatusPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/mpiv/commonMpIvDeliveryStatusPop";
	}	 
	
}
