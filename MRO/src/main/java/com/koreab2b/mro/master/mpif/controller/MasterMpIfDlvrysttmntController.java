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
import com.koreab2b.mro.master.mpif.service.MasterMpIfDlvrysttmntService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfDlvrysttmntController")
public class MasterMpIfDlvrysttmntController {

	@Autowired
	private MasterMpIfDlvrysttmntService masterMpIfDlvrysttmntService;
	
	// 조회
	@RequestMapping(value = "/mpif/getMasterMpIfDlvrysttmntList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIfDlvrysttmntList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfDlvrysttmntService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpif/excelMasterMpIfDlvrysttmntList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfDlvrysttmntService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mpif/saveMasterMpIfDlvrysttmntList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpIfDlvrysttmnt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfDlvrysttmntService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 삭제
	@RequestMapping(value = "/mpif/delMasterMpIfDlvrysttmntList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpIfDlvrysttmnt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfDlvrysttmntService.delSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
