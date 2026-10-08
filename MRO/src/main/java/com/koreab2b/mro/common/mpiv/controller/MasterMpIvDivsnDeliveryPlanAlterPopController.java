package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.MasterMpIvDivsnDeliveryPlanAlterPopService;

@Controller("masterMpIvDivsnDeliveryPlanAlterPopController")
public class MasterMpIvDivsnDeliveryPlanAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvDivsnDeliveryPlanAlterPopController.class);

	@Autowired
	private MasterMpIvDivsnDeliveryPlanAlterPopService masterMpIvDivsnDeliveryPlanAlterPopService;
	
	/**
	 * 분할납품 계획 변경 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getMasterMpIvDivsnDeliveryPlanAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpIvDivsnDeliveryPlanAlterPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = masterMpIvDivsnDeliveryPlanAlterPopService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/masterMpIvDivsnDeliveryPlanAlterPop";
	}
	
	/**
	 * 분할납품 계획변경 저장
	 * @param pModel
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveMasterMpIvDivsnDeliveryPlanAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveMasterMpIvDivsnDeliveryPlanAlterPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
//		logger.debug("/mpiv/saveMasterMpIvDivsnDeliveryPlanAlterPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = masterMpIvDivsnDeliveryPlanAlterPopService.updateMasterMpIvDivsnDeliveryPlanAlterPop(pMap);
		
		_response.put("msg", flag);
		
		return _response;
	}
}
