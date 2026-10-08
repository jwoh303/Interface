package com.koreab2b.mro.master.mdct.controller;

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

import com.koreab2b.mro.master.mdct.service.MasterMdCtNewCustomerBidManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtNewCustomerBidManageController")
public class MasterMdCtNewCustomerBidManageController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdCtNewCustomerBidManageController.class);
	
	@Autowired
	private MasterMdCtNewCustomerBidManageService masterMdCtNewCustomerBidManageService;
	
	// 잠재고객 입찰정보조회
	@RequestMapping(value = "/mdct/getMasterMdCtNewCustomerBidList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtNewCustomerBidList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterMdCtNewCustomerBidManageService.getDetailList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdct/masterMdctNewCustomerBidPop";
	}
	
	// 잠재고객 입찰정보저장
	@RequestMapping(value = "/mdct/saveMasterMdCtNewCustomerBidList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtNewCustomerBidList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerBidManageService.saveMasterMdCtNewCustomerBidList(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 잠재고객 입찰취소
	@RequestMapping(value = "/mdct/cancleMasterMdCtNewCustomerBidList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMasterMdCtNewCustomerBidList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerBidManageService.cancleMasterMdCtNewCustomerBidList(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 잠재고객 셋업정보조회
	@RequestMapping(value = "/mdct/getMasterMdCtNewCustomerSetList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtNewCustomerSetList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterMdCtNewCustomerBidManageService.getSetupList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdct/masterMdctNewCustomerSetPop";
	}
	// 잠재고객 셋업정보저장
	@RequestMapping(value = "/mdct/saveMasterMdCtNewCustomerSetList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtNewCustomerSetList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerBidManageService.saveMasterMdCtNewCustomerSetList(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 잠재고객 셋업취소
	@RequestMapping(value = "/mdct/cancleMasterMdCtNewCustomerSetList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMasterMdCtNewCustomerSetList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerBidManageService.cancleMasterMdCtNewCustomerSetList(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 잠재고객 계약정보조회
	@RequestMapping(value = "/mdct/getMasterMdCtNewCustomerConList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtNewCustomerConList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterMdCtNewCustomerBidManageService.getConList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdct/masterMdctNewCustomerConPop";
	}	
	// 잠재고객 계약정보저장
	@RequestMapping(value = "/mdct/saveMasterMdCtNewCustomerConList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtNewCustomerConList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerBidManageService.saveMasterMdCtNewCustomerConList(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 잠재고객 계약취소
	@RequestMapping(value = "/mdct/cancleMasterMdCtNewCustomerConList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMasterMdCtNewCustomerConList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerBidManageService.cancleMasterMdCtNewCustomerConList(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
}
