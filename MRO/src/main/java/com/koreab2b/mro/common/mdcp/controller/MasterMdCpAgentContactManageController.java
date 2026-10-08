package com.koreab2b.mro.common.mdcp.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdcp.service.MasterMdCpAgentContactManageService;

@Controller("masterMdCpAgentContactManageController")
public class MasterMdCpAgentContactManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCpAgentContactManageController.class);

	@Autowired
	private MasterMdCpAgentContactManageService masterMdCpAgentContactManageService;

	// 협력사 연락처 관리
	@RequestMapping(value = "/mdcp/showMasterMdCpAgentContactList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpAgentContactList() {
		return "master/mdcp/masterMdCpAgentContactList";
	}
	
	// 이메일/문자 발송내역 관리
	@RequestMapping(value = "/mdcp/showMasterMdCpAgentDmHistoryList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterMdCpAegntContactHistoryList() {
		return "master/mdcp/masterMdCpAgentDmHistoryList";
	}

	// 협력사 연락처 관리 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpAegntContactList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpAegntContactList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("pMap : {}", pMap.toString());

		//페이징용 파라미터의 셋팅	
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 선택한 협력사 정보 취득
		List<Map<String,String>> _data = masterMdCpAgentContactManageService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 협력사 이메일/문자 발송내역  관리 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpAgentDmHistory.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpAgentDmHistory(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("pMap : {}", pMap.toString());

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 이메일/문자 발송내역 관리 조회
		List<Map<String,String>> _data = masterMdCpAgentContactManageService.getAgentDmHistoryList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 협력사 연락처 관리 이력 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpAegntContactHistoryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMdCpAegntContactHistoryList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		LOGGER.debug("pMap : {}", pMap.toString());
		
		// 선택한 협력사 정보 취득
		List<Map<String,String>> _data = masterMdCpAgentContactManageService.getContactHistoryiList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);
	}
	
	// 수신처 정보 취득
	@RequestMapping(value = "/mdcp/getMasterMdCpAgentDmHistoryContactList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpAgentDmHistoryContactList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("pMap : {}", pMap.toString());

		// 선택한 협력사 정보 취득
		List<Map<String,String>> _data = masterMdCpAgentContactManageService.getMasterMdCpAgentDmHistoryContactList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
}
