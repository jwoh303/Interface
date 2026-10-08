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

import com.koreab2b.mro.common.mpcl.service.SellerMpClPositionCodePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClPositionCodePopController")
public class SellerMpClPositionCodePopController {

	@Autowired
	private SellerMpClPositionCodePopService sellerMpClPositionCodePopService;
	
	// 조회 - 직급코드
	@RequestMapping(value = "/mpcl/showSellerMpClPositionCodePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpClPositionCodePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		if ( !"insert".equals(pMap.get("kind")) ) {
			// 화면 조회
			Map<String, String> _data = sellerMpClPositionCodePopService.getList(pMap); 
			pModel.addAttribute("data", CommonUtil.getMapNvl(_data));
		}
		
		pModel.addAttribute("param", CommonUtil.getMapNvl(pMap));
		
		return "common/popup/mpcl/sellerMpClPositionCodePop";
	}
	
	// 조회 - 부서코드
	@RequestMapping(value = "/mpcl/showSellerMpClDepartmentCodePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpClDepartmentCodePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		if ( !"insert".equals(pMap.get("kind")) ) {
			// 화면 조회
			Map<String, String> _data = sellerMpClPositionCodePopService.getList(pMap); 
			pModel.addAttribute("data", CommonUtil.getMapNvl(_data));
		}
		
		pModel.addAttribute("param", CommonUtil.getMapNvl(pMap));
		
		return "common/popup/mpcl/sellerMpClDepartmentCodePop";
	}
	
	// 저장
	@RequestMapping(value = "/mpcl/insertSellerMpClPositionCodePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertSellerMpClPositionCodePop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String flag = sellerMpClPositionCodePopService.insertSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	
	// 수정
	@RequestMapping(value = "/mpcl/updateSellerMpClPositionCodePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMpClPositionCodePop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpClPositionCodePopService.updateSelectedData(pMap);
		_response.put("msg", flag);
		
		return  _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mpcl/delSellerMpClPositionCodePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delSellerMpClPositionCodePop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String flag = sellerMpClPositionCodePopService.deleteSelectedData(pMap);
		_response.put("msg", flag);
		
		return _response;
	}
	
}
