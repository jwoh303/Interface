package com.koreab2b.mro.master.mpds.controller;

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
import com.koreab2b.mro.master.mpds.service.MasterMpDscropProtectService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpDscropProtectController")
public class MasterMpDscropProtectController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDscropProtectController.class);

	@Autowired
	private MasterMpDscropProtectService masterMpDscropProtectService;
	
	// 조회z
	@RequestMapping(value = "/mpds/getMasterMpDscropProtectList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpDscropProtectList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpDscropProtectService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpds/excelMasterMpDscropProtectList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpDscropProtectService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mpds/saveMasterMpDscropProtectList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpDscropProtect(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpDscropProtectService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mpds/delMasterMpDscropProtectList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpDscropProtect(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpDscropProtectService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
