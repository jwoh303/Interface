package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDlvryCarPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvDlvryCarPopController")
public class CommonMpIvDlvryCarPopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvDlvryCarPopController.class);

	@Autowired
	private CommonMpIvDlvryCarPopService commonMpIvDlvryCarPopService;
	
	/**
	 * 배송차량 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getCommonMpIvDlvryCarPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvDlvryCarPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonMpIvDlvryCarPop.do 요청 파라미터 for jsp : {}", pMap);
		pMap.put("st_buyer_code", CommonUtil.nvl((String)  pMap.get("st_buyer_code"),"ALL"));
		List<Map<String, String>> _data = commonMpIvDlvryCarPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpiv/commonMpIvDlvryCarPop";
	}
	
	
	
	/**
	 * 배송차량정보 UPDATE
	 * @param pModel
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/saveCommonMpIvDlvryCarPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveCommonMpIvDlvryCarPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/saveCommonMpIvDlvryCarPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		Map<String, String> _response = new HashMap<String, String>();
		
		String flag = commonMpIvDlvryCarPopService.saveCommonMpIvDlvryCarPop(pMap);
		
		_response.put("msg", flag);
				
		return _response;
	}
	/**
	 * 배송차량 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getCommonMpIvDlvryNoticePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvDlvryNoticePop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/mpiv/getCommonMpIvDlvryNoticePop.do 요청 파라미터 for jsp : {}", pMap);
		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			if(pMap.get("st_type").equals("TYPE90")){
				return "common/popup/mpiv/commonMpIvDlvryNoticePop_v2";
			}
			return "common/popup/mpiv/commonMpIvDlvryNoticePop";
		} else {
			return "common/popup/mpiv/commonMpIvDlvryNoticePop";
		}
	
	}
}
