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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpst.service.MasterMpStLongTermStckListService;

@Controller("masterMpStLongTermStckListController")
public class MasterMpStLongTermStckListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStLongTermStckListController.class);

	@Autowired
	private MasterMpStLongTermStckListService masterMpStLongTermStckListService;
	
	// 장기재고 조회
	@RequestMapping(value = "/mpst/getMasterMpStLongTermStckList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStLongTermStckList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpStLongTermStckListService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 장기재고 상세 팝업 조회
	@RequestMapping(value = "/mpst/getMasterMpStLongTermStckDetailPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpStLongTermStckDetailPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = masterMpStLongTermStckListService.getPopList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
		
	// 장기재고 상세 조회
	@RequestMapping(value = "/mpst/getMasterMpStLongTermStckDtList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStLongTermStckDtList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpStLongTermStckListService.getDtList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 재고현황 추이 조회
	@RequestMapping(value = "/mpst/getMasterMpStLongTermStckFlowList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStLongTermStckFlowList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpStLongTermStckListService.getFlowList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
}
