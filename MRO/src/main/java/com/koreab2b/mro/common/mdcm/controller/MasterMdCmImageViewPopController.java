package com.koreab2b.mro.common.mdcm.controller;

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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmImageViewPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmImageViewPopController")
public class MasterMdCmImageViewPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmImageViewPopController.class);

	@Autowired
	private MasterMdCmImageViewPopService masterMdCmImageViewPopService;
	
	/**
	 * 이미지보기  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmImageViewPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmImageViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmImageViewPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCmImageViewPopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("st_cms_catlg_id", pMap.get("st_cms_catlg_id"));
		
		return "common/popup/mdcm/masterMdCmImageViewPop";
	}	 
	
}
