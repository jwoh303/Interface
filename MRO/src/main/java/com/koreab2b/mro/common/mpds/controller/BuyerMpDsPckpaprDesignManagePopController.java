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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.mpds.service.BuyerMpDsPckpaprDesignManagePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsPckpaprDesignManagePopController")
public class BuyerMpDsPckpaprDesignManagePopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsPckpaprDesignManagePopController.class);

	@Autowired
	private BuyerMpDsPckpaprDesignManagePopService buyerMpDsPckpaprDesignManagePopService;
	@Autowired
	private CommonInfoService commonInfoService;
	
	/**
	 * 포장지 도안 관리(작물보호) 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getBuyerMpDsPckpaprDesignManagePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsPckpaprDesignManagePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsPckpaprDesignManagePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpDsPckpaprDesignManagePopService.getList(pMap);
		Map<String, String> userRole = commonInfoService.getUserRole(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("userRole", CommonUtil.nvlMap(userRole));
		pModel.addAllAttributes(pMap);
		return "common/popup/mpds/buyerMpDsPckpaprDesignManagePop";
	}	 

	
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyerUpdateEsFiReg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateEsFiReg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignManagePopService.regEsFiReg(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyerUpdateMMReg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateMMReg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 			
		
		String _ret =  buyerMpDsPckpaprDesignManagePopService.regMMReg(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyerUpdateDDReg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateDDReg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 
		
		String _ret =  buyerMpDsPckpaprDesignManagePopService.regDDReg(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyerUpdateEEReg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateEEReg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 
		
		String _ret =  buyerMpDsPckpaprDesignManagePopService.regEEReg(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyerUpdateEsMkReg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateEsMkReg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 
		
		String _ret =  buyerMpDsPckpaprDesignManagePopService.regEsMkReg(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyerUpdateEsPdReg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateEsPdReg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 
		
		String _ret =  buyerMpDsPckpaprDesignManagePopService.regEsPdReg(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyerUpdateEsQaReg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateEsQaReg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 
		
		String _ret =  buyerMpDsPckpaprDesignManagePopService.regEsQaReg(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}	
	
}
