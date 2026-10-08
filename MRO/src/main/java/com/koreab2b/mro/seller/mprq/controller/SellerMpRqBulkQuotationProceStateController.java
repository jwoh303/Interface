package com.koreab2b.mro.seller.mprq.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mprq.service.SellerMpRqBulkQuotationProceStateService;

@Controller("sellerMpRqBulkQuotationProceStateController")
public class SellerMpRqBulkQuotationProceStateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpRqBulkQuotationProceStateController.class);

	@Autowired
	private SellerMpRqBulkQuotationProceStateService sellerMpRqBulkQuotationProceStateService;
			
	// 견적요청 건 조회
	@RequestMapping(value = "/mprq/getSellerMpRqBulkQuotationProceStateList.do", method = RequestMethod.POST)
	public void getSellerMpRqBulkQuotationProceStateList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		
		pMap = IBSheetUtil.removeSlash(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getComCode());		
		pMap.put("COM_CODE", _sessionInfo.getComCode()); // 사용자ID
		
		LOGGER.debug("getSellerMpRqBulkQuotationProceStateList 요청 파라미터 for jsp : {}", pMap);
		
		List<Map<String,String>> _data = sellerMpRqBulkQuotationProceStateService.getList(pMap);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}	
}
