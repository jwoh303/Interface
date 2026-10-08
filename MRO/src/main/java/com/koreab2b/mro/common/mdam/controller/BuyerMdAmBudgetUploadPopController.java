package com.koreab2b.mro.common.mdam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdam.service.BuyerMdAmBudgetUploadPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmBudgetUploadPopController")
public class BuyerMdAmBudgetUploadPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetUploadPopController.class);

	@Autowired
	private BuyerMdAmBudgetUploadPopService buyerMdAmBudgetUploadPopService;
	
	/** 
	 * 고객사 > 예산편성 > 일괄편성
	 * 
	 * @return
	 */
	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetUploadPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String budgetUploadPop(HttpServletRequest request) {
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mdam/buyerMdAmBudgetUploadPop_v2";
		}else{
			return "common/popup/mdam/buyerMdAmBudgetUploadPop";
		}
	}
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetUploadPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void getBuyerMdAmBudgetUploadPop(HttpServletRequest pReq , HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("요청 파라미터 : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) pReq.getSession().getAttribute("sessionInfo");
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(pReq)));
		
		List<Map<String,String>> _data = buyerMdAmBudgetUploadPopService.getList(pMap);

		pReq.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(pReq, pRes);		
	}
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetUploadPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmBudgetUploadPop_v2(HttpServletRequest pReq , HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {		
		logger.debug("요청 파라미터 : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) pReq.getSession().getAttribute("sessionInfo");
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(pReq)));
		
		List<Map<String,String>> _data = buyerMdAmBudgetUploadPopService.getBuyerMdAmBudgetUploadPop_v2(pMap);
		return IBSheetUtil.addResut(pReq, _data , pMap);
	}
	
	// 업로드
	@RequestMapping(value = "/mdam/saveBuyerMdAmExcelUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmExcelUpload(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMdAmBudgetUploadPopService.uploadSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	@RequestMapping(value = "/mdam/saveBuyerMdAmExcelUpload_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmExcelUpload_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMdAmBudgetUploadPopService.saveBuyerMdAmExcelUpload_v2(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("정상적으로 업로드 되었습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",-1);
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmBudgetUpload.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmBudgetUpload(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMdAmBudgetUploadPopService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	@RequestMapping(value = "/mdam/saveBuyerMdAmBudgetUpload_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmBudgetUpload_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = buyerMdAmBudgetUploadPopService.saveBuyerMdAmBudgetUpload_v2(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("정상적으로 저장되었습니다.")){
			mp.put("Code",2);
		}else{
			mp.put("Code",-1);
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
