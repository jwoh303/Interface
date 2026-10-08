package com.koreab2b.mro.master.mdct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdct.service.MasterMdCtReportCustomerManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtReportCustomerManageController")
public class MasterMdCtReportCustomerManageController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdCtReportCustomerManageController.class);
	
	@Autowired
	private MasterMdCtReportCustomerManageService masterMdCtReportCustomerManageService;
	
	// 고객사 프로파일 팝업 조회
	@RequestMapping(value = "/mdct/getMasterMdCtReportCustomerManageHd.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtReportCustomerManageHd(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterMdCtReportCustomerManageService.getReportList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/masterMdctReportCustomerPop";
	}
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtReportCustomerManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportCustomerManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtReportCustomerManageList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportCustomerManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 고객사 리포트 관리 등록
	@RequestMapping(value = "/mdct/saveMasterMdCtReportCustomerManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportCustomerManageList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("saveMasterMdCtReportCustomerManageList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("saveMasterMdCtReportCustomerManageList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtReportCustomerManageService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 고객사 리포트 관리 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtReportCustomerList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportCustomerList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("saveMasterMdCtReportCustomerList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("saveMasterMdCtReportCustomerList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtReportCustomerManageService.saveMasterMdCtReportCustomerList(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 고객사 리포트 관리 매핑삭제
	@RequestMapping(value = "/mdct/delMasterMdCtReportCustomerList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCtReportCustomerList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("delMasterMdCtReportCustomerList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("delMasterMdCtReportCustomerList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtReportCustomerManageService.delMasterMdCtReportCustomerList(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
