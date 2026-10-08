package com.koreab2b.mro.master.mdam.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdam.service.MasterMdAmMsdsService;

@Controller("masterMdAmMsdsController")
public class MasterMdAmMsdsController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmMsdsController.class);

	@Autowired
	private MasterMdAmMsdsService masterMdAmMsdsService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmMsdsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMsdsList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdAmMsdsService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdam/getMasterMdAmMsdsExcelList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdAmMsdsService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
}
