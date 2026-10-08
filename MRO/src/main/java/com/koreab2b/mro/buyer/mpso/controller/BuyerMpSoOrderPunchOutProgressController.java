package com.koreab2b.mro.buyer.mpso.controller;

import java.io.OutputStream;
import java.util.Date;
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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderPunchOutProgressService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoOrderPunchOutProgressController")
public class BuyerMpSoOrderPunchOutProgressController {
 

	@Autowired
	private BuyerMpSoOrderPunchOutProgressService buyerMpSoOrderPunchOutProgressService;
	
	// 조회 PG_06_B_014_00
	@RequestMapping(value = "/mpso/getBuyerMpSoRecentPunchOutList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoRecentPunchOutList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_specification", CommonUtil.onvl(pMap.get("st_specification") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		pMap.put("st_category_no", CommonUtil.onvl(pMap.get("st_category_no") ,"") );
		pMap.put("st_sort_column", CommonUtil.onvl(pMap.get("st_sort_column") ,"ALL") );
		pMap.put("st_sort_flag", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoOrderPunchOutProgressService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoRecentPunchOutList";
	}
	
 
}
