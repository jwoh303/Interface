package com.koreab2b.mro.common.coco.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.CommonCoCoBuyerCurrencyPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonCoCoBuyerCurrencyPopController")
public class CommonCoCoBuyerCurrencyPopController {
	
	@Autowired
	private CommonCoCoBuyerCurrencyPopService commonCoCoBuyerCurrencyPopService;
	
	/**
	 * 품목별 환율 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBuyerCurrencyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonCoCoBuyerCurrencyPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		List<Map<String,String>> _data = commonCoCoBuyerCurrencyPopService.getCommonCoCoBuyerCurrencyPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 품목별 환율 매핑저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/saveCommonCoCoBuyerCurrencyPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveCommonCoCoBuyerCurrencyPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = commonCoCoBuyerCurrencyPopService.saveCommonCoCoBuyerCurrencyPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/**
	 * 품목별 환율 매핑삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/deleteCommonCoCoBuyerCurrencyPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteCommonCoCoBuyerCurrencyPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = commonCoCoBuyerCurrencyPopService.deleteCommonCoCoBuyerCurrencyPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
