package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mpiv.service.SellerMpIvPrewarhsngOrderRegPopService;

@Controller("sellerMpIvPrewarhsngOrderRegPopController")
public class SellerMpIvPrewarhsngOrderRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvPrewarhsngOrderRegPopController.class);

	@Autowired
	private SellerMpIvPrewarhsngOrderRegPopService sellerMpIvPrewarhsngOrderRegPopService;
	
	/**
	 * 선입고 요청 등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvPrewarhsngOrderRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpIvPrewarhsngOrderRegPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvPrewarhsngOrderRegPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String st_b_req_date = pMap.get("st_b_req_date").replace("/", "");
		pMap.put("st_b_req_date", st_b_req_date);
		
		String flag = sellerMpIvPrewarhsngOrderRegPopService.saveSellerMpIvPrewarhsngOrderReg(pMap);
		
		_response.put("msg", flag);
		return _response;
	}
}
