package com.koreab2b.mro.common.mpcl.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpcl.service.SellerMpClGoodsDetailInfoCowayPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpClGoodsDetailInfoCowayPopController")
public class SellerMpClGoodsDetailInfoCowayPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpClGoodsDetailInfoCowayPopController.class);

	@Autowired
	private SellerMpClGoodsDetailInfoCowayPopService sellerMpClGoodsDetailInfoCowayPopService;
	
	/**
	 * 품목상세정보  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpcl/getSellerMpClGoodsDetailInfoCowayPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpClGoodsDetailInfoCowayPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpcl/getSellerMpClGoodsDetailInfoCowayPop.do 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _HdData = sellerMpClGoodsDetailInfoCowayPopService.getHdList(pMap);
		List<Map<String, String>> _DtData = sellerMpClGoodsDetailInfoCowayPopService.getDtList(pMap);
		pModel.addAttribute("hdData", CommonUtil.getListNvl(_HdData));
		pModel.addAttribute("dtData", CommonUtil.getListNvl(_DtData));
		return "common/popup/mpcl/sellerMpClGoodsDetailInfoCowayPop";
	}	 
	
}
