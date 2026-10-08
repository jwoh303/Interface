package com.koreab2b.mro.buyer.mdcm.controller;

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

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmUniformSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmUniformSearchController")
public class BuyerMdCmUniformSearchController {
 
	@Autowired
	private BuyerMdCmUniformSearchService buyerMdCmUniformSearchService;
	
	// 조회 
	@RequestMapping(value = "/mdcm/getBuyerMdCmUniformSearchList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmUniformSearchList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmUniformSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmUniformSearchList";
	}
}
