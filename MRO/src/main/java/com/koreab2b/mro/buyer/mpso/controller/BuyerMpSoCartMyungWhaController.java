package com.koreab2b.mro.buyer.mpso.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartMyungWhaService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoCartMyungWhaController")
public class BuyerMpSoCartMyungWhaController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoCartMyungWhaController.class);

	@Autowired
	private BuyerMpSoCartMyungWhaService buyerMpSoCartMyungWhaService;
	
	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoCartMyungWhaList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoCartMyungWhaList(ModelMap pModel  ,HttpServletRequest req,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoCartMyungWhaList.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		//pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"50") );
		pMap.put("st_query_cart", CommonUtil.onvl(pMap.get("st_query_cart") ,"ALL") );
		
		
			
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoCartMyungWhaService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoCartMyungWhaList";
	}
	
 
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpso/excelBuyerMpSoCartMyungWhaList.do", method = RequestMethod.POST)
	public String getExcelBuyerMpSoCartMyungWhaList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		//logger.debug("/mpso/excelBuyerMpSoCartMyungWhaList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpSoCartMyungWhaService.getList(pMap); 
		   
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "buyer/mpso/buyerMpSoCartMyungWhaExcelList";
		
		//CommonUtil.downloadExcel(_data, response, outputStream, headers);
		 
	}
}
