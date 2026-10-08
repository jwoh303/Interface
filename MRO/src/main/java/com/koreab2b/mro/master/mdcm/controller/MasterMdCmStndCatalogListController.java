package com.koreab2b.mro.master.mdcm.controller;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmStndCatalogListService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmStndCatalogListController")
public class MasterMdCmStndCatalogListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndCatalogListController.class);

	@Autowired
	private MasterMdCmStndCatalogListService masterMdCmStndCatalogListService;
	
	/**
	 * 승인
	 */
	@RequestMapping(value = "/mprq/saveMasterMpRqConfirmStndCatlg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqConfirmStndCatlg(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		String msg = masterMdCmStndCatalogListService.saveMasterMpRqConfirmStndCatlg(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}

}
