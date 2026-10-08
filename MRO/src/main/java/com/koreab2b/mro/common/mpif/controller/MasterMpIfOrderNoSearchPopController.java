package com.koreab2b.mro.common.mpif.controller;

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
import com.koreab2b.mro.common.mpif.service.MasterMpIfOrderNoSearchPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfOrderNoSearchPopController")
public class MasterMpIfOrderNoSearchPopController {

	@Autowired
	private MasterMpIfOrderNoSearchPopService masterMpIfOrderNoSearchPopService;
	
	/**
	 * 주문번호찾기 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpif/getMasterMpIfOrderNoSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpIfOrderNoSearchPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMpIfOrderNoSearchPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mpif/saveMasterMpIfOrderNoSearchPo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpIfOrderNoSearchPo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpIfOrderNoSearchPopService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
}
