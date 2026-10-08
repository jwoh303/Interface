package com.koreab2b.mro.seller.mpiv.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.seller.mpiv.service.SellerMpIvDeliveryProgressStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryProgressStateController")
public class SellerMpIvDeliveryProgressStateController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryProgressStateController.class);

	@Autowired
	private SellerMpIvDeliveryProgressStateService sellerMpIvDeliveryProgressStateService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryProgressStateList.do", method = RequestMethod.POST)
	public String getSellerMpIvDeliveryProgressStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpiv/getSellerMpIvDeliveryProgressStateList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvDeliveryProgressStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvDeliveryProgressStateList";
	}
	
	// 납품예정일 변경요청
	@RequestMapping(value = "/mpiv/saveSellerMpIvDsDateChangeReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvDsDateChangeReq(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvDsDateChangeReqList.do 요청 파라미터 for jsp : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryProgressStateService.updateSellerMpIvDsDateChangeReq(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpiv/excelSellerMpIvDeliveryProgressStateList.do", method = RequestMethod.POST)
	public void excelSellerMpIvDeliveryProgressState(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvDeliveryProgressStateList.do 요청 파라미터 for jsp : {}", pMap);

		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvDeliveryProgressStateService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "구매회사|상태|발주일|발주번호|납품예정일|거래명세서번호|납품일|납품확정일|품목코드|품명|규격|제조사|모델번호|발주수량|납품예정수량|납품수량|납품확정수량|구매사발주번호|고객사발주항번|단가|단위|납품현황|도착지|비고|비고2|관리번호|";
		String headers = "BUYER_NAME|STATUS|PO_CREATE_DATE|PO_NO|DS_DATE|INV_NO|INVOICE_DATE|DELIVERY_DATE|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|MAKER_PART_NO|ITEM_QTY|CD_QTY|INV_QTY|DELIVERY_QTY|LEGACY_PO_NO|LEGACY_PO_SEQ|AGENT_PRICE|UNIT_MEASURE|DELIVERY_STATUS|DELY_TO_LOCATION|PO_REMARK|PO_REMARK_2|REF_PR_NO|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납품현황.xls");
		
	}
	
	// 납풉정보 변경요청
	@RequestMapping(value = "/mpiv/saveSellerMpIvIvInfoChangeReqList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvIvInfoChangeReq(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveSellerMpIvIvInfoChangeReqList.do 요청 파라미터 for jsp : {}", pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryProgressStateService.updateSellerMpIvIvInfoChangeReq(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	// 리뉴얼 > 납품진행현황 > 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryProgressStateList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliveryProgressStateList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvDeliveryProgressStateList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = sellerMpIvDeliveryProgressStateService.getSellerMpIvDeliveryProgressStateList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
