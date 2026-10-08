package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvInvoiceDetailIVPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvInvoiceDetailIVPopController")
public class CommonMpIvInvoiceDetailIVPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvInvoiceDetailIVPopController.class);

	@Autowired
	private CommonMpIvInvoiceDetailIVPopService commonMpIvInvoiceDetailIVPopService;
	
	/**
	 * 송장 상세조회 IV 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvInvoiceDetailIVPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvInvoiceDetailIVPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvInvoiceDetailIVPop.do 요청 파라미터 for jsp : {}", pMap);
		
		Map<String, String> _dataMap = commonMpIvInvoiceDetailIVPopService.getInfo(pMap);
		List<Map<String, String>> _data = commonMpIvInvoiceDetailIVPopService.getList(pMap);
		
		pModel.addAttribute("info", CommonUtil.getMapNvl(_dataMap));
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/commonMpIvInvoiceDetailIVPop";
	}	 
	
	@RequestMapping(value = "/mpiv/getCommonMpIvInvoiceDetailIVPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvInvoiceDetailIVPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, String> _dataMap = commonMpIvInvoiceDetailIVPopService.getInfo_v2(pMap);
		
		pModel.addAttribute("info", CommonUtil.getMapNvl(_dataMap)); 
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/commonMpIvInvoiceDetailIVPop_v2";
	}
	@RequestMapping(value = "/mpiv/getCommonMpIvInvoiceDetailListIVPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonMpIvInvoiceDetailListIVPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = commonMpIvInvoiceDetailIVPopService.getList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
}
