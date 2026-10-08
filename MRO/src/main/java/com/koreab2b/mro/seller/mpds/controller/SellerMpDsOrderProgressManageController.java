package com.koreab2b.mro.seller.mpds.controller;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
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

import com.koreab2b.mro.seller.mpds.service.SellerMpDsOrderProgressManageService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpDsOrderProgressManageController")
public class SellerMpDsOrderProgressManageController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsOrderProgressManageController.class);

	@Autowired
	private SellerMpDsOrderProgressManageService sellerMpDsOrderProgressManageService;
	
	// 조회
	@RequestMapping(value = "/mpds/getSellerMpDsOrderProgressManageList.do", method = RequestMethod.POST)
	public String getSellerMpDsOrderProgressManageList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpds/getSellerMpDsOrderProgressManageList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpDsOrderProgressManageService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpds/sellerMpDsOrderProgressManageList";
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpds/excelSellerMpDsOrderProgressManageList.do", method = RequestMethod.POST)
	public void excelSellerMpDsOrderProgressManage(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mpds/excelSellerMpDsOrderProgressManageList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = sellerMpDsOrderProgressManageService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String title = "공장|품목코드|품목명|납품예정일|수량|단위|발주일|납품요청일|비고(고객사)|비고(운영사)|제조모집단|제품확인상태|실적등록일|납품처|도안상태";
		String headers = "BUYER_NAME|BUYER_ITEM_NO|DESCRIPTION|DS_DATE|DS_QTY|UNIT_MEASURE|PO_DATE|RD_DATE|B_REMARK|A_REMARK|REF_NO|STATUS|DI_DATE|DELY_TO_LOCATION_TEXT|PACKAGE_STATUS";

		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"발주진행관리.xls");
		 
	}
	

	//  납품실적등록
	@RequestMapping(value = "/mpds/setDiRegSellerMpDsOrderProgressManage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setDiRegSellerMpDsOrderProgressManage(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = sellerMpDsOrderProgressManageService.updateSelectedDataDiReg(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 납품실적취소	
	@RequestMapping(value = "/mpds/setDiCancelRegSellerMpDsOrderProgressManage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setDiCancelRegSellerMpDsOrderProgressManage(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = sellerMpDsOrderProgressManageService.updateSelectedDataDiCancel(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 거래명세서삭제
	@RequestMapping(value = "/mpds/setIvCancelRegSellerMpDsOrderProgressManage.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setIvCancelRegSellerMpDsOrderProgressManage(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = sellerMpDsOrderProgressManageService.updateSelectedDataIvCancel(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}		
}
