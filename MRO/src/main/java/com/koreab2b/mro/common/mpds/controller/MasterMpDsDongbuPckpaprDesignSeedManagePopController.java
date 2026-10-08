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

import com.koreab2b.mro.common.mpds.service.MasterMpDsDongbuPckpaprDesignSeedManagePopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpDsDongbuPckpaprDesignSeedManagePopController")
public class MasterMpDsDongbuPckpaprDesignSeedManagePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsDongbuPckpaprDesignSeedManagePopController.class);

	@Autowired
	private MasterMpDsDongbuPckpaprDesignSeedManagePopService masterMpDsDongbuPckpaprDesignSeedManagePopService;
	@Autowired
	private CommonInfoService commonInfoService;
	
	
	/**
	 * 포장지 도안 관리(종자) 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getMasterMpDsDongbuPckpaprDesignSeedManagePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpDsDongbuPckpaprDesignSeedManagePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getMasterMpDsDongbuPckpaprDesignSeedManagePop.do 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data = masterMpDsDongbuPckpaprDesignSeedManagePopService.getList(pMap);
		Map<String, String> userRole = commonInfoService.getUserRole(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("userRole", CommonUtil.nvlMap(userRole));
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpds/masterMpDsDongbuPckpaprDesignSeedManagePop";
	}
	

	/**
	 * 저장MM
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/setBuyerDongBuJongjaOrderPackingSaveMM.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> setBuyerDongBuJongjaOrderPackingSaveMM( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("masterUpdateReg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  masterMpDsDongbuPckpaprDesignSeedManagePopService.regSaveMM(formData); 

		_response.put("msg", rtnMsg);
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
	@RequestMapping(value = "/mpds/setSysopDongBuJongjaOrderPackingSave.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> setSysopDongBuJongjaOrderPackingSave( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("setSysopDongBuJongjaOrderPackingSave MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  masterMpDsDongbuPckpaprDesignSeedManagePopService.regSave(formData); 

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
	@RequestMapping(value = "/mpds/setSysopDongBuJongjaOrderPackingSave01.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> masterUpdateReg01( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("setSysopDongBuJongjaOrderPackingSave01 MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);	
		
		String _ret =  masterMpDsDongbuPckpaprDesignSeedManagePopService.regSave01(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
			
		return  _response;
	}	
	
}
