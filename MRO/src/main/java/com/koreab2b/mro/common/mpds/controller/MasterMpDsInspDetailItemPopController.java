package com.koreab2b.mro.common.mpds.controller;

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

import com.koreab2b.mro.common.mpds.service.MasterMpDsInspDetailItemPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpDsInspDetailItemPopController")
public class MasterMpDsInspDetailItemPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsInspDetailItemPopController.class);

	@Autowired
	private MasterMpDsInspDetailItemPopService masterMpDsInspDetailItemPopService;
	
	/**
	 * 검사 세부 항목 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getMasterMpDsInspDetailItemPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpDsInspDetailItemPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getBuyerMpDsInspDetailItemPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterMpDsInspDetailItemPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		return "common/popup/mpds/masterMpDsInspDetailItemPop";
	}	
	
}
