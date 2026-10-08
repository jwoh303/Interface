package com.koreab2b.mro.buyer.mppo.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mppo.service.BuyerMpPoOrderReqRejectService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoOrderReqRejectController")
public class BuyerMpPoOrderReqRejectController { 

	@Autowired
	private BuyerMpPoOrderReqRejectService buyerMpPoOrderReqRejectService;
	
	// 조회 PG_06_B_017_00
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderReqRejectList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpPoOrderReqRejectList(ModelMap pModel  ,HttpServletRequest req,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mppo/getBuyerMpPoOrderReqRejectList.do 요청 파라미터 : {}", pMap);

		 SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		 


		// 조회일자 Convert
		String _st_from_date = pMap.get("st_from_date").replace("/", "");
		String _st_to_date = pMap.get("st_to_date").replace("/", "");
		pMap.put("st_from_date",_st_from_date);
		pMap.put("st_to_date",_st_to_date);
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpPoOrderReqRejectService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mppo/buyerMpPoOrderReqRejectList";
	}
	 
}
