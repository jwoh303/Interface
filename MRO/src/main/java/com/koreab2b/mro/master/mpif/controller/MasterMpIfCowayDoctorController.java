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
import com.koreab2b.mro.master.mpif.service.MasterMpIfCowayDoctorService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfCowayDoctorController")
public class MasterMpIfCowayDoctorController {

	@Autowired
	private MasterMpIfCowayDoctorService masterMpIfCowayDoctorService;
	
	// 조회
	@RequestMapping(value = "/mpif/getMasterMpIfCowayDoctorAsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIfCowayDoctorAsList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		String delda	= ((String)pMap.get("st_delda")).replaceAll("/", "");
		pMap.put("DELDA", delda);
		
		List<Map<String,String>> _data = masterMpIfCowayDoctorService.getDoctorAsList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 삭제
	@RequestMapping(value = "/mpif/delMasterMpIfCowayDoctorAsList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpIfCowayDoctorAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		String rtnMsg = masterMpIfCowayDoctorService.delMasterMpIfCowayDoctorAsList(gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mpif/saveMasterMpIfCowayDoctorAsList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpIfCowayDoctorAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		String rtnMsg = masterMpIfCowayDoctorService.saveMasterMpIfCowayDoctorAsList(gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 엑셀 업로드 저장
	@RequestMapping(value = "/mpif/batchMasterMpIfCowayDoctorAsList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMpIfCowayDoctorAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		String rtnMsg = masterMpIfCowayDoctorService.batchMasterMpIfCowayDoctorAsList(gridData);
		
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
	
	// 엑셀 업로드 저장
	@RequestMapping(value = "/mpif/sendMasterMpIfCowayDoctorAsList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendMasterMpIfCowayDoctorAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		String rtnMsg = masterMpIfCowayDoctorService.sendMasterMpIfCowayDoctorAsList(gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
