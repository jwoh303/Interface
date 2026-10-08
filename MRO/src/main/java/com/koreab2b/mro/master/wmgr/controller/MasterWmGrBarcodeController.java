package com.koreab2b.mro.master.wmgr.controller;

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
import com.koreab2b.mro.master.wmco.service.MasterWmCoMgService;
import com.koreab2b.mro.master.wmgr.service.MasterWmGrBarcodeService;

@Controller("masterWmGrBarcodeController")
public class MasterWmGrBarcodeController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrBarcodeController.class);

	@Autowired
	private MasterWmGrBarcodeService masterWmGrBarcodeService;
	
	@Autowired
	private MasterWmCoMgService masterWmCoMgService;

	// 조회
	@RequestMapping(value = "/wmgr/getMasterWmGrBarcodeList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmGrBarcodeList(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterWmGrBarcodeService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
		//req.setAttribute("SHEETDATA", _data);
		//new IBSheetUtil().getXml(req, pRes);	
	}

	// 엑셀다운로드
	@RequestMapping(value = "/wmgr/excelMasterWmGrBarcodeList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){

		
		//페이징용 파라미터의 셋팅
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterWmGrBarcodeService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
}
