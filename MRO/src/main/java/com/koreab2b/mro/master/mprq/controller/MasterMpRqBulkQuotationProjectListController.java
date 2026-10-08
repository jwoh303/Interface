package com.koreab2b.mro.master.mprq.controller;

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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqBulkQuotationProjectListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqBulkQuotationProjectListController")
public class MasterMpRqBulkQuotationProjectListController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBulkQuotationProjectListController.class);

	@Autowired
	private MasterMpRqBulkQuotationProjectListService MasterMpRqBulkQuotationService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqBulkQuotationProjectList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqBulkQuotationProjectList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("searchMasterMpRqQuotationBulkList 요청 파라미터 : {}", pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = MasterMpRqBulkQuotationService.getList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMpRqBulkQuotationProjectList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String, String>> _data = MasterMpRqBulkQuotationService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 프로젝트 중단
	@RequestMapping(value = "/mprq/delMasterMpRqBulkQuotationProjectList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqQuotationBulk(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("updateMasterMpRqQuotationBulk 요청 파라미터 : {}", pMap);
				 
		String rtnMsg = MasterMpRqBulkQuotationService.updateData(pMap);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Msg", rtnMsg);
		return _response;
		
	}

}
