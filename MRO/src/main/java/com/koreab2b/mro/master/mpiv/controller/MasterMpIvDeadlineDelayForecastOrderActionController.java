package com.koreab2b.mro.master.mpiv.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpiv.service.MasterMpIvDeadlineDelayForecastOrderActionService;

@Controller("masterMpIvDeadlineDelayForecastOrderActionController")
public class MasterMpIvDeadlineDelayForecastOrderActionController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvDeadlineDelayForecastOrderActionController.class);

	@Autowired
	private MasterMpIvDeadlineDelayForecastOrderActionService masterMpIvDeadlineDelayForecastOrderActionService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getMasterMpIvDeadlineDelayForecastOrderActionList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void searchMasterMpIvDeadlineDelayForecastOrderActionList(HttpServletRequest pReq, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = masterMpIvDeadlineDelayForecastOrderActionService.getList(pMap);
		
		pReq.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(pReq, pRes);
		
	}

}
