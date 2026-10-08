package com.koreab2b.mro.master.mpif.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpif.service.MasterMpIfSecItemInfoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfSecItemInfoController")
public class MasterMpIfSecItemInfoController {

	@Autowired
	private MasterMpIfSecItemInfoService masterMpIfSecItemInfoService;
	
	// 조회
	@RequestMapping(value = "/mpif/getMasterMpIfSecItemInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIfSecItemInfoList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfSecItemInfoService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}


	// 엑셀다운로드
	@RequestMapping(value = "/mpif/excelMasterMpIfSecItemInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfSecItemInfoService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}

	// 삭제
	@RequestMapping(value = "/mpif/deleteEventMasterMpIfSecItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMpIfSecItemInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfSecItemInfoService.deleteSecItemInfo(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 수정
	@RequestMapping(value = "/mpif/updateItemMasterMpIfSecItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateItemMasterMpIfSecItemInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfSecItemInfoService.updateSecItemInfo(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 재견적
	@RequestMapping(value = "/mpif/requotationMasterMpIfSecItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> requotationMasterMpIfSecItemInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfSecItemInfoService.requotSecItemInfo(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 단가재전송
	@RequestMapping(value = "/mpif/resendPriceMasterMpIfSecItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> resendPriceMasterMpIfSecItemInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfSecItemInfoService.resendPriceSecItemInfo(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 재등록
	@RequestMapping(value = "/mpif/registItemMasterMpIfSecItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> registItemMasterMpIfSecItemInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfSecItemInfoService.registSecItemInfo(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 견적취소
	@RequestMapping(value = "/mpif/cancelQuotationMasterMpIfSecItemInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancelQuotationMasterMpIfSecItemInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfSecItemInfoService.cancelQutSecItemInfo(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
}
