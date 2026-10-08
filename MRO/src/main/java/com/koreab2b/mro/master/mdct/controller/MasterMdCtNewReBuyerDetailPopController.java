package com.koreab2b.mro.master.mdct.controller;

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
import com.koreab2b.mro.master.mdct.service.MasterMdCtNewReBuyerDetailPopService;

@Controller("masterMdCtNewReBuyerDetailPopController")
public class MasterMdCtNewReBuyerDetailPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCtNewReBuyerDetailPopController.class);

	@Autowired
	private MasterMdCtNewReBuyerDetailPopService masterMdCtNewReBuyerDetailPopService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtNewReBuyerDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtNewReBuyerDetailPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtNewReBuyerDetailPop 요청 파라미터 for jsp : {}", pMap); 
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String, String>> _data = masterMdCtNewReBuyerDetailPopService.getMasterMdCtNewReBuyerDetailPop(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}	 

}
