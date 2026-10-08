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

import com.koreab2b.mro.buyer.mpst.service.BuyerMpStReleaseDirectionsService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpStReleaseDirectionsController")
public class BuyerMpStReleaseDirectionsController {

	@Autowired
	private BuyerMpStReleaseDirectionsService buyerMpStReleaseDirectionsService;
	
	// 조회
	@RequestMapping(value = "/mpst/getBuyerMpStReleaseDirectionsList.do", method = RequestMethod.POST)
	public String getBuyerMpStReleaseDirectionsList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpStReleaseDirectionsService.getList(pMap);
		List<Map<String, String>> _userList = buyerMpStReleaseDirectionsService.getUserList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("userList", CommonUtil.getListNvl(_userList));
		
		return "buyer/mpst/buyerMpStReleaseDirectionsList";
	}
	
	// 저장
	@RequestMapping(value = "/mpst/saveBuyerMpStReleaseDirectionsList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMpStReleaseDirections(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = buyerMpStReleaseDirectionsService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
}
