package com.koreab2b.mro.master.mprq.controller;

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
import com.koreab2b.mro.master.mprq.service.MasterMpRqQuotationReceiptSendService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqQuotationReceiptSendController")
public class MasterMpRqQuotationReceiptSendController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationReceiptSendController.class);

	@Autowired
	private MasterMpRqQuotationReceiptSendService masterMpRqQuotationReceiptSendService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationReceiptSendList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqQuotationReceiptSendList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpRqQuotationReceiptSendService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 폼 조회
	@RequestMapping(value = "/mprq/getMasterMpRqQuoSendHd.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerChoice2PopHd(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqQuotationReceiptSendService.getListHd(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMpRqQuotationReceiptSendList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqQuotationReceiptSendService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqQuotationReceiptSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqQuotationReceiptSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqQuotationReceiptSendService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", rtnMsg);
		mp.put("usrmsg","N");
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 네고
	@RequestMapping(value = "/mprq/negoMasterMpRqQuotationReceiptSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> negoQuotationReceiptSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		Map<String, String> _result = masterMpRqQuotationReceiptSendService.negoQuotationReceiptSend(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mprq/delMasterMpRqQuotationReceiptSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqQuotationReceiptSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqQuotationReceiptSendService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", rtnMsg);
		mp.put("usrmsg","N");
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}

}
