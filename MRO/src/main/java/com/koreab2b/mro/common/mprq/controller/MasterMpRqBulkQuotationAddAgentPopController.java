package com.koreab2b.mro.common.mprq.controller;

import java.io.OutputStream;
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
import com.koreab2b.mro.common.mprq.service.MasterMpRqBulkQuotationAddAgentPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationAddAgentPopController")
public class MasterMpRqBulkQuotationAddAgentPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationAddAgentPopController.class);

	@Autowired
	private MasterMpRqBulkQuotationAddAgentPopService MasterMpRqBulkQuotationAddAgentService;
		
	// 품목정보 조회
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationAddAgentPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationAddAgentPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
				
		Map<String, String> _data = MasterMpRqBulkQuotationAddAgentService.getItem(pMap);
		
		pModel.addAttribute("item_data", _data);
		
		return "common/popup/mprq/masterMpRqBulkQuotationAddAgentPop";
	}
	
	// 협력사 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationAddAgentPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMpRqBulkQuotationAddAgentPop(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, String> formData) {
		LOGGER.debug("getMasterMpRqBulkQuotationAddAgentPop 요청 파라미터 : {}", formData);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationAddAgentService.getMasterMpRqBulkQuotationAddAgent(formData);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 협력사 삭제
	@RequestMapping(value = "/mprq/delMasterMpRqBulkQuotationAddAgentPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationAddAgent(HttpServletRequest req,  @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
				
		LOGGER.debug("delMasterMpRqBulkQuotationAddAgentPop param : {}", pMap);
		
		String rtnMsg = MasterMpRqBulkQuotationAddAgentService.delMasterMpRqBulkQuotationAddAgent(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
	
	// 진행현황 - 품목정보 조회
	@RequestMapping(value = "/mprq/showMasterMpRqBulkQuotationAddAgentListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpRqBulkQuotationAddAgentListPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest req) {
				
		Map<String, String> _data = MasterMpRqBulkQuotationAddAgentService.getItem(pMap);
		
		pModel.addAttribute("item_data", _data);
		
		return "common/popup/mprq/masterMpRqBulkQuotationAddAgentListPop";
	}
	
	// 진행현황
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationAddAgentListPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMpRqBulkQuotationAddAgentListPop(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, String> formData) {
		LOGGER.debug("getMasterMpRqBulkQuotationAddAgentListPop 요청 파라미터 : {}", formData);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationAddAgentService.getMasterMpRqBulkQuotationAddAgentListPop(formData);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
}
