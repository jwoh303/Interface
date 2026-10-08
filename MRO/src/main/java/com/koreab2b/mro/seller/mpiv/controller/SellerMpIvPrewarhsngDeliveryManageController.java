package com.koreab2b.mro.seller.mpiv.controller;

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

import com.koreab2b.mro.seller.mpiv.service.SellerMpIvPrewarhsngDeliveryManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvPrewarhsngDeliveryManageController")
public class SellerMpIvPrewarhsngDeliveryManageController {

	@Autowired
	private SellerMpIvPrewarhsngDeliveryManageService sellerMpIvPrewarhsngDeliveryManageService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvPrewarhsngDeliveryManageList.do", method = RequestMethod.POST)
	public String getSellerMpIvPrewarhsngDeliveryManageList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvPrewarhsngDeliveryManageService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mpiv/sellerMpIvPrewarhsngDeliveryManageList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpiv/excelSellerMpIvPrewarhsngDeliveryManageList.do", method = RequestMethod.POST)
	public void excelSellerMpIvPrewarhsngDeliveryManage(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletResponse response, OutputStream outputStream    ) {
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvPrewarhsngDeliveryManageService.getList(pMap); 
		   
		String title = "고객사코드|고객사명|요청일|거래명세서번호|총 금액|품목 수|요청자ID|요청자명|요청자부서코드|요청자부서명|상태";
		String headers = "BUYER|BUYER_NAME|BEFORE_GR_DATE|INV_NO|INV_AMT|PRODUCT_CNT|PURCHASER_ID|PURCHASER_NAME|PURCHASER_DEPT|PURCHASER_DEPT_NAME|DELIVERY_STATUS";
		String excelHeader = title +"@@"+headers;

		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "선입고_납품관리.xls");
		 
	}
}
