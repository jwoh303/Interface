package com.koreab2b.mro.master.mdcm.controller;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogRecharterService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogRecharterController")
public class MasterMdCmCatalogRecharterController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogRecharterController.class);

	@Autowired
	private MasterMdCmCatalogRecharterService masterMdCmCatalogRecharterService;

	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogRecharterList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogRecharterList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getSellerMpClCatalogRecharterList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogRecharterService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 재계약 저장
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogRecharter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCatalogRecharter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogRecharterService.saveMasterMdCmCatalogRecharter(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 재계약 취소
	@RequestMapping(value = "/mdcm/cancleMasterMdCmCatalogRecharter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMasterMdCmCatalogRecharter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogRecharterService.cancleMasterMdCmCatalogRecharter(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 재계약 재요청
	@RequestMapping(value = "/mdcm/reqMasterMdCmCatalogRecharter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reqMasterMdCmCatalogRecharter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogRecharterService.reqMasterMdCmCatalogRecharter(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 재계약 단가반영 요청
	@RequestMapping(value = "/mdcm/approvalMasterMdCmCatalogRecharter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> approvalMasterMdCmCatalogRecharterList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogRecharterService.approvalMasterMdCmCatalogRecharter(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmCatalogRecharter.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCmCatalogRecharter(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogRecharterService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
}
