package com.koreab2b.mro.master.mpst.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpst.service.MasterMpStAgingService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpStAgingController")
public class MasterMpStAgingController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStAgingController.class);
	
	@Autowired
	private MasterMpStAgingService masterMpStAgingService;

	// 장기재고 조회
	@RequestMapping(value = "/mpst/getMasterMpStAgingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStAgingList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		pMap.put("st_yyyymm", pMap.get("st_from_date").toString().replaceAll("/", "") );
		
		List<Map<String,String>> _data = masterMpStAgingService.getAgingList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
	
	@RequestMapping(value = "/mpst/getMasterMpStAgingPopup.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String showMasterMpStAgingPopup(ModelMap pModel, @RequestParam Map<String, String> pMap) { 
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpStAgingService.getAgingItemMaster(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		return "master/mpst/masterMpStAgingPop";
	}
	
	// getMasterMpStAgingPopup
	// 장기재고 조회
	@RequestMapping(value = "/mpst/getMasterMpStAgingPopupDT.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMpStAgingPopup(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
	
		List<Map<String,String>> _data = masterMpStAgingService.getAgingDetail(pMap);

		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpst/excelMasterMpStAgingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMpStAgingList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		
		pMap.put("st_yyyymm", pMap.get("st_from_date").toString().replaceAll("/", "") );
		
		List<Map<String,String>> _data = masterMpStAgingService.getAgingList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}	
}
