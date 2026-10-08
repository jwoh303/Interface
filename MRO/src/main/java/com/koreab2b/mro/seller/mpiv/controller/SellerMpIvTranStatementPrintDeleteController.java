package com.koreab2b.mro.seller.mpiv.controller;

import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.seller.mpiv.service.SellerMpIvTranStatementPrintDeleteService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvTranStatementPrintDeleteController")
public class SellerMpIvTranStatementPrintDeleteController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvTranStatementPrintDeleteController.class);

	@Autowired
	private SellerMpIvTranStatementPrintDeleteService sellerMpIvTranStatementPrintDeleteService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvTranStatementPrintDeleteList.do", method = RequestMethod.POST)
	public String getSellerMpIvTranStatementPrintDeleteList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpiv/getSellerMpIvTranStatementPrintDeleteList.do 요청 파라미터 : {}", pMap);
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvTranStatementPrintDeleteService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvTranStatementPrintDeleteList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpiv/excelSellerMpIvTranStatementPrintDeleteList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrWarehousingLis(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/wmgr/excelBuyerWmGrWarehousingLisList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvTranStatementPrintDeleteService.getExcelList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
				
		String title = "수신자|수신자HP|주소|우편번호|구분|비고|";
		String headers = "RECV_USER_NAME|RECV_USER_TEL|ADDR|ZIP_CODE|CALC_GUBUN|REMARK|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "거래명세서.xls");
		 
	}
}
