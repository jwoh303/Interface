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
import com.koreab2b.mro.master.mpst.service.MasterMpStLogisFeeListService;

@Controller("masterMpStLogisFeeListController")
public class MasterMpStLogisFeeListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStLogisFeeListController.class);

	@Autowired
	private MasterMpStLogisFeeListService masterMpStLogisFeeListService;
	
	// 물류수수료(부서별)
	@RequestMapping(value = "/mpst/getMasterMpStLogisFeeDeptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStLogisFeeDeptList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMpStLogisFeeListService.getDeptList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 물류수수료(고객사별)
	@RequestMapping(value = "/mpst/getMasterMpStLogisFeeBuyerList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStLogisFeeBuyerList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMpStLogisFeeListService.getBuyerList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 물류수수료(사유별)
	@RequestMapping(value = "/mpst/getMasterMpStLogisFeeReasonList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStLogisFeeReasonList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMpStLogisFeeListService.getReasonList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
}
