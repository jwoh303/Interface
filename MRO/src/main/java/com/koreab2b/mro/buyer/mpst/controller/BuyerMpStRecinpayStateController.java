package com.koreab2b.mro.buyer.mpst.controller;

import java.io.OutputStream;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mpst.service.BuyerMpStRecinpayStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpStRecinpayStateController")
public class BuyerMpStRecinpayStateController {

	@Autowired
	private BuyerMpStRecinpayStateService buyerMpStRecinpayStateService;
	
	// 조회
	@RequestMapping(value = "/mpst/getBuyerMpStRecinpayStateList.do", method = RequestMethod.POST)
	public String getBuyerMpStRecinpayStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpStRecinpayStateService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "buyer/mpst/buyerMpStRecinpayStateList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpst/excelBuyerMpStRecinpayStateList.do", method = RequestMethod.POST)
	public void excelBuyerMpStRecinpayState(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpStRecinpayStateService.getList(pMap); 
		   
		String title = "수불년월|품목코드|품목명|규격|제조사|단위|구매단가|기초수량|기초금액|입고수량|입고금액|출고수량|출고금액|조정수량|조정금액|기말수량|기말금액";
		String headers = "YYYYMM|ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|TARGET_PRICE|BASIC_QTY|BASIC_AMT|GR_QTY|GR_AMT|CHUL_QTY|CHUL_AMT|JO_QTY|JO_AMT|LAST_QTY|LAST_AMT";
		String excelHeader = title + "@@" + headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"수불현황.xls");
	}
}
