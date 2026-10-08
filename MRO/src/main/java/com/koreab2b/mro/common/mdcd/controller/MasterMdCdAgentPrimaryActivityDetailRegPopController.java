package com.koreab2b.mro.common.mdcd.controller;

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

import com.koreab2b.mro.common.mdcd.service.MasterMdCdAgentPrimaryActivityDetailRegPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCdAgentPrimaryActivityDetailRegPopController")
public class MasterMdCdAgentPrimaryActivityDetailRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdAgentPrimaryActivityDetailRegPopController.class);

	@Autowired
	private MasterMdCdAgentPrimaryActivityDetailRegPopService masterMdCdAgentPrimaryActivityDetailRegPopService;
	
	/**
	 * 주요활동내용등록  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcd/showMasterMdCdAgentPrimaryActivityDetailRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCdAgentPrimaryActivityDetailRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/getMasterMdCdAgentPrimaryActivityDetailRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		if (pMap.get("add_date") == null) {
			return "common/popup/mdcd/masterMdCdAgentPrimaryActivityDetailRegPop";
		}
		
		List<Map<String, String>> _data = masterMdCdAgentPrimaryActivityDetailRegPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcd/masterMdCdAgentPrimaryActivityDetailRegPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdcd/saveMasterMdCdAgentPrimaryActivityDetailRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCdAgentPrimaryActivityDetailRegPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		logger.debug("updateMasterMdCdAgentPrimaryActivityDetailRegPop MultiValueMap 요청 파라미터 : formData {}", pMap); 
		String _rtnMsg = masterMdCdAgentPrimaryActivityDetailRegPopService.updateSelectedData(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
		
	}
	
}
