package com.koreab2b.mro.common.mpso.controller;

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

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoDlvryInfoService;
import com.koreab2b.mro.common.mpso.service.CommonPopupMpsoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonPopupMpsoController")
public class CommonPopupMpsoController {

	private static final Logger logger = LoggerFactory.getLogger(CommonPopupMpsoController.class);

	@Autowired
	private CommonPopupMpsoService commonPopupMpsoService;
	@Autowired
	private BuyerMpSoDlvryInfoService buyerMpSoDlvryInfoService;
	
	/**
	 * 발주상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/poDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String poDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("poDetailPop 요청 파라미터 for jsp : {}", pMap); 
		Map<String,String> _data1 = commonPopupMpsoService.poDetailPopHd(pMap); 
		List<Map<String, String>> _data2 = commonPopupMpsoService.poDetailPopDt(pMap); 
		pModel.addAttribute("data1", _data1); 
		pModel.addAttribute("data2", _data2); 
		
		// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회
		List<Map<String, String>> specialLogicInfo = commonPopupMpsoService.getSpecialLogicInfo(pMap); 
		pModel.addAttribute("specialLogicInfo", (Map<String,String>)CommonUtil.getListNvl(specialLogicInfo).get(0));
		
		return "common/popup/mpso/poDetailPop";
	}	 

	/**
	 * 발주상세 조회(이력)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/poDetailHistPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String poDetailHistPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("poDetailHistPop 요청 파라미터 for jsp : {}", pMap); 
		Map<String,String> _data1 = commonPopupMpsoService.poDetailHistPopHd(pMap); 
		List<Map<String, String>> _data2 = commonPopupMpsoService.poDetailHistPopDt(pMap); 
		pModel.addAttribute("data1", _data1); 
		pModel.addAttribute("data2", _data2); 
		
		return "common/popup/mpso/poDetailHistPop";
	}
	
	/**
	 * 동화산업  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getBuyerMpSoDongHwaPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoDongHwaPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpso/getBuyerMpSoDongHwaPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		return "common/popup/mpso/buyerMpSoDongHwaPop";
	}
	
	//주문/배송조회 진행상태 팝업
	@RequestMapping(value = "/mpso/getBuyerMpSoOrderProgressStatusPop_v2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMpSoOrderProgressStatusPop_v2(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpso/getBuyerMpSoOrderProgressStatusPop_v2.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = buyerMpSoDlvryInfoService.getBuyerMpSoDlvryInfoDtlList_v2(pMap); 
		pModel.addAttribute("data", _data); 
		
		return "common/popup/mpso/buyerMpSoOrderProgressStatusPop_v2";
	}
}
