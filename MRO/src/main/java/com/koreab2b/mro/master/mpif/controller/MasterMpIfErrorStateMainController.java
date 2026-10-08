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
import com.koreab2b.mro.master.mpif.service.MasterMpIfErrorStateMainService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfErrorStateMainController")
public class MasterMpIfErrorStateMainController {

	@Autowired
	private MasterMpIfErrorStateMainService masterMpIfErrorStateMainService;
	
	// 조회
	@RequestMapping(value = "/mpif/getMasterMpIfErrorStateMainList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIfErrorStateMainList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfErrorStateMainService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpif/excelMasterMpIfErrorStateMainList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfErrorStateMainService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mpif/saveMasterMpIfErrorStateMainList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpIfErrorStateMain(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfErrorStateMainService.updateSelectedData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 납품요구일변경
	@RequestMapping(value = "/mpif/updateMasterMpIfErrorStateMain_RdDateIF.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpIfErrorStateMain_RD_DATE_IF(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfErrorStateMainService.updateSelectedDataRdDate(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		
		if("".equals(rtnMsg)){
			mp.put("Code",1);
		}
		else{
			mp.put("Code",0);
		}

		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mpif/delMasterMpIfErrorStateMainList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpIfErrorStateMain(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfErrorStateMainService.delSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	
	// 삼성전자 품의 상신 
	@RequestMapping(value = "/mpif/updateIfPoListInfoApprList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateIfPoListInfoApprList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String IFKey = masterMpIfErrorStateMainService.SelectBuyerIFkey(formData);
		
		String rtnMsg = masterMpIfErrorStateMainService.updateIfPoListInfoApprDate(formData, gridData, IFKey);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		
		if("".equals(rtnMsg)){
			mp.put("Code",1);
			_response.put("Message", IFKey);
		}
		else{
			mp.put("Code",0);
		}

		_response.put("Result",mp);
		return _response;
	}
	
}
