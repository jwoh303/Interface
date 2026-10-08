package com.koreab2b.mro.master.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.koreab2b.mro.master.mprq.service.MasterMpRqItemReqRcptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqItemReqRcptController")
public class MasterMpRqItemReqRcptController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqItemReqRcptController.class);

	@Autowired
	private MasterMpRqItemReqRcptService masterMpRqItemReqRcptService;
	
	@RequestMapping(value = "/mprq/masterMpRqItemReqRcpt.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> masterMpRqItemReqRcpt(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMpRqItemReqRcptService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);

	}
	
	
	/*삭제*/
	@RequestMapping(value = "/mprq/delMasterMpRqItemReqRcpt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqItemReqRcpt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		LOGGER.debug("delMasterMpRqItemReqRcpt MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMpRqItemReqRcptService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	@RequestMapping(value = "/mprq/masterMpRqItemReqRcptBoard.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> masterMpRqItemReqRcptBoard(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMpRqItemReqRcptService.getListBoard(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);

	}
	
	
	/*삭제*/
	@RequestMapping(value = "/mprq/delMasterMpRqItemReqRcptBoard.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqItemReqRcptBoard(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		LOGGER.debug("delMasterMpRqItemReqRcpt MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMpRqItemReqRcptService.updateSelectedDataBoard(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
