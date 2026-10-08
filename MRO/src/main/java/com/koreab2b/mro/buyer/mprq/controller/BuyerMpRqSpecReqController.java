package com.koreab2b.mro.buyer.mprq.controller;

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

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqSpecReqService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("BuyerMpRqSpecReqController")
public class BuyerMpRqSpecReqController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqSpecReqController.class);

	@Autowired
	private BuyerMpRqSpecReqService BuyerMpRqSpecReqService;
	
	

	
	/**
	 * 규격의뢰
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mprq/saveBuyerMpRqSpecReq.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> saveBuyerMpRqSpecReq( 
			ModelMap pModel,  
			@RequestParam MultiValueMap<String, String> pMap,
			 HttpServletRequest request) { 
		 
		LOGGER.debug("saveBuyerMpRqSpecReq MultiValueMap 요청 파라미터 : {}", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap); 			
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("userId", _sessionInfo.getUserId()); // 사용자ID 
		formData.put("comCode", _sessionInfo.getComCode()); // 사용자ID 
		
		String _ret =  BuyerMpRqSpecReqService.saveData(gridData,formData); 
	 
		_response.put("msg", _ret);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}



}
