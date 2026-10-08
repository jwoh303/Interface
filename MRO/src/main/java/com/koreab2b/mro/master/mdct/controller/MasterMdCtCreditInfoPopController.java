package com.koreab2b.mro.master.mdct.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdct.service.MasterMdCtCreditInfoPopService;

@Controller("masterMdCtCreditInfoPopController")
public class MasterMdCtCreditInfoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtCreditInfoPopController.class);

	@Autowired
	private MasterMdCtCreditInfoPopService masterMdCtCreditInfoPopService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtCreditInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtCreditInfoPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = masterMdCtCreditInfoPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
