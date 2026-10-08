package com.koreab2b.mro.buyer.mpst.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpst.service.BuyerMpStStockAdjustService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpStStockAdjustController")
public class BuyerMpStStockAdjustController {

	@Autowired
	private BuyerMpStStockAdjustService buyerMpStStockAdjustService;
	
	// 조회
	@RequestMapping(value = "/mpst/getBuyerMpStStockAdjustList.do", method = RequestMethod.POST)
	public String getBuyerMpStStockAdjustList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpStStockAdjustService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpst/buyerMpStStockAdjustList";
	}
	
	// 저장
	@RequestMapping(value = "/mpst/saveBuyerMpStStockAdjustList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpStStockAdjust(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = buyerMpStStockAdjustService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
}
