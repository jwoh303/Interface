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
import com.koreab2b.mro.common.mprq.service.MasterMpRqBuyerQuotationReceiptSendCntPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqBuyerQuotationReceiptSendCntPopController")
public class MasterMpRqBuyerQuotationReceiptSendCntPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBuyerQuotationReceiptSendCntPopController.class);

	@Autowired
	private MasterMpRqBuyerQuotationReceiptSendCntPopService masterMpRqBuyerQuotationReceiptSendCntPopService;
	
	/**
	 * 고객사견적접수및제출건수 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerQuotationReceiptSendCntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBuyerQuotationReceiptSendCntPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqBuyerQuotationReceiptSendCntPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 품목정비 이력 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerQuotationItemMdreqHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBuyerQuotationItemMdreqHistPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqBuyerQuotationReceiptSendCntPopService.getQuotationItemMdreqHistList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 추가정비 이력 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerQuotationAfterItemMdreqHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBuyerQuotationAfterItemMdreqHistPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqBuyerQuotationReceiptSendCntPopService.getQuotationAfterItemMdreqHistList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 견적 특이사항 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationRemarkPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqBuyerQuotationReceiptSendCntPopService.getMasterMpRqQuotationRemarkList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 견적 특이사항 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/saveMasterMpRqQuotationRemarkPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqQuotationRemarkPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("saveMasterMpRqQuotationRemarkPop 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("saveMasterMpRqQuotationRemarkPop 요청 파라미터 : formData {}", formData);
		String rtnMsg = masterMpRqBuyerQuotationReceiptSendCntPopService.saveMasterMpRqQuotationRemarkPop(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	/**
	 * 견적 특이사항 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/delMasterMpRqQuotationRemarkPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMpRqQuotationRemarkPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("delMasterMpRqQuotationRemarkPop 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("delMasterMpRqQuotationRemarkPop 요청 파라미터 : formData {}", formData);
		String rtnMsg = masterMpRqBuyerQuotationReceiptSendCntPopService.delMasterMpRqQuotationRemarkPop(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	/**
	 * 네고정비 이력 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerQuotationNegoItemMdreqHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBuyerQuotationNegoItemMdreqHistPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqBuyerQuotationReceiptSendCntPopService.getQuotationNegoItemMdreqHistList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * SG지정 이력 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerQuotationSgDHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBuyerQuotationSgDHistPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqBuyerQuotationReceiptSendCntPopService.getQuotationSgDHistList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
