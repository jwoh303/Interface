package com.koreab2b.mro.seller.mpcl.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.seller.mpcl.service.SellerMpClPositionCodeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClPositionCodeController")
public class SellerMpClPositionCodeController {

	@Autowired
	private SellerMpClPositionCodeService sellerMpClPositionCodeService;
	
	// 조회 - 직급코드
	@RequestMapping(value = "/mpcl/getSellerMpClPositionCodeList.do", method = RequestMethod.POST)
	public String getSellerMpClPositionCodeList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpClPositionCodeService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mpcl/sellerMpClPositionCodeList";
	}
	
	// 조회 - 부서코드
	@RequestMapping(value = "/mpcl/getSellerMpClDepartmentCodeList.do", method = RequestMethod.POST)
	public String getSellerMpClDepartmentCodeList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerMpClPositionCodeService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/mpcl/sellerMpClDepartmentCodeList";
	}
	
}
