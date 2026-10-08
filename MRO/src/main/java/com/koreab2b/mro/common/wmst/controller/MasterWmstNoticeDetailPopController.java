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

import com.koreab2b.mro.common.wmst.service.MasterWmstNoticeDetailPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

@Controller("masterWmstNoticeDetailPopController")
public class MasterWmstNoticeDetailPopController {
	
	@Autowired
	private MasterWmstNoticeDetailPopService masterWmstNoticeDetailPopService;
	
	// 조회
	@RequestMapping(value = "/wmst/showMasterWmstNoticeDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterWmstNoticeDetailPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		// 화면 조회
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		
		Map<String, String> _data = masterWmstNoticeDetailPopService.getDetail(pMap);
		pModel.addAttribute("data", _data);
		
		return "common/popup/wmst/masterWmstNoticeDetailPop";
	}
	
	// 삭제
		@RequestMapping(value = "/wmst/deleteMasterWmstNoticeDetailPop.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> deleteMasterWmstNoticeDetailPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

			Map<String, Object> _response = new HashMap<String, Object>();
			pMap.put("st_btype", "WM");
			String flag = masterWmstNoticeDetailPopService.deleteSelectedData(pMap);
			_response.put("msg", flag);

			return  _response;
		}

}
