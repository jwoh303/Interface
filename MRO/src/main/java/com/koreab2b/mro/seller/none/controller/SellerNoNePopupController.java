package com.koreab2b.mro.seller.none.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.seller.none.service.SellerNoNePopupService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerNoNePopupController")
public class SellerNoNePopupController {
	
	@Autowired
	private SellerNoNePopupService sellerNoNePopupService;
	
	// 조회
	@RequestMapping(value = "/none/getSellerNoNePopupListPop.do", method = RequestMethod.POST)
	public String getSellerNoNeNoticeListPop(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = sellerNoNePopupService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "seller/none/sellerNoNePopupListPop";
	}
	
	// 읽음 저장
	@RequestMapping(value = "/none/saveSellerNoNePopupRead.do", method = RequestMethod.POST)
	@ResponseBody				
	public Map<String, Object> saveSellerNoNePopupRead(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
 
		pMap = CommonUtil.removeSlash(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerNoNePopupService.saveSellerNoNePopupRead(pMap);
		
		_response.put("msg", flag);

		return  _response;
	}
}
