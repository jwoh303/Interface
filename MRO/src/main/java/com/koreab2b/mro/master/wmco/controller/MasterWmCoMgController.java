package com.koreab2b.mro.master.wmco.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.wmco.service.MasterWmCoMgService;
import com.koreab2b.mro.master.wmgr.service.MasterWmGrTrGrCreService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterWmCoMgController")
public class MasterWmCoMgController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmCoMgController.class);

	@Autowired
	private MasterWmCoMgService masterWmCoMgService;
	
	// warehouse_code 조회
	public String getForwarehouseCode(HttpServletRequest req, Map<String, Object> pMap) {
		logger.debug("요청 파라미터 for jsp : {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();

		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		
		logger.debug("session 값 입력 : {}", pMap);
		masterWmCoMgService.getForwarehouseCode(pMap);
		
		return "sample/search";
	}

}
