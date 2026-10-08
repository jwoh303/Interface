package com.koreab2b.mro.buyer.mpso.controller;

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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoDelayDlvyStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoDelayDlvyStateController")
public class BuyerMpSoDelayDlvyStateController {
 

	@Autowired
	private BuyerMpSoDelayDlvyStateService buyerMpSoDelayDlvyStateService;
	
	// 조회 PG_06_B_015_00
	@RequestMapping(value = "/mpso/getBuyerMpSoDelayDlvyStateList.do", method = RequestMethod.POST)
	public String getBuyerMpSoDelayDlvyStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoDelayDlvyStateList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoDelayDlvyStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoDelayDlvyStateList";
	} 
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpso/excelBuyerMpSoDelayDlvyStateList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoDelayDlvyState(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpso/excelBuyerMpSoDelayDlvyStateList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpSoDelayDlvyStateService.getList(pMap); 
		   
		//logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String title = "요청번호|관리번호|품목코드|주문일|품명|규격|단가|금액|배송희망일|배송확정일|단위|사유|발주일|발주수량|협력사|발주번호|상태|입고수량|배송확정수량|구매사코드|주문항번|발주항번|협력사코드|";
		String headers = "PR_NO|REF_PR_NO|BUYER_ITEM_NO|CHANGE_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|PO_SUM|RD_DATE|CD_DATE|UNIT_MEASURE|PR_RETURN_REASON|PO_CREATE_DATE|ITEM_QTY|AGENT_TEXT|PO_NO|STATUS_TEXT|GR_QTY|DI_QTY|BUYER|PR_SEQ|PO_SEQ|AGENT|";

		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"납기지연현황.xls");
		 
	}
}
