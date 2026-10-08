package com.koreab2b.mro.master.cmcl.controller;


import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

import com.koreab2b.mro.master.cmcl.service.MasterCmClLogisRateDetailService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClLogisRateDetailController")
public class MasterCmClLogisRateDetailController {

	@Autowired
	private MasterCmClLogisRateDetailService masterCmClLogisRateDetailService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClLogisRateDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClLogisRateDetailList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClLogisRateDetailService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/cmcl/getMasterCmClLogisRateDetailList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClLogisRateDetailList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClLogisRateDetailService.getList_v2(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClLogisRateDetailList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);		
		List<Map<String,String>> _data = masterCmClLogisRateDetailService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	@RequestMapping(value = "/cmcl/excelMasterCmClLogisRateDetailList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList_v2(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);		
		List<Map<String,String>> _data = masterCmClLogisRateDetailService.getList_v2(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	
}
