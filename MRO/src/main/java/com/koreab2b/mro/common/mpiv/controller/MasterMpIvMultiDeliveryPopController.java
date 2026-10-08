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

import com.koreab2b.mro.common.mpiv.service.MasterMpIvMultiDeliveryPopService;

@Controller("masterMpIvMultiDeliveryPopController")
public class MasterMpIvMultiDeliveryPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvMultiDeliveryPopController.class);

	@Autowired
	private MasterMpIvMultiDeliveryPopService masterMpIvMultiDeliveryPopService;
	
	/**
	 * Multi-delivery 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getMasterMpIvMultiDeliveryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpIvMultiDeliveryPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = masterMpIvMultiDeliveryPopService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/masterMpIvMultiDeliveryPop";
	}
}
