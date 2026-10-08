package com.koreab2b.mro.common.cmcl.controller;

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

import com.koreab2b.mro.common.cmcl.service.MasterCmClCmmntPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClCmmntPopController")
public class MasterCmClCmmntPopController {

	@Autowired
	private MasterCmClCmmntPopService masterCmClCmmntPopService;
	
	/**
	 * 적요 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/getMasterCmClCmmntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClCmmntPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterCmClCmmntPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClCmmntPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClSalesTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClCmmntPopService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	/**
	 * 담당자정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/getMasterCmClStndSettingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClStndSettingPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterCmClCmmntPopService.getMasterCmClStndSettingPop(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 미매핑 세금계산서 조회 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/getMasterCmClIssueIdInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClIssueIdInfoPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClCmmntPopService.getMasterCmClIssueIdInfoPop(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 미매핑 세금계산서 조회 팝업 (상단 그리드 조회)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/getMasterCmClIssueIdInfoPop1.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClIssueIdInfoPop1(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClCmmntPopService.getMasterCmClIssueIdInfoPop1(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 담당자저장
	@RequestMapping(value = "/mdcm/saveMasterCmClStndSettingPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterCmClStndSettingPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClCmmntPopService.saveMasterCmClStndSettingPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 담당자삭제
	@RequestMapping(value = "/mdcm/delMasterCmClStndSettingPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClStndSettingPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClCmmntPopService.delMasterCmClStndSettingPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	/**
	 * 수정사유팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/getMasterCmClStndSettingModifyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClStndSettingModifyPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterCmClCmmntPopService.getMasterCmClStndSettingModifyPop(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
