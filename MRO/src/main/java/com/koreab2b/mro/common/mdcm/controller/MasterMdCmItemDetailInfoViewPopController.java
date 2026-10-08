package com.koreab2b.mro.common.mdcm.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmItemDetailInfoViewPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmItemDetailInfoViewPopController")
public class MasterMdCmItemDetailInfoViewPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmItemDetailInfoViewPopController.class);

	@Autowired
	private MasterMdCmItemDetailInfoViewPopService masterMdCmItemDetailInfoViewPopService;
	
	/**
	 * 상품상세보기 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmItemDetailInfoViewPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmItemDetailInfoViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmItemDetailInfoViewPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _data = masterMdCmItemDetailInfoViewPopService.getList(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getMapNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mdcm/masterMdCmItemDetailInfoViewPop";
	}	 

	// 저장
	@RequestMapping(value = "/mdcm/procMasterMdCmItemDetailInfoViewPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> procMasterMdCmItemDetailInfoViewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		pMap = CommonUtil.removeSlash(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = masterMdCmItemDetailInfoViewPopService.procMasterMdCmItemDetailInfoViewPop(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}	
}
