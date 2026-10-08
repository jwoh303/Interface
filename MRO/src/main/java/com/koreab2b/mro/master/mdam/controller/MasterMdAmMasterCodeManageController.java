package com.koreab2b.mro.master.mdam.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdam.service.MasterMdAmMasterCodeManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmMasterCodeManageController")
public class MasterMdAmMasterCodeManageController {

	@Autowired
	private MasterMdAmMasterCodeManageService masterMdAmMasterCodeManageService;
	
	// 코드 조회
	@RequestMapping(value = "/mdam/getMasterMdAmMasterCodeManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmMasterCodeManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
			pMap.put("SESSION_BUDGET_FLAG", _sessionInfo.getBudgetFlag());
		}
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = new ArrayList<Map<String,String>>();
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			_data = masterMdAmMasterCodeManageService.getList_v2(pMap);
		}else{
			_data = masterMdAmMasterCodeManageService.getList(pMap);
		}
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 코드 엑셀다운로드
	@RequestMapping(value = "/mdam/excelMasterMdAmMasterCodeManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdAmMasterCodeManageService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 코드 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmMasterCodeManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmMasterCodeManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdAmMasterCodeManageService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	// 코드 삭제
	@RequestMapping(value = "/mdam/delMasterMdAmMasterCodeManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdAmMasterCodeManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdAmMasterCodeManageService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
