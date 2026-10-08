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
import com.koreab2b.mro.seller.mpiv.service.SellerMpIvDeliveryRecordRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpIvDeliveryRecordRegController")
public class SellerMpIvDeliveryRecordRegController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpIvDeliveryRecordRegController.class);

	@Autowired
	private SellerMpIvDeliveryRecordRegService sellerMpIvDeliveryRecordRegService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRecordRegList.do", method = RequestMethod.POST)
	public String getSellerMpIvDeliveryRecordRegList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		logger.debug("/mpiv/getSellerMpIvDeliveryRecordRegList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordRegService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpiv/sellerMpIvDeliveryRecordRegList";
	}
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRecordRegList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliveryRecordRegList_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvDeliveryRecordRegList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		
		// 납품실적등록대상 리스트조회
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordRegService.getSellerMpIvDeliveryRecordRegList_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRecordRegList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliveryRecordRegList_v3(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvDeliveryRecordRegList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		
		// 납품실적등록대상 리스트조회
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordRegService.getSellerMpIvDeliveryRecordRegList_v3(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryRecordRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvDeliveryRecordReg(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		// formData
//		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryRecordRegService.updateSellerMpIvDeliveryRecordReg(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryRecordRegList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvDeliveryRecordReg_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("updateSellerMpIvDeliveryRecordReg_v2 요청 파라미터 : {}", pMap);
		// formData
//		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryRecordRegService.updateSellerMpIvDeliveryRecordReg_v2(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryRecordRegList_v3.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvDeliveryRecordReg_v3(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("updateSellerMpIvDeliveryRecordReg_v2 요청 파라미터 : {}", pMap);
		// formData
//		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryRecordRegService.updateSellerMpIvDeliveryRecordReg_v3(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	
	// 택배사정보 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryRecordParcelRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvDeliveryRecordParcelReg(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("saveSellerMpIvDeliveryRecordParcelRegList 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryRecordRegService.updateSellerMpIvDeliveryRecordParcelReg(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}	
	
	@RequestMapping(value = "/mpiv/delSellerMpIvDeliveryRecordInvoiceList_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> delSellerMpIvDeliveryRecordInvoiceList_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/delSellerMpIvDeliveryRecordInvoiceList_v2.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = sellerMpIvDeliveryRecordRegService.delSellerMpIvDeliveryRecordInvoiceList_v2(pMap);
		
		_response.put("msg", flag);
				
		return _response;
	}
	
	// EXCEL 다운로드
	@RequestMapping(value = "/mpiv/excelSellerMpIvDeliveryRecordRegList.do", method = RequestMethod.POST)
	public void excelSellerMpIvDeliveryRecordReg(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpiv/excelSellerMpIvDeliveryRecordDeleteList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordRegService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "구매사|구매사코드|거래명세서번호|거래명세서 항번|발주번호|발주 항번|구매사발주번호|거래유형|배송유형|택배사|택배사코드|송장번호|품목코드|품명|규격|단가|단위|발주수량|납품일";
		
		String headers = "BUYER_NAME|BUYER|INV_NO|INV_SEQ|PO_NO|PO_SEQ|LEGACY_PO_NO|PROCESS_TYPE_TEXT|PARCEL_TYPE_TEXT|PARCEL_COM_NAME|PARCEL_COM_CODE|PARCEL_INV_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|AGENT_PRICE|UNIT_MEASURE|ITEM_QTY|DS_DATE|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납품실적등록조회.xls");
		 
	}
	
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRecordRegEndList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliveryRecordRegEndList_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvDeliveryRecordRegEndList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		
		// 납품완료 리스트조회
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordRegService.getSellerMpIvDeliveryRecordRegEndList_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/mpiv/getSellerMpIvDeliveryRecordRegEndList_v3.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getSellerMpIvDeliveryRecordRegEndList_v3(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getSellerMpIvDeliveryRecordRegEndList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		
		// 납품완료 리스트조회
		List<Map<String, String>> _data = sellerMpIvDeliveryRecordRegService.getSellerMpIvDeliveryRecordRegEndList_v3(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mpiv/saveSellerMpIvDeliveryRecordDeleteList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpIvDeliveryRecordDeleteList_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("saveSellerMpIvDeliveryRecordDeleteList_v2 요청 파라미터 : {}", pMap);
		// formData
//		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpIvDeliveryRecordRegService.updateSellerMpIvDeliveryRecordDeleteList_v2(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
	
	
}
