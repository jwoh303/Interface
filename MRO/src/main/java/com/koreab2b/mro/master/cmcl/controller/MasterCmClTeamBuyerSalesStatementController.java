package com.koreab2b.mro.master.cmcl.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.cmcl.service.MasterCmClTeamBuyerSalesStatementService;

@Controller("masterCmClTeamBuyerSalesStatementController")
public class MasterCmClTeamBuyerSalesStatementController {

	@Autowired
	private MasterCmClTeamBuyerSalesStatementService masterCmClTeamBuyerSalesStatementService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClTeamBuyerSalesStatementList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClTeamBuyerSalesStatementList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClTeamBuyerSalesStatementService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClTeamBuyerSalesStatementList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClTeamBuyerSalesStatementService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
//	@RequestMapping(value = "/cmcl/saveMasterCmClTeamBuyerSalesStatementList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> updateMasterCmClTeamBuyerSalesStatement(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
//		// formData
//		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
//		
//		String rtnMsg = masterCmClTeamBuyerSalesStatementService.updateSelectedData(formData, gridData);
//
//		_response.put("Message", rtnMsg);
//		
//		return _response;
//	}

	// 삭제
//	@RequestMapping(value = "/cmcl/delMasterCmClTeamBuyerSalesStatementList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> delMasterCmClTeamBuyerSalesStatement(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
//		// formData
//		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
//		
//		String rtnMsg = masterCmClTeamBuyerSalesStatementService.delSelectedData(formData, gridData);
//		_response.put("Message", rtnMsg);
//		
//		return _response;
//	}

}
