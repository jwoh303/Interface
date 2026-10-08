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

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDetailSearchPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvDetailSearchPopController")
public class CommonMpIvDetailSearchPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDetailSearchPopController.class);

	@Autowired
	private CommonMpIvDetailSearchPopService commonMpIvDetailSearchPopService;
	
	/**
	 * 상세검색  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvDetailSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvDetailSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvDetailSearchPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonMpIvDetailSearchPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/mpiv/commonMpIvDetailSearchPop";
	}	 
	
}
