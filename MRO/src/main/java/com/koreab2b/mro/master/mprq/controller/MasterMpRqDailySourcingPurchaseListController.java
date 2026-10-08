package com.koreab2b.mro.master.mprq.controller;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mprq.service.MasterMpRqDailySourcingPurchaseListService;

@Controller("masterMpRqDailySourcingPurchaseListController")
public class MasterMpRqDailySourcingPurchaseListController {

	@Autowired
	private MasterMpRqDailySourcingPurchaseListService masterMpRqDailySourcingPurchaseListService;

	@RequestMapping(value = "/mprq/searchMasterMpRqDailySourcingPurchaseList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqDailySourcingPurchaseList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		pMap.remove("st_my_user_id");
		if ("Y".equals(pMap.get("st_my_sg_only"))) {
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			if (!"KEP2239016".equals(_sessionInfo.getUserId())) {
				pMap.put("st_my_user_id", _sessionInfo.getUserId());
			}
		}

		List<Map<String,String>> _data = masterMpRqDailySourcingPurchaseListService.getList(pMap);
		return IBSheetUtil.addResut(req, _data, pMap);
	}

}
