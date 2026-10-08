package com.koreab2b.mro.master.mpso.controller;

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

import com.koreab2b.mro.master.mpso.service.MasterMpSoProgressDmSendPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoProgressDmSendPopController")
public class MasterMpSoProgressDmSendPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoProgressDmSendPopController.class);

	@Autowired
	private MasterMpSoProgressDmSendPopService masterMpSoProgressDmSendPopService;
		
	// 발주 정보 조회
	@RequestMapping(value = "/mpso/getMasterMpSoProgressDmSendPop.do",  method = {RequestMethod.GET,RequestMethod.POST})	
	public String getMasterMpSoProgressDmSendPop(ModelMap pModel ,HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		
		//페이징용 파라미터의 셋팅
		LOGGER.debug("pMap : {}", pMap.toString());
		
		// 협력사 수신정보 조회
		List<Map<String,String>> _data = masterMpSoProgressDmSendPopService.getPoList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		return "/common/popup/mpso/masterMpSoProgressDmSendPop";
	}
	
	
	// 수신 정보 조회
	@RequestMapping(value = "/mpso/getMasterMpSoProgressDmSendPopUserList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMpSoProgressDmSendPopUserList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		
		//페이징용 파라미터의 셋팅
		LOGGER.debug("pMap : {}", pMap.toString());
		
		// 협력사 수신정보 조회
		List<Map<String,String>> _data = masterMpSoProgressDmSendPopService.getUserList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);
	}
	
	// 발주정보 조회(미리보기용)
	@RequestMapping(value = "/mpso/getMasterMpSoProgressDmPreviewPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoProgressDmPreviewPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpSoProgressDmSendPopService.getPoList(pMap);
		_response.put("data", _data);
		
		return _response;
	}

	/**
	 * 고객사 입고독려 DM 발송
	 * @param pReq
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/saveMasterMpSoProgressDmSend.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoProgressDmSend(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("pMap : {}", pMap.toString());
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoProgressDmSendPopService.DmSend(formData, gridData);

//		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);

		return _response;
	}

	
		
}
