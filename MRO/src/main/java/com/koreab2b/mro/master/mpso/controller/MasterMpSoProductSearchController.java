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
import com.koreab2b.mro.master.mpso.service.MasterMpSoProductSearchService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoProductSearchController")
public class MasterMpSoProductSearchController {

	@Autowired 
	private MasterMpSoProductSearchService masterMpSoProductSearchService;
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoProductSearchList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoProductSearchList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSoProductSearchService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoProductSearchRootTreeList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoProductSearchRootTreeList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		List<Map<String,String>> _data = masterMpSoProductSearchService.getRootTreeList(pMap);
		
		Map<String, Object> resultMap = IBSheetUtil.addResut(req, _data , pMap); 
		
		return resultMap;
	}
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoProductSearchChildTreeList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoProductSearchChildTreeList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		List<Map<String,String>> _data = masterMpSoProductSearchService.getChildTreeList(pMap);
		
		Map<String, Object> resultMap = IBSheetUtil.addResut(req, _data , pMap); 
		
		return resultMap;
	}
	
	// 장바구지 담기
	@RequestMapping(value = "/mpso/saveMasterMpSoProductSearch.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoProductSearch(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo"); 
		formData.put("st_user_id", _sessionInfo.getUserId());
		 
		String rtnMsg = masterMpSoProductSearchService.insertWmsCart(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

}
