package com.koreab2b.mro.master.mpif.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpif.service.MasterMpIfCowayChargeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfCowayChargeController")
public class MasterMpIfCowayChargeController {

	@Autowired
	private MasterMpIfCowayChargeService masterMpIfCowayChargeService;
	
	// 조회
	@RequestMapping(value = "/mpif/getMasterMpIfCowayChargeList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIfCowayChargeAsList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		String yyyymm	= ((String)pMap.get("st_yyyymm")).replaceAll("/", "");
		pMap.put("YYYYMM", yyyymm);
		
		List<Map<String,String>> _data = masterMpIfCowayChargeService.getCowayChargeList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
//	// 삭제
	@RequestMapping(value = "/mpif/delMasterMpIfCowayChargeList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpIfCowayChargeAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		String rtnMsg = masterMpIfCowayChargeService.delMasterMpIfCowayChargeList(gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
//	// 저장
//	@RequestMapping(value = "/mpif/saveMasterMpIfCowayChargeAsList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> saveMasterMpIfCowayChargeAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
//		
//		String rtnMsg = masterMpIfCowayChargeService.saveMasterMpIfCowayChargeAsList(gridData);
//		
//		// 성공시 : 1 실패시 : 0
//		Map<String, Object> mp = new HashMap<String, Object>();
//		mp.put("Code",1);
//		_response.put("Result",mp);
//		_response.put("Message", rtnMsg);
//		return _response;
//	}
//	
	// 엑셀 업로드 저장
	@RequestMapping(value = "/mpif/batchMasterMpIfCowayChargeList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMpIfCowayChargeList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		String rtnMsg = masterMpIfCowayChargeService.batchMasterMpIfCowayChargeList(gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		
		if (rtnMsg.indexOf("저장되었습니다") > 0) {
			mp.put("Code",1);
		} else {
			mp.put("Code",1);
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
//	
//	// 엑셀 업로드 저장
//	@RequestMapping(value = "/mpif/sendMasterMpIfCowayChargeAsList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> sendMasterMpIfCowayChargeAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
//		
//		String rtnMsg = masterMpIfCowayChargeService.sendMasterMpIfCowayChargeAsList(gridData);
//		
//		// 성공시 : 1 실패시 : 0
//		Map<String, Object> mp = new HashMap<String, Object>();
//		mp.put("Code",1);
//		_response.put("Result",mp);
//		_response.put("Message", rtnMsg);
//		return _response;
//	}

}
