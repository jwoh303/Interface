package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.MasterMpIvQuotationSendService;
@Controller("masterMpIvQuotationSendController")
public class MasterMpIvQuotationSendController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpIvOrderReceiptDelayBuyerChoicePopController.class);

	@Autowired
	private MasterMpIvQuotationSendService masterMpIvQuotationSendService;
	
	@Autowired
	private CommonInfoService commonInfoService;
	
	/**
	 * 견적제출지연건조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getMasterMpIvQuotationSendDelayPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpIvQuotationSendDelayPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpIvQuotationSendService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 견적제출장기지연건조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getMasterMpIvQuotationSendLngtermDelayPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpIvQuotationSendLngtermDelayPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpIvQuotationSendService.getLngtermDelayPopList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 합의내역(지연사유조회)팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getMasterMpIvQuotationSendDelayReasonPop.jsp.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpIvQuotationSendDelayReasonPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		pMap.put("QUERYID", "getComboICOMCOD1");
		pMap.put("TYPE", "M066");
		List<Map<String, String>> _data = commonInfoService.ajaxQueryIdCombo(pMap);
		List<Map<String, String>> _data1 = masterMpIvQuotationSendService.getRqdtDelayReasonPop(pMap);
		List<Map<String, String>> _data2 = masterMpIvQuotationSendService.getRqdtDelayDetailPop(pMap);
		pModel.addAttribute("combo_data", _data);
		pModel.addAttribute("reason_data", _data1);
		pModel.addAttribute("detail_data", _data2);
		return "common/popup/mpiv/masterMpIvQuotationSendDelayReasonPop";
	}
	
	/**
	 * 견적제출지연사유등록팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/saveMasterMpIvQuotationSendDelayReasonPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> setMasterMpIvQuotationSendDelayReasonPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("setCommonCoCoApprovalInfo 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = masterMpIvQuotationSendService.setMasterMpIvQuotationSendDelayReasonPop(pMap);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
