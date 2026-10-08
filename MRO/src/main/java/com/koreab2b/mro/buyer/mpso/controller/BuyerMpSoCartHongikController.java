package com.koreab2b.mro.buyer.mpso.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartHongikService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoCartHongikController")
public class BuyerMpSoCartHongikController {
 

	@Autowired
	private BuyerMpSoCartHongikService buyerMpSoCartHongikService;
	@Autowired
	private BuyerMpSoCartService buyerMpSoCartService;
	
	// 조회 PG_06_B_011_00
	@RequestMapping(value = "/mpso/getBuyerMpSoCartHongikList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoCartHongikList(ModelMap pModel ,HttpServletRequest req,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoCartHongikList.do 요청 파라미터 : {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		//pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"50") );
		
		List<Map<String, String>> _Hdata = null;
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoCartHongikService.getList(pMap);
		
		// 홍익대학교-- 대학원 소속 체크. 
		_Hdata = buyerMpSoCartService.getHongIkType(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		 
		if (_Hdata == null){
			pModel.addAttribute("Hdata", "");
		}else{
			pModel.addAttribute("Hdata", CommonUtil.nvl(  _Hdata.get(0).get("FLAG"),"0"));
		}
		
		
		//홍익대학교-- 품의서 양식 확인.
		List<Map<String, String>> _HdataSheetType = buyerMpSoCartService.getHongIkSheetType(pMap);
		if (_Hdata == null){
			pModel.addAttribute("HdataSheetType", "");
		}else{
			pModel.addAttribute("HdataSheetType", CommonUtil.nvl(  _HdataSheetType.get(0).get("FLAG"),""));
		}
		
		return "buyer/mpso/buyerMpSoCartHongikList";
	}
	  
	
	
	
}
