package com.koreab2b.mro.common.none.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.none.service.CommonNoNeDeptChoiceMultiPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonNoNeDeptChoiceMultiPopController")
public class CommonNoNeDeptChoiceMultiPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonNoNeDeptChoiceMultiPopController.class);

	@Autowired
	private CommonNoNeDeptChoiceMultiPopService commonNoNeDeptChoiceMultiPopService;
	
	/**
	 * 구매사(고객사) 선택 (다건) 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/none/getCommonNoNeDeptChoiceMultiPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonNoNeDeptChoiceMultiPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/none/getCommonNoNeDeptChoiceMultiPop.do 요청 파라미터 for jsp : {}", pMap);
		
		List<Map<String, String>> _data = commonNoNeDeptChoiceMultiPopService.getCommonNoNeDeptChoiceMultiPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/none/commonNoNeDeptChoiceMultiPop";
	}	 
	
}
