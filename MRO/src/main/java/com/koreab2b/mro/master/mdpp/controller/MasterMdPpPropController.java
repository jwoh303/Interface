package com.koreab2b.mro.master.mdpp.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.master.mdpp.service.MasterMdPpPropService;

@Controller("masterMdPpPropController")
public class MasterMdPpPropController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdPpPropController.class);

	@Autowired
	private MasterMdPpPropService masterMdPpPropService;
		
	// 저장
	@RequestMapping(value = "/mdpp/saveMasterMdPpPropRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdPpPropRegList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMdPpPropService.updateSelectedData(pMap);
		
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("usrmsg","N");
		mp.put("msg", _result);
		
		_response.put("msg", mp);
		return _response;
		
	}
}
