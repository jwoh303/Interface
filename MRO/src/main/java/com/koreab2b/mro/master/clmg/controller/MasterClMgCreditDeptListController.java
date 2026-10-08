package com.koreab2b.mro.master.clmg.controller;

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
import com.koreab2b.mro.master.clmg.service.MasterClMgCreditDeptListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterClMgCreditDeptListController")
public class MasterClMgCreditDeptListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterClMgCreditDeptListController.class);

	@Autowired
	private MasterClMgCreditDeptListService masterClMgCreditDeptListService;
	
	// 조회
	@RequestMapping(value = "/clmg/getMasterClMgCreditDeptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterClMgCreditDeptList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterClMgCreditDeptListService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/clmg/excelMasterClMgCreditDeptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterClMgCreditDeptListService.getDetailList(pMap);
		IBSheetUtil.excelOut(req, res, CommonUtil.getListNvl(_data));
	}
}
