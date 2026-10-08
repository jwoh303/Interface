package com.koreab2b.mro.master.mpsm.controller;

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
import com.koreab2b.mro.master.mpsm.service.MasterMpSmStatsHomeService;

@Controller("masterMpSmStatsHomeController")
public class MasterMpSmStatsHomeController {

	@Autowired
	private MasterMpSmStatsHomeService masterMpSmStatsHomeService;
	
	// 조회
	@RequestMapping(value = "/mpsm/getMasterMpSmWarhsngResultList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSmWarhsngResultList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSmStatsHomeService.getWarhsngResultList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
