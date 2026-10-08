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
import com.koreab2b.mro.master.mprq.service.MasterMpRqDailySourcingDbManageListService;

@Controller("masterMpRqDailySourcingDbManageListController")
public class MasterMpRqDailySourcingDbManageListController {

	@Autowired
	private MasterMpRqDailySourcingDbManageListService masterMpRqDailySourcingDbManageListService;

	@RequestMapping(value = "/mprq/searchMasterMpRqDailySourcingDbManageList.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqDailySourcingDbManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqDailySourcingDbManageListService.getList(pMap);
		return IBSheetUtil.addResut(req, _data, pMap);
	}

}
