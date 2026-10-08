package com.koreab2b.mro.common.wmgr.controller;

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

import com.koreab2b.mro.common.wmgr.service.MasterWmGrLegacyNoPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGrLegacyNoPopController")
public class MasterWmGrLegacyNoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrLegacyNoPopController.class);

	@Autowired
	private MasterWmGrLegacyNoPopService masterWmGrLegacyNoPopService;
	
	/**
	 * LEGACY_NO 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getMasterWmGrLegacyNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGrLegacyNoPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGrLegacyNoPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	@RequestMapping(value = "/wmgr/showMasterWmGrLegacyNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrLegacyNoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/wmgr/showMasterWmGrLegacyNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterWmGrLegacyNoPopService.getDetail(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/wmco/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmgr/masterWmGrLegacyNoPop";
	}	
	
}
