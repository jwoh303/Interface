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
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.cmcl.service.MasterCmClSalesTaxsheetLogisIssueRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClSalesTaxsheetLogisIssueRegController")
public class MasterCmClSalesTaxsheetLogisIssueRegController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetLogisIssueRegController.class);
	@Autowired
	private MasterCmClSalesTaxsheetLogisIssueRegService masterCmClSalesTaxsheetLogisIssueRegService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClSalesTaxsheetLogisIssueRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClSalesTaxsheetLogisIssueRegList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClSalesTaxsheetLogisIssueRegService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClSalesTaxsheetLogisIssueRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterCmClSalesTaxsheetLogisIssueRegService.getList(pMap);
		IBSheetUtil.excelOut(req, res, CommonUtil.getListNvl(_data));
	}
		
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClSalesTaxsheetLogisIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClSalesTaxsheetLogisIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterCmClSalesTaxsheetLogisIssueRegService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	

	// 삭제
	@RequestMapping(value = "/cmcl/delMasterCmClSalesTaxsheetLogisIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClSalesTaxsheetLogisIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxsheetLogisIssueRegService.delSelectedData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	@RequestMapping(value = "/cmcl/delMasterCmClSalesTaxsheetLogisIssueRegList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClSalesTaxsheetLogisIssueReg_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxsheetLogisIssueRegService.delSelectedData_v2(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
}
