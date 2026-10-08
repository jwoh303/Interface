package com.koreab2b.mro.master.mpvo.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpvo.service.MasterMpVoBizTeamStateService;

@Controller("masterMpVoBizTeamStateController")
public class MasterMpVoBizTeamStateController {

	@Autowired
	private MasterMpVoBizTeamStateService masterMpVoBizTeamStateService;
	
	// 조회
	@RequestMapping(value = "/mpvo/getMasterMpVoBizTeamStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpVoBizTeamStateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		List<Map<String,String>> _data = masterMpVoBizTeamStateService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

}
