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
import com.koreab2b.mro.master.mdct.service.MasterMdCtCreditDeptPopService;

@Controller("masterMdCtCreditDeptPopController")
public class MasterMdCtCreditDeptPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtCreditDeptPopController.class);

	@Autowired
	private MasterMdCtCreditDeptPopService masterMdCtCreditDeptPopService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtCreditDeptPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtCreditDeptPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		List<Map<String,String>> _data = masterMdCtCreditDeptPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
