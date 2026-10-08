package com.koreab2b.mro.master.mdcp.controller;

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
import com.koreab2b.mro.master.mdcp.service.MasterMdCpSAgntcmpyRegManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpSAgntcmpyRegManageController")
public class MasterMdCpSAgntcmpyRegManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCpSAgntcmpyRegManageController.class);

	@Autowired
	private MasterMdCpSAgntcmpyRegManageService masterMdCpSAgntcmpyRegManageService;
	
	// 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpSAgntcmpyRegManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCpSAgntcmpyRegManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCpSAgntcmpyRegManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpSAgntcmpyRegManageSAgent.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> getMasterMdCpSAgntcmpyRegManageSAgent(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, String> _response = new HashMap<String, String>();

		LOGGER.debug("getMasterMdCpSAgntcmpyRegManageSAgent 요청 파라미터 : formData {}", pMap);
		
		_response = masterMdCpSAgntcmpyRegManageService.getSAgentList(pMap);
		return _response;
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdcp/excelMasterMdCpSAgntcmpyRegManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCpSAgntcmpyRegManageService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mdcp/saveMasterMdCpSAgntcmpyRegManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpSAgntcmpyRegManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCpSAgntcmpyRegManageService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mdcp/delMasterMdCpSAgntcmpyRegManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCpSAgntcmpyRegManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCpSAgntcmpyRegManageService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
