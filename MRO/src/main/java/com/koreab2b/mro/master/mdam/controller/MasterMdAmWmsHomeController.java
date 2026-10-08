package com.koreab2b.mro.master.mdam.controller;

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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdam.service.MasterMdAmWmsHomeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmWmsHomeController")
public class MasterMdAmWmsHomeController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmWmsHomeController.class);

	@Autowired
	private MasterMdAmWmsHomeService masterMdAmWmsHomeService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmWmsHome.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterMdAmWmsHomeList(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("/mdam/getMasterMdAmWmsHome.do 요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("whAdmin", _sessionInfo.getWhAdmin());
		
		// 구매대행 홈 담당자별 실적현황 조회
		List<Map<String, String>> _data = masterMdAmWmsHomeService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "master/mdam/masterMdAmWmsHomeList";
	}

}	
