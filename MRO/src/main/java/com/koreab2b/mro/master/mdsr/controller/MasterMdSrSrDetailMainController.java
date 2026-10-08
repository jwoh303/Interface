package com.koreab2b.mro.master.mdsr.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdsr.service.MasterMdSrSrDetailMainService;

@Controller("masterMdSrSrDetailMainController")
public class MasterMdSrSrDetailMainController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdSrSrDetailMainController.class);

	@Autowired
	private MasterMdSrSrDetailMainService masterMdSrSrDetailMainService;
	
	// 조회
	@RequestMapping(value = "/srDetailMain.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterMdSrSrDetailMainList(ModelMap pModel, HttpServletRequest pRequest) {
		
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		String st_user_id = _sessionInfo.getUserId();
		
		Map<String, String> pMap = new HashMap<String, String>();
		pMap.put("st_user_id", st_user_id);
		
		List<Map<String, String>> _data = masterMdSrSrDetailMainService.getList(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "master/srDetailMain";
	}

}
