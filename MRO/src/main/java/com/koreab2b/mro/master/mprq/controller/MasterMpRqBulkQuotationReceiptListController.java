package com.koreab2b.mro.master.mprq.controller;

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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqBulkQuotationReceiptListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationReceiptListController")
public class MasterMpRqBulkQuotationReceiptListController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationReceiptListController.class);

	@Autowired
	private MasterMpRqBulkQuotationReceiptListService MasterMpRqBulkQuotationService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationReceiptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBulkQuotationReceiptList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("getMasterMpRqBulkQuotationReceiptList 요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationService.getList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMpRqBulkQuotationReceiptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.removeSlash(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("excelMasterMpRqBulkQuotationReceiptList 요청 파라미터 : {}", pMap);
		
		List<Map<String, String>> _data = MasterMpRqBulkQuotationService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 임시저장
	@RequestMapping(value = "/mprq/saveMasterMpRqBulkQuotationReceiptListTemp.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBulkQuotationReceiptTempList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		 
		String rtnMsg = MasterMpRqBulkQuotationService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 견적 마감
	@RequestMapping(value = "/mprq/finishMasterMpRqBulkQuotationReceiptList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> finishMasterMpRqBulkQuotationReceiptList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("finishMasterMpRqBulkQuotationReceiptList 요청 파라미터 : {}", pMap);
				 
		String rtnMsg = MasterMpRqBulkQuotationService.updateData(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
		
	}
	
	// 견적 마감취소
	@RequestMapping(value = "/mprq/cancleMasterMpRqBulkQuotationReceiptList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMasterMpRqBulkQuotationReceiptList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		
		LOGGER.debug("cancleMasterMpRqBulkQuotationReceiptList 요청 파라미터 : {}", pMap);
				 
		String rtnMsg = MasterMpRqBulkQuotationService.updateData2(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
		
	}
	
	// 견적요청
	@RequestMapping(value = "/mprq/orderMasterMpRqBulkQuotationReceiptList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> orderMasterMpRqBulkQuotationReceiptList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		 
		String rtnMsg = MasterMpRqBulkQuotationService.orderData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 견적 마감일 변경
	@RequestMapping(value = "/mprq/updateMasterMpRqBulkQuotationReceiptListEndDate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqBulkQuotationReceiptListEndDate(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		 
		String rtnMsg = MasterMpRqBulkQuotationService.updateDateData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
}
