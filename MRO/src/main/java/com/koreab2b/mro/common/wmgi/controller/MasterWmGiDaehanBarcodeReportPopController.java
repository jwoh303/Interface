package com.koreab2b.mro.common.wmgi.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmgi.service.MasterWmGiDaehanBarcodeReportPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGiDaehanBarcodeReportPopController")
public class MasterWmGiDaehanBarcodeReportPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiDaehanBarcodeReportPopController.class);

	@Autowired
	private MasterWmGiDaehanBarcodeReportPopService masterWmGiDaehanBarcodeReportPopService;
	
	/**
	 * 대한제강 바코드 출력 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgi/getMasterWmGiDaehanBarcodeReportPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGiDaehanBarcodeReportPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGiDaehanBarcodeReportPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
}
