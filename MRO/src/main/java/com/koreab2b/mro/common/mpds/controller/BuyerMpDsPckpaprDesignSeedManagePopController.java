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
import com.koreab2b.mro.common.mpds.service.BuyerMpDsPckpaprDesignSeedManagePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsPckpaprDesignSeedManagePopController")
public class BuyerMpDsPckpaprDesignSeedManagePopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsPckpaprDesignSeedManagePopController.class);

	@Autowired
	private BuyerMpDsPckpaprDesignSeedManagePopService buyerMpDsPckpaprDesignSeedManagePopService;
	@Autowired
	private CommonInfoService commonInfoService;
	
	/**
	 * 포장지 도안 관리(종자) 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getBuyerMpDsPckpaprDesignSeedManagePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsPckpaprDesignSeedManagePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsPckpaprDesignSeedManagePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpDsPckpaprDesignSeedManagePopService.getList(pMap); 
		Map<String, String> userRole = commonInfoService.getUserRole(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("userRole", CommonUtil.nvlMap(userRole));
		pModel.addAllAttributes(pMap);
		return "common/popup/mpds/buyerMpDsPckpaprDesignSeedManagePop";
	}	 
	
	
	/**
	 * 저장
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/buyer_dongbu_jongja_order_packing_update_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_jongja_order_packing_update_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("updateRegbuyerDongbuOrderPacking MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_1(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}
	
	@RequestMapping(value = "/mpds/buyer_dongbu_order_packing_update_dd_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_order_packing_update_dd_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_order_packing_update_dd_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_2(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

	@RequestMapping(value = "/mpds/buyer_dongbu_order_packing_update_ee_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_order_packing_update_ee_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_order_packing_update_ee_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_3(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

	@RequestMapping(value = "/mpds/buyer_dongbu_jongja_order_packing_update_es_mk1_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_jongja_order_packing_update_es_mk1_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_jongja_order_packing_update_es_mk1_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_4(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

	@RequestMapping(value = "/mpds/buyer_dongbu_jongja_order_packing_update_es_pd1_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_jongja_order_packing_update_es_pd1_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_jongja_order_packing_update_es_pd1_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_5(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

	@RequestMapping(value = "/mpds/buyer_dongbu_jongja_order_packing_update_es_qa1_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_jongja_order_packing_update_es_qa1_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_jongja_order_packing_update_es_qa1_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_6(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

	@RequestMapping(value = "/mpds/buyer_dongbu_order_packing_update_es_fi_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_order_packing_update_es_fi_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_order_packing_update_es_fi_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_7(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

	@RequestMapping(value = "/mpds/buyer_dongbu_jongja_order_packing_update_es_mk_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_jongja_order_packing_update_es_mk_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_jongja_order_packing_update_es_mk_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_8(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

	@RequestMapping(value = "/mpds/buyer_dongbu_jongja_order_packing_update_es_pd_reg.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> buyer_dongbu_jongja_order_packing_update_es_pd_reg( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		logger.debug("buyer_dongbu_jongja_order_packing_update_es_pd_reg MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		Map<String, String> formData = CommonUtil.removeSlash(pMap); 	
		
		String _ret =  buyerMpDsPckpaprDesignSeedManagePopService.saveSelectedData_9(formData); 
	 
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return  _response;
	}

}
