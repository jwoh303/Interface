package com.koreab2b.mro.common.wmst.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.wmst.service.MasterWmstNoticeListPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmstNoticeListPopController")
public class MasterWmstNoticeListPopController {
	
	@Autowired
	private MasterWmstNoticeListPopService masterWmstNoticeListPopService;
	
	// 조회
	@RequestMapping(value = "/wmst/showMasterWmstNoticeListPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterWmstNoticeListPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("onepagerow", "10");
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		pMap.put("whAdmin", _sessionInfo.getWhAdmin());
		
		List<Map<String, String>> _data = masterWmstNoticeListPopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/wmst/masterWmstNoticeListPop";
	}

}
