package com.koreab2b.mro.master.mpvo.controller;

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
import com.koreab2b.mro.master.mpvo.service.MasterMpVoVocProgressStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocProgressStateController")
public class MasterMpVoVocProgressStateController {

	@Autowired
	private MasterMpVoVocProgressStateService masterMpVoVocProgressStateService;
	
	// 조회
	@RequestMapping(value = "/mpvo/getMasterMpVoVocProgressStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpVoVocProgressStateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpVoVocProgressStateService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpvo/excelMasterMpVoVocProgressStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpVoVocProgressStateService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mpvo/saveMasterMpVoVocProgressStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpVoVocProgressState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpVoVocProgressStateService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mpvo/delMasterMpVoVocProgressStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpVoVocProgressState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpVoVocProgressStateService.delSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
