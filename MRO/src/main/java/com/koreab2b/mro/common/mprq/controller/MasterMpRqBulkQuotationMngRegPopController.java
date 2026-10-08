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
import com.koreab2b.mro.common.mprq.service.MasterMpRqBulkQuotationMngRegPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationMngRegPopController")
public class MasterMpRqBulkQuotationMngRegPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationMngRegPopController.class);

	@Autowired
	private MasterMpRqBulkQuotationMngRegPopService MasterMpRqBulkQuotationMngRegService;
	
	// 엑셀 업로드
	@RequestMapping(value = "/mprq/batchMasterMpRqBulkQuotationMngRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMpRqBulkQuotationMngRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("요청 파라미터 : {}", gridData);
		LOGGER.debug("batchMasterMpRqBulkQuotationMngRegPop MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = MasterMpRqBulkQuotationMngRegService.batchMasterMpRqBulkQuotationMngReg(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	@RequestMapping(value = "/mprq/checkMasterMpRqBulkQuotationMngRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void checkMasterMpRqBulkQuotationMngRegPop(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, String> formData) {
		LOGGER.debug("checkMasterMpRqBulkQuotationMngRegPop 요청 파라미터 : {}", formData);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationMngRegService.checkMasterMpRqBulkQuotationMngReg(formData);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 품목 등록
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationMngRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationMngReg(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("saveMasterMpRqBulkQuotationMngRegPop param : {}", pMap);
		
		String rtnMsg = MasterMpRqBulkQuotationMngRegService.saveMasterMpRqBulkQuotationMngReg(pMap);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
}
