package com.koreab2b.mro.common.mdct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mdct.service.MasterMdCtBuyerReContractPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtBuyerReContractPopController")
public class MasterMdCtBuyerReContractPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtBuyerReContractPopController.class);

	@Autowired
	private MasterMdCtBuyerReContractPopService masterMdCtBuyerReContractPopService;
	
	// 재계약관리 팝업 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerReContractPopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtBuyerReContractPopList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterMdCtBuyerReContractPopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/masterMdCtBuyerReContractPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtBuyerReContractPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtBuyerReContractPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
			Map<String, Object> _response = new HashMap<String, Object>();
			
			String _result = masterMdCtBuyerReContractPopService.saveSelectedData(pMap);

			/* 성공시코드 OK , 실패시 메세지 전송 */
			_response.put("msg", _result);
			return _response;
	}
}
