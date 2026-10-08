package com.koreab2b.mro.buyer.mpst.controller;

import java.util.HashMap;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpst.service.BuyerMpStWarehouseGiService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpStWarehouseGiController")
public class BuyerMpStWarehouseGiController {

	@Autowired
	private BuyerMpStWarehouseGiService buyerMpStWarehouseGiService;
	
	// 조회
	@RequestMapping(value = "/mpst/getBuyerMpStWarehouseGiList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpStWarehouseGiList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
	
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

			
		List<Map<String,String>> _data = buyerMpStWarehouseGiService.getList(pMap);
			
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpst/excelBuyerMpStWarehouseGiList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelBuyerMpStWarehouseGiList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = buyerMpStWarehouseGiService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 삭제
	@RequestMapping(value = "/mpst/delBuyerMpStWarehouseGiList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBuyerMpStWarehouseGiList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMpStWarehouseGiService.delSelectedData(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 출고 
	@RequestMapping(value = "/mpst/setBuyerMpStGiAdd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setBuyerMpStGiAdd(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMpStWarehouseGiService.setSelectedData(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
