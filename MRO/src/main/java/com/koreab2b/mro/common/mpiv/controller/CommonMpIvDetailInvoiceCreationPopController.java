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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDetailInvoiceCreationPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvDetailInvoiceCreationPopController")
public class CommonMpIvDetailInvoiceCreationPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDetailInvoiceCreationPopController.class);

	@Autowired
	private CommonMpIvDetailInvoiceCreationPopService commonMpIvDetailInvoiceCreationPopService;
	
	/**
	 * 상세조회 및 송장생성 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvDetailInvoiceCreationPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvDetailInvoiceCreationPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvDetailInvoiceCreationPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = commonMpIvDetailInvoiceCreationPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/commonMpIvDetailInvoiceCreationPop";
	}
	
	/**
	 * 송장등록
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveCommonMpIvDetailInvoiceCreationPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> saveCommonMpIvDetailInvoiceCreationPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, String> _response = new HashMap<String, String>();
		
		_response = commonMpIvDetailInvoiceCreationPopService.saveCommonMpIvDetailInvoiceCreationPop(pMap);
		
		return  _response;
		
	}
	
}
