package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvTranBuyerChoicePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvTranBuyerChoicePopController")
public class CommonMpIvTranBuyerChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMpIvTranBuyerChoicePopController.class);

	@Autowired
	private CommonMpIvTranBuyerChoicePopService commonMpIvTranBuyerChoicePopService;
	
	/**
	 * 거래 고객사 선택 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvTranBuyerChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvTranBuyerChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap,HttpServletRequest request) {
		logger.debug("/mpiv/getCommonMpIvTranBuyerChoicePop.do 요청 파라미터 for jsp : {}", pMap);
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "common/popup/mpiv/commonMpIvTranBuyerChoicePop_v2";
		} else {
			List<Map<String, String>> _data = commonMpIvTranBuyerChoicePopService.getList(pMap); 
			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			pModel.addAllAttributes(pMap);
			
			return "common/popup/mpiv/commonMpIvTranBuyerChoicePop";
		}
	}
	@RequestMapping(value = "/mpiv/getCommonMpIvTranBuyerInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvTranBuyerInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap,HttpServletRequest request) {
		logger.debug("/mpiv/getCommonMpIvTranBuyerInfoPop.do 요청 파라미터 for jsp : {}", pMap);
		return "common/popup/mpiv/commonMpIvTranBuyerInfoPop_v2";
	}
	@RequestMapping(value = "/mpiv/getCommonMpIvTranBuyerChoicePopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonMpIvTranBuyerChoicePopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("newSourcingBuyerList 요청 파라미터 for jsp : {}", pMap); 
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String, String>> _data = commonMpIvTranBuyerChoicePopService.getCommonMpIvTranBuyerChoicePopList(pMap); 
		return IBSheetUtil.addResut(req, _data , pMap);
	}	
	
	/**
	 * 거래 고객사 물류 선택 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvBpTranBuyerChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvBpTranBuyerChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = commonMpIvTranBuyerChoicePopService.getBpList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "common/popup/mpiv/commonMpIvBpTranBuyerChoicePop";
	}	 
	
}
