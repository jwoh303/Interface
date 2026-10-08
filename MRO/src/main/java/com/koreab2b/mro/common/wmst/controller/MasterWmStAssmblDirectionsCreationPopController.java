package com.koreab2b.mro.common.wmst.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmst.service.MasterWmStAssmblDirectionsCreationPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmStAssmblDirectionsCreationPopController")
public class MasterWmStAssmblDirectionsCreationPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmStAssmblDirectionsCreationPopController.class);

	@Autowired
	private MasterWmStAssmblDirectionsCreationPopService masterWmStAssmblDirectionsCreationPopService;
	
	/**
	 * 조립 부품서 조회 조립상품조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/getMasterWmStAssmblDirectionsCreationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmStAssmblDirectionsCreationPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmStAssmblDirectionsCreationPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	/**
	 * 조립 부품서 조회 부품목록 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/getMasterWmStAssmblDirectionsCreationPop2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmStAssmblDirectionsCreationPop2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmStAssmblDirectionsCreationPopService.getList2(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 조립 부품서 조립상품 조립수량이 변할때
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/getMasterWmStAssmblDirectionsCreationPopChange.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmStAssmblDirectionsCreationPopChange(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmStAssmblDirectionsCreationPopService.getChangeList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	// 조립지시서 
	@RequestMapping(value = "/wmst/saveMasterWmStAssmblDirectionsCreationPop.do", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Map<String, Object> saveMasterWmStAssmblDirectionsCreationPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = "";
		Map<String, Object> mp = new HashMap<String, Object>();
		Map<String, String> rtnMap = new HashMap<String,String>();
		
		rtnMsg = masterWmStAssmblDirectionsCreationPopService.updateSelectedData(formData, gridData);
		if("OK".equals(rtnMsg)){
			mp.put("Code",1);
			
		}else{
			mp.put("Code",0);
		}
		_response.put("Message", rtnMap.get("rtnMsg"));
		_response.put("Result",mp);
		return _response;
		
	}
	
}
