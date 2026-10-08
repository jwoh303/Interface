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
import com.koreab2b.mro.common.mprq.service.MasterMpRqBulkQuotationSelAgentPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationSelAgentPopController")
public class MasterMpRqBulkQuotationSelAgentPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationSelAgentPopController.class);

	@Autowired
	private MasterMpRqBulkQuotationSelAgentPopService MasterMpRqBulkQuotationSelAgentService;

	// 협력사 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationSelAgentPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMpRqBulkQuotationSelAgentPop(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, String> formData) {
		LOGGER.debug("getMasterMpRqBulkQuotationSelAgentPop 요청 파라미터 : {}", formData);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationSelAgentService.getMasterMpRqBulkQuotationSelAgent(formData);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 우선 협력사 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationSelAgentPop2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMpRqBulkQuotationSelAgentPop2(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, String> formData) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("getMasterMpRqBulkQuotationSelAgentPop2 요청 파라미터 : {}", formData);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationSelAgentService.getMasterMpRqBulkQuotationSelAgent2(formData);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 우선 협력사 추가
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationSelAgentPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationSelAgentPop(HttpServletRequest req,  @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("saveMasterMpRqBulkQuotationSelAgentPop param : {}", pMap);
		
		String rtnMsg = MasterMpRqBulkQuotationSelAgentService.saveMasterMpRqBulkQuotationSelAgent(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
	
	// 우선 협력사 삭제
	@RequestMapping(value = "/mprq/delMasterMpRqBulkQuotationSelAgentPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqBulkQuotationSelAgentPop(HttpServletRequest req,  @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("delMasterMpRqBulkQuotationSelAgentPop param : {}", pMap);
		
		String rtnMsg = MasterMpRqBulkQuotationSelAgentService.delMasterMpRqBulkQuotationSelAgent(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
	
	// 견적에 선택 협력사 추가
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationSelAgentPopRFQ.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationSelAgentPopRFQ(HttpServletRequest req,  @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("saveMasterMpRqBulkQuotationSelAgentPopRFQ param : {}", pMap);
		
		String rtnMsg = MasterMpRqBulkQuotationSelAgentService.saveMasterMpRqBulkQuotationSelAgentPopRFQ(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
}
