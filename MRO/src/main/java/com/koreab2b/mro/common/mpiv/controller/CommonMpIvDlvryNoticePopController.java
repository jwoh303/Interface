package com.koreab2b.mro.common.mpiv.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDlvryNoticePopService;

@Controller("commonMpIvDlvryNoticePopController")
public class CommonMpIvDlvryNoticePopController {
	@Autowired
	private CommonMpIvDlvryNoticePopService commonMpIvDlvryNoticePopService;
	
	// 저장 
	@RequestMapping(value = "/mpiv/updateCommonMpIvDlvryNoticePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateCommonMpIvDlvryNoticePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = commonMpIvDlvryNoticePopService.updateCommonMpIvDlvryNoticePop(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
}
