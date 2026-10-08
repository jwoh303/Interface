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

import com.koreab2b.mro.common.mpiv.service.CommonMpIvBuyerTotalPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvBuyerTotalPopController")
public class CommonMpIvBuyerTotalPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvBuyerTotalPopController.class);

	@Autowired
	private CommonMpIvBuyerTotalPopService commonMpIvBuyerTotalPopService;
	
	/**
	 * 고객사별 집계 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerTotalPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvBuyerTotalPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvBuyerTotalPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonMpIvBuyerTotalPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/mpiv/commonMpIvBuyerTotalPop";
	}	 
	
}
