package com.koreab2b.mro.common.mpds.controller;

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

import com.koreab2b.mro.common.mpds.service.MasterMpDsOrderInfoConfirmPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpDsOrderInfoConfirmPopController")
public class MasterMpDsOrderInfoConfirmPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsOrderInfoConfirmPopController.class);

	@Autowired
	private MasterMpDsOrderInfoConfirmPopService masterMpDsOrderInfoConfirmPopService;
	
	/**
	 * 발주 정보 확인 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getMasterMpDsOrderInfoConfirmPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpDsOrderInfoConfirmPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getMasterMpDsOrderInfoConfirmPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMpDsOrderInfoConfirmPopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		return "common/popup/mpds/masterMpDsOrderInfoConfirmPop";
	}
	
	/**
	 * 발주 취소
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/cancelMasterMpDsOrderInfoConfirmPop.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> cancelMasterMpDsOrderInfoConfirmPop(ModelMap pModel, @RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("cancelMasterMpDsOrderInfoConfirmPop MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  masterMpDsOrderInfoConfirmPopService.cancelOrderInfo(formData); 

		_response.put("msg", rtnMsg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	
	/**
	 * 발주 수정
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/modifyMasterMpDsOrderInfoConfirmPop.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> modifyMasterMpDsOrderInfoConfirmPop(ModelMap pModel, @RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("cancelMasterMpDsOrderInfoConfirmPop MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  masterMpDsOrderInfoConfirmPopService.modifyOrderInfo(formData); 

		_response.put("msg", rtnMsg);
		logger.debug("_response " + _response);
			
		return  _response;
	}		

	
	/**
	 * 발주 생성
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/regMasterMpDsOrderInfoConfirmPop.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> regMasterMpDsOrderInfoConfirmPop(ModelMap pModel, @RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("cancelMasterMpDsOrderInfoConfirmPop MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  masterMpDsOrderInfoConfirmPopService.regOrderInfo(formData); 

		_response.put("msg", rtnMsg);
		logger.debug("_response " + _response);
			
		return  _response;
	}			
}
