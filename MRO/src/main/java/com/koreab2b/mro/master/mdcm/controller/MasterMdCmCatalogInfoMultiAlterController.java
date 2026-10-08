package com.koreab2b.mro.master.mdcm.controller;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogInfoMultiAlterService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogInfoMultiAlterController")
public class MasterMdCmCatalogInfoMultiAlterController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogInfoMultiAlterController.class);

	@Autowired
	private MasterMdCmCatalogInfoMultiAlterService masterMdCmCatalogInfoMultiAlterService;
	
	
	// 카탈로그 일괄수정 (엑셀업로드)
	@RequestMapping(value = "/mdcm/batchMasterMdCmCatalogInfoMultiAlter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCatalogInfoMultiAlter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
			
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("batchMasterMdCmCatalogInfoMultiAlter MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMdCmCatalogInfoMultiAlterService.batchMasterMdCmCatalogInfoMultiAlter(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 카탈로그 일괄수정 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogInfoMultiAlter.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogInfoMultiAlter(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		LOGGER.debug("getMasterMdCmCatalogInfoMultiAlter Map 요청 파라미터 : pMap  {} ", pMap);
		List<Map<String,String>> _data = masterMdCmCatalogInfoMultiAlterService.getMasterMdCmCatalogInfoMultiAlter(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 카탈로그 일괄수정 삭제
	@RequestMapping(value = "/mdcm/delMasterMdCmCatalogInfoMultiAlter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmCatalogInfoMultiAlter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("delMasterMdCmCatalogInfoMultiAlter MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMdCmCatalogInfoMultiAlterService.delMasterMdCmCatalogInfoMultiAlter(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 카탈로그 일괄수정 반영대상 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogInfoBeforeAfter.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogInfoBeforeAfter(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
			
		LOGGER.debug("getMasterMdCmCatalogInfoBeforeAfter Map 요청 파라미터 : pMap  {} ", pMap);
		List<Map<String,String>> _data = masterMdCmCatalogInfoMultiAlterService.getMasterMdCmCatalogInfoBeforeAfter(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}	
	
	// 카탈로그 일괄 등록 품의 상신
	@RequestMapping(value = "/mdcm/requestMasterMdCmCatalogInfoSearchPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> requestMasterMdCmCatalogInfoSearchPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) { 
		
		Map<String, Object> _response = new HashMap<String, Object>();
			
			
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
		LOGGER.debug("요청 파라미터 : gridData  {} ", gridData);
		LOGGER.debug("requestMasterMdCmCatalogInfoSearchPop MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMdCmCatalogInfoMultiAlterService.requestMasterMdCmCatalogInfoSearchPop(formData, gridData);
			
		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
	
		return _response;
	}

}
