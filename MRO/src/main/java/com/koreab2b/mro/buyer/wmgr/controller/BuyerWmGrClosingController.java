package com.koreab2b.mro.buyer.wmgr.controller;

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

import com.koreab2b.mro.buyer.wmgr.service.BuyerWmGrClosingService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerWmGrClosingController")
public class BuyerWmGrClosingController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerWmGrClosingController.class);

	@Autowired
	private BuyerWmGrClosingService buyerWmGrClosingService;
	
	// 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrClosingList.do", method = RequestMethod.POST)
	public String getBuyerWmGrClosingList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/wmgr/getBuyerWmGrClosingList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// xss replace 필터
		pMap = CommonUtil.xss_kep_filter(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerWmGrClosingService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/wmgr/buyerWmGrClosingList";
	}
	
	@RequestMapping(value = "/wmgr/getBuyerWmGrClosingList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrClosingList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = CommonUtil.xss_kep_filter_v2(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerWmGrClosingService.getList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// [v2] AR 요약 목록 조회 (Tab1 마감현황)
	@RequestMapping(value = "/wmgr/getBuyerWmGrClosingArSummaryList_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrClosingArSummaryList_v2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		pMap = CommonUtil.removeSlash(pMap);
		List<Map<String, String>> _data = buyerWmGrClosingService.getArSummaryList(pMap);

		Map<String, Object> result = new java.util.HashMap<String, Object>();
		result.put("data", CommonUtil.getListNvl(_data));
		result.put("total", _data != null ? _data.size() : 0);
		return result;
	}

	// [v2] AR 상세 팝업 - 데이터 조회
	@RequestMapping(value = "/wmgr/getBuyerWmGrClosingArDetailPop_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerWmGrClosingArDetailPop_v2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		pMap = CommonUtil.removeSlash(pMap);
		List<Map<String, String>> _data = buyerWmGrClosingService.getArDetailList(pMap);
		Map<String, String> _header = buyerWmGrClosingService.getArHeaderInfo(pMap);

		Map<String, Object> result = new java.util.HashMap<String, Object>();
		result.put("data", CommonUtil.getListNvl(_data));
		result.put("header", _header);
		result.put("total", _data != null ? _data.size() : 0);
		return result;
	}

	// [v2] AR 상세 팝업 - 화면 호출
	@RequestMapping(value = "/wmgr/showBuyerWmGrClosingArDetailPop.do", method = RequestMethod.GET)
	public String showBuyerWmGrClosingArDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		pModel.addAllAttributes(pMap);
		return "/common/popup/wmgr/buyerWmGrClosingArDetailPop_v2";
	}

	// EXCEL 다운로드
	@RequestMapping(value = "/wmgr/excelBuyerWmGrClosingList.do", method = RequestMethod.POST)
	public void excelBuyerWmGrClosing(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream
			, HttpServletRequest req) {
		//logger.debug("/wmgr/excelBuyerWmGrClosingList.do 요청 파라미터 for jsp : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String buyer = _sessionInfo.getComCode();
	    String p070000021 = CommonUtil.getSpecialCheckReturn(buyer,"P07-0000021","COL01_DATA");
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerWmGrClosingService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "";
		String headers = "";
		if("TYPE1".equals(p070000021)){
			title = "주문번호|발주번호|주문일|발주일|품목코드|입고일|품목명|규격|단가|입고금액|단위|발주수량|입고수량|협력사명|상태|요청부서코드|요청부서|요청자|고객사카테고리대분류|고객사카테고리중분류|고객사카테고리소분류|";
			headers = "PX_NO|PO_NO|CHANGE_DATE|PO_CREATE_DATE|BUYER_ITEM_NO|GR_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|UNIT_MEASURE|PO_ITEM_QTY|GR_ITEM_QTY|AGENT_NAME|CLOSE_STATUS|CHANGE_USER_DEPT|REQ_DEPT_NAME|REQ_USER_NAME|CATEG_NAME1|CATEG_NAME2|CATEG_NAME3|";
		}else if("TYPE2".equals(p070000021)){
			title = "주문번호|요청번호|관리번호|발주번호|입고번호|주문일|발주일|품목코드|입고일|품목명|규격|단가|입고금액|단위|발주수량|입고수량|입고총수량|협력사명|상태|BUYER|귀속부서|관장부서|계정|세금|국세청번호|";
			headers = "PX_NO|PR_NO|REF_PR_NO|PO_NO|GR_NO|CHANGE_DATE|PO_CREATE_DATE|BUYER_ITEM_NO|GR_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|UNIT_MEASURE|PO_ITEM_QTY|GR_ITEM_QTY|GR_QTY|AGENT_NAME|CLOSE_STATUS|BUYER|PR_REF_PR_NO1|PR_REF_PR_NO2|PR_REF_PR_NO3|PR_REF_PR_NO4|ISSUE_ID|";
		}else if("TYPE3".equals(p070000021)){
			title = "구매요청일자|구매요청번호|발주일자|발주번호|입고일자|진행상태|거래유형|품목코드|품목명|규격|단위|제조사|입고수량|입고단가|입고금액|요청부서|요청자사번|요청자명|결재경로|예산부서명|계정명|관리번호|";
			headers = "CHANGE_DATE|PR_NO|PO_CREATE_DATE|PO_NO|GR_DATE|CLOSE_STATUS|PROCESS_TYPE_NM|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|MAKER_NAME|GR_ITEM_QTY|UNIT_PRICE|ITEM_AMT|REQ_DEPT_NAME|CHANGE_USER_ID|REQ_USER_NAME|APRV_PATH|BUDGET_DEPT_NM|ACCOUNT_TYPE_NM|REF_PR_NO|";
		}else{
			title = "주문번호|요청번호|관리번호|발주번호|입고번호|주문일|발주일|품목코드|입고일|품목명|규격|단가|입고금액|단위|발주수량|입고수량|입고총수량|협력사명|상태|BUYER|발주금액|마감수량|마감금액|녹색구매제품";
			headers = "PX_NO|PR_NO|REF_PR_NO|PO_NO|GR_NO|CHANGE_DATE|PO_CREATE_DATE|BUYER_ITEM_NO|GR_DATE|DESCRIPTION|SPECIFICATION|UNIT_PRICE|ITEM_AMT|UNIT_MEASURE|PO_ITEM_QTY|GR_ITEM_QTY|GR_QTY|AGENT_NAME|CLOSE_STATUS|BUYER|PO_ITEM_AMT|AR_ITEM_QTY|AR_ITEM_AMT|BUY_GREEN_ITEM_NM";
		}		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "마감조회.xls");
		 
	}
}
