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

import com.koreab2b.mro.common.mpds.service.SellerMpDsTranStatementCreationPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpDsTranStatementCreationPopController")
public class SellerMpDsTranStatementCreationPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsTranStatementCreationPopController.class);

	@Autowired
	private SellerMpDsTranStatementCreationPopService sellerMpDsTranStatementCreationPopService;
	
	/**
	 * 거래명세서생성 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getSellerMpDsTranStatementCreationPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpDsTranStatementCreationPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getSellerMpDsTranStatementCreationPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpDsTranStatementCreationPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		return "common/popup/mpds/sellerMpDsTranStatementCreationPop";
	}	 

	/**
	 * 발주 수정
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpds/invoiceSellerMpDsTranStatementCreationPop.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> invoiceSellerMpDsTranStatementCreationPop(ModelMap pModel, @RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("invoiceSellerMpDsTranStatementCreationPop MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		String rtnMsg =  sellerMpDsTranStatementCreationPopService.invoiceOrderInfo(formData); 

		_response.put("msg", rtnMsg);
		logger.debug("_response " + _response);
			
		return  _response;
	}			
}
