package com.koreab2b.mro.seller.mprq.controller;

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

import com.koreab2b.mro.seller.mprq.service.SellerMpRqQuotaProceStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpRqQuotaProceStateController")
public class SellerMpRqQuotaProceStateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SellerMpRqQuotaProceStateController.class);

	@Autowired
	private SellerMpRqQuotaProceStateService sellerMpRqQuotaProceStateService;
	
	
	/**
	 * 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getSellerMpRqQuotaProceState.do", method = RequestMethod.POST)
	public String getSellerMpRqQuotaProceState(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("sellerMpRqEstiReq 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpRqQuotaProceStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mprq/sellerMpRqQuotaProceStateList";
	}	

	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getExcelDown.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		String filename = "제출견적진행상태_" + pMap.get("st_from_date") + "_" + pMap.get("st_to_date") + ".xls";
		List<Map<String, String>> _data = sellerMpRqQuotaProceStateService.getList(pMap); 
		
		String title = "견적번호|관리번호|순번|차수|진행상태|품목코드|견적요청일|견적마감일|품목명|규격|제조사|원산지|수량|단위|제출단가|조달일수|KeP담당자|MOQ|발주배수|거래유형|과세구분|품목구분|";
		String headers = "QUOTATION_NO|REF_NO|QUOTATION_SEQ|AGENT_REVISION|AGENT_SOURCING_STATUS|BUYER_ITEM_NO|ATOS_DATE2|ATOS_END_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|ORIGIN_NAME|ITEM_QTY|UNIT_MEASURE|STOA_LIST_PRICE|LEAD_TIME|BTOA_USER_NAME|MIN_ORDER_QTY|PUR_UNIT_QTY|PROCESS_NM|TAX_TYPE|ITEM_MAKE_TYPE|";
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,filename);
	}

	// 저장
	@RequestMapping(value = "/mprq/saveSellerMpRqQuotaProceState.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveSellerMpRqQuotaProceState(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpRqQuotaProceStateService.saveSellerMpRqQuotaProceState(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
}
