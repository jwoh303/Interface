package com.koreab2b.mro.buyer.mdam.controller;

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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmGoodsLineStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmGoodsLineStateController")
public class BuyerMdAmGoodsLineStateController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmGoodsLineStateController.class);

	@Autowired
	private BuyerMdAmGoodsLineStateService buyerMdAmGoodsLineStateService;
	

	// 조회조건-userList 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmGoodsLineStateUserList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerMdAmGoodsLineStateUserList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		List<Map<String, String>> _data = buyerMdAmGoodsLineStateService.getUserList(pMap);
		
		_response.put("userList", _data);
		_response.put("msg", "");
		
		return  _response;
	}
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmGoodsLineStateList.do", method = RequestMethod.POST)
	public String getBuyerMdAmGoodsLineStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {
		
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdAmGoodsLineStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/mdam/buyerMdAmGoodsLineStateList";
	}

	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @param response
	 * @param outputStream
	 */
	@RequestMapping(value = "/mdam/excelBuyerMdAmGoodsLineStateList.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvObtnodrReceiptList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMdAmGoodsLineStateService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());

		String title = "발주부서|발주자|품목코드|품목명|규격|제조사|단위|수량|단가|금액|발주번호|발주일|납기요청일|납품예정일|납품완료일|카테고리경로|";

		String headers = "PO_DEPT|PURCHASER_NAME|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|ITEM_QTY|UNIT_PRICE|ITEM_AMT|PO_NO|PO_CREATE_DATE|RD_DATE|DS_DATE|DELIVERY_DATE|CATEG_PATH|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "품목군별진행현황.xls");
 
	}
}
