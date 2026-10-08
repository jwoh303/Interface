package com.koreab2b.mro.master.cmcl.controller;

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
import com.koreab2b.mro.master.cmcl.service.MasterCmClPurchaseTaxsheetIssueRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClPurchaseTaxsheetIssueRegController")
public class MasterCmClPurchaseTaxsheetIssueRegController {

	@Autowired
	private MasterCmClPurchaseTaxsheetIssueRegService masterCmClPurchaseTaxsheetIssueRegService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClPurchaseTaxsheetIssueRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClPurchaseTaxsheetIssueRegList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClPurchaseTaxsheetIssueRegService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClPurchaseTaxsheetIssueRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClPurchaseTaxsheetIssueRegService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, CommonUtil.getListNvl(_data));
	}
		
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClPurchaseTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClPurchaseTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	@RequestMapping(value = "/cmcl/saveMasterCmClPurchaseTaxsheetIssueRegList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClPurchaseTaxsheetIssueReg_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.updateSelectedData_v2(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// SAP 전송
	@RequestMapping(value = "/cmcl/APsendMasterCmClPurchaseTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> APsendMasterCmClPurchaseTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.updateAPsendData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// SAP 전송취소
	@RequestMapping(value = "/cmcl/APreverseMasterCmClPurchaseTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> APreverseMasterCmClPurchaseTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.updateAPreverseData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	// 삭제
	@RequestMapping(value = "/cmcl/delMasterCmClPurchaseTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClPurchaseTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.delSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	@RequestMapping(value = "/cmcl/delMasterCmClPurchaseTaxsheetIssueRegList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClPurchaseTaxsheetIssueReg_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.delSelectedData_v2(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 역발행요청
	@RequestMapping(value = "/cmcl/delApMasterCmClPurchaseTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delApMasterCmClPurchaseTaxsheetIssueRegList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.delApMasterCmClPurchaseTaxsheetIssueRegList(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 전송
	@RequestMapping(value = "/cmcl/sendApMasterCmClPurchaseTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendApMasterCmClPurchaseTaxsheetIssueRegList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.sendApSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	@RequestMapping(value = "/cmcl/sendApMailMasterCmClPurchaseTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendApMailMasterCmClPurchaseTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterCmClPurchaseTaxsheetIssueRegService.sendApMailSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 역발행 메일 요청
	@RequestMapping(value = "/cmcl/sendMasterCmClsendApRMail.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendMasterCmClsendApRMail(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = CommonUtil.getDevRealLocalFlag(request);		
		if ("2".equals(flag)){
			pMap.put("smartBillUrl", "https://api.smartbill.co.kr/sb-api/request/");
		}else{
			pMap.put("smartBillUrl", "http://demoapi.smartbill.co.kr/sb-api/request/");
		}
		List<Map<String, String>> _data = masterCmClPurchaseTaxsheetIssueRegService.getMasterCmClsendApRMailPop(pMap);
		
		_response.put("data", _data);
		return _response;
	}
}
