package com.koreab2b.mro.master.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpso.service.MasterMpSoOrderExchangeRateAlterService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoOrderExchangeRateAlterController")
public class MasterMpSoOrderExchangeRateAlterController {
 

	@Autowired
	private MasterMpSoOrderExchangeRateAlterService masterMpSoOrderExchangeRateAlterService;
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoOrderExchangeRateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderExchangeRateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
	 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID",_sessionInfo.getUserId());  
		String START_ADD_DATE = pMap.get("START_ADD_DATE").toString().replaceAll("/","");
		String END_ADD_DATE = pMap.get("END_ADD_DATE").toString().replaceAll("/","");
		pMap.put("START_ADD_DATE" ,START_ADD_DATE) ;
		pMap.put("END_ADD_DATE" ,END_ADD_DATE) ;
		
		//페이징용 파라미터의 셋팅s
		pMap = IBSheetUtil.addParamForPaging3(pMap); 
		List<Map<String,String>> _data = masterMpSoOrderExchangeRateAlterService.getMasterMpSoOrderExchangeRateList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 저장
	@RequestMapping(value = "/mpso/saveMasterMpSoOrderExchangeRateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoOrderExchangeRateList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("USER_ID",_sessionInfo.getUserId());  
		String rtnMsg = masterMpSoOrderExchangeRateAlterService.saveMasterMpSoOrderExchangeRateList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mpso/delMasterMpSoOrderExchangeRateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpSoOrderExchangeRateList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("USER_ID",_sessionInfo.getUserId());  
		
		String rtnMsg = masterMpSoOrderExchangeRateAlterService.delMasterMpSoOrderExchangeRateList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
