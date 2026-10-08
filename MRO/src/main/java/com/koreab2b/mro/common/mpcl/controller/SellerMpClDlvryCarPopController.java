package com.koreab2b.mro.common.mpcl.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpcl.service.SellerMpClDlvryCarPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClDlvryCarPopController")
public class SellerMpClDlvryCarPopController {

	@Autowired
	private SellerMpClDlvryCarPopService sellerMpClDlvryCarPopService;
	
	// 조회
	@RequestMapping(value = "/mpcl/showSellerMpClDlvryCarPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpClDlvryCarPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		if ( !"insert".equals(pMap.get("kind")) ) {
			// 화면 조회
			Map<String, String> _data = sellerMpClDlvryCarPopService.getList(pMap); 
			pModel.addAttribute("data", CommonUtil.getMapNvl(_data));
		}
		
		pModel.addAttribute("param", CommonUtil.getMapNvl(pMap));
		
		return "common/popup/mpcl/sellerMpClDlvryCarPop";
	}	 
	
	// 저장
	@RequestMapping(value = "/mpcl/insertSellerMpClDlvryCarPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertSellerMpClDlvryCarPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String flag = sellerMpClDlvryCarPopService.insertSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 수정
	@RequestMapping(value = "/mpcl/updateSellerMpClDlvryCarPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpClDlvryCarPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpClDlvryCarPopService.updateSelectedData(pMap);
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mpcl/delSellerMpClDlvryCarPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delSellerMpClDlvryCarPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpClDlvryCarPopService.deleteSelectedData(pMap);
		_response.put("msg", flag);
		
		return _response;
	}
	
}
