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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mdcd.service.MasterMdCdCompanyAddressPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCdCompanyAddressPopController")
public class MasterMdCdCompanyAddressPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdCompanyAddressPopController.class);

	@Autowired
	private MasterMdCdCompanyAddressPopService masterMdCdCompanyAddressPopService;
	
	/**
	 * 소재지  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */		
	
	@RequestMapping(value = "/mdcd/getCompanyAddressPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCompanyAddressPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/getCompanyAddressPop.do 요청 파라미터 for jsp : {}", pMap);		
		List<Map<String, String>> _data = masterMdCdCompanyAddressPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcd/masterMdCdCompanyAddressPop";
	}
	
	@RequestMapping(value = "/mdcd/delCompanyAddressPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delCompanyAddressPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/delCompanyAddressPop.do 요청 파라미터 for jsp : {}", pMap);	
		
		Map<String, Object> _response = new HashMap<String, Object>();		
		
		Map<String,String> _result  = masterMdCdCompanyAddressPopService.deleteData(pMap); 
		
		_response.put("msg", _result.get("MSG"));
		return  _response;
	}
	
	@RequestMapping(value = "/mdcd/saveCompanyAddressPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveCompanyAddressPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/saveCompanyAddressPop.do 요청 파라미터 for jsp : {}", pMap);		
		
		
		
		Map<String, Object> _response = new HashMap<String, Object>();		
		
		Map<String,String> _result  = masterMdCdCompanyAddressPopService.saveData(pMap); 
		
		_response.put("msg", _result.get("MSG"));
		return  _response;	
		
	}
	
	@RequestMapping(value = "/mdcd/addCompanyAddressPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addCompanyAddressPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/addCompanyAddressPop.do 요청 파라미터 for jsp : {}", pMap);	
		
		Map<String, Object> _response = new HashMap<String, Object>();		
				
		Map<String,String> _result  = masterMdCdCompanyAddressPopService.addData(pMap); 
		
		_response.put("msg", _result.get("MSG"));
		return  _response;	
	}
	
}
