package com.koreab2b.mro.master.mpso.controller;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpso.service.MasterMpSoOrderInfoAlterService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoOrderInfoAlterController")
public class MasterMpSoOrderInfoAlterController {
 

	@Autowired
	private MasterMpSoOrderInfoAlterService masterMpSoOrderInfoAlterService;
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoOrderInfoAlterList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
 
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpso/excelMasterMpSoOrderInfoAlterList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mpso/saveMasterMpSoOrderInfoAlterList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoOrderInfoAlter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoOrderInfoAlterService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mpso/delMasterMpSoOrderInfoAlterList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpSoOrderInfoAlter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoOrderInfoAlterService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterMultiList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoAlterMultiList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
	 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID",_sessionInfo.getUserId());  
		
		String START_ADD_DATE = pMap.get("START_ADD_DATE").toString().replaceAll("/","");
		String END_ADD_DATE = pMap.get("END_ADD_DATE").toString().replaceAll("/","");
		pMap.put("START_ADD_DATE" ,START_ADD_DATE) ;
		pMap.put("END_ADD_DATE" ,END_ADD_DATE) ;
		
		//페이징용 파라미터의 셋팅s
		pMap = IBSheetUtil.addParamForPaging3(pMap); 
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterService.getMasterMpSoOrderInfoAlterMultiList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoAlterMultiList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoAlterMultiList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
	 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID",_sessionInfo.getUserId());  
		
		String START_ADD_DATE = pMap.get("START_ADD_DATE").toString().replaceAll("/","");
		String END_ADD_DATE = pMap.get("END_ADD_DATE").toString().replaceAll("/","");
		pMap.put("START_ADD_DATE" ,START_ADD_DATE) ;
		pMap.put("END_ADD_DATE" ,END_ADD_DATE) ;
		
		//페이징용 파라미터의 셋팅s
		pMap = IBSheetUtil.addParamForPaging3(pMap); 
		List<Map<String,String>> _data = masterMpSoOrderInfoAlterService.getMasterMpSoOrderInfoAlterMultiList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 저장
	@RequestMapping(value = "/mpso/saveMasterMpSoOrderInfoAlterMultiList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoOrderInfoAlterMultiList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("USER_ID",_sessionInfo.getUserId());  
		String rtnMsg = masterMpSoOrderInfoAlterService.saveMasterMpSoOrderInfoAlterMultiList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mpso/delMasterMpSoOrderInfoAlterMultList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpSoOrderInfoAlterMultList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("USER_ID",_sessionInfo.getUserId());  
		
		String rtnMsg = masterMpSoOrderInfoAlterService.delMasterMpSoOrderInfoAlterMultList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	
	
	
	
	
	
	
	
	

}
