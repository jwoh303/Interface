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

import com.koreab2b.mro.common.mpds.service.SellerMpDsOrderObtnodrReceiptPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpDsOrderObtnodrReceiptPopController")
public class SellerMpDsOrderObtnodrReceiptPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsOrderObtnodrReceiptPopController.class);

	@Autowired
	private SellerMpDsOrderObtnodrReceiptPopService sellerMpDsOrderObtnodrReceiptPopService;
	
	/**
	 * 발주수주접수 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getSellerMpDsOrderObtnodrReceiptPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpDsOrderObtnodrReceiptPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getSellerMpDsOrderObtnodrReceiptPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpDsOrderObtnodrReceiptPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		return "common/popup/mpds/sellerMpDsOrderObtnodrReceiptPop";
	}	 

	/**
	 * 발주 수정
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/dsDateRegSellerMpDsOrderObtnodrReceiptPop.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> dsDateRegSellerMpDsOrderObtnodrReceiptPop(ModelMap pModel, @RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("dsDateRegSellerMpDsOrderObtnodrReceiptPop MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  sellerMpDsOrderObtnodrReceiptPopService.regDsData(formData); 

		_response.put("msg", rtnMsg);
		logger.debug("_response " + _response);
			
		return  _response;
	}			
}
