package com.koreab2b.mro.master.mpsm.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpsm.service.MasterMpSmClosingStatsService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSmClosingStatsController")
public class MasterMpSmClosingStatsController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSmClosingStatsController.class);
	
	@Autowired
	private MasterMpSmClosingStatsService masterMpSmClosingStatsService;
	
	// 조회
	@RequestMapping(value = "/mpsm/getMasterMpSmClosingStatsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSmClosingStatsList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSmClosingStatsService.getClosingStatsList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 차트용 그리드 조회
	@RequestMapping(value = "/mpsm/getMasterMpSmClosingStatsList1.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSmClosingStatsList1(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSmClosingStatsService.getClosingStatsList1(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mpsm/excelMasterMpSmClosingStatsList.do", method = RequestMethod.POST)
	public void excelMasterMpSmClosingStatsList(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletResponse response, OutputStream outputStream) {

		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
				
		List<Map<String, String>> _data = masterMpSmClosingStatsService.getClosingStatsList(pMap); 
		   	
		String title = "";
		String headers = "";
		String header_text1 = "";
		String header_text2 = "";
		String header_text3 = "";
		
		header_text1 = CommonUtil.nvl((String)  pMap.get("st_header_text1"));
		header_text2 = CommonUtil.nvl((String)  pMap.get("st_header_text2"));
		header_text3 = CommonUtil.nvl((String)  pMap.get("st_header_text3"));
		
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		
		title = "고객사|부서코드|부서명|계정코드|계정명|" + header_text1 + "|주문건수|금액|비중(%)|전월증감(%)|전년증감(%)|" + header_text2 + "|" + header_text3 + "|";
		headers = "BUYER|DEPT|DEPT_NAME|ACCOUNT_TYPE|ACCOUNT_NAME|SUM_AMT|PO_CNT|AMT|RATE|BF_M_INCR_RATE|BF_Y_INCR_RATE|BF_M_AMT|BF_Y_AMT|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "마감현황.xls");	
		
	}
}
