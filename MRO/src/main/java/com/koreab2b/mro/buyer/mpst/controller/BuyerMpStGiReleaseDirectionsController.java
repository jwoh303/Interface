package com.koreab2b.mro.buyer.mpst.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpst.service.BuyerMpStGiReleaseDirectionsService;
import com.koreab2b.mro.buyer.mpst.service.BuyerMpStReleaseDirectionsService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpsm.service.MasterMpSmStatsHomeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpStGiReleaseDirectionsController")
public class BuyerMpStGiReleaseDirectionsController {

	@Autowired
	private BuyerMpStGiReleaseDirectionsService buyerMpStGiReleaseDirectionsService; 
	
	// 조회
	@RequestMapping(value = "/mpst/getBuyerMpStGiReleaseDirectionsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpStGiReleaseDirectionsList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = buyerMpStGiReleaseDirectionsService.getBuyerMpStGiReleaseDirectionsList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 출고
	@RequestMapping(value = "/mpst/updateBuyerMpStGi.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updateBuyerMpStGi(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
	
		Map<String, Object> _response = new HashMap<String, Object>();
		String _rtnMsg = "";
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		_rtnMsg = buyerMpStGiReleaseDirectionsService.updateSelectedGiData(formData, gridData);
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", _rtnMsg);
		
		return _response;
	}
	
	
	// 출고 취소
	@RequestMapping(value = "/mpst/updateBuyerMpStGiCancel.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updateBuyerMpStGiCancel(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		String _rtnMsg = "";

		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		_rtnMsg = buyerMpStGiReleaseDirectionsService.updateSelectedGiCancelData(formData, gridData);
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", _rtnMsg);

		return _response;
	}
	
	// 확정
	@RequestMapping(value = "/mpst/updateBuyerMpStGiComplete.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updateBuyerMpStGiComplete(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		String _rtnMsg = "";

		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		_rtnMsg = buyerMpStGiReleaseDirectionsService.updateSelectedGiCompleteData(formData, gridData);
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", _rtnMsg);

		return _response;
	}
	
}
