package com.koreab2b.mro.common.mprq.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.service.SellerMpRqBulkQuotationPriceRegPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("SellerMpRqBulkQuotationPriceRegPopController")
public class SellerMpRqBulkQuotationPriceRegPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpRqBulkQuotationPriceRegPopController.class);

	@Autowired
	private SellerMpRqBulkQuotationPriceRegPopService SellerMpRqBulkQuotationPriceRegService;
	
	// 엑셀 업로드
	@RequestMapping(value = "/mprq/batchSellerMpRqBulkQuotationPriceRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchSellerMpRqBulkQuotationPriceRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		formData.put("COM_CODE", _sessionInfo.getComCode()); // 회사  코드
		
		LOGGER.debug("요청 파라미터 : {}", gridData);
		LOGGER.debug("batchSellerMpRqBulkQuotationPriceRegPop MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = SellerMpRqBulkQuotationPriceRegService.batchSellerMpRqBulkQuotationPriceReg(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 업로드 결과 확인
	@RequestMapping(value = "/mprq/checkSellerMpRqBulkQuotationPriceRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void checkSellerMpRqBulkQuotationPriceRegPop(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, String> formData) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		formData.put("COM_CODE", _sessionInfo.getComCode()); // 코드
		
		LOGGER.debug("checkSellerMpRqBulkQuotationPriceRegPop 요청 파라미터 : {}", formData);
		List<Map<String,String>> _data = SellerMpRqBulkQuotationPriceRegService.checkSellerMpRqBulkQuotationPriceReg(formData);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 단가 업로드
	@RequestMapping(value = "/mprq/saveSellerMpRqBulkQuotationPriceRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpRqBulkQuotationPriceReg(HttpServletRequest req, @RequestParam Map<String, String> formData) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID
		formData.put("COM_CODE", _sessionInfo.getComCode()); // 코드
		LOGGER.debug("saveSellerMpRqBulkQuotationPriceRegPop param : {}", formData);
		
		String rtnMsg = SellerMpRqBulkQuotationPriceRegService.saveSellerMpRqBulkQuotationPriceReg(formData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
	}
}
