package com.koreab2b.mro.master.cmcl.controller;

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
import com.koreab2b.mro.master.cmcl.service.MasterCmClSalesReceiverUploadService;
import com.koreab2b.mro.master.mdcm.controller.MasterMdCmCatalogAlterController;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClSalesReceiverUploadController")
public class MasterCmClSalesReceiverUploadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesReceiverUploadController.class);
	
	@Autowired
	private MasterCmClSalesReceiverUploadService masterCmClSalesReceiverUploadService;
	
	// 조회 - 일괄카탈로그 조회
	@RequestMapping(value = "/cmcl/getMasterCmClSalesReceiverUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClSalesReceiverUploadList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		List<Map<String,String>> _data = masterCmClSalesReceiverUploadService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀업로드
	@RequestMapping(value = "/cmcl/batchMasterCmClSalesReceiverUpload.do", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> batchMasterCmClSalesReceiverUpload(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("batchMasterCmClSalesReceiverUpload MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterCmClSalesReceiverUploadService.batchMasterCmClSalesReceiverUpload(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 일괄 수정
	@RequestMapping(value = "/cmcl/saveMasterCmClSalesReceiverUpload.do", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> saveMasterCmClSalesReceiverUpload(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("saveMasterCmClSalesReceiverUpload MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterCmClSalesReceiverUploadService.saveMasterCmClSalesReceiverUpload(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
