package com.koreab2b.mro.seller.none.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.seller.none.service.SellerNoNeNoticeService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerNoNeNoticeController")
public class SellerNoNeNoticeController {
	
	@Autowired
	private SellerNoNeNoticeService sellerNoNeNoticeService;
	
	// 조회
	@RequestMapping(value = "/none/getSellerNoNeNoticeListPop.do", method = RequestMethod.POST)
	public String getSellerNoNeNoticeListPop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerNoNeNoticeService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/none/sellerNoNeNoticeListPop";
	}
	
	// 조회
	@RequestMapping(value = "/none/getSellerNoNeNoticeDetailPop.do", method = RequestMethod.POST)
	public String getSellerNoNeNoticeDetailPop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 화면 조회
		Map<String, String> _data = sellerNoNeNoticeService.getDetail(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "seller/none/sellerNoNeNoticeDetailPop";
	}

}
