package com.koreab2b.mro.master.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.master.mpso.service.MasterMpSoBuyerGrLockPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoBuyerGrLockPopController")
public class MasterMpSoBuyerGrLockPopController {

	@Autowired
	private MasterMpSoBuyerGrLockPopService masterMpSoBuyerGrLockPopService;
	
	@RequestMapping(value = "/mpso/showMasterMpSoBuyerGrLockPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterMpSoBuyerGrLockPop() {
		return "common/popup/mpso/masterMpSoBuyerGrLockPop";
	}
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoBuyerGrLockPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoBuyerGrLockPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		List<Map<String, String>> _data = masterMpSoBuyerGrLockPopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mpso/masterMpSoBuyerGrLockPop";
	}
	
	// 입고잠금
	@RequestMapping(value = "/mpso/updatMasterMpSoBuyerGrLockPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> updatMasterMpSoBuyerGrLockPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpSoBuyerGrLockPopService.saveGrLock(pMap);
		
		_response.put("msg", _result);
		return _response;
	}
}