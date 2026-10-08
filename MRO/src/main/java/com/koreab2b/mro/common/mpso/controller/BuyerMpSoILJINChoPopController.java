package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.BuyerMpSoILJINChoPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

/**
 * 일진전기 장바구니 관리항목
 *
 */
@Controller("buyerMpSoILJINChoPopController")
public class BuyerMpSoILJINChoPopController {
	@Autowired
	private BuyerMpSoILJINChoPopService buyerMpSoILJINChoPopService;
	
	/**
	 * 일진전기 장바구니 관리항목
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoILJINchoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoILJINchoPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		// st_item_no check
		// inventory_flag check
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_buyer", _sessionInfo.getComCode());
		Map<String, String> item_info = buyerMpSoILJINChoPopService.getILJINItemInfo(pMap);
		
		pModel.addAttribute("item_info", item_info);
		  		
		return "common/popup/mpso/buyerMpSoILJINChoPop";
	}	 
	
	@RequestMapping(value = "/mpso/getIljinProjectPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getIljinProjectPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		pMap.put("codeGubun", CommonUtil.nvl((String)  pMap.get("codeGubun"),""));
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_type", CommonUtil.nvl((String)  pMap.get("st_type"),""));
		pMap.put("st_code", CommonUtil.nvl((String)  pMap.get("st_code"),""));
		pMap.put("st_text", CommonUtil.nvl((String)  pMap.get("st_text"),""));
		pMap.put("st_text4", CommonUtil.nvl((String)  pMap.get("st_text4"),""));
		List<Map<String, String>> _data = buyerMpSoILJINChoPopService.getIljinProject(pMap); 
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/mpso/buyerMpSoIljinProjectPop";
	}
}
