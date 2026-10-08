package com.koreab2b.mro.master.mpso.controller;

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
import com.koreab2b.mro.master.mpso.service.MasterMpSoMonthClosingInfoService;

@Controller("masterMpSoMonthClosingInfoController")
public class MasterMpSoMonthClosingInfoController {

	@Autowired
	private MasterMpSoMonthClosingInfoService masterMpSoMonthClosingInfoService;
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoMonthClosingInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoMonthClosingInfoList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSoMonthClosingInfoService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpso/excelMasterMpSoMonthClosingInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoMonthClosingInfoService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
}
