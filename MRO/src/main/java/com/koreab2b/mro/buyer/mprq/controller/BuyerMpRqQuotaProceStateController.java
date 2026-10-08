package com.koreab2b.mro.buyer.mprq.controller;

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

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqQuotaProceStateService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqQuotaProceStateController")
public class BuyerMpRqQuotaProceStateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqQuotaProceStateController.class);

	@Autowired
	private BuyerMpRqQuotaProceStateService buyerMpRqQuotaProceStateService;
	
	// 조회
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotaProceState.do", method = RequestMethod.POST)
	public String getBuyerMpRqQuotaProceState(ModelMap pModel,  HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		LOGGER.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//펀치아웃관리자 체크
		boolean getCodeM145 = CommonUtil.getCodeCheckReturn("M145",_sessionInfo.getUserId());
		//펀치아웃관리자체크여부
		if(getCodeM145 == true){
			pMap.put("st_adminPcoGbn", "Y");
		}else{
			pMap.put("st_adminPcoGbn", "N");
		}
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mprq/buyerMpRqQuotaProceStateList";
	}
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotaProceState_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpRqQuotaProceState_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateService.getList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	@RequestMapping(value = "/mprq/getBuyerMpRqQuotaProceState2_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpRqQuotaProceState2_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateService.getList_tab2_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장(장바구니 담기)
	@RequestMapping(value = "/mprq/saveBuyerMpRqQuotaProceState.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqQuotaProceState(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		LOGGER.debug("saveBuyerMpRqQuotaProceState MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMpRqQuotaProceStateService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}

	// 견적삭제
	@RequestMapping(value = "/mprq/deleteBuyerMpRqQuotaProceState.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteBuyerMpRqQuotaProceState(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		LOGGER.debug("saveBuyerMpRqQuotaProceState MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMpRqQuotaProceStateService.deleteSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	/**
	 * EXCEL 다운로드 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerExcelDown.do", method = RequestMethod.POST)
	public void getExcelDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		String filename = "진행상태조회_" + pMap.get("st_from_date") + "_" + pMap.get("st_to_date") + ".xls";
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateService.getList(pMap);
		//SLOGIC-BEGIN(P04-4026-09)
		String title = "";
		String headers = "";
		if (pMap.get("st_buyer").equals("KRHWAS0031")) {
			title = "견적번호|순번|진행상태|품목코드|견적의뢰일|회신요청일|품목명|규격|수량|단위|제조사|원산지|견적단가|Nego단가|협력사|KeP담당자|요청자|요청부서|카테고리|";
			headers = "QUOTATION_NO|QUOTATION_SEQ|SOURCING_STATUS|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|MAKER_NAME|ORIGIN_NAME|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|AGENT_NAME|KEP_USER_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|BUYER_CATEG_PATH|";
		} else  if (pMap.get("st_buyer").equals("KRCELL0008") || pMap.get("st_buyer").equals("KRCELL0009") || pMap.get("st_buyer").equals("KRCELL0010")) { // 셀트리온 중서부사업팀 네고내역 추가 20180405 by HSJ
			title = "고객사|견적번호|순번|진행상태|품목코드|견적의뢰일|회신요청일|품목명|규격|수량|단위|제조사|원산지|견적단가|Nego단가|협력사|KeP담당자|요청자|요청부서|고객사비고|운영사비고|Nego차수|고객사Nego단가이력|Nego제출단가이력|";
			headers = "COM_NAME_LOC|QUOTATION_NO|QUOTATION_SEQ|SOURCING_STATUS|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|MAKER_NAME|ORIGIN_NAME|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|AGENT_NAME|KEP_USER_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|BTOA_REMARK|ATOB_REMARK|NEGO_SEQ|NEGO_BTOA_NEGO_PRICE|NEGO_ATOB_UNIT_PRICE|";
		}else {
			title = "고객사|견적번호|순번|진행상태|품목코드|견적의뢰일|회신요청일|품목명|규격|수량|단위|제조사|원산지|견적단가|Nego단가|협력사|KeP담당자|요청자|요청부서|고객사비고|운영사비고|선입고여부";
			headers = "COM_NAME_LOC|QUOTATION_NO|QUOTATION_SEQ|SOURCING_STATUS|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|MAKER_NAME|ORIGIN_NAME|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|AGENT_NAME|KEP_USER_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|BTOA_REMARK|ATOB_REMARK|PRE_GR_FLAG|";
		}
		//SLOGIC-END
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,filename);
	}
	/**
	 * EXCEL 상세 다운로드 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getBuyerExcelDetailDown.do", method = RequestMethod.POST)
	public void getBuyerExcelDetailDown(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		LOGGER.debug("getExcelDown 요청 파라미터 for jsp : {}", pMap);
		
		pMap = CommonUtil.PagingPrc(pMap);
		pMap.put("paging", "0"); // Excel Down을 위한 구분
		String filename = "진행상태상세조회_" + pMap.get("st_from_date") + "_" + pMap.get("st_to_date") + ".xls";
		List<Map<String, String>> _data = buyerMpRqQuotaProceStateService.getDetailList(pMap);
		//SLOGIC-BEGIN(P04-4026-09)
		String title = "";
		String headers = "";
		String p170000002 = CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(pMap.get("st_buyer"),"P17-0000002","COL01_DATA"),"");
				
		if (p170000002.equals("TYPE01")) {
			title = "견적번호|순번|진행상태|품목코드|견적의뢰일|회신요청일|품목명|규격|수량|단위|제조사|원산지|견적단가|Nego단가|입찰협력사|선정여부|KeP담당자|요청자|요청부서|카테고리|";
			headers = "QUOTATION_NO|QUOTATION_SEQ|SOURCING_STATUS|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|MAKER_NAME|ORIGIN_NAME|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|AGENT_NAME|BID_SUCCESS_FLAG|KEP_USER_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|BUYER_CATEG_PATH|";
		}else {
			title = "견적번호|순번|진행상태|품목코드|견적의뢰일|회신요청일|품목명|규격|수량|단위|제조사|원산지|견적단가|Nego단가|입찰협력사|선정여부|KeP담당자|요청자|요청부서|카테고리|";
			headers = "QUOTATION_NO|QUOTATION_SEQ|SOURCING_STATUS|BUYER_ITEM_NO|BTOA_DATE|BTOA_END_DATE|DESCRIPTION|SPECIFICATION|ITEM_QTY|UNIT_MEASURE|MAKER_NAME|ORIGIN_NAME|ATOB_UNIT_PRICE|BTOA_NEGO_PRICE|AGENT_NAME|BID_SUCCESS_FLAG|KEP_USER_NAME|BTOA_USER_NAME|BTOA_USER_DEPT|BUYER_CATEG_PATH|";			
		}
		//SLOGIC-END
		String excelHeader = title +"@@"+headers;		
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,filename);
	}
	
	// 저장(장바구니 담기) _v2
	@RequestMapping(value = "/mprq/saveBuyerMpRqQuotaProceState_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqQuotaProceState_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 회사코드 : {}", _sessionInfo.getUserId());		
		pMap.put("st_buyer", _sessionInfo.getComCode()); // 고객사코드 
		
		LOGGER.debug("saveBuyerMpRqQuotaProceState 요청 파라미터 : {}", pMap); 
		
		String flag = buyerMpRqQuotaProceStateService.updateSelectedData_v2(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
}
