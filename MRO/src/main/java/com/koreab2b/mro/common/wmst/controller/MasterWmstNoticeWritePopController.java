package com.koreab2b.mro.common.wmst.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmst.service.MasterWmstNoticeWritePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

@Controller("masterWmstNoticeWritePopController")
public class MasterWmstNoticeWritePopController {
	
	@Autowired
	private MasterWmstNoticeWritePopService masterWmstNoticeWritePopService;
	
	// 조회
	@RequestMapping(value = "/wmst/showMasterWmstNoticeWritePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterWmstNoticeWritePop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {		

		// 화면 조회
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		
		if (!"".equals(pMap.get("st_bid"))) {
			Map<String, String> _data = masterWmstNoticeWritePopService.getDetail(pMap);
			pModel.addAttribute("data", _data);
		}
		Map<String, String> _data2 = masterWmstNoticeWritePopService.getWarehouseCode(pMap);
		pModel.addAttribute("warehouseCode", _data2);
		
		return "common/popup/wmst/masterWmstNoticeWritePop";
	}
	
	// 저장
	@RequestMapping(value = "/wmst/saveMasterWmstNoticeWritePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmstNoticeWritePop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_nm", _sessionInfo.getUserNameLoc() );
		pMap.put("st_dept", _sessionInfo.getDepartment());
		pMap.put("st_dept_nm", _sessionInfo.getDepartmentName());
		if ("KRKORE0001".equals(pMap.get("st_compay"))) {
			pMap.put("st_acl",  "ALL");
		} else {
			pMap.put("st_acl",  "CST");
		}
		String flag = masterWmstNoticeWritePopService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
}
