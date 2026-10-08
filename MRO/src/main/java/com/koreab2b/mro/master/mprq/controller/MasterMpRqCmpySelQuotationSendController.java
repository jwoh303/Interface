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
import com.koreab2b.mro.master.mprq.service.MasterMpRqCmpySelQuotationSendService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqCmpySelQuotationSendController")
public class MasterMpRqCmpySelQuotationSendController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqCmpySelQuotationSendController.class);

	@Autowired
	private MasterMpRqCmpySelQuotationSendService masterMpRqCmpySelQuotationSendService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqCmpySelQuotationSendList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqCmpySelQuotationSendList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpRqCmpySelQuotationSendService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 팝업
	@RequestMapping(value = "/mprq/getMasterMpRqReqUserSelPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqReqUserSelPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		
		List<Map<String,String>> _data = masterMpRqCmpySelQuotationSendService.getMasterMpRqReqUserSelPop(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMpRqCmpySelQuotationSendList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqCmpySelQuotationSendService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 견적취소
	@RequestMapping(value = "/mprq/delMasterMpRqCmpySelQuotationSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqCmpySelQuotationSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = masterMpRqCmpySelQuotationSendService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	// 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqCmpySelQuotationSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqCmpySelQuotationSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = masterMpRqCmpySelQuotationSendService.saveSelectedData(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	// 견적초기화(사용 안함-두중 버전, 아래 new 사용 2024.05.17 HSJ)
	@RequestMapping(value = "/mprq/initMasterMpRqCmpySelQuotationSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> initMasterMpRqCmpySelQuotationSendList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : {}", gridData);
		Map<String,String> _result = masterMpRqCmpySelQuotationSendService.initSelectedData(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 추가정비 요청
	@RequestMapping(value = "/mprq/updateMasterMpRqAfterItemChgReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqAfterItemChgReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqCmpySelQuotationSendService.updateAfterItemChgReqData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 추가정비 제출
	@RequestMapping(value = "/mprq/updateMasterMpRqAfterItmCheSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqAfterItmCheSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqCmpySelQuotationSendService.updateMasterMpRqAfterItmCheSend(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 견적초기화 new 버전(결재 타지 않고 바로 시행 전결규정 변경 2024.05.17 HSJ)
	@RequestMapping(value = "/mprq/initNewMasterMpRqCmpySelQuotationSendList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> initNewMasterMpRqCmpySelQuotationSendList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : {}", gridData);
		Map<String,String> _result = masterMpRqCmpySelQuotationSendService.initNewSelectedData(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
}
