package com.koreab2b.mro.master.cmcl.controller;

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
import com.koreab2b.mro.master.cmcl.service.MasterCmClPurchaseTaxsheetSimulationService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClPurchaseTaxsheetSimulationController")
public class MasterCmClPurchaseTaxsheetSimulationController {

	private static final Logger logger = LoggerFactory.getLogger(MasterCmClPurchaseTaxsheetSimulationController.class);

	@Autowired
	private MasterCmClPurchaseTaxsheetSimulationService masterCmClPurchaseTaxsheetSimulationService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClPurchaseTaxsheetSimulationList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterCmClPurchaseTaxsheetSimulationList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterCmClPurchaseTaxsheetSimulationService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClPurchaseTaxsheetSimulationList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterCmClPurchaseTaxsheetSimulationService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClPurchaseTaxsheetSimulationList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClPurchaseTaxsheetSimulation(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetSimulationService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/cmcl/delMasterCmClPurchaseTaxsheetSimulationList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClPurchaseTaxsheetSimulation(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetSimulationService.delSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
