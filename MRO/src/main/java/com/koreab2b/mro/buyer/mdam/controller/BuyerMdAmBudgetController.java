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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmBudgetService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmBudgetController")
public class BuyerMdAmBudgetController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetController.class);

	@Autowired
	private BuyerMdAmBudgetService buyerMdAmBudgetService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetList.do", method = RequestMethod.POST)
	public String getBuyerMdAmBudgetList(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdam/getBuyerMdAmBudgetList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdAmBudgetService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		return "buyer/mdam/buyerMdAmBudgetList";
	}
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmBudgetList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getBuyerMdAmBudgetList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		List<Map<String,String>> _data = buyerMdAmBudgetService.getBuyerMdAmBudgetList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmBudgetList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmBudget(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdam/saveBuyerMdAmBudgetList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMdAmBudgetService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mdam/excelBuyerMdAmBudgetList.do", method = RequestMethod.POST)
	public void excelBuyerMdAmBudget( HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mdam/excelBuyerMdAmBudgetList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		List<Map<String, String>> _data = buyerMdAmBudgetService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "고객사코드|고객사명|예산부서코드|예산부서명|계정분류|기간구분|기간|예산|실적금액|임시실적금액|잔액|비고|예산수립일|최종실적발생일";
		String headers = "BUYER|BUYER_NAME|DEPT|DEPT_NAME|ACCOUNT_TYPE_TEXT|TERM_TYPE_TEXT|TERM_TEXT|PLAN_AMT|RESULT_AMT|TEMP_AMT|TEMP_AMT_TEXT|REMARK|PLAN_DATE|LAST_RESULT_DATE";
		
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"예산조회목록.xls");
	}
	
	// 이력 상세 다운로드	
	@RequestMapping(value = "/mdam/excelBuyerMdAmBudgetHistList.do", method = RequestMethod.POST)
	public void excelBuyerMdAmBudgetHist(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletResponse response, OutputStream outputStream){
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		List<Map<String, String>> _data = buyerMdAmBudgetService.getHistList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		String title = "기간구분|기간|순번|예산부서코드|예산부서|계정코드|계정정보|변경전 예산금액|변경 예산금액|변경후 예산금액|비고|수정자ID|수정자명|예산변경일시";
		String headers = "TERM_TYPE_TEXT|TERM_TEXT|REVISION|DEPT|DEPT_NAME|ACCOUNT_TYPE|ACCOUNT_TYPE_TEXT|BEFORE_AMT|CHANGE_AMT|AFTER_AMT|REMARK|ADD_USER_ID|ADD_USER_NAME|ADD_DATE";
		
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"예산상세이력.xls");
	}
	
	@RequestMapping(value = "/mdam/excelBuyerMdAmBudgetHistList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> excelBuyerMdAmBudgetHistList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("excelBuyerMdAmBudgetHistList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		List<Map<String,String>> _data = buyerMdAmBudgetService.excelBuyerMdAmBudgetHistList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
