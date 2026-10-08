package com.koreab2b.mro.seller.mpcl.controller;

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

import com.koreab2b.mro.seller.mpcl.service.SellerMpClClosingInfoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClClosingInfoController")
public class SellerMpClClosingInfoController {

	@Autowired
	private SellerMpClClosingInfoService sellerMpClClosingInfoService;
	
	// 조회
	@RequestMapping(value = "/mpcl/getSellerMpClClosingInfoList.do", method = RequestMethod.POST)
	public String getSellerMpClClosingInfoList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpcl/getSellerMpClClosingInfoList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 조회일자 Convert
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpClClosingInfoService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mpcl/sellerMpClClosingInfoList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpcl/excelSellerMpClClosingInfoList.do", method = RequestMethod.POST)
	public void excelSellerMpClClosingInfo(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletResponse response, OutputStream outputStream    ) {
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 

		List<Map<String, String>> _data = sellerMpClClosingInfoService.getAgentClosingInfoDown(pMap); 
		
		String title = "고객사|고객사코드|발주일|제품코드|발주번호|발주순번|품명|규격|단가|단위|발주수량|발주금액|납품수량|납품금액|입고수량|입고금액|납품예정일|납품일|고객사발주번호|고객사발주순번|발주자|인수자연락처|";
		String headers = "BUYER_NAME|BUYER|PO_CREATE_DATE|BUYER_ITEM_NO|PO_NO|PO_SEQ|DESCRIPTION|SPECIFICATION|AGENT_PRICE|UNIT_MEASURE|PO_QTY|PO_AMT|DELIVERY_QTY|DELIVERY_AMT|GR_QTY|GR_AMT|DS_DATE|DELIVERY_DATE|LEGACY_PO_NO|LEGACY_PO_SEQ|PURCHASER_NAME|CHANGE_USER_MOBILE_PHONE|";
		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "마감정보조회.xls");
	}
}
