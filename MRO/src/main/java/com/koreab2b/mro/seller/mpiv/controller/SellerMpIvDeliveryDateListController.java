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

import com.koreab2b.mro.seller.mpiv.service.SellerMpIvDeliveryDateListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryDateListController")
public class SellerMpIvDeliveryDateListController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryDateListController.class);

	@Autowired
	private SellerMpIvDeliveryDateListService sellerMpIvDeliveryDateListService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryDateList.do", method = RequestMethod.POST)
	public String getSellerMpIvDeliveryDateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvDeliveryDateListService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvDeliveryDateList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpiv/excelSellerMpIvDeliveryDateList.do", method = RequestMethod.POST)
	public void excelSellerMpIvDeliveryDateList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvDeliveryDateListService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "구매회사|발주번호|발주항번|품목코드|품명|규격|발주수량|납품|입고수량|확정수량|변경전|변경후|변경일|확인일|고객사발주번호|고객사발주항번|비고|";
		String headers = "BUYER_NAME|PO_NO|PO_SEQ|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|IV_QTY|GR_QTY|DI_QTY|BEFORE_DATA|AFTER_DATA|ADD_DATE|CONFIRM_DATE|LEGACY_PO_NO|LEGACY_PO_SEQ|PO_REMARK|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납기일변경현황리스트.xls");
		
	}
	
	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryDateReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpIvDeliveryDateReg(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 

		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryDateListService.updateSellerMpIvDeliveryDateReg(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
}
