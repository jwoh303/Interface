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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoNexePopService;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
/**
 * 넥센타이어 고정자산번호(관리번호) 팝업
 */
@Controller("buyerMpSoNexePopController")
public class BuyerMpSoNexePopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpSoNexePopController.class);

	@Autowired
	private BuyerMpSoNexePopService buyerMpSoNexePopService;
	/**
	 *  넥센타이어 고정자산번호(관리번호) 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoInfoNexePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoInfoNexePop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		List<Map<String, String>> _data = buyerMpSoNexePopService.getList(pMap);		
		pModel.addAttribute("data", (Map<String,String>)CommonUtil.getListNvl(_data).get(0)); 
		return "common/popup/mpso/buyerMpSoRefPrNoInfoNexePop";
	}
	
	@RequestMapping(value = "/mpso/getBuyerMpSoRefPrNoListNexePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoRefPrNoListNexePop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		List<Map<String, String>> _data = buyerMpSoNexePopService.getRefNoList(pMap);		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpso/buyerMpSoRefPrNoListNexePop";
	}
	
	
}
