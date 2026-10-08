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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogRegReqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogRegReqController")
public class MasterMdCmCatalogRegReqController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogRegReqController.class);

	@Autowired
	private MasterMdCmCatalogRegReqService masterMdCmCatalogRegReqService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogRegReqList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCatalogRegReqList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCmCatalogRegReqService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 삭제
	@RequestMapping(value = "/mdcm/delMasterMdCmCatalogRegReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmCatalogRegReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdCmCatalogRegReq MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegReqService.delSelectedData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 신규 업로드
	@RequestMapping(value = "/mdcm/batchMasterMdCmCatalogRegReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCatalogRegReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("batchMasterMdCmCatalogRegReq MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegReqService.batchSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 기등록 업로드
	@RequestMapping(value = "/mdcm/batchMasterMdCmCatalogRegRenew.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCatalogRegRenew(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("batchMasterMdCmCatalogRegRenew MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegReqService.batchRenewSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 등록 요청
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogRegReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmCatalogRegReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCmCatalogRegReqService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
}
