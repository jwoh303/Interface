package com.koreab2b.mro.common.mpds.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpds.service.MasterMpDsDbOffPoHistoryPopService;

@Controller("CommonMpDsDbOffPoHistoryController")
public class MasterMpDsDbOffPoHistoryPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsDbOffPoHistoryPopController.class);

	@Autowired
	private MasterMpDsDbOffPoHistoryPopService masterMpDsDbOffPoHistoryPopService;

	
	
	/**
	 * 발주변경 현황
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpds/getViewDbOffPoHistoryList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> viewDbOffPoHistoryPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpDsDbOffPoHistoryPopService.searchList(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

}
