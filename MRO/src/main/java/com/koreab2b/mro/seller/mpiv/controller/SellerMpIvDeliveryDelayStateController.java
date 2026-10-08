package com.koreab2b.mro.seller.mpiv.controller;

import java.io.OutputStream;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.mpiv.service.SellerMpIvDeliveryDelayStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryDelayStateController")
public class SellerMpIvDeliveryDelayStateController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryDelayStateController.class);

	@Autowired
	private SellerMpIvDeliveryDelayStateService sellerMpIvDeliveryDelayStateService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryDelayStateList.do", method = RequestMethod.POST)
	public String getSellerMpIvDeliveryDelayStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpiv/getSellerMpIvDeliveryDelayStateList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvDeliveryDelayStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvDeliveryDelayStateList";
	}
	
	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryDelayStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvDeliveryDelayState(ModelMap pModel, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryDelayStateService.updateSellerMpIvDeliveryDelayState(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpiv/excelSellerMpIvDeliveryDelayStateList.do", method = RequestMethod.POST)
	public void excelSellerMpIvDeliveryDelayState(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvDeliveryDelayStateList.do 요청 파라미터 for jsp : {}", pMap);
		

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvDeliveryDelayStateService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "구매사|발주번호|품목코드|발주일|품명|규격|단가|단위|납품예정일|발주수량|납품예정수량|발주자|요청자|관리번호|요청부서|사유|지연일수|";
		String headers = "BUYER_NAME|PO_NO|BUYER_ITEM_NO|PO_CREATE_DATE|DESCRIPTION|SPECIFICATION|AGENT_PRICE|UNIT_MEASURE|DS_DATE|ITEM_QTY|CD_QTY|PURCHASER|REQ_USER|REF_PR_NO|REQ_DEPT|DS_REMARK|DS_DELAY_DAY|";

		String excelHeader = title +"@@"+headers;
		
//		String excelHeader = "";
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납품지연조회.xls");
	}
}
