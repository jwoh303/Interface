package com.koreab2b.mro.common.wmgr.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.wmgr.service.MasterWmGrTrOrderManagerPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmGrTrOrderManagerPopController")
public class MasterWmGrTrOrderManagerPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrTrOrderManagerPopController.class);

	@Autowired
	private MasterWmGrTrOrderManagerPopService masterWmGrTrOrderManagerPopService;
	
	/**
	 * tr 발주조회 및 삭제 조회
	 * @param pModel
	 * @param pMap 
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getMasterWmGrTrOrderManagerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterWmGrTrOrderManagerPop(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterWmGrTrOrderManagerPopService.getList(pMap);
		//return IBSheetUtil.addResut(req, _data , pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	
	// 조회
	@RequestMapping(value = "/wmgr/showMasterWmGrTrOrderGrRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrTrOrderGrRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterWmGrTrOrderManagerPopService.getPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmgr/masterWmGrTrOrderManagerPop";
	}
	
	
}
