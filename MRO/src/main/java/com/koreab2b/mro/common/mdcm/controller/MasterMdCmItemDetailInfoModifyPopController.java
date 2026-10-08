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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmItemDetailInfoModifyPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmItemDetailInfoModifyPopController")
public class MasterMdCmItemDetailInfoModifyPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmItemDetailInfoModifyPopController.class);

	@Autowired
	private MasterMdCmItemDetailInfoModifyPopService masterMdCmItemDetailInfoModifyPopService;
	
	/**
	 * 상품정보 상세 및 수정 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmItemDetailInfoModifyPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmItemDetailInfoModifyPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmItemDetailInfoModifyPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _data = masterMdCmItemDetailInfoModifyPopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getMapNvl(_data)); 
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mdcm/masterMdCmItemDetailInfoModifyPop";
	}

	// 판촉물 삭제반려처리
	@RequestMapping(value = "/mdcm/saveMasterMdCmItemDetailInfoDeleteNotAccept.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmItemDetailInfoDeleteNotAccept(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		pMap = CommonUtil.removeSlash(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = masterMdCmItemDetailInfoModifyPopService.saveMasterMdCmItemDetailInfoDeleteNotAccept(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 판촉물 수정
	@RequestMapping(value = "/mdcm/saveMasterMdCmItemDetailInfoModifyPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmItemDetailInfoModifyPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		pMap = CommonUtil.removeSlash(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = masterMdCmItemDetailInfoModifyPopService.saveMasterMdCmItemDetailInfoModifyPop(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}	
	
}
