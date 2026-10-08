package com.koreab2b.mro.buyer.mpds.controller;

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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpds.service.BuyerMpDsOrderManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpDsOrderManageController")
public class BuyerMpDsOrderManageController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMpDsOrderManageController.class);

	@Autowired
	private BuyerMpDsOrderManageService buyerMpDsOrderManageService;
	
	// 조회
	@RequestMapping(value = "/mpds/getBuyerMpDsOrderManageList.do", method = RequestMethod.POST)
	public String getBuyerMpDsOrderManageList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpds/getBuyerMpDsOrderManageList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc2(pMap); 

		//화면 조회
		List<Map<String, String>> _data = buyerMpDsOrderManageService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pMap.put("st_gr_exception", ("on".equals(pMap.get("st_gr_exception")))? "on":"off");
		pModel.addAllAttributes(pMap);
		
		return "buyer/mpds/buyerMpDsOrderManageList";
	}

	// EXCEL 다운로드	
	@RequestMapping(value = "/mpds/excelBuyerMpDsOrderManageList.do", method = RequestMethod.POST)
	public void excelBuyerMpDsOrderManage(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpds/excelBuyerMpDsOrderManageList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpDsOrderManageService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String title = "요청공장|요청공장코드|품목코드|품목명|주문자|주문일|수량|단위|발주일|납품요청일|입고일|입고수량|비고|제조모집단|제품확인상태|납품예정일|납품처|도안상태";
		String headers = "BYCA_COMORG_CODE|BUYER|BUYER_ITEM_NO|DESCRIPTION|PURCHASERNAME|ADD_DATE|DS_QTY|UNIT_MEASURE|PO_DATE|RD_DATE|GR_DATE|GR_QTY|REMARK|REF_NO|STATUS|DS_DATE|DELY_TO_LOCATION_TEXT|PACKAGE_STATUS";

		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"발주관리.xls");
	}
	
	
	// 부분입고	
	@RequestMapping(value = "/mpds/setGrNextMonthBuyerMpDsOrderManage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setGrNextMonthBuyerMpDsOrderManage(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = buyerMpDsOrderManageService.updateSelectedDataGrNextMonth(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 입고취소
	@RequestMapping(value = "/mpds/setGrCancelRegBuyerMpDsOrderManage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setGrCancelRegBuyerMpDsOrderManage(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = buyerMpDsOrderManageService.updateSelectedDataGrCancelReg(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 입고실적등록
	@RequestMapping(value = "/mpds/setGrRegBuyerMpDsOrderManage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setGrRegBuyerMpDsOrderManage(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = buyerMpDsOrderManageService.updateSelectedDataGrRegBuyer(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}	
}
