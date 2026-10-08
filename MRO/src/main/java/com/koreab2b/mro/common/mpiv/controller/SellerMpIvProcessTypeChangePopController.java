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

import com.koreab2b.mro.common.mpiv.service.SellerMpIvProcessTypeChangePopService;

@Controller("sellerMpIvProcessTypeChangePopController")
public class SellerMpIvProcessTypeChangePopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvProcessTypeChangePopController.class);

	@Autowired
	private SellerMpIvProcessTypeChangePopService sellerMpIvProcessTypeChangePopService;
	
	/**
	 * 거래유형 변경 요청
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveSellerMpIvProcessTypeChangeReqPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveSellerMpIvProcessTypeChangeReqPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvProcessTypeChangeReqPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvProcessTypeChangePopService.saveSellerMpIvProcessTypeChangeReq(pMap);
		
		_response.put("msg", flag);
		return _response;
	}
}
