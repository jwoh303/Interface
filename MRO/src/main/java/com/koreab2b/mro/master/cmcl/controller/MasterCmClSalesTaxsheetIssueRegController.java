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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.cmcl.dao.MasterCmClSmartBillUploadingCreationDaoImpl;
import com.koreab2b.mro.master.cmcl.service.MasterCmClSalesTaxsheetIssueRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClSalesTaxsheetIssueRegController")
public class MasterCmClSalesTaxsheetIssueRegController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClSalesTaxsheetIssueRegController.class);
	@Autowired
	private MasterCmClSalesTaxsheetIssueRegService masterCmClSalesTaxsheetIssueRegService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClSalesTaxsheetIssueRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClSalesTaxsheetIssueRegList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClSalesTaxsheetIssueRegService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClSalesTaxsheetIssueRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		List<Map<String,String>> _data = masterCmClSalesTaxsheetIssueRegService.getList(pMap);
		IBSheetUtil.excelOut(req, res, CommonUtil.getListNvl(_data));
	}
		
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClSalesTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClSalesTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterCmClSalesTaxsheetIssueRegService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// SAP 전송
	@RequestMapping(value = "/cmcl/ARsendMasterCmClSalesTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> ARsendMasterCmClSalesTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxsheetIssueRegService.updateARsendData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// SAP 전송취소
	@RequestMapping(value = "/cmcl/ARreverseMasterCmClSalesTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> ARreverseMasterCmClSalesTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxsheetIssueRegService.updateARreverseData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	// 삭제
	@RequestMapping(value = "/cmcl/delMasterCmClSalesTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClSalesTaxsheetIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxsheetIssueRegService.delSelectedData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	@RequestMapping(value = "/cmcl/delMasterCmClSalesTaxsheetIssueRegList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClSalesTaxsheetIssueReg_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxsheetIssueRegService.delSelectedData_v2(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 스마트빌전송
	@RequestMapping(value = "/cmcl/SendARMasterCmClSalesTaxsheetIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> SendARMasterCmClSalesTaxsheetIssueRegList(HttpServletRequest req, HttpServletResponse pResponse,@RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterCmClSalesTaxsheetIssueRegService.SendARMasterCmClSalesTaxsheetIssueRegList(pMap, req, pResponse);
		
		_response.put("data", _data);
		return _response;

	}
	/**
	 * 전송FORMAT
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/SendARMasterCmClSalesTaxsheetIssueFormat.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> SendARMasterCmClSalesTaxsheetIssueFormat(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = CommonUtil.getDevRealLocalFlag(request);		
		LOGGER.debug(" getSslURL 0 로컬 1 개발 2 운영 : {}", flag);
		if ("2".equals(flag)){
			pMap.put("smartBillUrl", "https://api.smartbill.co.kr/sb-api/request/");
		}else{
			pMap.put("smartBillUrl", "http://demoapi.smartbill.co.kr/sb-api/request/");
		}
		List<Map<String, String>> _data = masterCmClSalesTaxsheetIssueRegService.SendARMasterCmClSalesTaxsheetIssueFormat(pMap);
		
		_response.put("data", _data);
		return _response;
	}
	// 세금계산서 발행삭제
	@RequestMapping(value = "/cmcl/delMasterCmClSalesTaxsheetIssueSbList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClSalesTaxsheetIssueSbList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxsheetIssueRegService.delSelectedSbData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
