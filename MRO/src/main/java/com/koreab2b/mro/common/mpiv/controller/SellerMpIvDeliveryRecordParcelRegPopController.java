package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.SellerMpIvDeliveryRecordParcelRegPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryRecordParcelRegPopController")
public class SellerMpIvDeliveryRecordParcelRegPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpIvDeliveryRecordParcelRegPopController.class);

	@Autowired
	private SellerMpIvDeliveryRecordParcelRegPopService sellerMpIvDeliveryRecordParcelRegPopService;
	
	/**
	 * 송장 등록 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/showSellerMpIvDeliveryRecordParcelRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showSellerMpIvDeliveryRecordParcelRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mpiv/showSellerMpIvDeliveryRecordParcelRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		pModel.addAttribute("_data", CommonUtil.getMapNvl(pMap)); 
		
		return "common/popup/mpiv/sellerMpIvDeliveryRecordParcelRegPop";
	}	 
	
	/**
	 * 송장 등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryRecordParcelRegPop.do", method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpIvDeliveryRecordParcelRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mpiv/saveSellerMpIvDeliveryRecordParcelRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String _data = sellerMpIvDeliveryRecordParcelRegPopService.setParcel(pMap);
		
		_response.put("data", CommonUtil.nvl(_data)); 
		
		return  _response;
	}	 
	
	/**
	 * 송장 등록 후 재조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRecordParcelRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliveryRecordParcelRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mpiv/getSellerMpIvDeliveryRecordParcelRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		List<Map<String,String>> _data = sellerMpIvDeliveryRecordParcelRegPopService.getNewParcel(pMap);
		
		_response.put("data", CommonUtil.nvlMap(_data.get(0))); 
		
		return  _response;
	}	
}
