package com.koreab2b.mro.common.home.controller;

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

import com.koreab2b.mro.common.home.service.BuyerHomeDeptBudgetPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerHomeDeptBudgetPopController")
public class BuyerHomeDeptBudgetPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerHomeDeptBudgetPopController.class);

	@Autowired
	private BuyerHomeDeptBudgetPopService buyerHomeDeptBudgetPopService;

	// 조회
	@RequestMapping(value = "/home/getBuyerHomeDeptBudgetPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerHomeDeptBudgetPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getBuyerHomeDeptBudgetPopList 요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = buyerHomeDeptBudgetPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/home/getBuyerHomeDeptBudgetPopList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerHomeDeptBudgetPopList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getBuyerHomeDeptBudgetPopList_v2 요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = buyerHomeDeptBudgetPopService.getList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/home/excelBuyerHomeDeptBudgetPopList.do", method = RequestMethod.POST)
	public void excelList(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletResponse response, OutputStream outputStream) {

		// Excel Down을 위한 구분
		pMap.put("pageflag", "0"); 
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
				
		List<Map<String, String>> _data = buyerHomeDeptBudgetPopService.getList(pMap); 
		   	
		String title = "";
		String headers = "";
		
		title = "부서코드|부서명|예산부서|예산계정|기간구분|기간|예산금액|실적금액|임시실적금액|잔여금액|";
		headers = "DEPT|DEPT_NAME|BDGT_DEPT_NAME|ACCOUNT_TYPE_TEXT|TERM_TYPE_TEXT|TERM_TEXT|PLAN_AMT|RESULT_AMT|TEMP_AMT|BAL_AMT|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "예산조회.xls");	
		
	}
}
