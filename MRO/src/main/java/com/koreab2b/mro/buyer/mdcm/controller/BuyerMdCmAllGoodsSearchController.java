package com.koreab2b.mro.buyer.mdcm.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmAllGoodsSearchService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

@Controller("buyerMdCmAllGoodsSearchController")
public class BuyerMdCmAllGoodsSearchController {
  
	@Autowired
	private BuyerMdCmAllGoodsSearchService buyerMdCmAllGoodsSearchService;
	
	// 조회 
	@RequestMapping(value = "/mdcm/showBuyerMdCmAllGoodsSearchList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String showMasterWmReExchangeManage(HttpServletRequest request) {
		return "buyer/mdcm/buyerMdCmAllGoodsSearchList";
	}
	
	@RequestMapping(value = "/mdcm/getBuyerMdCmAllGoodsSearchList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmReExchangeManageList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerMdCmAllGoodsSearchService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
