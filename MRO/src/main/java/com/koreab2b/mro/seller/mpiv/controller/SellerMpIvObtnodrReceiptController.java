package com.koreab2b.mro.seller.mpiv.controller;

import java.io.OutputStream;
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
import com.koreab2b.mro.common.mpiv.service.SellerMpIvObtnodrReceiptDetailPopService;
import com.koreab2b.mro.seller.mpiv.service.SellerMpIvObtnodrReceiptService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvObtnodrReceiptController")
public class SellerMpIvObtnodrReceiptController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvObtnodrReceiptController.class);

	@Autowired
	private SellerMpIvObtnodrReceiptService sellerMpIvObtnodrReceiptService;
	
	@Autowired
	private SellerMpIvObtnodrReceiptDetailPopService sellerMpIvObtnodrReceiptDetailPopService;
	
	/**
	 * 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getSellerMpIvObtnodrReceiptList.do", method = RequestMethod.POST)
	public String getSellerMpIvObtnodrReceiptList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpiv/getSellerMpIvObtnodrReceiptList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvObtnodrReceiptService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvObtnodrReceiptList";
	}
	
	// 수주접수(PO별) 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvObtnodrReceiptList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpRqQuotaList_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvObtnodrReceiptList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = sellerMpIvObtnodrReceiptService.getSellerMpIvObtnodrReceiptList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 수주접수(품목별) 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvObtnodrReceiptMultiList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvObtnodrReceiptMultiList_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvObtnodrReceiptMultiList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = sellerMpIvObtnodrReceiptService.getSellerMpIvObtnodrReceiptMultiList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
		
	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @param response
	 * @param outputStream
	 */
	@RequestMapping(value = "/mpiv/excelSellerMpIvObtnodrReceiptList.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvObtnodrReceiptList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		//pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvObtnodrReceiptService.getExcelList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());

		String title = "고객사|발주일|관리번호|주문번호|발주번호|발주금액|IF발주번호|품목명|규격|제조사|모델번호|품목수|납기요청일|도착지주소|비고|요청부서|요청자|협력사품목코드|";
		String headers = "BUYER_NAME|PO_CREATE_DATE|REF_PR_NO|REF_NO|PO_NO|PO_AMT|LEGACY_PO_NO|DESCRIPTION|SPECIFICATION|MAKER_NAME|MAKER_PART_NO|PO_SEQ|RD_DATE|DELY_TO_LOCATION|PO_REMARK|REQ_DEPT_NAME|REQ_USER_NAME|SELLER_ITEM_NO|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "수주접수.xls");
 
	}
}
