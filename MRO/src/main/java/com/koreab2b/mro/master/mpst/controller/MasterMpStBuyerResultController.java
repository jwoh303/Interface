package com.koreab2b.mro.master.mpst.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpst.service.MasterMpStBuyerResultService;

@Controller("masterMpStBuyerResultController")
public class MasterMpStBuyerResultController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStBuyerResultController.class);

	@Autowired
	private MasterMpStBuyerResultService masterMpStBuyerResultService;
	
	// 조회
	@RequestMapping(value = "/mpst/getMasterMpStBuyerResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStBuyerResultList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStBuyerResultService.getList(pMap);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpst/excelMasterMpStBuyerResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
//		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpStBuyerResultService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 고객사 SG별 실적조회
	@RequestMapping(value = "/mpst/getMasterMpStBuyerSgResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void getMasterMpStBuyerSgResultList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMpStBuyerResultService.getBuyerSgList(pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	// 협력사 SG별 실적조회
	@RequestMapping(value = "/mpst/getMasterMpStAgentSgResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void getMasterMpStAgentSgResultList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMpStBuyerResultService.getAgentSgList(pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
}
