package com.koreab2b.mro.common.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoChangeAccountPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoChangeAccountPopController")
public class BuyerMpSoChangeAccountPopController {
	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoChangeAccountPopController.class);
	
	@Autowired
	private BuyerMpSoChangeAccountPopService buyerMpSoChangeAccountPopService;
	
	@RequestMapping(value = "/mpso/getBuyerMpSoChangeAccountPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoAccountSelPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		LOGGER.debug("/mpso/getBuyerMpSoChangeAccountPop.do 요청 파라미터 for jsp : {}", pMap);
		
		List<Map<String, String>> _data = buyerMpSoChangeAccountPopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("CRUD", "R");
		
		return "common/popup/mpso/buyerMpSoChangeAccountPop";
	}
	@RequestMapping(value = "/mpso/getBuyerMpSoChangeAccountPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoChangeAccountPop_v2(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		LOGGER.debug("/mpso/getBuyerMpSoChangeAccountPop_v2.do 요청 파라미터 for jsp : {}", pMap);
		
		List<Map<String, String>> _data = buyerMpSoChangeAccountPopService.getList_v2(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("CRUD", "R");
		
		return "common/popup/mpso/buyerMpSoChangeAccountPop_v2";
	}
	
	// 저장
	@RequestMapping(value = "/mpso/saveBuyerMpSoChangeAccountPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpSoChangeAccountPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String _rtnMsg = buyerMpSoChangeAccountPopService.saveBuyerMpSoChangeAccountPop(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
	}
}