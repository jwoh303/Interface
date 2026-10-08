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

import com.koreab2b.mro.common.mdcd.service.MasterMdCdPrimaryActivityDetailRegPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCdPrimaryActivityDetailRegPopController")
public class MasterMdCdPrimaryActivityDetailRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdPrimaryActivityDetailRegPopController.class);

	@Autowired
	private MasterMdCdPrimaryActivityDetailRegPopService masterMdCdPrimaryActivityDetailRegPopService;
	
	/**
	 * 주요활동내용등록  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcd/showMasterMdCdPrimaryActivityDetailRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCdPrimaryActivityDetailRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/getMasterMdCdPrimaryActivityDetailRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		if (pMap.get("add_date") == null) {
			return "common/popup/mdcd/masterMdCdPrimaryActivityDetailRegPop";
		}
		
		List<Map<String, String>> _data = masterMdCdPrimaryActivityDetailRegPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcd/masterMdCdPrimaryActivityDetailRegPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdcd/saveMasterMdCdPrimaryActivityDetailRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCdPrimaryActivityDetailRegPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		logger.debug("updateMasterMdCdPrimaryActivityDetailRegPop MultiValueMap 요청 파라미터 : formData {}", pMap); 
		String _rtnMsg = masterMdCdPrimaryActivityDetailRegPopService.updateSelectedData(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
		
	}
	
}
