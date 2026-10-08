package com.koreab2b.mro.master.mpiv.controller;

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
import com.koreab2b.mro.master.mpiv.service.MasterMpIvDeliveryDelayListService;

@Controller("masterMpIvDeliveryDelayListController")
public class MasterMpIvDeliveryDelayListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvDeliveryDelayListController.class);

	@Autowired
	private MasterMpIvDeliveryDelayListService masterMpIvDeliveryDelayListService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getMasterMpIvDeliveryDelayList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpIvDeliveryDelayList(HttpServletRequest pReq, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMpIvDeliveryDelayListService.getList(pMap);
		
		return IBSheetUtil.addResut(pReq, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpiv/excelMasterMpIvDeliveryDelayList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void excelMasterMpIvDeliveryDelayList(HttpServletRequest pReq, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
			
		List<Map<String,String>> _data = masterMpIvDeliveryDelayListService.getList(pMap);
		IBSheetUtil.excelOut(pReq, pRes , _data);
	}	
}
