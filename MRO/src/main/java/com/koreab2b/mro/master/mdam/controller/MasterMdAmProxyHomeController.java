package com.koreab2b.mro.master.mdam.controller;

import java.util.HashMap;
import java.util.List;
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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdam.service.MasterMdAmProxyHomeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmProxyHomeController")
public class MasterMdAmProxyHomeController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmProxyHomeController.class);

	@Autowired
	private MasterMdAmProxyHomeService masterMdAmProxyHomeService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmProxyHome.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterMdAmProxyHomeList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("/mdam/getMasterMdAmProxyHome.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());
		
		pMap.put("com_code", _sessionInfo.getComCode());
		pMap.put("user_id", _sessionInfo.getUserId()); // 사용자ID
		
		String _authGbn = CommonUtil.nvl(masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessAuthGbn(pMap),"MB");
		
		pMap.put("auth_gbn", _authGbn);

		// 구매대행 홈 담당자별 실적현황 조회
		List<Map<String, String>> _data = masterMdAmProxyHomeService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("authGbn", _authGbn);
		pModel.addAllAttributes(pMap);
		
		return "master/mdam/masterMdAmProxyHomeList";
	}
	
	// 주요처리업무 조회
	@RequestMapping(value = "/mdam/getMasterMdAmProxyMainWorkProcess.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmProxyMainWorkProcessList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("/mpiv/delSellerMpIvTranStatementAlterPrintPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String _authGbn = CommonUtil.nvl(masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessAuthGbn(pMap),"MB");
		
		pMap.put("auth_gbn", _authGbn);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String st_user_type = _sessionInfo.getUserType();
		if(st_user_type.equals("SS")||st_user_type.equals("SM")||st_user_type.equals("DSM")){ //소싱지원, SM, DSM
			pMap.put("auth_gbn", st_user_type);
			List<Map<String, String>> _mainWorkProcessList = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessList(pMap);
			_response.put("mainWorkProcessList", _mainWorkProcessList);
			_response.put("authGbn", st_user_type);
		}else if(st_user_type.equals("ST")||st_user_type.equals("SOF")){ //소싱팀장, 구매본부실장
			pMap.put("auth_gbn", "SS");
			List<Map<String, String>> _mainWorkProcessSSList = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessList(pMap);
			pMap.put("auth_gbn", "SM");
			List<Map<String, String>> _mainWorkProcessSMList = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessList(pMap);
			pMap.put("auth_gbn", "DSM");
			List<Map<String, String>> _mainWorkProcessDSMList = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessList(pMap);
			_response.put("mainWorkProcessSSList", _mainWorkProcessSSList);
			_response.put("mainWorkProcessSMList", _mainWorkProcessSMList);
			_response.put("mainWorkProcessDSMList", _mainWorkProcessDSMList);
			_response.put("authGbn", st_user_type);			
		}else {
			// 주요업무처리 리스트
			List<Map<String, String>> _mainWorkProcessList = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessList(pMap);
			
			_response.put("mainWorkProcessList", _mainWorkProcessList);			
			if(_authGbn.equals("TL")) {
				// 담당자별 처리현황
				List<Map<String, String>> _workProcessListByUser = masterMdAmProxyHomeService.getWorkProcessListByUser(pMap);
				
				_response.put("workProcessListByUser", _workProcessListByUser);
				
			} else if(_authGbn.equals("MB")) {
				// 주요업무처리 합계
				Map<String, String> _mainWorkProcessSum = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessSumList(pMap);

				// 긴급납기/선입고 리스트
				List<Map<String, String>> _docTypeFPoList = masterMdAmProxyHomeService.getMasterMdAmProxyDocTypeFPoList(pMap);
				
				_response.put("mainWorkProcessSum", _mainWorkProcessSum);
				_response.put("docTypeFPoList", _docTypeFPoList);
			}
			_response.put("authGbn", _authGbn);
		}
		
		
		return _response;
	}
	
	// 고객사별 의뢰 재집계
	@RequestMapping(value = "/mdam/getMasterMdAmProxyBuyerRecount.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> execMasterMdAmProxyBuyerRecount(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("/mpiv/getMasterMdAmProxyBuyerRecount.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// 고객사별 의뢰 재집계 프로시저 실행 (PROC_KEP_PM_PA_DB('KRSCHA0001', 'SYSTEM');)
		String _ret =  masterMdAmProxyHomeService.getMasterMdAmProxyBuyerRecount(pMap);
		
		// 해당고객사 데이터 조회
		List<Map<String, String>> _mainWorkProcessList = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessList(pMap);
		
		// 주요업무처리 합계
		Map<String, String> _mainWorkProcessSum = masterMdAmProxyHomeService.getMasterMdAmProxyMainWorkProcessSumList(pMap);
		
		_response.put("mainWorkProcessList", _mainWorkProcessList);
		_response.put("mainWorkProcessSum", _mainWorkProcessSum);
		_response.put("msg", _ret);
		
		return _response;
	}
}	
