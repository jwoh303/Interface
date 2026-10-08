package com.koreab2b.mro.buyer.mprq.controller;

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

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqQuotaProceStateAdminService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqQuotaProceStateAdminController")
public class BuyerMpRqQuotaProceStateAdminController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqQuotaProceStateAdminController.class);

	@Autowired
	private BuyerMpRqQuotaProceStateAdminService buyerMpRqQuotaProceStateAdminService;
	
	// 조회
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotaProceStateAdmin.do", method = RequestMethod.POST)
	public String getBuyerMpRqQuotaProceStateAdmin(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		LOGGER.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 

		List<Map<String, String>> _data = buyerMpRqQuotaProceStateAdminService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mprq/buyerMpRqQuotaProceStateAdminList";
	}
	

	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerAdminExcelDown.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		String filename = "진행상태조회_" + pMap.get("st_from_date") + "_" + pMap.get("st_to_date") + ".xls";
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateAdminService.getList(pMap);
		//SLOGIC-BEGIN(P04-4026-09)
		String title = "";
		String headers = "";
		if (pMap.get("st_buyer").equals("KRHWAS0031")) {
			title = "견적번호|순번|진행상태|품목코드|견적의뢰일|회신요청일|품목명|규격|수량|단위|제조사|원산지|견적단가|Nego단가|협력사|KeP담당자|요청자|요청부서|카테고리|";
			headers = "QUOTATION_NO|QUOTATION_SEQ|SOURCING_STATUS|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|MAKER_NAME|ORIGIN_NAME|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|AGENT_NAME|KEP_USER_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|BUYER_CATEG_PATH|";
		} else {
			title = "견적번호|순번|진행상태|품목코드|견적의뢰일|회신요청일|품목명|규격|수량|단위|제조사|원산지|견적단가|Nego단가|협력사|KeP담당자|요청자|요청부서|비고|";
			headers = "QUOTATION_NO|QUOTATION_SEQ|SOURCING_STATUS|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|MAKER_NAME|ORIGIN_NAME|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|AGENT_NAME|KEP_USER_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|BTOA_REMARK|";
		}
		//SLOGIC-END
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,filename);
	}
	
	// 신규품목 등록현황조회
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotaSourcAdmin.do", method = RequestMethod.POST)
	public String getBuyerMpRqQuotaSourcAdmin(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		// 화면 조회
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateAdminService.getSourcList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "buyer/mprq/buyerMpRqQuotaSourcList";
	}


	/**
	 * 신규품목현황EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotaSourcExcelDown.do", method = RequestMethod.POST)
	public void getBuyerMpRqQuotaSourcExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		String filename = "신규품목현황.xls";
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateAdminService.getSourcList(pMap);
		String title = "";
		String headers = "";
		title = "표준품명|품목코드|품목명|규격|단가|단위|제조사|협력사|원산지|수정일|진행상태|등록자명|카테고리번호|고객사코드|청구자명|카테고리경로|";
		headers = "CATEGORY_TEXT|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_PRICE|UNIT_MEASURE|MAKER_NAME|AGENT_NAME|ORIGIN_NAME|ADD_DATE|ITEM_STATUS|ADD_USER_NAME|CATEGORY_NO|BUYER|BTOA_USER_NAME|CATEG_PATH|";
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,filename);
	}
	/**
	 * 신규품목현황EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotaNewPoExcelDown.do", method = RequestMethod.POST)
	public void getBuyerMpRqQuotaNewPoExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		String filename = "신규발주현황.xls";
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateAdminService.getNewPoList(pMap);
		String title = "";
		String headers = "";
		title = "고객사명|진행상태|발주구분|두산발주번호|두산발주항번|발주번호|발주항번|견적번호|견적항번|협력사명|품목코드|발주일|입고일|납기요청일|납기예정일|송장생성일|납품확정일|품목명|규격|제조사|단위|발주수량|입고수량|송장수량|납품확정수량|매출단가|발주금액|입고금액|요청자|요청부서|협력사코드|사업자등록번호|계약번호|계약서항번|고객사코드|요청부서코드|카탈로그관리코드|카테고리ID|카테고리명|카테고리경로|";
		headers = "BUYER_NAME|STATUS_TEXT|PO_GBN|LEGACY_PO_NO|LEGACY_PO_SEQ|PO_NO|PO_SEQ|QUOTATION_NO|QUOTATION_SEQ|AGENT_NAME|BUYER_ITEM_NO|PO_DATE|GR_DATE|RD_DATE|DS_DATE|INVOICE_DATE|DELIVERY_DATE|DESCRIPTION|SPECIFICATION|MAKER_NAME|UNIT_MEASURE|ITEM_QTY|GR_QTY|INV_QTY|DELIVERY_QTY|UNIT_PRICE|PO_ITEM_AMT|GR_ITEM_AMT|PO_USER_NAME|REQ_DEPT_NAME|AGENT_CODE|IRS_NO|CONTRACT_NO|CONTRACT_SEQ|BUYER|REQ_DEPT_CODE|BYIT_COMORG_CODE|BUYER_CATEGORY_NO|BUYER_CATEG_NAME|BUYER_CATEG_PATH|";
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,filename);
	}
}
