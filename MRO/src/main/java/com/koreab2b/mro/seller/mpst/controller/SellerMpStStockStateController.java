package com.koreab2b.mro.seller.mpst.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.mpst.service.SellerMpStStockStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpStStockStateController")
public class SellerMpStStockStateController {

	@Autowired
	private SellerMpStStockStateService sellerMpStStockStateService;
	
	// 조회
	@RequestMapping(value = "/mpst/getSellerMpStStockStateList.do", method = RequestMethod.POST)
	public String getSellerMpStStockStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpStStockStateService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "seller/mpst/sellerMpStStockStateList";
	}
	
	// 조회 - 리뉴얼 버전 (JSON 응답)
	@RequestMapping(value = "/mpst/getSellerMpStStockStateList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMpStStockStateList_v2(@RequestParam Map<String, String> pMap) {
		
		// 물류센터 목록만 조회하는 경우
		if ("Y".equals(pMap.get("loadWarehouseOnly"))) {
			// 구매사 목록 조회용 쿼리 (DISTINCT WAREHOUSE_CODE, WAREHOUSE_NAME)
			pMap.put("st_buyer", ""); // 빈 값으로 설정하여 모든 구매사 조회
		}
		
		// 기존 서비스 로직 그대로 사용
		List<Map<String, String>> data = sellerMpStStockStateService.getList(pMap);
		
		// JSON 응답 형태로 변환
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("data", data);
		result.put("Message", "조회되었습니다.");
		result.put("Code", 0); // IBSheet 성공 코드
		
		return result;
	}
	
	// 저장
//	@RequestMapping(value = "/mpst/saveSellerMpStStockStateList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> updateSellerMpStStockState(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//
//		// gridData
//		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
//		// formData
//		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
//		
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		String flag = sellerMpStStockStateService.updateSelectedData(_pMap, _list);
//		_response.put("msg", flag);
//
//		return  _response;
//	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpst/excelSellerMpStStockStateList.do", method = RequestMethod.POST)
	public void excelSellerMpStStockState(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpStStockStateService.getList(pMap); 
		   
		String title = "물류센터명|품목코드|품목명|규격|단위|총재고량|가용재고량|출하대기재고량|최대재고량|최소재고량";
		String headers = "WAREHOUSE_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|TOT_QTY|AVAIL_QTY|ALLOC_QTY|MAX_STOCK_QTY|MIN_ORDER_QTY";
		String excelHeader = title + "@@" + headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"재고현황조회.xls");
	}
	
}
