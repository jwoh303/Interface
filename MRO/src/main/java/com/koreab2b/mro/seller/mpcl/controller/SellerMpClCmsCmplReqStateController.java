package com.koreab2b.mro.seller.mpcl.controller;

import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.seller.mpcl.service.SellerMpClCmsCmplReqStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClCmsCmplReqStateController")
public class SellerMpClCmsCmplReqStateController {


	@Autowired
	private SellerMpClCmsCmplReqStateService sellerMpClCmsCmplReqStateService;
	
	// 조회
	@RequestMapping(value = "/mpcl/getSellerMpClCmsCmplReqStateList.do", method = RequestMethod.POST)
	public String getSellerMpClCmsCmplReqStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpClCmsCmplReqStateService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mpcl/sellerMpClCmsList";
	}


}
