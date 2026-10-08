package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmAgentContactMngPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMdCmAgentContactMngPopController")
public class MasterMdCmAgentContactMngPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmAgentContactMngPopController.class);

	@Autowired
	private MasterMdCmAgentContactMngPopService masterMdcmAgentContactMngPopService;
	

	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdcmAgentContactMngPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMdcmAgentContactMngPopList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		LOGGER.debug("pMap : {}", pMap.toString());

		// 선택한 협력사 정보 취득
		List<Map<String,String>> _data = masterMdcmAgentContactMngPopService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}

	/**
	 * 협력사 연락처 설정 저장
	 * @param pReq
	 * @param pMap
	 * @return Map<String, Object>
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdcmAgentContactMngPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdcmAgentDmSendPop(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("pMap : {}", pMap.toString());
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdcmAgentContactMngPopService.saveMasterMdcmAgentContactMngPop(formData, gridData);

//		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result", mp);
		_response.put("Message", rtnMsg);
//		
		return _response;
	}
	
}
