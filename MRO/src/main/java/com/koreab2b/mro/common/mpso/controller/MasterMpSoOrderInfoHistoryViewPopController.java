package com.koreab2b.mro.common.mpso.controller;

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
import com.koreab2b.mro.common.mpso.service.MasterMpSoOrderInfoHistoryViewPopService;

@Controller("masterMpSoOrderInfoHistoryViewPopController")
public class MasterMpSoOrderInfoHistoryViewPopController {
 

	@Autowired
	private MasterMpSoOrderInfoHistoryViewPopService masterMpSoOrderInfoHistoryViewPopService;
	
	/**
	 * 발주정보 이력보기 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoOrderInfoHistoryViewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoOrderInfoHistoryViewPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
 
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoOrderInfoHistoryViewPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
}
