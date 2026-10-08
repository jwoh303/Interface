package com.koreab2b.mro.buyer.mdam.controller;

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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmDepartmentAccountService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmDepartmentAccountController")
public class BuyerMdAmDepartmentAccountController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmDepartmentAccountController.class);

	@Autowired
	private BuyerMdAmDepartmentAccountService buyerMdAmDepartmentAccountService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmDepartmentAccountList.do", method = RequestMethod.POST)
	public String getBuyerMdAmDepartmentAccountList(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdam/getBuyerMdAmDepartmentAccountList.do 요청 파라미터 : {}", pMap);

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
		List<Map<String, String>> _data = buyerMdAmDepartmentAccountService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		pModel.addAllAttributes(pMap);
		
		return "buyer/mdam/buyerMdAmDepartmentAccountList";
	}
	
	@RequestMapping(value = "/mdam/getBuyerMdAmDepartmentAccountList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmDepartmentAccountList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getBuyerMdAmDepartmentAccountList_v2 요청 파라미터 : {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		// 화면 조회
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = buyerMdAmDepartmentAccountService.getBuyerMdAmDepartmentAccountList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmDepartmentAccountList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmDepartmentAccount(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = buyerMdAmDepartmentAccountService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetDepartmentAccountListPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMdAmBudgetDepartmentAccountListPop_v2(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		return "buyer/mdam/buyerMdAmBudgetDepartmentAccountListPop_v2";
	}
	
	@RequestMapping(value = "/mdam/saveBuyerMdAmBudgetDepartmentAccountListPop_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmBudgetDepartmentAccountListPop_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = buyerMdAmDepartmentAccountService.saveBuyerMdAmBudgetDepartmentAccountListPop_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("저장하였습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	@RequestMapping(value = "/mdam/delBuyerMdAmBudgetDepartmentAccountList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBuyerMdAmBudgetDepartmentAccountList_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = buyerMdAmDepartmentAccountService.delBuyerMdAmBudgetDepartmentAccountList_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("삭제하였습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
}
