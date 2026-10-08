package com.koreab2b.mro.common.mprq.controller;

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
import com.koreab2b.mro.common.mprq.service.MasterMpRqSellerChoice3PopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqSellerChoice3PopController")
public class MasterMpRqSellerChoice3PopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqSellerChoice3PopController.class);

	@Autowired
	private MasterMpRqSellerChoice3PopService masterMpRqSellerChoice3PopService;
	
	/**
	 * 협력사선정  3 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqSellerChoice3Pop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerChoice3Pop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqSellerChoice3PopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 폼 조회
	@RequestMapping(value = "/mprq/getMasterMpRqSellerChoice3PopHd.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerChoice3PopHd(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqSellerChoice3PopService.getListHd(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqSellerChoice3PopCode.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerChoice3PopCode(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqSellerChoice3PopService.getListCode(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 운영특이사항 조회
	@RequestMapping(value = "/mprq/getMasterMpRqSellerChoice3PopReNote.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqSellerChoice3PopReNote(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterMpRqSellerChoice3PopService.getListReNote(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	//첨부파일 수정
	@RequestMapping(value = "/mprq/updateFileUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateFileUpload(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : {}", pMap);
		String rtnMsg = masterMpRqSellerChoice3PopService.updateFileUpload(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	//견적마감
	@RequestMapping(value = "/mprq/saveMasterMpRqClose.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqClose(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : {}", pMap);
		String rtnMsg = masterMpRqSellerChoice3PopService.saveMasterMpRqClose(pMap);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	// 폼 조회
	@RequestMapping(value = "/mprq/getBuyerRate.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerRate(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqSellerChoice3PopService.getBuyerRate(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	// 마진율계산
	@RequestMapping(value = "/mprq/getBuyerSum.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerSum(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqSellerChoice3PopService.getBuyerSum(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	// 매익율계산(매출기준)
	@RequestMapping(value = "/mprq/getBuyerSumB.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerSumB(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqSellerChoice3PopService.getBuyerSumB(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	// 폼 조회
	@RequestMapping(value = "/mprq/getProcessImportRate.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getProcessImportRate(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqSellerChoice3PopService.getProcessImportRate(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	// 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqAgentSel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqAgentSel(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		LOGGER.debug("요청 파라미터 : {}", gridData);
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpRqSellerChoice3PopService.saveMasterMpRqAgentSel(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 시장가 확인
	@RequestMapping(value = "/mprq/saveMasterMpRqMarketUnitPriceYn.do", method = RequestMethod.POST)
	@ResponseBody
	public void saveMasterMpRqMarketPrice(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("요청 파라미터 : {}", formData);
			
		masterMpRqSellerChoice3PopService.saveMasterMpRqMarketUnitPriceYn(formData);

	}
	
}
