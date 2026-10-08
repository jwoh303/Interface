package com.koreab2b.mro.seller.mpst.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.mpst.service.SellerMpStToolStockStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpStToolStockStateController")
public class SellerMpStToolStockStateController {

	@Autowired
	private SellerMpStToolStockStateService sellerMpStToolStockStateService;
	
	// 조회
	@RequestMapping(value = "/mpst/getSellerMpStToolStockStateList.do", method = RequestMethod.POST)
	public String getSellerMpStToolStockStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpStToolStockStateService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "seller/mpst/sellerMpStToolStockStateList";
	}
	
	// 저장
	@RequestMapping(value = "/mpst/saveSellerMpStToolStockStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpStToolStockState(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		String flag = sellerMpStToolStockStateService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mpst/delSellerMpStToolStockStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delSellerMpStToolStockState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String flag = sellerMpStToolStockStateService.delSelectedData(formData, gridData);
		_response.put("msg", flag);
		
		return _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpst/excelSellerMpStToolStockStateList.do", method = RequestMethod.POST)
	public void excelSellerMpStToolStockState(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpStToolStockStateService.getList(pMap); 
		   
		String title = "고객사명|품목코드|품목명|구격|단위|단가|제조사|총재고수량|변경일";
		String headers = "BUYER_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|LIST_PRICE|MAKER_NAME|STOCK_QTY|CHANGE_DATE";
		String excelHeader = title + "@@" + headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"공구자재_재고현황.xls");
		 
	}
}
