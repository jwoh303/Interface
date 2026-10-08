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
import com.koreab2b.mro.master.mpvo.service.MasterMpVoBuyerStateService;

@Controller("masterMpVoBuyerStateController")
public class MasterMpVoBuyerStateController {


	@Autowired
	private MasterMpVoBuyerStateService masterMpVoBuyerStateService;
	
	// 조회
	@RequestMapping(value = "/mpvo/getMasterMpVoBuyerStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpVoBuyerStateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		List<Map<String,String>> _data = masterMpVoBuyerStateService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

}
