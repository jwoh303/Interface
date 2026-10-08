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

import com.koreab2b.mro.seller.mpiv.service.SellerMpIvDeliveryRecordDeleteService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryRecordDeleteController")
public class SellerMpIvDeliveryRecordDeleteController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryRecordDeleteController.class);

	@Autowired
	private SellerMpIvDeliveryRecordDeleteService sellerMpIvDeliveryRecordDeleteService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRecordDeleteList.do", method = RequestMethod.POST)
	public String getSellerMpIvDeliveryRecordDeleteList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpiv/getSellerMpIvDeliveryRecordDeleteList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordDeleteService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
	
		return "seller/mpiv/sellerMpIvDeliveryRecordDeleteList";
	}

	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryRecordDeleteList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpIvDeliveryRecordDelete(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		// formData
//			Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryRecordDeleteService.saveSellerMpIvDeliveryRecordDelete(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}

	// EXCEL 다운로드
	@RequestMapping(value = "/mpiv/excelSellerMpIvDeliveryRecordDeleteList.do", method = RequestMethod.POST)
	public void excelSellerMpIvDeliveryRecordDelete(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvDeliveryRecordDeleteList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordDeleteService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "구매사|발주번호|납품예정일|거래명세서번호|구매사발주번호|품목코드|품명|규격|단가|단위|발주수량|납품수량|납품일|입고수량|구매사입고일|BUYER|PO_SEQ|INV_SEQ|BYIT_COMORG_CODE|CONTRACT_NO|CONTRACT_SEQ|SELLER|";
		String headers = "BUYER_NAME|PO_NO|DS_DATE|INV_NO|LEGACY_PO_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|AGENT_PRICE|UNIT_MEASURE|ITEM_QTY|DELIVERY_QTY|DELIVERY_DATE|GR_QTY|BUYER_GR_DATE|BUYER|PO_SEQ|INV_SEQ|BYIT_COMORG_CODE|CONTRACT_NO|CONTRACT_SEQ|SELLER|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납품실적내역.xls");
		 
	}
}




