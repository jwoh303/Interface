package com.koreab2b.mro.master.mpvo.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpvo.service.MasterMpVoVocDailySummaryService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocDailySummaryController")
public class MasterMpVoVocDailySummaryController {

	@Autowired
	private MasterMpVoVocDailySummaryService masterMpVoVocDailySummaryService;
	
	/**
	 * 고객사 카테고리 선택 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocDailySummaryList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocDailySummaryList(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", CommonUtil.nvl((String) request.getParameter("st_user_id"), _sessionInfo.getUserId()));
		
		List<Map<String,String>> _week_data = masterMpVoVocDailySummaryService.selectListWeek(pMap);
		List<Map<String,String>> _today_data = masterMpVoVocDailySummaryService.selectListToday(pMap);
		
		pModel.addAttribute("week_data", _week_data); 
		pModel.addAttribute("today_data", _today_data); 
		
		return "master/mpvo/masterMpVoVocDailySummaryList";
	}

}
