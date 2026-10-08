package com.koreab2b.mro.common.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpso.service.MasterMpSoPoMngHistPopService;

@Controller("MasterMpSoPoMngHistPopController")
public class MasterMpSoPoMngHistPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoPoMngHistPopController.class);

	@Autowired
	private MasterMpSoPoMngHistPopService masterMpSoPoMngHistPopService;
	
	// 조회
	@RequestMapping(value = "/coco/getMasterMpSoPoMngHistList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoPoMngHistList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSoPoMngHistPopService.searchMasterMpSoPoMngHistList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}

