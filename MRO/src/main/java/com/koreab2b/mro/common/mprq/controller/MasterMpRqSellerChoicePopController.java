package com.koreab2b.mro.common.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.service.MasterMpRqSellerChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqSellerChoicePopController")
public class MasterMpRqSellerChoicePopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqSellerChoicePopController.class);

	@Autowired
	private MasterMpRqSellerChoicePopService masterMpRqSellerChoicePopService;
	
	/**
	 * 협력사선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqSellerChoicePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerChoicePop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqSellerChoicePopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 비고 조회
	@RequestMapping(value = "/mprq/getMasterMpRqSellerChoiceRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerChoiceRemarkPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqSellerChoicePopService.getListRemark(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mprq/saveAgentRoundReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveAgentRoundReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = masterMpRqSellerChoicePopService.saveAgentRoundReq(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
}
