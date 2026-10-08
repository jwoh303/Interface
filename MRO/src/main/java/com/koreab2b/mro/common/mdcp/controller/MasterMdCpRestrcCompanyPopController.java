package com.koreab2b.mro.common.mdcp.controller;

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

import com.koreab2b.mro.common.mdcp.service.MasterMdCpRestrcCompanyPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpRestrcCompanyPopController")
public class MasterMdCpRestrcCompanyPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpRestrcCompanyPopController.class);

	@Autowired
	private MasterMdCpRestrcCompanyPopService masterMdCpRestrcCompanyPopService;
	
	/**
	 * 제재업체  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/showMasterMdCpRestrcCompanyPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpRestrcCompanyPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpRestrcCompanyPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCpRestrcCompanyPopService.getList(pMap);
		List<Map<String, String>> _data2 = masterMdCpRestrcCompanyPopService.getMdmList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2));
		return "common/popup/mdcp/masterMdCpRestrcCompanyPop";
	}	 
	
	// 저장
	@RequestMapping(value = "/mdcp/saveMasterMdCpRestrcCompanyPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpRestrcCompanyPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcp/saveMasterMdCpRestrcCompanyPop.do Map 요청 파라미터 : formData {}", pMap); 

		String _result = masterMdCpRestrcCompanyPopService.updateSelectedData(pMap);
		_response.put("msg", _result);

		return  _response;
	}
}
