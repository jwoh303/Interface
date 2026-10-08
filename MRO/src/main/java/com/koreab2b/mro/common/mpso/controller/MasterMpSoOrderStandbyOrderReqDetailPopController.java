package com.koreab2b.mro.common.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.koreab2b.mro.common.mpso.service.MasterMpSoOrderStandbyOrderReqDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoOrderStandbyOrderReqDetailPopController")
public class MasterMpSoOrderStandbyOrderReqDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoOrderStandbyOrderReqDetailPopController.class);

	@Autowired
	private MasterMpSoOrderStandbyOrderReqDetailPopService masterMpSoOrderStandbyOrderReqDetailPopService;
	
	/**
	 * 발주대기 주문요청 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	

	// 조회(헤더)
	@RequestMapping(value = "/mpso/getMasterMpSoOrderStandbyOrderReqHeaderPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoOrderStandbyOrderReqHeaderPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/getMasterMpSoOrderStandbyOrderReqHeaderPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterMpSoOrderStandbyOrderReqDetailPopService.getHeader(pMap);

		pModel.addAttribute("data", _data);
		return "common/popup/mpso/masterMpSoOrderStandbyOrderReqDetailPop";
	}

	// 조회(상세)
	@RequestMapping(value = "/mpso/getMasterMpSoOrderStandbyOrderReqDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderStandbyOrderReqDetailPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("/mpso/getMasterMpSoOrderStandbyOrderReqDetailPop.do 요청 파라미터 for jsp : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String, String>> _data = masterMpSoOrderStandbyOrderReqDetailPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 저장
	@RequestMapping(value = "/mpso/saveMasterMpSoOrderStandbyOrderReqDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngMappingReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoOrderStandbyOrderReqDetailPopService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
}
