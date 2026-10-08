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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoCartService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderDetailHongikService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoOrderDetailHongikController")
public class BuyerMpSoOrderDetailHongikController {
 

	@Autowired
	private BuyerMpSoOrderDetailHongikService buyerMpSoOrderDetailHongikService;
	@Autowired
	private BuyerMpSoCartService buyerMpSoCartService;
	// 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderDetailHongikList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoOrderDetailHongikList(ModelMap pModel,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoOrderDetailHongikList.do 요청 파라미터 : {}", pMap);
		List<Map<String, String>> _Hdata = null;
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoOrderDetailHongikService.getList(pMap);
		
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
		
		return "buyer/mpso/buyerMpSoOrderDetailHongikList";
	} 
}
