package com.koreab2b.mro.common.mprq.controller;

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
import com.koreab2b.mro.common.mprq.service.MasterMpRqBulkQuotationDmSendPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterDmSendPopController")
public class MasterMpRqBulkQuotationDmSendPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationDmSendPopController.class);

	@Autowired
	private MasterMpRqBulkQuotationDmSendPopService masterDmSendPopService;

	/**
	 * 협력사 DM 발송
	 * @param pReq
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mprq/saveMasterMprqBulkQuotationDmSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMprqBulkQuotationDmSend(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("pMap : {}", pMap.toString());
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterDmSendPopService.saveMasterDmSend(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);

		return _response;
	}

	// 벌크소싱 견적현황 > 협력사 DM발송 팝업 > 미리보기 팝업 
	@RequestMapping(value = "/mprq/showMasterMprqBulkQuotationtDmPreviewPop.do", method = {RequestMethod.POST, RequestMethod.GET})
	public String showMasterMprqBulkQuotationtDmPreviewPop(ModelMap pModel, @RequestParam Map<String, String> pMap) { 
		return "/common/popup/mprq/masterMprqBulkQuotationtDmPreviewPop";
	}
}