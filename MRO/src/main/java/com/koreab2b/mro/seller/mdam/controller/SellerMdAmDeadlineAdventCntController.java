package com.koreab2b.mro.seller.mdam.controller;

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

import com.koreab2b.mro.seller.mdam.service.SellerMdAmDeadlineAdventCntService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdAmDeadlineAdventCntController")
public class SellerMdAmDeadlineAdventCntController {

	@Autowired
	private SellerMdAmDeadlineAdventCntService sellerMdAmDeadlineAdventCntService;
	
	// 조회
	@RequestMapping(value = "/mdam/getSellerMdAmDeadlineAdventCntList.do", method = RequestMethod.POST)
	public String getSellerMdAmDeadlineAdventCntList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMdAmDeadlineAdventCntService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "seller/mdam/sellerMdAmDeadlineAdventCntList";
	}
	
	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @param response
	 * @param outputStream
	 */
	@RequestMapping(value = "/mdam/excelSellerMdAmDeadlineAdventCntList.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMdAmDeadlineAdventCntService.getList(pMap); 
		   
		String title = "고객사|발주번호|발주항번|품목코드|발주일|품목명|규격|단가|단위|납기요청일|납품예정일|발주수량|발주금액|납품예정수량|발주자|요청자|관리번호|요청부서";
		String headers = "BUYER_NAME|PO_NO|PO_SEQ|BUYER_ITEM_NO|PO_CREATE_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|UNIT_MEASURE|RD_DATE|DS_DATE|ITEM_QTY|ITEM_AMT|CD_QTY|PURCHASER_NAME|ADD_USER_NAME|REF_PR_NO|REQ_DEPT";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납기도래품목현황.xls");
 
	}
	
	// 조회
	@RequestMapping(value = "/mdam/getSellerMdAmDeliveryDelayListPop.do", method = RequestMethod.POST)
	public String getSellerMdAmDeliveryDelayListPop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		

		// 화면 조회
		List<Map<String, String>> _data = sellerMdAmDeadlineAdventCntService.getListPop(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "seller/mdam/sellerMdAmDeliveryDelayListPop";
	}
	
}
