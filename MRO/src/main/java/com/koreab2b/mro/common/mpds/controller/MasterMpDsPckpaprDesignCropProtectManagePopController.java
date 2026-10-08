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

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.mpds.service.MasterMpDsPckpaprDesignCropProtectManagePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpDsPckpaprDesignCropProtectManagePopController")
public class MasterMpDsPckpaprDesignCropProtectManagePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsPckpaprDesignCropProtectManagePopController.class);

	@Autowired
	private MasterMpDsPckpaprDesignCropProtectManagePopService masterMpDsPckpaprDesignCropProtectManagePopService;
	@Autowired
	private CommonInfoService commonInfoService;
	
	/**
	 * 포장지 도안 관리(작물보호) 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getMasterMpDsPckpaprDesignCropProtectManagePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpDsPckpaprDesignCropProtectManagePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getMasterMpDsPckpaprDesignCropProtectManagePop.do 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data = masterMpDsPckpaprDesignCropProtectManagePopService.getList(pMap);
		Map<String, String> userRole = commonInfoService.getUserRole(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("userRole", CommonUtil.nvlMap(userRole));
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpds/masterMpDsPckpaprDesignCropProtectManagePop";
	}

	/**
	 * 바코드 부여
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/barCodeGrant.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> barCodeGrant( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("masterUpdateReg01 MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);	
		
		String _ret =  masterMpDsPckpaprDesignCropProtectManagePopService.getBarCode(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}		
	
	
	/**
	 * 저장1
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/setSysopDongBuOrderPackingSave.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> setSysopDongBuOrderPackingSave( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("masterUpdateReg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  masterMpDsPckpaprDesignCropProtectManagePopService.regSave(formData); 

		pModel.addAllAttributes(pMap);
		_response.put("msg", rtnMsg);
		logger.debug("_response " + _response);
			
		return  _response;
	}

	/**
	 * 저장2
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/setBuyerDongBuOrderPackingSaveMM.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> setBuyerDongBuOrderPackingSaveMM( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("masterUpdateReg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  masterMpDsPckpaprDesignCropProtectManagePopService.regSaveMM(formData); 

		_response.put("msg", rtnMsg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	
	
	/**
	 * 종결
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/masterUpdateReg01.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> masterUpdateReg01( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("masterUpdateReg01 MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);	
		String _ret =  masterMpDsPckpaprDesignCropProtectManagePopService.regSave01(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}	


}
