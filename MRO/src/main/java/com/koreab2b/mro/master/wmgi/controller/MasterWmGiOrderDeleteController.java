package com.koreab2b.mro.master.wmgi.controller;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.wmco.service.MasterWmCoMgService;
import com.koreab2b.mro.master.wmgi.service.MasterWmGiOrderDeleteService;

@Controller("masterWmGiOrderDeleteController")
public class MasterWmGiOrderDeleteController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiOrderDeleteController.class);

	@Autowired
	private MasterWmGiOrderDeleteService masterWmGiOrderDeleteService;
	@Autowired
	private MasterWmCoMgService masterWmCoMgService;
	// 조회
	@RequestMapping(value = "/wmgi/getMasterWmGiOrderDeleteList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmGiOrderDeleteList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _session_com_code = _sessionInfo.getComCode();
		String _session_user_id = _sessionInfo.getUserId();
		String whAdmin = _sessionInfo.getWhAdmin();
		
		 pMap.put("com_code", _session_com_code);
		 pMap.put("user_id", _session_user_id);
		 pMap.put("whAdmin", whAdmin);
		 
		String _warehouse_agent = masterWmCoMgService.getForwarehouseAgent(pMap);
		pMap.put("st_warehouse_agent", _warehouse_agent);
		
		List<Map<String,String>> _data = masterWmGiOrderDeleteService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}


}
