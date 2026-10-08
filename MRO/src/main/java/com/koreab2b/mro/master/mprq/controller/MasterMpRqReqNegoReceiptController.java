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
import com.koreab2b.mro.master.mprq.service.MasterMpRqReqNegoReceiptService;
import com.koreab2b.mro.master.mprq.service.MasterMpRqReqQuotReceiptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqReqNegoReceiptController")
public class MasterMpRqReqNegoReceiptController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqReqNegoReceiptController.class);

	@Autowired
	private MasterMpRqReqNegoReceiptService masterMpRqReqNegoReceiptService;
	@Autowired
	private MasterMpRqReqQuotReceiptService masterMpRqReqQuotReceiptService;
	
	
	/*조회*/
	@RequestMapping(value = "/mprq/searchMasterMpRqReqNegoReceiptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqReqNegoReceiptList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqReqNegoReceiptService.getList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/*엑셀다운로드*/
	@RequestMapping(value = "/mprq/excelMasterMpRqReqNegoReceiptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqReqNegoReceiptService.getList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}

		
	/*저장*/
	@RequestMapping(value = "/mprq/updateMasterMpRqReqNegoReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqReqNegoReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqNegoReceiptService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}

	/*고객사 Nego견적제출*/
	@RequestMapping(value = "/mprq/negoMasterMpRqReqNegoReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> orderMasterMpRqReqNegoReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpRqReqNegoReceiptService.negoSelectedData(formData, gridData);

		_response.put("Message",rtnMsg);
		
		return _response;
	}

	/*삭제*/
	@RequestMapping(value = "/mprq/delMasterMpRqReqNegoReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqReqNegoReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqQuotReceiptService.delSelectedData(formData, gridData);

		_response.put("Message",rtnMsg);
		
		return _response;
	}
	
	// 네고정비 요청
	@RequestMapping(value = "/mprq/updateMasterMpRqNegoItemChgReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqNegoItemChgReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqNegoReceiptService.updateNegoItemChgReqData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 네고정비 제출
	@RequestMapping(value = "/mprq/updateMasterMpRqNegoItmCheSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqNegoItmCheSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqReqNegoReceiptService.updateMasterMpRqNegoItmCheSend(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
