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

import com.koreab2b.mro.common.mprq.service.MasterMpRqBulkQuotationNewProjectPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationNewProjectPopController")
public class MasterMpRqBulkQuotationNewProjectPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationNewProjectPopController.class);

	@Autowired
	private MasterMpRqBulkQuotationNewProjectPopService MasterMpRqBulkQuotationNewProjectService;

	// 신규 프로젝트 등록
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationNewProject.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationNewProject(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("saveMasterMpRqBulkQuotationNewProject param : {}", pMap);
		_response = MasterMpRqBulkQuotationNewProjectService.insertData(pMap);

		return _response;
		
	}
	//  신규 프로젝트 고객사코드 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationBuyerCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationBuyerCode(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("saveMasterMpRqBulkQuotationNewProjectNotice gridData param : {}", gridData);
		String rtnMsg = MasterMpRqBulkQuotationNewProjectService.insertBuyerData(gridData, formData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
	
	//  신규 프로젝트 유의사항 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationNewProjectNotice.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoBuyerOrderCreation(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("saveMasterMpRqBulkQuotationNewProjectNotice gridData param : {}", gridData);
		String rtnMsg = MasterMpRqBulkQuotationNewProjectService.insertNoticeData(gridData, formData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
}
