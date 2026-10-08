package com.koreab2b.mro.master.mpif.controller;

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
import com.koreab2b.mro.master.mpif.service.MasterMpIfSamsungCatalogUploadService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfSamsungCatalogUploadController")
public class MasterMpIfSamsungCatalogUploadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIfSamsungCatalogUploadController.class);

	@Autowired
	private MasterMpIfSamsungCatalogUploadService masterMpIfSamsungCatalogUploadService;

	// 조회 - 일괄카탈로그 조회
	@RequestMapping(value = "/mpif/getMasterMpIfSamsungCatalogUploadList.do", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> getMasterMpIfSamsungCatalogUploadList(HttpServletRequest req,
			@RequestParam Map<String, Object> pMap) {

		List<Map<String, String>> _data = masterMpIfSamsungCatalogUploadService.getList(pMap);

		return IBSheetUtil.addResut(req, _data, pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpif/excelMasterMpIfSamsungCatalogUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMpSoProgressDownLoad(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		
		List<Map<String, String>> _data = masterMpIfSamsungCatalogUploadService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 저장
	@RequestMapping(value = "/mpif/saveMasterMpIfSamsungCatalogUploadList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpIfSamsungCatalogUploadList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("delMasterMdCmCatalogMultiAlter MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMpIfSamsungCatalogUploadService.saveList(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mpif/delMasterMpIfSamsungCatalogUploadList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpIfSamsungCatalogUploadList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("delMasterMdCmCatalogMultiAlter MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMpIfSamsungCatalogUploadService.delList(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 카탈로그조회 등록 일괄 (엑셀업로드)
	@RequestMapping(value = "/mpif/batchMasterMpIfSamsungCatalogUploadList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMpIfSamsungCatalogUploadList(HttpServletRequest req,
			@RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("batchMasterMdCmCatalogMultiAlter MultiValueMap 요청 파라미터 : formData  {} ", formData);
		String rtnMsg = masterMpIfSamsungCatalogUploadService.batchUploadList(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code", 1);
		_response.put("Result", mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 카탈로그 일괄 등록 품의 상신
	@RequestMapping(value = "/mpif/requestMasterMpIfSamsungCatalogUploadList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> requestMasterMpIfSamsungCatalogUploadList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) { 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData  {} ", gridData);
		LOGGER.debug("requestMasterMdCmCatalogSearchPop MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMpIfSamsungCatalogUploadService.requestMasterMpIfSamsungCatalogUploadList(formData, gridData);
		
		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
