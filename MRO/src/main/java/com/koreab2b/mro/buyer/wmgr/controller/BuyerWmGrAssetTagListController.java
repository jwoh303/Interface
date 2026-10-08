package com.koreab2b.mro.buyer.wmgr.controller;

import java.io.OutputStream;
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

import com.koreab2b.mro.buyer.wmgr.service.BuyerWmGrAssetTagListService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerWmGrAssetTagListController")
public class BuyerWmGrAssetTagListController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrAssetTagListController.class);

	@Autowired
	private BuyerWmGrAssetTagListService buyerWmGrAssetTagListService;
	
	
	// 화면 호출
	@RequestMapping(value = "/wmgr/getBuyerWmGrAssetTag.do", method = RequestMethod.GET)
	public String getBuyerWmGrAssetTag(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		return "buyer/wmgr/buyerWmGrAssetTagList";
	}
	// 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrAssetTagList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrAssetTagList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = buyerWmGrAssetTagListService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	//  엑셀다운로드
	@RequestMapping(value = "/wmgr/excelBuyerWmGrAssetTagList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelBuyerWmGrAssetTagList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = buyerWmGrAssetTagListService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/wmgr/saveBuyerWmGrAssetTagList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerWmGrAssetTagList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerWmGrAssetTagListService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	
}
