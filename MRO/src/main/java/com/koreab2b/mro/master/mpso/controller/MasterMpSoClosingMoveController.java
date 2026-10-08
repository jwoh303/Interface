package com.koreab2b.mro.master.mpso.controller;

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
import com.koreab2b.mro.master.mpso.service.MasterMpSoClosingMoveService;

@Controller("masterMpSoClosingMoveController")
public class MasterMpSoClosingMoveController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoClosingMoveController.class);

	@Autowired
	private MasterMpSoClosingMoveService masterMpSoClosingMoveService;
	
	// 조회 getSysopProxybuyAdminOfficeClosed
	@RequestMapping(value = "/mpso/getMasterMpSoClosingMoveList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoClosingMoveList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSoClosingMoveService.searchMasterMpSoClosingMoveList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
