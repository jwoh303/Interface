package com.koreab2b.mro.buyer.mpso.controller;

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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartExcelUploadService;
import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoCartExcelUploadController")
public class BuyerMpSoCartExcelUploadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartExcelUploadController.class);

	@Autowired
	private BuyerMpSoCartExcelUploadService buyerMpSoCartExcelUploadService;
	
	@Autowired
	private CommonInfoService commonInfoService;
	
	// 업로드 후 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoCartExcelUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpSoCartExcelUploadList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("buyer", _sessionInfo.getComCode());
		pMap.put("userid", _sessionInfo.getUserId());
		List<Map<String,String>> _data = buyerMpSoCartExcelUploadService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 장바구니담기
	@RequestMapping(value = "/mpso/setExcelIcomcartAdd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setExcelIcomcartAdd(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("buyer", _sessionInfo.getComCode());
		formData.put("userid", _sessionInfo.getUserId());
		
		String rtnMsg = buyerMpSoCartExcelUploadService.setCartAddReg(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mpso/delBuyerMpSoExcelUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBuyerMpSoExcelUpload(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("buyer", _sessionInfo.getComCode());
		formData.put("userid", _sessionInfo.getUserId());
		
		String rtnMsg = buyerMpSoCartExcelUploadService.deleteSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 업로드
	@RequestMapping(value = "/mpso/saveBuyerMpSoExcelUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpSoExcelUpload(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("buyer", _sessionInfo.getComCode());
		formData.put("userid", _sessionInfo.getUserId());
		
		String rtnMsg = buyerMpSoCartExcelUploadService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
