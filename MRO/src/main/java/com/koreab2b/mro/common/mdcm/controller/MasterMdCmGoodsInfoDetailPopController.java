package com.koreab2b.mro.common.mdcm.controller;

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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmGoodsInfoDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmGoodsInfoDetailPopController")
public class MasterMdCmGoodsInfoDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmGoodsInfoDetailPopController.class);

	@Autowired
	private MasterMdCmGoodsInfoDetailPopService masterMdCmGoodsInfoDetailPopService;
	
	/**
	 * 품목정보상세  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmGoodsInfoDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmGoodsInfoDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmGoodsInfoDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCmGoodsInfoDetailPopService.getList(pMap); 
		List<Map<String, String>> _data2 = masterMdCmGoodsInfoDetailPopService.getList2(pMap);
		List<Map<String, String>> _data3 = masterMdCmGoodsInfoDetailPopService.getList3(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("data2", CommonUtil.getListNvl(_data2));
		pModel.addAttribute("data3", CommonUtil.getListNvl(_data3));
		return "common/popup/mdcm/masterMdCmGoodsInfoDetailPop";
	}	 
	
}
