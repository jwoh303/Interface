package com.koreab2b.mro.master.mdam.controller;

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
import com.koreab2b.mro.master.mdam.service.MasterMdAmUniformProgressService;

@Controller("masterMdAmUniformProgressController")
public class MasterMdAmUniformProgressController {
	
	@Autowired
	private MasterMdAmUniformProgressService masterMdAmUniformProgressService;
	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmUniformProgressList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdAmUniformProgressList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdAmUniformProgressService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
}
