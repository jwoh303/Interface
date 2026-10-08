package com.koreab2b.mro.buyer.mdcm.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmAdminCatalogSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmAdminCatalogSearchController")
public class BuyerMdCmAdminCatalogSearchController {
	@Autowired
	private BuyerMdCmAdminCatalogSearchService buyerMdCmAdminCatalogSearchService;
  
	// 조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmAdminCatalogtList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmAdminCatalogtList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId()); 
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );

		pMap.put("st_sort_column", CommonUtil.onvl(pMap.get("st_sort_column") ,"ALL") );
		pMap.put("st_sort_flag", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		 
		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmAdminCatalogSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmAdminCatalogSearchList";
	}
	
}
