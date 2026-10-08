package com.koreab2b.mro.master.mpst.controller;

import java.util.*;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpst.service.MasterMpStPerformanceService;
import com.koreab2b.mro.util.CommonCodeDao;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.util.StaticContextAccessor;




@Controller("masterMpStPerformanceController")
public class MasterMpStPerformanceController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpStPerformanceController.class);

	@Autowired
	private MasterMpStPerformanceService masterMpStPerformanceService;
	
	// 조회
	@RequestMapping(value = "/mpst/getMasterPerformanceList.do", method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> masterPerformanceList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMpStPerformanceService.masterPerformanceList(pMap);
		pModel.addAllAttributes(pMap);
						
		return IBSheetUtil.addResut(req, _data, pMap);
	}
}
